/mob/living/carbon/human/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	return dna.species.can_equip(I, slot, disable_warning, src, bypass_equip_delay_self)

// Return the item currently in the slot ID
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(SLOT_BACK)
			return back
		if(SLOT_WEAR_MASK)
			return wear_mask
		if(SLOT_NECK)
			return wear_neck
		if(SLOT_HANDCUFFED)
			return handcuffed
		if(SLOT_LEGCUFFED)
			return legcuffed
		if(SLOT_BELT)
			return belt
		if(SLOT_WEAR_ID)
			return wear_id
		if(SLOT_EARS)
			return ears
		if(SLOT_GLASSES)
			return glasses
		if(SLOT_GLOVES)
			return gloves
		if(SLOT_HEAD)
			return head
		if(SLOT_SHOES)
			return shoes
		if(SLOT_WEAR_SUIT)
			return wear_suit
		if(SLOT_W_UNIFORM)
			return w_uniform
		if(SLOT_L_STORE)
			return l_store
		if(SLOT_R_STORE)
			return r_store
		if(SLOT_S_STORE)
			return s_store
	return null

/mob/living/carbon/human/proc/get_all_slots()
	. = get_head_slots() | get_body_slots()

/mob/living/carbon/human/proc/get_body_slots()
	return list(
		back,
		s_store,
		handcuffed,
		legcuffed,
		wear_suit,
		gloves,
		shoes,
		belt,
		wear_id,
		l_store,
		r_store,
		w_uniform
		)

/mob/living/carbon/human/proc/get_head_slots()
	return list(
		head,
		wear_mask,
		wear_neck,
		glasses,
		ears,
		)

