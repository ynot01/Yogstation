/datum/station_trait/bananium_shipment
	name = "Bananium Shipment"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	report_message = "Rumors has it that the clown planet has been sending support packages to clowns in this system"
	trait_to_give = STATION_TRAIT_BANANIUM_SHIPMENTS

/datum/station_trait/ian_adventure
	name = "Ian's Adventure"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = FALSE
	report_message = "Ian has gone exploring somewhere in the station."

/datum/station_trait/ian_adventure/on_round_start()
	for(var/mob/living/simple_animal/pet/dog/corgi/dog in GLOB.mob_list)
		if(!(istype(dog, /mob/living/simple_animal/pet/dog/corgi/Ian) || istype(dog, /mob/living/simple_animal/pet/dog/corgi/puppy/ian)))
			continue

		// The extended safety checks at time of writing are about chasms and lava
		// if there are any chasms and lava on stations in the future, woah
		var/turf/current_turf = get_turf(dog)
		var/turf/adventure_turf = find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE)

		// Poof!
		do_smoke(location=current_turf)
		dog.forceMove(adventure_turf)
		do_smoke(location=adventure_turf)


/datum/station_trait/glitched_pdas
	name = "PDA glitch"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 15
	show_in_report = TRUE
	report_message = "Something seems to be wrong with the PDAs issued to you all this shift. Nothing too bad though."
	trait_to_give = STATION_TRAIT_PDA_GLITCHED

/datum/station_trait/announcement_intern
	name = "Announcement Intern"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 0.2
	show_in_report = TRUE
	report_message = "Please be nice to him."
	blacklist = list(/datum/station_trait/announcement_medbot)

/datum/station_trait/announcement_intern/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/intern

/datum/station_trait/announcement_medbot
	name = "Announcement \"System\""
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 0.2
	show_in_report = TRUE
	report_message = "Our announcement system is under scheduled maintenance at the moment. Thankfully, we have a backup."
	blacklist = list(/datum/station_trait/announcement_intern)

/datum/station_trait/announcement_medbot/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/medbot

/datum/station_trait/darkmode
	name = "Dark Mode"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 2
	show_in_report = TRUE
	report_message = "This station has a dark finish."

/datum/station_trait/darkmode/New()
	. = ..()
	for(var/turf/open/floor/plasteel/F in world)
		if(is_station_level(F.z) && (!F.broken && !F.burnt))
			F.icon_regular_floor = 'icons/turf/floors.dmi'
			F.icon_state_regular_floor = "darkfull"
			F.icon = 'icons/turf/floors.dmi'
			F.icon_state = "darkfull"
			CHECK_TICK
