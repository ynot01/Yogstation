/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "#663300"
		if("hazel")
			return "#554422"
		if("grey")
			return pick("#666666","#777777","#888888","#999999","#aaaaaa","#bbbbbb","#cccccc")
		if("blue")
			return "#3366cc"
		if("green")
			return "#006600"
		if("amber")
			return "#ffcc00"
		if("albino")
			return "#" + pick("cc","dd","ee","ff") + pick("00","11","22","33","44","55","66","77","88","99") + pick("00","11","22","33","44","55","66","77","88","99")
		else
			return "#000000"

/proc/random_underwear(gender)
	if(!GLOB.underwear_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.underwear_m)
		if(FEMALE)
			return pick(GLOB.underwear_f)
		else
			return pick(GLOB.underwear_list)

/proc/random_undershirt(gender)
	if(!GLOB.undershirt_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	switch(gender)
		if(MALE)
			return pick(GLOB.undershirt_m)
		if(FEMALE)
			return pick(GLOB.undershirt_f)
		else
			return pick(GLOB.undershirt_list)

/proc/random_socks()
	if(!GLOB.socks_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	return pick(GLOB.socks_list)

/proc/random_features()
	if(!GLOB.tails_list_human.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human)
	if(!GLOB.tails_list_lizard.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard, GLOB.tails_list_lizard)
	if(!GLOB.tails_list_polysmorph.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/polysmorph, GLOB.tails_list_polysmorph)
	if(!GLOB.snouts_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts, GLOB.snouts_list)
	if(!GLOB.horns_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/horns, GLOB.horns_list)
	if(!GLOB.ears_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, GLOB.horns_list)
	if(!GLOB.frills_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, GLOB.frills_list)
	if(!GLOB.spines_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, GLOB.spines_list)
	if(!GLOB.body_markings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, GLOB.body_markings_list)
	if(!GLOB.wings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.wings_list)
	if(!GLOB.moth_wings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_wings, GLOB.moth_wings_list)
	if(!GLOB.teeth_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/teeth, GLOB.teeth_list)
	if(!GLOB.dome_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/dome, GLOB.dome_list)
	if(!GLOB.dorsal_tubes_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/dorsal_tubes, GLOB.dorsal_tubes_list)
	if(!GLOB.ethereal_mark_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ethereal_mark, GLOB.ethereal_mark_list)
	if(!GLOB.preternis_weathering_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/preternis_weathering, GLOB.preternis_weathering_list)
	if(!GLOB.preternis_antenna_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/preternis_antenna, GLOB.preternis_antenna_list)
	if(!GLOB.preternis_eye_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/preternis_eye, GLOB.preternis_eye_list)
	if(!GLOB.preternis_core_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/preternis_core, GLOB.preternis_core_list)
	if(!GLOB.pod_hair_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/pod_hair, GLOB.pod_hair_list)
	if(!GLOB.pod_flower_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/pod_flower, GLOB.pod_flower_list)
	if(!GLOB.ipc_screens_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_screens, GLOB.ipc_screens_list)
	if(!GLOB.ipc_antennas_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_antennas, GLOB.ipc_antennas_list)
	if(!GLOB.ipc_chassis_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_chassis, GLOB.ipc_chassis_list)
	if(!GLOB.vox_quills_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_quills, GLOB.vox_quills_list)
	if(!GLOB.vox_facial_quills_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_facial_quills, GLOB.vox_facial_quills_list)
	if(!GLOB.vox_tails_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_tails, GLOB.vox_tails_list)
	if(!GLOB.vox_body_markings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_body_markings, GLOB.vox_body_markings_list)
	if(!GLOB.vox_tail_markings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_tail_markings, GLOB.vox_tail_markings_list)

	//For now we will always return none for tail_human and ears.		this shit was unreadable if you do somethign like this make it at least readable
	return(list(
		"mcolor" = "#[pick("7F","FF")][pick("7F","FF")][pick("7F","FF")]",
		"mcolor_secondary" = "#[pick("7F","FF")][pick("7F","FF")][pick("7F","FF")]",
		"gradientstyle" = random_hair_gradient_style(10),
		"gradientcolor" = "#[pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")]",
		"tail_lizard" = pick(GLOB.tails_list_lizard),
		"tail_human" = "None",
		"wings" = "None",
		"snout" = pick(GLOB.snouts_list),
		"horns" = pick(GLOB.horns_list),
		"ears" = "None",
		"frills" = pick(GLOB.frills_list),
		"spines" = pick(GLOB.spines_list),
		"body_markings" = pick(GLOB.body_markings_list),
		"caps" = pick(GLOB.caps_list),
		"moth_wings" = pick(GLOB.moth_wings_list),
		"tail_polysmorph" = pick(GLOB.tails_list_polysmorph),
		"teeth" = pick(GLOB.teeth_list),
		"dome" = pick(GLOB.dome_list),
		"dorsal_tubes" = pick(GLOB.dorsal_tubes_list),
		"ethereal_mark" = pick(GLOB.ethereal_mark_list),
		"pretcolor" = pick(GLOB.color_list_preternis),
		"preternis_weathering" = pick(GLOB.preternis_weathering_list),
		"preternis_antenna" = pick(GLOB.preternis_antenna_list),
		"preternis_eye" = pick(GLOB.preternis_eye_list),
		"preternis_core" = pick(GLOB.preternis_core_list),
		"pod_hair" = pick(GLOB.pod_hair_list),
		"ipc_screen" = pick(GLOB.ipc_screens_list),
		"ipc_antenna" = pick(GLOB.ipc_antennas_list),
		"ipc_chassis" = pick(GLOB.ipc_chassis_list),
		"vox_skin_tone" = pick(GLOB.vox_skin_tones),
		"vox_quills" = pick(GLOB.vox_quills_list),
		"vox_facial_quills" = pick(GLOB.vox_facial_quills_list),
		"vox_body_markings" = pick(GLOB.vox_body_markings_list),
		"vox_tail_markings" = pick(GLOB.vox_tail_markings_list)
	))

