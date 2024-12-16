/mob/living/carbon
	blood_volume = BLOOD_VOLUME_GENERIC

/mob/living/carbon/Initialize(mapload)
	. = ..()
	create_reagents(1000)
	assign_bodypart_ownership()
	update_body_parts() //to update the carbon's new bodyparts appearance
	GLOB.carbon_list += src

/mob/living/carbon/Destroy()
	//This must be done first, so the mob ghosts correctly before DNA etc is nulled
	. =  ..()

	QDEL_LIST(hand_bodyparts)
	QDEL_LIST(internal_organs)
	QDEL_LIST(stomach_contents)//Yogs -- Yogs vorecode
	QDEL_LIST(bodyparts)
	QDEL_LIST(implants)
	for(var/wound in all_wounds) // these LAZYREMOVE themselves when deleted so no need to remove the list here
		qdel(wound)
	for(var/scar in all_scars)
		qdel(scar)
	remove_from_all_data_huds()
	QDEL_NULL(dna)
	GLOB.carbon_list -= src

/mob/living/carbon/perform_hand_swap(held_index)
	. = ..()
	if(!.)
		return

	if(!held_index)
		held_index = (active_hand_index % held_items.len)+1

	if(!isnum(held_index))
		CRASH("You passed [held_index] into swap_hand instead of a number. WTF man")

	var/oindex = active_hand_index
	active_hand_index = held_index
	if(hud_used)
		var/atom/movable/screen/inventory/hand/H
		H = hud_used.hand_slots["[oindex]"]
		if(H)
			H.update_appearance(UPDATE_ICON)
		H = hud_used.hand_slots["[held_index]"]
		if(H)
			H.update_appearance(UPDATE_ICON)


/mob/living/carbon/activate_hand(selhand) //l/r OR 1-held_items.len
	if(!selhand)
		selhand = (active_hand_index % held_items.len)+1

	if(istext(selhand))
		selhand = lowertext(selhand)
		if(selhand == "right" || selhand == "r")
			selhand = 2
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != active_hand_index)
		swap_hand(selhand)
	else
		mode() // Activate held item

/mob/living/carbon/attackby(obj/item/I, mob/living/user, params)
	// Fun situation, needing surgery code to be at the /mob/living level but needing it to happen before wound code so you can actualy do the wound surgeries
	for(var/datum/surgery/S in surgeries)
		if(S.location != user.zone_selected)
			continue
		if((mobility_flags & MOBILITY_STAND) && S.lying_required)
			continue
		if(!S.self_operable && user == src)
			continue
		if(user.combat_mode)
			continue
		return ..()

	if(!all_wounds || user.combat_mode || user == src)
		return ..()

	for(var/i in shuffle(all_wounds))
		var/datum/wound/W = i
		if(W.try_treating(I, user))
			return TRUE

	return ..()

/mob/living/carbon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(mind?.martial_art.handle_throw(hit_atom, src, throwingdatum))
		return
	. = ..()
	if(HAS_TRAIT(src, TRAIT_IMPACTIMMUNE))
		return
	var/hurt = TRUE
	var/extra_speed = 0
	if(throwingdatum.thrower != src)
		extra_speed = min(max(0, throwingdatum.speed - initial(throw_speed)), 3)
	if(istype(throwingdatum, /datum/thrownthing))
		var/datum/thrownthing/D = throwingdatum
		if(iscyborg(D.thrower))
			var/mob/living/silicon/robot/R = D.thrower
			if(!R.emagged)
				hurt = FALSE
	if(hit_atom.density && isturf(hit_atom))
		if(hurt)
			Knockdown(20)
			take_bodypart_damage(10 + 5 * extra_speed, check_armor = TRUE, wound_bonus = extra_speed * 5)
			visible_message(span_danger("[src] crashes into [hit_atom][extra_speed ? " really hard" : ""]!"),\
				span_userdanger("You violently crash into [hit_atom][extra_speed ? " extra hard" : ""]!"))
			playsound(src,'sound/weapons/punch2.ogg',50,1)
	if(iscarbon(hit_atom) && hit_atom != src)
		var/mob/living/carbon/victim = hit_atom
		if(victim.movement_type & FLYING)
			return
		if(hurt)
			victim.take_bodypart_damage(10 + 5 * extra_speed, check_armor = TRUE, wound_bonus = extra_speed * 5)
			take_bodypart_damage(10 + 5 * extra_speed, check_armor = TRUE, wound_bonus = extra_speed * 5)
			victim.Knockdown(20)
			Knockdown(20)
			visible_message(span_danger("[src] crashes into [victim][extra_speed ? " really hard" : ""], knocking them both over!"),\
				span_userdanger("You violently crash into [victim][extra_speed ? " extra hard" : ""]!"))
		playsound(src,'sound/weapons/punch1.ogg',50,1)


