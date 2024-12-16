//predominantly negative traits

/datum/quirk/badback
	name = "Bad Back"
	desc = "Thanks to your poor posture, backpacks and other bags never sit right on your back. More evenly weighted objects are fine, though."
	icon = "hiking"
	value = -4
	mood_quirk = TRUE
	gain_text = span_danger("Your back REALLY hurts!")
	lose_text = span_notice("Your back feels better.")
	medical_record_text = "Patient scans indicate severe and chronic back pain."

/datum/quirk/badback/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.back && istype(H.back, /obj/item/storage/backpack))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "back_pain", /datum/mood_event/back_pain)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "back_pain")

/datum/quirk/blooddeficiency
	name = "Blood Deficiency"
	desc = "Your body can't produce enough blood to sustain itself."
	icon = "tint"
	value = -4
	gain_text = span_danger("You feel your vigor slowly fading away.")
	lose_text = span_notice("You feel vigorous again.")
	medical_record_text = "Patient requires regular treatment for blood loss due to low production of blood."

/datum/quirk/blooddeficiency/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	species_type = new species_type()
	var/disallowed_trait = (NOBLOOD in species_type.species_traits) // Cant lose blood if your species doesn't have any
	qdel(species_type)

	if(disallowed_trait)
		return "You don't have blood!"
	return ..()

/datum/quirk/blooddeficiency/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return
	else
		if (H.blood_volume > (BLOOD_VOLUME_SAFE(H) - 25)) // just barely survivable without treatment
			H.blood_volume -= 0.275

/datum/quirk/blindness
	name = "Blind"
	desc = "You are completely blind, nothing can counteract this."
	icon = "eye-slash"
	value = -6
	gain_text = span_danger("You can't see anything.")
	lose_text = span_notice("You miraculously gain back your vision.")
	medical_record_text = "Patient has permanent blindness."
	job_blacklist = list("Captain", "Head of Personnel", "Research Director", "Chief Medical Officer", "Chief Engineer", "Head of Security", "Security Officer", "Warden")

/datum/quirk/blindness/add()
	quirk_holder.become_blind(ROUNDSTART_TRAIT)
	quirk_holder.AddComponent(/datum/component/echolocation) //add when echolocation is fixed

/datum/quirk/blindness/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/blindfold/white/B = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(B, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE)) //if you can't put it on the user's eyes, put it in their hands, otherwise put it on their eyes
		H.put_in_hands(B)
	H.regenerate_icons()

/datum/quirk/brainproblems
	name = "Brain Tumor"
	desc = "You have a little friend in your brain that is slowly destroying it. Better bring some mannitol!"
	icon = "head-side-virus"
	value = -6
	gain_text = span_danger("You feel smooth.")
	lose_text = span_notice("You feel wrinkled again.")
	medical_record_text = "Patient has a tumor in their brain that is slowly driving them to brain death."
	var/where = "at your feet"

/datum/quirk/brainproblems/on_process()
	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)

/datum/quirk/brainproblems/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/mannitolpills = new /obj/item/storage/pill_bottle/mannitol/braintumor(get_turf(quirk_holder))
	var/list/slots = list(
		"in your left pocket" = ITEM_SLOT_LPOCKET,
		"in your right pocket" = ITEM_SLOT_RPOCKET,
		"in your backpack" = ITEM_SLOT_BACKPACK
	)
	where = H.equip_in_one_of_slots(mannitolpills, slots, FALSE) || "at your feet"

/datum/quirk/brainproblems/post_add()
	to_chat(quirk_holder, span_boldnotice("There is a pill bottle of mannitol [where]. You're going to need it."))

/datum/quirk/deafness
	name = "Deaf"
	desc = "You are incurably deaf."
	icon = "deaf"
	value = -6
	mob_trait = TRAIT_DEAF
	gain_text = span_danger("You can't hear anything.")
	lose_text = span_notice("You're able to hear again!")
	medical_record_text = "Patient's cochlear nerve is incurably damaged."
	job_blacklist = list("Captain", "Head of Personnel", "Research Director", "Chief Medical Officer", "Chief Engineer", "Head of Security", "Security Officer", "Warden")

/datum/quirk/depression
	name = "Depression"
	desc = "You sometimes just hate life."
	icon = "frown"
	mob_trait = TRAIT_DEPRESSION
	value = -2
	gain_text = span_danger("You start feeling depressed.")
	lose_text = span_notice("You no longer feel depressed.") //if only it were that easy!
	medical_record_text = "Patient has a mild mood disorder, causing them to experience episodes of depression."
	mood_quirk = TRUE

/datum/quirk/heavy_sleeper
	name = "Heavy Sleeper"
	desc = "You sleep like a rock! Whenever you're put to sleep or knocked unconscious, you take a little bit longer to wake up and cant see anything."
	icon = "bed"
	value = -4
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = span_danger("You feel sleepy.")
	lose_text = span_notice("You feel awake again.")
	medical_record_text = "Patient has abnormal sleep study results and is difficult to wake up."

