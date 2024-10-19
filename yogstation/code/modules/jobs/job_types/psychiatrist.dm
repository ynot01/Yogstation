/datum/job/psych
	title = "Psychiatrist"
	description = "Diagnose crew members with psychological issues and aid their treatment."
	orbit_icon = "brain"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	alt_titles = list("Counsellor", "Therapist", "Mentalist")
	minimal_player_age = 5 //stop griefing

	outfit = /datum/outfit/job/psych

	added_access = list(ACCESS_CHEMISTRY)
	base_access = list(ACCESS_MEDICAL, ACCESS_PSYCHOLOGY)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	mind_traits = list(TRAIT_PSYCH)
	display_order = JOB_DISPLAY_ORDER_PSYCHIATRIST
	minimal_character_age = 24 //Psychology, therapy, and the like; all branches that would probably need to be certified as properly educated

	departments_list = list(
		/datum/job_department/medical,
	)

	mail_goodies = list(
		/obj/item/storage/box/hug = 30,
		/obj/item/storage/pill_bottle/mannitol = 25,
		/obj/item/storage/pill_bottle/happy = 10,
		/obj/item/storage/pill_bottle/stimulant = 10,
		/obj/item/reagent_containers/glass/bottle/morphine = 5, //lmao
		/obj/item/assembly/flash/handheld = 4,
		/obj/item/gun/ballistic/revolver/russian = 1
	)

	smells_like = "calm peace"

/datum/job/psych/proc/GaxStationChanges() // I'M SORRY
	return TRUE

/datum/outfit/job/psych
	name = "Psych"
	jobtype = /datum/job/psych

	shoes = /obj/item/clothing/shoes/sneakers/brown
	uniform = /obj/item/clothing/under/suit/burgundy
	l_hand = /obj/item/storage/briefcase
	glasses = /obj/item/clothing/glasses/regular
	ears = /obj/item/radio/headset/headset_med
