#define PERF_BASE_DAMAGE		0.5
/// Required strange reagent for revival.
#define REQUIRED_STRANGE_REAGENT_FOR_REVIVAL 2
///maximum volume for touch chemicals to heal with
#define TOUCH_CHEM_MAX 60

/////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	name = "Medicine"
	taste_description = "bitterness"

/datum/reagent/medicine/on_mob_life(mob/living/carbon/M)
	current_cycle++
	holder.remove_reagent(type, metabolization_rate / M.metabolism_efficiency) //medicine reagents stay longer if you have a better metabolism

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	description = "Leporazine will effectively regulate a patient's body temperature, ensuring it never leaves safe levels."
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/medicine/leporazine/on_mob_life(mob/living/carbon/M)
	if(M.bodytemperature > BODYTEMP_NORMAL)
		M.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	else if(M.bodytemperature < (BODYTEMP_NORMAL + 1))
		M.adjust_bodytemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	..()

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#C8A5DC" // rgb: 200, 165, 220
	can_synth = FALSE
	taste_description = "badmins"

/datum/reagent/medicine/adminordrazine/on_mob_life(mob/living/carbon/M)
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0, 0)
	M.setOxyLoss(0, 0)
	M.radiation = 0
	M.heal_bodypart_damage(5,5)
	M.adjustToxLoss(-5, 0, TRUE)
	M.hallucination = 0
	REMOVE_TRAITS_NOT_IN(M, list(SPECIES_TRAIT, ROUNDSTART_TRAIT, ORGAN_TRAIT))
	M.set_blurriness(0)
	M.set_blindness(0)
	M.SetKnockdown(0, FALSE)
	M.SetStun(0, FALSE)
	M.SetUnconscious(0, FALSE)
	M.SetParalyzed(0, FALSE)
	M.SetImmobilized(0, FALSE)
	M.silent = FALSE
	M.dizziness = 0
	M.disgust = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.slurring = 0
	M.confused = 0
	M.SetSleeping(0, 0)
	M.jitteriness = 0
	if(M.blood_volume < BLOOD_VOLUME_NORMAL(M))
		M.blood_volume = BLOOD_VOLUME_NORMAL(M)

	M.cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)
	for(var/organ in M.internal_organs)
		var/obj/item/organ/O = organ
		O.setOrganDamage(0)
	for(var/thing in M.diseases)
		var/datum/disease/D = thing
		if(D.severity == DISEASE_SEVERITY_POSITIVE)
			continue
		D.cure()
	..()
	. = 1

/datum/reagent/medicine/adminordrazine/quantum_heal
	name = "Quantum Medicine"
	description = "Rare and experimental particles, that apparently swap the user's body with one from an alternate dimension where it's completely healthy."
	taste_description = "science"

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	description = "Increases resistance to stuns as well as reducing drowsiness and hallucinations."
	color = "#FF00FF"

/datum/reagent/medicine/synaptizine/on_mob_life(mob/living/carbon/M)
	M.drowsyness = max(M.drowsyness-5, 0)
	M.AdjustStun(-20, FALSE)
	M.AdjustKnockdown(-20, FALSE)
	M.AdjustUnconscious(-20, FALSE)
	M.AdjustImmobilized(-20, FALSE)
	M.AdjustParalyzed(-20, FALSE)
	if(holder.has_reagent(/datum/reagent/toxin/mindbreaker))
		holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(30))
		M.adjustToxLoss(1, 0)
		. = 1
	..()

/datum/reagent/medicine/synaphydramine
	name = "Diphen-Synaptizine"
	description = "Reduces drowsiness, hallucinations, and Histamine from body."
	color = "#EC536D" // rgb: 236, 83, 109

/datum/reagent/medicine/synaphydramine/on_mob_life(mob/living/carbon/M)
	M.drowsyness = max(M.drowsyness-5, 0)
	if(holder.has_reagent(/datum/reagent/toxin/mindbreaker))
		holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)
	if(holder.has_reagent(/datum/reagent/toxin/histamine))
		holder.remove_reagent(/datum/reagent/toxin/histamine, 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(30))
		M.adjustToxLoss(1, 0)
		. = 1
	..()

/datum/reagent/medicine/inacusiate
	name = "Inacusiate"
	description = "Instantly restores all hearing to the patient, but does not cure deafness."
	color = "#6600FF" // rgb: 100, 165, 255

/datum/reagent/medicine/inacusiate/on_mob_life(mob/living/carbon/M)
	M.restoreEars()
	..()

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the patient's body temperature must be under 270K for it to metabolise correctly."
	color = "#0000C8"
	taste_description = "sludge"
	overdose_threshold = 100 //no chugging

/datum/reagent/medicine/cryoxadone/on_mob_life(mob/living/carbon/M)
	var/power = -0.00006 * (M.bodytemperature ** 2) + 6
	if(M.bodytemperature < T0C)
		M.adjustOxyLoss(-3 * power, 0)
		M.adjustBruteLoss(-power, 0)
		M.adjustFireLoss(-power, 0)
		M.adjustToxLoss(-power, 0, TRUE) //heals TOXINLOVERs
		M.adjustCloneLoss(-power, 0)
		if(prob(10))
			M.Knockdown(2 SECONDS)
			to_chat(M, span_danger("You feel woozy."))
		if(prob(10))
			M.drop_all_held_items()
			to_chat(M, span_danger("You lose concentration."))
		for(var/i in M.all_wounds)
			var/datum/wound/iter_wound = i
			iter_wound.on_xadone(power)
		REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC) //fixes common causes for disfiguration
		. = 1
	metabolization_rate = REAGENTS_METABOLISM * (0.00001 * (M.bodytemperature ** 2) + 0.5)
	..()

/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	description = "A chemical that derives from Cryoxadone. It specializes in healing clone damage, but nothing else. Requires very cold temperatures to properly metabolize, and metabolizes quicker than cryoxadone."
	color = "#0000C8"
	taste_description = "muscle"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/clonexadone/on_mob_life(mob/living/carbon/M)
	if(M.bodytemperature < T0C && M.IsSleeping()) //yes you have to be in cryo shut up and drink your corn syrup
		M.adjustCloneLoss(0.001 * (M.bodytemperature ** 2) - 100, 0)
		REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
		. = 1
	metabolization_rate = REAGENTS_METABOLISM * (0.000015 * (M.bodytemperature ** 2) + 0.75)
	..()

/datum/reagent/medicine/pyroxadone
	name = "Pyroxadone"
	description = "A mixture of cryoxadone and slime jelly, that apparently inverses the requirement for its activation."
	color = "#f7832a"
	taste_description = "spicy jelly"

