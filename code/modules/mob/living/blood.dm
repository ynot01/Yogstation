#define BLOOD_DRIP_RATE_MOD 90 //Greater number means creating blood drips more often while bleeding

/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/monkey/handle_blood()
	if(bodytemperature <= TCRYO || (HAS_TRAIT(src, TRAIT_HUSK))) //cryosleep or husked people do not pump the blood.
		return

	var/temp_bleed = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		temp_bleed += BP.get_bleed_rate()
		BP.generic_bleedstacks = max(0, BP.generic_bleedstacks - 1)
	if(temp_bleed)
		bleed(temp_bleed)

	//Blood regeneration if there is some space
	if(blood_volume < BLOOD_VOLUME_NORMAL(src))
		blood_volume += 0.1 // regenerate blood VERY slowly
		if(blood_volume < BLOOD_VOLUME_OKAY(src))
			adjustOxyLoss(round((BLOOD_VOLUME_NORMAL(src) - blood_volume) * 0.02, 1))

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()

	if((NOBLOOD in dna.species.species_traits) || bleedsuppress || (HAS_TRAIT(src, TRAIT_FAKEDEATH)) || (STABLEBLOOD in dna.species.species_traits))
		return

	if(mind && IS_BLOODSUCKER(src)) // Prevents Bloodsuckers from naturally regenerating Blood - Even while on masquerade
		return

	if(HAS_TRAIT(src, TRAIT_NOPULSE)) // Fulpstation Bloodsuckers edit - Dont regenerate blood, damnmit!
		return

	if(bodytemperature >= TCRYO && !(HAS_TRAIT(src, TRAIT_HUSK))) //cryosleep or husked people do not pump the blood.

		//Blood regeneration if there is some space
		if(blood_volume < BLOOD_VOLUME_NORMAL(src) && !HAS_TRAIT(src, TRAIT_NOHUNGER) && !HAS_TRAIT(src, TRAIT_NO_BLOOD_REGEN))
			var/obj/item/organ/heart = getorganslot(ORGAN_SLOT_HEART)
			var/heart_ratio = heart ? heart.get_organ_efficiency() : 0.5 //slower blood regeneration without a heart, or with a broken one </3
			var/nutrition_ratio = 0
			switch(nutrition)
				if(0 to NUTRITION_LEVEL_STARVING)
					nutrition_ratio = 0.2
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					nutrition_ratio = 0.4
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					nutrition_ratio = 0.6
				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
					nutrition_ratio = 0.8
				else
					nutrition_ratio = 1
			if(satiety > 80)
				nutrition_ratio *= 1.25
			nutrition_ratio *= heart_ratio
			adjust_nutrition(-nutrition_ratio * HUNGER_FACTOR)
			blood_volume = min(BLOOD_VOLUME_NORMAL(src), blood_volume + 0.5 * nutrition_ratio)

		//Effects of bloodloss
		var/word = pick("dizzy","woozy","faint")
		switch(get_blood_state())
			if(BLOOD_OKAY)
				if(prob(5))
					to_chat(src, span_warning("You feel [word]."))
				adjustOxyLoss(round((BLOOD_VOLUME_NORMAL(src) - blood_volume) * 0.01, 1))
			if(BLOOD_BAD)
				adjustOxyLoss(round((BLOOD_VOLUME_NORMAL(src) - blood_volume) * 0.02, 1))
				if(prob(5))
					adjust_eye_blur(6)
					to_chat(src, span_warning("You feel very [word]."))
			if(BLOOD_SURVIVE)
				adjustOxyLoss(5)
				if(prob(15))
					Unconscious(rand(20,60))
					to_chat(src, span_warning("You feel extremely [word]."))
			if(BLOOD_DEAD) // This little bit of code here is pretty much the only reason why BLOOD_DEAD exists at all
				if(!HAS_TRAIT(src, TRAIT_NODEATH))
					death()

		var/temp_bleed = 0
		//Bleeding out
		for(var/X in bodyparts)
			var/obj/item/bodypart/BP = X
			temp_bleed += BP.get_bleed_rate()
			BP.generic_bleedstacks = max(0, BP.generic_bleedstacks - 1)

		if(temp_bleed)
			bleed(temp_bleed)
			bleed_warn(temp_bleed)


//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/proc/bleed(amt)
	if(!blood_volume)
		return
	blood_volume = max(blood_volume - amt, 0)

	//Blood loss still happens in locker, floor stays clean
	if(isturf(loc) && prob(sqrt(amt)*BLOOD_DRIP_RATE_MOD))
		add_splatter_floor(loc, (amt <= 10))

/mob/living/carbon/human/bleed(amt)
	amt *= physiology.bleed_mod
	if(!(NOBLOOD in dna.species.species_traits))
		..()


/// A helper to see how much blood we're losing per tick
/mob/living/carbon/proc/get_bleed_rate()
	if(!blood_volume)
		return
	var/bleed_amt = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/iter_bodypart = X
		bleed_amt += iter_bodypart.get_bleed_rate()
	return bleed_amt

/mob/living/carbon/human/get_bleed_rate()
	if((NOBLOOD in dna.species.species_traits))
		return
	. = ..()
	. *= physiology.bleed_mod

