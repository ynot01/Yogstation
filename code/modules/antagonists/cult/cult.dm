#define SUMMON_POSSIBILITIES 3
#define CULT_VICTORY 1
#define CULT_LOSS 0
#define CULT_NARSIE_KILLED -1


/proc/iscultist(mob/living/M)
	if(istype(M, /mob/living/carbon/human/dummy))
		return TRUE
	return M?.mind?.has_antag_datum(/datum/antagonist/cult)

/proc/is_convertable_to_cult(mob/living/M,datum/team/cult/specific_cult)
	if(!istype(M))
		return FALSE
	if(M.mind)
		if(ishuman(M) && (M.mind.holy_role))
			return FALSE
		if(specific_cult && specific_cult.is_sacrifice_target(M.mind))
			return FALSE
		var/mob/living/master = M.mind.enslaved_to?.resolve()
		if(master && !iscultist(master))
			return FALSE
		if(M.mind.unconvertable)
			return FALSE
		if(M.is_convert_antag())
			return FALSE
	else
		return FALSE
	if(HAS_TRAIT(M, TRAIT_MINDSHIELD) || issilicon(M) || isbot(M) || isdrone(M) || ismouse(M) || is_servant_of_ratvar(M) || !M.client)
		return FALSE //can't convert machines, shielded, braindead, mice, or ratvar's dogs
	return TRUE


/datum/antagonist/cult
	name = "Cultist"
	roundend_category = "cultists"
	antagpanel_category = "Cult"
	antag_moodlet = /datum/mood_event/cult
	var/datum/action/innate/cult/comm/communion = new
	var/datum/action/innate/cult/mastervote/vote = new
	var/datum/action/innate/cult/blood_magic/magic = new
	preview_outfit = /datum/outfit/cultist
	job_rank = ROLE_CULTIST
	antag_hud_name = "cult"
	count_towards_antag_cap = TRUE
	var/ignore_implant = FALSE
	var/give_equipment = FALSE
	var/datum/team/cult/cult_team
	var/original_eye_color = "000" //this will store the eye color of the cultist so it can be returned if they get deconverted
	show_to_ghosts = TRUE


/datum/antagonist/cult/get_team()
	return cult_team

/datum/antagonist/cult/create_team(datum/team/cult/new_team)
	if(!new_team)
		//todo remove this and allow admin buttons to create more than one cult
		for(var/datum/antagonist/cult/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.cult_team)
				cult_team = H.cult_team
				return
		cult_team = new /datum/team/cult
		cult_team.setup_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	cult_team = new_team

/datum/antagonist/cult/Destroy()
	QDEL_NULL(communion)
	QDEL_NULL(vote)
	return ..()

/datum/antagonist/cult/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(. && !ignore_implant)
		. = is_convertable_to_cult(new_owner.current,cult_team)
		var/list/no_team_antag = list(
			/datum/antagonist/rev,
			/datum/antagonist/clockcult,
			/datum/antagonist/darkspawn,
			/datum/antagonist/zombie
			)
		for(var/datum/antagonist/NTA in new_owner.antag_datums)
			if(NTA.type in no_team_antag)
				return FALSE

/datum/antagonist/cult/greet()
	to_chat(owner.current, "<B><font size=3 color=red>You are a member of the cult!</font><B>")
	to_chat(owner.current, "<b>If you are new to Blood Cult, please review <a href='https://forums.yogstation.net/threads/how-to-newbloodcult-for-hyperdunces.16896/'>this tutorial</a>!<b>") //Yogs
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/bloodcult.ogg', 100, FALSE, pressure_affected = FALSE)//subject to change
	owner.announce_objectives()

