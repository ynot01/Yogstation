GLOBAL_LIST_INIT(possible_changeling_IDs, list(
	"Alpha",
	"Beta",
	"Gamma",
	"Delta",
	"Epsilon",
	"Zeta",
	"Eta",
	"Theta",
	"Iota",
	"Kappa",
	"Lambda",
	"Mu",
	"Nu",
	"Xi",
	"Omicron",
	"Pi",
	"Rho",
	"Sigma",
	"Tau",
	"Upsilon",
	"Phi",
	"Chi",
	"Psi",
	"Omega",
))

GLOBAL_LIST_INIT(slots, list(
	"head",
	"wear_mask",
	"back",
	"wear_suit",
	"w_uniform",
	"shoes",
	"belt",
	"gloves",
	"glasses",
	"ears",
	"wear_id",
	"s_store",
))
GLOBAL_LIST_INIT(slot2slot, list(
	"head" = ITEM_SLOT_HEAD,
	"wear_mask" = ITEM_SLOT_MASK,
	"neck" = ITEM_SLOT_NECK,
	"back" = ITEM_SLOT_BACK,
	"wear_suit" = ITEM_SLOT_OCLOTHING,
	"w_uniform" = ITEM_SLOT_ICLOTHING,
	"shoes" = ITEM_SLOT_FEET,
	"belt" = ITEM_SLOT_BELT,
	"gloves" = ITEM_SLOT_GLOVES,
	"glasses" = ITEM_SLOT_EYES,
	"ears" = ITEM_SLOT_EARS,
	"wear_id" = ITEM_SLOT_ID,
	"s_store" = ITEM_SLOT_SUITSTORE,
))

GLOBAL_LIST_INIT(slot2type, list(
	"head" = /obj/item/clothing/head/changeling,
	"wear_mask" = /obj/item/clothing/mask/changeling,
	"back" = /obj/item/changeling,
	"wear_suit" = /obj/item/clothing/suit/changeling,
	"w_uniform" = /obj/item/clothing/under/changeling,
	"shoes" = /obj/item/clothing/shoes/changeling,
	"belt" = /obj/item/changeling,
	"gloves" = /obj/item/clothing/gloves/changeling,
	"glasses" = /obj/item/clothing/glasses/changeling,
	"ears" = /obj/item/changeling,
	"wear_id" = /obj/item/changeling,
	"s_store" = /obj/item/changeling,
))

///If this is not null, we hand our this objective to all lings
GLOBAL_VAR(changeling_team_objective_type)

/// The duration of the fakedeath coma.
#define LING_FAKEDEATH_TIME 40 SECONDS
#define LING_DEAD_GENETICDAMAGE_HEAL_CAP	50	//The lowest value of geneticdamage handle_changeling() can take it to while dead.
/// The number of recent spoken lines to gain on absorbing a mob
#define LING_ABSORB_RECENT_SPEECH 8

/datum/antagonist/changeling
	name = "Changeling"
	roundend_category  = "changelings"
	antagpanel_category = "Changeling"
	show_to_ghosts = TRUE
	job_rank = ROLE_CHANGELING
	antag_hud_name = "changeling"
	antag_moodlet = /datum/mood_event/changeling
	ui_name = "AntagInfoChangeling"
	count_towards_antag_cap = TRUE

	var/you_are_greet = TRUE
	var/give_objectives = TRUE
	var/team_mode = FALSE //Should assign team objectives ?

	//Changeling Stuff

	var/list/stored_profiles = list() //list of datum/changelingprofile
	var/datum/changelingprofile/first_prof = null
	var/dna_max = 6 //How many extra DNA strands the changeling can store for transformation.
	var/absorbedcount = 0
	var/trueabsorbs = 0//dna gained using absorb, not dna sting
	var/chem_charges = 50 // chems we have on spawn
	var/chem_storage = 125 // max chems
	var/chem_recharge_rate = 2 // how fast we restore chems
	var/chem_recharge_slowdown = 0 // how much is our chem restore rate hampered (keep at 0)
	var/sting_range = 2
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/was_absorbed = FALSE //if they were absorbed by another ling already.
	var/isabsorbing = 0
	var/islinking = 0
	var/geneticpoints = 10
	var/purchasedpowers = list()

	var/mimicing = ""
	var/canrespec = FALSE//set to TRUE in absorb.dm
	var/changeling_speak = 0
	var/datum/dna/chosen_dna
	/// The currently active changeling sting.
	var/datum/action/changeling/sting/chosen_sting
	/// A reference to our cellular emporium datum.
	var/datum/antag_menu/cellular_emporium/cellular_emporium
	/// A reference to our cellular emporium action (which opens the UI for the datum).
	var/datum/action/innate/cellular_emporium/emporium_action

	/// UI displaying how many chems we have
	var/atom/movable/screen/ling/chems/lingchemdisplay
	/// UI displayng our currently active sting
	var/atom/movable/screen/ling/sting/lingstingdisplay

	var/static/list/all_powers = typecacheof(/datum/action/changeling,TRUE)
	var/list/stored_snapshots = list() //list of stored snapshots