/datum/quirk/hypersensitive
	name = "Hypersensitive"
	desc = "For better or worse, everything seems to affect your mood more than it should."
	icon = "flushed"
	value = -2
	gain_text = span_danger("You seem to make a big deal out of everything.")
	lose_text = span_notice("You don't seem to make a big deal out of everything anymore.")
	mood_quirk = TRUE //yogs
	medical_record_text = "Patient demonstrates a high level of emotional volatility."

/datum/quirk/hypersensitive/add()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier += 0.5

/datum/quirk/hypersensitive/remove()
	if(quirk_holder)
		var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
		if(mood)
			mood.mood_modifier -= 0.5

/datum/quirk/light_drinker
	name = "Light Drinker"
	desc = "You just can't handle your drinks and get drunk very quickly."
	icon = "cocktail"
	value = -2
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = span_notice("Just the thought of drinking alcohol makes your head spin.")
	lose_text = span_danger("You're no longer severely affected by alcohol.")
	medical_record_text = "Patient demonstrates a low tolerance for alcohol. (Wimp)"

/datum/quirk/light_drinker/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	species_type = new species_type()
	var/disallowed_trait = (NOMOUTH in species_type.species_traits) || !(initial(species_type.inherent_biotypes) & MOB_ORGANIC)// Cant drink or process alcohol
	qdel(species_type)
	if(disallowed_trait)
		return "You don't have the ability to consume alcohol!"
	return FALSE

/datum/quirk/nearsighted //t. errorage
	name = "Nearsighted"
	desc = "You are nearsighted without prescription glasses, but spawn with a pair."
	icon = "glasses"
	value = -2
	gain_text = span_danger("Things far away from you start looking blurry.")
	lose_text = span_notice("You start seeing faraway things normally again.")
	medical_record_text = "Patient requires prescription glasses in order to counteract nearsightedness."

/datum/quirk/nearsighted/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/regular/glasses = new(get_turf(H))
	H.put_in_hands(glasses)
	H.equip_to_slot(glasses, ITEM_SLOT_EYES)
	H.regenerate_icons() //this is to remove the inhand icon, which persists even if it's not in their hands

/datum/quirk/nyctophobia
	name = "Nyctophobia"
	desc = "As far as you can remember, you've always been afraid of the dark. While in the dark without a light source, you instinctually act careful, and constantly feel a sense of dread."
	icon = "lightbulb"
	value = -2
	medical_record_text = "Patient demonstrates a fear of the dark. (Seriously?)"

/datum/quirk/nyctophobia/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(isshadowperson(H) || is_team_darkspawn(H))
		return //we're tied with the dark, so we don't get scared of it; don't cleanse outright to avoid cheese
	var/turf/T = get_turf(quirk_holder)
	var/lums = T.get_lumcount()
	if(istype(T.loc, /area/shuttle))
		return
	if(lums <= 0.2)
		if(quirk_holder.m_intent == MOVE_INTENT_RUN)
			to_chat(quirk_holder, span_warning("Easy, easy, take it slow... you're in the dark..."))
			quirk_holder.toggle_move_intent()
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "nyctophobia", /datum/mood_event/nyctophobia)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")

/datum/quirk/nonviolent
	name = "Pacifist"
	desc = "The thought of violence makes you sick. So much so, in fact, that you can't hurt anyone."
	icon = "peace"
	value = -4
	mob_trait = TRAIT_PACIFISM
	gain_text = span_danger("You feel repulsed by the thought of violence!")
	lose_text = span_notice("You think you can defend yourself again.")
	medical_record_text = "Patient is unusually pacifistic and cannot bring themselves to cause physical harm."
	job_blacklist = list("Head of Security", "Security Officer", "Warden")


/datum/quirk/paraplegic
	name = "Paraplegic"
	desc = "Your legs do not function. Nothing will ever fix this. But hey, free wheelchair!"
	icon = "wheelchair"
	value = -7
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Patient has an untreatable impairment in motor function in the lower extremities."
	job_blacklist = list("Head of Security", "Security Officer")

