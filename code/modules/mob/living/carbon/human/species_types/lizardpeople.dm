#define LIZARD_SLOWDOWN "coldlizard" //define used for the lizard speedboost

/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Vuulek"
	plural_form = "Vuulen"
	id = SPECIES_LIZARD
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,DIGITIGRADE,LIPS,HAS_FLESH,HAS_BONE,HAS_TAIL)
	inherent_traits = list(TRAIT_COLDBLOODED)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_REPTILE
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings")
	mutanttongue = /obj/item/organ/tongue/lizard
	mutanttail = /obj/item/organ/tail/lizard
	coldmod = 0.67 //used to being cold, just doesn't like it much
	heatmod = 0.67 //greatly appreciate heat, just not too much
	default_features = list("mcolor" = "#00FF00", "tail_lizard" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	attack_verbs = list("slash", "scratch", "claw")
	attack_effect = ATTACK_EFFECT_CLAW
	barefoot_step_sound = FOOTSTEP_MOB_CLAW
	creampie_id = "creampie_lizard"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	disliked_food = SUGAR | VEGETABLES
	liked_food = MEAT | GRILLED | SEAFOOD | MICE | FRUIT
	inert_mutation = FIREBREATH
	deathsound = 'sound/voice/lizard/deathsound.ogg'
	screamsound = 'yogstation/sound/voice/lizardperson/lizard_scream.ogg' // Yog - not pitched bear growls
	wings_icon = "Dragon"
	species_language_holder = /datum/language_holder/lizard
	var/heat_stunmod = 0
	var/last_heat_stunmod = 0
	var/regrowtimer

	smells_like = "putrid scales"

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/lizard/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/H)
	..()
	last_heat_stunmod = heat_stunmod  //Saves previous mod
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
		heat_stunmod = 1		//lizard gets faster when warm
	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTCOLD))
		switch(H.bodytemperature)
			if(200 to BODYTEMP_COLD_DAMAGE_LIMIT)	//but slower
				heat_stunmod = -1
			if(120 to 200)
				heat_stunmod = -2		//and slower
			else
				heat_stunmod = -3		//and sleepier as they get colder
	else
		heat_stunmod = 0
	var/heat_stun_mult = 1.1**(last_heat_stunmod - heat_stunmod) //1.1^(difference between last and current values)
	if(heat_stun_mult != 1) 		//If they're the same 1.1^0 is 1, so no change, if we go up we divide by 1.1
		stunmod *= heat_stun_mult 	//however many times, and if it goes down we multiply by 1.1
						//This gets us an effective stunmod of 0.91, 1, 1.1, 1.21, 1.33, based on temp

/datum/species/lizard/movement_delay(mob/living/carbon/human/H)//to handle the slowdown based on cold
	. = ..()
	if(heat_stunmod && !HAS_TRAIT(H, TRAIT_IGNORESLOWDOWN) && H.has_gravity())
		H.add_movespeed_modifier(LIZARD_SLOWDOWN, update=TRUE, priority=100, multiplicative_slowdown= -heat_stunmod/3, blacklisted_movetypes=FLOATING)//between a 0.33 speedup and a 1 slowdown
	else if(H.has_movespeed_modifier(LIZARD_SLOWDOWN))
		H.remove_movespeed_modifier(LIZARD_SLOWDOWN)

/datum/species/lizard/get_butt_sprite()
	return BUTT_SPRITE_LIZARD

/datum/species/lizard/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.remove_movespeed_modifier(LIZARD_SLOWDOWN)

/datum/species/lizard/spec_fully_heal(mob/living/carbon/human/H)
	. = ..()
	H.remove_movespeed_modifier(LIZARD_SLOWDOWN)

/datum/species/lizard/spec_life(mob/living/carbon/human/H)
	. = ..()
	if((H.client && H.client.prefs.read_preference(/datum/preference/toggle/mood_tail_wagging)) && !is_wagging_tail() && H.mood_enabled)
		var/datum/component/mood/mood = H.GetComponent(/datum/component/mood)
		if(!istype(mood) || !(mood.shown_mood >= MOOD_LEVEL_HAPPY2))
			return
		var/chance = 0
		switch(mood.shown_mood)
			if(-INFINITY to MOOD_LEVEL_SAD4)
				chance = -0.1
			if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
				chance = -0.01
			if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
				chance = 0.001
			if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
				chance = 0.1
			if(MOOD_LEVEL_HAPPY4 to INFINITY)
				chance = 1
		if(prob(abs(chance)))
			switch(SIGN(chance))
				if(1)
					H.emote("wag")
				if(-1)
					stop_wagging_tail(H)
	if(!H.getorganslot(ORGAN_SLOT_TAIL) && !regrowtimer)
		regrowtimer = addtimer(CALLBACK(src, PROC_REF(regrow_tail), H), 20 MINUTES, TIMER_UNIQUE)

