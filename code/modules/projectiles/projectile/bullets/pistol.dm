// 9mm (Stechkin APS)

/obj/item/projectile/bullet/c9mm
	name = "9mm bullet"
	damage = 20
	wound_bonus = -10

/obj/item/projectile/bullet/c9mm/ap
	name = "9mm armor-piercing bullet"
	damage = 18
	armour_penetration = 40

/obj/item/projectile/bullet/incendiary/c9mm
	name = "9mm incendiary bullet"
	damage = 13
	fire_stacks = 1

// 10mm (Stechkin)

/obj/item/projectile/bullet/c10mm
	name = "10mm bullet"
	damage = 30
	wound_bonus = -30

/obj/item/projectile/bullet/c10mm/ap
	name = "10mm armor-piercing bullet"
	damage = 27
	armour_penetration = 40

/obj/item/projectile/bullet/c10mm/hp
	name = "10mm hollow-point bullet"
	damage = 45
	armour_penetration = -45
	sharpness = SHARP_EDGED
	wound_bonus = -25 //Do you WANT a gun that can decapitate in 4 shots for traitors?
	bare_wound_bonus = 5

/obj/item/projectile/bullet/c10mm/sp
	name = "10mm soporific bullet"
	damage = 30
	damage_type = STAMINA
	eyeblur = 20

/obj/item/projectile/bullet/c10mm/sp/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && isliving(target))
		var/mob/living/L = target
		if(L.getStaminaLoss() >= 100)
			L.Sleeping(400)
	return ..()

/obj/item/projectile/bullet/incendiary/c10mm
	name = "10mm incendiary bullet"
	damage = 25
	fire_stacks = 2

/obj/item/projectile/bullet/c10mm/emp
	name = "10mm EMP bullet"
	damage = 25

/obj/item/projectile/bullet/c10mm/emp/on_hit(atom/target, blocked = FALSE)
	..()
	empulse(target, 0.5, 1) //Heavy EMP on target, light EMP in tiles around
