/datum/job
	/// The name of the job used for preferences, bans, etc.
	var/title = "NOPE"

	/// The description of the job, used for preferences menu.
	/// Keep it short and useful. Avoid in-jokes, these are for new players.
	var/description

	/// This job comes with these accesses by default
	var/list/base_access = list()

	/// Additional accesses for the job if config.jobs_have_minimal_access is set to false
	var/list/added_access = list()

	/// Who is responsible for demoting them
	var/department_head = list()

	/// Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	/// Bitfield of departments this job belongs to. These get setup when adding the job into the department, on job datum creation.
	var/departments_bitflags = NONE

	/// If specified, this department will be used for the preferences menu.
	var/datum/job_department/department_for_prefs = null

	/// Lazy list with the departments this job belongs to.
	/// Required to be set for playable jobs.
	/// The first department will be used in the preferences menu,
	/// unless department_for_prefs is set.
	/// TODO: Currently not used so will always be empty! Change this to department datums
	var/list/departments_list = null
	
	/// Automatic deadmin for a job. Usually head/security positions
	var/auto_deadmin_role_flags = NONE
	// Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"
	/// How many max open slots for this job
	var/total_positions = 0
	/// How many can start the round as this job
	var/spawn_positions = 0
	/// How many players have this job
	var/current_positions = 0
	/// Supervisors, who this person answers to directly
	var/supervisors = ""

	/// What kind of mob type joining players with this job as their assigned role are spawned as.
	var/spawn_type = /mob/living/carbon/human

	/// Alternate titles for the job
	var/list/alt_titles
	/// If this is set to TRUE, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify
	/// If this is set to 1, a text is printed to the player when jobs are assigned, telling them that space law has been updated.
	var/space_law_notify
	/// If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0
	/// This is the IC age requirement for the players character in order to be this job.
	var/minimal_character_age = 0
	/// Outfit of the job
	var/outfit = null
	/// How many minutes are required to unlock this job
	var/exp_requirements = 0
	/// Which type of XP is required see `EXP_TYPE_` in __DEFINES/preferences.dm
	var/exp_type = ""
	/// Department XP required YOGS THIS IS NOT FUCKING SET FOR EVERY JOB I HATE WHOEVER DID THIS
	var/exp_type_department = ""
	/// How much antag rep this job gets increase antag chances next round unless its overriden in antag_rep.txt
	var/antag_rep = 3
	/// Base pay of the job
	var/paycheck = PAYCHECK_MINIMAL
	/// Where to pull money to pay people
	var/paycheck_department = ACCOUNT_CIV
	/// Traits added to the mind of the mob assigned this job
	var/list/mind_traits

	///Lazylist of traits added to the liver of the mob assigned this job (used for the classic "cops heal from donuts" reaction, among others)
	var/list/liver_traits = null

	/// Display order of the job
	var/display_order = JOB_DISPLAY_ORDER_DEFAULT

	/// Goodies that can be received via the mail system.
	// this is a weighted list.
	/// Keep the _job definition for this empty and use /obj/item/mail to define general gifts.
	var/list/mail_goodies = list()

	/// If this job's mail goodies compete with generic goodies.
	var/exclusive_mail_goodies = FALSE

	///The text a person using olfaction will see for the job of the target's scent
	var/smells_like = "a freeloader"

	/// Icons to be displayed in the orbit ui. Source: FontAwesome v5.
	var/orbit_icon

	var/datum/species/forced_species
		/**
	 * A list of job-specific areas to enable lights for if this job is present at roundstart, whenever minimal access is not in effect.
	 * This will be combined with minimal_lightup_areas, so no need to duplicate entries.
	 * Areas within their department will have their lights turned on automatically, so you should really only use this for areas outside of their department.
	 */
	var/list/lightup_areas = list()
	/**
	 * A list of job-specific areas to enable lights for if this job is present at roundstart.
	 * Areas within their department will have their lights turned on automatically, so you should really only use this for areas outside of their department.
	 */
	var/list/minimal_lightup_areas = list()

/datum/job/New()
	.=..()
	lightup_areas = typecacheof(lightup_areas)
	minimal_lightup_areas = typecacheof(minimal_lightup_areas)

	var/new_spawn_positions = CHECK_MAP_JOB_CHANGE(title, "spawn_positions")
	if(isnum(new_spawn_positions))
		spawn_positions = new_spawn_positions
	var/new_total_positions = CHECK_MAP_JOB_CHANGE(title, "total_positions")
	if(isnum(new_total_positions))
		total_positions = new_total_positions

