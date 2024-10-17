/datum/job/doctor
	title = "Medical Doctor"
	description = "Save lives, run around the station looking for victims, \
		scan everyone in sight"
	orbit_icon = "staff-snake"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	alt_titles = list("Physician", "Surgeon", "Nurse", "Medical Resident", "Attending Physician", "General Practitioner")

	outfit = /datum/outfit/job/doctor

	added_access = list(ACCESS_CHEMISTRY, ACCESS_GENETICS, ACCESS_VIROLOGY)
	base_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CLONING,
					ACCESS_MECH_MEDICAL)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	minimal_character_age = 26 //Barely acceptable considering the theoretically absurd knowledge they have, but fine

	departments_list = list(
		/datum/job_department/medical,
	)

	mail_goodies = list(
		/obj/item/healthanalyzer/advanced = 15,
		/obj/effect/spawner/lootdrop/surgery_tool_advanced = 6,
		/obj/item/reagent_containers/autoinjector/medipen = 6,
		/obj/effect/spawner/lootdrop/organ_spawner = 5,
		/obj/effect/spawner/lootdrop/memeorgans = 1
	)

	lightup_areas = list(
		/area/medical/genetics,
		/area/medical/virology,
		/area/medical/chemistry
	)
	minimal_lightup_areas = list(
		/area/medical/morgue,
		/area/medical/surgery,
		/area/medical/genetics/cloning
	)

	smells_like = "a hospital"

/datum/outfit/job/doctor
	name = "Medical Doctor"
	jobtype = /datum/job/doctor
	belt = /obj/item/storage/belt/medical
	ears = /obj/item/radio/headset/headset_med
	pda_type = /obj/item/modular_computer/tablet/pda/preset/medical
	uniform = /obj/item/clothing/under/rank/medical/doctor
	uniform_skirt = /obj/item/clothing/under/rank/medical/doctor/skirt
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/md
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	chameleon_extras = /obj/item/gun/syringe

/datum/outfit/job/doctor/dead
	name = "Medical Doctor"
	jobtype = /datum/job/doctor
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/md
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
