/datum/job/lawyer
	title = "Lawyer"
	description = "Advocate for prisoners, create law-binding contracts, \
		ensure Security is following protocol and Space Law."
	flag = LAWYER
	orbit_icon = "gavel"
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	var/lawyers = 0 //Counts lawyer amount
	alt_titles = list("Prosecutor", "Defense Attorney", "Paralegal", "Ace Attorney")

	outfit = /datum/outfit/job/lawyer

	added_access = list()
	base_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CIV
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_LAWYER
	minimal_character_age = 24 //Law is already absurd, never mind the wacky-ass shit that is space law

	departments_list = list(
		/datum/job_department/service,
	)

	smells_like = "legal lies"

/datum/outfit/job/lawyer
	name = "Lawyer"
	jobtype = /datum/job/lawyer

	pda_type = /obj/item/modular_computer/tablet/pda/preset/basic/fountainpen

	ears = /obj/item/radio/headset/headset_srvsec
	uniform = /obj/item/clothing/under/lawyer/bluesuit
	uniform_skirt = /obj/item/clothing/under/lawyer/bluesuit/skirt
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/briefcase/lawyer
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge

	chameleon_extras = /obj/item/stamp/law


/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	var/datum/job/lawyer/J = SSjob.GetJobType(jobtype)
	J.lawyers++
	if(J.lawyers>1)
		uniform = /obj/item/clothing/under/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/outfit/job/lawyer/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/under/lawyer/purpsuit
	. += /obj/item/clothing/suit/toggle/lawyer/purple
