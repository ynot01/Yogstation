/datum/job/rd
	title = "Research Director"
	description = "Supervise research efforts, ensure Robotics is in working \
		order, make sure the AI and its Cyborgs aren't rogue, replacing them if \
		they are"
	orbit_icon = "user-graduate"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	head_announce = list("Science")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_type_department = EXP_TYPE_SCIENCE
	exp_requirements = 900 //15 hours
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCIENCE
	alt_titles = list("Chief Science Officer", "Head of Research", "Chief Technology Officer")

	outfit = /datum/outfit/job/rd

	added_access = list(ACCESS_CAPTAIN)
	base_access = list(ACCESS_COMMAND, ACCESS_SCIENCE, ACCESS_RD, ACCESS_RESEARCH,
					ACCESS_TOXINS, ACCESS_TOXINS_STORAGE, ACCESS_EXPERIMENTATION, ACCESS_GENETICS,
					ACCESS_ROBOTICS, ACCESS_ROBO_CONTROL, ACCESS_XENOBIOLOGY, ACCESS_RND_SERVERS,
					ACCESS_AI_MASTER, ACCESS_AI_SAT, ACCESS_MECH_SCIENCE, ACCESS_TELEPORTER,
					ACCESS_AUX_BASE, ACCESS_SEC_BASIC, ACCESS_MAINT_TUNNELS, ACCESS_RC_ANNOUNCE,
					ACCESS_KEYCARD_AUTH)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SCI

	liver_traits = list(TRAIT_BALLMER_SCIENTIST)

	display_order = JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR
	minimal_character_age = 26 //Barely knows more than actual scientists, just responsibility and AI things

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_MID,
		SKILL_SCIENCE = EXP_HIGH,
		SKILL_FITNESS = EXP_NONE,
	)
	skill_points = 3

	departments_list = list(
		/datum/job_department/science,
		/datum/job_department/command,
	)

	mail_goodies = list(
		/obj/effect/spawner/lootdrop/aimodule_neutral = 15,
		/obj/item/transfer_valve = 15,
		/obj/effect/spawner/lootdrop/aimodule_harmless = 10,
		/obj/item/clothing/mask/facehugger/toy = 5,
		///obj/item/circuitboard/machine/sleeper/party = 3,
		/obj/item/borg/upgrade/ai = 2,
		/obj/effect/spawner/lootdrop/surgery_tool_alien = 2,
		/obj/effect/spawner/lootdrop/engineering_tool_alien = 2,
		/obj/effect/spawner/lootdrop/organ_spawner = 2,
		/obj/item/stack/ore/bluespace_crystal/refined/nt = 1
	)

	minimal_lightup_areas = list(
		/area/crew_quarters/heads/hor,
		/area/science/explab,
		/area/science/misc_lab,
		/area/science/mixing,
		/area/science/nanite,
		/area/science/robotics,
		/area/science/server,
		/area/science/storage,
		/area/science/xenobiology
	)

	smells_like = "theoretical education"

/datum/outfit/job/rd
	name = "Research Director"
	jobtype = /datum/job/rd

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/tablet/phone/preset/advanced/command/rd

	ears = /obj/item/radio/headset/heads/rd
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses/rd
	uniform = /obj/item/clothing/under/rank/rnd/research_director
	uniform_skirt = /obj/item/clothing/under/rank/rnd/research_director/skirt
	shoes = /obj/item/clothing/shoes/sneakers/brown
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/command
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/clipboard
	l_pocket = /obj/item/laser_pointer
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1, /obj/item/multitool/tricorder=1) //yogs - removes sci budget

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

	chameleon_extras = /obj/item/stamp/rd

/datum/outfit/job/rd/rig
	name = "Research Director (Hardsuit)"

	l_hand = null
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/rd
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