/datum/species/lizard/proc/regrow_tail(mob/living/carbon/human/H)
	if(!H.getorganslot(ORGAN_SLOT_TAIL) && H.stat != DEAD)
		var/obj/item/organ/tail/lizard/tail = new mutanttail()
		tail.color = H.dna.features["mcolor"]
		tail.tail_type = H.dna.features["tail_lizard"]
		tail.spines = H.dna.features["spines"]
		tail.Insert(H, TRUE)
		H.visible_message("[H]'s tail regrows.","You feel your tail regrow.")

/datum/species/lizard/get_footprint_sprite()
	return FOOTPRINT_SPRITE_CLAWS

/datum/species/lizard/get_species_description()
	return "The first sentient beings encountered by the SIC outside of the Sol system, vuulen are the most \
		commonly encountered non-human species in SIC space. Despite being one of the most integrated species in the SIC, they \
		are also one of the most heavily discriminated against."

/datum/species/lizard/get_species_lore()
	return list(
		"Born on the planet of Sangris, vuulen evolved from raptor-like creatures and quickly became the \
		dominant species thanks to the warm climate of the planet and their intelligence combined with relatively \
		dexterous claws. Vuulen developed similarly to humans technologically and geopolitically, mastering fire, \
		agriculture, writing, metalworking, architecture, and the applications of plasma; empires rose and fell; \
		varied and rich cultures emerged and grew. By the time first contact occurred between humans and vuulen, \
		the latter were a kind of medieval age, having even dabbled with the bluespace crystals naturally present \
		on the planet, albeit without success.",

		"The SIC was highly interested in Sangris for two reasons when it was discovered. The first was the \
		discovery of sapient life. The second was the great plethora of plasma and bluespace located on the planet. \
		A diplomatic team was quickly assembled, but the first contact turned violent. Afterwards, the SIC waged war \
		to conquer Sangris, doing so in a year due to the gap of technology and size between the two civilizations. \
		The remaining vuulek powers were assimilated into the newly-formed Opsillian Republic, and humans began populating the \
		planet. Vuulen were not citizens of the SIC, but still under its control through the Opsillian Republic. \
		Slavery was common, and most slaves were pressed into hazardous conditions in the collection or processing \
		of several of the planet's rich plasma veins. As time went on, the vuulen became gradually more accepted into \
		the human society. Finally, in 2463, the official interdiction of slavery was passed, and vuulen became full \
		citizens of the SIC. The Opsillian Republic went from a mere puppet state to a somewhat independent and legitimate government, \
		though many human companies continued to exploit vuulen as workers, as labor laws for non-humans \
		offered significantly less privilege than what would be expected.",

		"Vuulek communities are organized in clans, though their impact on the culture of the individuals is limited. \
		They tend to live like humans due to their colonization, only occasionally practicing some of \
		their clan traditions. Despite efforts to integrate vuulen into the SIC through establishments such \
		as habituation stations, a certain pridefulness nonetheless survived amongst vuulen, as they're often \
		eager to prove their worth and qualities. In addition, strength and honor are still values commonly held \
		by vuulen. Awareness of the past atrocities committed against vuulen by the SIC vary greatly \
		between individuals, both amongst humans and vuulen.",

		"Today, the vuulek societies have been almost completely assimilated in the SIC, \
		and vuulen are now considered SIC citizens and claim almost all the same rights as humans \
		do. However, lawyers still struggle in rigged courts to try and claim a sense of equality \
		for all those who exist in the SIC as honest citizens. Humans and vuulen exist side by side \
		across the SIC in harmony, but without much fraternity. While full-blown hostility is rare, \
		prejudice is common.",
	)

// Override for the default temperature perks, so we can give our specific "cold blooded" perk.
/datum/species/lizard/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "thermometer-half",
		SPECIES_PERK_NAME = "Cold-Blooded",
		SPECUES_PERK_DESC = "Vuulen are cold-blooded, and have evolved to withstand extreme temperatures for longer than most. \
							They're also affected by temperature psychologically, becoming more awake and alert in heat, but grow tired and drowsy in the cold.",
		),
		list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "commenting",
		SPECIES_PERK_NAME = "Reptilian Ssspeech",
		SPECIES_PERK_DESC = "Vuulen have a forked tongue, similar to that of a snake. \
							They have a tendency to hisss when ssspeaking.",
		),
	)

	return to_add

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = SPECIES_LIZARD_ASH
	limbs_id = SPECIES_LIZARD
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE,HAS_FLESH,HAS_BONE,HAS_TAIL)
	inherent_traits = list(TRAIT_NOGUNS) //yogs start - ashwalkers have special lungs and actually breathe
	mutantlungs = /obj/item/organ/lungs/ashwalker // yogs end
	species_language_holder = /datum/language_holder/lizard/ash //ashwalker dum

// yogs start - Ashwalkers now have ash immunity
/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.weather_immunities |= WEATHER_ASH