/datum/reagent/medicine/pyroxadone/on_mob_life(mob/living/carbon/M)
	if(M.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
		var/power = 0
		switch(M.bodytemperature)
			if(BODYTEMP_HEAT_DAMAGE_LIMIT to 400)
				power = 2
			if(400 to 460)
				power = 3
			else
				power = 5
		if(M.on_fire)
			power *= 2

		M.adjustOxyLoss(-2 * power, 0)
		M.adjustBruteLoss(-power, 0)
		M.adjustFireLoss(-1.5 * power, 0)
		M.adjustToxLoss(-power, 0, TRUE)
		M.adjustCloneLoss(-power, 0)
		for(var/i in M.all_wounds)
			var/datum/wound/iter_wound = i
			iter_wound.on_xadone(power)
		REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
		. = 1
	..()

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	description = "A powder derived from fish toxin, Rezadone can effectively treat genetic damage as well as restoring minor wounds. Overdose will cause intense nausea and minor toxin damage."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose_threshold = 30
	taste_description = "fish"

/datum/reagent/medicine/rezadone/on_mob_life(mob/living/carbon/M)
	M.adjustCloneLoss(-10) //Rezadone is almost always used over cryoxadone. Hopefully this will change that.
	M.heal_bodypart_damage(1,1)
	REMOVE_TRAIT(M, TRAIT_DISFIGURED, TRAIT_GENERIC)
	..()
	. = 1

/datum/reagent/medicine/rezadone/overdose_process(mob/living/M)
	M.adjustToxLoss(1, 0)
	M.Dizzy(5)
	M.Jitter(5)
	..()
	. = 1

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	description = "Spaceacillin will prevent a patient from conventionally spreading any diseases they are currently infected with. Also reduces infection in serious burns."
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

//Goon Chems. Ported mainly from Goonstation. Easily mixable (or not so easily) and provide a variety of effects.
/datum/reagent/medicine/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	description = "If used in touch-based applications, immediately restores burn wounds as well as restoring more over time. The chemical will heal up to 45 points of damage at 45 units applied. If ingested through other means, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/medicine/silver_sulfadiazine/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjustToxLoss(0.5*reac_volume)
			if(show_message)
				to_chat(M, span_warning("You don't feel so good..."))
		else if(M.getFireLoss())
			var/datum/reagent/S = M.reagents?.get_reagent(/datum/reagent/medicine/silver_sulfadiazine)
			var/heal_amt = clamp(reac_volume, 0, TOUCH_CHEM_MAX * 0.75 - S?.volume)
			M.adjustFireLoss(-heal_amt)
			if(show_message)
				to_chat(M, span_danger("You feel your burns healing! It stings like hell!"))
			M.emote("scream")
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
			if(method == TOUCH)
				M.reagents.add_reagent(/datum/reagent/medicine/silver_sulfadiazine, reac_volume)
	..()

/datum/reagent/medicine/silver_sulfadiazine/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-0.5*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/oxandrolone
	name = "Oxandrolone"
	description = "Stimulates the healing of severe burns. Extremely rapidly heals severe burns and slowly heals minor ones. Overdose will worsen existing burns."
	reagent_state = LIQUID
	color = "#f7ffa5"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

/datum/reagent/medicine/oxandrolone/on_mob_life(mob/living/carbon/M)
	if(M.getFireLoss() > 25)
		M.adjustFireLoss(-4*REM, 0) //Twice as effective as silver sulfadiazine for severe burns
	else
		M.adjustFireLoss(-0.5*REM, 0) //But only a quarter as effective for more minor ones
	..()
	. = 1

/datum/reagent/medicine/oxandrolone/overdose_process(mob/living/M)
	if(M.getFireLoss()) //It only makes existing burns worse
		M.adjustFireLoss(4.5*REM, FALSE, FALSE, BODYPART_ORGANIC) // it's going to be healing either 4 or 0.5
		. = 1
	..()

/datum/reagent/medicine/styptic_powder
	name = "Styptic Powder"
	description = "If used in touch-based applications, immediately restores bruising as well as restoring more over time. The chemical will heal up to 45 points of damage at 45 units applied. If ingested through other means, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#FF9696"

/datum/reagent/medicine/styptic_powder/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjustToxLoss(0.5*reac_volume)
			if(show_message)
				to_chat(M, span_warning("You don't feel so good..."))
		else if(M.getBruteLoss())
			var/datum/reagent/S = M.reagents?.get_reagent(/datum/reagent/medicine/styptic_powder)
			var/heal_amt = clamp(reac_volume, 0, TOUCH_CHEM_MAX * 0.75 - S?.volume)
			M.adjustBruteLoss(-heal_amt)
			if(show_message)
				to_chat(M, span_danger("You feel your bruises healing! It stings like hell!"))
			M.emote("scream")
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
			if(method == TOUCH)
				M.reagents.add_reagent(/datum/reagent/medicine/styptic_powder, reac_volume)
	..()


/datum/reagent/medicine/styptic_powder/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-0.5*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/salglu_solution
	name = "Saline-Glucose Solution"
	description = "Has a 33% chance per metabolism cycle to heal brute and burn damage. Can be used as a temporary blood substitute, as well as slowly speeding blood regeneration."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60
	taste_description = "sweetness and salt"
	var/last_added = 0
	var/max_blood_decrement = 10 //Yogs -- How much less than BLOOD_VOLUME_NORMAL(M) is the point where salglu stops refilling blood?
	//^ Used so that normal blood regeneration can continue with salglu active
	var/extra_regen = 0.25 // in addition to acting as temporary blood, also add this much to their actual blood per tick

/datum/reagent/medicine/salglu_solution/on_mob_life(mob/living/carbon/M)
	if(last_added)
		M.blood_volume -= last_added
		last_added = 0
	var/max_blood = BLOOD_VOLUME_NORMAL(M) - max_blood_decrement // The highest blood volume that salglu will work at.
	if(M.blood_volume < max_blood)
		var/amount_to_add = min(M.blood_volume, volume*5)
		var/new_blood_level = min(M.blood_volume + amount_to_add, max_blood)
		last_added = new_blood_level - M.blood_volume
		M.blood_volume = new_blood_level + extra_regen
	if(prob(33))
		M.adjustBruteLoss(-0.5*REM, 0)
		M.adjustFireLoss(-0.5*REM, 0)
		. = TRUE
	..()

/datum/reagent/medicine/salglu_solution/overdose_process(mob/living/M)
	if(prob(3))
		to_chat(M, "<span class = 'warning'>You feel salty.</span>")
		holder.add_reagent(/datum/reagent/consumable/sodiumchloride, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	else if(prob(3))
		to_chat(M, "<span class = 'warning'>You feel sweet.</span>")
		holder.add_reagent(/datum/reagent/consumable/sugar, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	if(prob(33))
		M.adjustBruteLoss(0.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(0.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = TRUE
	..()

/datum/reagent/medicine/mine_salve
	name = "Miner's Salve"
	description = "A powerful painkiller. Restores bruising and burns in addition to making the patient believe they are fully healed. Also great for treating severe burn wounds in a pinch."
	reagent_state = LIQUID
	color = "#6D6374"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/medicine/mine_salve/on_mob_life(mob/living/carbon/C)
	C.hal_screwyhud = SCREWYHUD_HEALTHY
	C.adjustBruteLoss(-0.25*REM, 0)
	C.adjustFireLoss(-0.25*REM, 0)
	..()
	return TRUE

/datum/reagent/medicine/mine_salve/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST, VAPOR, INJECT))
			M.adjust_nutrition(-5)
			if(show_message)
				to_chat(M, span_warning("Your stomach feels empty and cramps!"))
		else
			var/mob/living/carbon/C = M
			for(var/s in C.surgeries)
				var/datum/surgery/S = s
				S.success_multiplier = max(0.1, S.success_multiplier)
				// +10% success propability on each step, useful while operating in less-than-perfect conditions

			if(show_message)
				to_chat(M, span_danger("You feel your injuries fade away to nothing!") )
	..()

/datum/reagent/medicine/mine_salve/on_mob_end_metabolize(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/N = M
		N.hal_screwyhud = SCREWYHUD_NONE
	..()

/datum/reagent/medicine/synthflesh
	name = "Synthflesh"
	description = "Has a 100% chance of instantly healing brute and burn damage on corpses. The chemical will heal up to 120 points of damage at 60 units applied. Touch application only."
	reagent_state = LIQUID
	color = "#FFEBEB"

/datum/reagent/medicine/synthflesh/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	var/can_heal = FALSE
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if (M.stat == DEAD)
			can_heal = TRUE
		if((method in list(PATCH, TOUCH)) && can_heal)
			for(var/i in C.all_wounds)
				var/datum/wound/iter_wound = i
				iter_wound.on_synthflesh(reac_volume)
			var/datum/reagent/S = M.reagents.get_reagent(/datum/reagent/medicine/synthflesh)
			if(!ishuman(M))
				M.adjustBruteLoss(-1.25 * reac_volume)
				M.adjustFireLoss(-1.25 * reac_volume)
			else
				var/heal_amt = clamp(reac_volume, 0, TOUCH_CHEM_MAX - S?.volume)
				M.adjustBruteLoss(-2*heal_amt)
				M.adjustFireLoss(-2*heal_amt)
				if(method == TOUCH)
					M.reagents.add_reagent(/datum/reagent/medicine/synthflesh, reac_volume)
				if(HAS_TRAIT_FROM(M, TRAIT_HUSK, BURN) && (S?.volume + reac_volume >= SYNTHFLESH_UNHUSK_AMOUNT && M.getFireLoss() <= UNHUSK_DAMAGE_THRESHOLD) && M.cure_husk(BURN)) //cure husk will return true if it cures the final husking source
					M.visible_message(span_notice("The synthflesh soaks into [M]'s burns and they regain their natural color!"))
	..()

/datum/reagent/medicine/charcoal
	name = "Charcoal"
	description = "Heals toxin damage as well as slowly removing any other chemicals the patient has in their bloodstream."
	reagent_state = LIQUID
	color = "#000000"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "ash"

/datum/reagent/medicine/charcoal/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(-2*REM, 0)
	. = 1
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type,1)
	..()

/datum/reagent/medicine/system_cleaner
	name = "System Cleaner"
	description = "Neutralizes harmful chemical compounds inside synthetic systems."
	reagent_state = LIQUID
	color = "#F1C40F"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	process_flags = SYNTHETIC

/datum/reagent/medicine/system_cleaner/on_mob_life(mob/living/M)
	M.adjustToxLoss(-2*REM, 0)
	. = 1
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type,1)
	..()

/datum/reagent/medicine/liquid_solder
	name = "Liquid Solder"
	description = "Repairs brain damage in synthetics."
	color = "#727272"
	taste_description = "metallic"
	process_flags = SYNTHETIC

/datum/reagent/medicine/liquid_solder/on_mob_life(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3*REM)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(prob(10) && C.has_trauma_type(BRAIN_TRAUMA_SPECIAL))
			C.cure_trauma_type(BRAIN_TRAUMA_SPECIAL)
		else if(prob(10) && C.has_trauma_type(BRAIN_TRAUMA_MILD))
			C.cure_trauma_type(BRAIN_TRAUMA_MILD)
	..()

/datum/reagent/medicine/omnizine
	name = "Omnizine"
	description = "Slowly heals all damage types. Overdose will cause damage in all types instead."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	var/healing = 0.5
	overdose_threshold = 30
	process_flags = ORGANIC | SYNTHETIC

/datum/reagent/medicine/omnizine/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(-healing*REM, 0)
	M.adjustOxyLoss(-healing*REM, 0)
	M.adjustBruteLoss(-healing*REM, 0)
	M.adjustFireLoss(-healing*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/omnizine/overdose_process(mob/living/M)
	M.adjustToxLoss(1.5*REM, 0)
	M.adjustOxyLoss(1.5*REM, 0)
	M.adjustBruteLoss(1.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
	M.adjustFireLoss(1.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
	..()
	. = 1

/datum/reagent/medicine/omnizine/protozine
	name = "Protozine"
	description = "A less environmentally friendly and somewhat weaker variant of omnizine."
	color = "#d8c7b7"
	healing = 0.2

/datum/reagent/medicine/calomel
	name = "Calomel"
	description = "Quickly purges the body of all chemicals. Toxin damage is dealt if the patient is in good condition."
	reagent_state = LIQUID
	color = "#19C832"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "acid"

/datum/reagent/medicine/calomel/on_mob_life(mob/living/carbon/M)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type,2.5)
	if(M.health > 20)
		M.adjustToxLoss(2.5*REM, 0)
		. = 1
	..()

/datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	description = "Efficiently restores low radiation damage."
	reagent_state = LIQUID
	color = "#14FF3C"
	metabolization_rate = 2 * REAGENTS_METABOLISM

/datum/reagent/medicine/potass_iodide/on_mob_life(mob/living/carbon/M)
	if(M.radiation > 0)
		M.radiation -= min(M.radiation, 8)
	..()

/datum/reagent/medicine/pen_acid
	name = "Pentetic Acid"
	description = "Reduces massive amounts of radiation and toxin damage while purging other chemicals from the body."
	reagent_state = LIQUID
	color = "#E6FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/pen_acid/on_mob_life(mob/living/carbon/M)
	M.radiation -= max(M.radiation-RAD_MOB_SAFE, 0)/50
	M.adjustToxLoss(-2*REM, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.type,2)
	..()
	. = 1

/datum/reagent/medicine/sal_acid
	name = "Salicyclic Acid"
	description = "Stimulates the healing of severe bruises. Extremely rapidly heals severe bruising and slowly heals minor ones. Overdose will worsen existing bruising."
	reagent_state = LIQUID
	color = "#D2D2D2"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25


/datum/reagent/medicine/sal_acid/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() > 25)
		M.adjustBruteLoss(-4*REM, 0) //Twice as effective as styptic powder for severe bruising
	else
		M.adjustBruteLoss(-0.5*REM, 0) //But only a quarter as effective for more minor ones
	..()
	. = 1

/datum/reagent/medicine/sal_acid/overdose_process(mob/living/M)
	if(M.getBruteLoss()) //It only makes existing bruises worse
		M.adjustBruteLoss(4.5*REM, FALSE, FALSE, BODYPART_ORGANIC) // it's going to be healing either 4 or 0.5
		. = 1
	..()

/datum/reagent/medicine/salbutamol
	name = "Salbutamol"
	description = "Rapidly restores oxygen deprivation as well as preventing more of it to an extent."
	reagent_state = LIQUID
	color = "#00FFFF"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/medicine/salbutamol/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(-3*REM, 0)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	..()
	. = 1

/datum/reagent/medicine/perfluorodecalin
	name = "Perfluorodecalin"
	description = "Restores oxygen deprivation while producing a lesser amount of toxic byproducts. Both scale with exposure to the drug and current amount of oxygen deprivation. Overdose causes toxic byproducts regardless of oxygen deprivation."
	reagent_state = LIQUID
	color = "#FF6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35 // at least 2 full syringes +some, this stuff is nasty if left in for long

/datum/reagent/medicine/perfluorodecalin/on_mob_life(mob/living/carbon/human/M)
	var/oxycalc = 2.5*REM*current_cycle
	if(!overdosed)
		oxycalc = min(oxycalc,M.getOxyLoss()+PERF_BASE_DAMAGE) //if NOT overdosing, we lower our toxdamage to only the damage we actually healed with a minimum of 0.5. IE if we only heal 10 oxygen damage but we COULD have healed 20, we will only take toxdamage for the 10. We would take the toxdamage for the extra 10 if we were overdosing.
	M.adjustOxyLoss(-oxycalc, 0)
	M.adjustToxLoss(oxycalc/2.5, 0)
	if(prob(current_cycle) && M.losebreath)
		M.losebreath--
	..()
	return TRUE

/datum/reagent/medicine/perfluorodecalin/overdose_process(mob/living/M)
	metabolization_rate += 1
	return ..()

/datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	description = "Increases stun resistance and movement speed. Overdose deals toxin damage and inhibits breathing."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	addiction_threshold = 25

/datum/reagent/medicine/ephedrine/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.85, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/medicine/ephedrine/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	..()

/datum/reagent/medicine/ephedrine/on_mob_life(mob/living/carbon/M)
	if(prob(20) && iscarbon(M))
		var/obj/item/I = M.get_active_held_item()
		if(I && M.dropItemToGround(I))
			to_chat(M, "<span class ='notice'>Your hands spaz out and you drop what you were holding!</span>")
			M.Jitter(10)

	M.AdjustAllImmobility(-20, FALSE)
	M.adjustStaminaLoss(-1*REM, FALSE)
	..()
	return TRUE

/datum/reagent/medicine/ephedrine/overdose_process(mob/living/M)
	if(prob(2) && iscarbon(M))
		var/datum/disease/D = new /datum/disease/heart_failure
		M.ForceContractDisease(D)
		to_chat(M, span_userdanger("You're pretty sure you just felt your heart stop for a second there.."))
		M.playsound_local(M, 'sound/effects/singlebeat.ogg', 100, 0)

	if(prob(7))
		to_chat(M, span_notice("[pick("Your head pounds.", "You feel a tight pain in your chest.", "You find it hard to stay still.", "You feel your heart practically beating out of your chest.")]"))

	if(prob(33))
		M.adjustToxLoss(1*REM, 0)
		M.losebreath++
		. = 1
	return TRUE

/datum/reagent/medicine/ephedrine/addiction_act_stage1(mob/living/M)
	if(prob(3) && iscarbon(M))
		M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
		M.Unconscious(100)
		M.Jitter(350)

	if(prob(33))
		M.adjustToxLoss(2*REM, 0)
		M.losebreath += 2
		. = 1
	..()

/datum/reagent/medicine/ephedrine/addiction_act_stage2(mob/living/M)
	if(prob(6) && iscarbon(M))
		M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
		M.Unconscious(100)
		M.Jitter(350)

	if(prob(33))
		M.adjustToxLoss(3*REM, 0)
		M.losebreath += 3
		. = 1
	..()

/datum/reagent/medicine/ephedrine/addiction_act_stage3(mob/living/M)
	if(prob(12) && iscarbon(M))
		M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
		M.Unconscious(100)
		M.Jitter(350)

	if(prob(33))
		M.adjustToxLoss(4*REM, 0)
		M.losebreath += 4
		. = 1
	..()

/datum/reagent/medicine/ephedrine/addiction_act_stage4(mob/living/M)
	if(prob(24) && iscarbon(M))
		M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
		M.Unconscious(100)
		M.Jitter(350)

	if(prob(33))
		M.adjustToxLoss(5*REM, 0)
		M.losebreath += 5
		. = 1
	..()

/datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	description = "Rapidly purges the body of Histamine and reduces jitteriness. Slight chance of causing drowsiness. Overdosing will cause hallucinations."
	reagent_state = LIQUID
	color = "#64FFE6"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/diphenhydramine/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		M.drowsyness += 1
	M.jitteriness -= 1
	M.reagents.remove_reagent(/datum/reagent/toxin/histamine,3)
	..()

/datum/reagent/medicine/diphenhydramine/overdose_process(mob/living/M)
	M.set_drugginess(15)
	M.hallucination += 5*REM
	..()

/datum/reagent/medicine/morphine
	name = "Morphine"
	description = "A painkiller that allows the patient to move at full speed even in bulky objects. Causes drowsiness and eventually unconsciousness in high doses. Overdose will cause a variety of effects, ranging from minor to lethal."
	reagent_state = LIQUID
	color = "#A9FBFB"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	addiction_threshold = 25

/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/L)
	..()
	L.ignore_slowdown(type)
	ADD_TRAIT(L, TRAIT_SURGERY_PREPARED, type)
	SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "[type]_high", /datum/mood_event/high)

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/L)
	L.unignore_slowdown(type)
	REMOVE_TRAIT(L, TRAIT_SURGERY_PREPARED, type)
	..()