/datum/antagonist/cult/on_gain()
	. = ..()
	var/mob/living/current = owner.current
	if(ishuman(current))
		var/mob/living/carbon/human/H = current
		original_eye_color = H.eye_color
	if(give_equipment)
		equip_cultist(TRUE)
	SSgamemode.cult += owner // Only add after they've been given objectives
	current.log_message("has been converted to the cult of Nar'sie!", LOG_ATTACK, color="#960000")

	if(cult_team.blood_target && cult_team.blood_target_image && current.client)
		current.client.images += cult_team.blood_target_image

/datum/antagonist/cult/on_removal()
	SSgamemode.cult -= owner
	if(!silent)
		owner.current.visible_message("[span_deconversion_message("[owner.current] looks like [owner.current.p_theyve()] just reverted to [owner.current.p_their()] old faith!")]", null, null, null, owner.current)
		to_chat(owner.current, span_userdanger("An unfamiliar white light flashes through your mind, cleansing the taint of the Geometer and all your memories as her servant."))
		owner.current.log_message("has renounced the cult of Nar'sie!", LOG_ATTACK, color="#960000")
	if(cult_team.blood_target && cult_team.blood_target_image && owner.current.client)
		owner.current.client.images -= cult_team.blood_target_image

	return ..()

/*
/datum/antagonist/cult/get_preview_icon()
	var/icon/icon = render_preview_outfit(preview_outfit)

	// The longsword is 64x64, but getFlatIcon crunches to 32x32.
	// So I'm just going to add it in post, screw it.

	// Center the dude, because item icon states start from the center.
	// This makes the image 64x64.
	icon.Crop(-15, -15, 48, 48)

	var/obj/item/melee/cultblade/longsword = new
	icon.Blend(icon(longsword.lefthand_file, longsword.item_state), ICON_OVERLAY)
	qdel(longsword)

	// Move the guy back to the bottom left, 32x32.
	icon.Crop(17, 17, 48, 48)

	return finish_preview_icon(icon)
*/
/datum/antagonist/cult/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/cult1 = new
	var/mob/living/carbon/human/dummy/consistent/cult2 = new

	var/icon/final_icon = render_preview_outfit(/datum/outfit/cultist/leader, cult1)
	var/icon/teammate = render_preview_outfit(/datum/outfit/cultist/follower, cult2)
	teammate.Blend(rgb(128, 128, 128, 128), ICON_MULTIPLY)

	final_icon.Blend(teammate, ICON_OVERLAY, -world.icon_size / 4, 0)
	final_icon.Blend(teammate, ICON_OVERLAY, world.icon_size / 4, 0)

	qdel(cult1)
	qdel(cult2)

	return finish_preview_icon(final_icon)

/datum/outfit/cultist/leader
	suit = /obj/item/clothing/suit/hooded/cultrobes/berserker
	shoes = /obj/item/clothing/shoes/cult/alt
	head = /obj/item/clothing/head/hooded/berserkerhood
	glasses = /obj/item/clothing/glasses/hud/health/night/cultblind
	r_hand = /obj/item/melee/cultblade
	l_hand = /obj/item/shield/mirror

/datum/outfit/cultist/follower
	suit = /obj/item/clothing/suit/cultrobes/alt
	shoes = /obj/item/clothing/shoes/cult/alt
	head = /obj/item/clothing/head/culthood/alt
	glasses = /obj/item/clothing/glasses/hud/health/night/cultblind
	r_hand = /obj/item/melee/cultblade

/datum/antagonist/cult/proc/equip_cultist(metal=TRUE)
	var/mob/living/carbon/H = owner.current
	if(!istype(H))
		return
	. += cult_give_item(/obj/item/melee/cultblade/dagger, owner.current)
	if(metal)
		. += cult_give_item(/obj/item/stack/sheet/runed_metal/ten, owner.current)
	to_chat(owner, "These will help you start the cult on this station. Use them well, and remember - you are not the only one.</span>")


