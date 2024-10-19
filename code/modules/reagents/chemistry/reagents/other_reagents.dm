/datum/reagent/blood
	name = "Blood"
	color = COLOR_BLOOD
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	shot_glass_icon_state = "shotglassred"

	data = list(
		"donor" = null,
		"viruses" = null,
		"blood_DNA" = null,
		"blood_type" = null,
		"resistances" = null,
		"trace_chem" = null,
		"mind" = null,
		"ckey" = null,
		"gender" = null,
		"real_name" = null,
		"cloneable" = null,
		"factions" = null,
		"quirks" = null
		)

/datum/reagent/blood/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(L) //bloodsucker start
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_blood_volume = min(bloodsuckerdatum.bloodsucker_blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM(L))
		return //bloodsucker end

	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing

			if((D.spread_flags & DISEASE_SPREAD_SPECIAL) || (D.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
				continue

			if((methods & (TOUCH|VAPOR)) && permeability)
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
					L.ContactContractDisease(D)
			else //ingest, patch or inject
				L.ForceContractDisease(D)

	if(iscarbon(L))
		var/mob/living/carbon/exposed_carbon = L
		if(exposed_carbon.get_blood_id() == /datum/reagent/blood && (methods == INJECT || (methods == INGEST && exposed_carbon.dna && exposed_carbon.dna.species && (DRINKSBLOOD in exposed_carbon.dna.species.species_traits))))
			if(data && data["blood_type"])
				var/datum/blood_type/blood_type = data["blood_type"]
				if(blood_type.type in exposed_carbon.dna.blood_type.compatible_types)
					exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM(L))
					return
			exposed_carbon.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)


/datum/reagent/blood/on_new(list/data)
	if(istype(data))
		SetViruses(src, data)
		var/datum/blood_type/blood_type = data["blood_type"]
		if(blood_type)
			color = blood_type.color

/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
		if(data["viruses"] || mix_data["viruses"])

			var/list/mix1 = data["viruses"]
			var/list/mix2 = mix_data["viruses"]

			// Stop issues with the list changing during mixing.
			var/list/to_mix = list()

			for(var/datum/disease/advance/AD in mix1)
				to_mix += AD
			for(var/datum/disease/advance/AD in mix2)
				to_mix += AD

			var/datum/disease/advance/AD = Advance_Mix(to_mix)
			if(AD)
				var/list/preserve = list(AD)
				for(var/D in data["viruses"])
					if(!istype(D, /datum/disease/advance))
						preserve += D
				data["viruses"] = preserve
	return 1

/datum/reagent/blood/proc/get_diseases()
	. = list()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing
			. += D

/datum/reagent/blood/reaction_turf(turf/T, reac_volume)//splash the blood all over the place
	if(!istype(T))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/B = locate() in T //find some blood here
	if(!B)
		B = new(T)
	if(data["blood_DNA"])
		B.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/datum/reagent/liquidgibs
	name = "Liquid gibs"
	color = "#FF9966"
	description = "You don't even want to think about what's in here."
	taste_description = "gross iron"
	shot_glass_icon_state = "shotglassred"

/datum/reagent/polysmorphblood
	name = "Polysmorph blood"
	color = "#96BB00"
	description = "The blood of a polysmorph"
	taste_description = "acidic"

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	color = "#C81040" // rgb: 200, 16, 64
	taste_description = "slime"

/datum/reagent/vaccine/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(islist(data) && (((methods & INGEST) && reac_volume >= 5) || (methods & INJECT)))//drinking it requires at least 5u, injection doesn't
		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.GetDiseaseID() in data)
				D.cure()
		L.disease_resistances |= data

/datum/reagent/vaccine/on_merge(list/data)
	if(istype(data))
		src.data |= data.Copy()

/datum/reagent/water
	name = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#00B8FF" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "water"
	evaporation_rate = 4 // water goes fast
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."
	shot_glass_icon_state = "shotglassclear"
	compatible_biotypes = ALL_BIOTYPES
	default_container = /obj/item/reagent_containers/glass/beaker/waterbottle/large

/*
 *	Water reaction to turf
 */

/datum/reagent/water/reaction_turf(turf/open/T, reac_volume)
	if(!istype(T))
		return

	if(reac_volume >= 5)
		T.MakeSlippery(TURF_WET_WATER, 120 SECONDS, min(reac_volume * 3 SECONDS, 300 SECONDS)) //yogs

	for(var/mob/living/simple_animal/slime/M in T)
		M.apply_water()

	T.extinguish_turf()

	var/obj/effect/acid/A = (locate(/obj/effect/acid) in T)
	if(A)
		A.acid_level = max(A.acid_level - reac_volume*50, 0)

/*
 *	Water reaction to an object
 */

/datum/reagent/water/reaction_obj(obj/O, reac_volume)
	O.extinguish()
	O.acid_level = 0
	// Monkey cube
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = O
		cube.Expand()

	// Dehydrated carp
	else if(istype(O, /obj/item/toy/plush/carpplushie/dehy_carp))
		var/obj/item/toy/plush/carpplushie/dehy_carp/dehy = O
		dehy.Swell() // Makes a carp

	else if(istype(O, /obj/item/stack/sheet/hairlesshide))
		var/obj/item/stack/sheet/hairlesshide/HH = O
		new /obj/item/stack/sheet/wetleather(get_turf(HH), HH.amount)
		qdel(HH)

/*
 *	Water reaction to a mob
 */

/datum/reagent/water/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)//Splashing people with water can help put them out!
	if(!istype(M))
		return
	if(methods & TOUCH)
		// some nice cold water to WAKE THE FUCK UP
		// 20 units of water = 1 hug of antisleep
		M.AdjustUnconscious(-reac_volume*0.3 SECONDS)
		M.AdjustSleeping(-reac_volume*0.5 SECONDS)

		// this function allows lower volumes to still do something without preventing higher volumes from causing too much wetness
		M.adjust_wet_stacks(3*log(2, (reac_volume*M.get_permeability(null, TRUE) + 10) / 10))
		M.extinguish_mob() // permeability affects the negative fire stacks but not the extinguishing

		// if preternis, update wetness instantly when applying more water instead of waiting for the next life tick
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/datum/species/preternis/P = H.dna?.species
			if(istype(P))
				P.handle_wetness(H)
	..()

/datum/reagent/water/on_mob_life(mob/living/carbon/M)
	. = ..()
	var/body_temperature_difference = BODYTEMP_NORMAL - M.bodytemperature
	M.adjust_bodytemperature(min(3,body_temperature_difference))
	if(M.blood_volume)
		M.blood_volume += 0.1 // water is good for you!

/datum/reagent/water/holywater
	name = "Holy Water"
	description = "Water blessed by some deity."
	color = "#E0E8EF" // rgb: 224, 232, 239
	glass_icon_state  = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "A glass of holy water."
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver

/datum/reagent/water/holywater/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_HOLY, type)

/datum/reagent/water/holywater/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HOLY, type)
	..()

/datum/reagent/water/holywater/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(is_servant_of_ratvar(M))
		to_chat(M, span_userdanger("A darkness begins to spread its unholy tendrils through your mind, purging the Justiciar's influence!"))
	..()

