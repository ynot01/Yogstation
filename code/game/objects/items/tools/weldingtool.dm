#define WELDER_FUEL_BURN_INTERVAL 26
/obj/item/weldingtool
	name = "welding tool"
	desc = "A standard edition welder provided by Nanotrasen."
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	item_state = "welder"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 3
	throwforce = 5
	hitsound = "swing_hit"
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	drop_sound = 'sound/items/handling/weldingtool_drop.ogg'
	pickup_sound =  'sound/items/handling/weldingtool_pickup.ogg'
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.75
	light_on = FALSE
	throw_speed = 3
	throw_range = 5
	demolition_mod = 0.5 // not very good at smashing
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF

	materials = list(/datum/material/iron=70, /datum/material/glass=30)
	///Whether the welding tool is on or off.
	var/welding = FALSE
	var/max_fuel = 20 	//The max amount of fuel the welder can hold
	var/change_icons = 1
	var/can_off_process = 0
	var/progress_flash_divisor = 10
	var/burned_fuel_for = 0	//when fuel was last removed
	heat = 3800
	tool_behaviour = TOOL_WELDER
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	var/mutable_appearance/sparks

/obj/item/weldingtool/Initialize(mapload)
	. = ..()
	sparks =  mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	update_appearance(UPDATE_ICON)

/obj/item/weldingtool/update_overlays()
	. = ..()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = CEILING(ratio*4, 1) * 25
		. += "[initial(icon_state)][ratio]"
	if(welding)
		. += "[initial(icon_state)]-on"

/obj/item/weldingtool/update_icon_state()
	. = ..()
	if(welding)
		item_state = "[initial(item_state)]1"
	else
		item_state = "[initial(item_state)]"

/obj/item/weldingtool/process(delta_time)
	switch(welding)
		if(0)
			force = 3
			damtype = "brute"
			update_appearance(UPDATE_ICON)
			if(!can_off_process)
				STOP_PROCESSING(SSobj, src)
			return
	//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			force = 12
			damtype = BURN
			burned_fuel_for += delta_time
			if(burned_fuel_for >= WELDER_FUEL_BURN_INTERVAL)
				use(1)
			update_appearance(UPDATE_ICON)

	//This is to start fires. process() is only called if the welder is on.
	open_flame()


/obj/item/weldingtool/suicide_act(mob/user)
	if(isOn())
		user.visible_message(span_suicide("[user] welds [user.p_their()] every orifice closed! It looks like [user.p_theyre()] trying to commit suicide!"))
		if(!use_tool(user, 5 SECONDS, user))
			return MANUAL_SUICIDE_NONLETHAL
		return FIRELOSS
	user.visible_message(span_suicide("[user] tries welds [user.p_their()] every orifice closed! But forgot to turn the [src] on."))
	return SHAME

/obj/item/weldingtool/proc/explode()
	var/turf/T = get_turf(loc)
	var/plasmaAmount = reagents.get_reagent_amount(/datum/reagent/toxin/plasma)
	dyn_explosion(T, plasmaAmount/5)//20 plasma in a standard welder has a 4 power explosion. no breaches, but enough to kill/dismember holder
	qdel(src)