/datum/quirk/paraplegic/add()
	var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/on_spawn()
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/T = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in T

	var/obj/vehicle/ridden/wheelchair/wheels = new(T)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.

	for(var/obj/item/I in T)
		if(I.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(I)


/datum/quirk/poor_aim
	name = "Poor Aim"
	desc = "You're terrible with guns and can't line up a straight shot to save your life. Dual-wielding is right out."
	icon = "bullseye"
	value = -2
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "Patient possesses a strong tremor in both hands."

/datum/quirk/prosopagnosia
	name = "Prosopagnosia"
	desc = "You have a mental disorder that prevents you from being able to recognize faces at all."
	icon = "user-secret"
	value = -2
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Patient suffers from prosopagnosia and cannot recognize faces."

/datum/quirk/prosthetic_limb
	name = "Prosthetic Limb"
	desc = "An accident caused you to lose one of your limbs. Because of this, you now have a random prosthetic!"
	icon = "tg-prosthetic-leg"
	value = -2
	var/slot_string = "limb"
	var/specific = null
	medical_record_text = "During physical examination, patient was found to have a prosthetic limb."

/datum/quirk/prosthetic_limb/on_spawn()
	var/limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	if(specific)
		limb_slot = specific

	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
	var/obj/item/bodypart/prosthetic
	switch(limb_slot)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
			slot_string = "left arm"
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/robot/surplus(quirk_holder)
			slot_string = "right arm"
		if(BODY_ZONE_L_LEG)
			var/obj/item/bodypart/l_leg/L = H.get_bodypart(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/robot/surplus(quirk_holder)
			prosthetic.set_digitigrade(L.use_digitigrade)
			slot_string = "left leg"
		if(BODY_ZONE_R_LEG)
			var/obj/item/bodypart/r_leg/R = H.get_bodypart(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/robot/surplus(quirk_holder)
			prosthetic.set_digitigrade(R.use_digitigrade)
			slot_string = "right leg"
	prosthetic.replace_limb(H)
	qdel(old_part)
	H.regenerate_icons()

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Your [slot_string] has been replaced with a surplus prosthetic. It is fragile and will easily come apart under duress. Additionally, \
	you need to use a welding tool and cables to repair it, instead of bruise packs and ointment.</span>")

/datum/quirk/prosthetic_limb/left_arm
	name = "Prosthetic Limb (Left Arm)"
	desc = "An accident caused you to lose your left arm. Because of this, it's replaced with a prosthetic!"
	specific = BODY_ZONE_L_ARM

/datum/quirk/prosthetic_limb/right_arm
	name = "Prosthetic Limb (Right Arm)"
	desc = "An accident caused you to lose your right arm. Because of this, it's replaced with a prosthetic!"
	specific = BODY_ZONE_R_ARM

/datum/quirk/prosthetic_limb/left_leg
	name = "Prosthetic Limb (Left Leg)"
	desc = "An accident caused you to lose your left leg. Because of this, it's replaced with a prosthetic!"
	specific = BODY_ZONE_L_LEG

/datum/quirk/prosthetic_limb/right_leg
	name = "Prosthetic Limb (Right Leg)"
	desc = "An accident caused you to lose your right leg. Because of this, it's replaced with a prosthetic!"
	specific = BODY_ZONE_R_LEG

/datum/quirk/insanity
	name = "Reality Dissociation Syndrome"
	desc = "You suffer from a severe disorder that causes very vivid hallucinations. Mindbreaker toxin can suppress its effects, and you are immune to mindbreaker's hallucinogenic properties. THIS IS NOT A LICENSE TO GRIEF."
	icon = "grin-tongue-wink"
	value = -2
	//no mob trait because it's handled uniquely
	gain_text = null //handled by trauma
	lose_text = null
	var/where
	medical_record_text = "Patient suffers from acute Reality Dissociation Syndrome and experiences vivid hallucinations."

/datum/quirk/insanity/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	var/disallowed_trait = !(initial(species_type.inherent_biotypes) & ALL_NON_ROBOTIC)

	if(disallowed_trait)
		return "You are not illogical."
	return ..()

/datum/quirk/insanity/add()
	var/datum/brain_trauma/mild/reality_dissociation/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/insanity/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/sanitypills = new /obj/item/storage/pill_bottle/gummies/mindbreaker(get_turf(quirk_holder))
	var/list/slots = list(
		"in your left pocket" = ITEM_SLOT_LPOCKET,
		"in your right pocket" = ITEM_SLOT_RPOCKET,
		"in your backpack" = ITEM_SLOT_BACKPACK
	)
	where = H.equip_in_one_of_slots(sanitypills, slots, FALSE) || "at your feet"

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, span_boldnotice("There is a bottle of mindbreaker gummy bears [where]. You're going to need it."))
	to_chat(quirk_holder, span_boldwarning("Please note that your dissociation syndrome does NOT give you the right to attack people or otherwise cause any interference to \
	the round. You are not an antagonist, and the rules will treat you the same as other crewmembers."))

/datum/quirk/social_anxiety
	name = "Social Anxiety"
	desc = "Talking to people is very difficult for you, and you often stutter or even lock up."
	icon = "comment-slash"
	value = -2
	gain_text = span_danger("You start worrying about what you're saying.")
	lose_text = span_notice("You feel easier about talking again.") //if only it were that easy!
	medical_record_text = "Patient is usually anxious in social encounters and prefers to avoid them."
	job_blacklist = list("Captain", "Head of Personnel", "Research Director", "Chief Medical Officer", "Chief Engineer", "Head of Security", "Security Officer", "Warden")
	var/dumb_thing = TRUE
	mob_trait = TRAIT_ANXIOUS

/datum/quirk/social_anxiety/add()
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, PROC_REF(eye_contact))
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, PROC_REF(looks_at_floor))
	RegisterSignal(quirk_holder, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE, COMSIG_MOB_SAY))