/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/M)
	if(M.blood_volume)
		M.blood_volume += 0.1 // water is good for you!
	if(!data)
		data = list("misc" = 1)
	data["misc"]++
	M.adjust_jitter_up_to(4 SECONDS, 20 SECONDS)
	if(iscultist(M))
		for(var/datum/action/innate/cult/blood_magic/BM in M.actions)
			to_chat(M, span_cultlarge("Your blood rites falter as holy water scours your body!"))
			for(var/datum/action/innate/cult/blood_spell/BS in BM.spells)
				qdel(BS)
	if(data["misc"] >= 25)		// 10 units, 45 seconds @ metabolism 0.4 units & tick rate 1.8 sec
		M.adjust_stutter_up_to(4 SECONDS, 20 SECONDS)
		M.set_dizzy_if_lower(10 SECONDS)
		if(iscultist(M) && prob(20))
			M.say(pick("Av'te Nar'sie","Pa'lid Mors","INO INO ORA ANA","SAT ANA!","Daim'niodeis Arc'iai Le'eones","R'ge Na'sie","Diabo us Vo'iscum","Eld' Mon Nobis"), forced = "holy water")
			if(prob(10))
				M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
				M.Unconscious(120)
				to_chat(M, "<span class='cultlarge'>[pick("Your blood is your bond - you are nothing without it", "Do not forget your place", \
				"All that power, and you still fail?", "If you cannot scour this poison, I shall scour your meager life!")].</span>")
		else if(is_servant_of_ratvar(M) && prob(8))
			switch(pick("speech", "message", "emote"))
				if("speech")
					clockwork_say(M, "...[text2ratvar(pick("Engine... your light grows dark...", "Where are you, master?", "He lies rusting in Error...", "Purge all untruths and... and... something..."))]")
				if("message")
					to_chat(M, "<span class='boldwarning'>[pick("Ratvar's illumination of your mind has begun to flicker", "He lies rusting in Reebe, derelict and forgotten. And there he shall stay", \
					"You can't save him. Nothing can save him now", "It seems that Nar'sie will triumph after all")].</span>")
				if("emote")
					M.visible_message(span_warning("[M] [pick("whimpers quietly", "shivers as though cold", "glances around in paranoia")]."))
	if(data["misc"] >= 60)	// 30 units, 135 seconds
		if(iscultist(M) || is_servant_of_ratvar(M))
			if(iscultist(M))
				M.remove_cultist(FALSE, TRUE)
			else if(is_servant_of_ratvar(M))
				remove_servant_of_ratvar(M)
			M.remove_status_effect(/datum/status_effect/jitter)
			M.remove_status_effect(/datum/status_effect/speech/stutter)
			holder.remove_reagent(type, volume)	// maybe this is a little too perfect and a max() cap on the statuses would be better??
			return
	if(ishuman(M) && IS_VAMPIRE(M) && prob(80)) // Yogs Start
		var/datum/antagonist/vampire/V = M.mind.has_antag_datum(ANTAG_DATUM_VAMPIRE)
		if(!V.get_ability(/datum/vampire_passive/full))
			switch(data)
				if(1 to 4)
					to_chat(M, span_warning("Something sizzles in your veins!"))
					M.adjustFireLoss(0.5)
				if(5 to 12)
					to_chat(M, span_danger("You feel an intense burning inside of you!"))
					M.adjustFireLoss(1)
				if(13 to INFINITY)
					M.visible_message("<span class='danger'>[M] suddenly bursts into flames!<span>", span_userdanger("You suddenly ignite in a holy fire!"))
					M.adjust_fire_stacks(3)
					M.ignite_mob()            //Only problem with igniting people is currently the commonly availible fire suits make you immune to being on fire
					M.adjustFireLoss(3)        //Hence the other damages... ain't I a bastard? // Yogs End
	if(ishuman(M) && is_sinfuldemon(M) && prob(80))
		switch(data)
			if(1 to 4)
				to_chat(M, span_warning("Your unholy blood begins to burn as holy power creeps through you."))
				M.adjustFireLoss(1)
			if(5 to 10)
				to_chat(M, span_danger("The burning deepens and strengthens!"))
				M.adjustFireLoss(2)
			if(11 to 12)
				to_chat(M, span_danger("Your flesh itself begins to melt apart in agony!"))
				M.adjustFireLoss(3)
				M.emote("scream")
			if(13 to INFINITY)
				M.visible_message("<span class='danger'>[M] suddenly ignites in a brilliant flash of white!<span>", span_userdanger("You suddenly ignite in a holy fire!"))
				M.adjust_fire_stacks(3)
				M.ignite_mob()
				M.adjustFireLoss(4)
	holder.remove_reagent(type, 0.4)	//fixed consumption to prevent balancing going out of whack

/datum/reagent/water/holywater/reaction_turf(turf/T, reac_volume)
	..()
	if(!istype(T))
		return
	if(reac_volume>=10)
		for(var/obj/effect/rune/R in T)
			qdel(R)
	T.Bless()

/datum/reagent/fuel/unholywater		//if you somehow managed to extract this from someone, dont splash it on yourself and have a smoke
	name = "Unholy Water"
	description = "Something that shouldn't exist on this plane of existence."
	taste_description = "suffering"

/datum/reagent/fuel/unholywater/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (TOUCH|VAPOR)) && permeability)
		M.reagents.add_reagent(type, permeability * reac_volume / 4)
		return
	return ..()

/datum/reagent/fuel/unholywater/on_mob_life(mob/living/carbon/M)
	if(iscultist(M))
		M.adjust_drowsiness(-5 SECONDS)
		M.AdjustAllImmobility(-40, FALSE)
		M.adjustStaminaLoss(-10, 0)
		M.adjustToxLoss(-2, 0)
		M.adjustOxyLoss(-2, 0)
		M.adjustBruteLoss(-2, 0)
		M.adjustFireLoss(-2, 0)
		if(ishuman(M) && M.blood_volume < BLOOD_VOLUME_NORMAL(M))
			M.blood_volume += 3
	else  // Will deal about 90 damage when 50 units are thrown
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)
		M.adjustToxLoss(2, 0)
		M.adjustFireLoss(2, 0)
		M.adjustOxyLoss(2, 0)
		M.adjustBruteLoss(2, 0)
	holder.remove_reagent(type, 1)
	return TRUE

/datum/reagent/hellwater			//if someone has this in their system they've really pissed off an eldrich god
	name = "Hell Water"
	description = "YOUR FLESH! IT BURNS!"
	taste_description = "burning"
	accelerant_quality = 20
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/hellwater/on_mob_life(mob/living/carbon/M)
	M.fire_stacks = min(5,M.fire_stacks + 3)
	M.ignite_mob()			//Only problem with igniting people is currently the commonly availible fire suits make you immune to being on fire
	M.adjustToxLoss(1, 0)
	M.adjustFireLoss(1, 0)		//Hence the other damages... ain't I a bastard?
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 150)
	holder.remove_reagent(type, 1)

/datum/reagent/eldritch
	name = "Eldritch Essence"
	description = "Strange liquid that defies the laws of physics"
	taste_description = "glass"
	color = "#1f8016"
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/eldritch/on_mob_life(mob/living/carbon/M)
	if(IS_HERETIC(M) || IS_HERETIC_MONSTER(M))
		M.adjust_drowsiness(-5 SECONDS)
		M.AdjustAllImmobility(-40, FALSE)
		M.adjustStaminaLoss(-10, FALSE)
		M.adjustToxLoss(-2, FALSE)
		M.adjustOxyLoss(-2, FALSE)
		M.adjustBruteLoss(-2, FALSE, FALSE, BODYPART_ANY)
		M.adjustFireLoss(-2, FALSE, FALSE, BODYPART_ANY)
		if(ishuman(M) && M.blood_volume < BLOOD_VOLUME_NORMAL(M))
			M.blood_volume += 3
	else
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)
		M.adjustToxLoss(2, FALSE)
		M.adjustFireLoss(2, FALSE, FALSE, BODYPART_ANY)
		M.adjustOxyLoss(2, FALSE)
		M.adjustBruteLoss(2, FALSE, FALSE, BODYPART_ANY)
	holder.remove_reagent(type, 1)
	return TRUE

/datum/reagent/medicine/omnizine/godblood
	name = "Godblood"
	description = "Slowly heals all damage types. Has a rather high overdose threshold. Glows with mysterious power."
	overdose_threshold = 150

/datum/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	color = "#009CA8" // rgb: 0, 156, 168
	taste_description = "cherry" // by popular demand
	compatible_biotypes = ALL_BIOTYPES
	metabolization_rate = 2 * REAGENTS_METABOLISM // Double speed


