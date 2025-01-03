/datum/job/mining
	title = "Shaft Miner"
	description = "Travel to strange lands. Mine ores. \
		Meet strange creatures. Kill them for their gold."
	orbit_icon = "digging"
	department_head = list("Head of Personnel")
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	alt_titles = list("Lavaland Scout", "Prospector", "Junior Miner", "Major Miner", "Surveyor")

	outfit = /datum/outfit/job/miner

	added_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO_BAY, ACCESS_QM, ACCESS_SCIENCE,
					ACCESS_RESEARCH, ACCESS_AUX_BASE)
	base_access = list(ACCESS_CARGO, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MECH_MINING)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SHAFT_MINER
	minimal_character_age = 18 //Young and fresh bodies for a high mortality job, what more could you ask for

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_NONE,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_NONE,
		SKILL_FITNESS = EXP_HIGH,
	)
	skill_points = 2 // "unskilled" labor

	departments_list = list(
		/datum/job_department/cargo,
	)

	minimal_lightup_areas = list(
		/area/construction/mining/aux_base
	)

	mail_goodies = list(
		/obj/item/reagent_containers/autoinjector/medipen/survival = 10,
		/obj/item/grenade/plastic/miningcharge/lesser = 10,
		/obj/item/card/mining_point_card = 10,
		/obj/item/grenade/plastic/miningcharge = 5,
		/obj/item/card/mining_point_card/thousand = 5,
		/obj/item/grenade/plastic/miningcharge/mega = 1,
		/obj/item/card/mining_point_card/fivethousand = 1
	)

	smells_like = "ash and dust"

/datum/outfit/job/miner
	name = "Shaft Miner"
	jobtype = /datum/job/mining

	pda_type = /obj/item/modular_computer/tablet/pda/preset/shaft_miner

	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/cargo/cleated
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
	neck = /obj/item/clothing/neck/bodycam/miner
	l_pocket = /obj/item/wormhole_jaunter
	r_pocket = /obj/item/flashlight/seclite
	backpack_contents = list(
		/obj/item/storage/bag/ore = 1,\
		/obj/item/kitchen/knife/combat/survival = 1,\
		/obj/item/mining_voucher = 1,\
		/obj/item/stack/marker_beacon/ten = 1,\
		/obj/item/reagent_containers/autoinjector/medipen/survival = 1
		)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag
	box = /obj/item/storage/box/survival/mining

	chameleon_extras = /obj/item/gun/energy/kinetic_accelerator

/datum/outfit/job/miner/equipped
	name = "Shaft Miner (Equipment)"
	suit = /obj/item/clothing/suit/hooded/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = list(
		/obj/item/storage/bag/ore=1,
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/kinetic_accelerator=1,\
		/obj/item/stack/marker_beacon/ten=1)

/datum/outfit/job/miner/equipped/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(istype(H.wear_suit, /obj/item/clothing/suit/hooded))
		var/obj/item/clothing/suit/hooded/S = H.wear_suit
		S.ToggleHood()

/datum/outfit/job/miner/equipped/hardsuit
	name = "Shaft Miner (Equipment + Hardsuit)"
	suit = /obj/item/clothing/suit/space/hardsuit/mining
	mask = /obj/item/clothing/mask/breath

