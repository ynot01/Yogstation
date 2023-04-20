/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	lefthand_file = 'icons/mob/inhands/equipment/belt_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/belt_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	max_integrity = 300
	equip_sound = 'sound/items/handling/toolbelt_equip.ogg'
	var/content_overlays = FALSE //If this is true, the belt will gain overlays based on what it's holding

/obj/item/storage/belt/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins belting [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/belt/update_icon()
	cut_overlays()
	if(content_overlays)
		for(var/obj/item/I in contents)
			var/mutable_appearance/M = I.get_belt_overlay()
			add_overlay(M)
	..()

/obj/item/storage/belt/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/belt/utility
	name = "toolbelt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Holds tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	content_overlays = TRUE
	custom_price = 50
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'

/obj/item/storage/belt/utility/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 11
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 24
	STR.set_holdable(list(
		/obj/item/multitool/tricorder,			//yogs tricorder: 'cause making it into the yogs belt dm makes it the only thing a belt can hold
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/geiger_counter,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/holosign_creator/atmos,
		/obj/item/holosign_creator/engineering,
		/obj/item/forcefield_projector,
		/obj/item/assembly/signaler,
		/obj/item/lightreplacer,
		/obj/item/construction/rcd,
		/obj/item/pipe_dispenser,
		/obj/item/inducer,
		/obj/item/holosign_creator/multi/CE,
		/obj/item/airlock_painter,
		/obj/item/grenade/chem_grenade/smart_metal_foam,
		/obj/item/grenade/chem_grenade/metalfoam,
		/obj/item/storage/bag/construction,
		/obj/item/handdrill,
		/obj/item/jawsoflife,
		/obj/item/shuttle_creator, //Yogs: Added this here cause I felt it fits
		/obj/item/barrier_taperoll/engineering,
		/obj/item/storage/bag/sheetsnatcher,
		/obj/item/holotool
		))

/obj/item/storage/belt/utility/makeshift
	name = "makeshift toolbelt"
	desc = "A shoddy holder of tools."
	icon_state = "makeshiftbelt"
	item_state = "makeshiftutility"

/obj/item/storage/belt/utility/makeshift/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7 //It's a very crappy belt
	STR.max_combined_w_class = 16

/obj/item/storage/belt/utility/chief
	name = "\improper Chief Engineer's toolbelt" //"the Chief Engineer's toolbelt", because "Chief Engineer's toolbelt" is not a proper noun
	desc = "Holds tools, looks snazzy."
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"

/obj/item/storage/belt/utility/chief/full
	preload = TRUE

/obj/item/storage/belt/utility/chief/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/handdrill, src)
	SSwardrobe.provide_type(/obj/item/jawsoflife, src)
	SSwardrobe.provide_type(/obj/item/analyzer/ranged, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/experimental, src) //This can be changed if this is too much //It's been 5 years
	SSwardrobe.provide_type(/obj/item/multitool/tricorder, src)	//yogs: changes the multitool to the tricorder and removes the analyzer
	SSwardrobe.provide_type(/obj/item/stack/cable_coil, src)
	SSwardrobe.provide_type(/obj/item/extinguisher/mini, src)
	SSwardrobe.provide_type(/obj/item/holosign_creator/multi/CE, src)
	//much roomier now that we've managed to remove two tools

/obj/item/storage/belt/utility/chief/full/ert
	name = "advanced nanotrasen toolbelt"
	desc = "Full of top of the line tools for all of your engineering needs."

/obj/item/storage/belt/utility/chief/full/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/handdrill
	to_preload += /obj/item/jawsoflife
	to_preload += /obj/item/analyzer/ranged
	to_preload += /obj/item/weldingtool/experimental
	to_preload += /obj/item/multitool/tricorder
	to_preload += /obj/item/stack/cable_coil
	to_preload += /obj/item/extinguisher/mini
	to_preload += /obj/item/holosign_creator/multi/CE
	return to_preload