//Throwing stuff
/mob/living/carbon/proc/toggle_throw_mode()
	if(stat)
		return
	if(SEND_SIGNAL(src, COMSIG_CARBON_TOGGLE_THROW) & COMSIG_CARBON_BLOCK_TOGGLE_THROW)
		return
	if(ismecha(loc))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.cycle_action.Activate()
			return
	if(in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()


/mob/living/carbon/proc/throw_mode_off()
	in_throw_mode = 0
	if(client && hud_used)
		hud_used.throw_icon.icon_state = "act_throw_off"


/mob/living/carbon/proc/throw_mode_on()
	in_throw_mode = 1
	if(client && hud_used)
		hud_used.throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	SEND_SIGNAL(src, COMSIG_MOB_THROW, target)
	return

/mob/living/carbon/throw_item(atom/target)
	. = ..()
	throw_mode_off()
	if(!target || !isturf(loc))
		return
	if(istype(target, /atom/movable/screen))
		return

	var/atom/movable/thrown_thing
	var/obj/item/I = get_active_held_item()
	var/power_throw = 0

	if(!I)
		if(pulling && isliving(pulling) && grab_state >= GRAB_AGGRESSIVE)
			var/mob/living/throwable_mob = pulling
			if(!throwable_mob.buckled)
				thrown_thing = throwable_mob
				if(pulling && grab_state >= GRAB_NECK)
					power_throw++
				stop_pulling()
				if(HAS_TRAIT(src, TRAIT_PACIFISM))
					to_chat(src, span_notice("You gently let go of [throwable_mob]."))
					return
				if(!synth_check(src, SYNTH_ORGANIC_HARM))
					to_chat(src, span_notice("You gently let go of [throwable_mob]."))
					return
				var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
				var/turf/end_T = get_turf(target)
				if(start_T && end_T)
					log_combat(src, throwable_mob, "thrown", addition="grab from tile in [AREACOORD(start_T)] towards tile at [AREACOORD(end_T)]")

	else if(!CHECK_BITFIELD(I.item_flags, ABSTRACT) && !HAS_TRAIT(I, TRAIT_NODROP))
		thrown_thing = I
		SEND_SIGNAL(thrown_thing, COMSIG_MOVABLE_PRE_DROPTHROW, src)
		dropItemToGround(I, silent = TRUE)

		if(HAS_TRAIT(src, TRAIT_PACIFISM) && I.throwforce)
			to_chat(src, span_notice("You set [I] down gently on the ground."))
			return
		if(!synth_check(src, SYNTH_RESTRICTED_WEAPON))
			to_chat(src, span_notice("You set [I] down gently on the ground."))
			return

	if(thrown_thing)
		if(HAS_TRAIT(src, TRAIT_HULK))
			power_throw++
		visible_message(span_danger("[src] throws [thrown_thing][power_throw ? " really hard!" : "."]"), \
						span_danger("You throw [thrown_thing][power_throw ? " really hard!" : "."]"))
		log_message("has thrown [thrown_thing] [power_throw ? "really hard" : ""]", LOG_ATTACK)
		newtonian_move(get_dir(target, src))
		thrown_thing.safe_throw_at(target, thrown_thing.throw_range, thrown_thing.throw_speed + power_throw, src, null, null, null, move_force)
		changeNext_move(CLICK_CD_RANGE)

/mob/living/carbon/restrained(ignore_grab)
	. = (handcuffed || (!ignore_grab && pulledby && pulledby.grab_state >= GRAB_NECK))

/mob/living/carbon/proc/canBeHandcuffed()
	return 0


/mob/living/carbon/Topic(href, href_list)
	..()
	// Embed Stuff
	if(href_list["embedded_object"] && usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		var/obj/item/bodypart/L = locate(href_list["embedded_limb"]) in bodyparts
		if(!L)
			return
		var/obj/item/I = locate(href_list["embedded_object"]) in L.embedded_objects
		if(!I || I.loc != src) //no item, no limb, or item is not in limb or in the person anymore
			return
		var/time_taken = I.embedding.embedded_unsafe_removal_time*I.w_class
		usr.visible_message(span_warning("[usr] attempts to remove [I] from [usr.p_their()] [L.name]."),span_notice("You attempt to remove [I] from your [L.name]... (It will take [DisplayTimeText(time_taken)].)"))
		if(do_after(usr, time_taken, target = src))
			if(!I || !L || I.loc != src)
				return
			var/damage_amount = I.embedding.embedded_unsafe_removal_pain_multiplier * I.w_class
			L.receive_damage(damage_amount, sharpness = SHARP_EDGED)//It hurts to rip it out, get surgery you dingus.
			if(remove_embedded_object(I, get_turf(src), (damage_amount == 0)))
				usr.put_in_hands(I)
				usr.visible_message("[usr] successfully rips [I] out of [usr.p_their()] [L.name]!", span_notice("You successfully remove [I] from your [L.name]."))
		return

/mob/living/carbon/on_fall()
	. = ..()
	loc.handle_fall(src)//it's loc so it doesn't call the mob's handle_fall which does nothing

/mob/living/carbon/is_muzzled()
	return(istype(src.wear_mask, /obj/item/clothing/mask/muzzle))

/mob/living/carbon/resist_buckle()
	if(restrained())
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		var/buckle_cd = 600
		if(handcuffed)
			var/obj/item/restraints/O = src.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
			buckle_cd = O.breakouttime
		visible_message(span_warning("[src] attempts to unbuckle [p_them()]self!"), \
					span_notice("You attempt to unbuckle yourself... (This will take around [round(buckle_cd/10,1)] second\s, and you need to stay still.)"))
		if(do_after(src, buckle_cd, src, timed_action_flags = IGNORE_HELD_ITEM))
			if(!buckled)
				return
			buckled.user_unbuckle_mob(src,src)
		else
			if(src && buckled)
				to_chat(src, span_warning("You fail to unbuckle yourself!"))
	else
		buckled?.user_unbuckle_mob(src,src) //if we mash it after we get unbuckled before the alert dissapears we'll resist and runtime

/mob/living/carbon/resist_fire()
	adjust_fire_stacks(-5)
	Paralyze(6 SECONDS, TRUE, TRUE)
	spin(32,2)
	visible_message(span_danger("[src] rolls on the floor, trying to put [p_them()]self out!"), \
		span_notice("You stop, drop, and roll!"))
	sleep(3 SECONDS)
	if(fire_stacks <= 0)
		visible_message(span_danger("[src] has successfully extinguished [p_them()]self!"), \
			span_notice("You extinguish yourself."))
		extinguish_mob()
	return

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
	var/type = 0
	if(handcuffed)
		I = handcuffed
		type = 1
	else if(legcuffed)
		I = legcuffed
		type = 2
	if(I)
		if(type == 1)
			changeNext_move(CLICK_CD_BREAKOUT)
			last_special = world.time + CLICK_CD_BREAKOUT
		if(type == 2)
			changeNext_move(CLICK_CD_RANGE)
			last_special = world.time + CLICK_CD_RANGE
		cuff_resist(I)


/mob/living/carbon/proc/cuff_resist(obj/item/I, breakouttime = 1 MINUTES, cuff_break = 0)
	if(I.item_flags & BEING_REMOVED)
		to_chat(src, span_warning("You're already attempting to remove [I]!"))
		return
	I.item_flags |= BEING_REMOVED
	breakouttime = I.breakouttime
	if(!cuff_break)
		visible_message(span_warning("[src] attempts to remove [I]!"))
		to_chat(src, span_notice("You attempt to remove [I]... (This will take around [DisplayTimeText(breakouttime)] and you need to stand still.)"))
		if(do_after(src, breakouttime, src, timed_action_flags = IGNORE_HELD_ITEM))
			clear_cuffs(I, cuff_break)
		else
			to_chat(src, span_warning("You fail to remove [I]!"))

	else if(cuff_break == FAST_CUFFBREAK)
		breakouttime = 5 SECONDS
		visible_message(span_warning("[src] is trying to break [I]!"))
		to_chat(src, span_notice("You attempt to break [I]... (This will take around 5 seconds and you need to stand still.)"))
		if(do_after(src, breakouttime, src, timed_action_flags = IGNORE_HELD_ITEM))
			clear_cuffs(I, cuff_break)
		else
			to_chat(src, span_warning("You fail to break [I]!"))

	else if(cuff_break == INSTANT_CUFFBREAK)
		clear_cuffs(I, cuff_break)
	I.item_flags &= ~BEING_REMOVED

/mob/living/carbon/proc/uncuff()
	var/obj/item/cuff = handcuffed || legcuffed

	if(!cuff) //none? fuck it we ball
		changeNext_move(0)
		return

	if(handcuffed) //clear handcuffs first
		set_handcuffed(null)
		if(buckled?.buckle_requires_restraints)
			buckled.unbuckle_mob(src)
		update_handcuffed()

	if(legcuffed) //then clear legcuffs
		legcuffed = null
		update_inv_legcuffed()

	client?.screen -= cuff //remove overlay

	cuff.forceMove(drop_location())
	cuff.dropped(src) //drop it to the ground

	if(!QDELETED(cuff)) //if it didn't delete on drop, update planes
		cuff.layer = initial(cuff.layer)
		SET_PLANE_IMPLICIT(cuff, initial(cuff.plane))

	changeNext_move(0)

/mob/living/carbon/proc/clear_cuffs(obj/item/cuff, cuff_break, ignore_buckle)
	if(!cuff || !cuff.loc)
		return TRUE //???, we win nonetheless

	if(buckled && !ignore_buckle)
		return FALSE

	visible_message(span_danger("[src] manages to [cuff_break ? "break" : "remove"] [cuff]!"))
	to_chat(src, span_notice("You successfully [cuff_break ? "break" : "remove"] [cuff]."))

	if(cuff_break)
		qdel(cuff)
		return TRUE

	if(cuff == handcuffed)
		handcuffed.forceMove(drop_location())
		handcuffed.dropped(src)
		set_handcuffed(null)
		if(buckled && buckled.buckle_requires_restraints)
			buckled.unbuckle_mob(src)
		update_handcuffed()
		return TRUE

	if(cuff == legcuffed)
		legcuffed.forceMove(drop_location())
		legcuffed.dropped()
		legcuffed = null
		update_inv_legcuffed()
		return TRUE

	dropItemToGround(cuff)
	return TRUE

/mob/living/carbon/get_standard_pixel_y_offset(lying = 0)
	if(lying)
		return -6
	else
		return initial(pixel_y)

/mob/living/carbon/proc/accident(obj/item/I)
	if(!I || (I.item_flags & ABSTRACT) || HAS_TRAIT(I, TRAIT_NODROP))
		return

	dropItemToGround(I)

	var/modifier = 0
	if(HAS_TRAIT(src, TRAIT_CLUMSY))
		modifier -= 40 //Clumsy people are more likely to hit themselves -Honk!

	switch(rand(1,100)+modifier) //91-100=Nothing special happens
		if(-INFINITY to 0) //attack yourself
			INVOKE_ASYNC(I, TYPE_PROC_REF(/obj/item, attack), src, src)
		if(1 to 30) //throw it at yourself
			I.throw_impact(src)
		if(31 to 60) //Throw object in facing direction
			var/turf/target = get_turf(loc)
			var/range = rand(2,I.throw_range)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, dir)
				target = new_turf
				if(new_turf.density)
					break
			I.throw_at(target,I.throw_range,I.throw_speed,src)
		if(61 to 90) //throw it down to the floor
			var/turf/target = get_turf(loc)
			I.safe_throw_at(target,I.throw_range,I.throw_speed,src, force = move_force)

/mob/living/carbon/get_status_tab_items()
	. = ..()
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(vessel)
		. += "Plasma Stored: [vessel.stored_plasma]/[vessel.max_plasma]"
	if(locate(/obj/item/assembly/health) in src)
		. += "Health: [health]"

/mob/living/carbon/attack_ui(slot, params)
	if(!has_hand_for_held_index(active_hand_index))
		return FALSE
	return ..()

/mob/living/carbon/has_mouth()
	for(var/obj/item/bodypart/head/head in bodyparts)
		if(head.mouth)
			return TRUE

/mob/living/carbon/proc/spew_organ(power = 5, amt = 1)
	for(var/i in 1 to amt)
		if(!internal_organs.len)
			break //Guess we're out of organs!
		var/obj/item/organ/guts = pick(internal_organs)
		var/turf/T = get_turf(src)
		guts.Remove(src)
		guts.forceMove(T)
		var/atom/throw_target = get_edge_target_turf(guts, dir)
		guts.throw_at(throw_target, power, 4, src)


/mob/living/carbon/fully_replace_character_name(oldname,newname)
	..()
	if(dna)
		dna.real_name = real_name

/mob/living/carbon/update_mobility()
	. = ..()
	if(!(mobility_flags & MOBILITY_STAND))
		add_movespeed_modifier(MOVESPEED_ID_CARBON_CRAWLING, TRUE, multiplicative_slowdown = CRAWLING_ADD_SLOWDOWN)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CARBON_CRAWLING, TRUE)

