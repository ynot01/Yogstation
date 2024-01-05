/datum/map_template/ruin/proc/try_to_place(z, list/allowed_areas_typecache, turf/forced_turf, clear_below)
	var/sanity = forced_turf ? 1 : PLACEMENT_TRIES
	while(sanity > 0)
		sanity--
		var/width_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(width / 2)
		var/height_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(height / 2)
		var/turf/central_turf = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z)
		var/valid = TRUE
		var/list/affected_turfs = get_affected_turfs(central_turf,1)
		var/list/affected_areas = list()

		for(var/turf/check in affected_turfs)
			// Use assoc lists to move this out, it's easier that way
			if(check.flags_1 & NO_RUINS_1)
				valid = FALSE
				break
			
			var/area/new_area = get_area(check)
			affected_areas[new_area] = TRUE

		// This is faster yes. Only BARELY but it is faster
		for(var/area/affct_area as anything in affected_areas)
			if(!allowed_areas_typecache[affct_area.type])
				valid = FALSE
				break

		if(!valid)
			continue

		testing("Ruin \"[name]\" placed at ([central_turf.x], [central_turf.y], [central_turf.z])")

		if(clear_below)
			var/list/static/clear_below_typecache = typecacheof(list(
				/obj/structure/spawner,
				/mob/living/simple_animal,
				/obj/structure/flora,
				/obj/structure/herb //YOGS EDIT
			))
			for(var/turf/T as anything in affected_turfs)
				for(var/atom/thing as anything in T)
					if(clear_below_typecache[thing.type])
						qdel(thing)

		load(central_turf,centered = TRUE)
		loaded++

		for(var/turf/T in affected_turfs)
			T.flags_1 |= NO_RUINS_1

		new /obj/effect/landmark/ruin(central_turf, src)
		return central_turf


/proc/seedRuins(list/z_levels = null, budget = 0, whitelist = list(/area/space), list/potentialRuins, clear_below = FALSE)
	if(!z_levels || !z_levels.len)
		WARNING("No Z levels provided - Not generating ruins")
		return
	var/list/whitelist_typecache = typecacheof(whitelist)

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			WARNING("Z level [zl] does not exist - Not generating ruins")
			return

	var/list/ruins = potentialRuins.Copy()

	var/list/forced_ruins = list()		//These go first on the z level associated (same random one by default)
	var/list/ruins_availible = list()	//we can try these in the current pass
	var/list/ruins_placed = list() // yogs

	if(PERFORM_ALL_TESTS(log_mapping))
		log_mapping("All ruins being loaded for map testing")

	//Set up the starting ruin list
	for(var/key in ruins)
		var/datum/map_template/ruin/R = ruins[key]

		if(PERFORM_ALL_TESTS(log_mapping))
			R.cost = 0
			R.allow_duplicates = FALSE // no multiples for testing
			R.always_place = !R.unpickable // unpickable ruin means it spawns as a set with another ruin

		if(R.cost > budget) //Why would you do that
			continue
		if(R.always_place)
			forced_ruins[R] = -1
		if(R.unpickable)
			continue
		ruins_availible[R] = R.placement_weight

	while(budget > 0 && (ruins_availible.len || forced_ruins.len))
		var/datum/map_template/ruin/current_pick
		var/forced = FALSE
		var/forced_z	//If set we won't pick z level and use this one instead.
		var/forced_turf //If set we place the ruin centered on the given turf
		if(forced_ruins.len) //We have something we need to load right now, so just pick it
			for(var/ruin in forced_ruins)
				current_pick = ruin
				if(isturf(forced_ruins[ruin])) //Load into designated z
					var/turf/T = forced_ruins[ruin]
					forced_z = T.z
					forced_turf = T
				else if(forced_ruins[ruin] > 0) //Load into designated z
					forced_z = forced_ruins[ruin]
				forced = TRUE
				break
		else //Otherwise just pick random one
			current_pick = pickweight(ruins_availible)

		var/placement_tries = forced_turf ? 1 : PLACEMENT_TRIES //Only try once if we target specific turf
		var/failed_to_place = TRUE
		var/target_z = 0
		var/turf/placed_turf //Where the ruin ended up if we succeeded
		outer:
			while(placement_tries > 0)
				placement_tries--
				target_z = pick(z_levels)
				if(forced_z)
					target_z = forced_z
				if(current_pick.always_spawn_with) //If the ruin has part below, make sure that z exists.
					for(var/v in current_pick.always_spawn_with)
						if(current_pick.always_spawn_with[v] == PLACE_BELOW)
							var/turf/T = locate(1,1,target_z)
							if(!SSmapping.get_turf_below(T))
								if(forced_z)
									continue outer
								else
									break outer

				placed_turf = current_pick.try_to_place(target_z,whitelist_typecache,forced_turf,clear_below)
				if(!placed_turf)
					continue
				else
					failed_to_place = FALSE
					break

		//That's done remove from priority even if it failed
		if(forced)
			//TODO : handle forced ruins with multiple variants
			forced_ruins -= current_pick
			forced = FALSE

		if(failed_to_place)
			for(var/datum/map_template/ruin/R in ruins_availible)
				if(R.id == current_pick.id)
					ruins_availible -= R
			log_world("Failed to place [current_pick.name] ruin.")
		else
			ruins_placed[current_pick.type] = TRUE // yogs
			budget -= current_pick.cost
			if(!current_pick.allow_duplicates)
				for(var/datum/map_template/ruin/R in ruins_availible)
					if(R.id == current_pick.id)
						ruins_availible -= R
			if(current_pick.never_spawn_with)
				for(var/blacklisted_type in current_pick.never_spawn_with)
					for(var/possible_exclusion in ruins_availible)
						if(istype(possible_exclusion,blacklisted_type))
							ruins_availible -= possible_exclusion
			if(current_pick.always_spawn_with)
				for(var/v in current_pick.always_spawn_with)
					// yogs start
					var/datum/map_template/ruin/RT = v
					if(!initial(RT.allow_duplicates) && ruins_placed[v])
						continue
					// yogs end
					for(var/ruin_name in SSmapping.ruins_templates) //Because we might want to add space templates as linked of lava templates.
						var/datum/map_template/ruin/linked = SSmapping.ruins_templates[ruin_name] //why are these assoc, very annoying.
						if(istype(linked,v))
							switch(current_pick.always_spawn_with[v])
								if(PLACE_SAME_Z)
									forced_ruins[linked] = target_z //I guess you might want a chain somehow
								if(PLACE_LAVA_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_LAVA_RUINS))
								if(PLACE_SPACE_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_SPACE_RUINS))
								if(PLACE_ICE_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_ICE_RUINS))
								if(PLACE_ICE_UNDERGROUND_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_ICE_RUINS_UNDERGROUND))
								if(PLACE_DEFAULT)
									forced_ruins[linked] = -1
								if(PLACE_BELOW)
									forced_ruins[linked] = SSmapping.get_turf_below(placed_turf)
		forced_z = 0

		//Update the availible list
		for(var/datum/map_template/ruin/R in ruins_availible)
			if(R.cost > budget)
				ruins_availible -= R

	log_world("Ruin loader finished with [budget] left to spend.")