/**
 * bleed_warn() is used to for carbons with an active client to occasionally receive messages warning them about their bleeding status (if applicable)
 *
 * Arguments:
 * * bleed_amt- When we run this from [/mob/living/carbon/human/proc/handle_blood] we already know how much blood we're losing this tick, so we can skip tallying it again with this
 * * forced-
 */
/mob/living/carbon/proc/bleed_warn(bleed_amt = 0, forced = FALSE)
	if(!blood_volume || !client)
		return
	if(!COOLDOWN_FINISHED(src, bleeding_message_cd) && !forced)
		return

	if(!bleed_amt) // if we weren't provided the amount of blood we lost this tick in the args
		bleed_amt = get_bleed_rate()

	var/bleeding_severity = ""
	var/next_cooldown = BLEEDING_MESSAGE_BASE_CD

	switch(bleed_amt)
		if(-INFINITY to 0)
			return
		if(0 to 1)
			bleeding_severity = "You feel light trickles of blood across your skin"
			next_cooldown *= 2.5
		if(1 to 3)
			bleeding_severity = "You feel a small stream of blood running across your body"
			next_cooldown *= 2
		if(3 to 5)
			bleeding_severity = "You skin feels clammy from the flow of blood leaving your body"
			next_cooldown *= 1.7
		if(5 to 7)
			bleeding_severity = "Your body grows more and more numb as blood streams out"
			next_cooldown *= 1.5
		if(7 to INFINITY)
			bleeding_severity = "Your heartbeat thrashes wildly trying to keep up with your bloodloss"

	var/rate_of_change = ", but it's getting better." // if there's no wounds actively getting bloodier or maintaining the same flow, we must be getting better!
	if(HAS_TRAIT(src, TRAIT_COAGULATING)) // if we have coagulant, we're getting better quick
		rate_of_change = ", but it's clotting up quickly!"
	else
		// flick through our wounds to see if there are any bleeding ones getting worse or holding flow (maybe move this to handle_blood and cache it so we don't need to cycle through the wounds so much)
		for(var/i in all_wounds)
			var/datum/wound/iter_wound = i
			if(!iter_wound.blood_flow)
				continue
			var/iter_wound_roc = iter_wound.get_bleed_rate_of_change()
			switch(iter_wound_roc)
				if(BLOOD_FLOW_INCREASING) // assume the worst, if one wound is getting bloodier, we focus on that
					rate_of_change = ", <b>and it's getting worse!</b>"
					break
				if(BLOOD_FLOW_STEADY) // our best case now is that our bleeding isn't getting worse
					rate_of_change = ", and it's holding steady."
				if(BLOOD_FLOW_DECREASING) // this only matters if none of the wounds fit the above two cases, included here for completeness
					continue

	to_chat(src, span_warning("[bleeding_severity][rate_of_change]"))
	COOLDOWN_START(src, bleeding_message_cd, next_cooldown)

/mob/living/carbon/human/bleed_warn(bleed_amt = 0, forced = FALSE)
	if(!(NOBLOOD in dna.species.species_traits))
		return ..()

/mob/living/proc/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL(src)

