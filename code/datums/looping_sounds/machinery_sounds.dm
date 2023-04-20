/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg'=1,'sound/machines/shower/shower_mid2.ogg'=1,'sound/machines/shower/shower_mid3.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/supermatter
	mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)
	mid_length = 60
	volume = 40
	extra_range = 10

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/hypertorus
	mid_sounds = list('sound/machines/hypertorus/loops/hypertorus_nominal.ogg' = 1)
	mid_length = 60
	volume = 55
	extra_range = 15

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/generator
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 4
	mid_sounds = list('sound/machines/generator/generator_mid1.ogg'=1, 'sound/machines/generator/generator_mid2.ogg'=1, 'sound/machines/generator/generator_mid3.ogg'=1)
	mid_length = 4
	end_sound = 'sound/machines/generator/generator_end.ogg'
	volume = 40

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/looping_sound/deep_fryer
	start_sound = 'sound/machines/fryer/deep_fryer_immerse.ogg' //my immersions
	start_length = 10
	mid_sounds = list('sound/machines/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/fryer/deep_fryer_2.ogg' = 1)
	mid_length = 2
	end_sound = 'sound/machines/fryer/deep_fryer_emerge.ogg'
	volume = 10

/datum/looping_sound/oven
	start_sound = 'sound/machines/oven/oven_loop_start.ogg' //my immersions
	start_length = 12
	mid_sounds = list('sound/machines/oven/oven_loop_mid.ogg' = 1)
	mid_length = 13
	end_sound = 'sound/machines/oven/oven_loop_end.ogg'
	volume = 100

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/grill
	mid_sounds = list('sound/machines/grill/grillsizzle.ogg' = 1)
	mid_length = 18
	volume = 40

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/microwave
	start_sound = 'sound/machines/microwave/microwave-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/microwave/microwave-mid1.ogg'=6, 'sound/machines/microwave/microwave-mid2.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/microwave/microwave-end.ogg'
	volume = 90

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/decontamination_unit
	start_sound = 'sound/machines/decon/decon-down.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/decon/decon-scan1.ogg'=1, 'sound/machines/decon/decon-scan2.ogg'=1)
	mid_length = 18
	volume = 70

/datum/looping_sound/decontamination_unit/emagged
	mid_sounds = list('sound/machines/decon/decon-emagged1.ogg'=10, 'sound/machines/decon/decon-emagged2.ogg'=1)
	mid_length = 25
