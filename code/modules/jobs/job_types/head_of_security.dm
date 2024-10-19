/datum/job/hos
	title = "Head of Security"
	description = "Coordinate security personnel, ensure they are not corrupt, \
		make sure every department is protected."
	orbit_icon = "user-shield"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY|DEADMIN_POSITION_CRITICAL
	department_head = list("Captain")
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 1500 //25 hours
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	alt_titles = list("Security Commander", "Security Chief", "Chief Security Officer")

	outfit = /datum/outfit/job/hos
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	added_access = list(ACCESS_CAPTAIN, ACCESS_AI_MASTER)
	base_access = list(ACCESS_COMMAND, ACCESS_SECURITY, ACCESS_HOS, ACCESS_SEC_BASIC,
					ACCESS_BRIG, ACCESS_ARMORY, ACCESS_DETECTIVE, ACCESS_BRIG_PHYS,
					ACCESS_WEAPONS_PERMIT, ACCESS_LAWYER, ACCESS_MECH_SECURITY,
					ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_SURGERY, ACCESS_PARAMEDIC,
					ACCESS_ENGINEERING, ACCESS_ATMOSPHERICS, ACCESS_CONSTRUCTION, ACCESS_AUX_BASE,
					ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SCIENCE, ACCESS_TOXINS, ACCESS_EXPERIMENTATION,
					ACCESS_XENOBIOLOGY, ACCESS_ROBOTICS, ACCESS_AI_SAT, ACCESS_CARGO,
					ACCESS_CARGO_BAY, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAINT_TUNNELS,
					ACCESS_EVA, ACCESS_PERSONAL_LOCKERS, ACCESS_VAULT, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY
	minimal_character_age = 28 //You need some experience on your belt and a little gruffiness; you're still a foot soldier, not quite a tactician commander back at base

	departments_list = list(
		/datum/job_department/security,
		/datum/job_department/command,
	)

	mail_goodies = list(
		/obj/item/stack/sheet/plastic/five = 20, //need that plastic chair
		/obj/item/clothing/head/hatsky = 10,
		/obj/item/disk/nuclear/fake = 5,
		/obj/item/melee/chainofcommand/tailwhip = 3,
		/obj/item/melee/chainofcommand/tailwhip/kitty = 2,
		/obj/item/kitchen/knife/combat = 2
	)

	minimal_lightup_areas = list(
		/area/crew_quarters/heads/hos,
		/area/security/detectives_office,
		/area/security/warden
	)
	
	smells_like = "deadly authority"

/datum/job/hos/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	if(M?.client?.prefs)
		var/obj/item/badge/security/badge
		switch(M.client.prefs.exp[title] / 60)
			if(200 to INFINITY)
				badge = new /obj/item/badge/security/hos3
			if(50 to 200)
				badge = new /obj/item/badge/security/hos2
			else
				badge = new /obj/item/badge/security/hos1
		badge.owner_string = H.real_name
		var/obj/item/clothing/suit/my_suit = H.wear_suit
		my_suit.attach_badge(badge)

/datum/outfit/job/hos
	name = "Head of Security"
	jobtype = /datum/job/hos

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/tablet/phone/preset/advanced/command/hos

	belt = /obj/item/storage/belt/security/chief/full
	ears = /obj/item/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/rank/security/head_of_security
	uniform_skirt = /obj/item/clothing/under/rank/security/head_of_security/skirt
	shoes = /obj/item/clothing/shoes/jackboots
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/jackboots
	suit = /obj/item/clothing/suit/armor/hos/trenchcoat
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/HoS/beret
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/hos
	suit_store = /obj/item/gun/energy/e_gun

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/gun/energy/e_gun/hos, /obj/item/stamp/hos)

	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/hos/hardsuit
	name = "Head of Security (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/security/hos
	suit_store = /obj/item/tank/internals/oxygen
	backpack_contents = list(/obj/item/melee/baton/loaded=1, /obj/item/gun/energy/e_gun=1)

