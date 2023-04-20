/obj/vehicle/ridden/wheelchair //ported from Hippiestation (by Jujumatic)
	name = "wheelchair"
	desc = "A chair with big wheels. It looks like you can move in this on your own."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "wheelchair"
	layer = OBJ_LAYER
	max_integrity = 100
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = 30)	//Wheelchairs aren't super tough yo
	legs_required = 0	//You'll probably be using this if you don't have legs
	canmove = TRUE
	density = FALSE		//Thought I couldn't fix this one easily, phew
	movedelay = 4
	var/move_sound = 'sound/effects/roll.ogg'

/obj/vehicle/ridden/wheelchair/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 0
	D.set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(NORTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/obj/vehicle/ridden/wheelchair/ComponentInitialize()	//Since it's technically a chair I want it to have chair properties
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, .proc/can_user_rotate),CALLBACK(src, .proc/can_be_rotated),null)

/obj/vehicle/ridden/wheelchair/obj_destruction(damage_flag)
	new /obj/item/stack/rods(drop_location(), 1)
	new /obj/item/stack/sheet/metal(drop_location(), 1)
	..()

/obj/vehicle/ridden/wheelchair/Destroy()
	if(has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		unbuckle_mob(H)
	return ..()

/obj/vehicle/ridden/wheelchair/driver_move(mob/living/user, direction)
	if(istype(user))
		if(canmove && (user.get_num_arms() < arms_required))
			to_chat(user, span_warning("You don't have enough arms to operate the wheels!"))
			canmove = FALSE
			addtimer(VARSET_CALLBACK(src, canmove, TRUE), 2 SECONDS)
			return FALSE
		//paraplegic quirk users get a halved movedelay to model their life of wheelchair useage - yogs
		if(user.has_quirk(/datum/quirk/paraplegic))
			movedelay = 2
		else
			movedelay = 4
		set_move_delay(user)
	return ..()

/obj/vehicle/ridden/wheelchair/proc/set_move_delay(mob/living/user)
	var/datum/component/riding/D = GetComponent(/datum/component/riding)
	//1.5 (movespeed as of this change) multiplied by 6.7 gets ABOUT 10 (rounded), the old constant for the wheelchair that gets divided by how many arms they have
	//if that made no sense this simply makes the wheelchair speed change along with movement speed delay
	D.vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * movedelay) / min(user.get_num_arms(), 2)

/obj/vehicle/ridden/wheelchair/Moved()
	. = ..()
	cut_overlays()
	playsound(src, move_sound, 75, TRUE)
	if(has_buckled_mobs())
		handle_rotation_overlayed()

/obj/vehicle/ridden/wheelchair/post_buckle_mob(mob/living/user)
	. = ..()
	handle_rotation_overlayed()

/obj/vehicle/ridden/wheelchair/post_unbuckle_mob()
	. = ..()
	cut_overlays()

/obj/vehicle/ridden/wheelchair/setDir(newdir)
	..()
	handle_rotation(newdir)

/obj/vehicle/ridden/wheelchair/wrench_act(mob/living/user, obj/item/I)	//Attackby should stop it attacking the wheelchair after moving away during decon
	to_chat(user, span_notice("You begin to detach the wheels..."))
	if(I.use_tool(src, user, 4 SECONDS, volume=50))
		to_chat(user, span_notice("You detach the wheels and deconstruct the chair."))
		new /obj/item/stack/rods(drop_location(), 6)
		new /obj/item/stack/sheet/metal(drop_location(), 4)
		qdel(src)
	return TRUE

/obj/vehicle/ridden/wheelchair/proc/handle_rotation(direction)
	if(has_buckled_mobs())
		handle_rotation_overlayed()
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/vehicle/ridden/wheelchair/proc/handle_rotation_overlayed()
	cut_overlays()
	var/image/V = image(icon = icon, icon_state = "wheelchair_overlay", layer = FLY_LAYER, dir = src.dir)
	add_overlay(V)

/obj/vehicle/ridden/wheelchair/proc/can_be_rotated(mob/living/user)
	return TRUE

/obj/vehicle/ridden/wheelchair/proc/can_user_rotate(mob/living/user)
	var/mob/living/L = user
	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return FALSE
	if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/vehicle/ridden/wheelchair/CtrlClick(mob/user)
	if(has_buckled_mobs() && pick(buckled_mobs) == user)
		return
	. = ..()

/obj/vehicle/ridden/wheelchair/post_buckle_mob(mob/living/L)
	if(L.pulling && src.pulledby == L)
		L.stop_pulling()
	. = ..()