/obj/item/storage/belt/utility/chief/admin/full
	preload = FALSE

/obj/item/storage/belt/utility/chief/admin/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/construction/rcd/combat/admin, src)
	SSwardrobe.provide_type(/obj/item/pipe_dispenser, src)
	SSwardrobe.provide_type(/obj/item/shuttle_creator/admin, src)
	SSwardrobe.provide_type(/obj/item/handdrill, src)
	SSwardrobe.provide_type(/obj/item/jawsoflife, src)
	SSwardrobe.provide_type(/obj/item/analyzer/ranged, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/experimental, src) //This can be changed if this is too much
	SSwardrobe.provide_type(/obj/item/multitool/tricorder, src)	//yogs: changes the multitool to the tricorder and removes the analyzer
	SSwardrobe.provide_type(/obj/item/storage/bag/construction/admin/full, src)
	SSwardrobe.provide_type(/obj/item/extinguisher/mini, src)
	SSwardrobe.provide_type(/obj/item/holosign_creator/multi/CE, src)

/obj/item/storage/belt/utility/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/screwdriver, src)
	SSwardrobe.provide_type(/obj/item/wrench, src)
	SSwardrobe.provide_type(/obj/item/weldingtool, src)
	SSwardrobe.provide_type(/obj/item/crowbar, src)
	SSwardrobe.provide_type(/obj/item/wirecutters, src)
	SSwardrobe.provide_type(/obj/item/multitool, src)
	SSwardrobe.provide_type(/obj/item/stack/cable_coil, src)

/obj/item/storage/belt/utility/full/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/screwdriver
	to_preload += /obj/item/wrench
	to_preload += /obj/item/weldingtool
	to_preload += /obj/item/crowbar
	to_preload += /obj/item/wirecutters
	to_preload += /obj/item/multitool
	to_preload += /obj/item/stack/cable_coil
	return to_preload

/obj/item/storage/belt/utility/full/engi/PopulateContents()
	SSwardrobe.provide_type(/obj/item/screwdriver, src)
	SSwardrobe.provide_type(/obj/item/wrench, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/largetank, src)
	SSwardrobe.provide_type(/obj/item/crowbar, src)
	SSwardrobe.provide_type(/obj/item/wirecutters, src)
	SSwardrobe.provide_type(/obj/item/multitool, src)
	SSwardrobe.provide_type(/obj/item/stack/cable_coil, src)
	SSwardrobe.provide_type(/obj/item/barrier_taperoll/engineering, src)

/obj/item/storage/belt/utility/full/engi/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/screwdriver
	to_preload += /obj/item/wrench
	to_preload += /obj/item/weldingtool/largetank
	to_preload += /obj/item/crowbar
	to_preload += /obj/item/wirecutters
	to_preload += /obj/item/multitool
	to_preload += /obj/item/stack/cable_coil
	to_preload += /obj/item/barrier_taperoll/engineering
	return to_preload

/obj/item/storage/belt/utility/atmostech/PopulateContents()
	SSwardrobe.provide_type(/obj/item/screwdriver, src)
	SSwardrobe.provide_type(/obj/item/wrench, src)
	SSwardrobe.provide_type(/obj/item/weldingtool, src)
	SSwardrobe.provide_type(/obj/item/crowbar, src)
	SSwardrobe.provide_type(/obj/item/wirecutters, src)
	SSwardrobe.provide_type(/obj/item/t_scanner, src)
	SSwardrobe.provide_type(/obj/item/extinguisher/mini, src)
	SSwardrobe.provide_type(/obj/item/barrier_taperoll/engineering, src)

/obj/item/storage/belt/utility/atmostech/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/screwdriver
	to_preload += /obj/item/wrench
	to_preload += /obj/item/weldingtool
	to_preload += /obj/item/crowbar
	to_preload += /obj/item/wirecutters
	to_preload += /obj/item/t_scanner
	to_preload += /obj/item/extinguisher/mini
	to_preload += /obj/item/barrier_taperoll/engineering
	return to_preload

