/datum/job/chief_engineer
	title = "Chief Engineer"
	description = "Coordinate engineering, ensure equipment doesn't get stolen, \
		make sure the Supermatter doesn't blow up, maintain telecommunications."
	orbit_icon = "user-astronaut"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 1500 //25 hours
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_ENGINEERING
	alt_titles = list("Engineering Director", "Head of Engineering", "Senior Engineer", "Chief Engineering Officer")

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_MID,
		SKILL_TECHNICAL = EXP_MID,
		SKILL_SCIENCE = EXP_LOW,
		SKILL_FITNESS = EXP_NONE,
	)
	skill_points = 4 // lots of different skills required

	outfit = /datum/outfit/job/ce

	added_access = list(ACCESS_CAPTAIN, ACCESS_AI_MASTER)
	base_access = list(ACCESS_COMMAND, ACCESS_ENGINEERING, ACCESS_CE, ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS,
					ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ENGINE_EQUIP, ACCESS_CONSTRUCTION, ACCESS_TECH_STORAGE,
					ACCESS_SECURE_TECH, ACCESS_TCOMMS, ACCESS_TCOMMS_ADMIN, ACCESS_AUX_BASE,
					ACCESS_MECH_ENGINE, ACCESS_SEC_BASIC, ACCESS_EVA, ACCESS_AI_SAT,
					ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_ENG

	display_order = JOB_DISPLAY_ORDER_CHIEF_ENGINEER
	minimal_character_age = 30 //Combine all the jobs together; that's a lot of physics, mechanical, electrical, and power-based knowledge

	departments_list = list(
		/datum/job_department/engineering,
		/datum/job_department/command,
	)

	mail_goodies = list(
		/obj/item/reagent_containers/food/snacks/cracker = 25, //you know. for poly
		/obj/item/stack/sheet/mineral/diamond = 15,
		/obj/item/stack/sheet/mineral/gold = 15,
		/obj/effect/spawner/lootdrop/engineering_tool_advanced = 3,
		/obj/effect/spawner/lootdrop/engineering_tool_alien = 1
	)

	minimal_lightup_areas = list(/area/crew_quarters/heads/chief, /area/engine/atmos)

	smells_like = "industry leadership"

/datum/outfit/job/ce
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/tablet/phone/preset/advanced/command/ce

	belt = /obj/item/storage/belt/utility/chief/full
	ears = /obj/item/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/rank/engineering/chief_engineer
	uniform_skirt = /obj/item/clothing/under/rank/engineering/chief_engineer/skirt
	shoes = /obj/item/clothing/shoes/sneakers/brown
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/command
	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/atmos/ce
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1) //yogs - removes eng budget
	glasses = /obj/item/clothing/glasses/meson/sunglasses/ce

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	chameleon_extras = /obj/item/stamp/ce

	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/ce/rig
	name = "Chief Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine/elite
	shoes = /obj/item/clothing/shoes/magboots/advance
	suit_store = /obj/item/tank/internals/oxygen
	glasses = /obj/item/clothing/glasses/meson/sunglasses
	gloves = /obj/item/clothing/gloves/color/yellow
	head = null
	internals_slot = ITEM_SLOT_SUITSTORE
