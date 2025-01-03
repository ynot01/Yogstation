/datum/job/virologist
	title = "Virologist"
	description = "Study the effects of various diseases and synthesize a \
		vaccine for them. Engineer beneficial viruses."
	orbit_icon = "virus"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	exp_type = EXP_TYPE_CREW
	exp_requirements = 120
	minimal_player_age = 7
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/virologist

	alt_titles = list("Microbiologist", "Pathologist", "Junior Disease Researcher", "Epidemiologist", "Disease Control Expert")

	added_access = list(ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_GENETICS, ACCESS_CLONING)
	base_access = list(ACCESS_MEDICAL, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_VIROLOGIST
	minimal_character_age = 24 //Requires understanding of microbes, biology, infection, and all the like, as well as being able to understand how to interface the machines. Epidemiology is no joke of a field

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_MID,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_MID,
		SKILL_FITNESS = EXP_NONE,
	)
	skill_points = 2

	departments_list = list(
		/datum/job_department/medical,
	)

	mail_goodies = list(
		/obj/item/reagent_containers/glass/bottle/random_virus = 15,
		/obj/item/reagent_containers/glass/bottle/formaldehyde = 10,
		/obj/item/reagent_containers/glass/bottle/synaptizine = 10,
		/obj/item/stack/sheet/mineral/plasma = 10,
		/obj/item/stack/sheet/mineral/uranium = 5,
		/obj/item/reagent_containers/glass/bottle/fake_gbs = 4,
		/obj/item/reagent_containers/glass/bottle/magnitis = 3,
		/obj/item/reagent_containers/glass/bottle/pierrot_throat = 3,
		/obj/item/reagent_containers/glass/bottle/jitters = 3,
		/obj/item/reagent_containers/glass/bottle/anxiety = 3
	)

	lightup_areas = list(
		/area/medical/morgue,
		/area/medical/surgery,
		/area/medical/genetics,
		/area/medical/chemistry
	)
	minimal_lightup_areas = list(/area/medical/virology)
	
	smells_like = "germlessness"

/datum/outfit/job/virologist
	name = "Virologist"
	jobtype = /datum/job/virologist

	pda_type = /obj/item/modular_computer/tablet/pda/preset/medical/viro

	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/virologist
	uniform_skirt = /obj/item/clothing/under/rank/medical/virologist/skirt
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/flashlight/pen

	backpack = /obj/item/storage/backpack/virology
	satchel = /obj/item/storage/backpack/satchel/vir
	duffelbag = /obj/item/storage/backpack/duffelbag/med