//Only override this proc
//H is usually a human unless an /equip override transformed it
/datum/job/proc/after_spawn(mob/living/spawned, mob/M, latejoin = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src, spawned, M, latejoin)
	for(var/trait in mind_traits)
		ADD_TRAIT(spawned.mind, trait, JOB_TRAIT)

	var/obj/item/organ/liver/liver = spawned.getorganslot(ORGAN_SLOT_LIVER)
	if(liver)
		for(var/trait in liver_traits)
			ADD_TRAIT(liver, trait, JOB_TRAIT)
	spawned.mind.add_employee(/datum/corporation/nanotrasen)

/datum/job/proc/announce(mob/living/carbon/human/H)
	if(head_announce)
		announce_head(H, head_announce)

/datum/job/proc/override_latejoin_spawn(mob/living/carbon/human/H)		//Return TRUE to force latejoining to not automatically place the person in latejoin shuttle/whatever.
	return FALSE

//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	return TRUE

/datum/job/proc/GetAntagRep()
	. = CONFIG_GET(keyed_list/antag_rep)[replacetext(lowertext(title)," ", "_")]
	if(. == null)
		return antag_rep

//Don't override this unless the job transforms into a non-human (Silicons do this for example)
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	if(!H)
		return FALSE

	

//This reads Command placement exceptions in code/controllers/configuration/entries/game_options to allow non-Humans in specified Command roles. If the combination of species and command role is invalid, default to Human.
	if(CONFIG_GET(keyed_list/job_species_whitelist)[type] && !splittext(CONFIG_GET(keyed_list/job_species_whitelist)[type], ",").Find(H.dna.species.id))
		if(H.dna.species.id != SPECIES_HUMAN)
			H.set_species(/datum/species/human)
			H.apply_pref_name(/datum/preference/name/backup_human, preference_source)
	
	if(forced_species)
		H.set_species(forced_species)

	if(!visualsOnly)
		var/datum/bank_account/bank_account = new(H.real_name, src)
		bank_account.adjust_money(rand(STARTING_PAYCHECKS_MIN, STARTING_PAYCHECKS_MAX), TRUE)
		bank_account.payday(STARTING_PAYCHECKS, TRUE)
		H.account_id = bank_account.account_id

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(outfit_override || outfit)
		H.equipOutfit(outfit_override ? outfit_override : outfit, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.base_access.Copy()

	. = src.base_access.Copy()

	if(!CONFIG_GET(flag/jobs_have_minimal_access)) // If we should give players extra access
		. |= src.added_access.Copy()

	if(CONFIG_GET(flag/everyone_has_maint_access)) //Config has global maint access set
		. |= list(ACCESS_MAINT_TUNNELS)

/mob/living/proc/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	return

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE)
	dna.species.before_equip_job(equipping, src, visual_only)
	equipOutfit(equipping.outfit, visual_only)

/datum/job/proc/announce_head(mob/living/carbon/human/H, channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	if(H && GLOB.announcement_systems.len)
		//timer because these should come after the captain announcement
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer_here), CALLBACK(pick(GLOB.announcement_systems), /obj/machinery/announcement_system/proc/announce, "NEWHEAD", H.real_name, H.job, channels), 1))

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE	//Available in 0 days = available right now = player is old enough to play.
	return FALSE

/datum/job/proc/areas_to_light_up(minimal_access = TRUE)
	. = minimal_lightup_areas.Copy()
	if(!minimal_access)
		. |= lightup_areas
	for(var/department in departments_list)
		var/datum/job_department/place = new department()
		if(istype(place))
			if(place.department_bitflags & DEPARTMENT_BITFLAG_COMMAND)
				. |= GLOB.command_lightup_areas
			if(place.department_bitflags & DEPARTMENT_BITFLAG_ENGINEERING)
				. |= GLOB.engineering_lightup_areas
			if(place.department_bitflags & DEPARTMENT_BITFLAG_MEDICAL)
				. |= GLOB.medical_lightup_areas
			if(place.department_bitflags & DEPARTMENT_BITFLAG_SCIENCE)
				. |= GLOB.science_lightup_areas
			if(place.department_bitflags & DEPARTMENT_BITFLAG_CARGO)
				. |= GLOB.supply_lightup_areas
			if(place.department_bitflags & DEPARTMENT_BITFLAG_SECURITY)
				. |= GLOB.security_lightup_areas
		qdel(place)