/datum/antagonist/changeling/New()
	. = ..()
	for(var/datum/antagonist/changeling/C in GLOB.antagonists)
		if(!C.owner || C.owner == owner)
			continue
		if(C.was_absorbed) //make sure the other ling wasn't already killed by another one. only matters if the changeling that absorbed them was gibbed after.
			continue
		break

/datum/antagonist/changeling/Destroy()
	QDEL_NULL(cellular_emporium)
	QDEL_NULL(emporium_action)
	return ..()

/datum/antagonist/changeling/proc/generate_name()
	var/honorific
	if(owner.current.gender == FEMALE)
		honorific = "Ms."
	else if(owner.current.gender == MALE)
		honorific = "Mr."
	else
		honorific = "Dear" // Yogs -- I refuse to use Mx, that sounds more like a pharmaceutical company than a person
	if(GLOB.possible_changeling_IDs.len)
		changelingID = pick(GLOB.possible_changeling_IDs)
		GLOB.possible_changeling_IDs -= changelingID
		changelingID = "[honorific] [changelingID]"
	else
		changelingID = "[honorific] [rand(1,999)]"

/datum/antagonist/changeling/proc/create_actions()
	cellular_emporium = new(src)
	emporium_action = new(cellular_emporium)
	emporium_action.Grant(owner.current)

/datum/antagonist/changeling/on_gain()
	generate_name()
	create_actions()
	reset_powers()
	make_absorbable() // Lings need to be able to absorb other lings
	create_initial_profile()
	if(give_objectives)
		if(team_mode)
			forge_team_objectives()
		forge_objectives()
	handle_clown_mutation(owner.current, "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself.")
	owner.current.grant_all_languages(FALSE, FALSE, TRUE)	//Grants omnitongue. We are able to transform our body after all.
	return ..()

/datum/antagonist/changeling/on_removal()
	//We'll be using this from now on
	var/mob/living/carbon/C = owner.current
	if(istype(C))
		var/obj/item/organ/brain/B = C.getorganslot(ORGAN_SLOT_BRAIN)
		if(B && (B.decoy_override != initial(B.decoy_override)))
			B.organ_flags |= ORGAN_VITAL
			B.decoy_override = FALSE
	remove_changeling_powers()
	. = ..()

/datum/antagonist/changeling/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/datum/hud/ling_hud = owner.current.hud_used

	lingchemdisplay = new(ling_hud)
	ling_hud.infodisplay += lingchemdisplay

	lingstingdisplay = new(ling_hud)
	ling_hud.infodisplay += lingstingdisplay

	INVOKE_ASYNC(ling_hud, TYPE_PROC_REF(/datum/hud/, show_hud),ling_hud.hud_version)

/datum/antagonist/changeling/proc/make_absorbable()
	var/mob/living/carbon/C = owner.current
	if(ishuman(C) && ((NO_DNA_COPY in C.dna.species.species_traits) || !C.has_dna() || (NOHUSK in C.dna.species.species_traits)))
		to_chat(C, span_userdanger("You have been made a human, as your original race had incompatible DNA."))
		C.set_species(/datum/species/human, TRUE, TRUE)
		if(C.client?.prefs?.read_preference(/datum/preference/name/backup_human) && !is_banned_from(C.client?.ckey, "Appearance"))
			C.fully_replace_character_name(C.dna.real_name, C.client.prefs.read_preference(/datum/preference/name/backup_human))
		else
			C.fully_replace_character_name(C.dna.real_name, random_unique_name(C.gender))

/datum/antagonist/changeling/proc/reset_properties()
	changeling_speak = 0
	chosen_sting = null
	geneticpoints = initial(geneticpoints)
	sting_range = initial(sting_range)
	chem_storage = initial(chem_storage)
	chem_recharge_rate = initial(chem_recharge_rate)
	chem_charges = min(chem_charges, chem_storage)
	chem_recharge_slowdown = initial(chem_recharge_slowdown)
	mimicing = ""

