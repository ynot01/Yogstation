/datum/action/changeling/sting//parent path, not meant for users afaik
	name = "Tiny Prick"
	desc = "Stabby stabby"
	var/sting_icon = null

/datum/action/changeling/sting/Trigger()
	var/mob/user = owner
	if(!user || !user.mind)
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling)
		return
	if(!changeling.chosen_sting)
		set_sting(user)
	else
		unset_sting(user)
	return

/datum/action/changeling/sting/proc/set_sting(mob/user)
	to_chat(user, span_notice("We prepare our sting. Alt+click or click the middle mouse button on a target to sting them."))
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = src

	user.hud_used.lingstingdisplay.icon = 'icons/obj/changeling.dmi'
	user.hud_used.lingstingdisplay.icon_state = sting_icon
	user.hud_used.lingstingdisplay.invisibility = 0

/datum/action/changeling/sting/proc/unset_sting(mob/user)
	to_chat(user, span_warning("We retract our sting, we can't sting anyone for now."))
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.chosen_sting = null

	user.hud_used.lingstingdisplay.icon_state = null
	user.hud_used.lingstingdisplay.invisibility = INVISIBILITY_ABSTRACT

/mob/living/carbon/proc/unset_sting()
	if(mind)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling && changeling.chosen_sting)
			changeling.chosen_sting.unset_sting(src)

/datum/action/changeling/sting/can_sting(mob/user, mob/target)
	if(!..())
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling.chosen_sting)
		to_chat(user, "We haven't prepared our sting yet!")
	if(!iscarbon(target))
		return
	if(!isturf(user.loc))
		return
	if(!AStar(user, target.loc, /turf/proc/Distance, changeling.sting_range, simulated_only = FALSE))
		return
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		sting_feedback(user, target)
		changeling.chem_charges -= chemical_cost
	return 1

/datum/action/changeling/sting/sting_feedback(mob/user, mob/target)
	if(!target)
		return
	to_chat(user, span_notice("We stealthily sting [target.name]."))
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(target, span_warning("You feel a tiny prick."))
	return 1


/datum/action/changeling/sting/transformation
	name = "Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform for a short time. Costs 20 chemicals."
	helptext = "The victim will transform much like a changeling would. Does not provide a warning to others. Mutations will not be transferred, and monkeys will become human. Stings on already transformed targets won't last as long."
	button_icon_state = "sting_transform"
	sting_icon = "sting_transform"
	chemical_cost = 20
	dna_cost = 1
	var/datum/changelingprofile/selected_dna = null

/datum/action/changeling/sting/transformation/Trigger()
	var/mob/user = usr
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna("Select the target DNA: ", "Target DNA")
	if(!selected_dna)
		return
	if(NOTRANSSTING in selected_dna.dna.species.species_traits)
		to_chat(user, "<span class = 'notice'>That DNA is not compatible with changeling retrovirus!</span>")
		return
	..()

/datum/action/changeling/sting/transformation/can_sting(mob/user, mob/living/carbon/target)
	if(!..())
		return
	if((HAS_TRAIT(target, TRAIT_HUSK)) || !iscarbon(target) || (NOTRANSSTING in target.dna.species.species_traits))
		to_chat(user, span_warning("Our sting appears ineffective against its DNA."))
		return 0
	return 1

/datum/action/changeling/sting/transformation/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "transformation sting", " new identity is '[selected_dna.dna.real_name]'")
	var/datum/dna/NewDNA = selected_dna.dna
	if(ismonkey(target))
		to_chat(user, span_notice("Our genes cry out as we sting [target.name]!"))

	var/mob/living/carbon/C = target

	. = TRUE
	if(istype(C))

		if(!HAS_TRAIT(C, CHANGESTING_TRAIT))
			//block that stores the old identity for use in reverting
			var/mob/living/carbon/human/OldDNA = new /mob/living/carbon/human()
			OldDNA.real_name = C.real_name
			C.dna.transfer_identity(OldDNA)
			addtimer(CALLBACK(src, .proc/revert, C, OldDNA), 10 MINUTES, TIMER_UNIQUE)
			ADD_TRAIT(C, CHANGESTING_TRAIT, "recentsting")
		else
			to_chat(user, span_notice("We notice that [target.name]'s DNA is already in turmoil from the previous sting."))

		C.real_name = NewDNA.real_name
		NewDNA.transfer_identity(C)
		if(ismonkey(C))
			C.humanize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSTUNS | TR_KEEPREAGENTS | TR_DEFAULTMSG)
		C.updateappearance(mutcolor_update=1)

/datum/action/changeling/sting/transformation/proc/revert(mob/living/carbon/target, mob/living/carbon/original)
	REMOVE_TRAIT(target, CHANGESTING_TRAIT, "recentsting")
	target.real_name = original.real_name
	original.dna.transfer_identity(target)
	qdel(original)

/datum/action/changeling/sting/false_armblade
	name = "False Armblade Sting"
	desc = "We silently sting a human, injecting a retrovirus that mutates their arm to temporarily appear as an armblade. Costs 20 chemicals."
	helptext = "The victim will form an armblade much like a changeling would, except the armblade is less sharp and powerful."
	button_icon_state = "sting_armblade"
	sting_icon = "sting_armblade"
	chemical_cost = 20
	dna_cost = 1
	xenoling_available = FALSE