/obj/item/storage/belt/utility/servant/PopulateContents()
	SSwardrobe.provide_type(/obj/item/screwdriver/brass, src)
	SSwardrobe.provide_type(/obj/item/wirecutters/brass, src)
	SSwardrobe.provide_type(/obj/item/wrench/brass, src)
	SSwardrobe.provide_type(/obj/item/crowbar/brass, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/experimental/brass, src)
	SSwardrobe.provide_type(/obj/item/multitool, src)
	SSwardrobe.provide_type(/obj/item/stack/cable_coil, src)

/obj/item/storage/belt/utility/servant/get_types_to_preload()
	var/list/to_preload = list() //Yes this is a pain. Yes this is the point
	to_preload += /obj/item/screwdriver/brass
	to_preload += /obj/item/wirecutters/brass
	to_preload += /obj/item/wrench/brass
	to_preload += /obj/item/crowbar/brass
	to_preload += /obj/item/weldingtool/experimental/brass
	to_preload += /obj/item/multitool
	to_preload += /obj/item/stack/cable_coil
	return to_preload

/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	content_overlays = TRUE

/obj/item/storage/belt/medical/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 12
	STR.max_combined_w_class = 18
	STR.set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medspray,
		/obj/item/lighter,
		/obj/item/storage/box/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/autoinjector,
		/obj/item/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves/,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/stack/medical/bone_gel,
		/obj/item/holosign_creator/medical,
		/obj/item/holosign_creator/firstaid
		))

/obj/item/storage/belt/medical/chief
	name = "\improper Chief Medical Officer's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "medicalbelt_cmo"
	item_state = "medical_cmo"

/obj/item/storage/belt/medical/chief/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/scalpel/advanced, src)
	SSwardrobe.provide_type(/obj/item/retractor/advanced, src)
	SSwardrobe.provide_type(/obj/item/cautery/advanced, src)
	SSwardrobe.provide_type(/obj/item/pinpointer/crew, src)
	SSwardrobe.provide_type(/obj/item/sensor_device, src)
	SSwardrobe.provide_type(/obj/item/healthanalyzer/advanced, src)

/obj/item/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE

/obj/item/storage/belt/security/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.max_combined_w_class = 18
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(
		/obj/item/melee/baton,
		/obj/item/melee/classic_baton,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_box,
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/lethalshot,
		/obj/item/storage/box/breacherslug,
		/obj/item/storage/box/beanbag,
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/kitchen/knife/combat,
		/obj/item/flashlight/seclite,
		/obj/item/melee/classic_baton/telescopic,
		/obj/item/radio,
		/obj/item/pinpointer/tracker,
		/obj/item/clothing/gloves,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/gun/ballistic/revolver/tracking,
		/obj/item/holosign_creator/security,
		/obj/item/shield/riot/tele,
		/obj/item/barrier_taperoll/police
		))

/obj/item/storage/belt/security/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/reagent_containers/spray/pepper, src)
	SSwardrobe.provide_type(/obj/item/restraints/handcuffs, src)
	SSwardrobe.provide_type(/obj/item/grenade/flashbang, src)
	SSwardrobe.provide_type(/obj/item/assembly/flash/handheld, src)
	SSwardrobe.provide_type(/obj/item/melee/baton/loaded, src)
	SSwardrobe.provide_type(/obj/item/barrier_taperoll/police, src)
	update_icon()

/obj/item/storage/belt/security/chief
	name = "\improper Head of Security's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "securitybelt_hos"
	item_state = "security_hos"

/obj/item/storage/belt/security/chief/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.max_combined_w_class = 21

/obj/item/storage/belt/security/chief/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/reagent_containers/spray/pepper, src)
	SSwardrobe.provide_type(/obj/item/restraints/handcuffs, src)
	SSwardrobe.provide_type(/obj/item/grenade/flashbang, src)
	SSwardrobe.provide_type(/obj/item/assembly/flash/handheld, src)
	SSwardrobe.provide_type(/obj/item/melee/baton/loaded, src)
	SSwardrobe.provide_type(/obj/item/barrier_taperoll/police, src)
	SSwardrobe.provide_type(/obj/item/shield/riot/tele, src)
	update_icon()

