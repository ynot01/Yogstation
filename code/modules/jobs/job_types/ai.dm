/datum/job/ai
	title = "AI"
	description = "Assist the crew, follow your laws, coordinate your cyborgs."
	flag = AI_JF
	orbit_icon = "eye"
	auto_deadmin_role_flags = DEADMIN_POSITION_SILICON|DEADMIN_POSITION_CRITICAL
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = TRUE
	minimal_player_age = 30
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SILICON
	display_order = JOB_DISPLAY_ORDER_AI
	var/do_special_check = TRUE

	departments_list = list(
		/datum/job_department/silicon,
	)

	alt_titles = list("Station Central Processor", "Central Silicon Intelligence", "Cyborg Overlord")

	//this should never be seen because of the way olfaction works but just in case
	smells_like = "chained intellect"

/datum/job/ai/equip(mob/living/carbon/human/H, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source = null)
	if(visualsOnly)
		CRASH("dynamic preview is unsupported")
	. = H.AIize(latejoin,preference_source)

/datum/job/ai/after_spawn(mob/H, mob/M, latejoin)
	. = ..()
			
	var/mob/living/silicon/ai/AI = H

	AI.relocate(TRUE)

	var/total_available_cpu = 1 - GLOB.ai_os.total_cpu_assigned()
	var/total_available_ram = GLOB.ai_os.total_ram - GLOB.ai_os.total_ram_assigned()

	GLOB.ai_os.set_cpu(AI, total_available_cpu)
	GLOB.ai_os.add_ram(AI, total_available_ram)

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
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "[AI] has been downloaded to the central AI network.")) //YOGS - removed the co-ordinates

/datum/job/ai/config_check()
	return CONFIG_GET(flag/allow_ai)