/mob/living/carbon/human/proc/get_storage_slots()
	return list(
		back,
		belt,
		l_store,
		r_store,
		s_store,
		)

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
// Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
/mob/living/carbon/human/equip_to_slot(obj/item/I, slot, initial = FALSE)
	if(!..()) //a check failed or the item has already found its slot
		return

	var/not_handled = FALSE //Added in case we make this type path deeper one day
	switch(slot)
		if(SLOT_BELT)
			belt = I
			update_inv_belt()
		if(SLOT_WEAR_ID)
			wear_id = I
			sec_hud_set_ID()
			update_inv_wear_id()
		if(SLOT_EARS)
			ears = I
			update_inv_ears()
		if(SLOT_GLASSES)
			glasses = I
			var/obj/item/clothing/glasses/G = I
			if(G.glass_colour_type)
				update_glasses_color(G, 1)
			if(G.tint)
				update_tint()
			if(G.vision_correction)
				clear_fullscreen("nearsighted")
				clear_fullscreen("eye_damage")
			if(G.vision_flags || G.darkness_view || G.invis_override || G.invis_view || !isnull(G.lighting_alpha))
				update_sight()
			update_inv_glasses()
		if(SLOT_GLOVES)
			gloves = I
			update_inv_gloves()
		if(SLOT_SHOES)
			shoes = I
			update_inv_shoes()
		if(SLOT_WEAR_SUIT)
			wear_suit = I
			if(I.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform()
			if(wear_suit.breakouttime) //when equipping a straightjacket
				stop_pulling() //can't pull if restrained
				update_action_buttons_icon() //certain action buttons will no longer be usable.
			update_inv_wear_suit()
		if(SLOT_W_UNIFORM)
			w_uniform = I
			update_suit_sensors()
			update_inv_w_uniform()
		if(SLOT_L_STORE)
			l_store = I
			update_inv_pockets()
		if(SLOT_R_STORE)
			r_store = I
			update_inv_pockets()
		if(SLOT_S_STORE)
			s_store = I
			update_inv_s_store()
		else
			to_chat(src, span_danger("You are trying to equip this item to an unsupported inventory slot. Report this to a coder!"))

	//Item is handled and in slot, valid to call callback, for this proc should always be true
	if(!not_handled)
		I.equipped(src, slot, initial)

	return not_handled //For future deeper overrides

/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	var/index = get_held_index_of_item(I)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(!. || !I)
		return
	if(index && !QDELETED(src) && dna.species.mutanthands) //hand freed, fill with claws, skip if we're getting deleted.
		put_in_hand(new dna.species.mutanthands(), index)
	if(I == wear_suit)
		if(s_store && invdrop)
			dropItemToGround(s_store, TRUE) //It makes no sense for your suit storage to stay on you if you drop your suit.
		if(wear_suit.breakouttime) //when unequipping a straightjacket
			drop_all_held_items() //suit is restraining
			update_action_buttons_icon() //certain action buttons may be usable again.
		wear_suit = null
		if(!QDELETED(src)) //no need to update we're getting deleted anyway
			if(I.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform()
			update_inv_wear_suit()
	else if(I == w_uniform)
		w_uniform = null
		update_suit_sensors()
		if(!QDELETED(src))
			update_inv_w_uniform()
		if(invdrop)
			if(r_store && !can_equip(r_store, SLOT_R_STORE, TRUE))
				dropItemToGround(r_store, TRUE) //Again, makes sense for pockets to drop.
			if(l_store && !can_equip(l_store, SLOT_L_STORE, TRUE))
				dropItemToGround(l_store, TRUE)
			if(wear_id && !can_equip(wear_id, SLOT_WEAR_ID, TRUE))
				dropItemToGround(wear_id)
			if(belt && !can_equip(belt, SLOT_BELT, TRUE))
				dropItemToGround(belt)
	else if(I == gloves)
		gloves = null
		if(!QDELETED(src))
			update_inv_gloves()
	else if(I == glasses)
		glasses = null
		var/obj/item/clothing/glasses/G = I
		if(G.glass_colour_type)
			update_glasses_color(G, 0)
		if(G.tint)
			update_tint()
		if(G.vision_correction)
			if(HAS_TRAIT(src, TRAIT_NEARSIGHT))
				overlay_fullscreen("nearsighted", /atom/movable/screen/fullscreen/impaired, 1)
		if(G.vision_flags || G.darkness_view || G.invis_override || G.invis_view || !isnull(G.lighting_alpha))
			update_sight()
		if(!QDELETED(src))
			update_inv_glasses()
	else if(I == ears)
		ears = null
		if(!QDELETED(src))
			update_inv_ears()
	else if(I == shoes)
		shoes = null
		if(!QDELETED(src))
			update_inv_shoes()
	else if(I == belt)
		belt = null
		if(!QDELETED(src))
			update_inv_belt()
	else if(I == wear_id)
		wear_id = null
		sec_hud_set_ID()
		if(!QDELETED(src))
			update_inv_wear_id()
	else if(I == r_store)
		r_store = null
		if(!QDELETED(src))
			update_inv_pockets()
	else if(I == l_store)
		l_store = null
		if(!QDELETED(src))
			update_inv_pockets()
	else if(I == s_store)
		s_store = null
		if(!QDELETED(src))
			update_inv_s_store()

/mob/living/carbon/human/toggle_internals(obj/item/tank, is_external = FALSE)
	// Just close the tank if it's the one the mob already has open.
	var/obj/item/existing_tank = is_external ? external : internal
	if(tank == existing_tank)
		return toggle_close_internals(is_external)
	// Use breathing tube regardless of mask.
	if(can_breathe_tube())
		return toggle_open_internals(tank, is_external)
	// Use mask in absence of tube.
	if(isclothing(wear_mask) && ((wear_mask.visor_flags & MASKINTERNALS) || (wear_mask.clothing_flags & MASKINTERNALS)))
		// Adjust dishevelled breathing mask back onto face.
		if (wear_mask.mask_adjusted)
			wear_mask.adjustmask(src)
		return toggle_open_internals(tank, is_external)
	// Use helmet in absence of tube or valid mask.
	if(can_breathe_helmet())
		return toggle_open_internals(tank, is_external)
	// Notify user of missing valid breathing apparatus.
	if (wear_mask)
		// Invalid mask
		to_chat(src, span_warning("[wear_mask] can't use [tank]!"))
	else if (head)
		// Invalid headgear
		to_chat(src, span_warning("[head] isn't airtight! You need a mask!"))
	else
		// Not wearing any breathing apparatus.
		to_chat(src, span_warning("You need a mask!"))

/// Returns TRUE if the tank successfully toggles open/closed. Opens the tank only if a breathing apparatus is found.
/mob/living/carbon/human/toggle_externals(obj/item/tank)
	return toggle_internals(tank, TRUE)

/mob/living/carbon/human/wear_mask_update(obj/item/I, toggle_off = 1)
	if((I.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || (initial(I.flags_inv) & (HIDEHAIR|HIDEFACIALHAIR)))
		update_hair()
	// Close internal air tank if mask was the only breathing apparatus.
	if(invalid_internals())
		cutoff_internals()
	if(I.flags_inv & HIDEEYES)
		update_inv_glasses()
	sec_hud_set_security_status()
	..()

/mob/living/carbon/human/head_update(obj/item/I, forced)
	if((I.flags_inv & (HIDEHAIR|HIDEFACIALHAIR)) || forced)
		update_hair()
	else
		var/obj/item/clothing/C = I
		if(istype(C) && C.dynamic_hair_suffix)
			update_hair()
	// Close internal air tank if helmet was the only breathing apparatus.
	if (invalid_internals())
		cutoff_internals()
	if(I.flags_inv & HIDEEYES || forced)
		update_inv_glasses()
	if(I.flags_inv & HIDEEARS || forced)
		update_body()
	sec_hud_set_security_status()
	..()

/mob/living/carbon/human/proc/equipOutfit(outfit, visualsOnly = FALSE)
	var/datum/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return FALSE
	if(!O)
		return FALSE

	return O.equip(src, visualsOnly)


//delete all equipment without dropping anything
/mob/living/carbon/human/proc/delete_equipment()
	for(var/slot in get_all_slots())//order matters, dependant slots go first
		qdel(slot)
	for(var/obj/item/I in held_items)
		qdel(I)

/mob/living/carbon/human/proc/smart_equipbag() // take most recent item out of bag or place held item in bag
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_back = get_item_by_slot(SLOT_BACK)
	if(!equipped_back) // We also let you equip a backpack like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no backpack to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_BACK))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_back, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_back.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in backpack
		if(!SEND_SIGNAL(equipped_back, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(!equipped_back.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your backpack to take out!</span>")
		return
	var/obj/item/stored = equipped_back.contents[equipped_back.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from backpack
	return

/mob/living/carbon/human/proc/smart_equipbelt() // put held thing in belt or take most recent item out of belt
	if(incapacitated())
		return
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_belt = get_item_by_slot(SLOT_BELT)
	if(!equipped_belt) // We also let you equip a belt like this
		if(!thing)
			to_chat(src, "<span class='warning'>You have no belt to take something out of!</span>")
			return
		if(equip_to_slot_if_possible(thing, SLOT_BELT))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_belt, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_belt.attack_hand(src)
		else
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(thing) // put thing in belt
		if(!SEND_SIGNAL(equipped_belt, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, "<span class='warning'>You can't fit anything in!</span>")
		return
	if(!equipped_belt.contents.len) // nothing to take out
		to_chat(src, "<span class='warning'>There's nothing in your belt to take out!</span>")
		return
	var/obj/item/stored = equipped_belt.contents[equipped_belt.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from belt
	return

/mob/living/carbon/human/proc/smart_equipsuit()
	var/obj/item/thing = get_active_held_item()
	var/obj/item/equipped_suit = get_item_by_slot(SLOT_S_STORE)
	if(!equipped_suit) 
		if(!thing)
			to_chat(src, span_notice("You have no suit storage to take something out of."))
			return
		if(equip_to_slot_if_possible(thing, SLOT_S_STORE))
			update_inv_hands()
		return
	if(!SEND_SIGNAL(equipped_suit, COMSIG_CONTAINS_STORAGE)) // not a storage item
		if(!thing)
			equipped_suit.attack_hand(src)
		else
			to_chat(src, span_notice("You can't fit anything in."))
		return
	if(thing) // put thing in suit storage
		if(!SEND_SIGNAL(equipped_suit, COMSIG_TRY_STORAGE_INSERT, thing, src))
			to_chat(src, span_notice("You can't fit anything in."))
		return
	if(!equipped_suit.contents.len) // nothing to take out
		to_chat(src, span_notice("There's nothing in your suit storage to take out."))
		return
	var/obj/item/stored = equipped_suit.contents[equipped_suit.contents.len]
	if(!stored || stored.on_found(src))
		return
	stored.attack_hand(src) // take out thing from suit storage
	return