/datum/antagonist/cult/proc/cult_give_item(obj/item/item_path, mob/living/carbon/human/current_mob)
	var/list/slots = list(
		"backpack" = ITEM_SLOT_BACKPACK,
		"left pocket" = ITEM_SLOT_LPOCKET,
		"right pocket" = ITEM_SLOT_RPOCKET
	)

	var/T = new item_path(current_mob)
	var/item_name = initial(item_path.name)
	var/where = current_mob.equip_in_one_of_slots(T, slots)
	if(!where)
		to_chat(current_mob, span_userdanger("Unfortunately, you weren't able to get a [item_name]. This is very bad and you should adminhelp immediately (press F1)."))
		return FALSE
	else
		to_chat(current_mob, span_danger("You have a [item_name] in your [where]."))
		if(where == "backpack")
			SEND_SIGNAL(current_mob.back, COMSIG_TRY_STORAGE_SHOW, current_mob)
		return TRUE

/datum/antagonist/cult/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	handle_clown_mutation(current, mob_override ? null : "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
	current.faction |= "cult"
	current.grant_language(/datum/language/narsie, TRUE, TRUE, LANGUAGE_CULTIST)
	if(!cult_team.cult_master)
		vote.Grant(current)
	communion.Grant(current)
	if(ishuman(current))
		magic.Grant(current)
	current.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)
	if(cult_team.cult_risen)
		cult_team.rise(current)
		if(cult_team.cult_ascendent)
			cult_team.ascend(current)

	ADD_TRAIT(current, TRAIT_UNHOLY, type)
	add_team_hud(current)

/datum/antagonist/cult/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	current.faction -= "cult"
	current.remove_language(/datum/language/narsie, TRUE, TRUE, LANGUAGE_CULTIST)
	vote.Remove(current)
	communion.Remove(current)
	magic.Remove(current)
	current.clear_alert("bloodsense")
	REMOVE_TRAIT(current, TRAIT_UNHOLY, type)
	if(ishuman(current))
		var/mob/living/carbon/human/H = current
		H.eye_color = original_eye_color
		H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		REMOVE_TRAIT(H, CULT_EYES, null)
		H.remove_overlay(HALO_LAYER)
		H.updateappearance()

/datum/antagonist/cult/admin_add(datum/mind/new_owner,mob/admin)
	give_equipment = FALSE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has cult'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has cult'ed [key_name(new_owner)].")

/datum/antagonist/cult/admin_remove(mob/user)
	if(!owner.current)
		return
	message_admins("[key_name_admin(user)] has decult'ed [key_name_admin(owner)].")
	log_admin("[key_name(user)] has decult'ed [key_name(owner)].")
	owner.current.remove_cultist(silent=TRUE)

/datum/antagonist/cult/get_admin_commands()
	. = ..()
	.["Dagger"] = CALLBACK(src, PROC_REF(admin_give_dagger))
	.["Dagger and Metal"] = CALLBACK(src, PROC_REF(admin_give_metal))
	.["Remove Dagger and Metal"] = CALLBACK(src, PROC_REF(admin_take_all))

/datum/antagonist/cult/proc/admin_give_dagger(mob/admin)
	if(!equip_cultist(metal=FALSE))
		to_chat(admin, span_danger("Spawning dagger failed!"))

/datum/antagonist/cult/proc/admin_give_metal(mob/admin)
	if (!equip_cultist(metal=TRUE))
		to_chat(admin, span_danger("Spawning runed metal failed!"))

/datum/antagonist/cult/proc/admin_take_all(mob/admin)
	var/mob/living/current = owner.current
	for(var/o in current.get_all_contents())
		if(istype(o, /obj/item/melee/cultblade/dagger) || istype(o, /obj/item/stack/sheet/runed_metal))
			qdel(o)

/datum/antagonist/cult/master
	ignore_implant = TRUE
	show_in_antagpanel = FALSE //Feel free to add this later
	antag_hud_name = "cultmaster"
	var/datum/action/innate/cult/master/finalreck/reckoning = new
	var/datum/action/innate/cult/master/cultmark/bloodmark = new
	var/datum/action/innate/cult/master/pulse/throwing = new

