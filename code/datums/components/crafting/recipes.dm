// TODO LIST:
/*
	/datum/asset/spritesheet/crafting/proc/add_tool_icons() needs to be fixed. Using it breaks all icons, but we still want it for icons for TOOL_BEHAVIOR.
*/
/datum/crafting_recipe
	/// In-game display name.
	var/name = ""
	// Unused.
	var/desc = ""
	/// Type paths of items consumed associated with how many are needed.
	var/list/reqs = list()
	/// Type paths of items explicitly not allowed as an ingredient.
	var/list/blacklist = list()
	/// Type path of item resulting from this craft.
	var/result
	/// String defines of items needed but not consumed.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed.
	var/list/tool_paths
	/// Time in seconds.
	var/time = 3 SECONDS
	/// Type paths of items that will be placed in the result.
	var/list/parts = list()
	/// Where it shows up in the crafting UI.
	var/category
	/// Set to FALSE if it needs to be learned fast.
	var/always_available = TRUE
	/// Should only one object exist on the same turf?
	var/one_per_turf = FALSE
	/// What skill levels are required to craft this? ex. list(SKILL_MECHANICAL = EXP_HIGH, SKILL_SCIENCE = EXP_LOW)
	var/list/skill_requirements = list()

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	// These should be excluded from all crafting recipes:
	blacklist += list(
		// From surgical toolset implant:
		/obj/item/cautery/augment,
		/obj/item/circular_saw/augment,
		/obj/item/hemostat/augment,
		/obj/item/retractor/augment,
		/obj/item/scalpel/augment,
		/obj/item/surgicaldrill/augment,
		// From integrated toolset implant:
		/obj/item/crowbar/cyborg,
		/obj/item/multitool/cyborg,
		/obj/item/screwdriver/cyborg,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/wrench/cyborg,
	)

/**
  * Run custom pre-craft checks for this recipe
  *
  * user: the /mob that initiated the crafting
  * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
  */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	return

/// Additional UI data to be passed to the crafting UI for this recipe
/datum/crafting_recipe/proc/crafting_ui_data()
	return list()

//Normal recipes

/datum/crafting_recipe/ed209
	name = "ED209"
	result = /mob/living/simple_animal/bot/ed209
	reqs = list(/obj/item/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/bodypart/l_leg/robot = 1,
				/obj/item/bodypart/r_leg/robot = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/gun/energy/e_gun/dragnet = 1,
				/obj/item/stock_parts/cell = 1,
				/obj/item/assembly/prox_sensor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 6 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/secbot
	name = "Secbot"
	result = /mob/living/simple_animal/bot/secbot
	reqs = list(/obj/item/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/melee/baton = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 6 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/cleanbot
	name = "Cleanbot"
	result = /mob/living/simple_animal/bot/cleanbot
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 4 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/floorbot
	name = "Floorbot"
	result = /mob/living/simple_animal/bot/floorbot
	reqs = list(/obj/item/storage/toolbox = 1,
				/obj/item/stack/tile/plasteel = 10,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 4 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/medbot
	name = "Medbot"
	result = /mob/living/simple_animal/bot/medbot
	reqs = list(/obj/item/healthanalyzer = 1,
				/obj/item/storage/firstaid = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/r_arm/robot = 1)
	time = 4 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/honkbot
	name = "Honkbot"
	result = /mob/living/simple_animal/bot/honkbot
	reqs = list(/obj/item/storage/box/clown = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bikehorn/ = 1)
	time = 4 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/Firebot
	name = "Firebot"
	result = /mob/living/simple_animal/bot/firebot
	reqs = list(/obj/item/extinguisher = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/clothing/head/hardhat/red = 1)
	time = 4 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/Atmosbot
	name = "Automatic Station Stabilizer Bot"
	result = /mob/living/simple_animal/bot/atmosbot
	reqs = list(/obj/item/analyzer = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/grenade/chem_grenade/smart_metal_foam = 1)
	time = 6 SECONDS
	category = CAT_ROBOT

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 1.5 SECONDS
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_MISC

/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 6.5 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/rods = 6)
	time = 10 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/motorized_wheelchair
	name = "Motorized Wheelchair"
	result = /obj/vehicle/ridden/wheelchair/motorized
	reqs = list(/obj/item/stack/sheet/metal = 6,
		/obj/item/stack/rods = 2,
		/obj/item/wheelchair = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	parts = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 20 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/ghetto_heart
	name = "Makeshift Heart"
	result = /obj/item/organ/heart/ghetto
	reqs = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/weaponcrafting/receiver = 1, //it recieves the blood
				/obj/item/reagent_containers/autoinjector/medipen/pumpup = 1)
	tool_behaviors = list(TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/ghetto_lungs
	name = "Makeshift Lungs"
	result = /obj/item/organ/lungs/ghetto
	reqs = list(/obj/item/tank/internals/emergency_oxygen = 2,
				/obj/item/weaponcrafting/receiver = 1) //it recieves the oxygen
	tool_behaviors = list(TOOL_WELDER)
	time = 15 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/mousetrap
	name = "Mouse Trap"
	result = /obj/item/assembly/mousetrap
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/rods = 1)
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 5)
	category = CAT_MISC

/datum/crafting_recipe/flashlight_eyes
	name = "Flashlight Eyes"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 1 SECONDS
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/sheet/paperframes/five
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 5)
	category = CAT_STRUCTURES

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 3 SECONDS
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	category = CAT_MISC