/obj/item/storage/belt/security/webbing
	name = "security webbing"
	desc = "Unique and versatile chest rig, can hold security gear."
	icon_state = "securitywebbing"
	item_state = "securitywebbing"
	w_class = WEIGHT_CLASS_BULKY
	custom_premium_price = 200

/obj/item/storage/belt/security/webbing/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	STR.max_combined_w_class = 21

/obj/item/storage/belt/mining
	name = "explorer's webbing"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer1"
	item_state = "explorer1"

/obj/item/storage/belt/mining/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 24
	STR.set_holdable(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/resonator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/lighter,
		/obj/item/storage/box/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/kitchen/knife,
		/obj/item/reagent_containers/autoinjector,
		/obj/item/lazarus_injector,
		/obj/item/gps,
		/obj/item/storage/bag/ore,
		/obj/item/survivalcapsule,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/stack/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/hivelordstabilizer,
		/obj/item/organ/regenerative_core,
		/obj/item/wormhole_jaunter,
		/obj/item/storage/bag/plants,
		/obj/item/stack/marker_beacon,
		/obj/item/handdrill,
		/obj/item/jawsoflife,
		/obj/item/restraints/legcuffs/bola/watcher,
		/obj/item/stack/sheet/mineral,
		/obj/item/grenade/plastic/miningcharge,
		/obj/item/gem
		))


/obj/item/storage/belt/mining/vendor
	contents = newlist(/obj/item/survivalcapsule,
	/obj/item/grenade/plastic/miningcharge/lesser,
	/obj/item/grenade/plastic/miningcharge/lesser,
	/obj/item/grenade/plastic/miningcharge/lesser,)

/obj/item/storage/belt/mining/alt
	icon_state = "explorer2"
	item_state = "explorer2"

/obj/item/storage/belt/mining/primitive
	name = "hunter's belt"
	desc = "A versatile belt, woven from sinew."
	icon_state = "ebelt"
	item_state = "ebelt"

/obj/item/storage/belt/mining/primitive/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"

/obj/item/storage/belt/soulstone/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(
		/obj/item/soulstone
		))

/obj/item/storage/belt/soulstone/full/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/soulstone(src)

/obj/item/storage/belt/soulstone/full/chappy/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/soulstone/anybody/chaplain(src)

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	materials = list(/datum/material/gold=400)

/obj/item/storage/belt/champion/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.set_holdable(list(
		/obj/item/clothing/mask/luchador
		))

/obj/item/storage/belt/military
	name = "chest rig"
	desc = "A set of tactical webbing worn by Syndicate boarding parties."
	icon_state = "militarywebbing"
	item_state = "militarywebbing"
	resistance_flags = FIRE_PROOF

/obj/item/storage/belt/military/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/military/snack
	name = "tactical snack rig"

/obj/item/storage/belt/military/snack/Initialize()
	. = ..()
	var/sponsor = pick("DonkCo", "Waffle Co.", "Roffle Co.", "Gorlax Marauders", "Tiger Cooperative")
	desc = "A set of snack-tical webbing worn by athletes of the [sponsor] VR sports division."

