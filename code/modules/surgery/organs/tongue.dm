/obj/item/organ/tongue
	name = "tongue"
	desc = "A fleshy muscle mostly used for lying."
	icon_state = "tonguenormal"
	visual = FALSE
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("licked", "slobbered", "slapped", "frenched", "tongued")
	var/list/languages_possible
	var/say_mod = null
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = TRUE // set to TRUE now because otherwise default tongues can't be honked. Not even sure why this would ever be set to false since it doesn't do anything.
	var/honked = FALSE // This tongue has a bike horn jammed inside of it and will honk every time something is spoken.
	var/honkednoise = 'sound/items/bikehorn.ogg'
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/ratvar,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/sylvan,
		/datum/language/bonespeak,
		/datum/language/mothian,
		/datum/language/etherean,
		/datum/language/japanese,
		/datum/language/machine, //yogs
		/datum/language/darkspawn, //also yogs
		/datum/language/encrypted,
		/datum/language/felinid,
		/datum/language/english,
		/datum/language/french
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/update_icon()
	. = ..()
	if(honked) // This tongue has a bike horn inside of it. Let's draw it
		add_overlay("honked")

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)
	if(honked) // you have a bike horn inside of your tongue. Time to honk
		playsound(source, honkednoise, 50, TRUE)
		say_mod = "honks" // overrides original tongue here 

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech, override = TRUE)
	M.UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY)
	M.RegisterSignal(M, COMSIG_MOB_SAY, /mob/living/carbon/.proc/handle_tongueless_speech)

/obj/item/organ/tongue/could_speak_language(language)
	return is_type_in_typecache(language, languages_possible)

/obj/item/organ/tongue/honked // allows admins to spawn honked tongues from the item menu vs having to change the variable.
	honked = TRUE

/obj/item/organ/tongue/honked/boowomp
	honkednoise = 'yogstation/sound/items/boowomp.ogg'

/obj/item/organ/tongue/Initialize() // this only exists to make sure the spawned tongue has a horn inside of it visually
	. = ..()
	update_icon()

/obj/item/organ/tongue/examine(mob/user)
	. = ..()
	if(honked)
		. += "It seems to have a bikehorn shoved inside, HONK!"

/obj/item/organ/tongue/lizard
	name = "forked tongue"
	desc = "A thin and long muscle typically found in reptilian races, apparently moonlights as a nose."
	icon_state = "tonguelizard"
	say_mod = "hisses"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	modifies_speech = TRUE

/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	..()
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = "A freakish looking meat tube that apparently can take in liquids."
	icon_state = "tonguefly"
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	..()
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/abductor
	name = "superlingual matrix"
	desc = "A mysterious structure that allows for instant communication between users. Pretty impressive until you need to eat something."
	icon_state = "tongueayylmao"
	say_mod = "gibbers"
	taste_sensitivity = NO_TASTE_SENSITIVITY // ayys cannot taste anything.
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, span_notice("[src] is already attuned to the same channel as your own."))

	H.visible_message(span_notice("[H] holds [src] in their hands, and concentrates for a moment."), span_notice("You attempt to modify the attunation of [src]."))
	if(do_after(H, 1.5 SECONDS, src))
		to_chat(H, span_notice("You attune [src] to your own channel."))
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += span_notice("It is not attuned to a specific mothership.")
		else
			. += span_notice("It is attuned to [mothership].")

/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args)
	..()
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = usr
	var/rendered = span_abductor("<b>[user.real_name]:</b> [message]")
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		if(mothership == T.mothership)
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/zombie
	name = "rotting tongue"
	desc = "Between the decay and the fact that it's just lying there you doubt a tongue has ever seemed less sexy."
	icon_state = "tonguezombie"
	say_mod = "moans"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	..()
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, -3) == "..."))//3 == length("...")
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/alien
	name = "alien tongue"
	desc = "According to leading xenobiologists the evolutionary benefit of having a second mouth in your mouth is \"that it looks badass\"."
	icon_state = "tonguexeno"
	say_mod = "hisses"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/ratvar,
		/datum/language/monkey))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	..()
	playsound(owner, "hiss", 25, 1, 1)

/obj/item/organ/tongue/bone
	name = "bone \"tongue\""
	desc = "Apparently skeletons alter the sounds they produce through oscillation of their teeth, hence their characteristic rattling."
	icon_state = "tonguebone"
	say_mod = "rattles"
	attack_verb = list("bitten", "chattered", "chomped", "enamelled", "boned")
	taste_sensitivity = NO_TASTE_SENSITIVITY // skeletons cannot taste anything
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")

/obj/item/organ/tongue/bone/Initialize()
	. = ..()
	phomeme_type = pick(phomeme_types)

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	..()
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "plasma bone \"tongue\""
	desc = "Like animated skeletons, Plasmamen vibrate their teeth in order to produce speech."
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "robotic voicebox"
	desc = "A voice synthesizer that can interface with organic lifeforms."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	icon_state = "tonguerobot"
	say_mod = "states"
	attack_verb = list("beeped", "booped")
	modifies_speech = TRUE
	taste_sensitivity = NO_TASTE_SENSITIVITY // not as good as an organic tongue

/obj/item/organ/tongue/robot/emp_act(severity)
	if(prob(5))
		return 
	owner.apply_effect(EFFECT_STUTTER, rand(5 SECONDS, 2 MINUTES))
	owner.emote("scream")
	to_chat(owner, "<span class='warning'>Alert: Vocal cords are malfunctioning.</span>")

/obj/item/organ/tongue/robot/can_speak_language(language)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	..()
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "snailtongue"
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	..()
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/polysmorph
	name = "polysmorph tongue"
	desc = "Similar to that of a true xenomorph, but less bitey."
	icon_state = "tonguexeno"
	say_mod = "hisses"
	modifies_speech = TRUE
	var/static/list/languages_possible_polysmorph = typecacheof(list(
		/datum/language/common,
		/datum/language/polysmorph))

/obj/item/organ/tongue/polysmorph/handle_speech(datum/source, list/speech_args)
	..()
	var/static/regex/polysmorph_hiss = new("s+", "g")
	var/static/regex/polysmorph_hiSS = new("S+", "g")
	var/static/regex/polysmorph_ecks = new("(?<!^)x+", "g")//only affects Xs in the middle of a sentence
	var/static/regex/polysmorph_eckS = new("(?<!^)X+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = polysmorph_hiss.Replace(message, "ssssss")
		message = polysmorph_hiSS.Replace(message, "SSSSSS")
		message = polysmorph_ecks.Replace(message, "ksssss")
		message = polysmorph_eckS.Replace(message, "KSSSSS")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/polysmorph/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_polysmorph

/obj/item/organ/tongue/slime
	name = "slime tongue"
	desc = "A rudimentary tongue made of slime, just barely able to make every sound needed to talk normally."
	icon_state = "tonguezombie"
	say_mod = "garbles"
	var/static/list/languages_possible_jelly = typecacheof(list(
		/datum/language/common,
		/datum/language/slime))

/obj/item/organ/tongue/slime/Initialize(mapload)
	. = ..()
	languages_possible |= languages_possible_jelly