/datum/reagent/medicine/morphine/on_mob_life(mob/living/carbon/M)
	switch(current_cycle)
		if(11)
			to_chat(M, span_warning("You start to feel tired...") )
		if(12 to 24)
			M.drowsyness += 1
		if(24 to INFINITY)
			M.Sleeping(40, 0)
			. = 1
	..()

/datum/reagent/medicine/morphine/overdose_process(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.Dizzy(2)
		M.Jitter(2)
	..()

/datum/reagent/medicine/morphine/addiction_act_stage1(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.Jitter(2)
	..()

/datum/reagent/medicine/morphine/addiction_act_stage2(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(1*REM, 0)
		. = 1
		M.Dizzy(3)
		M.Jitter(3)
	..()

/datum/reagent/medicine/morphine/addiction_act_stage3(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(2*REM, 0)
		. = 1
		M.Dizzy(4)
		M.Jitter(4)
	..()

/datum/reagent/medicine/morphine/addiction_act_stage4(mob/living/M)
	if(prob(33))
		M.drop_all_held_items()
		M.adjustToxLoss(3*REM, 0)
		. = 1
		M.Dizzy(5)
		M.Jitter(5)
	..()

/datum/reagent/medicine/oculine
	name = "Oculine"
	description = "Quickly restores eye damage, cures nearsightedness, and has a chance to restore vision to the blind."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "dull toxin"

/datum/reagent/medicine/oculine/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return
	eyes.applyOrganDamage(-2)
	if(HAS_TRAIT_FROM(M, TRAIT_BLIND, EYE_DAMAGE))
		if(prob(20))
			to_chat(M, span_warning("Your vision slowly returns..."))
			M.cure_blind(EYE_DAMAGE)
			M.cure_nearsighted(EYE_DAMAGE)
			M.blur_eyes(35)

	else if(HAS_TRAIT_FROM(M, TRAIT_NEARSIGHT, EYE_DAMAGE))
		to_chat(M, span_warning("The blackness in your peripheral vision fades."))
		M.cure_nearsighted(EYE_DAMAGE)
		M.blur_eyes(10)
	else if(M.eye_blind || M.eye_blurry)
		M.set_blindness(0)
		M.set_blurriness(0)
	..()

/datum/reagent/medicine/atropine
	name = "Atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients."
	reagent_state = LIQUID
	color = "#000000"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35

/datum/reagent/medicine/atropine/on_mob_life(mob/living/carbon/M)
	if(M.health <= M.crit_threshold)
		M.adjustToxLoss(-2*REM, 0)
		M.adjustBruteLoss(-2*REM, 0)
		M.adjustFireLoss(-2*REM, 0)
		M.adjustOxyLoss(-5*REM, 0)
		. = 1
	M.losebreath = 0
	if(prob(20))
		M.Dizzy(5)
		M.Jitter(5)
	..()

/datum/reagent/medicine/atropine/overdose_process(mob/living/M)
	M.adjustToxLoss(0.5*REM, 0)
	. = 1
	M.Dizzy(1)
	M.Jitter(1)
	..()

/datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	description = "Minor boost to stun resistance. Slowly heals damage if a patient is in critical condition, as well as regulating oxygen loss. Overdose causes weakness and toxin damage."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/epinephrine/on_mob_metabolize(mob/living/carbon/M)
	..()
	ADD_TRAIT(M, TRAIT_NOCRITDAMAGE, type)

/datum/reagent/medicine/epinephrine/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, type)
	..()

/datum/reagent/medicine/epinephrine/on_mob_life(mob/living/carbon/M)
	if(M.health <= M.crit_threshold)
		M.adjustToxLoss(-0.5*REM, 0)
		M.adjustBruteLoss(-0.5*REM, 0)
		M.adjustFireLoss(-0.5*REM, 0)
		M.adjustOxyLoss(-0.5*REM, 0)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	if(M.losebreath < 0)
		M.losebreath = 0
	M.adjustStaminaLoss(-0.5*REM, 0)
	. = 1
	if(prob(20))
		M.AdjustAllImmobility(-20, FALSE)
	..()

/datum/reagent/medicine/epinephrine/overdose_process(mob/living/M)
	if(prob(33))
		M.adjustStaminaLoss(2.5*REM, 0)
		M.adjustToxLoss(1*REM, 0)
		M.losebreath++
		. = 1
	..()

/datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	description = "A miracle drug capable of bringing the dead back to life, at a heavy cost to their cellular makeup. Only functions when applied by patch or spray, if the target has less than 100 brute and burn damage and hasn't been husked. Causes slight damage to the living."
	reagent_state = LIQUID
	color = "#A0E85E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "magnets"

/datum/reagent/medicine/strange_reagent/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	var/datum/reagent/S = M.reagents?.get_reagent(/datum/reagent/medicine/strange_reagent)
	if((S?.volume + reac_volume) < REQUIRED_STRANGE_REAGENT_FOR_REVIVAL)
		M.visible_message(span_warning("[M]'s body shivers slightly, maybe the dose wasn't enough..."))
		return ..()
	if(M.stat == DEAD)
		if(M.suiciding || M.hellbound || ismegafauna(M)) //they are never coming back
			M.visible_message(span_warning("[M]'s body does not react..."))
			return
		if(iscarbon(M) && (M.getBruteLoss() + M.getFireLoss() >= 100 || HAS_TRAIT(M, TRAIT_HUSK))) //body is too damaged to be revived
			M.visible_message(span_warning("[M]'s body convulses a bit, and then falls still once more."))
			M.do_jitter_animation(10)
			return
		else
			M.visible_message(span_warning("[M]'s body starts convulsing!"))
			M.notify_ghost_cloning(source = M)
			M.do_jitter_animation(10)
			addtimer(CALLBACK(M, /mob/living/carbon.proc/do_jitter_animation, 10), 40) //jitter immediately, then again after 4 and 8 seconds
			addtimer(CALLBACK(M, /mob/living/carbon.proc/do_jitter_animation, 10), 80)
			sleep(10 SECONDS) //so the ghost has time to re-enter
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				for(var/organ in C.internal_organs)
					var/obj/item/organ/O = organ
					O.setOrganDamage(0)
			M.adjustBruteLoss(-100)
			M.adjustFireLoss(-100)
			M.adjustOxyLoss(-200, 0)
			M.adjustToxLoss(-200, 0, TRUE)
			M.updatehealth()
			if(M.revive())
				M.emote("gasp")
				log_combat(M, M, "revived", src)
	..()

/datum/reagent/medicine/strange_reagent/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(0.5*REM, 0)
	M.adjustFireLoss(0.5*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/mannitol
	name = "Mannitol"
	description = "Efficiently restores brain damage."
	color = "#DCDCFF"

/datum/reagent/medicine/mannitol/on_mob_life(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, (holder.has_reagent(/datum/reagent/drug/methamphetamine) ? 0 : -2)*REM)
	..()

/datum/reagent/medicine/neurine
	name = "Neurine"
	description = "Reacts with neural tissue, helping reform damaged connections. Can cure minor traumas."
	color = "#EEFF8F"

/datum/reagent/medicine/neurine/on_mob_life(mob/living/carbon/C)
	if(holder.has_reagent(/datum/reagent/consumable/ethanol/neurotoxin))
		holder.remove_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 5)
	if(prob(15))
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)
	..()

/datum/reagent/medicine/mutadone
	name = "Mutadone"
	description = "Removes jitteriness and restores genetic defects."
	color = "#5096C8"
	taste_description = "acid"

/datum/reagent/medicine/mutadone/on_mob_life(mob/living/carbon/M)
	M.jitteriness = 0
	if(M.has_dna())
		M.dna.remove_all_mutations(list(MUT_NORMAL, MUT_EXTRA), TRUE)
	if(!QDELETED(M)) //We were a monkey, now a human
		..()

/datum/reagent/medicine/antihol
	name = "Antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."
	color = "#00B4C8"
	taste_description = "raw egg"

/datum/reagent/medicine/antihol/on_mob_life(mob/living/carbon/M)
	M.dizziness = 0
	M.drowsyness = 0
	M.slurring = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3*REM, 0, 1)
	M.adjustToxLoss(-0.2*REM, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.drunkenness = max(H.drunkenness - 10, 0)
	..()
	. = 1

/datum/reagent/medicine/stimulants
	name = "Stimulants"
	description = "Increases stun resistance and movement speed in addition to restoring minor damage and weakness. Overdose causes weakness and toxin damage."
	color = "#78008C"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60

/datum/reagent/medicine/stimulants/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/medicine/stimulants/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	..()

/datum/reagent/medicine/stimulants/on_mob_life(mob/living/carbon/M)
	if(M.health < 50 && M.health > 0)
		M.adjustOxyLoss(-1*REM, 0)
		M.adjustToxLoss(-1*REM, 0)
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
	M.AdjustAllImmobility(-60, FALSE)
	M.adjustStaminaLoss(-30*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/stimulants/overdose_process(mob/living/M)
	if(prob(33))
		M.adjustStaminaLoss(2.5*REM, 0)
		M.adjustToxLoss(1*REM, 0)
		M.losebreath++
		. = 1
	..()

/datum/reagent/medicine/stimulants/nanite
	name = "Nano-Stimulants"
	description = "Nanite synthesized muscle stimulation mix that temporarily increases speed and stun resistance slightly. Overdose causes weakness and toxin damage."

/datum/reagent/medicine/stimulants/nanite/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.25, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/medicine/stimulants/nanite/on_mob_life(mob/living/carbon/M)
	if(M.health < 50 && M.health > 0)
		M.adjustOxyLoss(-1*REM, 0)
		M.adjustToxLoss(-1*REM, 0)
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
	M.AdjustAllImmobility(-20, FALSE)
	M.adjustStaminaLoss(-15*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/insulin
	name = "Insulin"
	description = "Increases sugar depletion rates."
	reagent_state = LIQUID
	color = "#FFFFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/insulin/on_mob_life(mob/living/carbon/M)
	if(M.AdjustSleeping(-20, FALSE))
		. = 1
	M.reagents.remove_reagent(/datum/reagent/consumable/sugar, 3)
	..()

//Trek Chems, used primarily by medibots. Only heals a specific damage type, but is very efficient.
/datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	description = "Restores bruising. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/medicine/bicaridine/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-2*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/bicaridine/overdose_process(mob/living/M)
	M.adjustBruteLoss(4*REM, FALSE, FALSE, BODYPART_ORGANIC)
	..()
	. = 1

/datum/reagent/medicine/dexalin
	name = "Dexalin"
	description = "Restores oxygen loss. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/medicine/dexalin/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(-2*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/dexalin/overdose_process(mob/living/M)
	M.adjustOxyLoss(4*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/kelotane
	name = "Kelotane"
	description = "Restores fire damage. Overdose causes it instead."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/medicine/kelotane/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-2*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/kelotane/overdose_process(mob/living/M)
	M.adjustFireLoss(4*REM, FALSE, FALSE, BODYPART_ORGANIC)
	..()
	. = 1

/datum/reagent/medicine/antitoxin
	name = "Anti-Toxin"
	description = "Heals toxin damage and removes toxins in the bloodstream. Overdose causes toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	taste_description = "a roll of gauze"

/datum/reagent/medicine/antitoxin/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(-2*REM, 0)
	for(var/datum/reagent/toxin/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type,1)
	..()
	. = 1

/datum/reagent/medicine/antitoxin/overdose_process(mob/living/M)
	M.adjustToxLoss(4*REM, 0) // End result is 2 toxin loss taken, because it heals 2 and then removes 4.
	..()
	. = 1

/datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	description = "Stabilizes the breathing of patients. Good for those in critical condition."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/medicine/inaprovaline/on_mob_life(mob/living/carbon/M)
	if(M.losebreath >= 5)
		M.losebreath -= 5
	..()

/datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	description = "Has a high chance to heal all types of damage. Overdose instead causes it."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose_threshold = 30
	taste_description = "grossness"

/datum/reagent/medicine/tricordrazine/on_mob_life(mob/living/carbon/M)
	if(prob(80))
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
		M.adjustOxyLoss(-1*REM, 0)
		M.adjustToxLoss(-1*REM, 0)
		. = 1
	..()

/datum/reagent/medicine/tricordrazine/overdose_process(mob/living/M)
	M.adjustToxLoss(2*REM, 0)
	M.adjustOxyLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, FALSE, FALSE, BODYPART_ORGANIC)
	M.adjustFireLoss(2*REM, FALSE, FALSE, BODYPART_ORGANIC)
	..()
	. = 1

/datum/reagent/medicine/regen_jelly
	name = "Regenerative Jelly"
	description = "Gradually regenerates all types of damage, without harming slime anatomy."
	reagent_state = LIQUID
	color = "#91D865"
	taste_description = "jelly"

/datum/reagent/medicine/regen_jelly/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-1.5*REM, 0)
	M.adjustFireLoss(-1.5*REM, 0)
	M.adjustOxyLoss(-1.5*REM, 0)
	M.adjustToxLoss(-1.5*REM, 0, TRUE) //heals TOXINLOVERs
	. = 1
	..()

/datum/reagent/medicine/tribaldetox
	name = "Cap Mix"
	description = "Heals toxin damage and removes toxins in the bloodstream via vomit. Can't overdose."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "poison"

/datum/reagent/medicine/tribaldetox/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(-2*REM, 0)
	if(prob(10))
		M.vomit(20)
		. = 1
	..()

/datum/reagent/medicine/grubjuice
	name = "Grub Juice"
	description = "A potent medicinal product that can have dangerous side effects if used too much."
	reagent_state = LIQUID
	color = "#43bf1d"
	taste_description = "bug intestines"
	overdose_threshold = 20
	can_synth = FALSE

/datum/reagent/medicine/grubjuice/on_mob_life(mob/living/carbon/M)
	M.heal_bodypart_damage(3,3)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, 1*REM)
	..()
	return TRUE

/datum/reagent/medicine/grubjuice/overdose_process(mob/living/M)
	M.adjustBruteLoss(2*REM, 0, FALSE, BODYPART_ORGANIC)
	M.adjustFireLoss(2*REM, 0, FALSE, BODYPART_ORGANIC)
	M.adjustToxLoss(5*REM, 0)
	..()
	return TRUE

/datum/reagent/medicine/syndicate_nanites //Used exclusively by Syndicate medical cyborgs
	name = "Restorative Nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	reagent_state = SOLID
	color = "#555555"
	overdose_threshold = 30

/datum/reagent/medicine/syndicate_nanites/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-5*REM, 0) //A ton of healing - this is a 50 telecrystal investment.
	M.adjustFireLoss(-5*REM, 0)
	M.adjustOxyLoss(-15, 0)
	M.adjustToxLoss(-5*REM, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -15*REM)
	M.adjustCloneLoss(-3*REM, 0)
	..()
	. = 1

/datum/reagent/medicine/syndicate_nanites/overdose_process(mob/living/carbon/M) //wtb flavortext messages that hint that you're vomitting up robots
	if(prob(25))
		M.reagents.remove_reagent(type, metabolization_rate*15) // ~5 units at a rate of 0.4 but i wanted a nice number in code
		M.vomit(20) // nanite safety protocols make your body expel them to prevent harmies
	..()
	. = 1

/datum/reagent/medicine/earthsblood //Created by ambrosia gaia plants
	name = "Earthsblood"
	description = "Ichor from an extremely powerful plant. Great for restoring wounds, but it's a little heavy on the brain."
	color = rgb(255, 175, 0)
	overdose_threshold = 25

/datum/reagent/medicine/earthsblood/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-3 * REM, 0)
	M.adjustFireLoss(-3 * REM, 0)
	M.adjustOxyLoss(-15 * REM, 0)
	M.adjustToxLoss(-3 * REM, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * REM, 150) //This does, after all, come from ambrosia, and the most powerful ambrosia in existence, at that!
	M.adjustCloneLoss(-1 * REM, 0)
	M.adjustStaminaLoss(-30 * REM, 0)
	M.jitteriness = min(max(0, M.jitteriness + 3), 30)
	M.druggy = min(max(0, M.druggy + 10), 15) //See above
	..()
	. = 1