/datum/quirk/social_anxiety/proc/handle_speech(datum/source, list/speech_args)
	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	var/moodmod
	if(mood)
		moodmod = (1+0.02*(50-(max(50, mood.mood_level*(7-mood.sanity_level))))) //low sanity levels are better, they max at 6
	else
		moodmod = (1+0.02*(50-(max(50, 0.1*quirk_holder.nutrition))))
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()
		var/mob/living/carbon/human/quirker = quirk_holder
		for(var/word in message_split)
			if(prob(max(5,(nearby_people*12.5*moodmod))) && word != message_split[1]) //Minimum 1/20 chance of filler
				new_message += pick("uh,","erm,","um,")
				if(prob(min(5,(0.05*(nearby_people*12.5)*moodmod)))) //Max 1 in 20 chance of cutoff after a succesful filler roll, for 50% odds in a 15 word sentence
					quirker.silent = max(3, quirker.silent)
					to_chat(quirker, span_danger("You feel self-conscious and stop talking. You need a moment to recover!"))
					break
			if(prob(max(5,(nearby_people*12.5*moodmod)))) //Minimum 1/20 chance of stutter
				// Add a short stutter, THEN treat our word
				quirker.adjust_stutter(0.5 SECONDS)
				new_message += quirker.treat_message(word)

			else
				new_message += word

		message = jointext(new_message, " ")
	var/mob/living/carbon/human/quirker = quirk_holder
	if(prob(min(50,(0.50*(nearby_people*12.5)*moodmod)))) //Max 50% chance of not talking
		if(dumb_thing)
			to_chat(quirker, span_userdanger("You think of a dumb thing you said a long time ago and scream internally."))
			dumb_thing = FALSE //only once per life
			if(prob(1))
				new/obj/item/reagent_containers/food/snacks/spaghetti/pastatomato(get_turf(quirker)) //now that's what I call spaghetti code
		else
			to_chat(quirk_holder, span_warning("You think that wouldn't add much to the conversation and decide not to say it."))
			if(prob(min(25,(0.25*(nearby_people*12.75)*moodmod)))) //Max 25% chance of silence stacks after succesful not talking roll
				to_chat(quirker, span_danger("You retreat into yourself. You <i>really</i> don't feel up to talking."))
				quirker.silent = max(5, quirker.silent)
		speech_args[SPEECH_MESSAGE] = pick("Uh.","Erm.","Um.")
	else
		speech_args[SPEECH_MESSAGE] = message

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_smallnotice("You make eye contact with [A].")), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	var/mob/living/carbon/human/quirker = quirk_holder
	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "You make eye contact with [other_mob], "
	else
		msg = "[other_mob] makes eye contact with you, "

	switch(rand(1,3))
		if(1)
			quirker.adjust_jitter(5 SECONDS)
			msg += "causing you to start fidgeting!"
		if(2)
			quirker.adjust_stutter(3 SECONDS)
			msg += "causing you to start stuttering!"
		if(3)
			quirker.Stun(2 SECONDS)
			msg += "causing you to freeze up!"

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_userdanger("[msg]")), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "Sometimes eye contact makes me so nervous..."
	mood_change = -5
	timeout = 3 MINUTES

//If you want to make some kind of junkie variant, just extend this quirk.
/datum/quirk/junkie
	name = "Junkie"
	desc = "You can't get enough of hard drugs."
	icon = "pills"
	value = -4
	gain_text = span_danger("You suddenly feel the craving for drugs.")
	lose_text = span_notice("You feel like you should kick your drug habit.")
	medical_record_text = "Patient has a history of hard drugs."
	var/drug_list = list(/datum/reagent/drug/crank, /datum/reagent/drug/krokodil, /datum/reagent/medicine/morphine, /datum/reagent/drug/happiness, /datum/reagent/drug/methamphetamine, /datum/reagent/drug/ketamine) //List of possible IDs
	var/reagent_id //ID picked from list
	var/datum/reagent/reagent_type //If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance
	var/where_drug
	var/obj/item/drug_container_type //If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/obj/item/drug_instance
	var/where_accessory
	var/obj/item/accessory_type //If this is null, it won't be spawned.
	var/obj/item/accessory_instance
	var/tick_counter = 0
	var/junkie_warning = null

