/datum/job/detective
	title = "Detective"
	description = "Investigate crimes, gather evidence, perform interrogations, \
		look badass, smoke cigarettes."
	flag = DETECTIVE
	orbit_icon = "user-secret"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 180
	exp_type = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/detective

	alt_titles = list("Investigator", "Forensic Analyst", "Investigative Cadet", "Private Eye", "Inspector")

	added_access = list()
	base_access = list(ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_COURT, ACCESS_BRIG, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DETECTIVE
	minimal_character_age = 22 //Understanding of forensics, crime analysis, and theory. Less of a grunt officer and more of an intellectual, theoretically, despite how this is never reflected in-game

	departments_list = list(
		/datum/job_department/security,
	)

	mail_goodies = list(
		///obj/item/storage/fancy/cigarettes = 25,
		/obj/item/ammo_box/c38 = 25,
		///obj/item/ammo_box/c38/dumdum = 5,
		/obj/item/ammo_box/c38/hotshot = 5,
		/obj/item/ammo_box/c38/iceblox = 5,
		///obj/item/ammo_box/c38/match = 5,
		/obj/item/ammo_box/tra32 = 5,
		///obj/item/storage/belt/holster/detective/full = 1
	)

	smells_like = "whisky-soaked despair"

/datum/outfit/job/detective
	name = "Detective"
	jobtype = /datum/job/detective

	pda_type = /obj/item/modular_computer/tablet/pda/preset/basic

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/det
	uniform_skirt = /obj/item/clothing/under/rank/det/skirt
	neck = /obj/item/clothing/neck/tie/detective
	shoes = /obj/item/clothing/shoes/sneakers/brown
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/jackboots
	suit = /obj/item/clothing/suit/det_suit
	gloves = /obj/item/clothing/gloves/color/black/forensic
	head = /obj/item/clothing/head/fedora/det_hat
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/lighter
	backpack_contents = list(/obj/item/storage/box/evidence=1,\
		/obj/item/detective_scanner=1,\
		/obj/item/melee/classic_baton=1)
	mask = /obj/item/clothing/mask/cigarette

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/gun/ballistic/revolver/detective, /obj/item/clothing/glasses/sunglasses)

/datum/outfit/job/detective/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
	if(istype(cig)) //Some species specfic changes can mess this up (plasmamen)
		cig.light("")

	if(visualsOnly)
		return