/mob/living/carbon/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL(src)
	for(var/i in bodyparts)
		var/obj/item/bodypart/BP = i
		BP.generic_bleedstacks = 0

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, total_amount, forced)
	if(!blood_volume || !AM.reagents)
		return FALSE
	if(blood_volume < BLOOD_VOLUME_BAD(src) && !forced)
		return FALSE

	if(blood_volume < total_amount)
		total_amount = blood_volume

	var/blood_id = get_blood_id()
	if(!blood_id)
		return FALSE

	var/amount = total_amount
	var/chems_amount = 0
	var/blood_proportion = (blood_volume > 0 || reagents.total_volume > 0) ? blood_volume / (blood_volume + reagents.total_volume) : 1

	if((1 - blood_proportion) * total_amount >= 0.1)
		amount = total_amount * blood_proportion
		chems_amount = total_amount * (1 - blood_proportion)

	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(src)
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_blood_volume -= amount
	blood_volume -= amount

	var/list/blood_data = get_blood_data(blood_id)

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(blood_id == C.get_blood_id())//both mobs have the same blood substance
			if(blood_id == /datum/reagent/blood) //normal blood
				if(blood_data["viruses"])
					for(var/thing in blood_data["viruses"])
						var/datum/disease/D = thing
						if((D.spread_flags & DISEASE_SPREAD_SPECIAL) || (D.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
							continue
						C.ForceContractDisease(D)
				var/datum/blood_type/blood_type = blood_data["blood_type"]
				if(!(blood_type.type in C.dna.blood_type.compatible_types))
					C.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
					return TRUE

			C.blood_volume = min(C.blood_volume + round(amount, 0.1), BLOOD_VOLUME_MAXIMUM(C))
			return TRUE

	AM.reagents.add_reagent(blood_id, amount, blood_data, bodytemperature)
	if(chems_amount)
		reagents.trans_to(AM, chems_amount)
	return TRUE


/mob/living/proc/get_blood_data(blood_id)
	return

/mob/living/carbon/get_blood_data(blood_id)
	if(blood_id == /datum/reagent/blood) //actual blood reagent
		var/blood_data = list()
		//set the blood data
		blood_data["donor"] = src
		blood_data["viruses"] = list()

		for(var/thing in diseases)
			var/datum/disease/D = thing
			blood_data["viruses"] += D.Copy()

		blood_data["blood_DNA"] = dna.unique_enzymes
		if(disease_resistances && disease_resistances.len)
			blood_data["resistances"] = disease_resistances.Copy()
		var/list/temp_chem = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			temp_chem[R.type] = R.volume
		blood_data["trace_chem"] = list2params(temp_chem)
		if(mind)
			blood_data["mind"] = mind
		else if(last_mind)
			blood_data["mind"] = last_mind
		if(ckey)
			blood_data["ckey"] = ckey
		else if(last_mind)
			blood_data["ckey"] = ckey(last_mind.key)

		if(!suiciding)
			blood_data["cloneable"] = 1
		blood_data["blood_type"] = dna.blood_type
		blood_data["gender"] = gender
		blood_data["real_name"] = real_name
		blood_data["features"] = dna.features
		blood_data["factions"] = faction
		blood_data["quirks"] = list()
		for(var/V in roundstart_quirks)
			var/datum/quirk/T = V
			blood_data["quirks"] += T.type
		return blood_data

//get the id of the substance this mob use as blood.
/mob/proc/get_blood_id()
	return

/mob/living/simple_animal/get_blood_id()
	if(blood_volume)
		return /datum/reagent/blood

/mob/living/carbon/monkey/get_blood_id()
	if(!(HAS_TRAIT(src, TRAIT_HUSK)))
		return /datum/reagent/blood

/mob/living/carbon/human/get_blood_id()
	if(HAS_TRAIT(src, TRAIT_HUSK))
		return
	if(NOBLOOD in dna.species.species_traits)
		return
	if(SSgamemode.holidays && SSgamemode.holidays[APRIL_FOOLS] && mind?.assigned_role == "Clown")
		return /datum/reagent/colorful_reagent
	if(dna.species.exotic_blood)
		return dna.species.exotic_blood
	return /datum/reagent/blood

/proc/random_blood_type()
	return get_blood_type(pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+"))

/proc/get_blood_type(type)
	return GLOB.blood_types[type]

/proc/get_blood_dna_color(list/blood_dna)
	if(!blood_dna)
		return null
	var/blood_print = blood_dna[length(blood_dna)]
	var/datum/blood_type/blood_type = blood_dna[blood_print]
	if(!blood_type)
		return null
	if(!istype(blood_type))//maybe a letter somehow got passed here, check anyways
		blood_type = get_blood_type(blood_type)
	if(!blood_type || !istype(blood_type))
		return null
	return blood_type.color

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T, small_drip)
	if(get_blood_id() != /datum/reagent/blood)
		return
	if(!T)
		T = get_turf(src)
	var/list/temp_blood_DNA
	if(small_drip)
		if(!QDELETED(T.liquids)) //just add it to our liquids
			var/list/blood_drop = list(get_blood_id() = 0.1)
			T.add_liquid_list(blood_drop, FALSE, 300)
			return
		// Only a certain number of drips (or one large splatter) can be on a given turf.
		var/obj/effect/decal/cleanable/blood/drip/drop = locate() in T
		if(drop)
			if(drop.drips < 5)
				drop.drips++
				drop.add_overlay(pick(drop.random_icon_states))
				drop.transfer_mob_blood_dna(src)
				if(isethereal(src))
					drop.Etherealify()
				return
			else
				temp_blood_DNA = drop.return_blood_DNA() //we transfer the dna from the drip to the splatter
				qdel(drop)//the drip is replaced by a bigger splatter
		else
			drop = new(T, get_static_viruses())
			drop.transfer_mob_blood_dna(src)
			if(isethereal(src))
				drop.Etherealify()
			return

	// Find a blood decal or create a new one.
	var/obj/effect/decal/cleanable/blood/B = locate() in T
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(T, get_static_viruses())
	B.bloodiness = min((B.bloodiness + BLOOD_AMOUNT_PER_DECAL), BLOOD_POOL_MAX)
	B.transfer_mob_blood_dna(src) //give blood info to the blood decal.
	if(temp_blood_DNA)
		B.add_blood_DNA(temp_blood_DNA)
	if(isethereal(src))
		B.Etherealify()

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(!(NOBLOOD in dna.species.species_traits))
		..()

/mob/living/carbon/alien/add_splatter_floor(turf/T, small_drip)
	if(!T)
		T = get_turf(src)
	var/obj/effect/decal/cleanable/xenoblood/B = locate() in T.contents
	if(!B)
		B = new(T)
	B.add_blood_DNA(list("UNKNOWN DNA" = "X*"))

/mob/living/silicon/robot/add_splatter_floor(turf/T, small_drip)
	if(!T)
		T = get_turf(src)
	var/obj/effect/decal/cleanable/oil/B = locate() in T.contents
	if(!B)
		B = new(T)