/datum/reagent/lube/reaction_turf(turf/open/T, reac_volume)
	if (!istype(T))
		return
	if(reac_volume >= 1)
		T.MakeSlippery(TURF_WET_LUBE, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

/datum/reagent/lube/on_mob_metabolize(mob/living/L)
	..()
	if(isipc(L))
		L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.8, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/lube/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	..()

/datum/reagent/lube/on_mob_life(mob/living/carbon/C)
	. = ..()
	if(!isipc(C))
		return
	C.adjustFireLoss(3)
	if(prob(10))
		to_chat(C, span_warning("You slowly burn up as your internal mechanisms work faster than intended."))

/datum/reagent/spraytan
	name = "Spray Tan"
	description = "A substance applied to the skin to darken the skin."
	color = "#FFC080" // rgb: 255, 196, 128  Bright orange
	metabolization_rate = 10 * REAGENTS_METABOLISM // very fast, so it can be applied rapidly.  But this changes on an overdose
	overdose_threshold = 11 //Slightly more than one un-nozzled spraybottle.
	taste_description = "sour oranges"
	var/saved_color

/datum/reagent/spraytan/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(ishuman(M))
		if(methods & (PATCH|VAPOR))
			var/mob/living/carbon/human/N = M
			if(N.dna.species.id == SPECIES_HUMAN)
				switch(N.skin_tone)
					if("african1")
						N.skin_tone = "african2"
					if("indian")
						N.skin_tone = "mixed2"
					if("arab")
						N.skin_tone = "indian"
					if("asian2")
						N.skin_tone = "arab"
					if("asian1")
						N.skin_tone = "asian2"
					if("mediterranean")
						N.skin_tone = "mixed1"
					if("latino")
						N.skin_tone = "mediterranean"
					if("caucasian3")
						N.skin_tone = "mediterranean"
					if("caucasian2")
						N.skin_tone = pick("caucasian3", "latino")
					if("caucasian1")
						N.skin_tone = "caucasian2"
					if ("albino")
						N.skin_tone = "caucasian1"
					if("mixed1")
						N.skin_tone = "mixed2"
					if("mixed2")
						N.skin_tone = "mixed3"
					if("mixed3")
						N.skin_tone = "african1"
					if("mixed4")
						N.skin_tone = "mixed3"

			if(MUTCOLORS in N.dna.species.species_traits) //take current alien color and darken it slightly
				var/newcolor = ""
				var/string = N.dna.features["mcolor"]
				var/len = length(string)
				var/char = ""
				var/ascii = 0
				for(var/i=1, i<=len, i += length(char))
					char = string[i]
					ascii = text2ascii(char)
					switch(ascii)
						if(48)
							newcolor += "0"
						if(49 to 57)
							newcolor += ascii2text(ascii-1)	//numbers 1 to 9
						if(97)
							newcolor += "9"
						if(98 to 102)
							newcolor += ascii2text(ascii-1)	//letters b to f lowercase
						if(65)
							newcolor +="9"
						if(66 to 70)
							newcolor += ascii2text(ascii+31)	//letters B to F - translates to lowercase
						else
							break
				if(ReadHSV(newcolor)[3] >= ReadHSV("#777777")[3])
					N.dna.features["mcolor"] = newcolor
			N.regenerate_icons()



		if(methods & INGEST)
			if(show_message)
				to_chat(M, span_notice("That tasted horrible."))
	..()


/datum/reagent/spraytan/overdose_process(mob/living/M)
	metabolization_rate = 1 * REAGENTS_METABOLISM

	if(ishuman(M))
		var/mob/living/carbon/human/N = M
		if(!HAS_TRAIT(M, TRAIT_BALD))
			N.hair_style = "Spiky"
		N.facial_hair_style = "Shaved"
		N.facial_hair_color = "000"
		N.hair_color = "000"
		if(!(HAIR in N.dna.species.species_traits)) //No hair? No problem!
			N.dna.species.species_traits += HAIR
		if(N.dna.species.use_skintones)
			saved_color = N.skin_tone
			N.skin_tone = "orange"
		else if(MUTCOLORS in N.dna.species.species_traits) //Aliens with custom colors simply get turned orange
			saved_color = N.dna.features["mcolor"]
			N.dna.features["mcolor"] = "#FF8800"
		N.regenerate_icons()
		if(prob(7))
			if(N.w_uniform)
				M.visible_message(pick("<b>[M]</b>'s collar pops up without warning.</span>", "<b>[M]</b> flexes [M.p_their()] arms."))
			else
				M.visible_message("<b>[M]</b> flexes [M.p_their()] arms.")
	if(prob(10))
		M.say(pick("Shit was SO cash.", "You are everything bad in the world.", "What sports do you play, other than 'jack off to naked drawn Japanese people?'", "Don???t be a stranger. Just hit me with your best shot.", "My name is John and I hate every single one of you."), forced = /datum/reagent/spraytan)
	..()
	return

/datum/reagent/spraytan/on_mob_delete(mob/living/M)
	if(ishuman(M) && saved_color)
		var/mob/living/carbon/human/N = M
		if(N.dna.species.use_skintones)
			N.skin_tone = saved_color
		else if(MUTCOLORS in N.dna.species.species_traits)
			N.dna.features["mcolor"] = saved_color
		N.regenerate_icons()
	..()

/datum/reagent/mutationtoxin
	name = "Stable Mutation Toxin"
	description = "A humanizing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = 0.1 //has to be low so it can metabolize for longer at the same reagent counts
	taste_description = "slime"
	var/datum/species/race = /datum/species/human
	var/mutationtext = span_danger("The pain subsides. You feel... human.")
	var/frozen = FALSE //warnings for the reagent being in/active
	var/already_mutating = FALSE //no return point for mutation so we don't spam ourselves

/datum/reagent/mutationtoxin/on_mob_life(mob/living/carbon/human/H)
	..()
	if(!istype(H))
		return
	if(!data)
		data = list("transfurmation" = 1)
		to_chat(H, span_warning("Something begins to shift under your skin, and you feel like you are heating up...")) //I think this is the best way to say "hey you should probably cool down to avoid this"
	if(H.bodytemperature >= T0C + 10 && !H.reagents.has_reagent(/datum/reagent/consumable/ice)) //if we're consuming ice, or have cooled ourselves, the toxin stops because slimes hate cold
		data["transfurmation"]++
		if(frozen)
			frozen = FALSE
			to_chat(H, span_warning("The movement beneath your skin picks up again..."))
	else
		data["transfurmation"]--
		if(!frozen)
			frozen = TRUE
			to_chat(H, span_warning("The movement beneath your skin stops, for now..."))

	if(!frozen) //welcome to flavor town
		if(data["transfurmation"] == 10) //that's bad cable management
			to_chat(H, span_warning("You feel uncomfortably warm."))
		if(data["transfurmation"] == 25) //take them out
			to_chat(H, span_warning("Your insides feel like jelly."))
		if(data["transfurmation"] == 40) //fix. them.
			to_chat(H, span_warning("Your skin is wrong. Your skin is wrong."))

	if(data["transfurmation"] >= 50 && !already_mutating) //~100 seconds & 5 units at 2 seconds per process & 0.1 metabolization rate
		already_mutating = TRUE
		var/current_species = H.dna.species.type
		var/datum/species/mutation = race
		if(mutation && mutation != current_species) //the real mutation was the friends we made along the way :)
			to_chat(H, span_warning("<b>You crumple in agony as your flesh wildly morphs into new forms!</b>"))
			H.visible_message("<b>[H]</b> falls to the ground and screams as [H.p_their()] skin bubbles and froths!") //'froths' sounds painful when used with SKIN.
			H.Knockdown(2 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(mutate), H), 2 SECONDS)
		else
			to_chat(H, span_notice("There is a sudden, relieving lack of skin shifting."))
			H.reagents.del_reagent(type) //adios
	return

/datum/reagent/mutationtoxin/on_mob_end_metabolize(mob/living/L)
	..()
	to_chat(L, span_notice("There is sudden, relieving lack of skin shifting."))

/datum/reagent/mutationtoxin/proc/mutate(mob/living/carbon/human/H)
	if(QDELETED(H))
		return
	to_chat(H, mutationtext)
	H.set_species(race)
	if(HAS_TRAIT(H, TRAIT_GENELESS))
		if(H.has_dna())
			H.dna.remove_all_mutations(list(MUT_NORMAL, MUT_EXTRA), TRUE)
	H.reagents.del_reagent(type) //adios

/datum/reagent/mutationtoxin/classic //The one from plasma on green slimes
	name = "Mutation Toxin"
	description = "A corruptive toxin."
	color = "#13BC5E" // rgb: 19, 188, 94
	race = /datum/species/jelly/slime
	mutationtext = span_danger("The pain subsides. Your whole body feels like slime.")

/datum/reagent/mutationtoxin/felinid
	name = "Felinid Mutation Toxin"
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/human/felinid
	mutationtext = span_danger("The pain subsides. You feel... like a degenerate.")

/datum/reagent/mutationtoxin/lizard
	name = "Lizard Mutation Toxin"
	description = "A lizarding toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/lizard
	mutationtext = span_danger("The pain subsides. You feel... scaly.")

/datum/reagent/mutationtoxin/fly
	name = "Fly Mutation Toxin"
	description = "An insectifying toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/fly
	mutationtext = span_danger("The pain subsides. You feel... buzzy.")

/datum/reagent/mutationtoxin/moth
	name = "Moth Mutation Toxin"
	description = "A glowing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/moth
	mutationtext = span_danger("The pain subsides. You feel... attracted to light.")

/datum/reagent/mutationtoxin/pod
	name = "Podperson Mutation Toxin"
	description = "A vegetalizing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/pod
	mutationtext = span_danger("The pain subsides. You feel... plantlike.")

/datum/reagent/mutationtoxin/ethereal
	name = "Ethereal Mutation Toxin"
	description = "An electrifying toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/ethereal
	mutationtext = span_danger("The pain subsides. You feel... ecstatic.")

/datum/reagent/mutationtoxin/preternis
	name = "Preternis Mutation Toxin"
	description = "A metallic precursor toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/preternis
	mutationtext = span_danger("The pain subsides. You feel... optimized.")

/datum/reagent/mutationtoxin/polysmorph
	name = "Polysmorph Mutation Toxin"
	description = "An acidic toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/polysmorph
	mutationtext = span_danger("The pain subsides. You feel... Alien.")

/datum/reagent/mutationtoxin/jelly
	name = "Imperfect Mutation Toxin"
	description = "An jellyfying toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/jelly
	mutationtext = span_danger("The pain subsides. You feel... wobbly.")

/datum/reagent/mutationtoxin/golem
	name = "Golem Mutation Toxin"
	description = "A crystal toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/golem/random
	mutationtext = span_danger("The pain subsides. You feel... rocky.")

