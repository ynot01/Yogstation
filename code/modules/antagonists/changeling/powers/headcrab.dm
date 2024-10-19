/datum/action/changeling/headcrab
	name = "Last Resort"
	desc = "We sacrifice our current body in a moment of need, placing us in control of a vessel that can plant our likeness in a new host. Costs 20 chemicals."
	helptext = "We will be placed in control of a small, fragile creature. We may attack a corpse like this to plant an egg which will slowly mature into a new form for us. Can be used while unconscious or dead." // yogs - added "Can be used while unconscious or dead."
	button_icon_state = "last_resort"
	chemical_cost = 20
	dna_cost = 1
	req_human = 1
	ignores_fakedeath = TRUE
	req_stat = DEAD

/datum/action/changeling/headcrab/sting_action(mob/living/user)
	set waitfor = FALSE
	if(tgui_alert(user,"Are we sure we wish to kill ourself and create a headslug?",,list("Yes", "No")) != "Yes")
		return
	if(QDELETED(user)) // Yogs: Implies maybe that the user was already gibbed or something. Prevents a null mob loc later on
		return
	if(ismob(user.pulledby) && IS_CHANGELING(user.pulledby) && user.pulledby.grab_state >= GRAB_NECK)
		to_chat(user, span_warning("Our abilities are being dampened! We cannot use [src]!"))
		return
	..()
	var/datum/mind/M = user.mind
	var/list/organs = user.getorganszone(BODY_ZONE_HEAD, 1)

	for(var/obj/item/organ/I in organs)
		I.Remove(user, 1)

	explosion(get_turf(user), 0, 0, 2, 0, TRUE)
	for(var/mob/living/carbon/human/H in range(2,user))
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			to_chat(H, span_userdanger("You are blinded by a shower of blood!"))
			H.Stun(20)
			H.adjust_eye_blur(20)
			eyes.applyOrganDamage(5)
			H.adjust_confusion(3 SECONDS)
	for(var/mob/living/silicon/S in range(2,user))
		to_chat(S, span_userdanger("Your sensors are disabled by a shower of blood!"))
		S.Paralyze(60)
	var/turf/user_turf = get_turf(user)
	var/mob/living/simple_animal/horror/horror = user.has_horror_inside()
	if (horror)
		horror.leave_victim()
	user.transfer_observers_to(user_turf) // user is about to be deleted, store orbiters on the turf
	user.gib()
	. = TRUE
	addtimer(CALLBACK(src, PROC_REF(spawn_headcrab), M, user_turf, organs), 0.5 SECONDS)

/datum/action/changeling/headcrab/proc/spawn_headcrab(datum/mind/stored_mind, turf/spawn_location, list/organs)
	var/mob/living/simple_animal/hostile/headcrab/crab = new(spawn_location)
	for(var/obj/item/organ/I in organs)
		I.forceMove(crab)
	crab.origin = stored_mind
	if(!crab.origin)
		return
	crab.origin.active = TRUE
	crab.origin.transfer_to(crab)
	spawn_location.transfer_observers_to(crab)
	to_chat(crab, span_warning("You burst out of the remains of your former body in a shower of gore!"))