/datum/antagonist/changeling/proc/remove_changeling_powers()
	if(ishuman(owner.current) || ismonkey(owner.current))
		var/additionalpoints = geneticpoints

		changeling_speak = 0
		chosen_sting = null
		mimicing = ""

		for(var/datum/action/changeling/p in purchasedpowers)
			if(p.dna_cost > 0)
				additionalpoints += p.dna_cost
			
			purchasedpowers -= p
			p.Remove(owner.current)
			
		geneticpoints = additionalpoints

/datum/antagonist/changeling/proc/reset_powers()
	if(purchasedpowers)
		remove_changeling_powers()
	//Repurchase free powers.
	for(var/path in all_powers)
		var/datum/action/changeling/S = new path
		if(!S.dna_cost)
			if(!has_sting(S))
				purchasedpowers += S
				S.on_purchase(owner.current,TRUE)

/datum/antagonist/changeling/proc/regain_powers()//for when action buttons are lost and need to be regained, such as when the mind enters a new mob
	emporium_action.Grant(owner.current)
	for(var/power in purchasedpowers)
		var/datum/action/changeling/S = power
		if(istype(S) && S.needs_button)
			S.Grant(owner.current)

/datum/antagonist/changeling/proc/has_sting(datum/action/changeling/power)
	for(var/P in purchasedpowers)
		var/datum/action/changeling/otherpower = P
		if(initial(power.name) == otherpower.name)
			return TRUE
	return FALSE


/datum/antagonist/changeling/proc/purchase_power(sting_name)
	var/datum/action/changeling/thepower

	for(var/path in all_powers)
		var/datum/action/changeling/S = path
		if(initial(S.name) == sting_name)
			thepower = new path
			break

	if(!thepower)
		to_chat(owner.current, "This is awkward. Changeling power purchase failed, please report this bug to a coder!")
		return

	if(absorbedcount < thepower.req_dna)
		to_chat(owner.current, "We lack the energy to evolve this ability!")
		return

	if(has_sting(thepower))
		to_chat(owner.current, "We have already evolved this ability!")
		return

	if(thepower.dna_cost < 0)
		to_chat(owner.current, "We cannot evolve this ability.")
		return

	if(geneticpoints < thepower.dna_cost)
		to_chat(owner.current, "We have reached our capacity for abilities.")
		return

	if(HAS_TRAIT(owner.current, TRAIT_DEATHCOMA))//To avoid potential exploits by buying new powers while in stasis, which clears your verblist.
		to_chat(owner.current, "We lack the energy to evolve new abilities right now.")
		return
	//this checks for conflicting abilities that you dont want players to have at the same time (movement speed abilities for example)
	for(var/conflictingpower in thepower.conflicts) 
		if(has_sting(conflictingpower))
			to_chat(owner.current, "This power conflicts with another power we currently have!")
			return

	geneticpoints -= thepower.dna_cost
	purchasedpowers += thepower
	thepower.on_purchase(owner.current)//Grant() is ran in this proc, see changeling_powers.dm

/datum/antagonist/changeling/proc/readapt()
	if(!ishuman(owner.current))
		to_chat(owner.current, span_danger("We can't remove our evolutions in this form!"))
		return
	if(canrespec)
		to_chat(owner.current, span_notice("We have removed our evolutions from this form, and are now ready to readapt."))
		reset_powers()
		canrespec = 0
		SSblackbox.record_feedback("tally", "changeling_power_purchase", 1, "Readapt")
		return 1
	else
		to_chat(owner.current, span_danger("You lack the power to readapt your evolutions!"))
		return 0

//Called in life()
/datum/antagonist/changeling/proc/regenerate()//grants the HuD in life.dm
	var/mob/living/carbon/the_ling = owner.current
	if(istype(the_ling))
		if(the_ling.stat == DEAD)
			chem_charges = min(max(0, chem_charges + chem_recharge_rate - chem_recharge_slowdown), (chem_storage*0.5))
			geneticdamage = max(LING_DEAD_GENETICDAMAGE_HEAL_CAP,geneticdamage-1)
		else //not dead? no chem/geneticdamage caps.
			chem_charges = min(max(0, chem_charges + chem_recharge_rate - chem_recharge_slowdown), chem_storage)
			geneticdamage = max(0, geneticdamage-1)


