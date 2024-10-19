/datum/round_event_control/antagonist/solo/heretic
	antag_flag = ROLE_HERETIC
	tags = list(TAG_COMBAT, TAG_SPOOKY, TAG_MAGICAL)
	antag_datum = /datum/antagonist/heretic
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_RESEARCH_DIRECTOR,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
	)
	weight = 10
	min_players = 15

/datum/round_event_control/antagonist/solo/heretic/roundstart
	name = "Heretics"
	roundstart = TRUE
	earliest_start = 0

/datum/round_event_control/antagonist/solo/heretic/midround
	name = "Midround Heretics"
