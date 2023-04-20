/datum/bounty/item/atmos
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but CentCom ignores that fact.
	var/gas_type

/datum/bounty/item/atmos/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	return T.air_contents.get_moles(gas_type) >= moles_required

/datum/bounty/item/atmos/simple/pluoxium
	name = "Full Tank of Pluoxium"
	description = "CentCom RnD is researching extra compact internals. Ship us a tank full of Pluoxium and you'll be compensated. (20 Moles)"
	reward = 2500
	gas_type = /datum/gas/pluoxium

/datum/bounty/item/atmos/simple/nitrium_tank
	name = "Full Tank of Nitrium"
	description = "The non-human staff of Station 88 has been volunteered to test performance enhancing drugs. Ship them a tank full of Nitrium so they can get started. (20 Moles)"
	reward = 12000
	gas_type = /datum/gas/nitrium

/datum/bounty/item/atmos/simple/tritium_tank
	name = "Full Tank of Tritium"
	description = "Station 49 is looking to kickstart their research program. Ship them a tank full of Tritium. (20 Moles)"
	reward = 3500
	gas_type = /datum/gas/tritium

/datum/bounty/item/atmos/simple/freon_tank
	name = "Full Tank of Freon"
	description = "The Supermatter of station 33 has started the delamination process. Deliver a tank of Freon gas to help them stop it! (20 Moles)"
	reward = 4500
	gas_type = /datum/gas/freon

/datum/bounty/item/atmos/simple/healium_tank
	name = "Full Tank of Healium"
	description = "Station 42's medical staff are working on an experimental cryogenics setup. They need a tank of Healium. (20 Moles)"
	reward = 8000
	gas_type = /datum/gas/healium

/datum/bounty/item/atmos/complex/zauker_tank
	name = "Full Tank of Zauker"
	description = "The main planet of \[REDACTED] has been chosen as testing grounds for the new weapon that uses Zauker gas. Ship us a tank full of it. (20 Moles)"
	reward = 25000
	gas_type = /datum/gas/zauker

/datum/bounty/item/atmos/complex/hypernob_tank
	name = "Full Tank of Hypernoblium"
	description = "Station 26's atmospheric division has had a mishap with an experimental fusion mix. Some Hyper-Noblium would be appreciated. (20 Moles)"
	reward = 15000
	gas_type = /datum/gas/hypernoblium

/datum/bounty/item/h2metal/metallic_hydrogen_armor
	name = "Metallic Hydrogen Armors"
	description = "Nanotrasen is requiring new armor to be made. Ship them some metallic hydrogen armors."
	reward = 8000
	required_count = 1
	wanted_types = list(/obj/item/clothing/suit/armor/elder_atmosian)

/datum/bounty/item/h2metal/metallic_hydrogen_helmet
	name = "Metallic Hydrogen Armors"
	description = "Nanotrasen is requiring new helmet to be made. Ship them some metallic hydrogen helmets."
	reward = 7000
	required_count = 1
	wanted_types = list(/obj/item/clothing/head/helmet/elder_atmosian)

/datum/bounty/item/h2metal/metallic_hydrogen_axe
	name = "Metallic Hydrogen Axes"
	description = "Nanotrasen is requiring new axes to be made. Ship them some metallic hydrogen helmets."
	reward = 7500
	required_count = 3
	wanted_types = list(/obj/item/twohanded/fireaxe/metal_h2_axe)

/datum/bounty/item/supermatter_silver
	name = "Supermatter Silvers"
	description = "Nanotrasen engineering team wants to build a new supermatter engine. Ship them 2 supermatter silvers."
	reward = 50000
	required_count = 2
	wanted_types = list(/obj/item/nuke_core/supermatter_sliver)