/datum/antagonist/cult/master/Destroy()
	QDEL_NULL(reckoning)
	QDEL_NULL(bloodmark)
	QDEL_NULL(throwing)
	return ..()

/datum/antagonist/cult/master/greet()
	to_chat(owner.current, "[span_cultlarge("You are the cult's Master")]. As the cult's Master, you have a unique title and loud voice when communicating, are capable of marking \
	targets, such as a location or a noncultist, to direct the cult to them, and, finally, you are capable of summoning the entire living cult to your location <b><i>once</i></b>.")
	to_chat(owner.current, "Use these abilities to direct the cult to victory at any cost.")

/datum/antagonist/cult/master/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	if(!cult_team.reckoning_complete)
		reckoning.Grant(current)
	bloodmark.Grant(current)
	throwing.Grant(current)
	current.update_mob_action_buttons()
	current.apply_status_effect(/datum/status_effect/cult_master)
	if(cult_team.cult_risen)
		cult_team.rise(current)
		if(cult_team.cult_ascendent)
			cult_team.ascend(current)
	add_team_hud(current, /datum/antagonist/cult)

/datum/antagonist/cult/master/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	reckoning.Remove(current)
	bloodmark.Remove(current)
	throwing.Remove(current)
	current.update_mob_action_buttons()
	current.remove_status_effect(/datum/status_effect/cult_master)

	if(ishuman(current))
		var/mob/living/carbon/human/H = current
		H.eye_color = original_eye_color
		H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		REMOVE_TRAIT(H, CULT_EYES, null)
		H.remove_overlay(HALO_LAYER)
		H.updateappearance()

/datum/team/cult
	name = "Cult"

	///The blood mark target
	var/atom/blood_target
	///Image of the blood mark target
	var/image/blood_target_image
	///Timer for the blood mark expiration
	var/blood_target_reset_timer

	var/cult_vote_called = FALSE
	var/mob/living/cult_master
	var/reckoning_complete = FALSE
	var/cult_risen = FALSE
	var/cult_ascendent = FALSE

	var/cult_got_mulligan = FALSE
	var/cult_failed = FALSE
	///list of cultists just before summoning Narsie
	var/list/true_cultists = list()

/datum/team/cult/proc/check_size()
	if(cult_ascendent)
		return
	var/alive = 0
	var/cultplayers = 0
	for(var/I in GLOB.player_list)
		var/mob/M = I
		if(M.stat != DEAD)
			if(iscultist(M))
				++cultplayers
			else
				++alive
	var/ratio = cultplayers/alive
	if(ratio > CULT_RISEN && !cult_risen)
		for(var/datum/mind/B in members)
			if(B.current)
				SEND_SOUND(B.current, 'sound/hallucinations/i_see_you2.ogg')
				to_chat(B.current, span_cultlarge("The veil weakens as your cult grows, your eyes begin to glow..."))
				addtimer(CALLBACK(src, PROC_REF(rise), B.current), 20 SECONDS)
		cult_risen = TRUE

	if(ratio > CULT_ASCENDENT && !cult_ascendent)
		for(var/datum/mind/B in members)
			if(B.current)
				SEND_SOUND(B.current, 'sound/hallucinations/im_here1.ogg')
				to_chat(B.current, "<span class='cultlarge'>Your cult is ascendent and the red harvest approaches - you cannot hide your true nature for much longer!!")
				addtimer(CALLBACK(src, PROC_REF(ascend), B.current), 20 SECONDS)
		cult_ascendent = TRUE


/datum/team/cult/proc/rise(cultist)
	if(ishuman(cultist))
		var/mob/living/carbon/human/H = cultist
		H.eye_color = "f00"
		H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		ADD_TRAIT(H, CULT_EYES, CULT_TRAIT)
		H.updateappearance()

/datum/team/cult/proc/ascend(cultist)
	if(ishuman(cultist))
		var/mob/living/carbon/human/H = cultist
		new /obj/effect/temp_visual/cult/sparks(get_turf(H), H.dir)
		var/istate = pick("halo1","halo2","halo3","halo4","halo5","halo6")
		var/mutable_appearance/new_halo_overlay = mutable_appearance('icons/effects/32x64.dmi', istate, -HALO_LAYER)
		H.overlays_standing[HALO_LAYER] = new_halo_overlay
		H.apply_overlay(HALO_LAYER)

/datum/team/cult/proc/make_image(datum/objective/sacrifice/sac_objective)
	var/datum/job/job_of_sacrifice = sac_objective.target.assigned_role
	var/datum/preferences/prefs_of_sacrifice = sac_objective.target.current.client.prefs
	var/icon/reshape = get_flat_human_icon(null, SSjob.GetJob(job_of_sacrifice), prefs_of_sacrifice, list(SOUTH))
	reshape.Shift(SOUTH, 4)
	reshape.Shift(EAST, 1)
	reshape.Crop(7,4,26,31)
	reshape.Crop(-5,-3,26,30)
	sac_objective.sac_image = reshape

/datum/team/cult/proc/setup_objectives()
	var/datum/objective/sacrifice/sacrifice_objective = new
	sacrifice_objective.team = src
	sacrifice_objective.find_target()
	objectives += sacrifice_objective

	var/datum/objective/eldergod/summon_objective = new
	summon_objective.team = src
	objectives += summon_objective

/datum/team/cult/proc/get_sacrifice_target(allow_convertable = TRUE)
	var/list/target_candidates = list()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player.mind && !player.mind.has_antag_datum(/datum/antagonist/cult) && !is_convertable_to_cult(player) && player.stat != DEAD)
			// The chaplain gets triple relative weighting
			if (player.mind.holy_role)
				target_candidates[player.mind] = 3
			else
				target_candidates[player.mind] = 1

	if(target_candidates.len == 0 && allow_convertable)
		message_admins("Cult Sacrifice: Could not find unconvertible target, checking for convertible target.")
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.mind && !player.mind.has_antag_datum(/datum/antagonist/cult) && player.stat != DEAD)
				target_candidates[player.mind] = 1

	if(target_candidates.len != 0)
		return pickweight(target_candidates)
	else
		return null

