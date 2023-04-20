/datum/symptom/radiation
	name = "Ionising Cellular Emission"
	desc = "Causes the host's cells to emit ionising radiation."
	stealth = -3
	resistance = 2
	stage_speed = -1
	transmittable = -1
	level = 6
	severity = 2
	symptom_delay_min = 15
	symptom_delay_max = 30
	var/fastrads = FALSE
	var/radothers = FALSE
	threshold_descs = list(
		"Transmission 12" = "Makes the host irradiate others around them as well.",
		"Stage Speed 8" = "Host takes radiation damage faster."
	)

/datum/symptom/radiation/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalTransmittable() >= 12)
		radothers = TRUE
	if(A.totalStageSpeed() >= 8)
		fastrads = TRUE

/datum/symptom/radiation/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1)
			if(prob(10))
				to_chat(M, span_notice("You feel off..."))
		if(2, 3)
			if(prob(10))
				to_chat(M, span_danger("You feel like the atoms inside you are beginning to split..."))
		if(4, 5)
			if(fastrads)
				radiate(M, 3)
			else
				radiate(M, 10)
			if(radothers && A.stage == 5)
				if(prob(5))
					M.visible_message(span_danger("[M] glows green for a moment!"), \
								 	  span_userdanger("You feel a massive wave of pain flow through you!"))
					radiation_pulse(M, 20)
			

/datum/symptom/radiation/proc/radiate(mob/living/carbon/M, chance)
	if(prob(chance))
		to_chat(M, span_danger("You feel a wave of pain throughout your body!"))
		M.rad_act(RAD_BACKGROUND_RADIATION + 4) // Yogs -- being irradiated actually causes radiation damage
