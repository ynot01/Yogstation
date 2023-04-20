#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

#define IPCLIMB(_id, lname) \
	/obj/item/bodypart/l_leg/ipc/_id { \
		name = lname + " Left Leg"; \
		icon_state = #_id + "_l_leg"; \
		species_id = #_id; \
	}; \
	/obj/item/bodypart/r_leg/ipc/_id { \
		name = lname + " Right Leg"; \
		icon_state = #_id + "_r_leg"; \
		species_id = #_id; \
	}; \
	/obj/item/bodypart/l_arm/ipc/_id { \
		name = lname + " Left Arm"; \
		icon_state = #_id + "_l_arm"; \
		species_id = #_id; \
	}; \
	/obj/item/bodypart/r_arm/ipc/_id { \
		name = lname + " Right Arm"; \
		icon_state = #_id + "_r_arm"; \
		species_id = #_id; \
	}; \
	/obj/item/bodypart/head/ipc/_id { \
		name = lname + " Head"; \
		icon_state = #_id + "_head"; \
		species_id = #_id; \
	}; \
	/datum/techweb_node/_id { \
		id = #_id; \
		display_name = lname + " Limbs"; \
		description = "Designs for the " + lname + "."; \
		prereq_ids = list("ipc_organs"); \
		design_ids = list(#_id+"_head", #_id+"_l_leg", #_id+"_r_leg", #_id+"_l_arm", #_id+"_r_arm"); \
		research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000); \
	}; \
	/datum/design/ipclimbs/l_leg/_id { \
		name = lname + " Left Leg"; \
		id = #_id + "_l_leg"; \
		build_path = /obj/item/bodypart/l_leg/ipc/_id; \
	}; \
	/datum/design/ipclimbs/r_leg/_id { \
		name = lname + " Right Leg"; \
		id = #_id + "_r_leg"; \
		build_path = /obj/item/bodypart/r_leg/ipc/_id; \
	}; \
	/datum/design/ipclimbs/l_arm/_id { \
		name = lname + " Left Arm"; \
		id = #_id + "_l_arm"; \
		build_path = /obj/item/bodypart/l_arm/ipc/_id; \
	}; \
	/datum/design/ipclimbs/r_arm/_id { \
		name = lname + " Right Arm"; \
		id = #_id + "_r_arm"; \
		build_path = /obj/item/bodypart/r_arm/ipc/_id; \
	}; \
	/datum/design/ipclimbs/head/_id { \
		name = lname + " Head"; \
		id = #_id + "_head"; \
		build_path = /obj/item/bodypart/head/ipc/_id; \
	}; \

//For ye whom may venture here, split up arm / hand sprites are formatted as "l_hand" & "l_arm".
//The complete sprite (displayed when the limb is on the ground) should be named "borg_l_arm".
//Failure to follow this pattern will cause the hand's icons to be missing due to the way get_limb_icon() works to generate the mob's icons using the aux_zone var.

/obj/item/bodypart/l_arm/robot
	name = "cyborg left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb = list("slapped", "punched")
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_arm"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_arm/robot
	name = "cyborg right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb = list("slapped", "punched")
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_arm"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_leg/robot
	name = "cyborg left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb = list("kicked", "stomped")
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_l_leg"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_leg/robot/digitigrade
	name = "digitigrade cyborg left leg"
	icon_state = "digitigrade_1_l_leg"
	use_digitigrade = FULL_DIGITIGRADE

/obj/item/bodypart/r_leg/robot
	name = "cyborg right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb = list("kicked", "stomped")
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_r_leg"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC
	disable_threshold = 1

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_leg/robot/digitigrade
	name = "digitigrade cyborg right leg"
	icon_state = "digitigrade_1_r_leg"
	use_digitigrade = FULL_DIGITIGRADE
	
//make them swappable
/obj/item/bodypart/l_leg/robot/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour != TOOL_SCREWDRIVER)
		return ..()
	var/obj/item/bodypart/l_leg/robot/prosthetic
	to_chat(user, span_notice("You configure [src] into [use_digitigrade != FULL_DIGITIGRADE ? "digitigrade" : "plantigrade"] mode."))
	if(istype(src,/obj/item/bodypart/l_leg/robot/surplus))
		if(use_digitigrade == FULL_DIGITIGRADE)
			prosthetic = new /obj/item/bodypart/l_leg/robot/surplus
		else
			prosthetic = new /obj/item/bodypart/l_leg/robot/surplus/digitigrade
	else
		if(use_digitigrade == FULL_DIGITIGRADE)
			prosthetic = new /obj/item/bodypart/l_leg/robot
		else
			prosthetic = new /obj/item/bodypart/l_leg/robot/digitigrade
	if(!prosthetic)
		return
	
	var/spot = src.loc
	moveToNullspace()
	if(spot == user && !user.get_inactive_held_item())
		user.put_in_inactive_hand(prosthetic)
	else
		prosthetic.forceMove(get_turf(user))
	qdel(src)
	