//Updates the mob's health from bodyparts and mob damage variables
/mob/living/carbon/updatehealth()
	var/total_burn	= 0
	var/total_brute	= 0
	var/total_stamina = 0
	for(var/X in bodyparts)	//hardcoded to streamline things a bit
		var/obj/item/bodypart/BP = X
		total_brute	+= (BP.brute_dam * BP.body_damage_coeff)
		total_burn	+= (BP.burn_dam * BP.body_damage_coeff)
		total_stamina += (BP.stamina_dam * BP.stam_damage_coeff)
	var/new_health = round(maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute, DAMAGE_PRECISION)
	if(new_health < health && (status_flags & GODMODE))
		return
	health = new_health
	if(!(status_flags & GODMODE))
		staminaloss = round(total_stamina, DAMAGE_PRECISION)
	update_stat()
	update_stamina()
	if(((maxHealth - total_burn) < HEALTH_THRESHOLD_DEAD) && stat == DEAD )
		become_husk(BURN)
	med_hud_set_health()
	if(stat == SOFT_CRIT)
		add_movespeed_modifier(MOVESPEED_ID_CARBON_SOFTCRIT, TRUE, multiplicative_slowdown = SOFTCRIT_ADD_SLOWDOWN)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CARBON_SOFTCRIT, TRUE)

