/// The Production Producer
/obj/machinery/part_fabricator
	name = "experimental part fabricator"
	desc = "A strange machine that condenses materials into advanced parts."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/part_fabricator
	resistance_flags = UNACIDABLE | LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF

	use_power = IDLE_POWER_USE
	idle_power_usage = 5000
	active_power_usage = 20000
	density = TRUE

	var/static/part_recipes_generated = FALSE
	var/static/capacitor_energy_requirement
	var/static/matterbin_freon_moles_requirement
	var/static/list/datum/bounty/reagent/scanner_chemicals_requirement
	var/static/laser_money_requirement
	var/static/datum/bounty/item/botany/manipulator_plant_requirement
	var/static/manipulator_temp_requirement

	var/static/list/acceptable_items

	var/tab = "capacitor"

	var/production_speed = 1

	var/printing
	var/production_progress = 0

/obj/machinery/part_fabricator/attackby(obj/item/inserted, mob/living/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, inserted))
		update_icon()
		return
	
	if(default_deconstruction_crowbar(inserted))
		return

	if(is_refillable() && inserted.is_drainable())
		return FALSE //inserting reagents into the machine
	
	if(inserted.get_item_credit_value() || is_type_in_list(inserted, acceptable_items))
		inserted.forceMove(src)
		to_chat(user, span_notice("You insert \the [inserted] into \the [src]."))
		return TRUE
	else if(user.a_intent == INTENT_HELP) // if they're bashing it they probably don't care
		to_chat(user, span_danger("\The [src] rejects \the [inserted]!"))
	
	return ..()

/obj/machinery/part_fabricator/examine(mob/user)
	. = ..()
	if(panel_open)
		. += span_notice("\The [src]'s maintenance hatch is open!")
	if(in_range(user, src) || isobserver(user))
		. += span_notice("Production speed at [production_speed*100]%")

/obj/machinery/part_fabricator/RefreshParts()
	production_speed = initial(production_speed)
	for(var/obj/item/stock_parts/P in component_parts)
		if(P.rating == 5)
			production_speed += 0.2 // 21 parts, up to 5.2x default speed
	if(reagents)
		reagents.maximum_volume = 0
		for(var/obj/item/reagent_containers/glass/G in component_parts)
			reagents.maximum_volume += G.volume
			G.reagents.trans_to(src, G.reagents.total_volume)

/obj/machinery/part_fabricator/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	for(var/obj/item/item in contents)
		item.forceMove(get_turf(src)) // Eject anything we may be holding
		adjust_item_drop_location(item)

/obj/machinery/part_fabricator/Initialize()
	. = ..()
	create_reagents(0, OPENCONTAINER)
	RefreshParts()
	if(part_recipes_generated)
		return
	
	capacitor_energy_requirement = (rand() * 0.5 + 0.75) * 1000000000 // 0.75-1.25 GW

	matterbin_freon_moles_requirement = (rand() * 0.5 + 0.5) * 100 // 50-100 moles

	scanner_chemicals_requirement = list()
	scanner_chemicals_requirement += new /datum/bounty/reagent/simple_drink
	scanner_chemicals_requirement += new /datum/bounty/reagent/chemical_simple

	laser_money_requirement = round((rand() * 0.5 + 0.75) * 10000) // 7500-12500 credits

	var/list/possible_plants = subtypesof(/datum/bounty/item/botany)
	for(var/datum/bounty/item/botany/plant_bounty in possible_plants)
		if(initial(plant_bounty.multiplier) < 2)
			possible_plants -= plant_bounty
	manipulator_plant_requirement = new pick(possible_plants)

	manipulator_temp_requirement = (rand() + 1) * 40000 // 40000-80000 Kelvin

	acceptable_items = list(
		/obj/item/electrical_stasis_manifold,
		/obj/item/organic_augur,
		/obj/item/mmi/posibrain,
		/obj/item/gun/energy/laser,
		/obj/item/organ
	)

	for(var/item in manipulator_plant_requirement.wanted_types)
		acceptable_items += item

	part_recipes_generated = TRUE

/obj/machinery/part_fabricator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!is_operational())
		return
	if(!ui)
		ui = new(user, src, "PartFabricator", name)
		ui.open()