/datum/quirk/junkie/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	reagent_id = pick(drug_list)
	if (!reagent_type)
		var/datum/reagent/prot_holder = GLOB.chemical_reagents_list[reagent_id]
		reagent_type = prot_holder.type
	reagent_instance = new reagent_type()
	H.reagents.addiction_list.Add(reagent_instance)
	if (!junkie_warning)
		junkie_warning = ("You thought you kicked it, but you suddenly feel like you need [reagent_instance.name] again...")
	var/current_turf = get_turf(quirk_holder)
	if (!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle
	drug_instance = new drug_container_type(current_turf)
	if (istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/P = new(drug_instance)
			P.icon_state = pill_state
			P.reagents.add_reagent(reagent_id, 1)

	if (accessory_type)
		accessory_instance = new accessory_type(current_turf)
	var/list/slots = list(
		"in your left pocket" = ITEM_SLOT_LPOCKET,
		"in your right pocket" = ITEM_SLOT_RPOCKET,
		"in your backpack" = ITEM_SLOT_BACKPACK
	)
	where_drug = H.equip_in_one_of_slots(drug_instance, slots, FALSE) || "at your feet"
	if (accessory_instance)
		where_accessory = H.equip_in_one_of_slots(accessory_instance, slots, FALSE) || "at your feet"
	announce_drugs()

/datum/quirk/junkie/post_add()
	if(where_drug == "in your backpack" || where_accessory == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

/datum/quirk/junkie/proc/announce_drugs()
	to_chat(quirk_holder, span_boldnotice("There is a [drug_instance.name] of [reagent_instance.name] [where_drug]. Better hope you don't run out..."))

/datum/quirk/junkie/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if (tick_counter == 60) //Halfassed optimization, increase this if there's slowdown due to this quirk
		var/in_list = FALSE
		for (var/datum/reagent/entry in H.reagents.addiction_list)
			if(istype(entry, reagent_type))
				in_list = TRUE
				break
		if(!in_list)
			H.reagents.addiction_list += reagent_instance
			reagent_instance.addiction_stage = 0
			to_chat(quirk_holder, span_danger("[junkie_warning]"))
		tick_counter = 0
	else
		++tick_counter

/datum/quirk/junkie/clone_data()
	return reagent_type

/datum/quirk/junkie/on_clone(data)
	var/mob/living/carbon/human/H = quirk_holder
	reagent_type = data
	reagent_instance = new reagent_type()
	H.reagents.addiction_list.Add(reagent_instance)

/datum/quirk/junkie/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	var/disallowed_trait = !(initial(species_type.inherent_biotypes) & MOB_ORGANIC) //if you can't process organic chems you couldn't get addicted in the first place

	if(disallowed_trait)
		return "You don't process normal chemicals!"
	return FALSE

/datum/quirk/junkie/smoker
	name = "Smoker"
	desc = "Sometimes you just really want a smoke. Probably not great for your lungs."
	icon = "smoking"
	value = -2
	mood_quirk = TRUE
	gain_text = span_danger("You could really go for a smoke right about now.")
	lose_text = span_notice("You feel like you should quit smoking.")
	medical_record_text = "Patient is a current smoker."
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale

/datum/quirk/junkie/smoker/on_spawn()
	drug_container_type = pick(/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/fancy/cigarettes/cigpack_midori,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
		/obj/item/storage/fancy/cigarettes/cigpack_carp,
		/obj/item/storage/fancy/cigarettes/cigars,
		/obj/item/storage/fancy/cigarettes/cigars/havana)
	. = ..()

/datum/quirk/junkie/smoker/announce_drugs()
	to_chat(quirk_holder, span_boldnotice("There is a [drug_instance.name] [where_drug], and a lighter [where_accessory]. Make sure you get your favorite brand when you run out."))


/datum/quirk/junkie/smoker/on_process()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_MASK)
	if (istype(I, /obj/item/clothing/mask/cigarette))
		var/obj/item/storage/fancy/cigarettes/C = drug_instance
		if(istype(I, C.spawn_type))
			SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "wrong_cigs")
			return
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "wrong_cigs", /datum/mood_event/wrong_brand)

/datum/quirk/junkie/drunkard
	name = "Drunkard"
	desc = "In space there's no such thing as day drinking."
	icon = "beer"
	value = -2
	mood_quirk = TRUE
	gain_text = span_danger("You could really go for a stiff drink right about now.")
	lose_text = span_notice("You no longer feel dependent on alcohol to function.")
	medical_record_text = "Patient is known to be dependent on alcohol."
	reagent_type = /datum/reagent/consumable/ethanol
	junkie_warning = "You suddenly feel like you need another drink..."

/datum/quirk/junkie/drunkard/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.reagents.add_reagent(/datum/reagent/consumable/ethanol, 20)
	drug_container_type = pick(/obj/item/reagent_containers/food/drinks/beer/light/plastic)
	. = ..()

/datum/quirk/junkie/caffeine
	name = "Caffeine Addict"
	desc = "Whether it's punching through drywall while on Grey Bull, or downing 100 cups of coffee in a day, you can't get enough caffeine."
	icon = "mug-hot"
	value = -2
	mood_quirk = TRUE
	gain_text = span_danger("You could really use some caffeine right about now.")
	lose_text = span_notice("You no longer feel dependent on caffeine to function.")
	medical_record_text = "Patient is known to be dependent on caffeine."
	reagent_type = /datum/reagent/drug/caffeine
	junkie_warning = "You suddenly feel like you need some caffeine..."
	var/list/weighted_items = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/icedcoffee = 200,
		/obj/item/reagent_containers/food/drinks/coffee = 100, //who just carries around a styrofoam cup of coffee in their backpack
		/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 100,
		/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 100,
		/obj/item/reagent_containers/food/drinks/mug/tea = 50,
		/obj/item/reagent_containers/food/drinks/soda_cans/thirteenloko = 1, //super rare because it's dangerous
		/obj/item/reagent_containers/food/drinks/bottle/nukacola = 1 //super rare to get nuka cola because it's actually kinda bad (irradiates you)
	)