/proc/random_hair_style(gender)
	switch(gender)
		if(MALE)
			return pick(GLOB.hair_styles_male_list)
		if(FEMALE)
			return pick(GLOB.hair_styles_female_list)
		else
			return pick(GLOB.hair_styles_list)

/proc/random_facial_hair_style(gender)
	switch(gender)
		if(MALE)
			return pick(GLOB.facial_hair_styles_male_list)
		if(FEMALE)
			return pick(GLOB.facial_hair_styles_female_list)
		else
			return pick(GLOB.facial_hair_styles_list)

/proc/random_hair_gradient_style(weight)
	if(rand(0, 100) <= weight)
		return pick(GLOB.hair_gradients_list)
	else
		return "None"

/proc/random_unique_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		if(gender==FEMALE)
			. = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			. = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

		if(!findname(.))
			break

/proc/random_unique_lizard_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(lizard_name(gender))

		if(!findname(.))
			break

/proc/random_unique_pod_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pod_name(gender))

		if(!findname(.))
			break

/proc/random_unique_preternis_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(preternis_name())

		if(!findname(.))
			break

/proc/random_unique_plasmaman_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(plasmaman_name())

		if(!findname(.))
			break

/proc/random_unique_ethereal_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(ethereal_name())

		if(!findname(.))
			break

/proc/random_unique_moth_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.moth_first)) + " " + capitalize(pick(GLOB.moth_last))

		if(!findname(.))
			break

/proc/random_unique_polysmorph_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.polysmorph_names))

		if(!findname(.))
			break

/proc/random_unique_ipc_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(ipc_name())

		if(!findname(.))
			break

/proc/random_skin_tone()
	return pick(GLOB.skin_tones)

GLOBAL_LIST_INIT(skin_tones, sortList(list(
	"albino",
	"caucasian1",
	"caucasian2",
	"caucasian3",
	"latino",
	"mediterranean",
	"asian1",
	"asian2",
	"arab",
	"indian",
	"mixed1",
	"mixed2",
	"mixed3",
	"mixed4",
	"african1",
	"african2"
	)))