/mob/living/carbon/update_stamina()
	var/stam = getStaminaLoss()
	if(stam > DAMAGE_PRECISION && (maxHealth - stam) <= crit_threshold)
		if(!stat)
			enter_stamcrit()
	else if(HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA))
		REMOVE_TRAIT(src, TRAIT_INCAPACITATED, STAMINA)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, STAMINA)
		REMOVE_TRAIT(src, TRAIT_FLOORED, STAMINA)
		update_mobility()
	else
		return
	update_stamina_hud()

/mob/living/carbon/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		if(SSmapping.level_trait(z, ZTRAIT_NOXRAY))
			set_sight(null)
		else if(is_secret_level(z))
			set_sight(initial(sight))
		else
			set_sight(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_invis_see(SEE_INVISIBLE_OBSERVER)
		return

	var/new_sight = initial(sight)
	see_infrared = initial(see_infrared)
	lighting_cutoff = initial(lighting_cutoff)
	lighting_color_cutoffs = list(lighting_cutoff_red, lighting_cutoff_green, lighting_cutoff_blue)

	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		set_invis_see(eyes.see_invisible)
		new_sight |= eyes.sight_flags
		if(!isnull(eyes.lighting_cutoff))
			lighting_cutoff = eyes.lighting_cutoff
		if(!isnull(eyes.color_cutoffs))
			lighting_color_cutoffs = blend_cutoff_colors(lighting_color_cutoffs, eyes.color_cutoffs)

	for(var/image/I in infra_images)
		if(client)
			client.images.Remove(I)
	infra_images = list()
	remove_client_colour(/datum/client_colour/monochrome_infra)

	if(client.eye && client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return

	if(glasses)
		new_sight |= glasses.vision_flags
		if(glasses.invis_override)
			set_invis_see(glasses.invis_override)
		else
			set_invis_see(min(glasses.invis_view, see_invisible))
		if(!isnull(glasses.lighting_cutoff))
			lighting_cutoff = max(lighting_cutoff, glasses.lighting_cutoff)
		if(length(glasses.color_cutoffs))
			lighting_color_cutoffs = blend_cutoff_colors(lighting_color_cutoffs, glasses.color_cutoffs)

	if(HAS_TRAIT(src, TRAIT_INFRARED_VISION))
		add_client_colour(/datum/client_colour/monochrome_infra)
		var/image/A = null
		see_infrared = TRUE
		lighting_cutoff = max(lighting_cutoff, 10)

		if(client)
			for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
				if(H == src)
					continue
				A = image('icons/mob/simple_human.dmi', H, "fullwhite")
				A.add_overlay(emissive_appearance('icons/mob/simple_human.dmi', "fullwhite", H))
				A.name = "white haze"
				A.override = 1
				infra_images |= A
				client.images |= A

	if(HAS_TRAIT(src, TRAIT_TRUE_NIGHT_VISION))
		lighting_cutoff = max(lighting_cutoff, LIGHTING_CUTOFF_HIGH)

	if(HAS_TRAIT(src, TRAIT_MESON_VISION))
		new_sight |= SEE_TURFS
		lighting_cutoff = max(lighting_cutoff, LIGHTING_CUTOFF_MEDIUM)

	if(HAS_TRAIT(src, TRAIT_THERMAL_VISION))
		new_sight |= SEE_MOBS
		lighting_cutoff = max(lighting_cutoff, LIGHTING_CUTOFF_MEDIUM)

	if(HAS_TRAIT(src, TRAIT_XRAY_VISION))
		new_sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS

	if(see_override)
		set_invis_see(see_override)

	if(SSmapping.level_trait(z, ZTRAIT_NOXRAY))
		new_sight = NONE

	set_sight(new_sight)
	return ..()

/mob/living/carbon/update_stamina_hud(shown_stamina_amount)
	if(!client || !hud_used?.stamina)
		return
	if(stat == DEAD || IsStun() || IsParalyzed() || IsImmobilized() || IsKnockdown() || IsFrozen())
		hud_used.stamina.icon_state = "stamina6"
	else
		if(shown_stamina_amount == null)
			shown_stamina_amount = health - getStaminaLoss() - crit_threshold
		if(shown_stamina_amount >= health)
			hud_used.stamina.icon_state = "stamina0"
		else if(shown_stamina_amount > health*0.8)
			hud_used.stamina.icon_state = "stamina1"
		else if(shown_stamina_amount > health*0.6)
			hud_used.stamina.icon_state = "stamina2"
		else if(shown_stamina_amount > health*0.4)
			hud_used.stamina.icon_state = "stamina3"
		else if(shown_stamina_amount > health*0.2)
			hud_used.stamina.icon_state = "stamina4"
		else if(shown_stamina_amount > 0)
			hud_used.stamina.icon_state = "stamina5"
		else
			hud_used.stamina.icon_state = "stamina6"


//to recalculate and update the mob's total tint from tinted equipment it's wearing.
/mob/living/carbon/proc/update_tint()
	if(!GLOB.tinted_weldhelh)
		return
	tinttotal = get_total_tint()
	if(tinttotal >= TINT_BLIND)
		become_blind(EYES_COVERED)
	else if(tinttotal >= TINT_DARKENED)
		cure_blind(EYES_COVERED)
		overlay_fullscreen("tint", /atom/movable/screen/fullscreen/impaired, 2)
	else
		cure_blind(EYES_COVERED)
		clear_fullscreen("tint", 0)

/mob/living/carbon/proc/get_total_tint()
	. = 0
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/HT = head
		. += HT.tint
	if(wear_mask)
		. += wear_mask.tint

	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(E)
		. += E.tint

	else
		. += INFINITY

// permeability: now slightly more sane and probably functional!
/mob/living/carbon/get_permeability(def_zone, linear = FALSE)
	if(def_zone)
		if(!can_inject(target_zone = def_zone))
			return 0
		if(getarmor(def_zone, BIO) >= 100)
			return 0
		var/permeability = linear ? (100 - getarmor(def_zone, BIO)) / 100 : 1 / (2**(getarmor(def_zone, BIO) / 15))
		if(permeability <= 0.01)
			return 0
		return permeability

	var/total_bodyparts = 0
	var/total_permeability = 0
	for(var/obj/item/bodypart/BP in bodyparts)
		total_bodyparts++
		if(!can_inject(target_zone = BP.body_zone))
			continue
		var/protection = getarmor(BP.body_zone, BIO)
		if(protection < 100)
			total_permeability += linear ? (100 - protection) / 100 : 1 / (2**(protection / 15)) // every 15 bio armor reduces permeability by half (15 is 0.5, 30 is 0.25, 60 is 0.0625, etc) unless otherwise specified to use a linear calculation

	var/permeability = clamp(total_permeability / total_bodyparts, 0, 1)
	if(permeability <= 0.01)
		return 0

	return permeability

//this handles hud updates
/mob/living/carbon/update_damage_hud()

	if(!client)
		return

	if(health <= crit_threshold && !(HAS_TRAIT(src, TRAIT_NOHARDCRIT) && HAS_TRAIT(src, TRAIT_NOSOFTCRIT)))//if crit is entirely disabled, no crit overlay at all
		var/severity = 0
		switch(health)
			if(-20 to -10)
				severity = 1
			if(-30 to -20)
				severity = 2
			if(-40 to -30)
				severity = 3
			if(-50 to -40)
				severity = 4
			if(-50 to -40)
				severity = 5
			if(-60 to -50)
				severity = 6
			if(-70 to -60)
				severity = 7
			if(-90 to -70)
				severity = 8
			if(-95 to -90)
				severity = 9
			if(-INFINITY to -95)
				severity = 10
		if(!InFullCritical() && !HAS_TRAIT(src, TRAIT_NOSOFTCRIT))//no soft crit blind for those immune to soft crit
			var/visionseverity = 4
			switch(health)
				if(-8 to -4)
					visionseverity = 5
				if(-12 to -8)
					visionseverity = 6
				if(-16 to -12)
					visionseverity = 7
				if(-20 to -16)
					visionseverity = 8
				if(-24 to -20)
					visionseverity = 9
				if(-INFINITY to -24)
					visionseverity = 10
			overlay_fullscreen("critvision", /atom/movable/screen/fullscreen/crit/vision, visionseverity)
		else
			clear_fullscreen("critvision")
		overlay_fullscreen("crit", /atom/movable/screen/fullscreen/crit, severity)
	else
		clear_fullscreen("crit")
		clear_fullscreen("critvision")

	//Oxygen damage overlay
	if(oxyloss)
		var/severity = 0
		switch(oxyloss)
			if(10 to 20)
				severity = 1
			if(20 to 25)
				severity = 2
			if(25 to 30)
				severity = 3
			if(30 to 35)
				severity = 4
			if(35 to 40)
				severity = 5
			if(40 to 45)
				severity = 6
			if(45 to INFINITY)
				severity = 7
		overlay_fullscreen("oxy", /atom/movable/screen/fullscreen/oxy, severity)
	else
		clear_fullscreen("oxy")

	//Fire and Brute damage overlay (BSSR)
	var/hurtdamage = getBruteLoss() + getFireLoss() + damageoverlaytemp
	if(hurtdamage)
		var/severity = 0
		switch(hurtdamage)
			if(5 to 15)
				severity = 1
			if(15 to 30)
				severity = 2
			if(30 to 45)
				severity = 3
			if(45 to 70)
				severity = 4
			if(70 to 85)
				severity = 5
			if(85 to INFINITY)
				severity = 6
		overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
	else
		clear_fullscreen("brute")

/mob/living/carbon/update_health_hud(shown_health_amount)
	if(!client || !hud_used)
		return
	if(hud_used.healths)
		if(stat != DEAD && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
			. = 1
			if(shown_health_amount == null)
				shown_health_amount = health
			if(shown_health_amount >= maxHealth)
				hud_used.healths.icon_state = "health0"
			else if(shown_health_amount > maxHealth*0.8)
				hud_used.healths.icon_state = "health1"
			else if(shown_health_amount > maxHealth*0.6)
				hud_used.healths.icon_state = "health2"
			else if(shown_health_amount > maxHealth*0.4)
				hud_used.healths.icon_state = "health3"
			else if(shown_health_amount > maxHealth*0.2)
				hud_used.healths.icon_state = "health4"
			else if(shown_health_amount > 0)
				hud_used.healths.icon_state = "health5"
			else
				hud_used.healths.icon_state = "health6"
		else
			hud_used.healths.icon_state = "health7"

/mob/living/carbon/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		// If player has holoparasites, ignore TRAIT_NODEATH
		if( health <= HEALTH_THRESHOLD_DEAD && ( !HAS_TRAIT(src, TRAIT_NODEATH) || LAZYLEN(hasparasites()) ) )
			death()
			return
		if(IsUnconscious() || IsSleeping() || getOxyLoss() > 50 || (HAS_TRAIT(src, TRAIT_DEATHCOMA)) || (health <= HEALTH_THRESHOLD_FULLCRIT && !HAS_TRAIT(src, TRAIT_NOHARDCRIT)))
			set_stat(UNCONSCIOUS)
			blind_eyes(1)
			if(CONFIG_GET(flag/near_death_experience) && health <= HEALTH_THRESHOLD_NEARDEATH && !HAS_TRAIT(src, TRAIT_NODEATH))
				ADD_TRAIT(src, TRAIT_SIXTHSENSE, "near-death")
			else
				REMOVE_TRAIT(src, TRAIT_SIXTHSENSE, "near-death")
		else
			if(health <= crit_threshold && !HAS_TRAIT(src, TRAIT_NOSOFTCRIT))
				set_stat(SOFT_CRIT)
			else
				set_stat(CONSCIOUS)
			adjust_blindness(-1)
			REMOVE_TRAIT(src, TRAIT_SIXTHSENSE, "near-death")
		update_mobility()
	update_damage_hud()
	update_health_hud()
	update_stamina_hud()
	med_hud_set_health()
	med_hud_set_status()

//called when we get cuffed/uncuffed
/mob/living/carbon/proc/update_handcuffed()
	if(handcuffed)
		drop_all_held_items()
		stop_pulling()
		throw_alert("handcuffed", /atom/movable/screen/alert/restrained/handcuffed, new_master = src.handcuffed)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "handcuffed", /datum/mood_event/handcuffed)
	else
		clear_alert("handcuffed")
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "handcuffed")
	update_mob_action_buttons() //some of our action buttons might be unusable when we're handcuffed.
	update_inv_handcuffed()
	update_hud_handcuffed()
	update_mobility()

/mob/living/carbon/fully_heal(admin_revive = FALSE)
	if(reagents)
		reagents.clear_reagents()
	for(var/O in internal_organs)
		var/obj/item/organ/organ = O
		organ.setOrganDamage(0)
	var/obj/item/organ/brain/B = getorgan(/obj/item/organ/brain)
	if(B)
		B.brain_death = FALSE
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(D.severity != DISEASE_SEVERITY_POSITIVE)
			D.cure(FALSE)
	for(var/thing in all_wounds)
		var/datum/wound/W = thing
		W.remove_wound()
	if(admin_revive)
		regenerate_limbs()
		regenerate_organs()
		set_handcuffed(initial(handcuffed))
		for(var/obj/item/restraints/R in contents) //actually remove cuffs from inventory
			qdel(R)
		update_handcuffed()
		if(reagents)
			reagents.addiction_list = list()
	cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)
	..()
	// heal ears after healing traits, since ears check TRAIT_DEAF trait
	// when healing.
	restoreEars()

