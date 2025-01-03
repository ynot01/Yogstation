/datum/job/brigphysician
	title = "Brig Physician"
	description = "Watch over the Brig and Prison Wing to ensure prisoners receive medical attention when needed."
	orbit_icon = "suitcase-medical"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	minimal_player_age = 5 //seriously stop griefing
	exp_requirements = 100
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/brigphysician

	alt_titles = list("Security Medic", "Security Medical Support", "Penitentiary Medical Care Unit", "Junior Brig Physician", "Detention Center Health Officer") 

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
		/datum/job_department/security,
	)

	added_access = list(ACCESS_SURGERY, ACCESS_CLONING)
	base_access = list(ACCESS_MEDICAL, ACCESS_SEC_BASIC, ACCESS_BRIG_PHYS, ACCESS_MORGUE,
					ACCESS_BRIG, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MECH_MEDICAL)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_BRIG_PHYSICIAN

	smells_like = "crimson guardianship"

	minimal_lightup_areas = list(/area/medical/morgue)
	
	mail_goodies = list(
		/obj/item/storage/firstaid/regular = 20,
		/obj/item/reagent_containers/autoinjector/medipen/atropine = 10,
		/obj/item/storage/firstaid/hypospray/brute = 10,
		/obj/item/storage/firstaid/hypospray/burn = 10,
		/obj/item/stack/medical/suture/medicated = 5,
		/obj/item/stack/medical/mesh/advanced = 5,
		/obj/item/reagent_containers/spray/pepper = 4
	)

/datum/outfit/job/brigphysician
	name = "Brig Physician"
	jobtype = /datum/job/brigphysician

	pda_type = /obj/item/modular_computer/tablet/pda/preset/medical/paramed

	backpack_contents = list(/obj/item/roller = 1)
	belt = /obj/item/storage/belt/medical
	ears = /obj/item/radio/headset/headset_medsec
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	shoes = /obj/item/clothing/shoes/jackboots
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/jackboots
	uniform = /obj/item/clothing/under/yogs/rank/physician/white
	uniform_skirt = /obj/item/clothing/under/yogs/rank/physician/white/skirt
	suit = /obj/item/clothing/suit/toggle/labcoat/emt/physician
	l_hand = /obj/item/storage/firstaid/regular
	r_hand = /obj/item/modular_computer/laptop/preset/paramedic/brig_physician
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	head = /obj/item/clothing/head/soft/emt/phys
	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	implants = list(/obj/item/implant/mindshield)