/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!SSdbcore.Connect())
		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/config_check()
	return TRUE

/datum/job/proc/map_check()
	return TRUE

/datum/job/proc/radio_help_message(mob/M)
	to_chat(M, "<b>Prefix your message with :h to speak on your department's radio. To see other prefixes, look closely at your headset.</b>")

/datum/outfit/job
	name = "Standard Gear"

	var/jobtype = null

	uniform = /obj/item/clothing/under/color/grey
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black
	box = /obj/item/storage/box/survival

	preload = TRUE // These are used by the prefs ui, and also just kinda could use the extra help at roundstart

	var/obj/item/id_type = /obj/item/card/id
	var/obj/item/modular_computer/pda_type = /obj/item/modular_computer/tablet/pda/preset/basic
	var/backpack = /obj/item/storage/backpack
	var/satchel  = /obj/item/storage/backpack/satchel
	var/duffelbag = /obj/item/storage/backpack/duffelbag

	var/uniform_skirt = null

	/// Which slot the PDA defaults to
	var/pda_slot = ITEM_SLOT_BELT

	/// What shoes digitgrade crew should wear
	var/digitigrade_shoes

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	switch(H.backbag)
		if(GBACKPACK)
			back = /obj/item/storage/backpack //Grey backpack
		if(GSATCHEL)
			back = /obj/item/storage/backpack/satchel //Grey satchel
		if(GDUFFELBAG)
			back = /obj/item/storage/backpack/duffelbag //Grey Duffel bag
		if(LSATCHEL)
			back = /obj/item/storage/backpack/satchel/leather //Leather Satchel
		if(DSATCHEL)
			back = satchel //Department satchel
		if(DDUFFELBAG)
			back = duffelbag //Department duffel bag
		else
			back = backpack //Department backpack

	if (H.jumpsuit_style == PREF_SKIRT && uniform_skirt)
		uniform = uniform_skirt

	if(HAS_TRAIT(H, TRAIT_DIGITIGRADE) && digitigrade_shoes) 
		shoes = digitigrade_shoes

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJob(H.job)

	var/obj/item/card/id/C = new id_type()
	if(istype(C))
		C.access = J.get_access()
		shuffle_inplace(C.access) // Shuffle access list to make NTNet passkeys less predictable
		C.registered_name = H.real_name
		if(H.mind?.role_alt_title)
			C.assignment = H.mind.role_alt_title
		else
			C.assignment = J.title
		C.originalassignment = J.title
		if(H.age)
			C.registered_age = H.age
		C.update_label()
		var/acc_id = "[H.account_id]"
		if(acc_id in SSeconomy.bank_accounts)
			var/datum/bank_account/B = SSeconomy.bank_accounts[acc_id]
			C.registered_account = B
			B.bank_cards += C
		H.sec_hud_set_ID()

	if(pda_type)
		var/obj/item/modular_computer/PDA = new pda_type()
		if(istype(PDA))
			PDA.InsertID(C)
			H.equip_to_slot_if_possible(PDA, ITEM_SLOT_ID)

			PDA.update_label()
			PDA.update_appearance(UPDATE_ICON)
			PDA.update_filters()
		else
			H.equip_to_slot_if_possible(C, ITEM_SLOT_ID)
	else
		H.equip_to_slot_if_possible(C, ITEM_SLOT_ID)

	if(H.stat != DEAD)//if a job has a gps and it isn't a decorative corpse, rename the GPS to the owner's name
		for(var/obj/item/gps/G in H.get_all_contents())
			G.gpstag = H.real_name
			G.name = "global positioning system ([G.gpstag])"
			var/datum/component/gps/tracker = G.GetComponent(/datum/component/gps)
			if(tracker)
				tracker.gpstag = G.gpstag
			continue

/datum/outfit/job/get_chameleon_disguise_info()
	var/list/types = ..()
	types -= /obj/item/storage/backpack //otherwise this will override the actual backpacks
	types += backpack
	types += satchel
	types += duffelbag
	return types

/datum/outfit/job/get_types_to_preload()
	var/list/preload = ..()
	preload += backpack
	preload += satchel
	preload += duffelbag
	preload += /obj/item/storage/backpack/satchel/leather
	var/skirtpath = "[uniform]/skirt"
	preload += text2path(skirtpath)
	return preload