/datum/reagent/medicine/earthsblood/overdose_process(mob/living/M)
	M.hallucination = min(max(0, M.hallucination + 5), 60)
	M.adjustToxLoss(5 * REM, 0)
	..()
	. = 1

/datum/reagent/medicine/haloperidol
	name = "Haloperidol"
	description = "Increases depletion rates for most stimulating/hallucinogenic drugs. Reduces druggy effects and jitteriness. Severe stamina regeneration penalty, causes drowsiness. Small chance of brain damage."
	reagent_state = LIQUID
	color = "#27870a"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/medicine/haloperidol/on_mob_life(mob/living/carbon/M)
	for(var/datum/reagent/drug/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type,5)
	M.drowsyness += 2
	if(M.jitteriness >= 3)
		M.jitteriness -= 3
	if (M.hallucination >= 5)
		M.hallucination -= 5
	if(prob(20))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1*REM, 50)
	M.adjustStaminaLoss(2.5*REM, 0)
	..()
	return TRUE

/datum/reagent/medicine/lavaland_extract
	name = "Lavaland Extract"
	description = "An extract of lavaland atmospheric and mineral elements. Heals the user in small doses, but is extremely toxic otherwise."
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose_threshold = 3 //To prevent people stacking massive amounts of a very strong healing reagent
	can_synth = FALSE