/datum/reagent/mutationtoxin/abductor
	name = "Abductor Mutation Toxin"
	description = "An alien toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/abductor
	mutationtext = span_danger("The pain subsides. You feel... alien.")


//BLACKLISTED RACES
/datum/reagent/mutationtoxin/skeleton
	name = "Skeleton Mutation Toxin"
	description = "A scary toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/skeleton
	mutationtext = span_danger("The pain subsides. You feel... spooky.")

/datum/reagent/mutationtoxin/zombie
	name = "Zombie Mutation Toxin"
	description = "An undead toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/zombie //Not the infectious kind. The days of xenobio zombie outbreaks are long past.
	mutationtext = span_danger("The pain subsides. You feel... undead.")

/datum/reagent/mutationtoxin/ash
	name = "Ash Mutation Toxin"
	description = "An ashen toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/lizard/ashwalker
	mutationtext = span_danger("The pain subsides. You feel... savage.")


//DANGEROUS RACES
/datum/reagent/mutationtoxin/shadow
	name = "Shadow Mutation Toxin"
	description = "A dark toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/shadow
	mutationtext = span_danger("The pain subsides. You feel... darker.")

/datum/reagent/mutationtoxin/plasma
	name = "Plasma Mutation Toxin"
	description = "A plasma-based toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	can_synth = FALSE //uhh no? we don't want people mass producing fire skeleton toxin?
	race = /datum/species/plasmaman
	mutationtext = span_danger("The pain subsides. You feel... flammable.")

/datum/reagent/slime_toxin
	name = "Slime Mutation Toxin"
	description = "A toxin that turns organic material into slime."
	color = "#5EFF3B" //RGB: 94, 255, 59
	taste_description = "slime"
	metabolization_rate = 0.2

/datum/reagent/slime_toxin/on_mob_life(mob/living/carbon/human/H)
	..()
	if(!istype(H))
		return
	if(!H.dna || !H.dna.species || !(H.mob_biotypes & MOB_ORGANIC))
		return

	if(isjellyperson(H))
		to_chat(H, span_warning("Your jelly shifts and morphs, turning you into another subspecies!"))
		var/species_type = pick(subtypesof(/datum/species/jelly))
		H.set_species(species_type)
		H.reagents.del_reagent(type)

	switch(current_cycle)
		if(1 to 6)
			if(prob(10))
				to_chat(H, span_warning("[pick("You don't feel very well.", "Your skin feels a little slimy.")]"))
		if(7 to 12)
			if(prob(10))
				to_chat(H, span_warning("[pick("Your appendages are melting away.", "Your limbs begin to lose their shape.")]"))
		if(13 to 19)
			if(prob(10))
				to_chat(H, span_warning("[pick("You feel your internal organs turning into slime.", "You feel very slimelike.")]"))
		if(20 to INFINITY)
			var/species_type = pick(subtypesof(/datum/species/jelly))
			H.set_species(species_type)
			H.reagents.del_reagent(type)
			to_chat(H, span_warning("You have become a jellyperson!")) // Yogs -- text macro fix

/datum/reagent/mulligan
	name = "Mulligan Toxin"
	description = "This toxin will rapidly change the DNA of human beings. Commonly used by Syndicate spies and assassins in need of an emergency ID change."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = INFINITY
	taste_description = "slime"

/datum/reagent/mulligan/on_mob_life(mob/living/carbon/human/H)
	..()
	if (!istype(H))
		return
	to_chat(H, span_warning("<b>You grit your teeth in pain as your body rapidly mutates!</b>"))
	H.visible_message("<b>[H]</b> suddenly transforms!")
	randomize_human(H)
	H.dna.update_dna_identity()

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	description = "An advanced corruptive toxin produced by slimes."
	color = "#13BC5E" // rgb: 19, 188, 94
	can_synth = FALSE //sorry, wrong maintenance pill, enjoy  being a dumb slime permanently
	taste_description = "slime"

/datum/reagent/aslimetoxin/reaction_mob(mob/living/M, methods = TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(!(methods & TOUCH) && prob(permeability * 100))
		M.ForceContractDisease(new /datum/disease/transformation/slime(), FALSE, TRUE)

/datum/reagent/gluttonytoxin
	name = "Gluttony's Blessing"
	description = "An advanced corruptive toxin produced by something terrible."
	color = "#5EFF3B" //RGB: 94, 255, 59
	can_synth = FALSE
	taste_description = "decay"

/datum/reagent/gluttonytoxin/reaction_mob(mob/living/M, methods = TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(prob(permeability * 100))
		M.ForceContractDisease(new /datum/disease/transformation/morph(), FALSE, TRUE)

/datum/reagent/ghosttoxin
	name = "Ghost's Curse"
	description = "An advanced corruptive toxin produced by something otherwordly."
	color = "#5EFF3B" //RGB: 94, 255, 59
	can_synth = FALSE
	taste_description = "decay"

/datum/reagent/ghosttoxin/reaction_mob(mob/living/M, methods = TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(prob(permeability * 100))
		M.ForceContractDisease(new /datum/disease/transformation/ghost(), FALSE, TRUE)

/datum/reagent/serotrotium
	name = "Serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	color = "#202040" // rgb: 20, 20, 40
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "bitterness"

/datum/reagent/serotrotium/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		if(prob(7))
			M.emote(pick("twitch","drool","moan","gasp"))
	..()

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal. Things made out of copper aren't very durable, but it makes a decent material for electrical wiring."
	reagent_state = SOLID
	color = "#6E3B08" // rgb: 110, 59, 8
	taste_description = "metal"

/datum/reagent/copper/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		reac_volume = min(reac_volume, M.amount)
		new/obj/item/stack/tile/bronze(get_turf(M), reac_volume)
		M.use(reac_volume)

/datum/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	taste_description = "sweetness"

/datum/reagent/mercury
	name = "Mercury"
	description = "A curious metal that's a liquid at room temperature. Neurodegenerative and very bad for the mind."
	color = "#484848" // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.

/datum/reagent/mercury/on_mob_life(mob/living/carbon/M)
	if((M.mobility_flags & MOBILITY_MOVE) && !isspaceturf(M.loc))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	..()

/datum/reagent/sulphur
	name = "Sulphur"
	description = "A sickly yellow solid mostly known for its nasty smell. It's actually much more helpful than it looks in biochemisty."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	taste_description = "rotten eggs"

/datum/reagent/carbon
	name = "Carbon"
	description = "A crumbly black solid that, while unexciting on a physical level, forms the base of all known life. Kind of a big deal."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	taste_description = "sour chalk"

/datum/reagent/carbon/reaction_turf(turf/T, reac_volume)
	if(!isspaceturf(T))
		var/obj/effect/decal/cleanable/dirt/D = locate() in T.contents
		if(!D)
			new /obj/effect/decal/cleanable/dirt(T)

/datum/reagent/chlorine
	name = "Chlorine"
	description = "A pale yellow gas that's well known as an oxidizer. While it forms many harmless molecules in its elemental form it is far from harmless."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "chlorine"

/datum/reagent/chlorine/on_mob_life(mob/living/carbon/M)
	M.take_bodypart_damage(1*REM, 0, 0, 0)
	. = 1
	..()

/datum/reagent/fluorine
	name = "Fluorine"
	description = "A comically-reactive chemical element. The universe does not want this stuff to exist in this form in the slightest."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "acid"

/datum/reagent/fluorine/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1*REM, 0)
	. = 1
	..()

/datum/reagent/sodium
	name = "Sodium"
	description = "A soft silver metal that can easily be cut with a knife. It's not salt just yet, so refrain from putting in on your chips."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "salty metal"

/datum/reagent/phosphorus
	name = "Phosphorus"
	description = "A ruddy red powder that burns readily. Though it comes in many colors, the general theme is always the same."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	taste_description = "vinegar"

/datum/reagent/lithium
	name = "Lithium"
	description = "A silver metal, its claim to fame is its remarkably low density. Using it is a bit too effective in calming oneself down."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "metal"

/datum/reagent/lithium/on_mob_life(mob/living/carbon/M)
	if((M.mobility_flags & MOBILITY_MOVE) && !isspaceturf(M.loc))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/glycerol
	name = "Glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "sweetness"

/datum/reagent/space_cleaner/sterilizine
	name = "Sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	color = "#C8A5DC" // rgb: 200, 165, 220
	taste_description = "bitterness"
	toxpwr = 0

/datum/reagent/space_cleaner/sterilizine/reaction_mob(mob/living/carbon/C, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & (TOUCH|VAPOR|PATCH))
		for(var/s in C.surgeries)
			var/datum/surgery/S = s
			S.success_multiplier = max(0.2, S.success_multiplier)
			// +20% success propability on each step, useful while operating in less-than-perfect conditions
	..()

/datum/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	taste_description = "iron"

	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/iron/on_mob_life(mob/living/carbon/C)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL(C))
		C.blood_volume += 0.5
	..()

/datum/reagent/iron/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(M.has_bane(BANE_IRON)) //If the target is weak to cold iron, then poison them.
		if(holder && holder.chem_temp < 100) // COLD iron.
			M.reagents.add_reagent(/datum/reagent/toxin, reac_volume)
	..()

/datum/reagent/gold
	name = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_description = "expensive metal"

/datum/reagent/silver
	name = "Silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_description = "expensive yet reasonable metal"

/datum/reagent/silver/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(M.has_bane(BANE_SILVER))
		M.reagents.add_reagent(/datum/reagent/toxin, reac_volume)
	if(ishuman(M) && is_sinfuldemon(M) && prob(80)) //sinful demons have a lesser reaction to silver
		M.reagents.add_reagent(/datum/reagent/toxin, reac_volume)
	..()

/datum/reagent/uranium
	name ="Uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192
	taste_description = "the inside of a reactor"
	var/irradiation_level = 1
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/uranium/on_mob_life(mob/living/carbon/M)
	M.apply_effect(irradiation_level/M.metabolism_efficiency,EFFECT_IRRADIATE,0)
	..()

/datum/reagent/uranium/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 3)
		if(!isspaceturf(T))
			var/obj/effect/decal/cleanable/greenglow/GG = locate() in T.contents
			if(!GG)
				GG = new/obj/effect/decal/cleanable/greenglow(T)
			GG.reagents.add_reagent(type, reac_volume)

/datum/reagent/uranium/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	taste_description = "the colour blue and regret"
	irradiation_level = 2*REM
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/bluespace
	name = "Bluespace Dust"
	description = "A dust composed of microscopic bluespace crystals, with minor space-warping properties."
	reagent_state = SOLID
	color = "#0000CC"
	taste_description = "fizzling blue"
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/bluespace/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (TOUCH|VAPOR)) && (reac_volume > 5))
		do_teleport(M, get_turf(M), (reac_volume / 5), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //4 tiles per crystal
	return ..()

/datum/reagent/bluespace/reaction_obj(obj/O, volume)
	if(volume > 5 && !O.anchored) // can teleport objects that aren't anchored
		do_teleport(O, get_turf(O), (volume / 5), asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //4 tiles per crystal
	return ..()

/datum/reagent/bluespace/on_mob_life(mob/living/carbon/M)
	if(current_cycle > 10 && prob(15))
		to_chat(M, span_warning("You feel unstable..."))
		M.adjust_jitter(2 SECONDS)
		current_cycle = 1
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living, bluespace_shuffle)), 30)
	..()