/datum/species/lizard/ashwalker/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.weather_immunities &= ~WEATHER_ASH

//Ash walker shaman, worse defensive stats, but better at surgery and have a healing touch ability
/datum/species/lizard/ashwalker/shaman
	name = "Ash Walker Shaman"
	id = SPECIES_LIZARD_ASH_SHAMAN
	armor = -1 //more of a support than a standard ashwalker, don't get hit
	brutemod = 1.15
	burnmod = 1.15
	speedmod = -0.1 //similar to ethereals, should help with saving others
	punchdamagehigh = 7
	punchstunthreshold = 7
	action_speed_coefficient = 0.9 //they're smart and efficient unlike other lizards
	species_language_holder = /datum/language_holder/lizard/shaman
	var/datum/action/cooldown/spell/touch/heal/lizard_touch

//gives the heal spell
/datum/species/lizard/ashwalker/shaman/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	lizard_touch = new(C)
	lizard_touch.Grant(C)

//removes the heal spell
/datum/species/lizard/ashwalker/shaman/on_species_loss(mob/living/carbon/C)
	. = ..()
	QDEL_NULL(lizard_touch)

///Adds up to a total of 40 assuming they're hurt by both brute and burn
#define LIZARD_HEAL_AMOUNT 20

//basic touch ability that heals brute and burn, only accessed by the ashwalker shaman
/datum/action/cooldown/spell/touch/heal
	name = "Healing Touch"
	desc = "This spell charges your hand with the vile energy of the Necropolis, permitting you to undo some external injuries from a target."
	panel = "Ashwalker"
	button_icon_state = "spell_default"
	hand_path = /obj/item/melee/touch_attack/healtouch

	school = SCHOOL_EVOCATION
	invocation = "BE REPLENISHED!!"
	invocation_type = INVOCATION_SHOUT

	sound = 'sound/magic/staff_healing.ogg'
	cooldown_time = 20 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/touch/heal/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/touch/heal/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/target, mob/living/carbon/caster)
	new /obj/effect/temp_visual/heal(get_turf(target), "#899d39")
	target.heal_overall_damage(LIZARD_HEAL_AMOUNT, LIZARD_HEAL_AMOUNT, 0, BODYPART_ANY, TRUE) //notice it doesn't heal toxins, still need to learn chems for that
	return TRUE

#undef LIZARD_HEAL_AMOUNT

/obj/item/melee/touch_attack/healtouch
	name = "\improper Healing Touch"
	desc = "A blaze of life-granting energy from the hand. Heals minor to moderate injuries."
	icon_state = "touchofdeath" //ironic huh //no
	item_state = "touchofdeath"
/*
 Lizard subspecies: DRACONIDS
 These guys only come from the dragon's blood bottle from lavaland. They're basically just lizards with all-around marginally better stats and fire resistance.
 Sadly they only get digitigrade legs. Can't have everything!
*/
/datum/species/lizard/draconid
	name = "Draconid"
	id = SPECIES_LIZARD_DRACONID
	limbs_id = SPECIES_LIZARD
	fixed_mut_color = "#A02720" 	//Deep red
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE,HAS_FLESH,HAS_BONE,HAS_TAIL)
	inherent_traits = list(TRAIT_RESISTHEAT)	//Dragons like fire, not cold blooded because they generate fire inside themselves or something
	burnmod = 0.8
	brutemod = 0.9 //something something dragon scales
	punchdamagelow = 3
	punchdamagehigh = 12
	punchstunthreshold = 12	//+2 claws of powergaming

/datum/species/lizard/draconid/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.weather_immunities |= WEATHER_ASH

/datum/species/lizard/draconid/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.weather_immunities &= ~WEATHER_ASH

// yogs end

/datum/species/lizard/has_toes()
	return TRUE

#undef LIZARD_SLOWDOWN

/datum/species/lizard/get_cough_sound(mob/living/carbon/human/lizard)
	if(lizard.gender == FEMALE)
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


/datum/species/lizard/get_cry_sound(mob/living/carbon/human/lizard)
	if(lizard.gender == FEMALE)
		return pick(
			'sound/voice/human/female_cry1.ogg',
			'sound/voice/human/female_cry2.ogg',
		)
	return pick(
		'sound/voice/human/male_cry1.ogg',
		'sound/voice/human/male_cry2.ogg',
		'sound/voice/human/male_cry3.ogg',
	)


/datum/species/lizard/get_sneeze_sound(mob/living/carbon/human/lizard)
	if(lizard.gender == FEMALE)
		return 'sound/voice/human/female_sneeze1.ogg'
	return 'sound/voice/human/male_sneeze1.ogg'

/datum/species/lizard/get_laugh_sound(mob/living/carbon/human)
	if(!istype(human))
		return
	return 'sound/voice/lizard/lizard_laugh1.ogg'