/datum/reagent/medicine/lavaland_extract/on_mob_life(mob/living/carbon/M)
	M.heal_bodypart_damage(5,5)
	..()
	return TRUE

/datum/reagent/medicine/lavaland_extract/overdose_process(mob/living/M)
	M.adjustBruteLoss(3*REM, 0, FALSE, BODYPART_ORGANIC)
	M.adjustFireLoss(3*REM, 0, FALSE, BODYPART_ORGANIC)
	M.adjustToxLoss(3*REM, 0)
	..()
	return TRUE

//used for changeling's adrenaline power
/datum/reagent/medicine/changelingadrenaline
	name = "Changeling Adrenaline"
	description = "Reduces the duration of unconsciousness, knockdown and stuns. Restores stamina, but deals toxin damage when overdosed."
	color = "#C8A5DC"
	overdose_threshold = 30

/datum/reagent/medicine/changelingadrenaline/on_mob_life(mob/living/carbon/M as mob)
	M.AdjustAllImmobility(-20, FALSE)
	M.adjustStaminaLoss(-15, 0)
	..()
	return TRUE

/datum/reagent/medicine/changelingadrenaline/overdose_process(mob/living/M as mob)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE

/datum/reagent/medicine/changelinghaste
	name = "Changeling Haste"
	description = "Drastically increases movement speed, but deals toxin damage."
	color = "#C8A5DC"
	metabolization_rate = 1