/datum/antagonist/changeling/proc/get_dna(dna_owner)
	for(var/datum/changelingprofile/prof in stored_profiles)
		if(dna_owner == prof.name)
			return prof

/datum/antagonist/changeling/proc/has_dna(datum/dna/tDNA)
	for(var/datum/changelingprofile/prof in stored_profiles)
		if(tDNA.is_same_as(prof.dna))
			return TRUE
	return FALSE

/datum/antagonist/changeling/proc/can_absorb_dna(mob/living/carbon/human/target, verbose=1)
	var/mob/living/carbon/user = owner.current
	if(!istype(user))
		return
	if(stored_profiles.len)
		var/datum/changelingprofile/prof = stored_profiles[1]
		if(prof.dna == user.dna && stored_profiles.len >= dna_max)//If our current DNA is the stalest, we gotta ditch it.
			if(verbose)
				to_chat(user, span_warning("We have reached our capacity to store genetic information! We must transform before absorbing more."))
			return
	if(!target)
		return
	if((NO_DNA_COPY in target.dna.species.species_traits) || (NOHUSK in target.dna.species.species_traits)) // if they can't be husked absorbing them will break and make them unrevivable
		if(verbose)
			to_chat(user, span_warning("[target] is not compatible with our biology."))
		return
	if(HAS_TRAIT(target, TRAIT_BADDNA))
		if(verbose)
			to_chat(user, span_warning("DNA of [target] is ruined beyond usability!"))
		return
	if(HAS_TRAIT(target, TRAIT_HUSK))
		if(verbose)
			to_chat(user, span_warning("[target]'s body is ruined beyond usability!"))
		return
	if(!ishuman(target))//Absorbing monkeys is entirely possible, but it can cause issues with transforming. That's what lesser form is for anyway!
		if(verbose)
			to_chat(user, span_warning("We could gain no benefit from absorbing a lesser creature."))
		return
	if(has_dna(target.dna))
		if(verbose)
			to_chat(user, span_warning("We already have this DNA in storage!"))
		return
	if(!target.has_dna())
		if(verbose)
			to_chat(user, span_warning("[target] is not compatible with our biology."))
		return
	return 1


/datum/antagonist/changeling/proc/create_profile(mob/living/carbon/human/H, protect = 0)
	var/datum/changelingprofile/prof = new

	H.dna.real_name = H.real_name //Set this again, just to be sure that it's properly set.
	var/datum/dna/new_dna = new H.dna.type
	H.dna.copy_dna(new_dna)
	prof.dna = new_dna
	prof.name = H.real_name
	prof.protected = protect

	prof.underwear = H.underwear
	prof.undershirt = H.undershirt
	prof.socks = H.socks
	if(H.mind)//yes we need to check this
		prof.accent = H.mind.accent_name

	for(var/i in H.all_scars)
		var/datum/scar/iter_scar = i
		LAZYADD(prof.stored_scars, iter_scar.format())

	var/list/slots = list("head", "wear_mask", "back", "wear_suit", "w_uniform", "shoes", "belt", "gloves", "glasses", "ears", "wear_id", "s_store")
	for(var/slot in slots)
		if(slot in H.vars)
			var/obj/item/I = H.vars[slot]
			if(!I)
				continue
			prof.name_list[slot] = I.name
			prof.appearance_list[slot] = I.appearance
			prof.flags_cover_list[slot] = I.flags_cover
			prof.inhand_icon_state_list[slot] = I.item_state
			prof.lefthand_file_list[slot] = I.lefthand_file
			prof.righthand_file_list[slot] = I.righthand_file
			prof.worn_icon_list[slot] = I.worn_icon
			prof.worn_icon_state_list[slot] = I.worn_icon_state
			prof.sprite_sheets_list[slot] = I.sprite_sheets
			prof.exists_list[slot] = 1
		else
			continue

	return prof

/datum/antagonist/changeling/proc/add_profile(datum/changelingprofile/prof)
	if(stored_profiles.len > dna_max)
		if(!push_out_profile())
			return

	if(!first_prof)
		first_prof = prof

	stored_profiles += prof
	absorbedcount++

/datum/antagonist/changeling/proc/add_new_profile(mob/living/carbon/human/H, protect = 0)
	var/datum/changelingprofile/prof = create_profile(H, protect)
	var/datum/icon_snapshot/entry = new
	entry.name = H.real_name
	entry.icon = H.icon
	entry.icon_state = H.icon_state
	entry.overlays = H.get_overlays_copy(list(HANDS_LAYER))	//ugh
	stored_snapshots[entry.name] = entry
	add_profile(prof)
	return prof

