/obj/structure/world_anvil
	name = "World Anvil"
	desc = "An anvil that is connected through lava reservoirs to the core of lavaland. Whoever was using this last was creating something powerful."
	icon = 'icons/obj/lavaland/anvil.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	pass_flags = LETPASSTHROW
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/forge_charges = 0
	var/obj/item/gps/internal //so we can find it!

/obj/structure/world_anvil/moonanvil
	name = "Moon Anvil"
	desc = "An anvil that is connected through plasma reservoirs to the core of icemoon. It's cool to the touch, and seems like it was once used by someone powerful."
	icon = 'icons/obj/ice_moon/moonanvil.dmi'
	icon_state = "moonanvil"

/obj/item/gps/internal/world_anvil
	icon_state = null
	gpstag = "Tempered Signal"
	desc = "An ancient anvil rests at this location."
	invisibility = 100

/obj/structure/world_anvil/Initialize(mapload)
	. = ..()
	internal = new /obj/item/gps/internal/world_anvil(src)
	AddElement(/datum/element/climbable)

/obj/structure/world_anvil/Destroy()
	QDEL_NULL(internal)
	. = ..()

/obj/structure/world_anvil/update_icon(updates=ALL)
	. = ..()
	icon_state = forge_charges > 0 ? "anvil_a" : "anvil"
	if(forge_charges > 0)
		set_light(4,1,LIGHT_COLOR_ORANGE)
	else
		set_light(0)

/obj/structure/world_anvil/moonanvil/update_icon(updates=ALL)
	. = ..()
	icon_state = forge_charges > 0 ? "moonanvil_a" : "moonanvil"
	if(forge_charges > 0)
		set_light(4,1,LIGHT_COLOR_BLUE)
	else
		set_light(0)


/obj/structure/world_anvil/examine(mob/user)
	. = ..()
	. += "It currently has [forge_charges] forge[forge_charges != 1 ? "s" : ""] remaining."

/obj/structure/world_anvil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/melee/gibtonite))
		var/obj/item/melee/gibtonite/placed_ore = I
		forge_charges = forge_charges + placed_ore.quality
		to_chat(user,"You place down the gibtonite on the [src], and watch as the gibtonite melts into it. The [src] is now heated enough for [forge_charges] forge[forge_charges > 1 ? "s" : ""].")
		qdel(placed_ore)
		update_appearance(UPDATE_ICON)
		return
	if(forge_charges <= 0)
		to_chat(user,"The [src] is not hot enough to be usable!")
		return
	var/success = FALSE
	switch(I.type)
		if(/obj/item/magmite)
			if(do_after(user, 10 SECONDS, src))
				new /obj/item/magmite_parts(get_turf(src))
				qdel(I)
				to_chat(user, "You carefully forge the rough plasma magmite into plasma magmite upgrade parts.")
				success = TRUE
		if(/obj/item/magmite/glacite)
			if(do_after(user, 10 SECONDS, src))
				new /obj/item/magmite_parts/glacite(get_turf(src))
				qdel(I)
				to_chat(user, "You carefully forge the rough plasma glacite into plasma glacite upgrade parts.")
				success = TRUE
		if(/obj/item/magmite_parts)
			var/obj/item/magmite_parts/parts = I
			if(!parts.inert)
				to_chat(user,"The magmite upgrade parts are already glowing and usable!")
				return
			if(do_after(user, 5 SECONDS, src))
				parts.restore()
				to_chat(user, "You successfully reheat the magmite upgrade parts. They are now glowing and usable again.")
		if(/obj/item/magmite_parts/glacite)
			var/obj/item/magmite_parts/glacite/parts = I
			if(!parts.inert)
				to_chat(user,"The glacite upgrade parts are already glowing and usable!")
				return
			if(do_after(user, 5 SECONDS, src))
				parts.restore()
				to_chat(user, "You successfully reheat the glacite upgrade parts. They are now glowing and usable again.")
	if(!success)
		return
	forge_charges--
	if(forge_charges <= 0)
		visible_message("The [src] cools down.")
		update_appearance(UPDATE_ICON)