/mob/living/proc/bluespace_shuffle()
	do_teleport(src, get_turf(src), 5, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

#define REDSPACE_TELEPORT_MINIMUM 5
//Gateway to traitor chemistry, want a drug to be traitor only? use this
/datum/reagent/redspace
	name = "Redspace Dust"
	description = "A sinister looking dust composed of grinded Syndicate telecrystals, the red colouration a result of impurities within their manufacturing process."
	reagent_state = SOLID
	color = "#db0735"
	taste_description = "bitter evil"
	compatible_biotypes = ALL_BIOTYPES
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	can_synth = FALSE

//Teleport like normal telecrystals
/datum/reagent/redspace/on_mob_metabolize(mob/living/L)
	if(volume >= REDSPACE_TELEPORT_MINIMUM)
		var/turf/destination = get_teleport_loc(L.loc, L, rand(3,6))
		if(!istype(destination))
			return
		new /obj/effect/particle_effect/sparks(L.loc)
		playsound(L.loc, "sparks", 50, 1)
		if(!do_teleport(L, destination, asoundin = 'sound/effects/phaseinred.ogg', channel = TELEPORT_CHANNEL_BLUESPACE))
			return
		L.throw_at(get_edge_target_turf(L, L.dir), 1, 3, spin = FALSE, diagonals_first = TRUE)
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.adjust_disgust(15)
	L.reagents.remove_reagent(type, volume)

#undef REDSPACE_TELEPORT_MINIMUM

/datum/reagent/aluminium
	name = "Aluminium"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_description = "metal"

/datum/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_mult = 0

/datum/reagent/fuel
	name = "Welding fuel"
	description = "Required for welders. Flammable."
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "gross metal"
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the glass_name might imply."
	accelerant_quality = 15
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/fuel/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)//Splashing people with welding fuel to make them easy to ignite!
	if(methods & (TOUCH|VAPOR))
		M.adjust_fire_stacks(reac_volume / 10)
		return
	..()

/datum/reagent/fuel/on_mob_life(mob/living/carbon/M)
	if(M.mob_biotypes & MOB_ROBOTIC)
		M.adjustFireLoss(-1*REM, FALSE, FALSE, BODYPART_ROBOTIC)
	else
		M.adjustToxLoss(1*REM, 0)
	..()
	return TRUE

/datum/reagent/space_cleaner
	name = "Space cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	color = "#A5F0EE" // rgb: 165, 240, 238
	var/toxpwr = 1
	taste_description = "sourness"
	reagent_weight = 0.6 //so it sprays further
	var/clean_types = CLEAN_WASH

/datum/reagent/space_cleaner/reaction_obj(obj/O, reac_volume)
	O?.wash(clean_types)

/datum/reagent/space_cleaner/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 1)
		T.wash(clean_types)
		for(var/am in T)
			var/atom/movable/movable_content = am
			if(ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash
				continue
			movable_content.wash(clean_types)

		for(var/mob/living/simple_animal/slime/M in T)
			M.adjustToxLoss(rand(5,10))

/datum/reagent/space_cleaner/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & (TOUCH|VAPOR))
		M.wash(clean_types)
	if(methods & (INJECT|INGEST))
		return ..() // stop drinking space cleaner!! no fun allowed!!

/datum/reagent/space_cleaner/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(toxpwr*REM, 0)
	..()

/datum/reagent/space_cleaner/ez_clean
	name = "EZ Clean"
	description = "A powerful, acidic cleaner sold by Waffle Co. Affects organic matter while leaving other objects unaffected."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "acid"
	can_synth = FALSE

/datum/reagent/space_cleaner/ez_clean/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(6.33)
	M.adjustFireLoss(6.33)
	M.adjustToxLoss(6.33)
	..()

/datum/reagent/space_cleaner/ez_clean/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	..()
	if((methods & (TOUCH|VAPOR)) && !issilicon(M) && permeability)
		var/existing = M.reagents.get_reagent_amount(type)
		M.reagents.add_reagent(type, max(reac_volume - existing, 0) * permeability)
		M.adjustBruteLoss(1 * reac_volume * permeability)
		M.adjustFireLoss(1 * reac_volume * permeability)
		M.emote("scream")

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizziness."
	color = "#C8A5DC" // rgb: 200, 165, 220
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "sourness"

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/affected_mob)
	affected_mob.set_dizzy_if_lower(2 SECONDS)

	// Cryptobiolin adjusts the mob's confusion down to 20 seconds if it's higher,
	// or up to 1 second if it's lower, but will do nothing if it's in between
	var/confusion_left = affected_mob.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(confusion_left < 1 SECONDS)
		affected_mob.set_confusion(1 SECONDS)

	else if(confusion_left > 20 SECONDS)
		affected_mob.set_confusion(20 SECONDS)
	..()

/datum/reagent/impedrezene
	name = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	color = "#C8A5DC" // rgb: 200, 165, 220A
	taste_description = "numbness"

/datum/reagent/impedrezene/on_mob_life(mob/living/carbon/affected_mob)
	affected_mob.adjust_jitter(-5 SECONDS)
	if(prob(80))
		affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	if(prob(50))
		affected_mob.adjust_drowsiness(6 SECONDS)
	if(prob(10))
		affected_mob.emote("drool")
	..()

/datum/reagent/nanomachines
	name = "Nanomachines"
	description = "Microscopic construction robots."
	color = "#535E66" // rgb: 83, 94, 102
	can_synth = FALSE
	taste_description = "sludge"

/datum/reagent/nanomachines/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*permeability)))
		L.ForceContractDisease(new /datum/disease/transformation/robot(), FALSE, TRUE)

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	color = "#535E66" // rgb: 83, 94, 102
	can_synth = FALSE
	taste_description = "sludge"

/datum/reagent/xenomicrobes/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*permeability)))
		L.ForceContractDisease(new /datum/disease/transformation/xeno(), FALSE, TRUE)

/datum/reagent/fungalspores
	name = "Tubercle bacillus Cosmosis microbes"
	description = "Active fungal spores."
	color = "#92D17D" // rgb: 146, 209, 125
	can_synth = FALSE
	taste_description = "slime"

/datum/reagent/fungalspores/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*permeability)))
		L.ForceContractDisease(new /datum/disease/tuberculosis(), FALSE, TRUE)

/datum/reagent/snail
	name = "Agent-S"
	description = "Virological agent that infects the subject with Gastrolosis."
	color = "#003300" // rgb(0, 51, 0)
	taste_description = "goo"
	can_synth = FALSE //special orange man request