// Checks if the current sacrifice target is still valid and gives the cult
// their mulligan target if it isn't.  If the cult's mulligan target also fails,
// returns FALSE; in that case, the round should end immediately.
/datum/team/cult/proc/check_sacrifice_status()
	var/datum/objective/sacrifice/sac_objective = locate() in objectives
	if (!sac_objective)
		message_admins("A cult somehow doesn't have a sacrifice objective at all, causing the round to end.")
		return FALSE

	// The point of this function is to detect and gracefully recover from the
	// case that the target has their body destroyed completely without it being
	// sacrificed.  Thus, if the target has their body or was sacrificed, no
	// problem.
	if (sac_objective.sacced)
		return TRUE

	var/mob/living/carbon/human/body = sac_objective.target.current
	if (istype(body))
		return TRUE

	var/old_target = sac_objective.target
	if (!cult_got_mulligan)
		// If the cult was on its first sacrifice target, try to generate a new
		// target that can't be converted.
		var/datum/mind/new_target = get_sacrifice_target(FALSE)
		if (new_target != null) // If no valid targets exist, no mulligan
			cult_got_mulligan = TRUE

			sac_objective.target = new_target
			sac_objective.update_explanation_text()

			var/datum/job/sacjob = SSjob.GetJob(sac_objective.target.assigned_role)
			var/datum/preferences/sacface = sac_objective.target.current.client.prefs
			var/icon/reshape = get_flat_human_icon(null, sacjob, sacface, list(SOUTH))
			reshape.Shift(SOUTH, 4)
			reshape.Shift(EAST, 1)
			reshape.Crop(7,4,26,31)
			reshape.Crop(-5,-3,26,30)

			// Updates on its own every tick
			sac_objective.sac_image = reshape

			var/list/adjectives = list("sniveling", "cowardly", "worthless", "loyalist", "unhygenic")
			var/list/nouns = list("dog", "maggot", "ant", "cow", "clown")
			var/adjective = pick(adjectives)
			var/noun = pick(nouns)
			for (var/datum/mind/M in members)
				to_chat(M.current, span_cultlarge("The Geometer is displeased with your failure to sacrifice the [adjective] [noun] [old_target]."))

				// Handle the case where the new target is jobless
				var/job = new_target.current.job
				if (job == null)
					job = "disgusting NEET"
				to_chat(M.current, "<span class='cultlarge'>You will be given one more chance to serve by sacrificing the [job], [new_target].")
				to_chat(M.current, span_narsiesmall("Do not fail me again."))

			return TRUE
	// At this point, the cultists have squandered their mulligan and the round is over.
	for (var/datum/mind/M in members)
		to_chat(M.current, span_narsiesmall("I will not be worshipped by failures."))
		// Nar'sie is sick of your crap
		M.current.reagents.add_reagent(/datum/reagent/toxin/heparin, 100)
		M.current.reagents.add_reagent(/datum/reagent/toxin/initropidril, 100)
	cult_failed = TRUE
	return FALSE

