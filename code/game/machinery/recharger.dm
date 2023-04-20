/obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger"
	desc = "A charging dock for energy based weaponry."
	use_power = IDLE_POWER_USE
	idle_power_usage = 4
	active_power_usage = 250
	circuit = /obj/item/circuitboard/machine/recharger
	pass_flags = PASSTABLE
	var/obj/item/charging = null
	var/recharge_coeff = 1

	/// Has a special 
	var/icon_state_filled = null
	var/icon_state_open = "rechargeropen"

	var/static/list/allowed_devices = typecacheof(list(
		/obj/item/gun/energy,
		/obj/item/melee/baton,
		/obj/item/ammo_box/magazine/recharge,
		/obj/item/ammo_box/magazine/m308/laser,
		/obj/item/modular_computer))

/obj/machinery/recharger/RefreshParts()
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		recharge_coeff = C.rating

/obj/machinery/recharger/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("You're too far away to examine [src]'s contents and display!")
		return

	if(charging)
		. += {"[span_notice("\The [src] contains:")]
		[span_notice("- \A [charging].")]"}

	if(!(stat & (NOPOWER|BROKEN)))
		. += "<span class='notice'>The status display reads:<span>"
		. += "<span class='notice'>- Recharging <b>[recharge_coeff*10]%</b> cell charge per cycle.<span>"
		if(charging)
			var/obj/item/stock_parts/cell/C = charging.get_cell()
			. += "<span class='notice'>- \The [charging]'s cell is at <b>[C.percent()]%</b>.<span>"


/obj/machinery/recharger/proc/setCharging(new_charging)
	charging = new_charging
	if (new_charging)
		START_PROCESSING(SSmachines, src)
		use_power = ACTIVE_POWER_USE
		if(icon_state_filled)
			icon_state = icon_state_filled
	else
		use_power = IDLE_POWER_USE
		icon_state = initial(icon_state)
	update_icon()

/obj/machinery/recharger/attackby(obj/item/G, mob/user, params)
	if(G.tool_behaviour == TOOL_WRENCH)
		if(charging)
			to_chat(user, span_notice("Remove the charging item first!"))
			return
		setAnchored(!anchored)
		power_change()
		to_chat(user, span_notice("You [anchored ? "attached" : "detached"] [src]."))
		G.play_tool_sound(src)
		return

	var/allowed = is_type_in_typecache(G, allowed_devices)

	if(allowed)
		if(anchored)
			if(charging || panel_open)
				return 1

			//Checks to make sure he's not in space doing it, and that the area got proper power.
			var/area/a = get_area(src)
			if(!isarea(a) || a.power_equip == 0)
				to_chat(user, span_notice("[src] blinks red as you try to insert [G]."))
				return 1

			if (istype(G, /obj/item/gun/energy))
				var/obj/item/gun/energy/E = G
				if(!E.can_charge)
					to_chat(user, span_notice("Your gun has no external power connector."))
					return 1

			if(!user.transferItemToLoc(G, src))
				return 1
			setCharging(G)

		else
			to_chat(user, span_notice("[src] isn't connected to anything!"))
		return 1

	if(anchored && !charging)
		if(default_deconstruction_screwdriver(user, "rechargeropen", "recharger", G))
			return

		if(panel_open && G.tool_behaviour == TOOL_CROWBAR)
			default_deconstruction_crowbar(G)
			return

	return ..()

/obj/machinery/recharger/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	add_fingerprint(user)
	if(charging)
		charging.update_icon()
		charging.forceMove(drop_location())
		user.put_in_hands(charging)
		setCharging(null)

/obj/machinery/recharger/attack_tk(mob/user)
	if(charging)
		charging.update_icon()
		charging.forceMove(drop_location())
		setCharging(null)

/obj/machinery/recharger/process(delta_time)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return PROCESS_KILL

	if(charging && charging.loc == src)
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		if(C)
			if(C.charge < C.maxcharge)
				C.give(C.chargerate * recharge_coeff * delta_time / 2)
				use_power(125 * recharge_coeff * delta_time)
			update_icon()

		if(istype(charging, /obj/item/ammo_box/magazine/recharge))
			var/obj/item/ammo_box/magazine/recharge/R = charging
			if(R.stored_ammo.len < R.max_ammo)
				for(var/i in 1 to recharge_coeff) //So it actually gives more ammo when upgraded
					R.stored_ammo += new R.ammo_type(R)
					if(R.stored_ammo.len <= R.max_ammo)
						break
				use_power(100 * recharge_coeff)
			update_icon()
			return
		if(istype(charging, /obj/item/ammo_box/magazine/m308/laser))
			var/obj/item/ammo_box/magazine/m308/laser/R = charging
			if(R.stored_ammo.len < R.max_ammo)
				for(var/i in 1 to recharge_coeff) //See above
					R.stored_ammo += new R.ammo_type(R)
				use_power(100 * recharge_coeff)
			update_icon()
			return
	else
		if(charging)
			charging.update_icon()
			charging.forceMove(drop_location())
			setCharging(null)
		return PROCESS_KILL

/obj/machinery/recharger/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_CONTENTS)
		return
	if(!(stat & (NOPOWER|BROKEN)) && anchored)
		if(istype(charging,  /obj/item/gun/energy))
			var/obj/item/gun/energy/E = charging
			if(E.cell)
				E.cell.emp_act(severity)

		else if(istype(charging, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = charging
			if(B.cell)
				B.cell.charge = 0


/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	cut_overlays()
	if(charging)
		var/mutable_appearance/scan = mutable_appearance(icon, "[initial(icon_state)]filled")
		var/obj/item/stock_parts/cell/C = charging.get_cell()
		var/num = 0
		if(C)
			num = round(C.charge/C.maxcharge, 0.01)
		if(istype(charging, /obj/item/ammo_box/magazine/recharge))
			var/obj/item/ammo_box/magazine/recharge/R = charging
			num = round(R.stored_ammo.len/R.max_ammo, 0.01)
		if(istype(charging, /obj/item/ammo_box/magazine/m308/laser))
			var/obj/item/ammo_box/magazine/m308/laser/R = charging
			num = round(R.stored_ammo.len/R.max_ammo, 0.01)
		
		if(num >= 1)
			scan.color = "#58d0ff"
		else
			scan.color = gradient(list(0, "#ff0000", 0.99, "#00ff00", 1, "#cece00"), num)
		add_overlay(scan)

/obj/machinery/recharger/wallrecharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger"
	desc = "A wall mounted charging dock for energy based weaponry."
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 400

	icon_state_filled = "wrechargerweapon"
	icon_state_open = "wrechargeropen"