/datum/reagent/snail/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*permeability)))
		L.ForceContractDisease(new /datum/disease/gastrolosis(), FALSE, TRUE)

/datum/reagent/fluorosurfactant//foam precursor
	name = "Fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	color = "#9E6B38" // rgb: 158, 107, 56
	taste_description = "metal"

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	description = "An agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "metal"

/datum/reagent/smart_foaming_agent //Smart foaming agent. Functions similarly to metal foam, but conforms to walls.
	name = "Smart foaming agent"
	description = "An agent that yields metallic foam which conforms to area boundaries when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "metal"

/datum/reagent/ammonia
	name = "Ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	taste_description = "mordant"

/datum/reagent/diethylamine
	name = "Diethylamine"
	description = "A secondary amine, mildly corrosive."
	color = "#604030" // rgb: 96, 64, 48
	taste_description = "iron"

/////////////////////////Coloured Crayon Powder////////////////////////////
//For colouring in /proc/mix_color_from_reagents


/datum/reagent/colorful_reagent/crayonpowder
	name = "Crayon Powder"
	var/colorname = "none"
	description = "A powder made by grinding down crayons, good for colouring chemical reagents."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 207, 54, 0
	taste_description = "the back of class"

/datum/reagent/colorful_reagent/crayonpowder/New()
	description = "\an [colorname] powder made by grinding down crayons, good for colouring chemical reagents."


/datum/reagent/colorful_reagent/crayonpowder/red
	name = "Red Crayon Powder"
	colorname = "red"
	color = "#DA0000" // red
	random_color_list = list("#DA0000")

// Pepperspray coloring, only affects mobs
/datum/reagent/colorful_reagent/crayonpowder/red/pepperspray/reaction_obj(obj/O, reac_volume)
	return

/datum/reagent/colorful_reagent/crayonpowder/red/pepperspray/reaction_turf(turf/T, reac_volume)
	return

/datum/reagent/colorful_reagent/crayonpowder/orange
	name = "Orange Crayon Powder"
	colorname = "orange"
	color = "#FF9300" // orange
	random_color_list = list("#FF9300")

/datum/reagent/colorful_reagent/crayonpowder/yellow
	name = "Yellow Crayon Powder"
	colorname = "yellow"
	color = "#FFF200" // yellow
	random_color_list = list("#FFF200")

/datum/reagent/colorful_reagent/crayonpowder/green
	name = "Green Crayon Powder"
	colorname = "green"
	color = "#A8E61D" // green
	random_color_list = list("#A8E61D")

/datum/reagent/colorful_reagent/crayonpowder/blue
	name = "Blue Crayon Powder"
	colorname = "blue"
	color = "#00B7EF" // blue
	random_color_list = list("#00B7EF")

/datum/reagent/colorful_reagent/crayonpowder/purple
	name = "Purple Crayon Powder"
	colorname = "purple"
	color = "#DA00FF" // purple
	random_color_list = list("#DA00FF")

/datum/reagent/colorful_reagent/crayonpowder/invisible
	name = "Invisible Crayon Powder"
	colorname = "invisible"
	color = "#FFFFFF00" // white + no alpha
	random_color_list = list(null)	//because using the powder color turns things invisible

/datum/reagent/colorful_reagent/crayonpowder/black
	name = "Black Crayon Powder"
	colorname = "black"
	color = "#404040" // not quite black
	random_color_list = list("#404040")

/datum/reagent/colorful_reagent/crayonpowder/white
	name = "White Crayon Powder"
	colorname = "white"
	color = "#FFFFFF" // white
	random_color_list = list("#FFFFFF") //doesn't actually change appearance at all




//////////////////////////////////Hydroponics stuff///////////////////////////////

/datum/reagent/plantnutriment
	name = "Generic nutriment"
	description = "Some kind of nutriment. You can't really tell what it is. You should probably report it, along with how you obtained it."
	color = "#000000" // RBG: 0, 0, 0
	var/tox_prob = 0
	taste_description = "plant food"

/datum/reagent/plantnutriment/on_mob_life(mob/living/carbon/M)
	if(prob(tox_prob))
		M.adjustToxLoss(1*REM, 0)
		. = 1
	..()

/datum/reagent/plantnutriment/eznutriment
	name = "E-Z-Nutrient"
	description = "Cheap and extremely common type of plant nutriment."
	color = "#376400" // RBG: 50, 100, 0
	tox_prob = 10

/datum/reagent/plantnutriment/left4zednutriment
	name = "Left 4 Zed"
	description = "Unstable nutriment that makes plants mutate more often than usual."
	color = "#1A1E4D" // RBG: 26, 30, 77
	tox_prob = 25

/datum/reagent/plantnutriment/robustharvestnutriment
	name = "Robust Harvest"
	description = "Very potent nutriment that prevents plants from mutating."
	color = "#9D9D00" // RBG: 157, 157, 0
	tox_prob = 15

/datum/reagent/plantnutriment/tribalnutriment
	name = "Mushroom Paste Fertilizer"
	description = "A fertilizer made from mushrooms and gutlunch honey found on lavaland that preventes plants from mutating."
	color = "#800000"
	tox_prob = 15
	taste_description = "actual hell"





// GOON OTHERS



/datum/reagent/oil
	name = "Oil"
	description = "Burns in a small smoky fire, mostly used to get Ash."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "oil"
	compatible_biotypes = ALL_BIOTYPES
	accelerant_quality = 8

/datum/reagent/oil/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-2*REM, FALSE, FALSE, BODYPART_ROBOTIC)
	..()

/datum/reagent/stable_plasma
	name = "Stable Plasma"
	description = "Non-flammable plasma locked into a liquid form that cannot ignite or become gaseous/solid."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "bitterness"
	taste_mult = 1.5
	compatible_biotypes = ALL_BIOTYPES

/datum/reagent/stable_plasma/on_mob_life(mob/living/carbon/C)
	C.adjustPlasma(10)
	..()

/datum/reagent/iodine
	name = "Iodine"
	description = "Commonly added to table salt as a nutrient. On its own it tastes far less pleasing."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "metal"

/datum/reagent/carpet
	name = "Carpet"
	description = "For those that need a more creative way to roll out a red carpet."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "carpet" // Your tounge feels furry.

/datum/reagent/carpet/reaction_turf(turf/T, reac_volume)
	if(isplatingturf(T) || istype(T, /turf/open/floor/plasteel))
		var/turf/open/floor/F = T
		F.place_on_top(/turf/open/floor/carpet, flags = CHANGETURF_INHERIT_AIR)
	..()

/datum/reagent/bromine
	name = "Bromine"
	description = "A brownish liquid that's highly reactive. Useful for stopping free radicals, but not intended for human consumption."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "chemicals"

/datum/reagent/phenol
	name = "Phenol"
	description = "An aromatic ring of carbon with a hydroxyl group. A useful precursor to some medicines, but has no healing properties on its own."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "acid"

/datum/reagent/ash
	name = "Ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#808080"
	taste_description = "ash"

/datum/reagent/acetone
	name = "Acetone"
	description = "A slick, slightly carcinogenic liquid. Has a multitude of mundane uses in everyday life."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "acid"

/datum/reagent/colorful_reagent
	name = "Colorful Reagent"
	description = "Thoroughly sample the rainbow."
	reagent_state = LIQUID
	color = "#C8A5DC"
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")
	taste_description = "rainbows"


/datum/reagent/colorful_reagent/on_mob_life(mob/living/carbon/M)
	M.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/colorful_reagent/reaction_mob(mob/living/M, methods, reac_volume, show_message = TRUE, permeability = 1)
	M.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/colorful_reagent/reaction_obj(obj/O, reac_volume)
	if(O)
		O.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/colorful_reagent/reaction_turf(turf/T, reac_volume)
	if(T)
		T.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/hair_dye
	name = "Quantum Hair Dye"
	description = "Has a high chance of making you look like a mad scientist."
	reagent_state = LIQUID
	color = "#C8A5DC"
	var/list/potential_colors = list("0ad","a0f","f73","d14","d14","0b5","0ad","f73","fc2","084","05e","d22","fa0") // fucking hair code
	taste_description = "sourness"

/datum/reagent/hair_dye/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & (TOUCH|VAPOR))
		if(M && ishuman(M) && permeability)
			var/mob/living/carbon/human/H = M
			H.hair_color = pick(potential_colors)
			H.facial_hair_color = pick(potential_colors)
			H.update_hair()

/datum/reagent/barbers_aid
	name = "Barber's Aid"
	description = "A solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "sourness"

/datum/reagent/barbers_aid/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & (TOUCH|VAPOR))
		if(M && ishuman(M) && permeability && !HAS_TRAIT(M, TRAIT_BALD))
			var/mob/living/carbon/human/H = M
			var/datum/sprite_accessory/hair/picked_hair = pick(GLOB.hair_styles_list)
			var/datum/sprite_accessory/facial_hair/picked_beard = pick(GLOB.facial_hair_styles_list)
			H.hair_style = picked_hair
			H.facial_hair_style = picked_beard
			H.update_hair()

