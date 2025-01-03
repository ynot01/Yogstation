/datum/job/hydro
	title = "Botanist"
	description = "Grow plants for the cook, for medicine, and for recreation."
	orbit_icon = "seedling"
	department_head = list("Head of Personnel")
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the head of personnel"

	outfit = /datum/outfit/job/botanist

	alt_titles = list("Ecologist", "Agriculturist", "Botany Greenhorn", "Hydroponicist", "Gardener")

	added_access = list(ACCESS_BAR, ACCESS_KITCHEN)
	base_access = list(ACCESS_SERVICE, ACCESS_HYDROPONICS, ACCESS_MORGUE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BOTANIST
	minimal_character_age = 22 //Biological understanding of plants and how to manipulate their DNAs and produces relatively "safely". Not just something that comes to you without education

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_MID,
		SKILL_FITNESS = EXP_NONE,
	)
	skill_points = 3

	departments_list = list(
		/datum/job_department/service,
	)

	mail_goodies = list(
		/obj/item/reagent_containers/glass/bottle/mutagen = 20,
		/obj/item/reagent_containers/glass/bottle/saltpetre = 20,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 20,
		/obj/item/gun/energy/floragun = 10,
		/obj/effect/spawner/lootdrop/seed_rare = 5,// These are strong, rare seeds, so use sparingly.
		/obj/item/reagent_containers/food/snacks/monkeycube/bee = 2
	)

	minimal_lightup_areas = list(/area/hydroponics, /area/medical/morgue)
	
	smells_like = "fertilizer"

/datum/outfit/job/botanist
	name = "Botanist"
	jobtype = /datum/job/hydro

	pda_type = /obj/item/modular_computer/tablet/pda/preset/botanist

	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	uniform_skirt = /obj/item/clothing/under/rank/civilian/hydroponics/skirt
	suit = /obj/item/clothing/suit/apron
	gloves  =/obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/plant_analyzer

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd


