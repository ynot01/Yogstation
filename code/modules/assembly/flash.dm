#define CONFUSION_STACK_MAX_MULTIPLIER 2
/obj/item/assembly/flash
	name = "flash"
	desc = "A powerful and versatile flashbulb device, with applications ranging from disorienting attackers to acting as visual receptors in robot production."
	icon_state = "flash"
	item_state = "flashtool"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	materials = list(/datum/material/iron = 300, /datum/material/glass = 300)
	light_system = MOVABLE_LIGHT //Used as a flash here.
	light_range = FLASH_LIGHT_RANGE
	light_color = COLOR_WHITE
	light_power = FLASH_LIGHT_POWER
	light_on = FALSE
	fryable = TRUE
	/// Whether we currently have the flashing overlay.
	var/flashing = FALSE
	///flicked when we flash
	var/flashing_overlay = "flash-f"
	///Number of times the flash has been used.
	var/times_used = 0
	///Is the flash burnt out?
	var/burnt_out = FALSE
	///reduction to burnout % chance
	var/burnout_resistance = 0
	///last world.time this flash was used
	var/last_used = 0
	///self explanatory, cooldown on flash use
	var/cooldown = 0
	///last time we actually flashed
	var/last_trigger = 0
	///can we convert people to revolution
	var/can_convert = FALSE
	///can we stun silicons
	var/borgstun = TRUE

/obj/item/assembly/flash/suicide_act(mob/living/user)
	if(burnt_out)
		user.visible_message(span_suicide("[user] raises \the [src] up to [user.p_their()] eyes and activates it ... but it's burnt out!"))
		return SHAME
	else if(user.eye_blind)
		user.visible_message(span_suicide("[user] raises \the [src] up to [user.p_their()] eyes and activates it ... but [user.p_theyre()] blind!"))
		return SHAME
	user.visible_message(span_suicide("[user] raises \the [src] up to [user.p_their()] eyes and activates it! It looks like [user.p_theyre()] trying to commit suicide!"))
	attack(user,user)
	return FIRELOSS

/obj/item/assembly/flash/update_icon(updates=ALL, flash = FALSE)
	flashing = flash
	. = ..()
	if(burnt_out)
		item_state = "flashburnt"
	if(flash)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/, update_icon)), 5)
	if(holder)
		holder.update_icon(updates)

/obj/item/assembly/flash/update_overlays()
	. = ..()
	attached_overlays = list()
	if(burnt_out)
		. += "flashburnt"
		attached_overlays += "flashburnt"
	if(flashing)
		. += flashing_overlay
		attached_overlays += flashing_overlay

