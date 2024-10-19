/datum/round_event_control/tzimisce
	name = "Spawn Tzimisce"
	typepath = /datum/round_event/ghost_role/tzimisce
	max_occurrences = 2
	min_players = 25
	earliest_start = 45 MINUTES
	track = EVENT_TRACK_ROLESET
	tags = list(TAG_SPOOKY, TAG_MAGICAL, TAG_COMBAT)
	description = "spawns a tzimisce bloodsucker from ghost roles."

/datum/round_event_control/tzimisce/canSpawnEvent(players_amt, allow_magic, fake_check)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/all_players in GLOB.player_list)
			if(IS_BLOODSUCKER(all_players) || IS_MONSTERHUNTER(all_players))
				return TRUE
		return FALSE

/datum/round_event/ghost_role/tzimisce
	minimum_required = 1
	role_name = "Tzimisce"
	fakeable = FALSE

/datum/round_event/ghost_role/tzimisce/spawn_role()
	//selecting a spawn_loc
	if(!SSjob.latejoin_trackers.len)
		return MAP_ERROR

	//selecting a candidate player
	var/list/candidates = get_candidates(ROLE_BLOODSUCKER, null, ROLE_BLOODSUCKER)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected_candidate = pick_n_take(candidates)
	var/key = selected_candidate.key

	var/datum/mind/tzimisce_mind = create_tzimisce_mind(key)
	tzimisce_mind.active = TRUE

	var/mob/living/carbon/human/tzimisce = spawn_event_tzimisce()
	tzimisce_mind.transfer_to(tzimisce)
	tzimisce_mind.add_antag_datum(/datum/antagonist/bloodsucker)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = tzimisce.mind.has_antag_datum(/datum/antagonist/bloodsucker)
	bloodsuckerdatum.antag_hud_name = "tzimisce"
	bloodsuckerdatum.add_team_hud(tzimisce)
	bloodsuckerdatum.bloodsucker_level_unspent += round(world.time / (15 MINUTES), 1)
	bloodsuckerdatum.my_clan = new /datum/bloodsucker_clan/tzimisce(bloodsuckerdatum)
	bloodsuckerdatum.owner.announce_objectives()

	spawned_mobs += tzimisce
	message_admins("[ADMIN_LOOKUPFLW(tzimisce)] has been made into a tzimisce bloodsucker an event.")
	log_game("[key_name(tzimisce)] was spawned as a tzimisce bloodsucker by an event.")
	var/datum/job/jobdatum = SSjob.GetJob(pick("Assistant", "Botanist", "Station Engineer", "Medical Doctor", "Scientist", "Cargo Technician", "Cook"))
	if(SSshuttle.arrivals)
		SSshuttle.arrivals.QueueAnnounce(tzimisce, jobdatum.title)
	tzimisce_mind.assigned_role = jobdatum.title //sets up the manifest properly
	jobdatum.equip(tzimisce) 
	var/obj/item/card/id/id = tzimisce.get_item_by_slot(ITEM_SLOT_ID)
	if(!istype(id)) //pda on ID slot
		var/obj/item/modular_computer/tablet/PDA = tzimisce.get_item_by_slot(ITEM_SLOT_ID)
		var/obj/item/computer_hardware/card_slot/card_slot2 = PDA.all_components[MC_CARD2]
		var/obj/item/computer_hardware/card_slot/card_slot = PDA.all_components[MC_CARD]
		id = card_slot2?.stored_card || card_slot?.stored_card //check both slots, priority on 2nd
	id.assignment = jobdatum.title
	id.originalassignment = jobdatum.title
	id.update_label()
	GLOB.data_core.manifest_inject(tzimisce, force = TRUE)
	tzimisce.update_move_intent_slowdown() //prevents you from going super duper fast
	announce_to_ghosts(tzimisce)
	return SUCCESSFUL_SPAWN


/datum/round_event/ghost_role/tzimisce/proc/spawn_event_tzimisce()
	var/mob/living/carbon/human/new_tzimisce = new()
	SSjob.SendToLateJoin(new_tzimisce)
	new_tzimisce.randomize_human_appearance(~(RANDOMIZE_SPECIES))
	new_tzimisce.dna.update_dna_identity()
	return new_tzimisce

/datum/round_event/ghost_role/tzimisce/proc/create_tzimisce_mind(key)
	var/datum/mind/tzimisce_mind = new /datum/mind(key)
	tzimisce_mind.special_role = ROLE_BLOODSUCKER
	return tzimisce_mind
