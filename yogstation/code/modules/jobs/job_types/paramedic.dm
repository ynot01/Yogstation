/datum/job/paramedic
	title = "Paramedic"
	description = "Constantly reminder the crew about their suit sensor. Come to their aid when they die."
	orbit_icon = "truck-medical"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief medical officer"
	alt_titles = list("EMT", "Paramedic Trainee", "Rapid Response Medic", "Space Search & Rescue")

	outfit = /datum/outfit/job/paramedic

	added_access = list(ACCESS_SURGERY, ACCESS_CLONING)
	base_access = list(ACCESS_MEDICAL, ACCESS_PARAMEDIC, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS,
					ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MECH_MEDICAL)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_PARAMEDIC
	minimal_character_age = 20 //As a paramedic you just need to know basic first aid and handling of patients in shock. Ideally you're also strong and able to stay cool. You don't know surgery

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
	)

	mail_goodies = list(
		/obj/item/reagent_containers/autoinjector/medipen = 10,//these are already super plentiful
		/obj/item/reagent_containers/autoinjector/medipen/atropine = 15,
		/obj/item/reagent_containers/autoinjector/medipen/ekit = 15,
		/obj/item/reagent_containers/autoinjector/medipen/blood_loss = 10,
		/obj/item/reagent_containers/autoinjector/medipen/survival = 5
	)

	lightup_areas = list(/area/medical/surgery)
	minimal_lightup_areas = list(
		/area/storage/eva,
		/area/medical/morgue,
		/area/medical/genetics/cloning
	)

	smells_like = "pre-packaged oxygen"

/datum/outfit/job/paramedic
	name = "Paramedic"
	jobtype = /datum/job/paramedic

	pda_type = /obj/item/modular_computer/tablet/pda/preset/medical/paramed

	backpack_contents = list(/obj/item/storage/firstaid/regular)
	ears = /obj/item/radio/headset/headset_med
	belt = /obj/item/storage/belt/medical
	uniform = /obj/item/clothing/under/rank/medical/doctor
	uniform_skirt = /obj/item/clothing/under/rank/medical/doctor/skirt
	suit = /obj/item/clothing/suit/toggle/labcoat/emt
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_hand = /obj/item/roller
	l_pocket = /obj/item/flashlight/pen/paramedic
	r_pocket = /obj/item/gps
	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