/obj/item/assembly/flash/proc/clown_check(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		flash_carbon(user, user, 15, 0)
		return FALSE
	return TRUE

/obj/item/assembly/flash/proc/burn_out() //Made so you can override it if you want to have an invincible flash from R&D or something.
	if(!burnt_out)
		burnt_out = TRUE
		update_icon(ALL, FALSE)
	if(ismob(loc))
		var/mob/M = loc
		M.visible_message(span_danger("[src] burns out!"),span_userdanger("[src] burns out!"))
	else
		var/turf/T = get_turf(src)
		T.visible_message(span_danger("[src] burns out!"))

/obj/item/assembly/flash/proc/flash_recharge(interval = 10)
	var/deciseconds_passed = world.time - last_used
	for(var/seconds = deciseconds_passed / 10, seconds >= interval, seconds -= interval) //get 1 charge every interval
		times_used--
	last_used = world.time
	times_used = max(0, times_used) //sanity
	if(max(0, prob(times_used * 3) - burnout_resistance)) //The more often it's used in a short span of time the more likely it will burn out
		burn_out()
		return FALSE
	return TRUE

//BYPASS CHECKS ALSO PREVENTS BURNOUT!
/obj/item/assembly/flash/proc/AOE_flash(bypass_checks = FALSE, range = 3, power = 5, targeted = FALSE, mob/user)
	if(!bypass_checks && !try_use_flash())
		return FALSE
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	if(user)
		targets -= user
	for(var/mob/living/carbon/C in targets)
		flash_carbon(C, user, power, targeted, TRUE)
	return TRUE

/obj/item/assembly/flash/proc/get_flash_targets(atom/target_loc, range = 3, override_vision_checks = FALSE)
	if(!target_loc)
		target_loc = loc
	if(override_vision_checks)
		return get_hearers_in_view(range, get_turf(target_loc))
	if(isturf(target_loc) || (ismob(target_loc) && isturf(target_loc.loc)))
		return viewers(range, get_turf(target_loc))
	else
		return typecache_filter_list(target_loc.get_all_contents(), GLOB.typecache_living)

/obj/item/assembly/flash/proc/try_use_flash(mob/user = null)
	if(user && !synth_check(user, SYNTH_RESTRICTED_ITEM))
		return
	if(user && HAS_TRAIT(user, TRAIT_NO_STUN_WEAPONS))
		to_chat(user, span_warning("You can't seem to remember how this works!"))
		return FALSE
	if(burnt_out || (world.time < last_trigger + cooldown))
		return FALSE
	last_trigger = world.time
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	set_light_on(TRUE)
	addtimer(CALLBACK(src, PROC_REF(flash_end)), FLASH_LIGHT_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)
	times_used++
	flash_recharge()
	update_icon(ALL, flash = TRUE)
	if(user && !clown_check(user))
		return FALSE
	return TRUE

/obj/item/assembly/flash/proc/flash_end()
	set_light_on(FALSE)

/obj/item/assembly/flash/proc/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(ismob(user))
		log_combat(user, M, "[targeted? "flashed(targeted)" : "flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "flashed(targeted)" : "flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_disarm("[src] emits a blinding light!"))
	if(targeted)
		if(M.flash_act(1, 1))
			M.set_confusion_if_lower(power * CONFUSION_STACK_MAX_MULTIPLIER SECONDS)
			if(ismob(user))
				terrible_conversion_proc(M, user)
				visible_message(span_disarm("[user] blinds [M] with the flash!"))
				to_chat(user, span_danger("You blind [M] with the flash!"))
				to_chat(M, span_userdanger("[user] blinds you with the flash!"))
				for(var/datum/brain_trauma/trauma in M.get_traumas())
					trauma.on_flash(user, M)
			else
				to_chat(M, span_userdanger("You are blinded by [src]!"))
			if(M.IsParalyzed() || M.IsKnockdown())
				M.Knockdown(rand(20,30))
			else
				M.Knockdown(rand(80,120))
		else if(ismob(user))
			visible_message(span_disarm("[user] fails to blind [M] with the flash!"))
			to_chat(user, span_warning("You fail to blind [M] with the flash!"))
			to_chat(M, span_danger("[user] fails to blind you with the flash!"))
		else
			to_chat(M, span_danger("[src] fails to blind you!"))
	else
		if(M.flash_act())
			M.set_confusion_if_lower(power * CONFUSION_STACK_MAX_MULTIPLIER SECONDS)

/obj/item/assembly/flash/proc/flash_borg(mob/living/silicon/robot/robot_victim, mob/user)
	log_combat(user, robot_victim, "flashed", src)
	if(!robot_victim.sensor_protection)
		update_icon(ALL, flash = TRUE)
		robot_victim.Paralyze(rand(8 SECONDS,12 SECONDS))
		robot_victim.set_confusion_if_lower(5 SECONDS * CONFUSION_STACK_MAX_MULTIPLIER)
		robot_victim.flash_act(affect_silicon = 1)
		if(ismob(user))
			user.visible_message(span_disarm("[user] overloads [robot_victim]'s sensors with the flash!"), span_danger("You overload [robot_victim]'s sensors with the flash!"))
		return TRUE
	else
		robot_victim.overlay_fullscreen("reducedflash", /atom/movable/screen/fullscreen/flash/static)
		robot_victim.uneq_all()
		robot_victim.stop_pulling()
		robot_victim.break_all_cyborg_slots(TRUE)
		addtimer(CALLBACK(robot_victim, TYPE_PROC_REF(/mob/living/silicon/robot, clear_fullscreen), "reducedflash"), 5 SECONDS)
		addtimer(CALLBACK(robot_victim, TYPE_PROC_REF(/mob/living/silicon/robot, repair_all_cyborg_slots)), 5 SECONDS)
		to_chat(robot_victim, span_danger("Your sensors were momentarily dazzled!"))
		if(ismob(user))
			user.visible_message(span_disarm("[user] overloads [robot_victim]'s sensors with the flash!"), span_danger("You overload [robot_victim]'s sensors with the flash!"))
		return TRUE

/obj/item/assembly/flash/attack(mob/living/M, mob/user)
	if(!try_use_flash(user))
		return FALSE
	if(iscarbon(M))
		flash_carbon(M, user, 5, 1)
		return TRUE
	else if(iscyborg(M) && borgstun)
		flash_borg(M, user)

	user.visible_message(span_disarm("[user] fails to blind [M] with the flash!"), span_warning("You fail to blind [M] with the flash!"))

/obj/item/assembly/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(holder)
		return FALSE
	if(!AOE_flash(FALSE, 3, 5, FALSE, user))
		return FALSE
	to_chat(user, span_danger("[src] emits a blinding light!"))

/obj/item/assembly/flash/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!try_use_flash())
		return
	AOE_flash()
	burn_out()

/obj/item/assembly/flash/activate()//AOE flash on signal received
	if(!..())
		return
	AOE_flash()

/obj/item/assembly/flash/proc/terrible_conversion_proc(mob/living/carbon/H, mob/user)
	if(!can_convert)
		return
	if(H?.stat == DEAD)
		return
	if(!user.mind)
		return
	var/datum/antagonist/rev/head/converter = user.mind.has_antag_datum(/datum/antagonist/rev/head)
	if(!converter)
		return
	if(!H.client)
		to_chat(user, span_warning("This mind is so vacant that it is not susceptible to influence!"))
		return
	if(H.stat != CONSCIOUS)
		to_chat(user, span_warning("They must be conscious before you can convert [H.p_them()]!"))
		return
	if(converter.add_revolutionary(H.mind))
		times_used -- //Flashes less likely to burn out for headrevs when used for conversion
	else
		to_chat(user, span_warning("This mind seems resistant to the flash!"))


/obj/item/assembly/flash/cyborg
	name = "cyborg flash"
	desc = "A powerful and versatile flashbulb device, with applications ranging from disorienting attackers to acting as visual receptors in robot production. This variant is unable to stun cyborgs."
	borgstun = FALSE

/obj/item/assembly/flash/cyborg/attack(mob/living/M, mob/user)
	..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))

