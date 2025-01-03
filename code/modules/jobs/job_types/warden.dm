/datum/job/warden
	title = "Warden"
	description = "Watch over the Brig and Prison Wing, release prisoners when \
		their time is up, issue equipment to security, be a security officer when \
		they all eventually die."
	orbit_icon = "handcuffs"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	minimal_player_age = 7
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/warden

	alt_titles = list("Brig Watchman", "Brig Superintendent", "Security Dispatcher", "Prison Supervisor")

	added_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_DETECTIVE)
	base_access = list(ACCESS_SECURITY, ACCESS_ARMORY, ACCESS_SEC_BASIC, ACCESS_BRIG,
					ACCESS_MECH_SECURITY, ACCESS_WEAPONS_PERMIT, ACCESS_BRIG_PHYS, ACCESS_EXTERNAL_AIRLOCKS) // See /datum/job/warden/get_access()

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WARDEN
	minimal_character_age = 20 //You're a sergeant, probably has some experience in the field

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_NONE,
		SKILL_FITNESS = EXP_HIGH,
	)
	skill_points = 2

	departments_list = list(
		/datum/job_department/security,
	)

	mail_goodies = list(
		/obj/item/storage/box/handcuffs = 10,
		/obj/item/storage/box/teargas = 10,
		/obj/item/storage/box/flashbangs = 10,
		/obj/item/storage/box/rubbershot = 10,
		/obj/effect/spawner/lootdrop/techshell = 10,
		/obj/item/storage/box/lethalshot = 5
	)

	lightup_areas = list(/area/security/detectives_office)
	minimal_lightup_areas = list(/area/security/warden)
	
	smells_like = "gunpowdery justice"

/datum/job/warden/get_access()
	var/list/L = list()
	L = ..() | check_config_for_sec_maint()
	return L

/datum/job/warden/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	if(M?.client?.prefs)
		var/obj/item/badge/security/badge
		switch(M.client.prefs.exp[title] / 60)
			if(200 to INFINITY)
				badge = new /obj/item/badge/security/warden3
			if(50 to 200)
				badge = new /obj/item/badge/security/warden2
			else
				badge = new /obj/item/badge/security/warden1
		badge.owner_string = H.real_name
		var/obj/item/clothing/suit/my_suit = H.wear_suit
		my_suit.attach_badge(badge)

/datum/outfit/job/warden
	name = "Warden"
	jobtype = /datum/job/warden

	pda_type = /obj/item/modular_computer/tablet/pda/preset/security/warden

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/warden
	uniform_skirt = /obj/item/clothing/under/rank/security/warden/skirt
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
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = /obj/item/gun/ballistic/shotgun/automatic/combat/compact

