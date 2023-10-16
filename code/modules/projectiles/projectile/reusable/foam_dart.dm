/obj/projectile/bullet/reusable/foam_dart
	name = "foam dart"
	desc = "I hope you're wearing eye protection."
	damage = 0 // It's a damn toy.
	damage_type = OXY
	nodamage = TRUE
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart_proj"
	ammo_type = /obj/item/ammo_casing/reusable/foam_dart
	range = 10

/// Apply stamina damage to other toy gun users
/obj/projectile/bullet/reusable/foam_dart/on_hit(atom/target, blocked)
	. = ..()

	if(stamina > 0) // NO RIOT DARTS!!!
		return

	if(!iscarbon(target))
		return
	
	var/nerfed = FALSE
	var/mob/living/carbon/C = target
	for(var/obj/item/gun/ballistic/T in C.held_items) // Is usually just ~2 items
		if(ispath(T.mag_type, /obj/item/ammo_box/magazine/toy) || ispath(T.mag_type, /obj/item/ammo_box/magazine/internal/shot/toy)) // All automatic foam force guns || Foam force shotguns & crossbows
			nerfed = TRUE
			break
		if(istype(T, /obj/item/gun/ballistic/bow)) // Bows have their own handling
			var/obj/item/gun/ballistic/bow/bow = T
			if(bow.nerfed)
				nerfed = TRUE
				break
	
	if(!nerfed)
		return
	
	C.adjustStaminaLoss(25) // ARMOR IS CHEATING!!!

/obj/projectile/bullet/reusable/foam_dart/riot
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/reusable/foam_dart/riot
	stamina = 25
