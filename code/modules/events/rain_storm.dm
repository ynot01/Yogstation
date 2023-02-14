/datum/round_event_control/rain_storm
	name = "Rain Storm"
	typepath = /datum/round_event/rain_storm
	max_occurrences = 2

/datum/round_event/rain_storm/announce(fake)
	priority_announce("Your station is about to encounter an acidic cloud. Please return all crew members indoors.", "Anomaly Alert")

/datum/round_event/rain_storm/start()
	SSweather.run_weather(/datum/weather/acid_rain/space)
