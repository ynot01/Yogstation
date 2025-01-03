/datum/job/bartender
	title = "Bartender"
	description = "Serve booze, mix drinks, keep the crew drunk."
	orbit_icon = "cocktail"
	department_head = list("Head of Personnel")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	exp_type_department = EXP_TYPE_SERVICE // This is so the jobs menu can work properly

	alt_titles = list("Barkeep", "Tapster", "Barista", "Mixologist")

	outfit = /datum/outfit/job/bartender

	added_access = list(ACCESS_HYDROPONICS, ACCESS_KITCHEN, ACCESS_MORGUE)
	base_access = list(ACCESS_SERVICE, ACCESS_BAR, ACCESS_WEAPONS_PERMIT)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BARTENDER
	minimal_character_age = 21 //I shouldn't have to explain this one

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_NONE,
		SKILL_FITNESS = EXP_MID,
	)
	skill_points = 2

	departments_list = list(
		/datum/job_department/service,
	)

	mail_goodies = list(
		/obj/item/storage/box/beanbag = 30,
		/obj/item/reagent_containers/glass/bottle/clownstears = 10,
		/obj/item/stack/sheet/mineral/plasma = 10,
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/reagent_containers/food/drinks/shaker = 5,
	)

	lightup_areas = list(
		/area/hydroponics,
		/area/medical/morgue,
		/area/crew_quarters/kitchen
	)
	
	smells_like = "alcohol"

/datum/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	pda_type = /obj/item/modular_computer/tablet/pda/preset/fountainpen/bartender

	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/bartender
	uniform_skirt = /obj/item/clothing/under/rank/civilian/bartender/skirt
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(/obj/item/storage/box/beanbag=1)
	shoes = /obj/item/clothing/shoes/laceup
	
/datum/outfit/job/bartender/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	var/obj/item/card/id/W = H.wear_id
	if(H.age < AGE_MINOR)
		W.registered_age = AGE_MINOR
		to_chat(H, span_notice("You're not technically old enough to access or serve alcohol, but your ID has been discreetly modified to display your age as [AGE_MINOR]. Try to keep that a secret!"))