/mob/living/carbon/can_be_revived()
	. = ..()
	if(!getorgan(/obj/item/organ/brain) && (!mind || !mind.has_antag_datum(/datum/antagonist/changeling)))
		return 0

/mob/living/carbon/proc/can_defib(careAboutGhost = TRUE) //yogs start
	if(suiciding || hellbound || HAS_TRAIT(src, TRAIT_HUSK)) //can't revive
		return FALSE
	if((world.time - timeofdeath) > DEFIB_TIME_LIMIT) //too late
		return FALSE
	if((getBruteLoss() >= MAX_REVIVE_BRUTE_DAMAGE) || (getFireLoss() >= MAX_REVIVE_FIRE_DAMAGE) || !can_be_revived()) //too damaged
		return FALSE
	if(!getorgan(/obj/item/organ/heart)) //what are we even shocking
		return FALSE
	var/obj/item/organ/brain/BR = getorgan(/obj/item/organ/brain)
	if(QDELETED(BR) || BR.brain_death || BR.organ_flags & ORGAN_FAILING || BR.suicided)
		return FALSE
	if(careAboutGhost && get_ghost())
		return FALSE
	return TRUE //yogs end

/mob/living/carbon/harvest(mob/living/user)
	if(QDELETED(src))
		return
	var/organs_amt = 0
	for(var/X in internal_organs)
		var/obj/item/organ/O = X
		if(prob(50))
			organs_amt++
			O.Remove(src)
			O.forceMove(drop_location())
	if(organs_amt)
		to_chat(user, span_notice("You retrieve some of [src]\'s internal organs!"))

/mob/living/carbon/extinguish_mob()
	for(var/X in get_equipped_items())
		var/obj/item/I = X
		I.acid_level = 0 //washes off the acid on our clothes
		I.extinguish() //extinguishes our clothes
	..()

/mob/living/carbon/fakefire(fire_icon = "Generic_mob_burning")
	var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
	new_fire_overlay.appearance_flags = RESET_COLOR
	overlays_standing[FIRE_LAYER] = new_fire_overlay
	apply_overlay(FIRE_LAYER)

/mob/living/carbon/fakefireextinguish()
	remove_overlay(FIRE_LAYER)

/mob/living/carbon/proc/create_bodyparts()
	var/l_arm_index_next = -1
	var/r_arm_index_next = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = new X()
		O.set_owner(src)
		bodyparts.Remove(X)
		bodyparts.Add(O)
		if(O.body_part & ARM_LEFT)
			l_arm_index_next += 2
			O.held_index = l_arm_index_next //1, 3, 5, 7...
			hand_bodyparts += O
		else if(O.body_part & ARM_RIGHT)
			r_arm_index_next += 2
			O.held_index = r_arm_index_next //2, 4, 6, 8...
			hand_bodyparts += O

/mob/living/carbon/do_after_coefficent()
	. = ..()
	var/datum/component/mood/mood = GetComponent(/datum/component/mood) //Currently, only carbons or higher use mood, move this once that changes.
	if(mood)
		switch(mood.sanity) //Alters do_after delay based on how sane you are
			if(-INFINITY to SANITY_DISTURBED)
				. *= 1.25
			if(SANITY_NEUTRAL to INFINITY)
				. *= 0.90

	for(var/datum/status_effect/S as anything in status_effects)
		. *= S.interact_speed_modifier()

/mob/living/carbon/proc/create_internal_organs()
	for(var/X in internal_organs)
		var/obj/item/organ/I = X
		I.Insert(src)

/mob/living/carbon/proc/get_footprint_sprite()
	return FOOTPRINT_SPRITE_PAWS

/mob/living/carbon/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_SEPERATOR
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_BODYPART, "Modify bodypart")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_ORGANS, "Modify organs")
	VV_DROPDOWN_OPTION(VV_HK_HALLUCINATION, "Hallucinate")
	VV_DROPDOWN_OPTION(VV_HK_MARTIAL_ART, "Give Martial Arts")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_TRAUMA, "Give Brain Trauma")
	VV_DROPDOWN_OPTION(VV_HK_CURE_TRAUMA, "Cure Brain Traumas")

