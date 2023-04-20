/obj/item/projectile/bullet/shotgun/slug
	name = "12g shotgun slug"
	speed = 0.5 //Shotgun = slower
	var/tile_dropoff = 1.5
	var/tile_dropoff_s = 1
	damage = 46 //About 2/3's the damage of buckshot but doesn't suffer from spread or negative AP
	sharpness = SHARP_POINTY
	wound_bonus = -30

/obj/item/projectile/bullet/shotgun/slug/syndie
	name = "12g syndicate shotgun slug"
	damage = 60
	tile_dropoff = 0.5

/obj/item/projectile/bullet/shotgun/slug/beanbag
	name = "beanbag slug"
	damage = 5
	stamina = 55
	wound_bonus = 20
	sharpness = SHARP_NONE

/obj/item/projectile/bullet/incendiary/shotgun
	name = "incendiary slug"
	damage = 20

/obj/item/projectile/bullet/incendiary/shotgun/dragonsbreath
	name = "dragonsbreath pellet"
	damage = 7

/obj/item/projectile/bullet/shotgun/slug/stun
	name = "stunslug"
	damage = 5
	paralyze = 100
	stutter = 5
	jitter = 20
	range = 7
	icon_state = "spark"
	color = "#FFFF00"

/obj/item/projectile/bullet/shotgun/slug/meteor
	name = "meteorslug"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "dust"
	damage = 20
	paralyze = 8 SECONDS
	wound_bonus = 0
	sharpness = SHARP_NONE
	hitsound = 'sound/effects/meteorimpact.ogg'

/obj/item/projectile/bullet/shotgun/slug/meteor/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ismovable(target))
		var/atom/movable/M = target
		var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
		M.safe_throw_at(throw_target, 3, 2, force = MOVE_FORCE_OVERPOWERING)

/obj/item/projectile/bullet/shotgun/slug/meteor/Initialize()
	. = ..()
	SpinAnimation()

/obj/item/projectile/bullet/shotgun/slug/frag12
	name = "frag12 slug"
	damage = 25
	wound_bonus = 0

/obj/item/projectile/bullet/shotgun/slug/frag12/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 0, 2)
	return BULLET_ACT_HIT

/obj/item/projectile/bullet/shotgun/slug/uranium
	name = "depleted uranium slug"
	icon_state = "ubullet"
	damage = 35 //Most certainly to drop below 3-shot threshold because of damage falloff
	armour_penetration = 60 // he he funny round go through armor
	wound_bonus = -40
	penetrating = TRUE //Goes through an infinite number of mobs

/obj/item/projectile/bullet/shotgun/slug/Range()
	..()
	if(damage > 0)
		damage -= tile_dropoff
	if(stamina > 0)
		stamina -= tile_dropoff_s

/obj/item/projectile/bullet/pellet
	speed = 0.5 //Shotgun = slower
	var/tile_dropoff = 0.4
	var/tile_dropoff_s = 0.3
	armour_penetration = -20 //Armor is 25% stronger against pellets

/obj/item/projectile/bullet/pellet/shotgun_buckshot
	name = "buckshot pellet"
	damage = 11 //Total of 66
	wound_bonus = 5
	bare_wound_bonus = 5
	wound_falloff_tile = -2.5 // low damage + additional dropoff will already curb wounding potential anything past point blank
	
/obj/item/projectile/bullet/pellet/shotgun_buckshot/syndie
	name = "syndicate buckshot pellet"
	damage = 14.5 //3.5 more damage so it sucks less?
	wound_bonus = 2
	bare_wound_bonus = 2
	armour_penetration = 0 //So it doesn't suffer against armor (it's for nukies only)

/obj/item/projectile/bullet/pellet/shotgun_flechette
	name = "flechette pellet"
	speed = 0.4 //You're special
	damage = 12
	wound_bonus = 4
	bare_wound_bonus = 4
	armour_penetration = 40
	tile_dropoff = 0.35 //Ranged pellet because I guess?
	wound_falloff_tile = -1

/obj/item/projectile/bullet/pellet/shotgun_clownshot
	name = "clownshot pellet"
	damage = 0
	hitsound = 'sound/items/bikehorn.ogg'

/obj/item/projectile/bullet/pellet/shotgun_rubbershot
	name = "rubbershot pellet"
	damage = 3
	stamina = 13 //Total of 78 with less falloff (very big)
	sharpness = SHARP_NONE

/obj/item/projectile/bullet/pellet/shotgun_cryoshot
	name = "cryoshot pellet"
	damage = 6
	sharpness = SHARP_NONE
	var/temperature = 100

/obj/item/projectile/bullet/pellet/shotgun_cryoshot/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		M.adjust_bodytemperature((temperature - M.bodytemperature))

/obj/item/projectile/bullet/pellet/shotgun_improvised
	name = "improvised pellet"
	damage = 6
	wound_bonus = 0
	bare_wound_bonus = 7.5
	tile_dropoff = 0.35

/obj/item/projectile/bullet/pellet/shotgun_improvised/on_range()
	do_sparks(1, TRUE, src)
	..()

/obj/item/projectile/bullet/pellet/shotgun_thundershot
	name = "thundershot pellet"
	damage = 3
	sharpness = SHARP_NONE
	hitsound = 'sound/magic/lightningbolt.ogg'

/obj/item/projectile/bullet/pellet/shotgun_thundershot/on_hit(atom/target)
	..()
	tesla_zap(target, rand(2, 3), 17500, TESLA_MOB_DAMAGE)
	return BULLET_ACT_HIT

/obj/item/projectile/bullet/pellet/Range()
	..()
	if(damage > 0)
		damage -= tile_dropoff
	if(stamina > 0)
		stamina -= tile_dropoff_s
	if(damage < 0 && stamina < 0)
		qdel(src)

// Mech Scattershot

/obj/item/projectile/bullet/scattershot
	damage = 16

//Breaching Ammo

/obj/item/projectile/bullet/shotgun/slug/breaching
	name = "12g breaching round"
	desc = "A breaching round designed to destroy airlocks and windows with only a few shots, but is ineffective against other targets."
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	damage = 10 //does shit damage to everything except doors and windows

/obj/item/projectile/bullet/shotgun/slug/breaching/on_hit(atom/target)
	if(istype(target, /obj/structure/window) || istype(target, /obj/machinery/door) || istype(target, /obj/structure/door_assembly))
		damage = 500 //one shot to break a window or 3 shots to breach an airlock door
	..()
	