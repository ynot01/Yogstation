/obj/machinery/stasis
	name = "lifeform stasis unit"
	desc = "A not so comfortable looking bed with some nozzles at the top and bottom. It will keep someone in stasis."
	icon = 'icons/obj/machines/stasis.dmi'
	icon_state = "stasis"
	density = FALSE
	can_buckle = TRUE
	buckle_lying = 90
	circuit = /obj/item/circuitboard/machine/stasis
	idle_power_usage = 40
	active_power_usage = 340
	fair_market_price = 10
	payment_department = ACCOUNT_MED
	var/stasis_enabled = TRUE
	var/last_stasis_sound = FALSE
	var/stasis_can_toggle = 0
	var/stasis_cooldown = 5 SECONDS

	// Life tickrate is processed as follows
	// if (living.life_tickrate && (tick % living.life_tickrate) == 0) is true, life will tick on that tick
	// Thus,
	// 0 life_tickrate is 0% organ decay or 100% stasis
	// 1 life_tickrate is 100% organ decay or 0% stasis
	// 1.5 life_tickrate is 66% orcan decay or 33% stasis
	// 2 life_tickrate is 50% organ decay or 50% stasis
	// 3 life_tickrate is 33% organ decay or 66% stasis
	// 4 life_tickrate is 25% organ decay or 75% stasis
	// 5 life_tickrate is 20% organ decay or 80% stasis
	var/stasis_part = 1 // Tier part for easy reference
	var/stasis_amount = 1.5 // How much it adds to life tickrate
	// T1 = 0.5, 33% stasis
	// T2 = 1, 50% stasis
	// T3 = 3, 75% stasis
	// T4 = -1, 100% stasis
	
	var/mattress_state = "stasis_on"
	var/obj/effect/overlay/vis/mattress_on

/obj/machinery/stasis/RefreshParts()
	stasis_amount = initial(stasis_amount)
	stasis_cooldown = initial(stasis_cooldown)
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		switch(C.rating)
			if(1)
				stasis_amount = 0.5 // 33% stasis
				stasis_part = 1
			if(2)
				stasis_amount = 1 // 50% stasis, equivalent to a holobed
				stasis_part = 2
			if(3)
				stasis_amount = 3 // 75% stasis
				stasis_part = 3
			if(4)
				stasis_amount = -1 // 100% stasis
				stasis_part = 4
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		stasis_cooldown *= 1/M.rating // 100%, 50%, 33%, 25%
	if(occupant)
		thaw_them(occupant)
		chill_out(occupant)
	

/obj/machinery/stasis/ComponentInitialize()
	AddComponent(/datum/component/surgery_bed, 1, TRUE)

/obj/machinery/stasis/examine(mob/user)
	. = ..()
	if(panel_open)
		. += span_notice("[src]'s maintenance hatch is open!")
	. += span_notice("Alt-click to [stasis_enabled ? "turn off" : "turn on"] the machine.")
	if(in_range(user, src) || isobserver(user))
		var/stasis_percent = 33
		if(stasis_part > 1)
			stasis_percent = 25*stasis_part
		. += "<span class='notice'>The status display reads: \n"+\
		"Stasis efficiency at <b>[stasis_percent]%</b>.\n"+\
		"[stasis_enabled ? "Shutdown" : "Startup"] will take <b>[stasis_cooldown/10]</b> seconds.</span>"
	if(obj_flags & EMAGGED)
		. += span_warning("There's a worrying blue mist surrounding it.")

/obj/machinery/stasis/proc/play_power_sound()
	var/_running = stasis_running()
	if(last_stasis_sound != _running)
		var/sound_freq = rand(5120, 8800)
		if(_running)
			playsound(src, 'sound/machines/synth_yes.ogg', 50, TRUE, frequency = sound_freq)
		else
			playsound(src, 'sound/machines/synth_no.ogg', 50, TRUE, frequency = sound_freq)
		last_stasis_sound = _running

/obj/machinery/stasis/AltClick(mob/user)
	if(world.time >= stasis_can_toggle && user.canUseTopic(src, !issilicon(user)))
		stasis_enabled = !stasis_enabled
		stasis_can_toggle = world.time + stasis_cooldown
		playsound(src, 'sound/machines/click.ogg', 60, TRUE)
		play_power_sound()
		update_icon()