/// An overridable getter for more dynamic goodies.
/datum/job/proc/get_mail_goodies(mob/recipient)
	return mail_goodies


/datum/job/proc/award_service(client/winner, award)
	return


/datum/job/proc/get_captaincy_announcement(mob/living/captain)
	return "Due to extreme staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

/// Returns an atom where the mob should spawn in.
// /datum/job/proc/get_roundstart_spawn_point()
// 	if(random_spawns_possible)
// 		if(HAS_TRAIT(SSstation, STATION_TRAIT_LATE_ARRIVALS))
// 			return get_latejoin_spawn_point()
// 		if(HAS_TRAIT(SSstation, STATION_TRAIT_RANDOM_ARRIVALS))
// 			return get_safe_random_station_turf(typesof(/area/station/hallway)) || get_latejoin_spawn_point()
// 		if(HAS_TRAIT(SSstation, STATION_TRAIT_HANGOVER))
// 			var/obj/effect/landmark/start/hangover_spawn_point
// 			for(var/obj/effect/landmark/start/hangover/hangover_landmark in GLOB.start_landmarks_list)
// 				hangover_spawn_point = hangover_landmark
// 				if(hangover_landmark.used) //so we can revert to spawning them on top of eachother if something goes wrong
// 					continue
// 				hangover_landmark.used = TRUE
// 				break
// 			return hangover_spawn_point || get_latejoin_spawn_point()
// 	if(length(GLOB.jobspawn_overrides[title]))
// 		return pick(GLOB.jobspawn_overrides[title])
// 	var/obj/effect/landmark/start/spawn_point = get_default_roundstart_spawn_point()
// 	if(!spawn_point) //if there isn't a spawnpoint send them to latejoin, if there's no latejoin go yell at your mapper
// 		return get_latejoin_spawn_point()
// 	return spawn_point


/// Handles finding and picking a valid roundstart effect landmark spawn point, in case no uncommon different spawning events occur.
/datum/job/proc/get_default_roundstart_spawn_point()
	for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
		if(spawn_point.name != title)
			continue
		. = spawn_point
		if(spawn_point.used) //so we can revert to spawning them on top of eachother if something goes wrong
			continue
		spawn_point.used = TRUE
		break
	if(!.)
		log_mapping("Job [title] ([type]) couldn't find a round start spawn point.")

/// Finds a valid latejoin spawn point, checking for events and special conditions.
// /datum/job/proc/get_latejoin_spawn_point()
// 	if(length(GLOB.jobspawn_overrides[title])) //We're doing something special today.
// 		return pick(GLOB.jobspawn_overrides[title])
// 	if(length(SSjob.latejoin_trackers))
// 		return pick(SSjob.latejoin_trackers)
// 	return SSjob.get_last_resort_spawn_points()


// Spawns the mob to be played as, taking into account preferences and the desired spawn point.
/datum/job/proc/get_spawn_mob(client/player_client, atom/spawn_point)
	var/mob/living/spawn_instance
	if(ispath(spawn_type, /mob/living/silicon/ai))
		// This is unfortunately necessary because of snowflake AI init code. To be refactored.
		spawn_instance = new spawn_type(get_turf(spawn_point), null, player_client.mob)
	else
		spawn_instance = new spawn_type(player_client.mob.loc)
		spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	spawn_instance.apply_prefs_job(player_client, src)
	if(!player_client)
		qdel(spawn_instance)
		return // Disconnected while checking for the appearance ban.
	return spawn_instance


/// Applies the preference options to the spawning mob, taking the job into account. Assumes the client has the proper mind.
/mob/living/proc/apply_prefs_job(client/player_client, datum/job/job)

/**
 * Called after a successful roundstart spawn.
 * Client is not yet in the mob.
 * This happens after after_spawn()
 */
/datum/job/proc/after_roundstart_spawn(mob/living/spawning, client/player_client)
	SHOULD_CALL_PARENT(TRUE)


/**
 * Called after a successful latejoin spawn.
 * Client is in the mob.
 * This happens after after_spawn()
 */
/datum/job/proc/after_latejoin_spawn(mob/living/spawning)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_LATEJOIN_SPAWN, src, spawning)

//Warden and regular officers add this result to their get_access()
/datum/job/proc/check_config_for_sec_maint()
	if(CONFIG_GET(flag/security_has_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	return list()
