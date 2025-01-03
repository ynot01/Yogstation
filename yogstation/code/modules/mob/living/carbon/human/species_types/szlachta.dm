/datum/species/szlachta 
	name = "Szlachta"
	id = "szlachta"
	limbs_id = "szlachta"
	possible_genders = list(PLURAL)
	nojumpsuit = TRUE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN
	siemens_coeff = 0
	brutemod = 0.5
	burnmod = 0.75
	stunmod = 0.5
	punchdamagelow = 12
	punchdamagehigh = 19 //hardcore
	punchstunchance = 0.3
	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_SUITSTORE, ITEM_SLOT_HEAD)
	species_traits = list(NO_UNDERWEAR,NO_DNA_COPY,NOTRANSSTING,NOEYESPRITES,NOFLASH)
	inherent_traits = list(TRAIT_NOGUNS, TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,
							TRAIT_NOBREATH, TRAIT_RADIMMUNE, TRAIT_VIRUSIMMUNE, TRAIT_PIERCEIMMUNE, TRAIT_NODISMEMBER,
							TRAIT_MONKEYLIKE, TRAIT_NOCRITDAMAGE, TRAIT_GENELESS, TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT, TRAIT_HARDLY_WOUNDED, TRAIT_HUSK)
	mutanteyes = /obj/item/organ/eyes/alien

/datum/species/szlachta/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.real_name = "towering monstrosity"
	C.name = C.real_name
	if(C.mind)
		C.mind.name = C.real_name
	C.dna.real_name = C.real_name