/mob/living/carbon/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MODIFY_BODYPART])
		if(!check_rights(R_SPAWN))
			return
		var/edit_action = input(usr, "What would you like to do?","Modify Body Part") as null|anything in list("add","remove", "augment")
		if(!edit_action)
			return
		var/list/limb_list = list()
		if(edit_action == "remove" || edit_action == "augment")
			for(var/obj/item/bodypart/B in bodyparts)
				limb_list += B.body_zone
			if(edit_action == "remove")
				limb_list -= BODY_ZONE_CHEST
		else
			limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/obj/item/bodypart/B in bodyparts)
				limb_list -= B.body_zone
		var/result = input(usr, "Please choose which body part to [edit_action]","[capitalize(edit_action)] Body Part") as null|anything in sortList(limb_list)
		if(result)
			var/obj/item/bodypart/BP = get_bodypart(result)
			switch(edit_action)
				if("remove")
					if(BP)
						BP.drop_limb()
					else
						to_chat(usr, span_boldwarning("[src] doesn't have such bodypart."))
				if("add")
					if(BP)
						to_chat(usr, span_boldwarning("[src] already has such bodypart."))
					else
						if(!regenerate_limb(result))
							to_chat(usr, span_boldwarning("[src] cannot have such bodypart."))
				if("augment")
					if(ishuman(src))
						if(BP)
							BP.change_bodypart_status(BODYPART_ROBOTIC, TRUE, TRUE)
						else
							to_chat(usr, span_boldwarning("[src] doesn't have such bodypart."))
					else
						to_chat(usr, span_boldwarning("Only humans can be augmented."))
		admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [src]")
	if(href_list[VV_HK_MODIFY_ORGANS])
		if(!check_rights(R_DEBUG))
			return
		usr.client.manipulate_organs(src)
	if(href_list[VV_HK_MARTIAL_ART])
		if(!check_rights(R_DEBUG))
			return
		var/list/artpaths = subtypesof(/datum/martial_art)
		var/list/artnames = list()
		for(var/i in artpaths)
			var/datum/martial_art/M = i
			artnames[initial(M.name)] = M
		var/result = input(usr, "Choose the martial art to teach","JUDO CHOP") as null|anything in sortList(artnames, /proc/cmp_typepaths_asc)
		if(!usr)
			return
		if(QDELETED(src))
			to_chat(usr, span_boldwarning("Mob doesn't exist anymore."))
			return
		if(result)
			var/chosenart = artnames[result]
			var/datum/martial_art/MA = new chosenart
			MA.teach(src)
			log_admin("[key_name(usr)] has taught [MA] to [key_name(src)].")
			message_admins(span_notice("[key_name_admin(usr)] has taught [MA] to [key_name_admin(src)]."))
	if(href_list[VV_HK_GIVE_TRAUMA])
		if(!check_rights(R_DEBUG))
			return
		var/list/traumas = subtypesof(/datum/brain_trauma)
		var/result = input(usr, "Choose the brain trauma to apply","Traumatize") as null|anything in sortList(traumas, /proc/cmp_typepaths_asc)
		if(!usr)
			return
		if(QDELETED(src))
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!result)
			return
		var/datum/brain_trauma/BT = gain_trauma(result)
		if(BT)
			log_admin("[key_name(usr)] has traumatized [key_name(src)] with [BT.name]")
			message_admins(span_notice("[key_name_admin(usr)] has traumatized [key_name_admin(src)] with [BT.name]."))
	if(href_list[VV_HK_CURE_TRAUMA])
		if(!check_rights(R_DEBUG))
			return
		cure_all_traumas(TRAUMA_RESILIENCE_ABSOLUTE)
		log_admin("[key_name(usr)] has cured all traumas from [key_name(src)].")
		message_admins(span_notice("[key_name_admin(usr)] has cured all traumas from [key_name_admin(src)]."))
	if(href_list[VV_HK_HALLUCINATION])
		if(!check_rights(R_DEBUG))
			return
		var/list/hallucinations = subtypesof(/datum/hallucination)
		var/result = input(usr, "Choose the hallucination to apply","Send Hallucination") as null|anything in sortList(hallucinations, /proc/cmp_typepaths_asc)
		if(!usr)
			return
		if(QDELETED(src))
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(result)
			new result(src, TRUE)

/mob/living/carbon/can_resist()
	return bodyparts.len > 2 && ..()

/mob/living/carbon/proc/hypnosis_vulnerable()
	if(HAS_TRAIT(src, TRAIT_MINDSHIELD))
		return FALSE
	if(has_status_effect(/datum/status_effect/hallucination))
		return TRUE
	if(IsSleeping())
		return TRUE
	if(HAS_TRAIT(src, TRAIT_DUMB))
		return TRUE
	var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
	if(mood)
		if(mood.sanity < SANITY_UNSTABLE)
			return TRUE

/mob/living/carbon/verb/giveitem(mob/living/carbon/A as mob in range(1))
	set name = "Give"
	set category = "IC"
	if(!iscarbon(src))
		to_chat(src, span_warning("You can't give items!"))
		return
	if(A && A != src && get_dist(src, A) < 2)
		var/mob/living/carbon/C = src
		C.give()