/datum/quirk/junkie/caffeine/on_spawn()
	drug_container_type = pickweight(weighted_items)
	return ..()

/datum/quirk/unstable
	name = "Unstable"
	desc = "Due to past troubles, you are unable to recover your sanity if you lose it. Be very careful managing your mood!"
	icon = "angry"
	value = -4
	mood_quirk = TRUE
	mob_trait = TRAIT_UNSTABLE
	gain_text = span_danger("There's a lot on your mind right now.")
	lose_text = span_notice("Your mind finally feels calm.")
	medical_record_text = "Patient's mind is in a vulnerable state, and cannot recover from traumatic events."

/datum/quirk/allergic
	name = "Allergic Reaction"
	desc = "You have had an allergic reaction to medicine in the past. Better stay away from it!"
	icon = "prescription-bottle"
	value = -2
	gain_text = span_danger("You remember your allergic reaction to a common medicine.")
	lose_text = span_notice("You no longer are allergic to medicine.")

	var/allergy_chem_list = list(	
		/datum/reagent/medicine/inacusiate,
		/datum/reagent/medicine/silver_sulfadiazine,
		/datum/reagent/medicine/styptic_powder,
		/datum/reagent/medicine/omnizine,
		/datum/reagent/medicine/oculine,
		/datum/reagent/medicine/neurine,
		/datum/reagent/medicine/bicaridine,
		/datum/reagent/medicine/kelotane,
		/datum/reagent/medicine/c2/libital,
		/datum/reagent/medicine/c2/aiuri,
		/datum/reagent/medicine/atropine,
		/datum/reagent/medicine/pen_acid,
		/datum/reagent/medicine/salbutamol,

		/datum/reagent/drug/caffeine, //get fucked

		/datum/reagent/medicine/mutadone,
		/datum/reagent/medicine/charcoal, //this isn't about realism, it's about sending a message
		/datum/reagent/medicine/mannitol, //i am a spiteful god and my creations will suffer
		/datum/reagent/medicine/cryoxadone, //mortals shall look to the heavens and cry "why must you subject us to this cruel torment"
		/datum/reagent/medicine/synthflesh, //i shall look upon at them and laugh
		/datum/reagent/water //FOR I AM THE GOD OF THIS WORLD AND MY WORD IS LAW
		)

	/// Allergy reagent
	var/reagent_id
	COOLDOWN_DECLARE(allergies)
	/// how long allergies last after getting rid of the allergen
	var/cooldown_duration = 10 SECONDS 
	/// Wether the person is experiencing anaphylatic shock or not
	COOLDOWN_DECLARE(anaphylaxis)
	/// How long anaphylactic shock lasts
	var/shock_duration = 15 SECONDS

/datum/quirk/allergic/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	var/disallowed_trait = !(initial(species_type.inherent_biotypes) & MOB_ORGANIC)

	if(disallowed_trait)
		return "You don't process normal chemicals!"
	return FALSE

/datum/quirk/allergic/on_spawn()
	reagent_id = pick(allergy_chem_list)
	var/datum/reagent/allergy = GLOB.chemical_reagents_list[reagent_id]
	to_chat(quirk_holder, span_danger("You remember you are allergic to [allergy.name]."))
	quirk_holder.allergies += allergy
	medical_record_text = "Patient has a severe allergic reaction to [allergy.name]."

/datum/quirk/allergic/on_process()
	var/mob/living/carbon/H = quirk_holder

	if(H.stat == DEAD)
		return

	var/datum/reagent/allergy = GLOB.chemical_reagents_list[reagent_id]

	if(H.reagents.has_reagent(reagent_id)) //check if there are chems
		if(COOLDOWN_FINISHED(src, allergies)) //if it wasn't ongoing, give a prompt
			to_chat(quirk_holder, span_userdanger("You forgot you were allergic to [allergy.name]!"))
		COOLDOWN_START(src, allergies, cooldown_duration) //start it, or refresh the ongoing

	if(!COOLDOWN_FINISHED(src, allergies))
		H.emote("choke")
		H.losebreath += 3
		H.adjust_eye_blur(2)
		H.adjustStaminaLoss(4)
		H.clear_stamina_regen()
		H.silent = max(H.silent, 3) //can't speak, your throat is swollen shut

	else if(!COOLDOWN_FINISHED(src, allergies)) //if the cooldown is going
		//external indicator that it's happening
		if(prob(50)) 
			switch(rand(0, 2))
				if(0)
					H.emote("cough")
				if(1)
					H.emote("sneeze")
				if(2)
					H.emote("choke")

		if(prob(50))
			switch(rand(0, 10)) //negative effect
				if(0 to 5)
					to_chat(H, span_danger("Your eyes swell up and you can barely see!"))
					H.adjust_eye_blur(3)
				if(6 to 9) //nice
					to_chat(H, span_danger("You scratch at an itch."))
					H.adjustBruteLoss(2)
				if(10)
					to_chat(H, span_userdanger("You go into anaphylactic shock!"))
					COOLDOWN_START(src, allergies, shock_duration)

