/datum/species/moth
	name = "Ex'hai"
	plural_form = "Ex'hau"
	id = SPECIES_MOTH
	say_mod = "flutters"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYESPRITES,HAS_FLESH,HAS_BONE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("moth_wings")
	default_features = list("moth_wings" = "Plain")
	attack_verbs = list("slash")
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/moth
	liked_food = VEGETABLES | SUGAR
	disliked_food = DAIRY | GROSS
	toxic_food = MEAT | RAW | SEAFOOD | MICE
	burnmod = 1.25 //Fluffy and flammable
	brutemod = 0.9 //Evasive buggers
	punchdamagehigh = 9 //Weird fluffy bug fist
	punchstunchance = 0 //No stun punches
	mutanteyes = /obj/item/organ/eyes/moth
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/mothmen

	deathsound = 'sound/voice/moth/moth_death.ogg'

	smells_like = "dusty dryness"

/datum/species/moth/regenerate_organs(mob/living/carbon/C, datum/species/old_species, replace_current = TRUE, visual_only = FALSE)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)

/datum/species/moth/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name()

	var/randname = moth_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/moth/get_butt_sprite()
	return BUTT_SPRITE_FUZZY

/datum/species/moth/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	. = ..()
	if(.) //if the mob is immune to fire, don't burn wings off.
		return
	if(H.dna.features["moth_wings"] != "Burnt Off" && H.bodytemperature >= 800 && H.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(H, span_danger("Your precious wings burn to a crisp!"))
		H.dna.features["moth_wings"] = "Burnt Off"
		handle_mutant_bodyparts(H)

/datum/species/moth/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, chem.metabolization_rate)
		return FALSE
	return ..()

/datum/species/moth/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 9 //flyswatters deal 10x damage to moths
	return 0

/datum/species/moth/space_move(mob/living/carbon/human/H)
	. = ..()
	if(H.loc && !isspaceturf(H.loc) && H.dna.features["moth_wings"] != "Burnt Off")
		var/datum/gas_mixture/current = H.loc.return_air()
		if(current && (current.return_pressure() >= ONE_ATMOSPHERE*0.85)) //as long as there's reasonable pressure and no gravity, flight is possible
			return TRUE

/datum/species/moth/get_species_description()
	return "Ex'hau, also known as mothpeople, are one of the two other spacefaring species that the SIC encountered. \
		While generally appreciated due to their fluffiness, their biology makes them unsuitable to living in most planetary gravities."

/datum/species/moth/get_species_lore()
	return list(
		"Originating from the low-gravity planet Wallalius, ex'hau evolved from nocturnal, herbivorous insects \
		that lived under the canopy formed by the gigantic flora. While ex'hau sent their first rocket into orbit \
		around 1762, the scarcity of metal on their planet along with the frailty of their body made them only able to land \
		on their moon S'lai in 1902. In 2323 they encountered the ethereals, then they discovered humanity in 2463, \
		developing a cordial relationship with the former and managing to remain at peace with the latter.",

		"While the SIC was initially wary of the ex'hau, mothperson biology renders them unable to live in many \
		biomes and the distance between the two civilization has minimized potential conflicts and competitions \
		for the colonization of nearby space. Trade and travel between the SIC and the various ex'hai nations is \
		not uncommon; Wallalian earthsblood is a significantly valuable good for its medicinal properties, and the ex'hau \
		are always in need of more industrial metals, which the SIC can easily provide.",

		"The ex'hau are absolutely fascinated by light due to their very sensitive eyes, often focusing all their attention to it. \
		While fuzzy and physically unassuming, ex'hau can prove to be very aggressive when confident in their chances of winning \
		or when they feel threatened. They are extremely protective of their wings, as losing them being an incredibly \
		distressing experience and a source of great shame.",

		"Many ex'hau can be encountered in SIC space where gravity is low, such as colonies on gas giants or spacecrafts. \
		Experimental treatments even allow a few of them to live, albeit difficultly, in normal planetary gravity. \
		They can come for a variety of mundane reasons, such as finding work or wanting to see new horizons.",
	)

/datum/species/moth/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "feather-alt",
			SPECIES_PERK_NAME = "Flutter-Wings",
			SPECIES_PERK_DESC = "Ex'hau naturally have large, delicate wings. They can fly in pressurized, zero-g environments and safely land \
								short falls using them. Take care however, as they're easily burnt off.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "scroll",
			SPECIES_PERK_NAME = "Silky Sustenance",
			SPECIES_PERK_DESC = "Ex'hau are able to feed off proteins found in most fabrics, letting them eat cloth and most clothing for nourishment.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fa-solid fa-eye",
			SPECIES_PERK_NAME = "Nocturnal Eyes",
			SPECIES_PERK_DESC = "Ex'hau have very sensitive eyes. Welding may need more than one layer of protection, \
				and sunglasses won't shield them from flashes.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "mosquito",
			SPECIES_PERK_NAME = "Fluffy Pests",
			SPECIES_PERK_DESC = "Ex'hau are very similar to insects genetically, and are hurt much more by fly swatters and insecticides.",
		),
	)

	return to_add

/datum/species/moth/get_scream_sound(mob/living/carbon/human)
	return 'sound/voice/moth/scream_moth.ogg'

/datum/species/moth/get_cough_sound(mob/living/carbon/human/moth)
	if(moth.gender == FEMALE)
		return pick(
			'sound/voice/human/female_cough1.ogg',
			'sound/voice/human/female_cough2.ogg',
			'sound/voice/human/female_cough3.ogg',
			'sound/voice/human/female_cough4.ogg',
			'sound/voice/human/female_cough5.ogg',
			'sound/voice/human/female_cough6.ogg',
		)
	return pick(
		'sound/voice/human/male_cough1.ogg',
		'sound/voice/human/male_cough2.ogg',
		'sound/voice/human/male_cough3.ogg',
		'sound/voice/human/male_cough4.ogg',
		'sound/voice/human/male_cough5.ogg',
		'sound/voice/human/male_cough6.ogg',
	)


/datum/species/moth/get_cry_sound(mob/living/carbon/human/moth)
	if(moth.gender == FEMALE)
		return pick(
			'sound/voice/human/female_cry1.ogg',
			'sound/voice/human/female_cry2.ogg',
		)
	return pick(
		'sound/voice/human/male_cry1.ogg',
		'sound/voice/human/male_cry2.ogg',
		'sound/voice/human/male_cry3.ogg',
	)


/datum/species/moth/get_sneeze_sound(mob/living/carbon/human/moth)
	if(moth.gender == FEMALE)
		return 'sound/voice/human/female_sneeze1.ogg'
	return 'sound/voice/human/male_sneeze1.ogg'


/datum/species/moth/get_laugh_sound(mob/living/carbon/human)
	if(!istype(human))
		return
	return 'sound/voice/moth/moth_laugh1.ogg'
