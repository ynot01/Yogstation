/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	description = "Get your space legs, assist people, ask the HoP to give you a job."
	flag = ASSISTANT
	orbit_icon = "toolbox"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	added_access = list()			//See /datum/job/assistant/get_access()
	base_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT
	minimal_character_age = 18 //Would make it even younger if I could because this role turns men into little brat boys and likewise for the other genders

	department_for_prefs = /datum/job_department/assistant

	mail_goodies = list(
		/obj/item/reagent_containers/food/snacks/donkpocket = 10,
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/gloves/color/fyellow = 7,
		/obj/item/choice_beacon/music = 5,
		/obj/item/toy/crayon/spraycan = 3,
		/obj/item/crowbar/large = 1
	)

	alt_titles = list("Intern", "Apprentice", "Subordinate", "Temporary Worker", "Associate")

/datum/job/assistant/get_access()
	. = ..()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. |= list(ACCESS_MAINT_TUNNELS)

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	if (CONFIG_GET(flag/grey_assistants))
		uniform = /obj/item/clothing/under/color/grey
		uniform_skirt = /obj/item/clothing/under/skirt/color/grey
	else
		uniform = /obj/item/clothing/under/color/random
		uniform_skirt = /obj/item/clothing/under/skirt/color/random
	return ..()


/datum/outfit/job/assistant/consistent
	name = "Assistant - Consistent"

/datum/outfit/job/assistant/consistent/pre_equip(mob/living/carbon/human/target)
	..()
	uniform = /obj/item/clothing/under/color/grey

/datum/outfit/job/assistant/consistent/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	// This outfit is used by the assets SS, which is ran before the atoms SS
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
	//	H.w_uniform?.update_greyscale()
		H.update_inv_w_uniform()