/datum/quirk/kleptomaniac
	name = "Kleptomaniac"
	desc = "You have an uncontrollable urge to pick up things you see. Even things that don't belong to you."
	icon = "hands-holding-circle"
	value = -2
	gain_text = span_danger("You have an unmistakeable urge to grab nearby objects.")
	lose_text = span_notice("You no longer feel the urge to steal.")
	medical_record_text = "Patient has an uncontrollable urge to steal."

/datum/quirk/kleptomaniac/on_process()
	if(prob(3))
		var/mob/living/carbon/H = quirk_holder
		var/obj/item/I = locate(/obj/item/) in oview(1, H)
		if(!I || I.anchored || H.incapacitated() || !I.Adjacent(H))
			return
		if(isliving(quirk_holder))
			var/mob/living/L = quirk_holder
			if(!(L.mobility_flags & MOBILITY_PICKUP))
				return
		if(!H.get_active_held_item())
			to_chat(quirk_holder, span_danger("You can't keep your eyes off [I.name]."))
			H.UnarmedAttack(I, TRUE, list())

/datum/quirk/ineloquent
	name = "Ineloquent"
	desc = "Thinking big words makes brain go hurt."
	icon = "comments"
	value = -2
	human_only = TRUE
	gain_text = "You feel your vocabulary slipping away."
	lose_text = "You regrasp the full extent of your linguistic prowess."
	medical_record_text = "Patient is affected by partial loss of speech leading to a reduced vocabulary."
	job_blacklist = list("Captain", "Head of Personnel", "Research Director", "Chief Medical Officer", "Chief Engineer", "Head of Security", "Security Officer", "Warden")

/datum/quirk/ineloquent/add()
	var/datum/brain_trauma/mild/expressive_aphasia/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/hemophilia //basically permanent weak heparin
	name = "Hemophiliac"
	desc = "You can't naturally clot bleeding wounds and bleed much more from them than most people, making even small cuts possibly life threatening."
	icon = "droplet"
	value = -4
	mob_trait = TRAIT_BLOODY_MESS_LITE
	gain_text = span_danger("You feel like your blood is thin.")
	lose_text = span_notice("You feel like your blood is of normal thickness once more.")
	medical_record_text = "Patient appears unable to naturally form blood clots."

/datum/quirk/hemophilia/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	species_type = new species_type()
	var/disallowed_trait = (NOBLOOD in species_type.species_traits)
	qdel(species_type)

	if(disallowed_trait)
		return "You can't bleed."
	return ..()

/datum/quirk/brain_damage
	name = "Brain Damage"
	desc = "The shuttle ride was a bit bumpy to the station."
	icon = "brain"
	value = -6
	gain_text = span_danger("Your head hurts.")
	lose_text = span_notice("Your head feels good again.")
	medical_record_text = "Patient appears to have brain damage."
	job_blacklist = list("Captain", "Head of Personnel", "Research Director", "Chief Medical Officer", "Chief Engineer", "Head of Security", "Security Officer", "Warden")

/datum/quirk/brain_damage/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/brain_trauma/badtimes = list(BRAIN_TRAUMA_MILD, BRAIN_TRAUMA_SEVERE)
	var/amount = 0 // Pray you dont get fucked
	amount = rand(1, 3)

	for(var/i = 0 to amount)
		H.gain_trauma_type(pick(badtimes), TRAUMA_RESILIENCE_ABSOLUTE) // Mr bones wild rides takes no breaks

/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	icon = "palette"
	value = -4
	mob_trait = TRAIT_COLORBLIND
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, span_boldannounce("Mmm. Nothing's ever clear on this station. It's all shades of gray..."))
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	if(quirk_holder)
		quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/nomail
	name = "Loser"
	desc = "You are a complete nobody, no one would ever send you anything worthwhile in the mail."
	icon = "envelopes-bulk"
	value = -1
	mob_trait = TRAIT_BADMAIL

/datum/quirk/telomeres_short
	name = "Short Telomeres"
	desc = "Due to hundreds of cloning cycles, your DNA's telomeres are dangerously shortened. Your DNA can't support cloning without expensive DNA restructuring, and what's worse- you work for Nanotrasen."
	icon = "magnifying-glass-minus"
	value = -2
	medical_record_text = "DNA analysis indicates that the patient's DNA telomeres are artificially shortened from previous cloner usage."

/datum/quirk/telomeres_short/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	species_type = new species_type()
	var/no_dna = (NO_DNA_COPY in  species_type.species_traits) //Can't pick if you have no DNA bruv.
	var/no_clone = (TRAIT_NOCLONE in species_type.inherent_traits)
	qdel(species_type)
	if(no_dna)
		return "You have no DNA!"
	else if(no_clone)
		return "Your species cannot be cloned!"
	return FALSE

//we apply it directly to the dna so it carries over to the brain mob if someone tries to clone the brain
/datum/quirk/telomeres_short/New(mob/living/quirk_mob, spawn_effects, no_init)
	. = ..()
	var/datum/dna/holder = quirk_holder?.has_dna()
	if(holder)
		holder.features |= TRAIT_SHORT_TELOMERES

