// Weapons

/datum/crafting_recipe/pin_removal
	name = "Pin Removal"
	result = /obj/item/gun
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/IED
	name = "IED"
	result = /obj/item/grenade/iedcasing
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	skill_requirements = list(
		SKILL_TECHNICAL = EXP_LOW,
		SKILL_SCIENCE = EXP_LOW,
	)
	time = 1.5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/shield/riot/flash
	reqs = list(/obj/item/wallframe/flasher = 1,
				/obj/item/assembly/flash/handheld = 1,
				/obj/item/shield/riot = 1)
	blacklist = list(/obj/item/shield/riot/buckler, /obj/item/shield/riot/tele)
	skill_requirements = list(SKILL_TECHNICAL = EXP_LOW)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/glass/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/melee/baton/cattleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1)
	skill_requirements = list(SKILL_TECHNICAL = EXP_LOW)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/teleprod
	name = "Teleprod"
	result = /obj/item/melee/baton/cattleprod/teleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/ore/bluespace_crystal = 1)
	skill_requirements = list(
		SKILL_TECHNICAL = EXP_MID,
		SKILL_SCIENCE = EXP_LOW,
	)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6)
	time = 2 SECONDS // 15 faster than crafting them by hand!
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/watcherbola
	name = "Watcher Bola"
	result = /obj/item/restraints/legcuffs/bola/watcher
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/animalhide/goliath_hide = 2,
				/obj/item/restraints/handcuffs/cable/sinew = 1)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/gonbola
	name = "Gonbola"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6,
				/obj/item/stack/sheet/animalhide/gondola = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_RANGED // You throw it. That's why it's ranged.

/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
	            /obj/item/stack/sheet/metal = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
	            /obj/item/stack/cable_coil = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
	            /obj/item/stack/cable_coil = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/greatruinousknife
	name = "Great Ruinous Knife"
	result = /obj/item/kitchen/knife/ritual/holy/strong
	reqs = list(/obj/item/kitchen/knife/ritual/holy = 1,
	            /obj/item/stack/sheet/ruinous_metal = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bloodyruinousknife
	name = "Blood Soaked Ruinous Knife"
	result = /obj/item/kitchen/knife/ritual/holy/strong/blood
	reqs = list(/obj/item/kitchen/knife/ritual/holy/strong = 1,
	            /obj/item/stack/sheet/runed_metal = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/pipebow
	name = "Pipe Bow"
	result = /obj/item/gun/ballistic/bow/pipe
	reqs = list(/obj/item/pipe = 5,
				/obj/item/stack/sheet/plastic = 5,
				/obj/item/weaponcrafting/silkstring = 1)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 9 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/maint
	name = "Makeshift Bow"
	result = /obj/item/gun/ballistic/bow/maint
	reqs = list(/obj/item/pipe = 5,
           		/obj/item/stack/tape = 3,
				/obj/item/stack/cable_coil = 10)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/woodenbow
	name = "Wooden Bow"
	result = /obj/item/gun/ballistic/bow
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/weaponcrafting/silkstring = 1)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 7 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/woodencrossbow
	name = "Wooden Crossbow"
	result = /obj/item/gun/ballistic/bow/crossbow
	reqs = list(/obj/item/gun/ballistic/bow = 1,
				/obj/item/stack/sheet/mineral/wood = 2,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/weaponcrafting/receiver = 1,
				/obj/item/weaponcrafting/stock = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/ishotgun
	name = "Improvised Shotgun"
	result = /obj/item/gun/ballistic/shotgun/doublebarrel/improvised
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	skill_requirements = list(SKILL_MECHANICAL = EXP_MID)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/gauss
	name = "Makeshift gauss rifle"
	reqs = list(/obj/item/stock_parts/cell = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/weaponcrafting/receiver = 1,
				/obj/item/stack/tape = 1,
				/obj/item/stack/rods = 4,
				/obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_WRENCH)
	skill_requirements = list(
		SKILL_MECHANICAL = EXP_LOW,
		SKILL_TECHNICAL = EXP_LOW,
		SKILL_SCIENCE = EXP_LOW,
	)
	result = /obj/item/gun/ballistic/gauss
	time = 12
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/maint_musket
	name = "Maintenance Musket"
	reqs = list(/obj/item/pipe = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_WRENCH)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	result = /obj/item/gun/ballistic/maint_musket
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/sledgehammer
	name = "Sledgehammer"
	result = /obj/item/melee/sledgehammer
	reqs = list(/obj/item/stack/sheet/mineral/wood = 4,
				/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/metal = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	result = /obj/item/melee/sledgehammer
	time = 8 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/melee/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stack/sheet/plasteel = 5)
	tool_behaviors = list(TOOL_WELDER)
	skill_requirements = list(SKILL_MECHANICAL = EXP_MID)
	time = 5 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/melee/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/shard = 1)
	time = 4 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/extendohand
	name = "Extendo-Hand"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/plastic/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	skill_requirements = list(
		SKILL_TECHNICAL = EXP_MID,
		SKILL_SCIENCE = EXP_MID,
	)
	time = 3 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/chemical_payload2
	name = "Chemical Payload (Gibtonite)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/melee/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	skill_requirements = list(
		SKILL_TECHNICAL = EXP_MID,
		SKILL_SCIENCE = EXP_MID,
	)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/goliathshield
	name = "Goliath Shield"
	result = /obj/item/shield/riot/goliath
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bonesword
	name = "Bone Sword"
	result = /obj/item/claymore/bone
	time = 4 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 3,
				/obj/item/stack/sheet/sinew = 2)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bone_bow
	name = "Bone Bow"
	result = /obj/item/gun/ballistic/bow/ashen
	time = 8 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 8,
				/obj/item/stack/sheet/sinew = 4)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bone_crossbow
	name = "Bone Crossbow"
	result = /obj/item/gun/ballistic/bow/crossbow/ashen
	time = 10 SECONDS
	reqs = list(/obj/item/gun/ballistic/bow/ashen = 1,
				/obj/item/claymore/bone = 1,
				/obj/item/stack/sheet/sinew = 3)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bonedagger
	name = "Bone Dagger"
	result = /obj/item/kitchen/knife/combat/bone
	time = 2 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 2)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/bonespear
	name = "Bone Spear"
	result = /obj/item/melee/spear/bonespear
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 4,
				 /obj/item/stack/sheet/sinew = 1)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/fireaxe/boneaxe
	time = 5 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 6,
				 /obj/item/stack/sheet/sinew = 3)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/chitinspear
	name = "Chitin Spear"
	result = /obj/item/melee/spear/bonespear/chitinspear //take a bonespear, reinforce it with some chitin and resin, profit?
	time = 7.5 SECONDS
	reqs = list(/obj/item/melee/spear/bonespear = 1,
				/obj/item/stack/sheet/sinew = 3,
				/obj/item/stack/sheet/ashresin = 1,
				/obj/item/stack/sheet/animalhide/weaver_chitin = 6)
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "Pneumatic Cannon"
	result = /obj/item/pneumatic_cannon/ghetto
	tool_behaviors = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/packageWrap = 8,
				/obj/item/pipe = 2)
	skill_requirements = list(SKILL_MECHANICAL = EXP_LOW)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