/obj/item/assembly/flash/cyborg/attack_self(mob/user)
	..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))

/obj/item/assembly/flash/cyborg/attackby(obj/item/W, mob/user, params)
	return
/obj/item/assembly/flash/cyborg/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/item/assembly/flash/cyborg/combat
	name = "combat cyborg flash"
	desc = "A powerful and versatile flashbulb device, with applications ranging from disorienting attackers to acting as visual receptors in robot production. This variant is able to stun cyborgs."
	borgstun = TRUE

/obj/item/assembly/flash/memorizer
	name = "memorizer"
	desc = "If you see this, you're not likely to remember it any time soon."
	icon = 'icons/obj/device.dmi'
	icon_state = "memorizer"
	item_state = "nullrod"

/obj/item/assembly/flash/handheld //this is now the regular pocket flashes

/obj/item/assembly/flash/armimplant
	name = "photon projector"
	desc = "A high-powered photon projector implant normally used for lighting purposes, but also doubles as a flashbulb weapon. Self-repair protocols fix the flashbulb if it ever burns out."
	var/flashcd = 20
	var/overheat = 0
	var/obj/item/organ/cyberimp/arm/flash/I = null

/obj/item/assembly/flash/armimplant/burn_out()
	if(I && I.owner)
		to_chat(I.owner, span_warning("Your photon projector implant overheats and deactivates!"))
		I.Retract()
	overheat = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd * 2)

/obj/item/assembly/flash/armimplant/try_use_flash(mob/user = null)
	if(user && !synth_check(user, SYNTH_RESTRICTED_ITEM))
		return
	if(user && HAS_TRAIT(user, TRAIT_NO_STUN_WEAPONS))
		to_chat(user, span_warning("You can't seem to remember how this works!"))
		return FALSE
	if(overheat)
		if(I && I.owner)
			to_chat(I.owner, span_warning("Your photon projector is running too hot to be used again so quickly!"))
		return FALSE
	overheat = TRUE
	set_light_on(TRUE)
	addtimer(CALLBACK(src, PROC_REF(flash_end)), FLASH_LIGHT_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd)
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	update_icon(ALL, flash = TRUE)
	return TRUE


/obj/item/assembly/flash/armimplant/proc/cooldown()
	overheat = FALSE

/obj/item/assembly/flash/armimplant/rev
	name = "syndicate flash"
	desc = "A flash which, used with certain hypnotic and subliminal messaging techniques, can turn loyal crewmembers into vicious revolutionaries."
	icon_state = "revflash"
	item_state = "revflash"
	flashing_overlay = "revflash-f"
	can_convert = TRUE

/obj/item/assembly/flash/hypnotic
	desc = "A modified flash device, programmed to emit a sequence of subliminal flashes that can send a vulnerable target into a hypnotic trance."
	flashing_overlay = "flash-hypno"
	light_color = LIGHT_COLOR_PINK
	cooldown = 20

/obj/item/assembly/flash/hypnotic/burn_out()
	return

/obj/item/assembly/flash/hypnotic/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_disarm("[src] emits a soothing light..."))
	if(targeted)
		if(M.flash_act(1, 1))
			var/hypnosis = FALSE
			if(M.hypnosis_vulnerable())
				hypnosis = TRUE
			if(user)
				user.visible_message(span_disarm("[user] blinds [M] with the flash!"), span_danger("You hypno-flash [M]!"))

			if(!hypnosis)
				to_chat(M, span_notice("The light makes you feel oddly relaxed..."))
				M.adjust_confusion_up_to(10 SECONDS, 20 SECONDS)
				M.adjust_dizzy_up_to(20 SECONDS, 40 SECONDS)
				M.adjust_drowsiness_up_to(20 SECONDS, 40 SECONDS)
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 10 SECONDS)
			else
				M.apply_status_effect(/datum/status_effect/trance, 200, TRUE)

		else if(user)
			user.visible_message(span_disarm("[user] fails to blind [M] with the flash!"), span_warning("You fail to hypno-flash [M]!"))
		else
			to_chat(M, span_danger("[src] fails to blind you!"))

	else if(M.flash_act())
		to_chat(M, span_notice("Such a pretty light..."))
		M.adjust_confusion_up_to(4 SECONDS, 20 SECONDS)
		M.adjust_dizzy_up_to(8 SECONDS, 40 SECONDS)
		M.adjust_drowsiness_up_to(8 SECONDS, 40 SECONDS)
		M.apply_status_effect(STATUS_EFFECT_PACIFY, 40)