/obj/item/storage/belt/military/snack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.set_holdable(list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/reagent_containers/food/drinks
		))

	var/amount = 5
	var/rig_snacks
	while(contents.len <= amount)
		rig_snacks = pick(list(
		/obj/item/reagent_containers/food/snacks/candy,
		/obj/item/reagent_containers/food/drinks/dry_ramen,
		/obj/item/reagent_containers/food/snacks/chips,
		/obj/item/reagent_containers/food/snacks/sosjerky,
		/obj/item/reagent_containers/food/snacks/syndicake,
		/obj/item/reagent_containers/food/snacks/spacetwinkie,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers,
		/obj/item/reagent_containers/food/snacks/nachos,
		/obj/item/reagent_containers/food/snacks/cheesynachos,
		/obj/item/reagent_containers/food/snacks/cubannachos,
		/obj/item/reagent_containers/food/snacks/nugget,
		/obj/item/reagent_containers/food/snacks/spaghetti/pastatomato,
		/obj/item/reagent_containers/food/snacks/rofflewaffles,
		/obj/item/reagent_containers/food/snacks/donkpocket,
		/obj/item/reagent_containers/food/drinks/soda_cans/cola,
		/obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind,
		/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb,
		/obj/item/reagent_containers/food/drinks/soda_cans/starkist,
		/obj/item/reagent_containers/food/drinks/soda_cans/space_up,
		/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game,
		/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime,
		/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola
		))
		new rig_snacks(src)

/obj/item/storage/belt/military/abductor
	name = "agent belt"
	desc = "A belt used by abductor agents."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"
	content_overlays = TRUE

/obj/item/storage/belt/military/abductor/agent/PopulateContents()
	new /obj/item/screwdriver/abductor(src)
	new /obj/item/wrench/abductor(src)
	new /obj/item/weldingtool/abductor(src)
	new /obj/item/crowbar/abductor(src)
	new /obj/item/wirecutters/abductor(src)
	new /obj/item/multitool/abductor(src)
	new /obj/item/stack/cable_coil(src,MAXCOIL,"white")

/obj/item/storage/belt/military/abductor/scientist/PopulateContents()
	new /obj/item/scalpel/alien(src)
	new /obj/item/hemostat/alien(src)
	new /obj/item/retractor/alien(src)
	new /obj/item/circular_saw/alien(src)
	new /obj/item/surgicaldrill/alien(src)
	new /obj/item/cautery/alien(src)

/obj/item/storage/belt/admin
	name = "badmin belt"
	desc = "A belt used by admins to debug."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"
	content_overlays = TRUE // This won't end well

/obj/item/storage/belt/military/snack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1000
	STR.max_combined_w_class = 1000
	STR.max_w_class = WEIGHT_CLASS_GIGANTIC

/obj/item/storage/belt/admin/full/PopulateContents()
	new /obj/item/construction/rcd/combat/admin(src)
	new /obj/item/pipe_dispenser(src)
	new /obj/item/shuttle_creator/admin(src)
	new /obj/item/handdrill(src)
	new /obj/item/jawsoflife(src)
	new /obj/item/analyzer/ranged(src)
	new /obj/item/weldingtool/experimental(src)
	new /obj/item/multitool/tricorder(src)
	new /obj/item/storage/bag/construction/admin/full(src)
	new /obj/item/extinguisher/mini(src)
	new /obj/item/holosign_creator/multi/CE(src)
	new /obj/item/restraints/handcuffs/alien(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/melee/baton/loaded(src)
	new /obj/item/scalpel/alien(src)
	new /obj/item/hemostat/alien(src)
	new /obj/item/retractor/alien(src)
	new /obj/item/circular_saw/alien(src)
	new /obj/item/surgicaldrill/alien(src)
	new /obj/item/cautery/alien(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/sensor_device(src)
	new /obj/item/healthanalyzer/advanced(src)

/obj/item/storage/belt/military/army
	name = "army belt"
	desc = "A belt used by military forces."
	icon_state = "grenadebeltold"
	item_state = "security"

/obj/item/storage/belt/military/assault
	name = "assault belt"
	desc = "A tactical assault belt."
	icon_state = "assaultbelt"
	item_state = "security"

/obj/item/storage/belt/grenade
	name = "grenadier belt"
	desc = "A belt for holding grenades."
	icon_state = "grenadebeltnew"
	item_state = "security"

/obj/item/storage/belt/grenade/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 30
	STR.display_numerical_stacking = TRUE
	STR.max_combined_w_class = 60
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/grenade,
		/obj/item/screwdriver,
		/obj/item/lighter,
		/obj/item/multitool,
		/obj/item/reagent_containers/food/drinks/bottle/molotov,
		/obj/item/grenade/plastic/c4,
		/obj/item/reagent_containers/food/snacks/grown/cherry_bomb,
		/obj/item/reagent_containers/food/snacks/grown/firelemon
		))