/datum/quirk/telomeres_short/Destroy()
	. = ..()
	var/datum/dna/holder = quirk_holder?.has_dna()
	if(holder)
		holder.features -= TRAIT_SHORT_TELOMERES

/datum/quirk/telomeres_short/transfer_mob(mob/living/to_mob)
	. = ..()
	var/datum/dna/holder = quirk_holder?.has_dna()
	if(holder)
		holder.features -= TRAIT_SHORT_TELOMERES
	holder = to_mob?.has_dna()
	if(holder)
		holder.features |= TRAIT_SHORT_TELOMERES

/datum/quirk/body_purist
	name = "Body Purist"
	desc = "You believe your body is a temple and its natural form is an embodiment of perfection. Accordingly, you despise the idea of ever augmenting it with unnatural parts, cybernetic, prosthetic, or anything like it."
	icon = "person-rays"
	value = -2
	mood_quirk = TRUE
	gain_text = span_danger("You now begin to hate the idea of having cybernetic implants.")
	lose_text = span_notice("Maybe cybernetics aren't so bad. You now feel okay with augmentations and prosthetics.")
	medical_record_text = "This patient has disclosed an extreme hatred for unnatural bodyparts and augmentations."
	var/cybernetics_level = 0

/datum/quirk/body_purist/add()
	check_cybernetics()
	RegisterSignal(quirk_holder, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(on_organ_gain))
	RegisterSignal(quirk_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_organ_lose))
	RegisterSignal(quirk_holder, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(on_limb_gain))
	RegisterSignal(quirk_holder, COMSIG_CARBON_REMOVE_LIMB, PROC_REF(on_limb_lose))

/datum/quirk/body_purist/remove()
	UnregisterSignal(quirk_holder, list(
		COMSIG_CARBON_GAIN_ORGAN,
		COMSIG_CARBON_LOSE_ORGAN,
		COMSIG_CARBON_ATTACH_LIMB,
		COMSIG_CARBON_REMOVE_LIMB,
	))
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "body_purist")

/datum/quirk/body_purist/proc/check_cybernetics()
	var/mob/living/carbon/owner = quirk_holder
	if(!istype(owner))
		return
	for(var/obj/item/bodypart/limb as anything in owner.bodyparts)
		if(!limb.is_organic_limb())
			cybernetics_level++
	for(var/obj/item/organ/organ as anything in owner.internal_organs)
		if(organ.organ_flags & ORGAN_SYNTHETIC || organ.status == ORGAN_ROBOTIC)
			cybernetics_level++
	update_mood()

/datum/quirk/body_purist/proc/update_mood()
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "body_purist")
	if(cybernetics_level)
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "body_purist", /datum/mood_event/body_purist, -cybernetics_level * 10)

/datum/quirk/body_purist/proc/on_organ_gain(datum/source, obj/item/organ/new_organ, special)
	SIGNAL_HANDLER
	if(new_organ.organ_flags & ORGAN_SYNTHETIC || new_organ.status == ORGAN_ROBOTIC)
		cybernetics_level++
		update_mood()

/datum/quirk/body_purist/proc/on_organ_lose(datum/source, obj/item/organ/old_organ, special)
	SIGNAL_HANDLER
	if(old_organ.organ_flags & ORGAN_SYNTHETIC || old_organ.status == ORGAN_ROBOTIC)
		cybernetics_level--
		update_mood()

/datum/quirk/body_purist/proc/on_limb_gain(datum/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER
	if(!new_limb.is_organic_limb())
		cybernetics_level++
		update_mood()

/datum/quirk/body_purist/proc/on_limb_lose(datum/source, obj/item/bodypart/old_limb, special)
	SIGNAL_HANDLER
	if(!old_limb.is_organic_limb())
		cybernetics_level--
		update_mood()

/datum/quirk/lactose_intolerance
	name = "Lactose Intolerance"
	desc = "You don't tolerate milk or other dairy products."
	icon = "utensils"
	gain_text = span_danger("You suddenly feel intolerant towards milk.")
	lose_text = span_notice("You feel like you could drink milk again.")
	medical_record_text = "Patient is lactose intolerant."
	value = -1

/datum/quirk/lactose_intolerance/check_quirk(datum/preferences/prefs)
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	if(initial(species_type.toxic_food) & DAIRY)
		return "You're already lactose intolerant!"
	species_type = new species_type()
	if((TRAIT_POWERHUNGRY in species_type.inherent_traits) || (TRAIT_NOHUNGER in species_type.inherent_traits))
		return "You don't eat food!"
	return FALSE

/datum/quirk/lactose_intolerance/add()
	if(!ishuman(quirk_holder))
		return
	var/mob/living/carbon/carbon_holder = quirk_holder
	var/datum/species/spec = carbon_holder.dna.species
	spec.toxic_food |= DAIRY
	RegisterSignal(carbon_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/lactose_intolerance/remove()
	UnregisterSignal(quirk_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/lactose_intolerance/proc/on_species_gain(datum/source, datum/species/new_species)
	new_species.toxic_food |= DAIRY // no escape from your terrible fate