/obj/machinery/part_fabricator/ui_data(mob/user)
	var/list/data = ..()
	// Capacitor requirements /////////////////////////////////////////////////////////////////
	if(tab == "capacitor")
		var/current_ESMs = 0
		for(var/obj/item/electrical_stasis_manifold/esm in contents)
			current_ESMs++
		data["current_ESMs"] = current_ESMs ? current_ESMs : "0"

		var/current_energy = get_power(TRUE)
		data["current_energy"] = current_energy ? current_energy : "0"

	// Matter bin requirements /////////////////////////////////////////////////////////////////
	else if(tab == "matterbin")
		var/current_augurs = 0
		for(var/obj/item/organic_augur/augur in contents)
			current_augurs++
		data["current_augurs"] = current_augurs ? current_augurs : "0"

		var/datum/gas_mixture/my_gas = return_air()
		var/current_moles = my_gas.get_moles(/datum/gas/freon)
		data["current_moles"] = current_moles ? current_moles : "0"

	// Scanner requirements /////////////////////////////////////////////////////////////////
	else if(tab == "scanner")
		var/current_posibrain = "ERROR: No artificial brain loaded"
		for(var/obj/item/mmi/posibrain/posi in contents)
			current_posibrain = "ERROR: Artificial brain inactive"
			if(posi.brainmob?.key && posi.brainmob.stat == CONSCIOUS && posi.brainmob.client)
				current_posibrain = "Artificial brain active"
				break
		data["current_posibrain"] = current_posibrain

		var/current_reagents = list()
		var/current_reagents_num = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			current_reagents += "[R.name]"
			current_reagents_num += R.volume
		data["current_reagents"] = current_reagents
		data["current_reagents_num"] = current_reagents_num

	// Laser requirements /////////////////////////////////////////////////////////////////
	else if(tab == "laser")
		var/current_lasergun = "ERROR: No laser gun loaded"
		for(var/obj/item/gun/energy/laser/lasgun in contents)
			var/valid = FALSE
			for(var/obj/item/ammo_casing/ammotype in lasgun.ammo_type)
				if(initial(ammotype.harmful)) // No practice laser guns
					valid = TRUE
					break
			if(valid)
				current_lasergun = "Laser gun loaded"
				break
		data["current_lasergun"] = current_lasergun

		var/current_money = 0
		for(var/obj/item/money in contents)
			current_money += money.get_item_credit_value()
		data["current_money"] = current_money ? current_money : "0"

	// Manipulator requirements /////////////////////////////////////////////////////////////////
	else if(tab == "manipulator")
		var/current_plants = 0
		for(var/selected_item in contents)
			if(is_type_in_list(selected_item, manipulator_plant_requirement.wanted_types))
				current_plants++
		data["current_plants"] = current_plants

		var/current_temp = my_gas.return_temperature()
		data["current_temp"] = current_temp ? current_temp : "0"

	// Other vars /////////////////////////////////////////////////////////////////

	data["production_progress"] = production_progress
	data["tab"] = tab

	return data

/obj/machinery/part_fabricator/ui_static_data(mob/user)
	var/list/data = ..()
	data["capacitor_energy"] = capacitor_energy_requirement
	data["matterbin_moles"] = matterbin_freon_moles_requirement
	data["scanner_chemicals"] = list()
	data["scanner_chemicals_num"] = list()
	for(var/datum/bounty/reagent/bounty in scanner_chemicals_requirement)
		data["scanner_chemicals"] += "[initial(bounty.wanted_reagent.name)]"
		data["scanner_chemicals_num"] += bounty.required_volume
	data["laser_money"] = laser_money_requirement
	data["manipulator_plant"] = manipulator_plant_requirement.name
	data["manipulator_plant_num"] = manipulator_plant_requirement.required_count
	data["manipulator_temp"] = manipulator_temp_requirement
	return data

/obj/machinery/part_fabricator/ui_act(action, list/params)
	if(..())
		return
	
	switch(action)
		if("tryPrint")
			return try_print()
		/// Tabs ///
		if("goCapacitor")
			tab = "capacitor"
			return TRUE
		if("goMatterBin")
			tab = "matterbin"
			return TRUE
		if("goScanner")
			tab = "scanner"
			return TRUE
		if("goLaser")
			tab = "laser"
			return TRUE
		if("goManipulator")
			tab = "manipulator"
			return TRUE
		/// Ejection ///
		if("ejectESM")
			eject_type(/obj/item/electrical_stasis_manifold)
			return TRUE
		if("ejectAugur")
			eject_type(/obj/item/organic_augur)
			return TRUE
		if("ejectPosi")
			eject_type(/obj/item/mmi/posibrain)
			return TRUE
		if("flushChems")
			reagents.remove_all()
			return TRUE
		if("ejectLaserGun")
			eject_type(/obj/item/gun/energy/laser)
			return TRUE
		if("ejectMoney")
			for(var/obj/item/item in contents)
				if(item.get_item_credit_value())
					eject_item(item)
			return TRUE
		if("ejectPlants")
			eject_type(manipulator_plant_requirement.wanted_types)
			return TRUE
		

/// Returns the power of the powernet of the APC of the room we're in
/obj/machinery/part_fabricator/proc/get_power(view = FALSE) // viewavail is nicer looking but not the true current power
	var/current_energy = 0
	var/area/my_area = get_area(src)
	if(!my_area)
		return
	// this is apparently the best way to get the current area's APC
	for(var/obj/machinery/power/apc/selected_apc as anything in GLOB.apcs_list)
		if(selected_apc.area == my_area)
			current_energy = view ? selected_apc.terminal?.powernet?.viewavail : selected_apc.terminal?.powernet?.avail
			break
	return current_energy