/obj/vehicle/ridden/wheelchair/the_whip/driver_move(mob/living/user, direction)
	if(istype(user))
		var/datum/component/riding/D = GetComponent(/datum/component/riding)
		D.vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * 6.7) / user.get_num_arms()
	return ..()

/obj/item/wheelchair
	name = "wheelchair"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "wheelchair_folded"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 8 //Force is same as a chair
	custom_materials = list(/datum/material/iron = 10000)
	var/obj/vehicle/ridden/wheelchair/wheelchair

/obj/vehicle/ridden/wheelchair/MouseDrop(over_object, src_location, over_location)  //Lets you collapse wheelchair
	. = ..()
	if(over_object != usr || !Adjacent(usr))
		return FALSE
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return FALSE
	if(has_buckled_mobs())
		to_chat(usr, span_warning("You need to unbuckle the passenger from [src] first!"))
		return FALSE
	usr.visible_message(span_notice("[usr] collapses [src]."), span_notice("You collapse [src]."))
	var/obj/item/wheelchair/wheelchair_folded = new /obj/item/wheelchair(get_turf(src))
	forceMove(wheelchair_folded)
	wheelchair_folded.desc = "A collapsed [name] that can be carried around." 
	wheelchair_folded.name = name
	wheelchair_folded.wheelchair = src
	usr.put_in_hands(wheelchair_folded)
	
/obj/item/wheelchair/attack_self(mob/user)  //Deploys wheelchair on in-hand use
	deploy_wheelchair(user, user.loc)

/obj/item/wheelchair/proc/deploy_wheelchair(mob/user, atom/location)
	if(!wheelchair)
		wheelchair = new /obj/vehicle/ridden/wheelchair(location)
	wheelchair.add_fingerprint(user)
	wheelchair.forceMove(location)
	qdel(src)

/obj/item/wheelchair/Destroy()
	wheelchair = null
	. = ..()

/obj/vehicle/ridden/wheelchair/explosive //reference to something i've never actually watched

/obj/vehicle/ridden/wheelchair/explosive/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/ridden/wheelchair/explosive/kaboom, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/ridden/wheelchair/explosive/obj_destruction(damage_flag)
	explosion(src, 1, 3, 5)
	qdel(src)

/datum/action/vehicle/ridden/wheelchair/explosive/kaboom
	name = "Ding!"
	desc = "Ring the cute little bell on your wheelchair."
	icon_icon = 'icons/obj/bell.dmi'
	button_icon_state = "bell"
	var/exploding = FALSE
	var/explode_delay = 2 SECONDS
	var/explode_size = list(2, 3, 6)

/datum/action/vehicle/ridden/wheelchair/explosive/kaboom/Trigger()
	playsound(vehicle_target, 'sound/items/bell.ogg', 40, FALSE)
	if(exploding)
		return
	vehicle_target.visible_message(span_boldwarning("The bell on [vehicle_target] dings loudly!"))
	exploding = TRUE
	sleep(explode_delay)
	vehicle_target.visible_message(span_boldwarning("[vehicle_target] explodes!!"))
	explosion(vehicle_target, explode_size[1], explode_size[2], explode_size[3])
	qdel(vehicle_target)

/obj/item/wheelchair/explosive

/obj/vehicle/ridden/wheelchair/explosive/MouseDrop(over_object, src_location, over_location)  //Lets you collapse wheelchair
	. = ..()
	if(over_object != usr || !Adjacent(usr))
		return FALSE
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return FALSE
	if(has_buckled_mobs())
		to_chat(usr, span_warning("You need to unbuckle the passenger from [src] first!"))
		return FALSE
	usr.visible_message(span_notice("[usr] collapses [src]."), span_notice("You collapse [src]."))
	var/obj/item/wheelchair/wheelchair_folded = new /obj/item/wheelchair/explosive(get_turf(src))
	forceMove(wheelchair_folded)
	wheelchair_folded.desc = "A collapsed [name] that can be carried around." 
	wheelchair_folded.name = name
	wheelchair_folded.wheelchair = src
	usr.put_in_hands(wheelchair_folded)

/obj/item/wheelchair/explosive/deploy_wheelchair(mob/user, atom/location)
	if(!wheelchair)
		wheelchair = new /obj/vehicle/ridden/wheelchair/explosive(location)
	wheelchair.add_fingerprint(user)
	wheelchair.forceMove(location)
	qdel(src)