/datum/objective/sacrifice
	var/sacced = FALSE
	var/sac_image

/// Unregister signals from the old target so it doesn't cause issues when sacrificed of when a new target is found.
/datum/objective/sacrifice/proc/clear_sacrifice()
	if(!target)
		return
	UnregisterSignal(target, COMSIG_MIND_TRANSFERRED)
	if(target.current)
		UnregisterSignal(target.current, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	target = null

/datum/objective/sacrifice/find_target(dupe_search_range, list/blacklist)
	clear_sacrifice()
	if(!istype(team, /datum/team/cult))
		return
	var/datum/team/cult/cult = team
	var/list/target_candidates = list()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(!player.mind)
			continue
		if(player.mind.has_antag_datum(/datum/antagonist/cult))
			continue
		if(is_convertable_to_cult(player))
			continue
		if(isipc(player))
			continue
		if(player.stat == DEAD)
			continue
		target_candidates += player.mind
	if(target_candidates.len == 0)
		message_admins("Cult Sacrifice: Could not find unconvertible target, checking for convertible target.")
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(!player.mind)
				continue
			if(player.mind.has_antag_datum(/datum/antagonist/cult))
				continue
			if(isipc(player))
				continue
			if(player.stat == DEAD)
				continue
			target_candidates += player.mind
	listclearnulls(target_candidates)
	if(LAZYLEN(target_candidates))
		target = pick(target_candidates)
		update_explanation_text()
		// Register a bunch of signals to both the target mind and its body
		// to stop cult from softlocking everytime the target is deleted before being actually sacrificed.
		RegisterSignal(target, COMSIG_MIND_TRANSFERRED, PROC_REF(on_mind_transfer))
		RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
		RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))
	else
		message_admins("Cult Sacrifice: Could not find unconvertible or convertible target. WELP!")
		sacced = TRUE // Prevents another hypothetical softlock. This basically means every PC is a cultist.
	if(!sacced)
		cult.make_image(src)
	for(var/datum/mind/mind in cult.members)
		if(mind.current)
			mind.current.clear_alert("bloodsense")
			mind.current.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)

/datum/objective/sacrifice/proc/on_target_body_del()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(find_target))

/datum/objective/sacrifice/proc/on_mind_transfer(datum/source, mob/previous_body)
	SIGNAL_HANDLER
	//If, for some reason, the mind was transferred to a ghost (better safe than sorry), find a new target.
	if(!isliving(target.current))
		INVOKE_ASYNC(src, PROC_REF(find_target))
		return
	UnregisterSignal(previous_body, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
	RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))

