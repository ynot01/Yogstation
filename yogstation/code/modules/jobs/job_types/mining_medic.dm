/datum/job/miningmedic
	title = "Mining Medic"
	description = "Watch over the Shaft Miners as they all inevitably die on Lavaland."
	orbit_icon = "kit-medical"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer and the quartermaster"
	minimal_player_age = 4
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/miningmedic

	alt_titles = list("Mining Medical Support", "Lavaland Medical Care Unit", "Planetside Health Officer", "Land Search & Rescue", "Lavaland EMT")

	minimal_character_age = 26 //Matches MD

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_MID,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_NONE,
		SKILL_FITNESS = EXP_MID,
	)
	skill_points = 2

	departments_list = list(
		/datum/job_department/medical,
		/datum/job_department/cargo,
	)
	
	minimal_lightup_areas = list(
		/area/construction/mining/aux_base
	)

	//if it's skeleton there's probably no paramedic to save spaced miners that jaunted away from danger
	added_access = list(ACCESS_SURGERY, ACCESS_CARGO_BAY, ACCESS_CLONING, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS)
	base_access = list(ACCESS_CARGO, ACCESS_MEDICAL, ACCESS_MINING, ACCESS_MINING_STATION,
					ACCESS_MORGUE, ACCESS_MECH_MINING, ACCESS_MECH_MEDICAL)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_MINING_MEDIC

	smells_like = "bloody soot"
	mail_goodies = list(
		/obj/item/reagent_containers/autoinjector/medipen/survival = 30,
		/obj/item/extraction_pack = 5,
		/obj/item/storage/firstaid/hypospray/advanced = 5,
		/obj/item/fulton_core = 1
	)

/datum/outfit/job/miningmedic
	name = "Mining Medic"
	jobtype = /datum/job/miningmedic

	pda_type = /obj/item/modular_computer/tablet/pda/preset/medical/paramed

	backpack_contents = list(/obj/item/roller = 1,\
		/obj/item/kitchen/knife/combat/survival = 1,\
		/obj/item/reagent_containers/autoinjector/medipen/survival = 1,\
		/obj/item/modular_computer/laptop/preset/paramedic/mining_medic = 1,\
		/obj/item/storage/firstaid/hypospray/qmc = 1)

	ears = /obj/item/radio/headset/headset_medcargo
	glasses = /obj/item/clothing/glasses/hud/health/meson

	suit = /obj/item/clothing/suit/hooded/miningmedic
	uniform = /obj/item/clothing/under/yogs/rank/miner/medic

	belt = /obj/item/storage/belt/medical/mining
	gloves = /obj/item/clothing/gloves/color/latex/fireproof
	l_pocket = /obj/item/wormhole_jaunter

	shoes = /obj/item/clothing/shoes/workboots/mining
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/medical

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	box = /obj/item/storage/box/survival/mining
	pda_slot = ITEM_SLOT_LPOCKET
