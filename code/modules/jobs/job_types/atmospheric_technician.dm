/datum/job/atmos
	title = "Atmospheric Technician"
	description = "Ensure the air is breathable on the station, fill oxygen tanks, fight fires, purify the air."
	orbit_icon = "fire-extinguisher"
	department_head = list("Chief Engineer")
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	alt_titles = list("Life-support Technician", "Fire Suppression Specialist", "Atmospherics Trainee", "Environmental Maintainer", "Fusion Specialist")

	outfit = /datum/outfit/job/atmos

	added_access = list(ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE)
	base_access = list(ACCESS_ENGINEERING, ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MECH_ENGINE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG
	display_order = JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN
	minimal_character_age = 24 //Intense understanding of thermodynamics, gas law, gas interaction, construction and safe containment of gases, creation of new ones, math beyond your wildest imagination

	base_skills = list(
		SKILL_PHYSIOLOGY = EXP_NONE,
		SKILL_MECHANICAL = EXP_LOW,
		SKILL_TECHNICAL = EXP_NONE,
		SKILL_SCIENCE = EXP_LOW,
		SKILL_FITNESS = EXP_LOW,
	)
	skill_points = 3

	departments_list = list(
		/datum/job_department/engineering,
	)

	mail_goodies = list(
		///obj/item/rpd_upgrade/unwrench = 30,
		/obj/item/grenade/gas_crystal/crystal_foam = 10,
		/obj/item/grenade/gas_crystal/pluonium_crystal = 10,
		/obj/item/grenade/gas_crystal/healium_crystal = 10,
		/obj/item/grenade/gas_crystal/nitrous_oxide_crystal = 5,
		/obj/item/clothing/suit/space/hardsuit/engine/atmos = 1,
	)
	
	minimal_lightup_areas = list(/area/engine/atmos)

	smells_like = "a gas leak"

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos

	pda_type = /obj/item/modular_computer/tablet/pda/preset/atmos

	belt = /obj/item/storage/belt/utility/atmostech
	ears = /obj/item/radio/headset/headset_eng
	digitigrade_shoes = /obj/item/clothing/shoes/xeno_wraps/engineering
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	uniform_skirt = /obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt
	r_pocket = /obj/item/analyzer

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer

	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/atmos/rig
	name = "Atmospheric Technician (Hardsuit)"

	mask = /obj/item/clothing/mask/gas
	suit = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