/datum/crafting_recipe/toysword
	name = "Toy Sword"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword
	category = CAT_MISC

/datum/crafting_recipe/toysword
	name = "Toy Sledgehammer"
	reqs = list(/obj/item/light/bulb = 2, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/melee/vxtvulhammer/toy/pirate // not authentic!!!!
	category = CAT_MISC

/datum/crafting_recipe/toybat
	name = "Toy Baseball Bat"
	reqs = list(/obj/item/stack/sheet/plastic = 6, )
	result = /obj/item/toy/foamblade/baseball
	category = CAT_MISC

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	category = CAT_STRUCTURES

/datum/crafting_recipe/garbage_bin
	name = "Garbage Bin"
	reqs = 	list(/obj/item/stack/sheet/metal = 3)
	result = /obj/structure/closet/crate/bin
	category = CAT_STRUCTURES

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_STRUCTURES

/datum/crafting_recipe/shower
	name = "Shower"
	reqs = 	list(/obj/item/stack/rods = 4, /obj/item/stack/sheet/metal = 1)
	result = /obj/machinery/shower
	category = CAT_STRUCTURES
	time = 15 SECONDS

/datum/crafting_recipe/iv_drip
	name = "IV drip"
	reqs = 	list(/obj/item/stack/rods = 4, /obj/item/stack/sheet/metal = 1)
	result = /obj/machinery/iv_drip
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_STRUCTURES
	time = 5 SECONDS

/datum/crafting_recipe/sink
	name = "Sink"
	reqs = 	list(/obj/item/stack/rods = 1, /obj/item/stack/sheet/metal = 4)
	result = /obj/structure/sink
	category = CAT_STRUCTURES

/datum/crafting_recipe/mirror
	name = "Mirror"
	reqs = 	list(/obj/item/stack/rods = 1, /obj/item/stack/sheet/glass = 1, /obj/item/stack/sheet/mineral/silver = 1)
	result = /obj/item/wallframe/mirror
	category = CAT_STRUCTURES

/datum/crafting_recipe/toilet // best moment of my life - Hopek 2020
	name = "Toilet"
	reqs = 	list(/obj/item/stack/sheet/metal = 5, /obj/item/reagent_containers/glass/bucket = 1)
	result = /obj/structure/toilet
	category = CAT_STRUCTURES

/datum/crafting_recipe/cloth_curtain
	name = "Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/cloth_curtain
	category = CAT_STRUCTURES

/datum/crafting_recipe/secure_closet
	name = "Secure Closet"
	reqs = list(/obj/item/stack/sheet/metal = 5, /obj/item/stack/cable_coil = 10, /obj/item/electronics/airlock = 1)
	parts = list(/obj/item/electronics/airlock = 1)
	result = /obj/structure/closet/secure_closet
	category = CAT_STRUCTURES

/datum/crafting_recipe/shutters
	name = "Mechanical Shutter"
	reqs = list(/obj/item/stack/sheet/plasteel = 10, /obj/item/stack/cable_coil = 5, /obj/item/electronics/airlock = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 10 SECONDS
	result = /obj/machinery/door/poddoor/shutters/preopen
	category = CAT_STRUCTURES

/datum/crafting_recipe/blastdoor
	name = "Blastdoor"
	reqs = list(/obj/item/stack/sheet/plasteel = 20, /obj/item/stack/cable_coil = 10, /obj/item/electronics/airlock = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 20 SECONDS
	result = /obj/machinery/door/poddoor/preopen
	category = CAT_STRUCTURES

/datum/crafting_recipe/bonepickaxe
	name = "Bone Pickaxe"
	result = /obj/item/pickaxe/bonepickaxe
	time = 5 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 3,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/firebrand
	name = "Firebrand"
	result = /obj/item/match/firebrand
	time = 10 SECONDS //Long construction time. Making fire is hard work.
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 2 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	category = CAT_MISC

/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 6 SECONDS
	reqs = list(/obj/item/grown/log = 5)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/datum/crafting_recipe/rake
	name = "Rake"
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_TOOLS

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_TOOLS

/datum/crafting_recipe/cleanleather
	name = "Clean Leather"
	result = /obj/item/stack/sheet/wetleather
	reqs = list(/obj/item/stack/sheet/hairlesshide = 1, /datum/reagent/water = 20)
	time = 10 SECONDS //its pretty hard without the help of a washing machine.
	category = CAT_MISC

/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 6.5 SECONDS
	reqs = list(/obj/item/melee/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/melee/spear = 1)
	blacklist = list(/obj/item/melee/spear/bonespear, /obj/item/melee/spear/bamboospear)
	result = /obj/structure/headpike/glass
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 6.5 SECONDS
	reqs = list(/obj/item/melee/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/melee/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebamboo
	name = "Spike Head (Bamboo Spear)"
	time = 6.5 SECONDS
	reqs = list(/obj/item/melee/spear/bamboospear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/melee/spear/bamboospear = 1)
	result = /obj/structure/headpike/bamboo
	category = CAT_PRIMAL

/datum/crafting_recipe/sillycup
	name = "Paper Cup"
	result = /obj/item/reagent_containers/food/drinks/sillycup
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 2)
	category = CAT_MISC

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	category = CAT_MISC

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 0.5 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 1,
				  /obj/item/stack/tile/plasteel = 1,
				  /obj/item/stack/cable_coil = 2,
				  /obj/item/assembly/igniter = 1)
	category = CAT_STRUCTURES

/datum/crafting_recipe/rcl
	name = "Makeshift Rapid Cable Layer"
	result = /obj/item/rcl/ghetto
	time = 4 SECONDS
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 15)
	category = CAT_TOOLS

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 15 SECONDS // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
		        /obj/item/stack/sheet/mineral/wood = 20,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/aitater
	name = "intelliTater"
	result = /obj/item/aicard/aitater
	time = 3 SECONDS
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/reagent_containers/food/snacks/grown/potato = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/aispook
	name = "intelliLantern"
	result = /obj/item/aicard/aispook
	time = 3 SECONDS
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/reagent_containers/food/snacks/grown/pumpkin = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/urinal
	name = "Urinal"
	reqs = 	list(/obj/item/stack/sheet/metal = 4 , /obj/item/pipe = 2)
	result = /obj/structure/urinal
	category = CAT_STRUCTURES

/datum/crafting_recipe/paint/crayon
	name = "Paint"
	result = /obj/item/paint/anycolor
	reqs = list(/obj/item/toy/crayon = 1,
				/datum/reagent/water = 5,
				/datum/reagent/consumable/milk = 5,
				/obj/item/reagent_containers/glass/bucket = 1)
	tool_behaviors = list(TOOL_CROWBAR)
	category = CAT_MISC
	time = 3 SECONDS

/datum/crafting_recipe/paint/spraycan
	name = "Paint"
	result = /obj/item/paint/anycolor
	reqs = list(/obj/item/toy/crayon/spraycan = 1,
				/datum/reagent/water = 5,
				/datum/reagent/consumable/milk = 5,
				/obj/item/reagent_containers/glass/bucket = 1)
	tool_behaviors = list(TOOL_CROWBAR)
	category = CAT_MISC
	time = 3 SECONDS

/datum/crafting_recipe/woodenmug
	name = "Wooden Mug"
	result = /obj/item/reagent_containers/glass/woodmug
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	time = 2 SECONDS
	category = CAT_PRIMAL

/datum/crafting_recipe/elder_atmosian_statue
	name = "Elder Atmosian Statue"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 10,
				/obj/item/stack/sheet/mineral/zaukerite = 1,
				/obj/item/grenade/gas_crystal/healium_crystal = 1,
				/obj/item/grenade/gas_crystal/pluonium_crystal = 1,
				/obj/item/grenade/gas_crystal/healium_crystal = 1
				)
	category = CAT_STRUCTURES