/datum/objective/sacrifice/proc/on_possible_mindswap(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(target.current, list(COMSIG_QDELETING, COMSIG_MOB_MIND_TRANSFERRED_INTO))
	//we check if the mind is bodyless only after mindswap shenanigeans to avoid issues.
	addtimer(CALLBACK(src, PROC_REF(do_we_have_a_body)), 0 SECONDS)

/datum/objective/sacrifice/proc/do_we_have_a_body()
	if(!target.current) //The player was ghosted and the mind isn't probably going to be transferred to another mob at this point.
		find_target()
		return
	RegisterSignal(target.current, COMSIG_QDELETING, PROC_REF(on_target_body_del))
	RegisterSignal(target.current, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(on_possible_mindswap))

/datum/objective/sacrifice/check_completion()
	return sacced || completed

/datum/objective/sacrifice/update_explanation_text()
	if(target)
		explanation_text = "Sacrifice [target], the [target.assigned_role] via invoking a Sacrifice rune with [target.p_them()] on it and three acolytes around it."
	else
		explanation_text = "The veil has already been weakened here, proceed to the final objective."

/datum/objective/eldergod
	var/summoned = FALSE
	var/killed = FALSE
	var/list/summon_spots = list()

/datum/objective/eldergod/New()
	..()
	var/sanity = 0
	while(summon_spots.len < SUMMON_POSSIBILITIES && sanity < 100)
		var/area/summon = pick(GLOB.areas - summon_spots)
		if(summon && is_station_level(summon.z) && summon.valid_territory)
			summon_spots += summon
		sanity++
	update_explanation_text()

/datum/objective/eldergod/update_explanation_text()
	explanation_text = "Summon Nar'sie by invoking the rune 'Summon Nar'sie'. The summoning can only be accomplished in [english_list(summon_spots)] - where the veil is weak enough for the ritual to begin."

/datum/objective/eldergod/check_completion()
	if(killed)
		return CULT_NARSIE_KILLED // You failed so hard that even the code went backwards.
	return summoned || completed

/datum/team/cult/proc/check_cult_victory()
	for(var/datum/objective/O in objectives)
		if(O.check_completion() == CULT_NARSIE_KILLED)
			return CULT_NARSIE_KILLED
		else if(!O.check_completion())
			return CULT_LOSS
	return CULT_VICTORY

/datum/team/cult/roundend_report()
	var/list/parts = list()

	var/victory = check_cult_victory()

	if(victory == CULT_NARSIE_KILLED) // Epic failure, you summoned your god and then someone killed it.
		parts += "<span class='redtext big'>Nar'sie has been killed! The cult will haunt the universe no longer!</span>"
	else if(victory)
		parts += "<span class='greentext big'>The cult has succeeded! Nar'Sie has snuffed out another torch in the void!</span>"
	else
		parts += "<span class='redtext big'>The staff managed to stop the cult! Dark words and heresy are no match for Nanotrasen's finest!</span>"

	if(objectives.len)
		parts += "<b>The cultists' objectives were:</b>"
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				parts += "<b>Objective #[count]</b>: [objective.explanation_text] [span_greentext("Success!")]"
			else
				parts += "<b>Objective #[count]</b>: [objective.explanation_text] [span_redtext("Fail.")]"
			count++

	if(members.len)
		parts += span_header("The cultists were:")
		if(length(true_cultists))
			parts += printplayerlist(true_cultists)
		else
			parts += printplayerlist(members)

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/team/cult/proc/is_sacrifice_target(datum/mind/mind)
	for(var/datum/objective/sacrifice/sac_objective in objectives)
		if(mind == sac_objective.target)
			return TRUE
	return FALSE

/datum/team/cult/is_gamemode_hero()
	return SSgamemode.name == "cult"

/// Sets a blood target for the cult.
/datum/team/cult/proc/set_blood_target(atom/new_target, mob/marker, duration = 90 SECONDS)
	if(QDELETED(new_target))
		CRASH("A null or invalid target was passed to set_blood_target.")

	if(blood_target_reset_timer)
		return FALSE

	blood_target = new_target
	RegisterSignal(blood_target, COMSIG_QDELETING, PROC_REF(unset_blood_target_and_timer))
	var/area/target_area = get_area(new_target)

	blood_target_image = image('icons/effects/mouse_pointers/cult_target.dmi', new_target, "glow", ABOVE_MOB_LAYER)
	blood_target_image.appearance_flags = RESET_COLOR
	blood_target_image.pixel_x = -new_target.pixel_x
	blood_target_image.pixel_y = -new_target.pixel_y

	for(var/datum/mind/cultist as anything in members)
		if(!cultist.current)
			continue
		if(cultist.current.stat == DEAD || !cultist.current.client)
			continue

		to_chat(cultist.current, span_bold(span_cultlarge("[marker] has marked [blood_target] in the [target_area.name] as the cult's top priority, get there immediately!")))
		SEND_SOUND(cultist.current, sound(pick('sound/hallucinations/over_here2.ogg','sound/hallucinations/over_here3.ogg'), 0, 1, 75))
		cultist.current.client.images += blood_target_image

	blood_target_reset_timer = addtimer(CALLBACK(src, PROC_REF(unset_blood_target)), duration, TIMER_STOPPABLE)
	return TRUE

/// Unsets out blood target, clearing the images from all the cultists.
/datum/team/cult/proc/unset_blood_target()
	blood_target_reset_timer = null

	for(var/datum/mind/cultist as anything in members)
		if(!cultist.current)
			continue
		if(cultist.current.stat == DEAD || !cultist.current.client)
			continue

		if(QDELETED(blood_target))
			to_chat(cultist.current, span_bold(span_cultlarge("The blood mark's target is lost!")))
		else
			to_chat(cultist.current, span_bold(span_cultlarge("The blood mark has expired!")))
		cultist.current.client.images -= blood_target_image

	UnregisterSignal(blood_target, COMSIG_QDELETING)
	blood_target = null

	QDEL_NULL(blood_target_image)

/// Unsets our blood target when they get deleted.
/datum/team/cult/proc/unset_blood_target_and_timer(datum/source)
	SIGNAL_HANDLER

	deltimer(blood_target_reset_timer)
	unset_blood_target()

/datum/outfit/cultist
	name = "Cultist (Preview only)"

	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/yogs/armor/sith_suit
	shoes = /obj/item/clothing/shoes/cult/alt
	r_hand = /obj/item/melee/blood_magic/stun

/datum/outfit/cultist/post_equip(mob/living/carbon/human/H, visualsOnly)
	H.eye_color = BLOODCULT_EYE
	H.update_body()

	var/obj/item/clothing/suit/hooded/hooded = locate() in H
	if(!isdummy(H))
		hooded.MakeHood() // This is usually created on Initialize, but we run before atoms
		hooded.ToggleHood()



	
/mob/living/proc/add_cultist(stun, equip = FALSE, datum/team/cult/cult_team = null)
	if (!istype(mind))
		return FALSE

	var/datum/antagonist/cult/new_cultist = new()
	new_cultist.give_equipment = equip

	if(mind.add_antag_datum(new_cultist,cult_team))
		if(stun)
			Unconscious(100)
		return TRUE

/mob/living/proc/remove_cultist(silent, stun)
	if (!istype(mind))
		return FALSE

	var/datum/antagonist/cult/cult_datum = mind.has_antag_datum(/datum/antagonist/cult)
	if(!cult_datum)
		return FALSE
	cult_datum.silent = silent
	cult_datum.on_removal()
	if(stun)
		Unconscious(100)
	return TRUE