/datum/reagent/concentrated_barbers_aid
	name = "Concentrated Barber's Aid"
	description = "A concentrated solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "sourness"

/datum/reagent/concentrated_barbers_aid/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & (TOUCH|VAPOR))
		if(M && ishuman(M) && permeability && !HAS_TRAIT(M, TRAIT_BALD))
			var/mob/living/carbon/human/H = M
			H.hair_style = "Very Long Hair"
			H.facial_hair_style = "Beard (Very Long)"
			H.update_hair()

/datum/reagent/baldium
	name = "Baldium"
	description = "A major cause of hair loss across the world."
	reagent_state = LIQUID
	color = "#ecb2cf"
	taste_description = "bitterness"

/datum/reagent/baldium/reaction_mob(mob/living/M, methods, reac_volume, show_message = TRUE, permeability = 1)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)))
		return
	if(!permeability)
		return
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		to_chat(H, span_danger("Your hair starts to fall out in clumps!"))
		H.hair_style = "Bald"
		H.facial_hair_style = "Shaved"
		H.update_hair()

/datum/reagent/saltpetre
	name = "Saltpetre"
	description = "Volatile. Controversial. Third Thing."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "cool salt"

/datum/reagent/lye
	name = "Lye"
	description = "Also known as sodium hydroxide. As a profession making this is somewhat underwhelming."
	reagent_state = LIQUID
	color = "#FFFFD6" // very very light yellow
	taste_description = "acid"

/datum/reagent/drying_agent
	name = "Drying agent"
	description = "A desiccant. Can be used to dry things."
	reagent_state = LIQUID
	color = "#A70FFF"
	taste_description = "dryness"
	group_evaporation_rate = 16
	evaporation_rate = 0 //will never evaporate on it's own

/datum/reagent/drying_agent/reaction_turf(turf/open/T, reac_volume)
	if(istype(T))
		T.MakeDry(ALL, TRUE, reac_volume * 5 SECONDS)		//50 deciseconds per unit

/datum/reagent/drying_agent/reaction_obj(obj/O, reac_volume)
	if(O.type == /obj/item/clothing/shoes/galoshes)
		var/t_loc = get_turf(O)
		qdel(O)
		new /obj/item/clothing/shoes/galoshes/dry(t_loc)

// Virology virus food chems.

/datum/reagent/toxin/mutagen/mutagenvirusfood
	name = "mutagenic agar"
	color = "#A3C00F" // rgb: 163,192,15
	taste_description = "sourness"

/datum/reagent/toxin/mutagen/mutagenvirusfood/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1.5*REM, 0)
	..()

/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	name = "sucrose agar"
	color = "#41B0C0" // rgb: 65,176,192
	taste_description = "sweetness"

/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(0.5*REM, 0)
	..()


/datum/reagent/medicine/synaptizine/synaptizinevirusfood
	name = "virus rations"
	color = "#D18AA5" // rgb: 209,138,165
	taste_description = "bitterness"

/datum/reagent/medicine/synaptizine/synaptizinevirusfood/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(0.25*REM, 0)
	..()


/datum/reagent/toxin/plasma/plasmavirusfood
	name = "virus plasma"
	color = "#A69DA9" // rgb: 166,157,169
	taste_description = "bitterness"
	taste_mult = 1.5

/datum/reagent/toxin/plasma/plasmavirusfood/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(REM, 0)
	..()


/datum/reagent/toxin/plasma/plasmavirusfood/weak
	name = "weakened virus plasma"
	color = "#CEC3C6" // rgb: 206,195,198
	taste_description = "bitterness"
	taste_mult = 1.5

/datum/reagent/toxin/plasma/plasmavirusfood/weak/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(0.5*REM, 0)
	..()

/datum/reagent/uranium/uraniumvirusfood
	name = "decaying uranium gel"
	color = "#67ADBA" // rgb: 103,173,186
	taste_description = "the inside of a reactor"

/datum/reagent/uranium/uraniumvirusfood/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(2.5*REM, 0)
	..()

/datum/reagent/uranium/uraniumvirusfood/unstable
	name = "unstable uranium gel"
	color = "#2FF2CB" // rgb: 47,242,203
	taste_description = "the inside of a reactor"

/datum/reagent/uranium/uraniumvirusfood/unstable/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(2*REM, 0)
	..()

/datum/reagent/uranium/uraniumvirusfood/stable
	name = "stable uranium gel"
	color = "#04506C" // rgb: 4,80,108
	taste_description = "the inside of a reactor"

/datum/reagent/uranium/uraniumvirusfood/stable/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1.5*REM, 0)
	..()

// Bee chemicals

/datum/reagent/royal_bee_jelly
	name = "royal bee jelly"
	description = "Royal Bee Jelly, if injected into a Queen Space Bee said bee will split into two bees."
	color = "#00ff80"
	taste_description = "strange honey"

/datum/reagent/royal_bee_jelly/on_mob_life(mob/living/carbon/M)
	if(prob(2))
		M.say(pick("Bzzz...","BZZ BZZ","Bzzzzzzzzzzz..."), forced = "royal bee jelly")
	..()

//Misc reagents

/datum/reagent/romerol
	name = "Romerol"
	// the REAL zombie powder
	description = "Romerol is a highly experimental bioterror agent \
		which causes dormant nodules to be etched into the grey matter of \
		the subject. These nodules only become active upon death of the \
		host, upon which, the secondary structures activate and take control \
		of the host body."
	color = "#123524" // RGB (18, 53, 36)
	metabolization_rate = INFINITY
	can_synth = FALSE
	taste_description = "brains"

/datum/reagent/romerol/reaction_mob(mob/living/carbon/human/H, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	// Silently add the zombie infection organ to be activated upon death
	if(!H.getorganslot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/nodamage/ZI = new()
		ZI.Insert(H)
	..()

/datum/reagent/romerol/on_mob_life(mob/living/carbon/human/H)
	if(!H.getorganslot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/nodamage/ZI = new()
		ZI.Insert(H)
	if(holder)
		holder.remove_reagent(type, INFINITY) //By default it slowly disappears.

/datum/reagent/magillitis
	name = "Magillitis"
	description = "An experimental serum which causes rapid muscular growth in Hominidae. Side-affects may include hypertrichosis, violent outbursts, and an unending affinity for bananas."
	reagent_state = LIQUID
	color = "#00f041"

/datum/reagent/magillitis/on_mob_life(mob/living/carbon/M)
	..()
	if((ismonkey(M) || ishuman(M)) && current_cycle >= 10)
		M.gorillize()

/datum/reagent/growthserum
	name = "Growth Serum"
	description = "A commercial chemical designed to help older men in the bedroom."//not really it just makes you a giant
	color = "#ff0000"//strong red. rgb 255, 0, 0
	var/current_size = RESIZE_DEFAULT_SIZE
	taste_description = "bitterness" // apparently what viagra tastes like

/datum/reagent/growthserum/on_mob_metabolize(mob/living/carbon/H)
	var/newsize = current_size
	switch(volume)
		if(0 to 19)
			newsize = 1.25*RESIZE_DEFAULT_SIZE
		if(20 to 49)
			newsize = 1.5*RESIZE_DEFAULT_SIZE
		if(50 to 99)
			newsize = 2*RESIZE_DEFAULT_SIZE
		if(100 to 199)
			newsize = 2.5*RESIZE_DEFAULT_SIZE
		if(200 to INFINITY)
			newsize = 3.5*RESIZE_DEFAULT_SIZE
	H.resize = newsize/current_size
	current_size = newsize
	H.update_transform()
	..()

/datum/reagent/growthserum/on_mob_end_metabolize(mob/living/M)
	M.resize = RESIZE_DEFAULT_SIZE/current_size
	current_size = RESIZE_DEFAULT_SIZE
	M.update_transform()
	..()

/datum/reagent/plastic_polymers //not harmful because it's too big as a polymer chain, where microplastics are small enough to get into your veins
	name = "plastic polymers"
	description = "the liquid components of plastic."
	color = "#f7eded"
	taste_description = "plastic"

/datum/reagent/glitter
	name = "generic glitter"
	description = "if you can see this description, contact a coder."
	color = "#FFFFFF" //pure white
	taste_description = "plastic"
	reagent_state = SOLID
	var/glitter_type = /obj/effect/decal/cleanable/glitter

/datum/reagent/glitter/reaction_turf(turf/T, reac_volume)
	if(!istype(T))
		return
	new glitter_type(T)

/datum/reagent/glitter/pink
	name = "pink glitter"
	description = "pink sparkles that get everywhere"
	color = "#ff8080" //A light pink color
	glitter_type = /obj/effect/decal/cleanable/glitter/pink

/datum/reagent/glitter/white
	name = "white glitter"
	description = "white sparkles that get everywhere"
	glitter_type = /obj/effect/decal/cleanable/glitter/white

/datum/reagent/glitter/blue
	name = "blue glitter"
	description = "blue sparkles that get everywhere"
	color = "#4040FF" //A blueish color
	glitter_type = /obj/effect/decal/cleanable/glitter/blue

/datum/reagent/pax
	name = "Pax"
	description = "A colorless liquid that suppresses violence on the subjects."
	color = "#AAAAAA55"
	taste_description = "water"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/pax/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_PACIFISM, type)

/datum/reagent/pax/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_PACIFISM, type)
	..()

/datum/reagent/bz_metabolites
	name = "BZ metabolites"
	description = "A harmless metabolite of BZ gas"
	color = "#FAFF00"
	taste_description = "acrid cinnamon"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

/datum/reagent/bz_metabolites/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, CHANGELING_HIVEMIND_MUTE, type)
	if(L.mind && L.mind.has_antag_datum(/datum/antagonist/changeling)) //yogs
		to_chat(L, span_userdanger("We have toxins in our blood, our powers are weakening rapidly!")) //yogs

