// Rain, in space! Crazy!
/datum/weather/acid_rain/space
	name = "acid rain"
	desc = "Clouds of acid pollute space, and occasionally the station passes through them."

	telegraph_duration = 12 SECONDS
	telegraph_message = span_boldwarning("Thunder rumbles far above. You hear droplets drumming against the glass. Seek shelter.")
	telegraph_sound = null

	weather_message = span_userdanger("<i>Acid starts to coat the outer layers of the station! Get inside!</i>")
	weather_overlay = "acid_rain"
	weather_color = "green"
	weather_duration_lower = 60 SECONDS
	weather_duration_upper = 150 SECONDS
	weather_sound = null

	end_duration = 10 SECONDS
	end_message = span_boldannounce("The downpour gradually slows to a light shower. It should be safe in space now.")
	end_sound = null

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_STATION

	immunity_type = WEATHER_ACID // temp

	var/datum/looping_sound/active_outside_rainstorm/sound_ao = new(list(), FALSE, TRUE)
	var/datum/looping_sound/active_inside_rainstorm/sound_ai = new(list(), FALSE, TRUE)

/datum/weather/acid_rain/space/telegraph()
	. = ..()
	var/list/inside_areas = list()
	var/list/outside_areas = list()
	var/list/eligible_areas = list()
	for (var/z in impacted_z_levels)
		eligible_areas += SSmapping.areas_in_z["[z]"]
	for(var/i in 1 to eligible_areas.len)
		var/area/place = eligible_areas[i]
		if(place.outdoors)
			outside_areas += place
		else
			inside_areas += place
		CHECK_TICK

	sound_ao.output_atoms = outside_areas
	sound_ai.output_atoms = inside_areas

	sound_ao.start()
	sound_ai.start()

/datum/weather/acid_rain/space/wind_down()
	. = ..()
	sound_ao.stop()
	sound_ai.stop()