/obj/machinery/stasis/Exited(atom/movable/AM, atom/newloc)
	if(AM == occupant)
		var/mob/living/L = AM
		if(L.has_status_effect(STATUS_EFFECT_STASIS))
			thaw_them(L)
	. = ..()

/obj/machinery/stasis/proc/stasis_running()
	return stasis_enabled && is_operational()

/obj/machinery/stasis/update_icon()
	. = ..()
	var/_running = stasis_running()
	var/list/overlays_to_remove = managed_vis_overlays

	if(mattress_state)
		if(!mattress_on || !managed_vis_overlays)
			mattress_on = SSvis_overlays.add_vis_overlay(src, icon, mattress_state, layer, plane, dir, alpha = 0, unique = TRUE)

		if(mattress_on.alpha ? !_running : _running) //check the inverse of _running compared to truthy alpha, to see if they differ
			var/new_alpha = _running ? 255 : 0
			var/easing_direction = _running ? EASE_OUT : EASE_IN
			animate(mattress_on, alpha = new_alpha, time = stasis_cooldown, easing = CUBIC_EASING|easing_direction)

		overlays_to_remove = managed_vis_overlays - mattress_on

	SSvis_overlays.remove_vis_overlay(src, overlays_to_remove)

	if(stat & BROKEN)
		icon_state = "stasis_broken"
		return
	if(panel_open || stat & MAINT)
		icon_state = "stasis_maintenance"
		return
	icon_state = "stasis"

/obj/machinery/stasis/obj_break(damage_flag)
	. = ..()
	if(.)
		play_power_sound()

/obj/machinery/stasis/power_change()
	. = ..()
	play_power_sound()

/obj/machinery/stasis/proc/chill_out(mob/living/target)
	if(target != occupant)
		return
	var/freq = rand(24750, 26550)
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 2, frequency = freq)
	target.apply_status_effect(STATUS_EFFECT_STASIS, null, TRUE, stasis_amount)
	target.ExtinguishMob()
	use_power = ACTIVE_POWER_USE
	if(obj_flags & EMAGGED)
		to_chat(target, span_warning("Your limbs start to feel numb..."))

/obj/machinery/stasis/proc/thaw_them(mob/living/target)
	target.remove_status_effect(STATUS_EFFECT_STASIS)
	if(target == occupant)
		use_power = IDLE_POWER_USE

/obj/machinery/stasis/post_buckle_mob(mob/living/L)
	if(!can_be_occupant(L))
		return
	occupant = L
	if(stasis_running() && check_nap_violations())
		chill_out(L)
	update_icon()

/obj/machinery/stasis/post_unbuckle_mob(mob/living/L)
	thaw_them(L)
	if(L == occupant)
		occupant = null
	update_icon()

/obj/machinery/stasis/process()
	if( !( occupant && isliving(occupant) && check_nap_violations() ) )
		use_power = IDLE_POWER_USE
		return
	var/mob/living/L_occupant = occupant
	if(stasis_running())
		if(!L_occupant.has_status_effect(STATUS_EFFECT_STASIS))
			chill_out(L_occupant)
		if(obj_flags & EMAGGED && L_occupant.getStaminaLoss() <= 200)
			L_occupant.adjustStaminaLoss(5*stasis_part)
	else if(L_occupant.has_status_effect(STATUS_EFFECT_STASIS))
		thaw_them(L_occupant)

/obj/machinery/stasis/screwdriver_act(mob/living/user, obj/item/I)
	. = default_deconstruction_screwdriver(user, "stasis_maintenance", "stasis", I)
	update_icon()

/obj/machinery/stasis/wrench_act(mob/living/user, obj/item/I)
	if(default_change_direction_wrench(user, I))
		return TRUE

/obj/machinery/stasis/crowbar_act(mob/living/user, obj/item/I)
	return default_deconstruction_crowbar(I)

/obj/machinery/stasis/nap_violation(mob/violator)
	unbuckle_mob(violator, TRUE)

/obj/machinery/stasis/attack_robot(mob/user)
	if(Adjacent(user) && occupant)
		unbuckle_mob(occupant)
	else
		..()

/obj/machinery/stasis/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("The stasis bed's safeties are already overridden!"))
		return
	to_chat(user, span_notice("You override the stasis bed's safeties!"))
	obj_flags |= EMAGGED