/obj/item/bodypart/r_leg/robot/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour != TOOL_SCREWDRIVER)
		return ..()
	var/obj/item/bodypart/r_leg/robot/prosthetic
	to_chat(user, span_notice("You configure [src] into [use_digitigrade != FULL_DIGITIGRADE ? "digitigrade" : "plantigrade"] mode."))
	if(istype(src,/obj/item/bodypart/r_leg/robot/surplus))
		if(use_digitigrade == FULL_DIGITIGRADE)
			prosthetic = new /obj/item/bodypart/r_leg/robot/surplus
		else
			prosthetic = new /obj/item/bodypart/r_leg/robot/surplus/digitigrade
	else
		if(use_digitigrade == FULL_DIGITIGRADE)
			prosthetic = new /obj/item/bodypart/r_leg/robot
		else
			prosthetic = new /obj/item/bodypart/r_leg/robot/digitigrade
	if(!prosthetic)
		return

	var/spot = src.loc
	moveToNullspace()
	if(spot == user && !user.get_inactive_held_item())
		user.put_in_inactive_hand(prosthetic)
	else
		prosthetic.forceMove(get_turf(user))
	qdel(src)
	

/obj/item/bodypart/chest/robot
	name = "cyborg torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_chest"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	var/wired = FALSE
	var/obj/item/stock_parts/cell/cell = null


/obj/item/bodypart/chest/robot/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
	return ..()

/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/bodypart/chest/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		if(cell)
			to_chat(user, span_warning("You have already inserted a cell!"))
			return
		else
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, span_notice("You insert the cell."))
	else if(istype(W, /obj/item/stack/cable_coil))
		if(wired)
			to_chat(user, span_warning("You have already inserted wire!"))
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			wired = TRUE
			to_chat(user, span_notice("You insert the wire."))
		else
			to_chat(user, span_warning("You need one length of coil to wire it!"))
	else
		return ..()

/obj/item/bodypart/chest/robot/wirecutter_act(mob/living/user, obj/item/I)
	if(!wired)
		return
	. = TRUE
	I.play_tool_sound(src)
	to_chat(user, span_notice("You cut the wires out of [src]."))
	new /obj/item/stack/cable_coil(drop_location(), 1)
	wired = FALSE

/obj/item/bodypart/chest/robot/screwdriver_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(!cell)
		to_chat(user, span_warning("There's no power cell installed in [src]!"))
		return
	I.play_tool_sound(src)
	to_chat(user, span_notice("Remove [cell] from [src]."))
	cell.forceMove(drop_location())
	cell = null


/obj/item/bodypart/chest/robot/examine(mob/user)
	. = ..()
	if(cell)
		. += {"It has a [cell] inserted.\n
		<span class='info'>You can use a <b>screwdriver</b> to remove [cell].</span>"}
	else
		. += span_info("It has an empty port for a <b>power cell</b>.")
	if(wired)
		. += "Its all wired up[cell ? " and ready for usage" : ""].\n"+\
		span_info("You can use <b>wirecutters</b> to remove the wiring.")
	else
		. += span_info("It has a couple spots that still need to be <b>wired</b>.")

/obj/item/bodypart/chest/robot/drop_organs(mob/user, violent_removal)
	if(wired)
		new /obj/item/stack/cable_coil(drop_location(), 1)
		wired = FALSE
	if(cell)
		cell.forceMove(drop_location())
		cell = null
	..()


/obj/item/bodypart/head/robot
	name = "cyborg head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	item_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	flags_1 = CONDUCT_1
	icon_state = "borg_head"
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_ROBOTIC

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	var/obj/item/assembly/flash/handheld/flash1 = null
	var/obj/item/assembly/flash/handheld/flash2 = null


/obj/item/bodypart/head/robot/handle_atom_del(atom/A)
	if(A == flash1)
		flash1 = null
	if(A == flash2)
		flash2 = null
	return ..()

/obj/item/bodypart/head/robot/Destroy()
	QDEL_NULL(flash1)
	QDEL_NULL(flash2)
	return ..()

/obj/item/bodypart/head/robot/examine(mob/user)
	. = ..()
	if(!flash1 && !flash2)
		. += span_info("It has two empty eye sockets for <b>flashes</b>.")
	else
		var/single_flash = FALSE
		if(!flash1 || !flash2)
			single_flash = TRUE
			. += {"One of its eye sockets is currently occupied by a flash.\n
			<span class='info'>It has an empty eye socket for another <b>flash</b>.</span>"}
		else
			. += "It has two eye sockets occupied by flashes."
		. += span_notice("You can remove the seated flash[single_flash ? "":"es"] with a <b>crowbar</b>.")

/obj/item/bodypart/head/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/assembly/flash/handheld))
		var/obj/item/assembly/flash/handheld/F = W
		if(flash1 && flash2)
			to_chat(user, span_warning("You have already inserted the eyes!"))
			return
		else if(F.burnt_out)
			to_chat(user, span_warning("You can't use a broken flash!"))
			return
		else
			if(!user.transferItemToLoc(F, src))
				return
			if(flash1)
				flash2 = F
			else
				flash1 = F
			to_chat(user, span_notice("You insert the flash into the eye socket."))
			return
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, "You install the manipulator and modify the head, creating a functional spider-bot!")
		new /mob/living/simple_animal/spiderbot (get_turf(src))
		qdel(W)
		qdel(src)
		return
	return ..()

