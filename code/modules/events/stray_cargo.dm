///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event_control/stray_cargo
	name = "Stray Cargo Pod"
	typepath = /datum/round_event/stray_cargo
	weight = 20
	max_occurrences = 4
	earliest_start = 10 MINUTES
	description = "A pod containing a random supply crate lands on the station."
	admin_setup = list(/datum/event_admin_setup/set_location/stray_cargo, /datum/event_admin_setup/listed_options/stray_cargo)
	track = EVENT_TRACK_MUNDANE
	tags = list(TAG_COMMUNAL)

/datum/event_admin_setup/set_location/stray_cargo
	input_text = "Aim pod at turf we're on?"

/datum/event_admin_setup/set_location/stray_cargo/apply_to_event(datum/round_event/stray_cargo/event)
	event.admin_override_turf = chosen_turf

/datum/event_admin_setup/listed_options/stray_cargo
	input_text = "Choose a cargo crate to drop."
	normal_run_option = "Random Crate"

/datum/event_admin_setup/listed_options/stray_cargo/get_list()
	return sort_list(subtypesof(/datum/supply_pack), /proc/cmp_typepaths_asc)

/datum/event_admin_setup/listed_options/stray_cargo/apply_to_event(datum/round_event/stray_cargo/event)
	event.admin_override_contents = chosen
	var/log_message = "[key_name_admin(usr)] has aimed a stray cargo pod at [event.admin_override_turf ? AREACOORD(event.admin_override_turf) : "a random location"]. The pod contents are [chosen ? chosen : "random"]."
	message_admins(log_message)
	log_admin(log_message)

///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event/stray_cargo
	var/area/impact_area ///Randomly picked area
	announce_chance = 75
	var/list/possible_pack_types = list() ///List of possible supply packs dropped in the pod, if empty picks from the cargo list
	var/static/list/stray_spawnable_supply_packs = list() ///List of default spawnable supply packs, filtered from the cargo list
	///Admin setable override that is used instead of selecting a random location
	var/atom/admin_override_turf
	///Admin setable override to spawn a specific cargo pack type
	var/admin_override_contents

/datum/round_event/stray_cargo/announce(fake)
	if(fake)
		impact_area = find_event_area()
	priority_announce("Stray cargo pod detected on long-range scanners. Expected location of impact: [impact_area.name].", "Collision Alert")

/**
* Tries to find a valid area, throws an error if none are found
* Also randomizes the start timer
*/
/datum/round_event/stray_cargo/setup()
	start_when = rand(20, 40)
	if(admin_override_turf)
		impact_area = get_area(admin_override_turf)
	else
		impact_area = find_event_area()
	if(!impact_area)
		CRASH("No valid areas for cargo pod found.")
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		CRASH("Stray Cargo Pod : No valid turfs found for [impact_area] - [impact_area.type]")

	if(!stray_spawnable_supply_packs.len)
		stray_spawnable_supply_packs = SSshuttle.supply_packs.Copy()
		for(var/pack in stray_spawnable_supply_packs)
			var/datum/supply_pack/pack_type = pack
			if(initial(pack_type.special))
				stray_spawnable_supply_packs -= pack
	setup = TRUE //MONKESTATION ADDITION

///Spawns a random supply pack, puts it in a pod, and spawns it on a random tile of the selected area
/datum/round_event/stray_cargo/start()
	var/list/turf/valid_turfs = get_area_turfs(impact_area)
	//Only target non-dense turfs to prevent wall-embedded pods
	for(var/i in valid_turfs)
		var/turf/T = i
		if(T.density)
			valid_turfs -= T
	var/turf/landing_zone
	if(admin_override_turf)
		landing_zone = admin_override_turf
	else
		landing_zone = pick(valid_turfs)
	var/pack_type
	if(admin_override_contents)
		pack_type = admin_override_contents
	else
		if(possible_pack_types.len)
			pack_type = pick(possible_pack_types)
		else
			pack_type = pick(stray_spawnable_supply_packs)
	var/datum/supply_pack/supply_pack
	if(ispath(pack_type, /datum/supply_pack))
		supply_pack = new pack_type
	else  // treat this as a supply pack id and resolving it with SSshuttle
		if(admin_override_contents)
			supply_pack = admin_override_contents //Syndicate crates create a new datum while being customized which will result in this being triggered. Outside of this situation this should never trigger
		else
			supply_pack = SSshuttle.supply_packs[pack_type]
	var/obj/structure/closet/crate/crate = supply_pack.generate(null)
	if(crate) //empty supply packs are a thing! get memed on.
		crate.locked = FALSE //Unlock secure crates
		crate.update_appearance()
	var/obj/structure/closet/supplypod/pod = make_pod()
	new /obj/effect/DPtarget(landing_zone, pod, crate)
	announce_to_ghosts(landing_zone)

///Handles the creation of the pod, in case it needs to be modified beforehand
/datum/round_event/stray_cargo/proc/make_pod()
	var/obj/structure/closet/supplypod/S = new
	return S

///Picks an area that wouldn't risk critical damage if hit by a pod explosion
/datum/round_event/stray_cargo/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places that shouldn't explode
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engine,
		/area/shuttle)
		)

		///Subtypes from the above that actually should explode.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engine/break_room))
		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
	var/list/possible_areas = typecache_filter_list(GLOB.areas, allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)