/datum/reagent/medicine/changelinghaste/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/medicine/changelinghaste/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	..()

/datum/reagent/medicine/changelinghaste/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(2, 0)
	..()
	return TRUE

/datum/reagent/medicine/corazone
	// Heart attack code will not do damage if corazone is present
	// because it's SPACE MAGIC ASPIRIN
	name = "Corazone"
	description = "A medication used to treat pain, fever, and inflammation, along with heart attacks. Causes rapid organ failure when overdosed."
	color = "#F5F5F5"
	self_consuming = TRUE
	overdose_threshold = 30

/datum/reagent/medicine/corazone/on_mob_metabolize(mob/living/M)
	..()
	ADD_TRAIT(M, TRAIT_STABLEHEART, type)
	ADD_TRAIT(M, TRAIT_STABLELIVER, type)

/datum/reagent/medicine/corazone/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_STABLEHEART, type)
	REMOVE_TRAIT(M, TRAIT_STABLELIVER, type)
	..()

/datum/reagent/medicine/corazone/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 1.5 * REM)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, 1 * REM)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.8 * REM)
	..()

/datum/reagent/medicine/muscle_stimulant
	name = "Muscle Stimulant"
	description = "A potent chemical that allows someone under its influence to be at full physical ability even when under massive amounts of pain."

/datum/reagent/medicine/muscle_stimulant/on_mob_metabolize(mob/living/M)
	. = ..()
	M.ignore_slowdown(type)

/datum/reagent/medicine/muscle_stimulant/on_mob_end_metabolize(mob/living/M)
	. = ..()
	M.unignore_slowdown(type)

/datum/reagent/medicine/modafinil
	name = "Modafinil"
	description = "Long-lasting sleep suppressant that very slightly reduces stun and knockdown times. Overdosing has horrendous side effects and deals lethal oxygen damage, will knock you unconscious if not dealt with."
	reagent_state = LIQUID
	color = "#BEF7D8" // palish blue white
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	overdose_threshold = 20 // with the random effects this might be awesome or might kill you at less than 10u (extensively tested)
	taste_description = "salt" // it actually does taste salty
	var/overdose_progress = 0 // to track overdose progress

/datum/reagent/medicine/modafinil/on_mob_metabolize(mob/living/M)
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/medicine/modafinil/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/medicine/modafinil/on_mob_life(mob/living/carbon/M)
	if(!overdosed) // We do not want any effects on OD
		overdose_threshold = overdose_threshold + rand(-10,10)/10 // for extra fun
		M.AdjustAllImmobility(-5, FALSE)
		M.adjustStaminaLoss(-0.5*REM, 0)
		M.Jitter(1)
		metabolization_rate = 0.01 * REAGENTS_METABOLISM * rand(5,20) // randomizes metabolism between 0.02 and 0.08 per tick
		. = TRUE
	..()

/datum/reagent/medicine/modafinil/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("You feel awfully out of breath and jittery!"))
	metabolization_rate = 0.025 * REAGENTS_METABOLISM // sets metabolism to 0.01 per tick on overdose

/datum/reagent/medicine/modafinil/overdose_process(mob/living/M)
	overdose_progress++
	switch(overdose_progress)
		if(1 to 40)
			M.jitteriness = min(M.jitteriness+1, 10)
			M.stuttering = min(M.stuttering+1, 10)
			M.Dizzy(5)
			if(prob(50))
				M.losebreath++
		if(41 to 80)
			M.adjustOxyLoss(0.1*REM, 0)
			M.adjustStaminaLoss(0.1*REM, 0)
			M.jitteriness = min(M.jitteriness+1, 20)
			M.stuttering = min(M.stuttering+1, 20)
			M.Dizzy(10)
			if(prob(50))
				M.losebreath++
			if(prob(20))
				to_chat(M, "You have a sudden fit!")
				M.emote("moan")
				M.Paralyze(20, 1, 0) // you should be in a bad spot at this point unless epipen has been used
		if(81)
			to_chat(M, "You feel too exhausted to continue!") // at this point you will eventually die unless you get charcoal
			M.adjustOxyLoss(0.1*REM, 0)
			M.adjustStaminaLoss(0.1*REM, 0)
		if(82 to INFINITY)
			M.Sleeping(100, 0, TRUE)
			M.adjustOxyLoss(1.5*REM, 0)
			M.adjustStaminaLoss(1.5*REM, 0)
	..()
	return TRUE

/datum/reagent/medicine/psicodine
	name = "Psicodine"
	description = "Suppresses anxiety and other various forms of mental distress. Overdose causes hallucinations and minor toxin damage."
	reagent_state = LIQUID
	color = "#07E79E"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/psicodine/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FEARLESS, type)

/datum/reagent/medicine/psicodine/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FEARLESS, type)
	..()

/datum/reagent/medicine/psicodine/on_mob_life(mob/living/carbon/M)
	M.jitteriness = max(0, M.jitteriness-6)
	M.dizziness = max(0, M.dizziness-6)
	M.confused = max(0, M.confused-6)
	M.disgust = max(0, M.disgust-6)
	var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
	if(mood && mood.sanity <= SANITY_NEUTRAL) // only take effect if in negative sanity and then...
		mood.setSanity(min(mood.sanity+5, SANITY_NEUTRAL)) // set minimum to prevent unwanted spiking over neutral
	..()
	. = 1

/datum/reagent/medicine/psicodine/overdose_process(mob/living/M)
	M.hallucination = min(max(0, M.hallucination + 5), 60)
	M.adjustToxLoss(1, 0)
	..()
	. = 1

/datum/reagent/medicine/metafactor
	name = "Mitogen Metabolism Factor"
	description = "This enzyme catalyzes the conversion of nutricious food into healing peptides."
	metabolization_rate = 0.0625  * REAGENTS_METABOLISM //slow metabolism rate so the patient can self heal with food even after the troph has metabolized away for amazing reagent efficency.
	reagent_state = SOLID
	color = "#FFBE00"
	overdose_threshold = 10

/datum/reagent/medicine/metafactor/overdose_start(mob/living/carbon/M)
	metabolization_rate = 2  * REAGENTS_METABOLISM

/datum/reagent/medicine/metafactor/overdose_process(mob/living/carbon/M)
	if(prob(13))
		M.vomit()
	..()