GLOBAL_LIST_INIT(skin_tone_names, list(
	"african1" = "Medium brown",
	"african2" = "Dark brown",
	"albino" = "Albino",
	"arab" = "Light brown",
	"asian1" = "Ivory",
	"asian2" = "Beige",
	"caucasian1" = "Porcelain",
	"caucasian2" = "Light peach",
	"caucasian3" = "Peach",
	"indian" = "Brown",
	"latino" = "Light beige",
	"mediterranean" = "Olive",
	"mixed1" = "Chestnut",
	"mixed2" = "Walnut",
	"mixed3" = "Coffee",
	"mixed4" = "Macadamia",
))

GLOBAL_LIST_EMPTY(species_list)

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)
			return "infant"
		if(1 to 3)
			return "toddler"
		if(3 to 13)
			return "child"
		if(13 to 19)
			return "teenager"
		if(19 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

//some additional checks as a callback for for do_afters that want to break on losing health or on the mob taking action
/mob/proc/break_do_after_checks(list/checked_health, check_clicks)
	if(check_clicks && next_move > world.time)
		return FALSE
	return TRUE

//pass a list in the format list("health" = mob's health var) to check health during this
/mob/living/break_do_after_checks(list/checked_health, check_clicks)
	if(islist(checked_health))
		if(health < checked_health["health"])
			return FALSE
		checked_health["health"] = health
	return ..()

/**
 * Timed action involving one mob user. Target is optional.
 *
 * Checks that `user` does not move, change hands, get stunned, etc. for the
 * given `delay`. Returns `TRUE` on success or `FALSE` on failure.
 * Interaction_key is the assoc key under which the do_after is capped, with max_interact_count being the cap. Interaction key will default to target if not set.
 */
/proc/do_after(mob/user, delay, atom/target, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks, interaction_key, max_interact_count = 1)
	if(!user)
		return FALSE
	if(!isnum(delay))
		CRASH("do_after was passed a non-number delay: [delay || "null"].")

	if(!interaction_key && target)
		interaction_key = target //Use the direct ref to the target
	if(interaction_key) //Do we have a interaction_key now?
		var/current_interaction_count = LAZYACCESS(user.do_afters, interaction_key) || 0
		if(current_interaction_count >= max_interact_count) //We are at our peak
			return
		LAZYSET(user.do_afters, interaction_key, current_interaction_count + 1)

	if(!(timed_action_flags & IGNORE_SLOWDOWNS))
		delay *= user.action_speed_modifier * user.do_after_coefficent() //yogs: darkspawn

	var/datum/progressbar/progbar
	if(progress)
		progbar = new(user, delay, target || user, timed_action_flags, extra_checks)

	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)

		if(QDELETED(progbar) || !progbar.update(world.time - starttime))
			. = FALSE
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	if(interaction_key)
		LAZYREMOVE(user.do_afters, interaction_key)
	SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)

/mob/proc/do_after_coefficent() // This gets added to the delay on a do_after, default 1
	. = 1

/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, species_datum))
			. = TRUE

/proc/spawn_atom_to_turf(spawn_type, target, amount, admin_spawn=FALSE, list/extra_args)
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/new_args = list(T)
	if(extra_args)
		new_args += extra_args
	var/atom/X
	for(var/j in 1 to amount)
		X = new spawn_type(arglist(new_args))
		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1
	return X //return the last mob spawned

/proc/spawn_and_random_walk(spawn_type, target, amount, walk_chance=100, max_walk=3, always_max_walk=FALSE, admin_spawn=FALSE)
	var/turf/T = get_turf(target)
	var/step_count = 0
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/spawned_mobs = new(amount)

	for(var/j in 1 to amount)
		var/atom/movable/X

		if (istype(spawn_type, /list))
			var/mob_type = pick(spawn_type)
			X = new mob_type(T)
		else
			X = new spawn_type(T)

		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1

		spawned_mobs[j] = X

		if(always_max_walk || prob(walk_chance))
			if(always_max_walk)
				step_count = max_walk
			else
				step_count = rand(1, max_walk)

			for(var/i in 1 to step_count)
				step(X, pick(NORTH, SOUTH, EAST, WEST))

	return spawned_mobs

