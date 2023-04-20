/datum/job/warden
	title = "Warden"
	description = "Watch over the Brig and Prison Wing, release prisoners when \
		their time is up, issue equipment to security, be a security officer when \
		they all eventually die."
	flag = WARDEN
	orbit_icon = "handcuffs"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/warden

	alt_titles = list("Brig Watchman", "Brig Superintendent", "Security Staff Sergeant", "Security Dispatcher", "Prison Supervisor")

	added_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_FORENSICS_LOCKERS)
	base_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_MECH_SECURITY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM) // See /datum/job/warden/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WARDEN
	minimal_character_age = 20 //You're a sergeant, probably has some experience in the field

	departments_list = list(
		/datum/job_department/security,
	)

	mail_goodies = list(
		/obj/item/storage/box/fancy/cigarettes = 15,
		/obj/item/storage/box/handcuffs = 10,
		/obj/item/storage/box/teargas = 10,
		/obj/item/storage/box/flashbangs = 10,
		/obj/item/storage/box/rubbershot = 10,
		/obj/effect/spawner/lootdrop/techshell = 10,
		/obj/item/storage/box/lethalshot = 5
	)

	smells_like = "gunpowdery justice"

/datum/job/warden/get_access()
	var/list/L = list()
	L = ..() | check_config_for_sec_maint()
	return L

/datum/outfit/job/warden
	name = "Warden"
	jobtype = /datum/job/warden

	pda_type = /obj/item/modular_computer/tablet/pda/preset/warden

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/warden
	uniform_skirt = /obj/item/clothing/under/rank/warden/skirt
	shoes = /obj/item/clothing/shoes/jackboots
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/jackboots
	suit = /obj/item/clothing/suit/armor/vest/warden/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/warden
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	r_pocket = /obj/item/assembly/flash/handheld
	l_pocket = /obj/item/restraints/handcuffs
	backpack_contents = list(/obj/item/melee/baton/loaded=1) //yogs - ~~added departmental budget ID~~ removes sec budget

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = /obj/item/gun/ballistic/shotgun/automatic/combat/compact