/datum/reagent/bz_metabolites/on_mob_end_metabolize(mob/living/L)
	..()
	REMOVE_TRAIT(L, CHANGELING_HIVEMIND_MUTE, type)
	if(L.mind && L.mind.has_antag_datum(/datum/antagonist/changeling)) //yogs
		to_chat(L, span_boldnotice("Our blood is pure, we can regenerate chemicals again.")) //yogs

/datum/reagent/bz_metabolites/on_mob_life(mob/living/carbon/target)
	if(target.mind)
		var/datum/antagonist/changeling/changeling = target.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			changeling.chem_charges = max(changeling.chem_charges-6, 0)
	return ..()

/datum/reagent/pax/peaceborg
	name = "Synth-Pax"
	description = "A colorless liquid that suppresses violence on the subjects. Cheaper to synthetize, but wears out faster than normal Pax."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/peaceborg/confuse
	name = "Dizzying Solution"
	description = "Makes the target off balance and dizzy."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "dizziness"

/datum/reagent/peaceborg/confuse/on_mob_life(mob/living/carbon/affected_mob)
	affected_mob.adjust_confusion_up_to(3 SECONDS * REM , 5 SECONDS)
	affected_mob.adjust_dizzy_up_to(6 SECONDS * REM, 12 SECONDS)
	if(prob(20))
		to_chat(affected_mob, "You feel confused and disorientated.")
	..()

/datum/reagent/peaceborg/tire
	name = "Tiring Solution"
	description = "An extremely weak stamina-toxin that tires out the target. Completely harmless."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "tiredness"

/datum/reagent/peaceborg/tire/on_mob_life(mob/living/carbon/M)
	var/healthcomp = (100 - M.health)	//DOES NOT ACCOUNT FOR ADMINBUS THINGS THAT MAKE YOU HAVE MORE THAN 200/210 HEALTH, OR SOMETHING OTHER THAN A HUMAN PROCESSING THIS.
	if(M.getStaminaLoss() < (45 - healthcomp))	//At 50 health you would have 200 - 150 health meaning 50 compensation. 60 - 50 = 10, so would only do 10-19 stamina.)
		M.adjustStaminaLoss(10)
		M.clear_stamina_regen()
	if(prob(30))
		to_chat(M, "You should sit down and take a rest...")
	..()

/datum/reagent/tranquility
	name = "Tranquility"
	description = "A highly mutative liquid of unknown origin."
	color = "#9A6750" //RGB: 154, 103, 80
	taste_description = "inner peace"
	can_synth = FALSE

/datum/reagent/tranquility/reaction_mob(mob/living/L, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*permeability)))
		L.ForceContractDisease(new /datum/disease/transformation/gondola(), FALSE, TRUE)


/datum/reagent/spider_extract
	name = "Spider Extract"
	description = "A highly specialized extract coming from the Australicus sector, used to create broodmother spiders."
	color = "#ED2939"
	taste_description = "upside down"
	can_synth = FALSE

/datum/reagent/monkey_powder //monkey powder from TG
	name = "Monkey Powder"
	description = "Just add water!"
	color = "#9C5A19"
	taste_description = "bananas"
	can_synth = TRUE

/datum/reagent/gorilla_powder //modified monkey powder
	name = "Gorilla Powder"
	description = "Just add water!"
	color = "#020202"
	taste_description = "bananas"
	can_synth = TRUE

/datum/reagent/cow_powder
	name = "Cow Powder"
	description = "Just add water!"
	color = "#fffbf1"
	taste_description = "milk"
	can_synth = TRUE

/datum/reagent/chicken_powder
	name = "Chicken Powder"
	description = "Just add water!"
	color = "#ffb94f"
	taste_description = "eggs"
	can_synth = TRUE

/datum/reagent/sheep_powder
	name = "Sheep Powder"
	description = "Just add water!"
	color = "#ffffff"
	taste_description = "wool"
	can_synth = TRUE

/datum/reagent/goat_powder
	name = "Goat Powder"
	description = "Just add water!"
	color = "#8a8782"
	taste_description = "rage"
	can_synth = TRUE

/datum/reagent/mouse_powder
	name = "Mouse Powder"
	description = "Just add water!"
	color = "#8a8782"
	taste_description = "squeaking"
	can_synth = TRUE

/datum/reagent/cellulose
	name = "Cellulose Fibers"
	description = "A crystalline polydextrose polymer, plants swear by this stuff."
	reagent_state = SOLID
	color = "#E6E6DA"
	taste_mult = 0

/datum/reagent/lemoline
	name = "Lemoline"
	description = "Synthesized in off-station laboratories, used in several high-quality medicines."
	color ="#FFF44F"
	taste_description = "lemony"

/datum/reagent/determination
	name = "Determination"
	description = "For when you need to push on a little more. Do NOT allow near plants."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM // 5u (WOUND_DETERMINATION_CRITICAL) will last for ~17 ticks
	self_consuming = TRUE
	/// Whether we've had at least WOUND_DETERMINATION_SEVERE (2.5u) of determination at any given time. No damage slowdown immunity or indication we're having a second wind if it's just a single moderate wound
	var/significant = FALSE

// "Second wind" reagent generated when someone suffers a wound. Epinephrine, adrenaline, and stimulants are all already taken so here we are
/datum/reagent/determination/on_mob_end_metabolize(mob/living/carbon/M)
	if(significant)
		var/stam_crash = 0
		for(var/thing in M.all_wounds)
			var/datum/wound/W = thing
			stam_crash += (W.severity + 1) * 3 // spike of 3 stam damage per wound severity (moderate = 6, severe = 9, critical = 12) when the determination wears off if it was a combat rush
		M.adjustStaminaLoss(stam_crash)
	M.remove_status_effect(STATUS_EFFECT_DETERMINED)
	..()

/datum/reagent/determination/on_mob_life(mob/living/carbon/M)
	if(!significant && volume >= WOUND_DETERMINATION_SEVERE)
		significant = TRUE
		M.apply_status_effect(STATUS_EFFECT_DETERMINED) // in addition to the slight healing, limping cooldowns are divided by 4 during the combat high

	volume = min(volume, WOUND_DETERMINATION_MAX)

	var/heal_amount = 0.25
	if(ishumanbasic(M)) //indomitable human spirit
		heal_amount *= 2

	for(var/thing in M.all_wounds)
		var/datum/wound/W = thing
		var/obj/item/bodypart/wounded_part = W.limb
		if(wounded_part)
			wounded_part.heal_damage(heal_amount, heal_amount)
		M.adjustStaminaLoss(-heal_amount*REM) // the more wounds, the more stamina regen
	..()


/datum/reagent/plaguebacteria
	name = "Yersinia pestis"
	description = "A horrible plague, in a container. It is a TERRIBLE idea to drink this."
	color = "#7CFC00"
	taste_description = "death"
	can_synth = FALSE

/datum/reagent/plaguebacteria/reaction_mob(mob/living/L, methods = TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if((methods & (INGEST|TOUCH|INJECT)) && prob(permeability*100)) //permeability is always 1 by default except with touch and vapor
		L.ForceContractDisease(new /datum/disease/plague(), FALSE, TRUE)

/datum/reagent/liquidsoap
	name = "Liquid soap"
	color = "#ddb772"
	description = "Not much use in this form..."
	taste_description = "soap"

/datum/reagent/microplastics
	name = "Microplastics"
	description = "Finely ground plastics, reduced to microscopic scale. Nearly unable to metabolize in a body, and potentially harmful in the long term."
	color = "#ffffff"
	metabolization_rate = 0.05 * REAGENTS_METABOLISM
	taste_mult = 0
	taste_description = "plastic"

/datum/reagent/microplastics/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.55*REM)
	M.adjustOrganLoss(ORGAN_SLOT_STOMACH, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_APPENDIX, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_EARS, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_EYES, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.25*REM)
	..()