/datum/reagent/medicine/silibinin
	name = "Silibinin"
	description = "A thistle derrived hepatoprotective flavolignan mixture that help reverse damage to the liver."
	reagent_state = SOLID
	color = "#FFFFD0"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/medicine/silibinin/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, -2 * REM)//Add a chance to cure liver trauma once implemented.
	..()
	. = TRUE

/datum/reagent/medicine/polypyr  //This is intended to be an ingredient in advanced chems.
	name = "Polypyrylium Oligomers"
	description = "A purple mixture of short polyelectrolyte chains not easily synthesized in the laboratory. It is valued as an intermediate in the synthesis of the cutting edge pharmaceuticals."
	reagent_state = SOLID
	color = "#9423FF"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 50
	taste_description = "numbing bitterness"

/datum/reagent/medicine/polypyr/on_mob_life(mob/living/carbon/M) //I wanted a collection of small positive effects, this is as hard to obtain as coniine after all.
	. = ..()
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, -0.25 * REM)
	M.adjustBruteLoss(-0.35 * REM, 0)
	return TRUE

/datum/reagent/medicine/polypyr/reaction_mob(mob/living/carbon/human/exposed_human, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_human) || (reac_volume < 0.5))
		return
	exposed_human.hair_color = "92f"
	exposed_human.facial_hair_color = "92f"
	exposed_human.update_hair()

/datum/reagent/medicine/polypyr/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.5 * REM)
	..()
	. = TRUE

// helps bleeding wounds clot faster
/datum/reagent/medicine/coagulant
	name = "Sanguirite"
	description = "A proprietary coagulant used to help bleeding wounds clot faster, as well as slow organ decay."
	reagent_state = LIQUID
	color = "#bb2424"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 20
	/// The bloodiest wound that the patient has will have its blood_flow reduced by this much each tick
	var/clot_rate = 0.3
	/// While this reagent is in our bloodstream, we reduce all bleeding by this factor
	var/passive_bleed_modifier = 0.7
	/// For tracking when we tell the person we're no longer bleeding
	var/was_working

/datum/reagent/medicine/coagulant/on_mob_add(mob/living/M)
	ADD_TRAIT(M, TRAIT_COAGULATING, type)
	ADD_TRAIT(M, TRAIT_PRESERVED_ORGANS, type)
	return ..()

/datum/reagent/medicine/coagulant/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_COAGULATING, type)
	REMOVE_TRAIT(M, TRAIT_PRESERVED_ORGANS, type)
	return ..()

/datum/reagent/medicine/coagulant/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!M.blood_volume || !M.all_wounds)
		return

	var/datum/wound/bloodiest_wound

	for(var/i in M.all_wounds)
		var/datum/wound/iter_wound = i
		if(iter_wound.blood_flow)
			if(iter_wound.blood_flow > bloodiest_wound?.blood_flow)
				bloodiest_wound = iter_wound

	if(bloodiest_wound)
		if(!was_working)
			to_chat(M, span_green("You can feel your flowing blood start thickening!"))
			was_working = TRUE
		bloodiest_wound.blood_flow = max(0, bloodiest_wound.blood_flow - clot_rate)
	else if(was_working)
		was_working = FALSE

/datum/reagent/medicine/coagulant/overdose_process(mob/living/M)
	. = ..()
	if(!M.blood_volume)
		return

	if(prob(15))
		M.losebreath += rand(2,4)
		M.adjustOxyLoss(rand(1,3))
		if(prob(30))
			to_chat(M, span_danger("You can feel your blood clotting up in your veins!"))
		else if(prob(10))
			to_chat(M, span_userdanger("You feel like your blood has stopped moving!"))

		if(prob(50))
			var/obj/item/organ/lungs/our_lungs = M.getorganslot(ORGAN_SLOT_LUNGS)
			our_lungs.applyOrganDamage(1)
		else
			var/obj/item/organ/heart/our_heart = M.getorganslot(ORGAN_SLOT_HEART)
			our_heart.applyOrganDamage(1)

/datum/reagent/medicine/coagulant/on_mob_metabolize(mob/living/M)
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/blood_boy = M
	blood_boy.physiology?.bleed_mod *= passive_bleed_modifier

/datum/reagent/medicine/coagulant/on_mob_end_metabolize(mob/living/M)
	if(was_working)
		to_chat(M, span_warning("The medicine thickening your blood loses its effect!"))
	if(!ishuman(M))
		return

	var/mob/living/carbon/human/blood_boy = M
	blood_boy.physiology?.bleed_mod /= passive_bleed_modifier

// i googled "natural coagulant" and a couple of results came up for banana peels, so after precisely 30 more seconds of research, i now dub grinding banana peels good for your blood
/datum/reagent/medicine/coagulant/banana_peel
	name = "Pulped Banana Peel"
	description = "Ancient Clown Lore says that pulped banana peels are good for your blood, but are you really going to take medical advice from a clown about bananas?"
	color = "#50531a" // rgb: 175, 175, 0
	taste_description = "horribly stringy, bitter pulp"
	glass_name = "glass of banana peel pulp"
	glass_desc = "Ancient Clown Lore says that pulped banana peels are good for your blood, but are you really going to take medical advice from a clown about bananas?"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	clot_rate = 0.2
	passive_bleed_modifier = 0.8

/datum/reagent/medicine/burnmix
	name = "BurnMix"
	description = "Take in moderation. Initially heals damage at a snail's pace until overdosed. Effects increase when used with Epinephrine or Perfluorodecalin. You don't want this in your body for longer than needed."
	reagent_state = LIQUID
	color = "#BD328A" //  R 189 G 50 B 138 , Medium Red Violet , Hue of Violet
	overdose_threshold = 15
	taste_description = "a chunky mess"
	glass_name = "glass of ...red?"
	glass_desc = "Looks like some chunky dark red mix."
	reagent_weight = 4
	addiction_threshold = 40
	var/clean_types = CLEAN_WASH // Burnmix can be used to clean turfs but cannot clean mobs and objects like space cleaner.
	// Max healing non OD with best rolls + buffs: 0.2 + 0.15 + 0.2 = 0.55
	// Max healing with OD + best rolls and all buffs: 0.4 + 0.35 + 0.4 = 1.15

/datum/reagent/medicine/burnmix/on_mob_life(mob/living/carbon/M)
	var/heal_roll = pick(-0.1,-0.2) // Base heal, Non OD
	var/slur = 10 // Slur 10 sets up for future slur gains as real effects seem to start at 30
	var/jitter = 0
	start_effect(M, heal_roll, slur, jitter)
	epinephrine_effect(M, heal_roll, slur, jitter)
	perfluorodecalin_effect(M, heal_roll, slur, jitter)
	base_effect(M, heal_roll, slur, jitter)
	..()
	. = 1

/datum/reagent/medicine/burnmix/overdose_process(mob/living/M)
	var/heal_roll = pick(-0.2,-0.4)
	var/slur = 20
	var/jitter = 2
	start_effect(M, heal_roll, slur, jitter)
	perfluorodecalin_effect(M, heal_roll, slur, jitter)
	epinephrine_effect(M, heal_roll, slur, jitter)
	combined_effect(M, heal_roll, slur, jitter) // OD allows for the combined effect
	base_effect(M, heal_roll, slur, jitter)
	..()
	. = 1

/datum/reagent/drug/burnmix/overdose_start(mob/living/M, heal_roll , slur , jitter)
	to_chat(M, span_userdanger("You feel the BurnMix increase in potency."))
	..()
	. = 1

/datum/reagent/medicine/burnmix/proc/start_effect(mob/living/carbon/M, heal_roll, slur, jitter)
	if(!overdosed)
		if(M.health <= M.crit_threshold)
			heal_roll = 0 // Burnmix will not heal anyone inside of crit without epipen or morhpine
		if(prob(10))
			heal_roll = 0 // Burnmix has a chance not to basic heal at all
	else if(overdosed)
		if(M.health <= M.crit_threshold)
			heal_roll -= 0.2 // Burnmix in overdose will heal inside of crit without epipen or perfluorodecalin. Being in crit means a roll for either no base healing or half reduction to base heal.
		if(prob(10))
			heal_roll = 0 // Burnmix has a chance not to basic heal at all
	return

