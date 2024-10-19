/datum/round_event_control/antagonist/solo/changeling
	antag_flag = ROLE_CHANGELING
	tags = list(TAG_COMBAT, TAG_ALIEN)
	antag_datum = /datum/antagonist/changeling
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_RESEARCH_DIRECTOR,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
	)
	min_players = 15
	weight = 9
	shared_occurence_type = SHARED_CHANGELING

/datum/round_event_control/antagonist/solo/changeling/roundstart
	name = "Changelings"
	roundstart = TRUE
	title_icon = "changeling"
	earliest_start = 0
	maximum_antags = 1

/datum/round_event_control/antagonist/solo/changeling/midround
	name = "Genome Awakening (Changelings)"
	max_occurrences = 2