/datum/crafting_recipe/tape
	name = "tape"
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/datum/reagent/consumable/caramel = 5)
	result = /obj/item/stack/tape
	time = 1
	category = CAT_MISC

/datum/crafting_recipe/goliath_drapes
	name = "Goliath Mat"
	result = /obj/item/surgical_mat/goliath
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/sinew = 1,
				 /obj/item/stack/sheet/animalhide/goliath_hide = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_scalpel
	name = "Bone Scalpel"
	result = /obj/item/scalpel/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1,
				 /obj/item/stack/sheet/mineral/diamond = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_retractor
	name = "Bone Retractor"
	result = /obj/item/retractor/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_bonesaw
	name = "Bone Bonesaw"
	result = /obj/item/circular_saw/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1,
				 /obj/item/organ/regenerative_core = 1,
				 /obj/item/stack/sheet/mineral/diamond = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_hemostat
	name = "Bone Hemostat"
	result = /obj/item/hemostat/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_bonesetter
	name = "Bone Bonesetter"
	result = /obj/item/bonesetter/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_cautery
	name = "Bone Cautery"
	result = /obj/item/cautery/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 1,
				 /obj/item/stack/sheet/animalhide/goliath_hide = 1,
				 /obj/item/stack/sheet/mineral/plasma = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_spade
	name = "Bone Spade"
	result = /obj/item/shovel/spade/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 1,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_hatchet
	name = "Bone Hatchet"
	result = /obj/item/hatchet/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 1,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/bone_cultivator
	name = "Bone Cultivator"
	result = /obj/item/cultivator/bone
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_TOOLS

