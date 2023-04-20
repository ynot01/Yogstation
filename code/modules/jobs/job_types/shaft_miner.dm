/datum/job/mining
	title = "Shaft Miner"
	description = "Travel to strange lands. Mine ores. \
		Meet strange creatures. Kill them for their gold."
	flag = MINER
	orbit_icon = "digging"
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dcba97"
	alt_titles = list("Lavaland Scout", "Prospector", "Junior Miner", "Major Miner", "Surveyor")

	outfit = /datum/outfit/job/miner

	added_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_QM)
	base_access = list(ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SHAFT_MINER
	minimal_character_age = 18 //Young and fresh bodies for a high mortality job, what more could you ask for

	departments_list = list(
		/datum/job_department/cargo,
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

	pda_type = /obj/item/modular_computer/tablet/pda/preset/basic

	ears = /obj/item/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/cargo
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/miner/lavaland
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
	box = /obj/item/storage/box/survival_mining
	ipc_box = /obj/item/storage/box/ipc/miner

	chameleon_extras = /obj/item/gun/energy/kinetic_accelerator

/datum/outfit/job/miner/equipped
	name = "Shaft Miner (Equipment)"
	suit = /obj/item/clothing/suit/hooded/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	glasses = /obj/item/clothing/glasses/meson
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = SLOT_S_STORE
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