/obj/machinery/part_fabricator/proc/eject_type(list/eject_types)
	if(!islist(eject_types))
		eject_types = list(eject_types)
	if(!eject_types.len)
		return
	for(var/atom/movable/item in contents)
		if(is_type_in_list(item, eject_types) || is_type_in_typecache(item, eject_types))
			eject_item(item)

/obj/machinery/part_fabricator/proc/eject_item(atom/movable/item)
	item.forceMove(drop_location())
	adjust_item_drop_location(item)

/obj/machinery/part_fabricator/proc/try_print()
	if(production_progress > 0)
		return FALSE
	printing = tab
	if(!is_satisfied())
		balloon_alert_to_viewers("Failed!")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		printing = null
		return FALSE
	production_progress = 1
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/machinery/part_fabricator/proc/is_satisfied()
	switch(printing)
		if("capacitor")
			var/current_ESMs = 0
			for(var/obj/item/electrical_stasis_manifold/esm in contents)
				contents -= esm
				current_ESMs++
			if(current_ESMs < 1)
				return FALSE
			
			if(get_power() < capacitor_energy_requirement)
				return FALSE
			return TRUE

		if("matterbin")
			var/current_augurs = 0
			for(var/obj/item/organic_augur/augur in contents)
				current_augurs++
			if(current_augurs < 1)
				return FALSE
			
			var/datum/gas_mixture/my_gas = return_air()
			var/current_moles = my_gas.get_moles(/datum/gas/freon)
			if(current_moles < matterbin_freon_moles_requirement)
				return FALSE
			return TRUE

		if("scanner")
			var/has_posi = FALSE
			for(var/obj/item/mmi/posibrain/posi in contents)
				has_posi = TRUE
				if(!posi.brainmob?.key || posi.brainmob.stat != CONSCIOUS || !posi.brainmob.client)
					return FALSE
			if(!has_posi)
				return FALSE
			
			for(var/datum/bounty/reagent/bounty in scanner_chemicals_requirement)
				if(!reagents.has_reagent(bounty.wanted_reagent, bounty.required_volume))
					return FALSE
			return TRUE

		if("laser")
			var/has_lasergun = FALSE
			for(var/obj/item/gun/energy/laser/lasgun in contents)
				has_lasergun = TRUE
				for(var/obj/item/ammo_casing/ammotype in lasgun.ammo_type)
					if(!initial(ammotype.harmful)) // No practice laser guns
						return FALSE
			if(!has_lasergun)
				return FALSE

			var/current_money = 0
			for(var/obj/item/money in contents)
				current_money += money.get_item_credit_value()
			if(current_money < laser_money_requirement)
				return FALSE
			return TRUE

		if("manipulator")
			var/current_plants = 0
			for(var/selected_item in contents)
				if(is_type_in_list(selected_item, manipulator_plant_requirement.wanted_types))
					current_plants++
			if(current_plants < manipulator_plant_requirement.required_count)
				return FALSE

			var/datum/gas_mixture/my_gas = return_air()
			if(my_gas.return_temperature() < manipulator_temp_requirement)
				return FALSE
			return TRUE

/obj/machinery/part_fabricator/process(delta_time)
	if(!printing || printing == "") // How
		return PROCESS_KILL
	
	production_progress += production_speed * delta_time

	if(!is_satisfied())
		balloon_alert_to_viewers("Failed!")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		production_progress = 0
		printing = null
		return PROCESS_KILL

	if(production_progress >= 100)
		var/obj/item/stock_parts/printed
		switch(printing)
			if("capacitor")
				printed = new /obj/item/stock_parts/capacitor/cubic
			if("matterbin")
				printed = new /obj/item/stock_parts/matter_bin/holding
			if("scanner")
				printed = new /obj/item/stock_parts/scanning_module/hexaphasic
			if("laser")
				printed = new /obj/item/stock_parts/micro_laser/quinthyper
			if("manipulator")
				printed = new /obj/item/stock_parts/manipulator/planck
			else
				explosion(get_turf(src), -1, -1, 2)
				STOP_PROCESSING(SSobj, src)
				production_progress = 1337
				message_admins("\A [src][ADMIN_FLW(src)] malfunctioned, please read runtimes and set production_progress and printing vars to restart it.")
				CRASH("Part fabricator tried to print unknown or null part: [printing]")

		if(is_satisfied()) // sanity
			balloon_alert_to_viewers("Success!")
			playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
			printed.forceMove(drop_location())
			adjust_item_drop_location(printed)
		else
			balloon_alert_to_viewers("Failed!")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
			qdel(printed)

		production_progress = 0
		printing = null
		return PROCESS_KILL
