/datum/round_event_control/antagonist/solo/from_ghosts/wizard
	name = "Ghost Wizard"
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_EXTERNAL, TAG_MAGICAL)
	typepath = /datum/round_event/antagonist/solo/ghost/wizard
	antag_flag = ROLE_WIZARD
	antag_datum = /datum/antagonist/wizard
	restricted_roles = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_SECURITY,
	) // Just to be sure that a wizard getting picked won't ever imply a Captain or HoS not getting drafted
	maximum_antags = 1
	enemy_roles = list(
		JOB_AI,
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_CHAPLAIN,
	)
	required_enemies = 5
	weight = 2
	min_players = 35
	max_occurrences = 1

/datum/round_event_control/antagonist/solo/from_ghosts/wizard/canSpawnEvent(players_amt, allow_magic = FALSE, fake_check = FALSE)
	. = ..()
	if(!.)
		return
	if(!length(GLOB.wizardstart))
		return FALSE

/datum/round_event/antagonist/solo/ghost/wizard

/datum/round_event/antagonist/solo/ghost/wizard/add_datum_to_mind(datum/mind/antag_mind)
	. = ..()
	antag_mind.current.forceMove(pick(GLOB.wizardstart))
