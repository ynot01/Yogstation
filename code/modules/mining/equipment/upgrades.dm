//plasma magmite is exclusively used to upgrade mining equipment, by using it on a heated world anvil to make upgradeparts.
/obj/item/magmite
	name = "plasma magmite"
	desc = "A chunk of plasma magmite, crystallized deep under the planet's surface. It seems to lose strength as it gets further from the planet!"
	icon = 'icons/obj/mining.dmi'
	icon_state = "Magmite ore"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/magmite/glacite
	name = "plasma glacite"
	desc = "A chunk of plasma glacite, crystalized deep within the plasma reserves."
	icon_state = "Glacite ore"

/obj/item/magmite_parts
	name = "plasma magmite upgrade parts"
	desc = "Forged on the legendary World Anvil, these parts can be used to upgrade many kinds of mining equipment."
	icon = 'icons/obj/mining.dmi'
	icon_state = "upgrade_parts"
	w_class = WEIGHT_CLASS_NORMAL
	var/inert = FALSE
	var/glacite = FALSE

/obj/item/magmite_parts/glacite
	name = "plasma glacite upgrade parts"
	desc = "Forged on the legendary Moon Anvil, these parts can be used to ugprade many kinds of mining equipment."
	icon_state = "glacite_parts"
	glacite = TRUE

/obj/item/magmite_parts/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(go_inert)), 10 MINUTES)

/obj/item/magmite_parts/proc/go_inert()
	if(inert)
		return
	if(glacite)
		visible_message(span_warning("The [src] loses it's glow!"))
		inert = TRUE
		name = "inert plasma glacite upgrade parts"
		icon_state = "glacite_parts_inert"
		desc += "It appears to have lost its icy glow."
	else if(!glacite)
		visible_message(span_warning("The [src] loses it's glow!"))
		inert = TRUE
		name = "inert plasma magmite upgrade parts"
		icon_state = "upgrade_parts_inert"
		desc += "It appears to have lost its magma-like glow."

/obj/item/magmite_parts/proc/restore()
	if(!inert)
		return
	inert = FALSE
	name = initial(name)
	icon_state = initial(icon_state)
	desc = initial(desc)
	addtimer(CALLBACK(src, PROC_REF(go_inert)), 10 MINUTES)

/obj/item/magmite_parts/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(inert)
		to_chat(span_warning("[src] appears inert! Perhaps the World Anvil can restore it!"))
	switch(target.type)
		if(/obj/item/gun/energy/kinetic_accelerator) //basic kinetic accelerator
			var/obj/item/gun/energy/kinetic_accelerator/gun = target
			if(gun.bayonet)
				gun.remove_gun_attachment(item_to_remove = gun.bayonet)
			if(gun.gun_light)
				gun.remove_gun_attachment(item_to_remove = gun.gun_light)
			for(var/obj/item/borg/upgrade/modkit/kit in gun.modkits)
				kit.uninstall(gun)
			qdel(gun)
			var/obj/item/gun/energy/kinetic_accelerator/mega/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the kinetic accelerator, merging the parts and kinetic accelerator to form a mega kinetic accelerator.")
			qdel(src)
		if(/obj/item/gun/energy/plasmacutter/adv)
			var/obj/item/gun/energy/plasmacutter/adv/gun = target
			qdel(gun)
			var/obj/item/gun/energy/plasmacutter/adv/mega/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the plasma cutter, merging the parts and cutter to form a mega plasma cutter.")
			qdel(src)
		if(/obj/item/gun/energy/plasmacutter/scatter) //holy fuck make a new system bro do a /datum/worldanvilrecipe DAMN
			var/obj/item/gun/energy/plasmacutter/scatter/gun = target
			qdel(gun)
			var/obj/item/gun/energy/plasmacutter/scatter/mega/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the plasma cutter shotgun, merging the parts and cutter to form a mega plasma cutter shotgun.")
			qdel(src)
		if(/obj/item/kinetic_crusher)
			var/obj/item/kinetic_crusher/gun = target
			for(var/t in gun.trophies)
				var/obj/item/crusher_trophy/T = t
				T.remove_from(gun, user)
			qdel(gun)
			var/obj/item/kinetic_crusher/mega/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the kinetic crusher, merging the parts and cutter to form a mega kinetic crusher.")
			qdel(src)

/obj/item/magmite_parts/glacite/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(inert)
		to_chat(span_warning("[src] appears inert! Perhaps the World Anvil can restore it!"))
	switch(target.type)
		if(/obj/item/gun/energy/kinetic_accelerator) //basic kinetic accelerator
			var/obj/item/gun/energy/kinetic_accelerator/gun = target
			if(gun.bayonet)
				gun.remove_gun_attachment(item_to_remove = gun.bayonet)
			if(gun.gun_light)
				gun.remove_gun_attachment(item_to_remove = gun.gun_light)
			for(var/obj/item/borg/upgrade/modkit/kit in gun.modkits)
				kit.uninstall(gun)
			qdel(gun)
			var/obj/item/gun/energy/kinetic_accelerator/mega/glacite/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the kinetic accelerator, merging the parts and kinetic accelerator to form a mega kinetic accelerator.")
			qdel(src)
		if(/obj/item/gun/energy/plasmacutter/adv)
			var/obj/item/gun/energy/plasmacutter/adv/gun = target
			qdel(gun)
			var/obj/item/gun/energy/plasmacutter/adv/mega/glacite/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the plasma cutter, merging the parts and cutter to form a mega plasma cutter.")
			qdel(src)
		if(/obj/item/gun/energy/plasmacutter/scatter) 
			var/obj/item/gun/energy/plasmacutter/scatter/gun = target
			qdel(gun)
			var/obj/item/gun/energy/plasmacutter/scatter/mega/glacite/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the plasma cutter shotgun, merging the parts and cutter to form a mega plasma cutter shotgun.")
			qdel(src)
		if(/obj/item/kinetic_crusher)
			var/obj/item/kinetic_crusher/gun = target
			for(var/t in gun.trophies)
				var/obj/item/crusher_trophy/T = t
				T.remove_from(gun, user)
			qdel(gun)
			var/obj/item/kinetic_crusher/mega/glacite/newgun = new(get_turf(user))
			user.put_in_hand(newgun)
			to_chat(user,"Harsh tendrils wrap around the kinetic crusher, merging the parts and cutter to form a mega kinetic crusher.")
			qdel(src)
