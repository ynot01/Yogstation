/datum/job/paramedic
	title = "Paramedic"
	description = "Constantly reminder the crew about their suit sensor. Come to their aid when they die."
	flag = PARAMEDIC
	orbit_icon = "truck-medical"
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#d4ebf2"
	alt_titles = list("EMT", "Paramedic Trainee", "Rapid Response Medic", "Space Search & Rescue")

	outfit = /datum/outfit/job/paramedic

	added_access = list(ACCESS_CLONING)
	base_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_PARAMEDIC, ACCESS_MECH_MEDICAL)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_PARAMEDIC
	minimal_character_age = 20 //As a paramedic you just need to know basic first aid and handling of patients in shock. Ideally you're also strong and able to stay cool. You don't know surgery

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

	smells_like = "pre-packaged oxygen"

/datum/outfit/job/paramedic
	name = "Paramedic"
	jobtype = /datum/job/paramedic

	pda_type = /obj/item/modular_computer/tablet/pda/preset/paramed

	backpack_contents = list(/obj/item/storage/firstaid/regular)
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/toggle/labcoat/emt
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_hand = /obj/item/roller
	l_pocket = /obj/item/flashlight/pen/paramedic
	r_pocket = /obj/item/gps
	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