/datum/crafting_recipe/epinephrine_medipen
	name = "Epinephrine Medipen"
	result = /obj/item/reagent_containers/autoinjector/medipen
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 2 SECONDS
	reqs = list(/obj/item/pen = 1, // You feel a tiny prick!
				/obj/item/reagent_containers/syringe = 1,
				/datum/reagent/medicine/epinephrine = 10) // Sanguirite is unobtainable
	category = CAT_MEDICAL

/datum/crafting_recipe/atropine_medipen
	name = "Atropine Autoinjector"
	result = /obj/item/reagent_containers/autoinjector/medipen/atropine
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 4 SECONDS
	reqs = list(/obj/item/pen = 1, // You feel a tiny prick!
				/obj/item/reagent_containers/syringe = 1,
				/datum/reagent/medicine/atropine = 10)
	category = CAT_MEDICAL

/datum/crafting_recipe/maint_pumpup
	name = "Maintenance Pump-Up"
	result = /obj/item/reagent_containers/autoinjector/medipen/pumpup
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 4 SECONDS
	reqs = list(/obj/item/pen = 1, // You feel a tiny prick!
				/obj/item/reagent_containers/syringe = 1,
				/datum/reagent/drug/pumpup = 15)
	category = CAT_MEDICAL

/datum/crafting_recipe/refill_epinephrine_medipen
	name = "Refill Epinephrine Medipen"
	result = /obj/item/reagent_containers/autoinjector/medipen
	time = 2 SECONDS
	reqs = list(/obj/item/reagent_containers/autoinjector/medipen = 1,
				/datum/reagent/medicine/epinephrine = 10)
	category = CAT_MEDICAL