/obj/item/bodypart/head/robot/crowbar_act(mob/living/user, obj/item/I)
	if(flash1 || flash2)
		I.play_tool_sound(src)
		to_chat(user, span_notice("You remove the flash from [src]."))
		if(flash1)
			flash1.forceMove(drop_location())
			flash1 = null
		if(flash2)
			flash2.forceMove(drop_location())
			flash2 = null
	else
		to_chat(user, span_warning("There is no flash to remove from [src]."))
	return TRUE


/obj/item/bodypart/head/robot/drop_organs(mob/user, violent_removal)
	if(flash1)
		flash1.forceMove(user.loc)
		flash1 = null
	if(flash2)
		flash2.forceMove(user.loc)
		flash2 = null
	..()




/obj/item/bodypart/l_arm/robot/surplus
	name = "surplus prosthetic left arm"
	desc = "A skeletal, robotic limb. Outdated and fragile, but it's still better than nothing."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_arm/robot/surplus
	name = "surplus prosthetic right arm"
	desc = "A skeletal, robotic limb. Outdated and fragile, but it's still better than nothing."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/l_leg/robot/surplus
	name = "surplus prosthetic left leg"
	desc = "A skeletal, robotic limb. Outdated and fragile, but it's still better than nothing."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/l_leg/robot/surplus/digitigrade
	name = "surplus digitigrade prosthetic left leg"
	icon_state = "digitigrade_1_l_leg"
	use_digitigrade = FULL_DIGITIGRADE

/obj/item/bodypart/r_leg/robot/surplus
	name = "surplus prosthetic right leg"
	desc = "A skeletal, robotic limb. Outdated and fragile, but it's still better than nothing."
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20

/obj/item/bodypart/r_leg/robot/surplus/digitigrade
	name = "surplus digitigrade prosthetic right leg"
	icon_state = "digitigrade_1_r_leg"
	use_digitigrade = FULL_DIGITIGRADE

/obj/item/bodypart/l_leg/ipc
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_IPC
	icon = 'yogstation/icons/mob/human_parts.dmi'
	limb_override = TRUE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_leg/ipc
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_IPC
	icon = 'yogstation/icons/mob/human_parts.dmi'
	limb_override = TRUE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/l_arm/ipc
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_IPC
	icon = 'yogstation/icons/mob/human_parts.dmi'
	limb_override = TRUE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/r_arm/ipc
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_IPC
	icon = 'yogstation/icons/mob/human_parts.dmi'
	limb_override = TRUE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

/obj/item/bodypart/head/ipc
	status = BODYPART_ROBOTIC
	sub_status = BODYPART_SUBTYPE_IPC
	icon = 'yogstation/icons/mob/human_parts.dmi'
	limb_override = TRUE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

IPCLIMB(bshipc, "Bishop Cyberkinetics")
IPCLIMB(bs2ipc, "Bishop Cyberkinetics (2.0)")
IPCLIMB(hsiipc, "Hephaestus Industries")
IPCLIMB(hi2ipc, "Hephaestus Industries (2.0)")
IPCLIMB(sgmipc, "Shellguard Munitions")
IPCLIMB(wtmipc, "Ward-Takahashi")
IPCLIMB(xmgipc, "Xion Manufacturing")
IPCLIMB(xm2ipc, "Xion Manufacturing (2.0)")
IPCLIMB(zhpipc, "Zeng-Hu Pharmaceuticals")

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG
