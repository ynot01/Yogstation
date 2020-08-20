/// Jungleland mining tool, the Jungle Machete
/obj/item/melee/machete
	name = "jungle machete"
	desc = "An archaic tool used for cutting through grass or flesh or grass flesh."
	obj_flags = UNIQUE_RENAME
	force = 14
	sharpness = IS_SHARP
	throwforce = 9
	throw_speed = 4
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=1500)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "hacked", "stabbed", "cut")
	icon = ''
	icon_state = ""
	item_state = ""
	lefthand_file = ''
	righthand_file = ''

/obj/item/melee/machete/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 110)