/datum/reagent/medicine/burnmix/proc/base_effect(mob/living/carbon/M, heal_roll, slur, jitter)
	if(!overdosed)
		if(prob(10)) // Start of base probability effects
			var/tox_roll = pick(1,-1) // Rolls for damage or healing
			if(tox_roll == 1)
				M.emote("moan")
			if(tox_roll == -1)
				M.emote("twitch")
			if(prob(90))
				M.adjustToxLoss(tox_roll*REM, 0)
			M.Jitter(jitter)
		if(prob(1)) // Last set of non OD probability effects
			M.Dizzy(jitter)
			M.apply_effect(slur, EFFECT_SLUR) // End of base probability effects
		if(heal_roll < 0) // Healing payload after calculations
			M.adjustFireLoss(heal_roll*REM, 0)
			M.adjustBruteLoss(heal_roll*REM, 0)

	else if(overdosed)
		if(prob(40)) // start last set of OD probability effects
			M.emote(pick("twitch","drool","moan","giggle","spin"))
		if(prob(60))
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, pick(0,1,2,2.5,-1,-2))
		if(prob(15))
			M.set_drugginess(rand(2,6))
		M.Jitter(jitter)
		if(prob(40))
			M.adjustToxLoss(pick(1,-1)*REM, 0)
		if(prob(1))
			M.Dizzy(jitter) // end last set of OD probability effects
		M.Jitter(jitter) // OD slur and jitter after calculations
		M.apply_effect(slur, EFFECT_SLUR)
		if(heal_roll < 0) // OD Healing payload after calculations
			M.adjustFireLoss(heal_roll*REM, FALSE, FALSE, BODYPART_ORGANIC)
			M.adjustBruteLoss(heal_roll*REM, 0)
	return

/datum/reagent/medicine/burnmix/proc/perfluorodecalin_effect(mob/living/carbon/M, heal_roll, slur, jitter)
	if(holder.has_reagent(/datum/reagent/medicine/perfluorodecalin))
		if(!overdosed)
			jitter += 5
			slur += 25
			M.drowsyness += 0.5
			heal_roll -= 0.2
		else if(overdosed)
			heal_roll -= 0.4
			jitter += 15
			slur += 25
			if(prob(25))
				M.adjustToxLoss(0.5*REM, 0)
				M.adjustToxLoss(pick(0,-0.25), 0) // gives a chance to negate half perfluorodecalin tox damage
	return

/datum/reagent/medicine/burnmix/proc/epinephrine_effect(mob/living/carbon/M, heal_roll, slur, jitter)
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		if(!overdosed)
			jitter += 5
			slur += 25
			heal_roll -= 0.15
			if(prob(15))
				M.losebreath++
				if(prob(80))
					M.adjustStaminaLoss(1.25*REM, 0) // end IF has Epinephrine in body
		else if(overdosed)
			heal_roll -= 0.35
			jitter += 15
			slur += 25
			if(prob(25))
				M.losebreath++
				M.adjustStaminaLoss(2.5*REM, 0)
				if(prob(80))
					M.adjustToxLoss(pick(0.5,0.25,0,0,-0.25)*REM, 0)
	return

/datum/reagent/medicine/burnmix/proc/combined_effect(mob/living/carbon/M, heal_roll, slur, jitter)
	if(holder.has_reagent(holder.has_reagent(/datum/reagent/medicine/epinephrine) && /datum/reagent/medicine/perfluorodecalin))
		if(overdosed)
			if(prob(0.5)) // Should be 1 in 200 chance of a 1 in 3 chance to roll for faint if both epinephrine and perfluorodecalin are present
				M.emote((pick("scream","faint","gasp")))
			if(prob(60)) // Original edit did too much brain damage. Moved to both drug effects. Was default OD effect
				M.adjustOrganLoss(ORGAN_SLOT_BRAIN,pick(1,-1))
			if(prob(30))
				slur += 25
			if(prob(30))
				jitter = 50
			if(prob(30))
				M.drowsyness += 0.5
				if(prob(2))
					to_chat(M, "<span class ='notice'>Your fingers spasm!</span>")
					M.drop_all_held_items() // end IF both drugs present
	return

/datum/reagent/medicine/burnmix/reaction_mob(mob/living/M, method=TOUCH, reac_volume,show_message = 1)
	if(iscarbon(M))
		if (M.stat == DEAD) // If the mob is dead and you apply it via touch. You get to play an RNG healing game.
			if(method in list(PATCH, TOUCH))
				var/RNG_ROLL = pick(-0.5,-0.25,-0.1,0,0.2)
				var/RNG_TEXT = "no effect"
				if(RNG_ROLL == -0.5)
					RNG_TEXT = "had a great effect"
				if(RNG_ROLL == -0.25)
					RNG_TEXT = "had a good effect"
				if(RNG_ROLL == -0.1)
					RNG_TEXT = "had a somewhat good effect"
				if(RNG_ROLL == 0.2)
					RNG_TEXT = "made things worse!"
				if(RNG_ROLL != 0)
					SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "painful_medicine", /datum/mood_event/painful_medicine)
					M.adjustBruteLoss(RNG_ROLL*reac_volume)
					M.adjustFireLoss(RNG_ROLL*reac_volume)
				M.visible_message(span_warning("[M]'s body reacts with the medicine. It seemed to have [RNG_TEXT]!"))
	..()

/datum/reagent/medicine/burnmix/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 1)
		T.wash(clean_types)
		for(var/am in T)
			var/atom/movable/movable_content = am
			if(ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash
				continue
			movable_content.wash(clean_types)

/datum/reagent/medicine/radscrub
	name = "Rad Scrub Plus"
	description = "Are your chairs, tables, bottles and assitants glowing green? Spray em down Donk Co's new patented cleaner, Rad Scrub Plus! WARNING: SWALLOWING OR INGESTING RAD SCRUB PLUS MAY RESULT NAUSUA, POISONING, OR MESOTHELIOMA"
	color = "#9f5a2f"
	var/old_insulation = RAD_NO_INSULATION
	taste_description = "metallic dust"
	self_consuming = TRUE

/datum/reagent/medicine/radscrub/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.wash(CLEAN_RAD) //you only get decontaminated if it's spray based, can't spam out 100 1u pills

/datum/reagent/medicine/radscrub/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1*REM, 0)
	..()

/datum/reagent/medicine/radscrub/on_mob_add(mob/living/L)
	..()
	//store the person's original insulation so they're only extra protected while it's in their system
	old_insulation = L.rad_insulation
	L.rad_insulation = RAD_LIGHT_INSULATION

/datum/reagent/medicine/radscrub/on_mob_end_metabolize(mob/living/L)
	L.rad_insulation = old_insulation
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.vomit(stun = FALSE) //it binds with the radioactive particles inside you, and they have to come out somehow
	..()

/datum/reagent/medicine/radscrub/reaction_obj(obj/O, reac_volume)
	//scrubs the contamination and applies a light treatment to it to mitigate immediate recontamination
	var/datum/component/radioactive/radiation = O.GetComponent(/datum/component/radioactive)
	if(radiation)
		radiation.strength -= max(0, reac_volume * (RAD_BACKGROUND_RADIATION * 5))
	O.wash(CLEAN_RAD | CLEAN_TYPE_WEAK)
	if(O.rad_insulation < RAD_LIGHT_INSULATION)
		O.rad_insulation = RAD_LIGHT_INSULATION

#undef PERF_BASE_DAMAGE
#undef REQUIRED_STRANGE_REAGENT_FOR_REVIVAL

/datum/reagent/medicine/coagulant/seraka_extract
	name = "Seraka Extract"
	description = "A deeply coloured oil present in small amounts in seraka mushrooms. Acts as an effective blood clotting agent, but has a low overdose threshold."
	color = "#00767C"
	taste_description = "intensely savoury bitterness"
	glass_name = "glass of seraka extract"
	glass_desc = "Deeply savoury and bitter. Slows your blood flow. Dangerous in moderate quantities."
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	clot_rate = 0.4 //slightly better than regular coagulant
	passive_bleed_modifier = 0.5
	overdose_threshold = 10 //but easier to overdose on

/datum/reagent/medicine/resurrector_nanites
	name = "Resurrector Nanite Serum"
	description = "A serum of nanites capable of restoring corpses to living people in a timely manner."
	taste_description = "a bunch of tiny robots"

/datum/reagent/medicine/resurrector_nanites/reaction_mob(mob/living/carbon/M)
	..()
	if(M.stat != DEAD)
		return
	M.revive(full_heal = TRUE)
	M.Jitter(10 SECONDS)
	M.emote("gasp")

/datum/reagent/medicine/naniteremover
	name = "Nanolytic Agent"
	description = "Creates an environment that in unsuitable for nanites, causing them to rapidly break down."
	reagent_state = LIQUID
	color = "#ff00d4"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "acidic oil"
	process_flags = ORGANIC | SYNTHETIC
	var/nanite_reduction = -50

/datum/reagent/medicine/naniteremover/on_mob_life(mob/living/carbon/M)
	if(SEND_SIGNAL(M, COMSIG_HAS_NANITES))
		SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, nanite_reduction)
	return ..()
	