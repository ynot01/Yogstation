/obj/item/balloon
	name = "balloon"
	desc = "A balloon!"
	icon = 'yogstation/icons/obj/objects.dmi'
	icon_state = "bal_regular"

/obj/item/balloon/proc/random_balloon_color()
	return pick(COLOR_RED, COLOR_GREEN, COLOR_BLUE, COLOR_YELLOW, COLOR_CYAN, COLOR_PURPLE, COLOR_ORANGE)

/obj/item/balloon/Initialize()
	. = ..()
	color = random_balloon_color()

/obj/item/balloon/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.sharpness == SHARP_POINTY)
		user.visible_message("[user] pops the balloon!", "You pop the balloon")
		playsound(src, 'sound/weapons/gunshot.ogg', 100, 1)
		new /obj/effect/decal/cleanable/generic(get_turf(src))
		qdel(src)

/obj/item/balloonbox
	name = "assorted balloons"
	desc = "An assorted bag of balloons"
	icon = 'yogstation/icons/obj/objects.dmi'
	icon_state = "bal_bag"
	var/uses = 7

/obj/item/balloonbox/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/balloonbox/attack_self(mob/user)
	if(!uses)
		to_chat(user, span_notice("Oh no! There are no balloons left!"))
		qdel(src)
		return
	var/list/balloons = list(
		"Regular" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_regular"),
		"Happy" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_happy"),
		"Dog" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_dog"),
		"Flower" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_flower"),
		"Bomb" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_bomb"),
		"Demon" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_demon"),
		"Sword" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_sword"),
		"Monkey" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_monkey"),
		"Donkey" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_donkey"),
		"Snake" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_snake"),
		"Girafe" = image(icon = 'yogstation/icons/obj/objects.dmi', icon_state = "bal_girafe"),
		)
	var/choice = show_radial_menu(user, src, balloons, tooltips = TRUE)
	if(!check_menu(user))
		return
	if(choice)
		var/obj/item/balloon/BB = new(get_turf(src))
		var/image/I = balloons[choice]
		BB.icon_state = I.icon_state
		uses--
		if(!uses)
			to_chat(user, span_notice("Oh no! There are no balloons left!"))
			qdel(src)
		else
			to_chat(user, span_notice("There is [uses] [uses == 1 ? "balloon" : "balloons"] left!"))

/obj/item/balloonbox/examine(mob/user)
	. = ..()
	. += span_notice("It has [uses] uses left.")