/obj/item/storage/belt/grenade/full/PopulateContents()
	var/static/items_inside = list(
		/obj/item/grenade/flashbang = 1,
		/obj/item/grenade/smokebomb = 4,
		/obj/item/grenade/empgrenade = 1,
		/obj/item/grenade/empgrenade = 1,
		/obj/item/grenade/syndieminibomb/concussion/frag = 10,
		/obj/item/grenade/gluon = 4,
		/obj/item/grenade/chem_grenade/incendiary = 2,
		/obj/item/grenade/chem_grenade/facid = 1,
		/obj/item/grenade/syndieminibomb = 2,
		/obj/item/screwdriver = 1,
		/obj/item/multitool = 1)
	generate_items_inside(items_inside,src)


/obj/item/storage/belt/wands
	name = "wand belt"
	desc = "A belt designed to hold various rods of power. A veritable fanny pack of exotic magic."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"

/obj/item/storage/belt/wands/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(
		/obj/item/gun/magic/wand
		))

/obj/item/storage/belt/wands/full/PopulateContents()
	new /obj/item/gun/magic/wand/resurrection(src)
	new /obj/item/gun/magic/wand/polymorph(src)
	new /obj/item/gun/magic/wand/teleport(src)
	new /obj/item/gun/magic/wand/door(src)
	new /obj/item/gun/magic/wand/fireball(src)

	for(var/obj/item/gun/magic/wand/W in contents) //All wands in this pack come in the best possible condition
		W.max_charges = initial(W.max_charges)
		W.charges = W.max_charges

/obj/item/storage/belt/janitor
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"

/obj/item/storage/belt/janitor/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.max_w_class = WEIGHT_CLASS_BULKY //Set to this so the  light replacer can fit.
	STR.set_holdable(list(
		/obj/item/grenade/chem_grenade,
		/obj/item/lightreplacer,
		/obj/item/flashlight,
		/obj/item/reagent_containers/spray,
		/obj/item/soap,
		/obj/item/holosign_creator/janibarrier,
		/obj/item/forcefield_projector,
		/obj/item/key/janitor,
		/obj/item/clothing/gloves,
		/obj/item/melee/flyswatter,
		/obj/item/assembly/mousetrap,
		/obj/item/paint/paint_remover
		))

/obj/item/storage/belt/janitor/full/PopulateContents()
	new /obj/item/lightreplacer(src)
	new /obj/item/reagent_containers/spray/cleaner(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/holosign_creator/janibarrier(src)
	new /obj/item/melee/flyswatter(src)

/obj/item/storage/belt/bandolier
	name = "bandolier"
	desc = "A bandolier for holding shotgun ammunition."
	icon_state = "bandolier"
	item_state = "bandolier"

/obj/item/storage/belt/bandolier/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 24
	STR.max_combined_w_class = 24
	STR.display_numerical_stacking = TRUE
	STR.set_holdable(list(
		/obj/item/ammo_casing/shotgun
		))

/obj/item/storage/belt/holster
	name = "shoulder holster"
	desc = "A holster to carry a handgun and ammo. WARNING: Badasses only."
	icon_state = "holster"
	item_state = "holster"
	w_class = WEIGHT_CLASS_NORMAL
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/storage/belt/holster/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box,
		/obj/item/gun/energy/e_gun/mini
		))

/obj/item/storage/belt/holster/full/PopulateContents()
	var/static/items_inside = list(
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/c38 = 2)
	generate_items_inside(items_inside, src)

/obj/item/storage/belt/holster/syndicate
	name = "syndicate shoulder holster"
	desc = "A modified holster that can carry more than enough firepower."