/datum/crafting_recipe/refill_atropine_medipen
	name = "Refill Atropine Autoinjector"
	result = /obj/item/reagent_containers/autoinjector/medipen/atropine
	time = 4 SECONDS
	reqs = list(/obj/item/reagent_containers/autoinjector/medipen/atropine = 1,
				/datum/reagent/medicine/atropine = 10)
	category = CAT_MEDICAL

/datum/crafting_recipe/refill_maint_pumpup
	name = "Refill Maintenance Pump-Up"
	result = /obj/item/reagent_containers/autoinjector/medipen/pumpup
	time = 4 SECONDS
	reqs = list(/obj/item/reagent_containers/autoinjector/medipen/pumpup = 1,
				/datum/reagent/drug/pumpup = 15)
	category = CAT_MEDICAL

/datum/crafting_recipe/mothplush
	name = "Moth Plushie"
	result = /obj/item/toy/plush/mothplushie
	reqs = list(/obj/item/stack/sheet/animalhide/mothroach = 1,
				/obj/item/organ/heart = 1,
				/obj/item/stack/sheet/cloth = 3)
	category = CAT_MISC

/datum/crafting_recipe/suture
	name = "Suture"
	result = /obj/item/stack/medical/suture
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/sheet/metal = 1,
				/datum/reagent/space_cleaner/sterilizine = 4)
	category = CAT_MEDICAL

/datum/crafting_recipe/makeshiftsuture
	name = "Makeshift Suture"
	result = /obj/item/stack/medical/suture/emergency/makeshift
	reqs = list(/obj/item/clothing/torncloth = 1,
				/obj/item/shard = 1,
				/datum/reagent/water = 4)
	category = CAT_MEDICAL

/datum/crafting_recipe/medicatedsuture
	name = "Medicated Suture"
	result = /obj/item/stack/medical/suture/medicated
	reqs = list(/obj/item/stack/sheet/plastic = 2,
				/obj/item/stack/sheet/metal = 1,
				/datum/reagent/space_cleaner/sterilizine = 6,
				/datum/reagent/medicine/morphine = 5)
	category = CAT_MEDICAL

/datum/crafting_recipe/mesh
	name = "Regenerative Mesh"
	result = /obj/item/stack/medical/mesh
	reqs = list(/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/medical/gauze/improvised = 2,
				/datum/reagent/space_cleaner/sterilizine = 7,
				/datum/reagent/medicine/morphine = 3)
	category = CAT_MEDICAL

/datum/crafting_recipe/ointment
	name = "Ointment"
	result = /obj/item/stack/medical/ointment
	reqs = list(/datum/reagent/water = 10,
				/datum/reagent/ash = 10)
	tool_paths = list(/obj/item/weldingtool)
	category = CAT_MEDICAL

