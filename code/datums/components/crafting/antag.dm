///////////////////////////////////////////////////
/// 				Antag recipes				///
// see granters.dm - at the top for easy viewing //
///////////////////////////////////////////////////

// Weapons
/datum/crafting_recipe/metal_baseball_bat
	name = "Titanium Baseball Bat"
	result = /obj/item/melee/baseball_bat/metal_bat
	reqs = list(/obj/item/stack/sheet/mineral/titanium = 10
				)
	tool_behaviors = list(TOOL_WELDER) // To weld the bat together.
	category = CAT_WEAPON_MELEE
	always_available = FALSE

/datum/crafting_recipe/lance
	name = "Explosive Lance (Grenade)"
	result = /obj/item/melee/spear
	reqs = list(/obj/item/melee/spear = 1,
				/obj/item/grenade = 1)
	blacklist = list(/obj/item/melee/spear/explosive,
					/obj/item/grenade/flashbang)
	parts = list(/obj/item/melee/spear = 1,
				/obj/item/grenade = 1)
	time = 1.5 SECONDS
	category = CAT_WEAPON_MELEE
	always_available = FALSE

/datum/crafting_recipe/knifeboxing
	name = "Knife-boxing Gloves"
	result = /obj/item/clothing/gloves/knifeboxing
	reqs = list(/obj/item/clothing/gloves/boxing = 1,
				/obj/item/kitchen/knife = 2)
	time = 10 SECONDS
	category = CAT_WEAPON_MELEE
	always_available = FALSE

/datum/crafting_recipe/pipebomb
	name = "Pipe Bomb"
	result = /obj/item/grenade/pipebomb
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/pipe = 1,
				/obj/item/assembly/mousetrap = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_WRENCH, TOOL_WIRECUTTER)
	time = 1.5 SECONDS
	category = CAT_WEAPON_RANGED
	skill_requirements = list(
		SKILL_MECHANICAL = EXP_MID,
		SKILL_TECHNICAL = EXP_HIGH,
		SKILL_SCIENCE = EXP_LOW,
	) // this is such a good idea

/datum/crafting_recipe/flamethrower
	name = "Flamethrower"
	result = /obj/item/gun/flamethrower
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/assembly/igniter = 1,
				/obj/item/weldingtool = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	skill_requirements = list(
		SKILL_MECHANICAL = EXP_LOW,
		SKILL_SCIENCE = EXP_LOW,
	)
	time = 1 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftpistol
	name = "Makeshift Pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/makeshift
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/rods = 2,
           		/obj/item/stack/tape = 3)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 12 SECONDS
	category = CAT_WEAPON_RANGED
	always_available = FALSE

/datum/crafting_recipe/makeshiftsuppressor
	name = "Makeshift Suppressor"
	result = /obj/item/suppressor/makeshift
	reqs = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/cloth = 2,
           		/obj/item/stack/tape = 1)
	time = 12 SECONDS
	category = CAT_MISC
	always_available = FALSE

// Ammo

/datum/crafting_recipe/makeshiftmagazine
	name = "Makeshift Pistol Magazine (10mm)"
	result = /obj/item/ammo_box/magazine/m10mm/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 2,
        		/obj/item/stack/tape = 2)
	time = 12 SECONDS
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/datum/crafting_recipe/bola_arrow
	name = "Bola Arrow"
	result = /obj/item/ammo_casing/reusable/arrow
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow = 1,
				/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/restraints/legcuffs/bola = 1)
	blacklist = list(/obj/item/ammo_casing/reusable/arrow/toy)
	parts = list(/obj/item/ammo_casing/reusable/arrow = 1, /obj/item/restraints/handcuffs/cable = 1, /obj/item/restraints/legcuffs/bola = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/datum/crafting_recipe/explosive_arrow
	name = "Explosive Arrow"
	result = /obj/item/ammo_casing/reusable/arrow
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow = 1,
				/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/grenade = 1)
	blacklist = list(/obj/item/ammo_casing/reusable/arrow/toy)
	parts = list(/obj/item/ammo_casing/reusable/arrow = 1, /obj/item/restraints/handcuffs/cable = 1, /obj/item/grenade = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/datum/crafting_recipe/flaming_arrow
	name = "Fire Arrow"
	result = /obj/item/ammo_casing/reusable/arrow
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow = 1,
				/obj/item/stack/sheet/cloth = 1,
				/datum/reagent/fuel = 10)
	blacklist = list(/obj/item/ammo_casing/reusable/arrow/toy)
	parts = list(/obj/item/ammo_casing/reusable/arrow = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/datum/crafting_recipe/syringe_arrow
	name = "Syringe Arrow"
	result = /obj/item/ammo_casing/reusable/arrow
	time = 1.5 SECONDS
	reqs = list(/obj/item/ammo_casing/reusable/arrow = 1,
				/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/reagent_containers/syringe = 1)
	blacklist = list(/obj/item/ammo_casing/reusable/arrow/toy)
	parts = list(/obj/item/ammo_casing/reusable/arrow = 1, /obj/item/restraints/handcuffs/cable = 1, /obj/item/reagent_containers/syringe = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/*
/datum/crafting_recipe/supermatter_sliver_arrow
	name = "Supermatter Sliver Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/supermatter/sliver
	time = 5 SECONDS // Need to be very careful
	reqs = list(/obj/item/nuke_core/supermatter_sliver = 1,
				/obj/item/scalpel/supermatter = 1,	// Needed so the sliver doesn't destroy the rod and so atmos techs can't mass produce instant dust arrows
				/obj/item/stack/rods = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE

/datum/crafting_recipe/singularity_shard_arrow
	name = "Singularity Shard Arrow"
	result = /obj/item/ammo_casing/reusable/arrow/singulo
	time = 5 SECONDS
	reqs = list(/obj/item/singularity_shard = 1,
				/obj/item/stack/rods = 1, 
				/obj/item/stack/cable_coil = 3)
	parts = list(/obj/item/singularity_shard = 1)
	category = CAT_WEAPON_AMMO
	always_available = FALSE
*/