// Displays a message in deadchat, sent by source.
// Automatically gives the class deadsay to the whole message (message + source)
/proc/deadchat_broadcast(message, source=null, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	message = span_deadsay("[source][message]")
	for(var/mob/M in GLOB.player_list)
		var/datum/preferences/prefs
		if(M.client && M.client.prefs)
			prefs = M.client.prefs
		else
			prefs = new

		var/override = FALSE
		if(M.client && M.client.holder && (prefs.chat_toggles & CHAT_DEAD))
			override = TRUE
		if(HAS_TRAIT(M, TRAIT_SIXTHSENSE))
			override = TRUE
		if(SSticker.current_state == GAME_STATE_FINISHED)
			override = TRUE
		if(isnewplayer(M) && !override)
			continue
		if(M.stat != DEAD && !override)
			continue
		if(speaker_key && (speaker_key in prefs.ignoring))
			continue

		switch(message_type)
			if(DEADCHAT_DEATHRATTLE)
				if(prefs.toggles & DISABLE_DEATHRATTLE)
					continue
			if(DEADCHAT_ARRIVALRATTLE)
				if(prefs.toggles & DISABLE_ARRIVALRATTLE)
					continue
			if(DEADCHAT_PDA)
				if(!(prefs.chat_toggles & CHAT_GHOSTPDA))
					continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
				var/F
				if(turf_target)
					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
				else
					F = FOLLOW_LINK(M, follow_target)
				rendered_message = "[F] [message]"
			else if(turf_target)
				var/turf_link = TURF_LINK(M, turf_target)
				rendered_message = "[turf_link] [message]"

			to_chat(M, rendered_message, avoid_highlighting = speaker_key == M.key)
		else
			to_chat(M, message, avoid_highlighting = speaker_key == M.key)

//Used in chemical_mob_spawn. Generates a random mob based on a given gold_core_spawnable value.
/proc/create_random_mob(spawn_location, mob_class = HOSTILE_SPAWN)
	var/static/list/mob_spawn_meancritters = list() // list of possible hostile mobs
	var/static/list/mob_spawn_nicecritters = list() // and possible friendly mobs

	if(mob_spawn_meancritters.len <= 0 || mob_spawn_nicecritters.len <= 0)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			switch(initial(SA.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += T
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += T

	var/chosen
	if(mob_class == FRIENDLY_SPAWN)
		chosen = pick(mob_spawn_nicecritters)
	else
		chosen = pick(mob_spawn_meancritters)
	var/mob/living/simple_animal/C = new chosen(spawn_location)
	return C

/proc/passtable_on(target, source)
	var/mob/living/L = target
	if (!HAS_TRAIT(L, TRAIT_PASSTABLE) && L.pass_flags & PASSTABLE)
		ADD_TRAIT(L, TRAIT_PASSTABLE, INNATE_TRAIT)
	ADD_TRAIT(L, TRAIT_PASSTABLE, source)
	L.pass_flags |= PASSTABLE

/proc/passtable_off(target, source)
	var/mob/living/L = target
	REMOVE_TRAIT(L, TRAIT_PASSTABLE, source)
	if(!HAS_TRAIT(L, TRAIT_PASSTABLE))
		L.pass_flags &= ~PASSTABLE

/proc/dance_rotate(atom/movable/AM, datum/callback/callperrotate, set_original_dir=FALSE)
	set waitfor = FALSE
	var/originaldir = AM.dir
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!AM)
			return
		AM.setDir(i)
		callperrotate?.Invoke()
		sleep(0.1 SECONDS)
	if(set_original_dir)
		AM.setDir(originaldir)

/// Gets the client of the mob, allowing for mocking of the client.
/// You only need to use this if you know you're going to be mocking clients somewhere else.
#define GET_CLIENT(mob) (##mob.client || ##mob.mock_client)