/obj/item/melee/arm_blade/false
	desc = "A grotesque mass of flesh that used to be your arm. On the bright side, at least you can cut wood with this."
	force = 20 //yogs -- worse than armblade but still not terrible
	//daily reminder that xantam is a closet furry
	fake = TRUE

/datum/action/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(isliving(target))
		var/mob/living/L = target
		if((HAS_TRAIT(L, TRAIT_HUSK)) || !L.has_dna())
			to_chat(user, span_warning("Our sting appears ineffective against its DNA."))
			return 0
	return 1

/datum/action/changeling/sting/false_armblade/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", object="false armblade sting")

	var/obj/item/held = target.get_active_held_item()
	if(held && !target.dropItemToGround(held))
		to_chat(user, span_warning("[held] is stuck to [target.p_their()] hand, you cannot grow a false armblade over it!"))
		return
	..()
	if(ismonkey(target))
		to_chat(user, span_notice("Our genes cry out as we sting [target.name]!"))

	var/obj/item/melee/arm_blade/false/blade = new(target,1)
	target.put_in_hands(blade)
	target.visible_message(span_warning("A grotesque blade forms around [target.name]\'s arm!"), span_userdanger("Your arm twists and mutates, transforming into a horrific monstrosity!"), span_italics("You hear organic matter ripping and tearing!"))
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)

	addtimer(CALLBACK(src, .proc/remove_fake, target, blade), 600)
	return TRUE

/datum/action/changeling/sting/false_armblade/proc/remove_fake(mob/target, obj/item/melee/arm_blade/false/blade)
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)
	target.visible_message("<span class='warning'>With a sickening crunch, \
	[target] reforms [target.p_their()] [blade.name] into an arm!</span>",
	span_warning("[blade] reforms back to normal."),
	"<span class='italics>You hear organic matter ripping and tearing!</span>")

	qdel(blade)
	target.update_inv_hands()

/*/datum/action/changeling/sting/extract_dna //yogs start - removed extract dna sting
	name = "Extract DNA Sting"
	desc = "We stealthily sting a target and extract their DNA. Costs 25 chemicals."
	helptext = "Will give you the DNA of your target, allowing you to transform into them."
	button_icon_state = "sting_extract"
	sting_icon = "sting_extract"
	chemical_cost = 25
	dna_cost = 0

/datum/action/changeling/sting/extract_dna/can_sting(mob/user, mob/target)
	if(..())
		var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
		return changeling.can_absorb_dna(target)

/datum/action/changeling/sting/extract_dna/sting_action(mob/user, mob/living/carbon/human/target)
	log_combat(user, target, "stung", "extraction sting")
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!(changeling.has_dna(target.dna)))
		changeling.add_new_profile(target)
	return TRUE*/ //yogs end

/datum/action/changeling/sting/mute
	name = "Mute Sting"
	desc = "We silently sting a human, completely silencing them for a short time. Costs 20 chemicals."
	helptext = "Does not provide a warning to the victim that they have been stung, until they try to speak and cannot."
	button_icon_state = "sting_mute"
	sting_icon = "sting_mute"
	chemical_cost = 20
	dna_cost = 2

/datum/action/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
	log_combat(user, target, "stung", "mute sting")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 17)
	return TRUE

/datum/action/changeling/sting/blind
	name = "Blind Sting"
	desc = "We temporarily blind our victim. Costs 25 chemicals."
	helptext = "This sting completely blinds a target for a short time, and leaves them with blurred vision for a long time."
	button_icon_state = "sting_blind"
	sting_icon = "sting_blind"
	chemical_cost = 25
	dna_cost = 1

/datum/action/changeling/sting/blind/sting_action(mob/user, mob/living/carbon/target)
	log_combat(user, target, "stung", "blind sting")
	to_chat(target, span_danger("Your eyes burn horrifically!"))
	target.become_nearsighted(EYE_DAMAGE)
	target.blind_eyes(20)
	target.blur_eyes(40)
	return TRUE

/datum/action/changeling/sting/LSD
	name = "Hallucination Sting"
	desc = "We cause mass terror to our victim."
	helptext = "We evolve the ability to sting a target with a powerful hallucinogenic chemical. The target does not notice they have been stung, and the effect occurs after 30 to 60 seconds."
	button_icon_state = "sting_lsd"
	sting_icon = "sting_lsd"
	chemical_cost = 10
	dna_cost = 1

/datum/action/changeling/sting/LSD/sting_action(mob/user, mob/living/carbon/target)
	log_combat(user, target, "stung", "LSD sting")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/toxin/mindbreaker, 30)
	return TRUE

/datum/action/changeling/sting/cryo
	name = "Cryogenic Sting"
	desc = "We silently sting our victim with a cocktail of chemicals that freezes them from the inside. Costs 15 chemicals."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing."
	button_icon_state = "sting_cryo"
	sting_icon = "sting_cryo"
	chemical_cost = 15
	dna_cost = 2
	xenoling_available = FALSE

/datum/action/changeling/sting/cryo/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "cryo sting")
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/consumable/frostoil, 30)
	return TRUE
