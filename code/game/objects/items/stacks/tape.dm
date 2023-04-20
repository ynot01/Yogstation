/obj/item/stack/tape
	name = "tape"
	singular_name = "tape"
	desc = "Used for sticking things together."
	icon = 'icons/obj/tapes.dmi'
	icon_state = "tape_w"
	item_flags = NOBLUDGEON
	amount = 1
	max_amount = 5
	resistance_flags = FLAMMABLE
	grind_results = list(/datum/reagent/cellulose = 5)
	var/maximum_weight_class = WEIGHT_CLASS_SMALL
	var/static/list/tape_blacklist = typecacheof(/obj/item/grenade, /obj/item/slime_extract, /obj/item/slimecross) //stuff you can't take that may or may not be max_weight_class
	var/fall_chance = 10
	var/removal_time = 0
	var/removal_pain = 0

/obj/item/stack/tape/attack(mob/living/M, mob/user)
	. = ..()
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/obj/item/clothing/mask/muzzle/tape/tape_muzzle = new()
		if(!tape_muzzle.mob_can_equip(M, null, SLOT_WEAR_MASK, TRUE, TRUE))
			to_chat(user, span_warning("You can't tape [M]'s mouth shut!"))
			return
		playsound(user, 'sound/effects/tape.ogg', 25)
		M.visible_message(span_danger("[user] is trying to put [tape_muzzle.name] on [M]!"), span_userdanger("[user] is trying to put [tape_muzzle.name] on [M]!"))
		if(!do_after(user, 2 SECONDS, M))
			qdel(tape_muzzle)
			return
		if(!M.equip_to_slot_or_del(tape_muzzle, SLOT_WEAR_MASK, user))
			to_chat(user, span_warning("You fail tape [M]'s mouth shut!"))
			qdel(tape_muzzle)
			return
		use(1)
	else
		to_chat(user,span_warning("You must be targetting the mouth to tape [M.p_their()] mouth!"))

/obj/item/stack/tape/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !istype(target, /obj/item))
		return
	var/obj/item/I = target
	if(I.is_sharp())
		to_chat(user, span_warning("[I] would cut the tape if you tried to wrap it!"))
		return
	if(I.w_class > maximum_weight_class)
		to_chat(user, span_warning("[I] is too big!"))
		return
	var/list/item_contents = I.GetAllContents()
	for(var/obj/item/C in item_contents)
		if(is_type_in_typecache(C,tape_blacklist))
			to_chat(user, span_warning("The [src] doesn't seem to stick to [I]!"))
			return
	to_chat(user, span_info("You wrap [I] with [src]."))
	use(1)
	I.embedding = I.embedding.setRating(100, fall_chance, 0, 0, 0, 0, removal_pain, removal_time, TRUE)
	I.taped = TRUE

/obj/item/stack/tape/guerrilla
	name = "guerrilla tape"
	singular_name = "guerrilla tape"
	desc = "A suspicious looking roll of tape. It seems to be much more adhesive than the standard variety."
	icon_state = "tape_evil"
	amount = 5
	removal_pain = 10
	removal_time = 2 SECONDS //six seconds
	fall_chance = 5
	maximum_weight_class = WEIGHT_CLASS_BULKY