/datum/crafting_recipe/antisepticointment
	name = "Antiseptic Ointment"
	result = /obj/item/stack/medical/ointment/antiseptic
	reqs = list(/datum/reagent/water = 10,
				/datum/reagent/ash = 10,
				/datum/reagent/silver = 10)
	tool_paths = list(/obj/item/weldingtool)
	category = CAT_MEDICAL

/datum/crafting_recipe/advancedmesh
	name = "Advanced Regenerative Mesh"
	result = /obj/item/stack/medical/mesh/advanced
	reqs = list(/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/medical/gauze/improvised = 2,
				/datum/reagent/space_cleaner/sterilizine = 10,
				/datum/reagent/medicine/silver_sulfadiazine = 10,
				/datum/reagent/medicine/morphine = 3)
	category = CAT_MEDICAL

/datum/crafting_recipe/gauze
	name = "Gauze"
	result = /obj/item/stack/medical/gauze
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/medical/suture = 1) //for reinforcement, so its not just...cloth.
	category = CAT_MEDICAL

/datum/crafting_recipe/makeshiftsuture/tribal
	name = "Sinew Suture"
	result = /obj/item/stack/medical/suture/emergency/makeshift/tribal
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 6,
				/datum/reagent/consumable/tinlux = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/leftprostheticarm
	name = "Left Prosthetic Arm"
	result = /obj/item/bodypart/l_arm/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL

/datum/crafting_recipe/rightprostheticarm
	name = "Right Prosthetic Arm"
	result = /obj/item/bodypart/r_arm/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL

/datum/crafting_recipe/leftprostheticleg
	name = "Left Prosthetic Leg"
	result = /obj/item/bodypart/l_leg/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL

/datum/crafting_recipe/rightprostheticleg
	name = "Right Prosthetic Leg"
	result = /obj/item/bodypart/r_leg/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL

/datum/crafting_recipe/apprentice_bait
	name = "Apprentice Bait"
	reqs = list(
		/datum/reagent/water = 2,
		/datum/reagent/consumable/flour = 5,
		/obj/item/reagent_containers/food/snacks/grown/corn = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bait/apprentice
	category = CAT_BAIT

/datum/crafting_recipe/journeyman_bait
	name = "Journeyman Bait"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bait/apprentice = 2,
		/datum/reagent/blood = 5
	)
	result = /obj/item/reagent_containers/food/snacks/bait/journeyman
	category = CAT_BAIT

/datum/crafting_recipe/master_bait
	name = "Master Bait"
	reqs = list(
		/datum/reagent/toxin/plasma = 5,
		/obj/item/reagent_containers/food/snacks/bait/journeyman = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bait/master
	category = CAT_BAIT

/datum/crafting_recipe/wild_bait
	name = "Wild Bait"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bait/worm = 1,
		/obj/item/stack/medical/gauze/improvised = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bait/wild
	category = CAT_BAIT

// It can't run without fuel rods (cargo only) so this shouldn't be a problem
/datum/crafting_recipe/reactor_frame
	name = "Nuclear Reactor Frame"
	reqs = list(
		/obj/item/stack/sheet/plasteel = 20,
		/obj/item/stack/sheet/metal = 50,
		/obj/item/stack/cable_coil = 10,
		/obj/item/pipe = 3,
		/obj/item/electronics/advanced_airlock_controller = 1
	)
	tool_behaviors = list(TOOL_WELDER)
	result = /obj/structure/reactor_frame
	category = CAT_STRUCTURES
	time = 10 SECONDS

/datum/crafting_recipe/morguetray
	name = "Morgue Tray"
	reqs = list(
		/obj/item/stack/sheet/metal = 5
	)
	result = /obj/structure/tray/morgue
	category = CAT_STRUCTURES

/datum/crafting_recipe/crematortray
	name = "Crematorium Tray"
	reqs = list(
		/obj/item/stack/sheet/metal = 5
	)
	result = /obj/structure/tray/cremator
	category = CAT_STRUCTURES
