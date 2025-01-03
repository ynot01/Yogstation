/datum/job/ai
	title = "AI"
	description = "Assist the crew, follow your laws, coordinate your cyborgs."
	orbit_icon = "eye"
	auto_deadmin_role_flags = DEADMIN_POSITION_SILICON|DEADMIN_POSITION_CRITICAL
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your laws"
	req_admin_notify = TRUE
	minimal_player_age = 30
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SILICON
	display_order = JOB_DISPLAY_ORDER_AI
	var/do_special_check = TRUE

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_MASTER,
		SKILL_MECHANICAL = EXP_MASTER,
		SKILL_TECHNICAL = EXP_MASTER,
		SKILL_SCIENCE = EXP_MASTER,
		SKILL_FITNESS = EXP_NONE, // it can't fucking MOVE
	)
	skill_points = 0

	departments_list = list(
		/datum/job_department/silicon,
	)

	alt_titles = list("Station Central Processor", "Central Silicon Intelligence", "Cyborg Overlord")

	//this should never be seen because of the way olfaction works but just in case
	smells_like = "chained intellect"

/datum/job/ai/equip(mob/living/equipping, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source = null)
	if(visualsOnly)
		CRASH("dynamic preview is unsupported")
	. = equipping.AIize(preference_source)

/datum/job/ai/after_spawn(mob/living/spawned, mob/M, latejoin)
	. = ..()
	var/mob/living/silicon/ai/AI = spawned

	AI.relocate(TRUE, TRUE)
	
	var/total_available_cpu = 1 - AI.ai_network.resources.total_cpu_assigned()
	var/total_available_ram = AI.ai_network.resources.total_ram() - AI.ai_network.resources.total_ram_assigned()

	AI.ai_network.resources.set_cpu(AI, total_available_cpu)
	AI.ai_network.resources.add_ram(AI, total_available_ram) 

	AI.apply_pref_name(/datum/preference/name/ai, M.client)			//If this runtimes oh well jobcode is fucked.
	AI.set_core_display_icon(null, M.client)

	//we may have been created after our borg
	if(SSticker.current_state == GAME_STATE_SETTING_UP)
		for(var/mob/living/silicon/robot/R in GLOB.silicon_mobs)
			if(!R.connected_ai)
				R.TryConnectToAI()

	if(latejoin)
		announce(AI)

/datum/job/ai/override_latejoin_spawn()
	return TRUE

/datum/job/ai/special_check_latejoin(client/C)
	if(!do_special_check)
		return TRUE
	if(GLOB.ai_list.len && !SSticker.triai)
		return FALSE
	if(SSticker.triai && GLOB.ai_list.len >= 3)
		return FALSE
	for(var/i in GLOB.data_cores)
		var/obj/machinery/ai/data_core/core = i
		if(istype(core))
			if(core.valid_data_core())
				return TRUE
	return FALSE


/datum/job/ai/announce(mob/living/silicon/ai/AI)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[AI] has been downloaded to the central AI network.")) //YOGS - removed the co-ordinates

/datum/job/ai/config_check()
	return CONFIG_GET(flag/allow_ai)
