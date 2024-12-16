/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/// The time it takes for the crying visual to be removed
#define CRY_DURATION 12.8 SECONDS

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = SOFT_CRIT

/datum/emote/living/carbon/human/cry/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user)) // Give them a visual crying effect if they're human
		var/mob/living/carbon/human/human_user = user
		ADD_TRAIT(human_user, TRAIT_CRYING, "[type]")
		human_user.update_body()

		// Use a timer to remove the effect after the defined duration has passed
		var/list/key_emotes = GLOB.emote_list["cry"]
		for(var/datum/emote/living/carbon/human/cry/human_emote in key_emotes)
			// The existing timer restarts if it is already running
			addtimer(CALLBACK(human_emote, PROC_REF(end_visual), human_user), CRY_DURATION, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/emote/living/carbon/human/cry/proc/end_visual(mob/living/carbon/human/human_user)
	if(!QDELETED(human_user))
		REMOVE_TRAIT(human_user, TRAIT_CRYING, "[type]")
		human_user.update_body()

/datum/emote/living/carbon/human/cry/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_cry_sound(user)

#undef CRY_DURATION

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "sadly can't find anybody to give daps to, and daps themself. Shameful."
	message_param = "gives daps to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses."
	message_param = "hisses at %t."
	emote_type = EMOTE_AUDIBLE
	var/list/viable_tongues = list(/obj/item/organ/tongue/lizard, /obj/item/organ/tongue/polysmorph)

/datum/emote/living/carbon/hiss/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(istype(T, /obj/item/organ/tongue/lizard))
		return 'sound/voice/lizard/hiss.ogg'
	if(istype(T, /obj/item/organ/tongue/polysmorph))
		return pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	if(iscatperson(user))//yogs: catpeople can hiss!
		return pick('sound/voice/feline/hiss1.ogg', 'sound/voice/feline/hiss2.ogg', 'sound/voice/feline/hiss3.ogg')

/datum/emote/living/carbon/hiss/can_run_emote(mob/living/user, status_check = TRUE, intentional)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(iscatperson(user)) //yogs: cat people can hiss!
		return TRUE
	return is_type_in_list(T, viable_tongues)

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themself."
	message_param = "hugs %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = SOFT_CRIT

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	emote_type = EMOTE_AUDIBLE
	cooldown = 10 SECONDS
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming || !H.can_speak_vocal())
		return
	if(H.dna?.species)
		return H.dna.species.get_scream_sound(H)

/datum/emote/living/carbon/human/rattle
	key = "rattle"
	key_third_person = "rattles"
	message = "rattles their bones!"
	message_param = "rattles %t bones!"
	emote_type = EMOTE_AUDIBLE
	sound = 'sound/voice/rattled.ogg'

/datum/emote/living/carbon/human/rattle/can_run_emote(mob/living/user, status_check = TRUE, intentional)
	return (isskeleton(user) || isplasmaman(user)) && ..()

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

// Tail thump! Lizard-tail exclusive emote.
/datum/emote/living/carbon/human/tailthump
	key = "thump"
	key_third_person = "thumps their tail"
	message = "thumps their tail!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/tailthump/get_sound(mob/living/user)
	var/obj/item/organ/tail/lizard/tail = user.getorganslot(ORGAN_SLOT_TAIL)
	return tail?.sound_override || 'sound/voice/lizard/tailthump.ogg' // Source: https://freesound.org/people/TylerAM/sounds/389665/

/datum/emote/living/carbon/human/tailthump/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species)
		return FALSE
	if(H.IsParalyzed() || H.IsStun()) // No thumping allowed. Taken from can_wag_tail().
		return FALSE
	return ("tail_lizard" in H.dna.species.mutant_bodyparts) || ("waggingtail_lizard" in H.dna.species.mutant_bodyparts)

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species) // Here to prevent a runtime when a silicon does *help.
		return FALSE
	return H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings."
	hands_use_check = TRUE
	var/wing_time = 20

/datum/emote/living/carbon/human/flap/can_run_emote(mob/user, status_check, intentional)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna.features["wings"] == "None")
			return FALSE
	return ..()

/datum/emote/living/carbon/human/flap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/open = FALSE
		if(H.dna.features["wings"] != "None")
			if("wingsopen" in H.dna.species.mutant_bodyparts)
				open = TRUE
				H.CloseWings()
			else
				H.OpenWings()
			addtimer(CALLBACK(H, open ? TYPE_PROC_REF(/mob/living/carbon/human, OpenWings) : TYPE_PROC_REF(/mob/living/carbon/human, CloseWings)), wing_time)

/datum/emote/living/carbon/human/flap/get_sound(mob/living/carbon/human/user)
	if(ismoth(user))
		return 'sound/voice/moth/moth_flutter.ogg'
	return ..()