// Shank - Makeshift weapon that can embed on throw
/datum/crafting_recipe/shank
	name = "Shank"
	reqs = list(/obj/item/shard = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/cable_coil = 10)
	result = /obj/item/kitchen/knife/shank
	time = 1 SECONDS
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/plug_bayonet
	name = "Plug Bayonet"
	reqs = list(/obj/item/kitchen/knife = 1,
			/obj/item/stack/sheet/mineral/wood = 1)
	result = /obj/item/kitchen/knife/plug_bayonet
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 10 SECONDS
	category = CAT_WEAPON_MELEE

// Ammo

/datum/crafting_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/laserbuckshot
	name = "Laser Buckshot Shell"
	result = /obj/item/ammo_casing/shotgun/laserbuckshot
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 2)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/thundershot
	name = "Thundershot Shell"
	result = /obj/item/ammo_casing/shotgun/thundershot
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/super = 1,
				/datum/reagent/teslium = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/depleteduraniumslug
	name = "Depleted Uranium Slug Shell"
	result = /obj/item/ammo_casing/shotgun/uraniumpenetrator
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stack/sheet/mineral/uranium = 2,
				/obj/item/stack/rods = 2,
				/datum/reagent/thermite = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/cryoshot
	name = "Cryoshot Shell"
	result = /obj/item/ammo_casing/shotgun/cryoshot
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/medicine/c2/rhigoxane = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/ripslug
	name = "Ripslug Shell"
	result = /obj/item/ammo_casing/shotgun/rip
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stack/sheet/mineral/plastitanium = 5,
				/obj/item/stock_parts/micro_laser/quadultra = 1) // to split the slug duh
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO	

/datum/crafting_recipe/anarchy
	name = "Anarchy Shell"
	result = /obj/item/ammo_casing/shotgun/anarchy
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stack/sheet/plastic = 5, // uhh because we dont have rubber and this is as close as i can get?
				/obj/item/stack/sheet/mineral/silver = 5) // mirrors are inlaid with silver so light reflects, so clearly it helps them reflect too, right?
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bolts
	name = "Bolts"
	result = /obj/item/ammo_casing/caseless/bolts
	reqs = list(/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WIRECUTTER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/cartridge_welder
	name = "Cartridge Welding Fuel" //Reversed so that they're together in the menu
	result = /obj/item/ammo_casing/caseless/cartridge
	reqs = list(/obj/item/clothing/torncloth = 1,
				/datum/reagent/fuel = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 2 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/cartridge_BP
	name = "Cartridge Black Powder"
	result = /obj/item/ammo_casing/caseless/cartridge/black_powder
	reqs = list(/obj/item/clothing/torncloth = 1,
				/datum/reagent/blackpowder = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 2 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/wood_arrow
	name = "Wood Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/wood
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/rods = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/ashen_arrow
	name = "Ashen Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/ash
	tool_behaviors = list(TOOL_WELDER)
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow/wood = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bone_tipped_arrow
	name = "Bone-Tipped Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/bone_tipped
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow/ash = 1,
				/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bone_arrow
	name = "Bone Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/bone
	time = 1.5 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 1,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/chitin_arrow
	name = "Chitin Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/chitin
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow/bone = 1,
				/obj/item/stack/sheet/sinew = 1,
				/obj/item/stack/sheet/ashresin = 1,
				/obj/item/stack/sheet/animalhide/weaver_chitin = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bamboo_arrow
	name = "Bamboo Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/bamboo
	time = 1.5 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/bamboo = 2)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bronze_arrow
	name = "Bronze Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/bronze
	time = 1.5 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/tile/bronze = 1)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/glass_arrow
	name = "Glass Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/glass
	time = 1.5 SECONDS
	reqs = list(/obj/item/shard = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/cable_coil = 3)
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/plasma_glass_arrow
	name = "Plasmaglass Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/glass/plasma
	time = 1.5 SECONDS
	reqs = list(/obj/item/shard/plasma = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/cable_coil = 3)
	category = CAT_WEAPON_AMMO
