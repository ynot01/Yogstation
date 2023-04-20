/obj/effect/swing
	name = "swing"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "swing_small"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/swing/Initialize(mapload, mob/origin, params)
	. = ..()
	var/list/calculated = calculate_projectile_angle_and_pixel_offsets(origin, params)
	pixel_x = calculated[2]
	pixel_y = calculated[3]
	var/matrix/M = new
	M.Turn(calculated[1])
	transform = M
	playsound(get_turf(origin), 'sound/weapons/punchmiss.ogg', 75, 1)
	QDEL_IN(src, 2 SECONDS)

/obj/effect/swing/large
	icon_state = "swing_large"