/// Returns whether or not the carbon should be able to be shocked
/mob/living/carbon/proc/should_electrocute(power_source)
	if (ismecha(loc))
		return FALSE

	if (wearing_shock_proof_gloves())
		return FALSE

	if(!get_powernet_info_from_source(power_source))
		return FALSE

	if (HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE

	return TRUE

/// Returns if the carbon is wearing shock proof gloves
/mob/living/carbon/proc/wearing_shock_proof_gloves()
	return gloves?.armor.getRating(ELECTRIC) >= 100

/mob/living/carbon/wash(clean_types)
	. = ..()
	// Wash equipped stuff that cannot be covered
	for(var/i in held_items)
		var/obj/item/held_thing = i
		if(!held_thing)
			return

		if(held_thing.wash(clean_types))
			. = TRUE
	if(back?.wash(clean_types))
		update_inv_back(0)
		. = TRUE
	if(head?.wash(clean_types))
		update_inv_head()
		. = TRUE
		// Check and wash stuff that can be covered
	var/list/obscured = check_obscured_slots()

	// If the eyes are covered by anything but glasses, that thing will be covering any potential glasses as well.
	if(glasses && is_eyes_covered(FALSE, TRUE, TRUE) && glasses.wash(clean_types))
		update_inv_glasses()
		. = TRUE
	if(wear_mask && !(ITEM_SLOT_MASK in obscured) && wear_mask.wash(clean_types))
		update_inv_wear_mask()
		. = TRUE
	if(ears && !(ITEM_SLOT_EARS in obscured) && ears.wash(clean_types))
		update_inv_ears()
		. = TRUE
	if(wear_neck && !(ITEM_SLOT_NECK in obscured) && wear_neck.wash(clean_types))
		update_inv_neck()
		. = TRUE
	if(shoes && !(ITEM_SLOT_FEET in obscured) && shoes.wash(clean_types))
		update_inv_shoes()
		. = TRUE
	if(gloves && !(ITEM_SLOT_GLOVES in obscured) && gloves.wash(clean_types))
		update_inv_gloves()
		. = TRUE

/// if any of our bodyparts are bleeding
/mob/living/carbon/proc/is_bleeding()
	for(var/i in bodyparts)
		var/obj/item/bodypart/BP = i
		if(BP.get_bleed_rate())
			return TRUE

/// get our total bleedrate
/mob/living/carbon/proc/get_total_bleed_rate()
	var/total_bleed_rate = 0
	for(var/i in bodyparts)
		var/obj/item/bodypart/BP = i
		total_bleed_rate += BP.get_bleed_rate()

	return total_bleed_rate

/mob/living/carbon/ZImpactDamage(turf/impacted_turf, levels, impact_flags = NONE)
	impact_flags |= SEND_SIGNAL(src, COMSIG_LIVING_Z_IMPACT, levels, impacted_turf)
	if(impact_flags & ZIMPACT_CANCEL_DAMAGE)
		return impact_flags
	Knockdown(levels * 3 SECONDS)
	if(!(impact_flags & ZIMPACT_NO_MESSAGE))
		visible_message(
			span_danger("[src] crashes into [impacted_turf] with a sickening noise!"),
			span_userdanger("You crash into [impacted_turf] with a sickening noise!"),
		)
	var/obj/item/bodypart/damaged_limb = pick(bodyparts)
	if(!damaged_limb)
		CRASH("[src] has no bodyparts!")
	var/fall_damage = (levels * 5) ** 1.5
	if(damaged_limb.can_dismember() && prob(fall_damage * 3) && HAS_TRAIT(src, TRAIT_EASYDISMEMBER))
		damaged_limb.dismember(BRUTE, FALSE)
		apply_damage(fall_damage, BRUTE, BODY_ZONE_CHEST, sharpness = SHARP_NONE)
	else
		damaged_limb.receive_damage(fall_damage, 0, 0, getarmor(damaged_limb.body_zone, BOMB), TRUE, wound_bonus = 30, sharpness = SHARP_NONE)

/**
  * generate_fake_scars()- for when you want to scar someone, but you don't want to hurt them first. These scars don't count for temporal scarring (hence, fake)
  *
  * If you want a specific wound scar, pass that wound type as the second arg, otherwise you can pass a list like WOUND_LIST_SLASH to generate a random cut scar.
  *
  * Arguments:
  * * num_scars- A number for how many scars you want to add
  * * forced_type- Which wound or category of wounds you want to choose from, WOUND_LIST_BLUNT, WOUND_LIST_SLASH, or WOUND_LIST_BURN (or some combination). If passed a list, picks randomly from the listed wounds. Defaults to all 3 types
  */
/mob/living/carbon/proc/generate_fake_scars(num_scars, forced_type)
	for(var/i in 1 to num_scars)
		var/datum/scar/scaries = new
		var/obj/item/bodypart/scar_part = pick(bodyparts)

		var/wound_type
		if(forced_type)
			if(islist(forced_type))
				wound_type = pick(forced_type)
			else
				wound_type = forced_type
		else
			wound_type = pick(GLOB.global_all_wound_types)

		var/datum/wound/phantom_wound = new wound_type
		scaries.generate(scar_part, phantom_wound)
		scaries.fake = TRUE
		QDEL_NULL(phantom_wound)

/mob/living/carbon/is_face_visible()
	return ..() && !(wear_mask?.flags_inv & HIDEFACE) && !(head?.flags_inv & HIDEFACE) // Yogs -- you can no longer make eye contact with a cigarette butt that contains a tator

/**
  * get_biological_state is a helper used to see what kind of wounds we roll for. By default we just assume carbons (read:monkeys) are flesh and bone, but humans rely on their species datums
  *
  * go look at the species def for more info [/datum/species/proc/get_biological_state]
  */
/mob/living/carbon/proc/get_biological_state()
	return BIO_FLESH_BONE

/mob/living/carbon/proc/eat_text(fullness, eatverb, obj/O, mob/living/carbon/C, mob/user)
	return dna?.species.eat_text(fullness, eatverb, O, C, user)

/mob/living/carbon/proc/force_eat_text(fullness, obj/O, mob/living/carbon/C, mob/user)
	return dna?.species.force_eat_text(fullness, O, C, user)

/mob/living/carbon/proc/drink_text(obj/O, mob/living/carbon/C, mob/user)
	return dna?.species.drink_text(O, C, user)

/mob/living/carbon/proc/force_drink_text(obj/O, mob/living/carbon/C, mob/user)
	return dna?.species.force_drink_text(O, C, user)

/**
 * This proc is a helper for spraying blood for things like slashing/piercing wounds and dismemberment.
 *
 * The strength of the splatter in the second argument determines how much it can dirty and how far it can go
 *
 * Arguments:
 * * splatter_direction: Which direction the blood is flying
 * * splatter_strength: How many tiles it can go, and how many items it can pass over and dirty
 */
/mob/living/carbon/proc/spray_blood(splatter_direction, splatter_strength = 3)
	if(!isturf(loc))
		return
	var/splatter_color = null
	if(dna?.blood_type)
		splatter_color = dna.blood_type.color
	else
		var/blood_id = get_blood_id()
		if(blood_id != /datum/reagent/blood)//special blood substance
			var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
			splatter_color = R.color
	var/obj/effect/decal/cleanable/blood/hitsplatter/our_splatter = new(loc, splatter_strength, splatter_color)
	our_splatter.add_blood_DNA(return_blood_DNA())
	our_splatter.blood_dna_info = get_blood_dna_list()
	var/turf/targ = get_ranged_target_turf(src, splatter_direction, splatter_strength)
	INVOKE_ASYNC(our_splatter, TYPE_PROC_REF(/obj/effect/decal/cleanable/blood/hitsplatter, fly_towards), targ, splatter_strength)

/**
 * Clears dynamic stamina regeneration on all limbs, typically used for continuous buildup like chems.
 *
 * Make sure it's used AFTER stamina damage is applied.
 */
/mob/living/carbon/clear_stamina_regen()
	for(var/obj/item/bodypart/B in bodyparts)
		B.stamina_cache = list()