/datum/emote/living/carbon/human/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "flaps their wings ANGRILY!"
	hands_use_check = TRUE
	wing_time = 10

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user,intentional), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if("wings" in H.dna.species.mutant_bodyparts)
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species) // Here to prevent a runtime when a silicon does *help.
		return FALSE
	return (H.dna.species["wings"] != "None")

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if("wings" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wings"
		dna.species.mutant_bodyparts |= "wingsopen"
		if("wingsdetail" in dna.species.mutant_bodyparts)
			dna.species.mutant_bodyparts -= "wingsdetail"
			dna.species.mutant_bodyparts |= "wingsdetailopen"
	if("moth_wings" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts |= "moth_wingsopen"
		dna.features["moth_wingsopen"] = "moth_wings"
		dna.species.mutant_bodyparts -= "moth_wings"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if("wingsopen" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wingsopen"
		dna.species.mutant_bodyparts |= "wings"
		if("wingsdetailopen" in dna.species.mutant_bodyparts)
			dna.species.mutant_bodyparts -= "wingsdetailopen"
			dna.species.mutant_bodyparts |= "wingsdetail"
	if("moth_wingsopen" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "moth_wingsopen"
		dna.species.mutant_bodyparts |= "moth_wings"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)

/datum/emote/living/carbon/human/robot_tongue
	emote_type = EMOTE_AUDIBLE //emotes that require robotic voicebox are audible by default, because it's a sound-making device

/datum/emote/living/carbon/human/robot_tongue/can_run_emote(mob/user, status_check = TRUE , intentional)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/organ/tongue/T = user.getorganslot("tongue")
	if(!istype(T) || T.status != ORGAN_ROBOTIC)
		return FALSE

/datum/emote/living/carbon/human/robot_tongue/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."

/datum/emote/living/carbon/human/robot_tongue/beep/get_sound(mob/living/user)
	return 'sound/machines/twobeep.ogg'


/datum/emote/living/carbon/human/robot_tongue/boop
	key = "boop"
	key_third_person = "boops"
	message = "boops."

/datum/emote/living/carbon/human/robot_tongue/boop/get_sound(mob/living/user)
	return 'sound/machines/boop.ogg'

/datum/emote/living/carbon/human/robot_tongue/buzz
	key = "buzz"
	key_third_person = "buzzes"
	message = "buzzes."
	message_param = "buzzes at %t."

/datum/emote/living/carbon/human/robot_tongue/buzz/get_sound(mob/living/user)
	return 'sound/machines/buzz-sigh.ogg'

/datum/emote/living/carbon/human/robot_tongue/buzz2
	key = "buzz2"
	message = "buzzes twice."

/datum/emote/living/carbon/human/robot_tongue/buzz2/get_sound(mob/living/user)
	return 'sound/machines/buzz-two.ogg'

/datum/emote/living/carbon/human/robot_tongue/chime
	key = "chime"
	key_third_person = "chimes"
	message = "chimes."

/datum/emote/living/carbon/human/robot_tongue/chime/get_sound(mob/living/user)
	return 'sound/machines/chime.ogg'

/datum/emote/living/carbon/human/robot_tongue/ping
	key = "ping"
	key_third_person = "pings"
	message = "pings."
	message_param = "pings at %t."

/datum/emote/living/carbon/human/robot_tongue/ping/get_sound(mob/living/user)
	return 'sound/machines/ping.ogg'

/datum/emote/living/carbon/human/robot_tongue/warn
	key = "warn"
	key_third_person = "warns"
	message = "blares an alarm!"
	message_param = "blares an alarm at %t!"

/datum/emote/living/carbon/human/robot_tongue/warn/get_sound(mob/living/user)
	return 'sound/machines/warning-buzzer.ogg'

// Emotes only for clowns who use a robotic tongue. Honk!
/datum/emote/living/carbon/human/robot_tongue/clown/can_run_emote(mob/user, status_check = TRUE, intentional)
	. = ..()
	if(!.)
		return FALSE

	if(!user || !user.mind || !user.mind.assigned_role || user.mind.assigned_role != "Clown")
		return FALSE
	return TRUE

/datum/emote/living/carbon/human/robot_tongue/clown/honk
	key = "honk"
	key_third_person = "honks"
	message = "honks."

/datum/emote/living/carbon/human/robot_tongue/clown/honk/get_sound(mob/living/user)
	return 'sound/items/bikehorn.ogg'

/datum/emote/living/carbon/human/robot_tongue/clown/sad
	key = "sad"
	key_third_person = "plays a sad trombone..."
	message = "plays a sad trombone..."

/datum/emote/living/carbon/human/robot_tongue/clown/sad/get_sound(mob/living/user)
	return 'sound/misc/sadtrombone.ogg'
