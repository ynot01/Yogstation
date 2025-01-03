#define FOOTPRINT_INDEX_FILE 1
#define FOOTPRINT_INDEX_STATE 2

//Component for clothing items that can pick up blood from decals and spread it around everywhere when walking, such as shoes or suits with integrated shoes.

/datum/component/bloodysoles
	/// The type of the last grub pool we stepped in, used to decide the type of footprints to make
	var/last_blood_state = BLOOD_STATE_NOT_BLOODY

	/// How much of each grubby type we have on our feet
	var/list/bloody_shoes = list(BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)

	/// The ITEM_SLOT_* slot the item is equipped on, if it is.
	var/equipped_slot

	/// The parent item but casted into atom type for easier use.
	var/atom/parent_atom

	/// Either the mob carrying the item, or the mob itself for the /feet component subtype
	var/mob/living/carbon/wielder

	/// The world.time when we last picked up blood
	var/last_pickup

	var/footprint_sprite = FOOTPRINT_SPRITE_SHOES

/datum/component/bloodysoles/Initialize()
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE
	parent_atom = parent

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))

//Unregisters from the wielder if necessary

/datum/component/bloodysoles/proc/unregister()
	if(!QDELETED(wielder))
		UnregisterSignal(wielder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(wielder, COMSIG_STEP_ON_BLOOD)
	wielder = null
	equipped_slot = null


//Returns true if the parent item is obscured by something else that the wielder is wearing

/datum/component/bloodysoles/proc/is_obscured()
	return equipped_slot in wielder.check_obscured_slots(TRUE)

//Run to update the icon of the parent

/datum/component/bloodysoles/proc/update_icon()
	var/obj/item/parent_item = parent
	parent_item.update_slot_icon()

//Run to equally share the blood between us and a decal
/datum/component/bloodysoles/proc/share_blood(obj/effect/decal/cleanable/pool)
	last_blood_state = pool.blood_state

	// Share the blood between our boots and the blood pool
	var/total_bloodiness = pool.bloodiness + bloody_shoes[last_blood_state]

	// We can however be limited by how much blood we can hold
	var/new_our_bloodiness = min(BLOOD_ITEM_MAX, total_bloodiness / 2)

	bloody_shoes[last_blood_state] = new_our_bloodiness
	pool.bloodiness = total_bloodiness - new_our_bloodiness // Give the pool the remaining blood incase we were limited

	parent_atom.add_blood_DNA(pool.return_blood_DNA())
	update_icon()

//Find a blood decal on a turf that matches our last_blood_state

/datum/component/bloodysoles/proc/find_pool_by_blood_state(turf/turfLoc, typeFilter = null, footprint_sprite)
	for(var/obj/effect/decal/cleanable/blood/pool in turfLoc)
		if(pool.blood_state == last_blood_state && pool.footprint_sprite == footprint_sprite && (!typeFilter || istype(pool, typeFilter)))
			return pool


//Adds the parent type to the footprint's shoe_types var

/datum/component/bloodysoles/proc/add_parent_to_footprint(obj/effect/decal/cleanable/blood/footprints/FP)
	FP.shoe_types |= parent.type

/*
Called when the parent item is equipped by someone
Used to register our wielder
*/
/datum/component/bloodysoles/proc/on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!iscarbon(equipper))
		return
	var/obj/item/parent_item = parent
	if(!(parent_item.slot_flags & slot))
		unregister()
		return

	equipped_slot = slot
	wielder = equipper
	RegisterSignal(wielder, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(wielder, COMSIG_STEP_ON_BLOOD, PROC_REF(on_step_blood))

/*
Called when the parent item has been dropped
Used to deregister our wielder
*/
/datum/component/bloodysoles/proc/on_drop(datum/source, mob/dropper)
	SIGNAL_HANDLER

	unregister()

/*
Called when the wielder has moved
Used to make bloody footprints on the ground
*/
/datum/component/bloodysoles/proc/on_moved(datum/source, OldLoc, Dir, Forced)
	SIGNAL_HANDLER

	if(bloody_shoes[last_blood_state] == 0)
		return
	if(QDELETED(wielder) || is_obscured())
		return
	if(!(wielder.mobility_flags & MOBILITY_STAND) || !wielder.has_gravity(wielder.loc))
		return

	var/half_our_blood = bloody_shoes[last_blood_state] / 2
	var/footprint_sprite = wielder.get_footprint_sprite()
	// Add footprints in old loc if we have enough cream
	if(half_our_blood >= BLOOD_FOOTPRINTS_MIN)
		var/turf/oldLocTurf = get_turf(OldLoc)
		var/obj/effect/decal/cleanable/blood/footprints/oldLocFP = find_pool_by_blood_state(oldLocTurf, /obj/effect/decal/cleanable/blood/footprints, footprint_sprite)
		if(oldLocFP)
			// Footprints found in the tile we left, add us to it
			add_parent_to_footprint(oldLocFP)
			if (!(oldLocFP.exited_dirs & wielder.dir))
				oldLocFP.exited_dirs |= wielder.dir
				oldLocFP.update_icon()
		else if(find_pool_by_blood_state(oldLocTurf, footprint_sprite = footprint_sprite))
			// No footprints in the tile we left, but there was some other blood pool there. Add exit footprints on it
			bloody_shoes[last_blood_state] -= half_our_blood
			update_icon()


			oldLocFP = new(oldLocTurf, footprint_sprite)
			if(!QDELETED(oldLocFP)) ///prints merged
				oldLocFP.blood_state = last_blood_state
				oldLocFP.exited_dirs |= wielder.dir
				add_parent_to_footprint(oldLocFP)
				oldLocFP.bloodiness = half_our_blood
				oldLocFP.add_blood_DNA(parent_atom.return_blood_DNA())
				oldLocFP.update_icon()

			half_our_blood = bloody_shoes[last_blood_state] / 2

	// If we picked up the blood on this tick in on_step_blood, don't make footprints at the same place
	if(last_pickup && last_pickup == world.time)
		return

	// Create new footprints
	if(half_our_blood >= BLOOD_FOOTPRINTS_MIN)
		bloody_shoes[last_blood_state] -= half_our_blood
		update_icon()

		var/obj/effect/decal/cleanable/blood/footprints/FP = new(get_turf(parent_atom), footprint_sprite)
		if(!QDELETED(FP)) ///prints merged
			FP.blood_state = last_blood_state
			FP.entered_dirs |= wielder.dir
			add_parent_to_footprint(FP)
			FP.bloodiness = half_our_blood
			FP.add_blood_DNA(parent_atom.return_blood_DNA())
			FP.update_icon()


/*
Called when the wielder steps in a pool of blood
Used to make the parent item bloody
*/
/datum/component/bloodysoles/proc/on_step_blood(datum/source, obj/effect/decal/cleanable/pool)
	SIGNAL_HANDLER

	if(QDELETED(wielder) || is_obscured())
		return

	if(istype(pool, /obj/effect/decal/cleanable/blood/footprints) && pool.blood_state == last_blood_state)
		// The pool we stepped in was actually footprints with the same type
		var/obj/effect/decal/cleanable/blood/footprints/pool_FP = pool
		add_parent_to_footprint(pool_FP)
		if((bloody_shoes[last_blood_state] / 2) >= BLOOD_FOOTPRINTS_MIN && !(pool_FP.entered_dirs & wielder.dir))
			// If our feet are bloody enough, add an entered dir
			pool_FP.entered_dirs |= wielder.dir
			pool_FP.update_icon()

	share_blood(pool)

	last_pickup = world.time

/*
Called when the parent item is being washed
*/
/datum/component/bloodysoles/proc/on_clean(datum/source, clean_types)
	SIGNAL_HANDLER

	if(!(clean_types & CLEAN_TYPE_BLOOD) || last_blood_state == BLOOD_STATE_NOT_BLOODY)
		return

	bloody_shoes = list(BLOOD_STATE_HUMAN = 0, BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	last_blood_state = BLOOD_STATE_NOT_BLOODY
	update_icon()
	return TRUE


/*
Like its parent but can be applied to carbon mobs instead of clothing items
*/

/datum/component/bloodysoles/feet
	var/mutable_appearance/bloody_feet

/datum/component/bloodysoles/feet/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	parent_atom = parent
	wielder = parent
	if(footprint_sprite)
		src.footprint_sprite = footprint_sprite
	if(!bloody_feet)
		bloody_feet = mutable_appearance('icons/effects/blood.dmi', "shoeblood", SHOES_LAYER)

	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_STEP_ON_BLOOD, PROC_REF(on_step_blood))
	RegisterSignal(parent, COMSIG_CARBON_UNEQUIP_SHOECOVER, PROC_REF(unequip_shoecover))
	RegisterSignal(parent, COMSIG_CARBON_EQUIP_SHOECOVER, PROC_REF(equip_shoecover))

/datum/component/bloodysoles/feet/update_icon()
	. = list()
	if(ishuman(wielder))// Monkeys get no bloody feet :(
		var/obj/item/bodypart/l_leg/left_leg = wielder.get_bodypart(BODY_ZONE_L_LEG)
		var/obj/item/bodypart/r_leg/right_leg = wielder.get_bodypart(BODY_ZONE_R_LEG)
		if(left_leg?.species_id == right_leg?.species_id && icon_exists(bloody_feet.icon, "shoeblood_[left_leg.species_id]"))
			bloody_feet.icon_state = "shoeblood_[left_leg.species_id]"
		else if(HAS_TRAIT(wielder, TRAIT_DIGITIGRADE) && !HAS_TRAIT(wielder, TRAIT_DIGI_SQUISH))
			bloody_feet.icon_state = "shoeblood_digi"
		if(HAS_BLOOD_DNA(wielder))
			bloody_feet.color = get_blood_dna_color(wielder.return_blood_DNA())
			. += bloody_feet
		if(bloody_shoes[BLOOD_STATE_HUMAN] > 0 && !is_obscured())
			wielder.remove_overlay(SHOES_LAYER)
			wielder.overlays_standing[SHOES_LAYER] = bloody_feet
			wielder.apply_overlay(SHOES_LAYER)
		else
			wielder.update_inv_shoes()

/datum/component/bloodysoles/feet/add_parent_to_footprint(obj/effect/decal/cleanable/blood/footprints/FP)
	if(ismonkey(wielder))
		FP.species_types["monkey"] = list(null, FALSE)
		return

	if(!ishuman(wielder))
		FP.species_types["unknown"] = list(null, FALSE)
		return

	// Our limbs code is horribly out of date and won't work the normal way, so we do it like this
	for(var/obj/item/bodypart/affecting as anything in wielder.bodyparts)
		if((affecting.body_part & (LEG_LEFT|LEG_RIGHT)) && !affecting.bodypart_disabled)
			var/image/limb_icon = affecting.get_limb_icon(FALSE)[1]
			FP.species_types[affecting.species_id] = list(limb_icon.icon, limb_icon.icon_state)
			break


/datum/component/bloodysoles/feet/is_obscured()
	if(wielder.shoes)
		return TRUE
	return ITEM_SLOT_FEET in wielder.check_obscured_slots(TRUE)

/datum/component/bloodysoles/feet/on_moved(datum/source, OldLoc, Dir, Forced)
	if(wielder.num_legs < 2)
		return

	..()

/datum/component/bloodysoles/feet/on_step_blood(datum/source, obj/effect/decal/cleanable/pool)
	if(wielder.num_legs < 2)
		return

	..()

/datum/component/bloodysoles/feet/proc/unequip_shoecover(datum/source)
	SIGNAL_HANDLER

	update_icon()

/datum/component/bloodysoles/feet/proc/equip_shoecover(datum/source)
	SIGNAL_HANDLER

	update_icon()