/datum/antagonist/changeling/proc/remove_profile(mob/living/carbon/human/H, force = 0)
	for(var/datum/changelingprofile/prof in stored_profiles)
		if(H.real_name == prof.name)
			if(prof.protected && !force)
				continue
			stored_profiles -= prof
			qdel(prof)

/datum/antagonist/changeling/proc/get_profile_to_remove()
	for(var/datum/changelingprofile/prof in stored_profiles)
		if(!prof.protected)
			return prof

/datum/antagonist/changeling/proc/push_out_profile()
	var/datum/changelingprofile/removeprofile = get_profile_to_remove()
	if(removeprofile)
		stored_profiles -= removeprofile
		return 1
	return 0


/datum/antagonist/changeling/proc/create_initial_profile()
	var/mob/living/carbon/C = owner.current	//only carbons have dna now, so we have to typecaste
	if(ishuman(C))
		add_new_profile(C)

/datum/antagonist/changeling/apply_innate_effects(mob/living/mob_override)
	var/mob/mob_to_tweak = mob_override || owner.current
	if(!isliving(mob_to_tweak))
		return
	handle_clown_mutation(mob_to_tweak, "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself.")
	RegisterSignal(mob_to_tweak, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignals(mob_to_tweak, list(COMSIG_MOB_MIDDLECLICKON, COMSIG_MOB_ALTCLICKON), PROC_REF(on_click_sting))
	//Brains optional.
	var/obj/item/organ/brain/our_ling_brain = mob_to_tweak.getorganslot(ORGAN_SLOT_BRAIN)
	if(our_ling_brain)
		our_ling_brain.organ_flags &= ~ORGAN_VITAL
		our_ling_brain.decoy_override = TRUE

	if(mob_to_tweak.hud_used)
		var/datum/hud/hud_used = mob_to_tweak.hud_used
		lingchemdisplay = new /atom/movable/screen/ling/chems(hud_used)
		hud_used.infodisplay += lingchemdisplay

		lingstingdisplay = new /atom/movable/screen/ling/sting(hud_used)
		hud_used.infodisplay += lingstingdisplay

		hud_used.show_hud(hud_used.hud_version)
	else
		RegisterSignal(mob_to_tweak, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))


/datum/antagonist/changeling/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/living_mob = mob_override || owner.current
	UnregisterSignal(living_mob, list(COMSIG_MOB_MIDDLECLICKON, COMSIG_MOB_ALTCLICKON))

	if(living_mob.hud_used)
		var/datum/hud/hud_used = living_mob.hud_used

		hud_used.infodisplay -= lingchemdisplay
		hud_used.infodisplay -= lingstingdisplay
		QDEL_NULL(lingchemdisplay)
		QDEL_NULL(lingstingdisplay)

/datum/antagonist/changeling/greet()
	if (you_are_greet)
		to_chat(owner.current, span_boldannounce("You are [changelingID], a changeling! You have absorbed and taken the form of a human."))
	to_chat(owner.current, span_boldannounce("Use say \"[MODE_TOKEN_CHANGELING] message\" to communicate with your fellow changelings."))
	to_chat(owner.current, "<b>You must complete the following tasks:</b>")
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, FALSE, pressure_affected = FALSE)

	owner.announce_objectives()

/datum/antagonist/changeling/farewell()
	to_chat(owner.current, span_userdanger("You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!"))

/**
 * Signal proc for [COMSIG_LIVING_LIFE].
 * Handles regenerating chemicals on life ticks.
 */
/datum/antagonist/changeling/proc/on_life(datum/source, delta_time, times_fired)
	SIGNAL_HANDLER

	// If dead, we only regenerate up to half chem storage.
	if(owner.current.stat == DEAD)
		adjust_chemicals((chem_recharge_rate - chem_recharge_slowdown) * delta_time, chem_storage * 0.5)

	// If we're not dead - we go up to the full chem cap.
	else
		adjust_chemicals((chem_recharge_rate - chem_recharge_slowdown) * delta_time)

/*
 * Adjust the chem charges of the ling by [amount]
 * and clamp it between 0 and override_cap (if supplied) or chem_storage (if no override supplied)
 */
/datum/antagonist/changeling/proc/adjust_chemicals(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : chem_storage
	chem_charges = clamp(chem_charges + amount, 0, cap_to)

	lingchemdisplay?.maptext = ANTAG_MAPTEXT(chem_charges, COLOR_CHANGELING_CHEMICALS)


/datum/antagonist/changeling/proc/forge_team_objectives()
	if(GLOB.changeling_team_objective_type)
		var/datum/objective/changeling_team_objective/team_objective = new GLOB.changeling_team_objective_type
		team_objective.owner = owner
		if(team_objective.prepare())//Setting up succeeded
			objectives += team_objective
		else
			qdel(team_objective)
	return

/datum/antagonist/changeling/proc/forge_objectives()
	//OBJECTIVES - random traitor objectives. Unique objectives "steal brain" and "identity theft".
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/escape_objective_possible = TRUE

	//if there's a team objective, check if it's compatible with escape objectives
	for(var/datum/objective/changeling_team_objective/CTO in objectives)
		if(!CTO.escape_objective_compatible)
			escape_objective_possible = FALSE
			break
	var/other_changelings_exist = FALSE
	for(var/datum/antagonist/changeling/CL in GLOB.antagonists)
		if(CL != src)
			other_changelings_exist = TRUE
			break

	var/changeling_objective = other_changelings_exist ? pick(1,3) : 1 //yogs - fuck absorb most
	switch(changeling_objective) //yogs - see above
		if(1)
			var/datum/objective/absorb/absorb_objective = new
			absorb_objective.owner = owner
			absorb_objective.gen_amount_goal(3, 5) //yogs, 6-8 -> 3-5
			objectives += absorb_objective
		if(2)
			var/datum/objective/absorb_most/ac = new
			ac.owner = owner
			objectives += ac
		if(3) //only give the murder other changelings goal if they're not in a team.
			var/datum/objective/absorb_changeling/ac = new
			ac.owner = owner
			objectives += ac

	if(prob(60))
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = owner
		steal_objective.find_target()
		objectives += steal_objective

	var/list/active_ais = active_ais()
	if(active_ais.len && prob(100/GLOB.joined_player_list.len))
		var/datum/objective/destroy/destroy_objective = new
		destroy_objective.owner = owner
		destroy_objective.find_target()
		objectives += destroy_objective
	else
		if(prob(70))
			var/N = pick(/datum/objective/assassinate, /datum/objective/assassinate/cloned, /datum/objective/assassinate/once)
			var/datum/objective/assassinate/kill_objective = new N
			kill_objective.owner = owner
			if(team_mode) //No backstabbing while in a team
				kill_objective.find_target_by_role(role = ROLE_CHANGELING, role_type = TRUE, invert = TRUE)
			else
				kill_objective.find_target()
			objectives += kill_objective
		else
			var/datum/objective/maroon/maroon_objective = new
			maroon_objective.owner = owner
			if(team_mode)
				maroon_objective.find_target_by_role(role = ROLE_CHANGELING, role_type = TRUE, invert = TRUE)
			else
				maroon_objective.find_target()
			objectives += maroon_objective

			if (!(locate(/datum/objective/escape) in objectives) && escape_objective_possible)
				var/datum/objective/escape/escape_with_identity/identity_theft = new
				identity_theft.owner = owner
				identity_theft.target = maroon_objective.target
				identity_theft.update_explanation_text()
				objectives += identity_theft
				escape_objective_possible = FALSE

	if (!(locate(/datum/objective/escape) in objectives) && escape_objective_possible)
		if(prob(50))
			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = owner
			objectives += escape_objective
		else
			var/datum/objective/escape/escape_with_identity/identity_theft = new
			identity_theft.owner = owner
			if(team_mode)
				identity_theft.find_target_by_role(role = ROLE_CHANGELING, role_type = TRUE, invert = TRUE)
			else
				identity_theft.find_target()
			objectives += identity_theft
		escape_objective_possible = FALSE

/**
 * Signal proc for [COMSIG_MOB_MIDDLECLICKON] and [COMSIG_MOB_ALTCLICKON].
 * Allows the changeling to sting people with a click.
 */
/datum/antagonist/changeling/proc/on_click_sting(mob/living/ling, atom/clicked)
	SIGNAL_HANDLER

	// nothing to handle
	if(!chosen_sting)
		return

	if(!isliving(ling) || clicked == ling || ling.stat != CONSCIOUS)
		return

	// sort-of hack done here: we use in_given_range here because it's quicker.
	// actual ling stings do pathfinding to determine whether the target's "in range".
	// however, this is "close enough" preliminary checks to not block click
	if(!isliving(clicked) || !IN_GIVEN_RANGE(ling, clicked, sting_range))
		return
	
	chosen_sting.try_to_sting(ling, clicked)
	ling.next_click = world.time + 5

	return COMSIG_MOB_CANCEL_CLICKON

/datum/antagonist/changeling/admin_add(datum/mind/new_owner,mob/admin)
	. = ..()
	to_chat(new_owner.current, span_boldannounce("Our powers have awoken. A flash of memory returns to us...we are [changelingID], a changeling!"))

/datum/antagonist/changeling/get_admin_commands()
	. = ..()
	if(stored_profiles.len && (owner.current.real_name != first_prof.name))
		.["Transform to initial appearance."] = CALLBACK(src, PROC_REF(admin_restore_appearance))

/datum/antagonist/changeling/proc/admin_restore_appearance(mob/admin)
	if(!stored_profiles.len || !iscarbon(owner.current))
		to_chat(admin, span_danger("Resetting DNA failed!"))
	else
		var/mob/living/carbon/C = owner.current
		first_prof.dna.transfer_identity(C, transfer_SE=1)
		C.real_name = first_prof.name
		C.updateappearance(mutcolor_update=1)
		C.domutcheck()

// Profile

/datum/changelingprofile
	var/name = "a bug"

	var/protected = 0

	var/datum/dna/dna = null
	/// Assoc list of item slot to item name - stores the name of every item of this profile.
	var/list/name_list = list()
	/// Assoc list of item slot to apperance - stores the appearance of every item of this profile.
	var/list/appearance_list = list()
	/// Assoc list of item slot to flag - stores the flags_cover of every item of this profile.
	var/list/flags_cover_list = list()
	/// Assoc list of item slot to boolean - stores whether an item in that slot exists
	var/list/exists_list = list()
	/// Assoc list of item slot to file - stores the lefthand file of the item in that slot
	var/list/lefthand_file_list = list()
	/// Assoc list of item slot to file - stores the righthand file of the item in that slot
	var/list/righthand_file_list = list()
	/// Assoc list of item slot to file - stores the inhand file of the item in that slot
	var/list/inhand_icon_state_list = list()
	/// Assoc list of item slot to file - stores the worn icon file of the item in that slot
	var/list/worn_icon_list = list()
	/// Assoc list of item slot to string - stores the worn icon state of the item in that slot
	var/list/worn_icon_state_list = list()

	var/underwear
	var/undershirt
	var/socks
	var/accent = null
	/// What scars the target had when we copied them, in string form (like persistent scars)
	var/list/stored_scars

/datum/changelingprofile/Destroy()
	qdel(dna)
	LAZYCLEARLIST(stored_scars)
	. = ..()

/datum/changelingprofile/proc/copy_profile(datum/changelingprofile/new_profile)
	new_profile.name = name
	new_profile.protected = protected
	new_profile.dna = new dna.type()
	dna.copy_dna(new_profile.dna)
	new_profile.name_list = name_list.Copy()
	new_profile.appearance_list = appearance_list.Copy()
	new_profile.flags_cover_list = flags_cover_list.Copy()
	new_profile.exists_list = exists_list.Copy()
	new_profile.lefthand_file_list = lefthand_file_list.Copy()
	new_profile.righthand_file_list = righthand_file_list.Copy()
	new_profile.inhand_icon_state_list = inhand_icon_state_list.Copy()
	new_profile.underwear = underwear
	new_profile.undershirt = undershirt
	new_profile.socks = socks
	new_profile.worn_icon_list = worn_icon_list.Copy()
	new_profile.worn_icon_state_list = worn_icon_state_list.Copy()
	new_profile.sprite_sheets_list = sprite_sheets_list.Copy()
	new_profile.stored_scars = stored_scars.Copy()

/datum/antagonist/changeling/xenobio
	name = "Xenobio Changeling"
	give_objectives = FALSE
	show_in_roundend = FALSE //These are here for admin tracking purposes only
	you_are_greet = FALSE

/datum/antagonist/changeling/roundend_report()
	var/list/parts = list()

	var/changelingwin = 1
	if(!owner.current)
		changelingwin = 0

	parts += printplayer(owner)

	//Removed sanity if(changeling) because we -want- a runtime to inform us that the changelings list is incorrect and needs to be fixed.
	parts += "<b>Changeling ID:</b> [changelingID]."
	parts += "<b>Genomes Extracted:</b> [absorbedcount]"
	parts += " "
	if(objectives.len)
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				parts += "<b>Objective #[count]</b>: [objective.explanation_text] <span class='greentext'>Success!</b></span>"
			else
				parts += "<b>Objective #[count]</b>: [objective.explanation_text] [span_redtext("Fail.")]"
				changelingwin = 0
			count++

	if(changelingwin)
		parts += span_greentext("The changeling was successful!")
		SSachievements.unlock_achievement(/datum/achievement/greentext/changelingwin, owner.current.client) //changeling wins, give achivement
	else
		parts += span_redtext("The changeling has failed.")

	return parts.Join("<br>")

/datum/antagonist/changeling/antag_listing_name()
	return ..() + "([changelingID])"

/datum/antagonist/changeling/xenobio/antag_listing_name()
	return ..() + "(Xenobio)"

/datum/antagonist/changeling/get_preview_icon()
	var/icon/final_icon = render_preview_outfit(/datum/outfit/changeling)
	var/icon/split_icon = render_preview_outfit(/datum/outfit/job/engineer)

	final_icon.Shift(WEST, world.icon_size / 2)
	final_icon.Shift(EAST, world.icon_size / 2)

	split_icon.Shift(EAST, world.icon_size / 2)
	split_icon.Shift(WEST, world.icon_size / 2)

	final_icon.Blend(split_icon, ICON_OVERLAY)

	return finish_preview_icon(final_icon)

/datum/antagonist/changeling/ui_data(mob/user)
	var/list/data = list()

	data["true_name"] = changelingID
	data["stolen_antag_info"] = antag_memory
	data["objectives"] = get_objectives()

	return data

/datum/outfit/changeling
	name = "Changeling"

	head = /obj/item/clothing/head/helmet/changeling
	suit = /obj/item/clothing/suit/armor/changeling
	l_hand = /obj/item/melee/arm_blade



/proc/changeling_transform(mob/living/carbon/human/user, datum/changelingprofile/chosen_prof)
	var/datum/dna/chosen_dna = chosen_prof.dna
	user.real_name = chosen_prof.name
	user.underwear = chosen_prof.underwear
	user.undershirt = chosen_prof.undershirt
	user.socks = chosen_prof.socks
	user.mind.accent_name = chosen_prof.accent
	user.mind.RegisterSignal(user, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/mind, handle_speech))

	chosen_dna.transfer_identity(user, 1)
	user.updateappearance(mutcolor_update=1)
	user.update_body()
	user.domutcheck()

	// get rid of any scars from previous changeling-ing
	for(var/i in user.all_scars)
		var/datum/scar/iter_scar = i
		if(iter_scar.fake)
			qdel(iter_scar)

	//vars hackery. not pretty, but better than the alternative.
	for(var/slot in GLOB.slots)
		if(istype(user.vars[slot], GLOB.slot2type[slot]) && !(chosen_prof.exists_list[slot])) //remove unnecessary flesh items
			qdel(user.vars[slot])
			continue

		if((user.vars[slot] && !istype(user.vars[slot], GLOB.slot2type[slot])) || !(chosen_prof.exists_list[slot]))
			continue

		var/obj/item/new_flesh_item
		var/equip = 0
		if(!user.vars[slot])
			var/thetype = GLOB.slot2type[slot]
			equip = 1
			new_flesh_item = new thetype(user)

		else if(istype(user.vars[slot], GLOB.slot2type[slot]))
			new_flesh_item = user.vars[slot]

		new_flesh_item.appearance = chosen_prof.appearance_list[slot]
		new_flesh_item.name = chosen_prof.name_list[slot]
		new_flesh_item.flags_cover = chosen_prof.flags_cover_list[slot]
		new_flesh_item.lefthand_file = chosen_prof.lefthand_file_list[slot]
		new_flesh_item.righthand_file = chosen_prof.righthand_file_list[slot]
		new_flesh_item.item_state = chosen_prof.inhand_icon_state_list[slot]
		new_flesh_item.worn_icon = chosen_prof.worn_icon_list[slot]
		new_flesh_item.worn_icon_state = chosen_prof.worn_icon_state_list[slot]
		new_flesh_item.sprite_sheets = chosen_prof.sprite_sheets_list[slot]

		if(equip)
			user.equip_to_slot_or_del(new_flesh_item, GLOB.slot2slot[slot])
	for(var/stored_scar_line in chosen_prof.stored_scars)
		var/datum/scar/attempted_fake_scar = user.load_scar(stored_scar_line)
		if(attempted_fake_scar)
			attempted_fake_scar.fake = TRUE

	user.regenerate_icons()