/obj/item/weldingtool/attack(mob/living/M, mob/living/user, params)
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(isOn() && !user.combat_mode && cig && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		if(cig.lit)
			to_chat(user, span_notice("The [cig.name] is already lit."))
			return FALSE
		if(M == user)
			cig.attackby(src, user)
			return TRUE
		else
			cig.light(span_notice("[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name]."))
			playsound(src, 'sound/items/lighter/light.ogg', 50, 2)
			return TRUE

	if(!user.combat_mode && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
		if(affecting?.status == BODYPART_ROBOTIC)
			if(affecting.brute_dam <= 0)
				to_chat(user, span_warning("[affecting] is already in good condition!"))
				return FALSE
			if(DOING_INTERACTION_WITH_TARGET(user, H))
				return FALSE
			if(!tool_start_check(user, 1))
				return FALSE
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message(span_notice("[user] starts to fix some of the dents on [M]'s [affecting.name]."), span_notice("You start fixing some of the dents on [M == user ? "your" : "[M]'s"] [affecting.name]."))
			heal_robo_limb(src, H, user, 10, 0, 1, 50)
			user.visible_message(span_notice("[user] fixes some of the dents on [M]'s [affecting.name]."), span_notice("You fix some of the dents on [M == user ? "your" : "[M]'s"] [affecting.name]."))
			return TRUE

	return ..()

/obj/item/weldingtool/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(O.is_refillable())
		reagents.trans_to(O, reagents.total_volume, transfered_by = user)
		to_chat(user, span_notice("You empty [src]'s fuel tank into [O]."))
		update_appearance(UPDATE_ICON)
	if(isOn())
		use(1)
		var/turf/location = get_turf(user)
		location.hotspot_expose(700, 50, 1)
		if(get_fuel() <= 0)
			set_light_on(FALSE)

		if(isliving(O))
			var/mob/living/L = O
			if(L.ignite_mob())
				message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(L)] on fire with [src] at [AREACOORD(user)]")
				log_game("[key_name(user)] set [key_name(L)] on fire with [src] at [AREACOORD(user)]")


/obj/item/weldingtool/attack_self(mob/user)
	if(src.reagents.has_reagent(/datum/reagent/toxin/plasma))
		message_admins("[ADMIN_LOOKUPFLW(user)] activated a rigged welder at [AREACOORD(user)].")
		explode()
	switched_on(user)

	update_appearance(UPDATE_ICON)

/obj/item/weldingtool/use_tool(atom/target, mob/living/user, delay, amount, volume, datum/callback/extra_checks, skill_check)
	target.add_overlay(sparks)
	. = ..()
	target.cut_overlay(sparks)

// Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)


// Uses fuel from the welding tool.
/obj/item/weldingtool/use(used = 0)
	if(!isOn() || !check_fuel())
		return FALSE

	if(used > 0)
		burned_fuel_for = 0
	if(get_fuel() >= used)
		reagents.remove_reagent(/datum/reagent/fuel, used)
		check_fuel()
		return TRUE
	else
		return FALSE

//Toggles the welding value.
/obj/item/weldingtool/proc/set_welding(new_value)
	if(welding == new_value)
		return
	. = welding
	welding = new_value
	set_light_on(welding)

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		set_light_on(FALSE)
		switched_on(user)
		update_appearance(UPDATE_ICON)
		//mob icon update
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands(0)

		return 0
	return 1

//Switches the welder on
/obj/item/weldingtool/proc/switched_on(mob/user)
	set_welding(!welding)
	if(welding)
		if(get_fuel() >= 1)
			to_chat(user, span_notice("You switch [src] on."))
			playsound(loc, acti_sound, 50, 1)
			force = 12
			damtype = BURN
			demolition_mod = 1.5 // pretty good at cutting
			hitsound = 'sound/items/welder.ogg'
			update_appearance(UPDATE_ICON)
			START_PROCESSING(SSobj, src)
		else
			to_chat(user, span_warning("You need more fuel!"))
			switched_off(user)
	else
		to_chat(user, span_notice("You switch [src] off."))
		playsound(loc, deac_sound, 50, 1)
		switched_off(user)

//Switches the welder off
/obj/item/weldingtool/proc/switched_off(mob/user)
	set_welding(FALSE)

	force = 3
	damtype = "brute"
	hitsound = "swing_hit"
	demolition_mod = initial(demolition_mod)
	update_appearance(UPDATE_ICON)


/obj/item/weldingtool/examine(mob/user)
	. = ..()
	. += "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/item/weldingtool/is_hot()
	return welding * heat

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

// When welding is about to start, run a normal tool_use_check, then flash a mob if it succeeds.
/obj/item/weldingtool/tool_start_check(mob/living/user, amount=0)
	. = tool_use_check(user, amount)
	if(. && user)
		if(HAS_TRAIT(user, TRAIT_SAFEWELD))
			return
		user.flash_act(light_range)

// Flash the user during welding progress
/obj/item/weldingtool/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	. = ..()
	if(. && user)
		if (progress_flash_divisor == 0)
			progress_flash_divisor = initial(progress_flash_divisor)
			if(HAS_TRAIT(user, TRAIT_SAFEWELD))
				return
			user.flash_act(min(light_range,1))
		else
			progress_flash_divisor--

// If welding tool ran out of fuel during a construction task, construction fails.
/obj/item/weldingtool/tool_use_check(mob/living/user, amount)
	if(!isOn() || !check_fuel())
		to_chat(user, span_warning("[src] has to be on to complete this task!"))
		return FALSE

	if(get_fuel() >= amount)
		return TRUE
	else
		to_chat(user, span_warning("You need more welding fuel to complete this task!"))
		return FALSE

/obj/item/weldingtool/ignition_effect(atom/A, mob/user)
	if(use_tool(A, user, 0, amount=1))
		return span_notice("[user] casually lights [A] with [src], what a badass.")
	else
		return ""

/obj/item/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A slightly larger welder with a larger tank."
	icon_state = "indwelder"
	max_fuel = 40
	materials = list(/datum/material/glass=60)

/obj/item/weldingtool/largetank/cyborg
	name = "integrated welding tool"
	desc = "An advanced welder designed to be used in robotic systems."
	toolspeed = 0.5

/obj/item/weldingtool/largetank/cyborg/cyborg_unequip(mob/user)
	if(!isOn())
		return
	switched_on(user)

/obj/item/weldingtool/mini
	name = "emergency welding tool"
	desc = "A miniature welder used during emergencies."
	icon_state = "miniwelder"
	max_fuel = 10
	w_class = WEIGHT_CLASS_TINY
	materials = list(/datum/material/iron=30, /datum/material/glass=10)
	change_icons = 0

/obj/item/weldingtool/abductor
	name = "alien welding tool"
	desc = "An alien welding tool. Whatever fuel it uses, it never runs out."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder_alien"
	toolspeed = 0.1
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = 0

/obj/item/weldingtool/abductor/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/weldingtool/hugetank
	name = "upgraded industrial welding tool"
	desc = "An upgraded welder based of the industrial welder."
	icon_state = "upindwelder"
	item_state = "upindwelder"
	max_fuel = 80
	materials = list(/datum/material/iron=70, /datum/material/glass=120)

/obj/item/weldingtool/experimental
	name = "experimental welding tool"
	desc = "An experimental welder capable of self-fuel generation and less harmful to the eyes."
	icon_state = "exwelder"
	item_state = "exwelder"
	max_fuel = 40
	materials = list(/datum/material/iron=70, /datum/material/glass=120)
	var/last_gen = 0
	change_icons = 0
	can_off_process = 1
	light_range = 1
	toolspeed = 0.5
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/brass
	name = "brass welding tool"
	desc = "A brass welder that seems to constantly refuel itself. It is faintly warm to the touch."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "brasswelder"
	item_state = "brasswelder"

/obj/item/weldingtool/experimental/Initialize(mapload)
	. = ..()
	sparks = mutable_appearance('icons/effects/welding_effect.dmi', "exp_welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)


/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)

/obj/item/weldingtool/makeshift
	name = "makeshift welding tool"
	desc = "A MacGyver-style welder."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "welder_makeshift"
	toolspeed = 2
	max_fuel = 10
	materials = list(MAT_METAL=140)

/obj/item/weldingtool/makeshift/switched_on(mob/user)
	..()
	if(welding && get_fuel() >= 1 && prob(2))
		var/datum/effect_system/reagents_explosion/e = new()
		to_chat(user, span_userdanger("Shoddy construction causes [src] to blow the fuck up!"))
		e.set_up(round(get_fuel() / 10, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

#undef WELDER_FUEL_BURN_INTERVAL