/obj/item/storage/belt/holster/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4

/obj/item/storage/belt/quiver
	name = "leather quiver"
	desc = "A quiver made from the hide of some animal. Used to hold arrows."
	icon_state = "quiver"
	item_state = "quiver"

/obj/item/storage/belt/quiver/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 15
	STR.display_numerical_stacking = TRUE
	STR.set_holdable(list(
		/obj/item/ammo_casing/caseless/arrow,
		/obj/item/stand_arrow,
		/obj/item/throwing_star/magspear
		))

/obj/item/storage/belt/quiver/ashwalker/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/ammo_casing/caseless/arrow/bone(src)

/obj/item/storage/belt/quiver/admin
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/belt/quiver/admin/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 100
	STR.max_items = 100

/obj/item/storage/belt/quiver/admin/full/PopulateContents()
	for(var/arrow in typesof(/obj/item/ammo_casing/caseless/arrow))
		if(istype(arrow, /obj/item/ammo_casing/caseless/arrow/energy))
			continue
		for(var/i in 1 to 10)
			new arrow(src)

/obj/item/storage/belt/fannypack
	name = "fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	dying_key = DYE_REGISTRY_FANNYPACK
	custom_price = 15

/obj/item/storage/belt/fannypack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/fannypack/black
	name = "black fannypack"
	icon_state = "fannypack_black"
	item_state = "fannypack_black"

/obj/item/storage/belt/fannypack/red
	name = "red fannypack"
	icon_state = "fannypack_red"
	item_state = "fannypack_red"

/obj/item/storage/belt/fannypack/purple
	name = "purple fannypack"
	icon_state = "fannypack_purple"
	item_state = "fannypack_purple"

/obj/item/storage/belt/fannypack/blue
	name = "blue fannypack"
	icon_state = "fannypack_blue"
	item_state = "fannypack_blue"

/obj/item/storage/belt/fannypack/orange
	name = "orange fannypack"
	icon_state = "fannypack_orange"
	item_state = "fannypack_orange"

/obj/item/storage/belt/fannypack/white
	name = "white fannypack"
	icon_state = "fannypack_white"
	item_state = "fannypack_white"

/obj/item/storage/belt/fannypack/green
	name = "green fannypack"
	icon_state = "fannypack_green"
	item_state = "fannypack_green"

/obj/item/storage/belt/fannypack/pink
	name = "pink fannypack"
	icon_state = "fannypack_pink"
	item_state = "fannypack_pink"

/obj/item/storage/belt/fannypack/cyan
	name = "cyan fannypack"
	icon_state = "fannypack_cyan"
	item_state = "fannypack_cyan"

/obj/item/storage/belt/fannypack/yellow
	name = "yellow fannypack"
	icon_state = "fannypack_yellow"
	item_state = "fannypack_yellow"

/obj/item/storage/belt/sabre
	name = "sabre sheath"
	desc = "An ornate sheath designed to hold an officer's blade."
	icon_state = "sheath"
	item_state = "sheath"

/obj/item/storage/belt/sabre/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.rustle_sound = FALSE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/melee/sabre
		))

/obj/item/storage/belt/sabre/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("Alt-click it to quickly draw the blade.")

/obj/item/storage/belt/sabre/AltClick(mob/user)
	if(!iscarbon(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src].", span_notice("You take [I] out of [src]."))
		user.put_in_hands(I)
		update_icon()
	else
		to_chat(user, "[src] is empty.")

/obj/item/storage/belt/sabre/update_icon()
	icon_state = "sheath"
	item_state = "sheath"
	if(contents.len)
		icon_state += "-sabre"
		item_state += "-sabre"
	if(loc && isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()
	..()

/obj/item/storage/belt/sabre/PopulateContents()
	new /obj/item/melee/sabre(src)
	update_icon()

/obj/item/storage/belt/multi
	name = "multi-belt"
	desc = "Can hold quite a lot of stuff."
	w_class = WEIGHT_CLASS_NORMAL
