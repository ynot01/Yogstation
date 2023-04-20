/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stack_medical.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	var/self_delay = 50
	var/other_delay = 0
	/// Sound/Sounds to play when this is applied
	var/apply_sounds
	var/repeating = FALSE
	/// How much brute we heal per application
	var/heal_brute
	/// How much burn we heal per application
	var/heal_burn
	/// How much we reduce bleeding per application on cut wounds
	var/stop_bleeding
	/// How much sanitization to apply to burns on application
	var/sanitization
	/// How much we add to flesh_healing for burn wounds on application
	var/flesh_regeneration
	/// If set and this used as a splint for a broken bone wound, this is used as a multiplier for applicable slowdowns (lower = better) (also for speeding up burn recoveries)
	var/splint_factor
	/// How much blood flow this stack can absorb if used as a bandage on a cut wound, note that absorption is how much we lower the flow rate, not the raw amount of blood we suck up
	var/absorption_capacity
	/// How quickly we lower the blood flow on a cut wound we're bandaging. Expected lifetime of this bandage in ticks is thus absorption_capacity/absorption_rate, or until the cut heals, whichever comes first
	var/absorption_rate
	/// Coefficient for applying this stack to a wound
	var/treatment_speed = 1

/obj/item/stack/medical/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)

/obj/item/stack/medical/get_belt_overlay()
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "stack_medical")

/obj/item/stack/medical/proc/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!M.can_inject(user, TRUE))
		return
	if(M == user)
		playsound(src, pick(apply_sounds), 25)
		if(!silent)
			user.visible_message(span_notice("[user] starts to apply \the [src] on [user.p_them()]self..."), span_notice("You begin applying \the [src] on yourself..."))
		if(!do_mob(user, M, self_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return
	else if(other_delay)
		playsound(src, pick(apply_sounds), 25)
		if(!silent)
			user.visible_message(span_notice("[user] starts to apply \the [src] on [M]."), span_notice("You begin applying \the [src] on [M]..."))
		if(!do_mob(user, M, other_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return

	if(heal(M, user))
		log_combat(user, M, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(M, user, TRUE)

/obj/item/stack/medical/proc/heal(mob/living/M, mob/user)
	return

/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, span_warning("[C] doesn't have \a [parse_zone(user.zone_selected)]!"))
		return
	if(affecting.status != BODYPART_ORGANIC) //Limb must be organic to be healed - RR
		to_chat(user, span_warning("[src] won't work on a robotic limb!"))
		return
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message(span_green("[user] applies [src] on [C]'s [affecting.name]."), span_green("You apply [src] on [C]'s [affecting.name]."))
		var/previous_damage = affecting.get_damage()
		if(affecting.heal_damage(brute, burn))
			C.update_damage_overlays()
		post_heal_effects(max(previous_damage - affecting.get_damage(), 0), C, user)
		return TRUE
	to_chat(user, span_warning("[C]'s [affecting.name] can not be healed with \the [src]!"))
	return FALSE

///Override this proc for special post heal effects.
/obj/item/stack/medical/proc/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	return


/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A therapeutic gel pack and bandages designed to treat blunt-force trauma."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	heal_brute = 40
	self_delay = 40
	other_delay = 20
	grind_results = list(/datum/reagent/medicine/c2/libital = 10)

/obj/item/stack/medical/bruise_pack/heal(mob/living/M, mob/user)
	if(M.stat == DEAD)
		to_chat(user, span_warning("[M] is dead! You can not help [M.p_them()]."))
		return
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, span_warning("You cannot use \the [src] on [M]!"))
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, span_notice("[M] is at full health."))
			return FALSE
		user.visible_message(span_green("[user] applies \the [src] on [M]."), span_green("You apply \the [src] on [M]."))
		M.heal_bodypart_damage((heal_brute/2))
		return TRUE
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, heal_burn)
	to_chat(user, span_warning("You can't heal [M] with \the [src]!"))

/obj/item/stack/medical/bruise_pack/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is bludgeoning [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/stack/medical/gauze
	name = "medical gauze"
	desc = "A roll of elastic cloth, perfect for stabilizing all kinds of wounds, from cuts and burns, to broken bones. "
	gender = PLURAL
	singular_name = "medical gauze"
	icon_state = "gauze"
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	self_delay = 50
	other_delay = 20
	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = 100
	absorption_rate = 0.25
	absorption_capacity = 5
	splint_factor = 0.35

// gauze is only relevant for wounds, which are handled in the wounds themselves
/obj/item/stack/medical/gauze/try_heal(mob/living/M, mob/user, silent)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_notice("There's nothing there to bandage!"))
		return
	if(!LAZYLEN(limb.wounds))
		to_chat(user, span_notice("There's no wounds that require bandaging on [user==M ? "your" : "[M]'s"] [limb.name]!")) // good problem to have imo
		return

	var/gauzeable_wound = FALSE
	for(var/i in limb.wounds)
		var/datum/wound/woundies = i
		if(woundies.wound_flags & ACCEPTS_GAUZE)
			gauzeable_wound = TRUE
			break
	if(!gauzeable_wound)
		to_chat(user, span_notice("There's no wounds that require bandaging on [user==M ? "your" : "[M]'s"] [limb.name]!")) // good problem to have imo
		return

	if(limb.current_gauze && (limb.current_gauze.absorption_capacity * 0.8 > absorption_capacity)) // ignore if our new wrap is < 20% better than the current one, so someone doesn't bandage it 5 times in a row
		to_chat(user, span_warning("The bandage currently on [user==M ? "your" : "[M]'s"] [limb.name] is still in good condition!"))
		return

	user.visible_message(span_warning("[user] begins wrapping the wounds on [M]'s [limb.name] with [src]..."), span_warning("You begin wrapping the wounds on [user == M ? "your" : "[M]'s"] [limb.name] with [src]..."))

	playsound(src, 'sound/effects/rip2.ogg', 25)

	if(!do_after(user, (user == M ? self_delay : other_delay), M))
		return

	playsound(src, 'sound/effects/rip1.ogg', 25)

	user.visible_message(span_green("[user] applies [src] to [M]'s [limb.name]."), span_green("You bandage the wounds on [user == M ? "yourself" : "[M]'s"] [limb.name]."))
	limb.apply_gauze(src)

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.sharpness)
		if(get_amount() < 2)
			to_chat(user, span_warning("You need at least two gauzes to do this!"))
			return
		new /obj/item/stack/sheet/cloth(user.drop_location())
		user.visible_message(span_notice("[user] cuts [src] into pieces of cloth with [I]."), \
					 span_notice("You cut [src] into pieces of cloth with [I]."), \
					 span_hear("You hear cutting."))
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins tightening \the [src] around [user.p_their()] neck! It looks like [user.p_they()] forgot how to use medical supplies!"))
	return OXYLOSS

/obj/item/stack/medical/gauze/improvised
	name = "improvised gauze"
	singular_name = "improvised gauze"
	desc = "A roll of cloth roughly cut from something that does a decent job of stabilizing wounds, but less efficiently so than real medical gauze."
	self_delay = 60
	other_delay = 30
	absorption_rate = 0.15
	absorption_capacity = 4

/obj/item/stack/medical/gauze/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 250

/obj/item/stack/medical/suture
	name = "suture"
	desc = "Basic sterile sutures used to seal up cuts and lacerations and stop bleeding."
	gender = PLURAL
	singular_name = "suture"
	icon_state = "suture"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	repeating = TRUE
	heal_brute = 10
	stop_bleeding = 0.6
	grind_results = list(/datum/reagent/space_cleaner/sterilizine = 2)

/obj/item/stack/medical/suture/emergency
	name = "emergency suture"
	desc = "A value pack of cheap sutures, not very good at repairing damage, but still decent at stopping bleeding."
	icon_state = "suture_green"
	heal_brute = 5
	amount = 5
	max_amount = 5
	grind_results = list(/datum/reagent/space_cleaner/sterilizine = 1)

/obj/item/stack/medical/suture/emergency/makeshift
	name = "makeshift suture"
	desc = "A makeshift suture, gnarly looking, but it...should work."
	heal_brute = 4
	stop_bleeding = 0.44
	amount = 5
	max_amount = 5
	grind_results = null

/obj/item/stack/medical/suture/emergency/makeshift/tribal
	name = "sinew suture"
	desc = "A suture created from well processed sinew, with a bone needle"
	icon_state = "suture_tribal"
	heal_brute = 6
	stop_bleeding = 0.55
	amount = 10
	max_amount = 10
	grind_results = list(/datum/reagent/liquidgibs = 2)

/obj/item/stack/medical/suture/medicated
	name = "medicated suture"
	icon_state = "suture_purp"
	desc = "A suture infused with drugs that speed up wound healing of the treated laceration."
	amount = 25
	max_amount = 25
	heal_brute = 15
	stop_bleeding = 0.75
	treatment_speed = 0.5
	grind_results = list(/datum/reagent/medicine/polypyr = 2)

/obj/item/stack/medical/suture/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, span_warning("[M] is dead! You can not help [M.p_them()]."))
		return
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, heal_burn)
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, span_warning("You cannot use \the [src] on [M]!"))
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, span_notice("[M] is at full health."))
			return FALSE
		user.visible_message(span_green("[user] applies \the [src] on [M]."), span_green("You apply \the [src] on [M]."))
		M.heal_bodypart_damage(heal_brute)
		return TRUE

	to_chat(user, span_warning("You can't heal [M] with \the [src]!"))

/obj/item/stack/medical/ointment
	name = "burn ointment"
	desc = "Basic burn ointment, rated effective for second degree burns with proper bandaging, though it's still an effective stabilizer for worse burns. Not terribly good at outright healing burns though."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = list('sound/effects/ointment.ogg')
	amount = 8
	max_amount = 8
	self_delay = 40
	other_delay = 20
	repeating = TRUE
	heal_burn = 5
	flesh_regeneration = 2.5
	sanitization = 0.25
	grind_results = list(/datum/reagent/medicine/c2/lenturi = 10)

/obj/item/stack/medical/ointment/heal(mob/living/M, mob/user)
	if(M.stat == DEAD)
		to_chat(user, span_warning("[M] is dead! You can not help [M.p_them()]."))
		return
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, heal_burn)
	to_chat(user, span_warning("You can't heal [M] with \the [src]!"))

/obj/item/stack/medical/ointment/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is squeezing \the [src] into [user.p_their()] mouth! [user.p_do(TRUE)]n't [user.p_they()] know that stuff is toxic?"))
	return TOXLOSS

/obj/item/stack/medical/ointment/antiseptic
	name = "antiseptic ointment"
	desc = "A specialized ointment, designed with preventing infections in mind."
	icon_state = "aointment"
	amount = 15
	max_amount = 15
	heal_burn = 3
	sanitization = 1.0 // its main purpose is to disinfect
	grind_results = list(/datum/reagent/space_cleaner/sterilizine = 10)

/obj/item/stack/medical/mesh
	name = "regenerative mesh"
	desc = "A bacteriostatic mesh used to dress burns."
	gender = PLURAL
	singular_name = "regenerative mesh"
	icon_state = "regen_mesh"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	heal_burn = 10
	repeating = TRUE
	sanitization = 0.75
	flesh_regeneration = 3

	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/space_cleaner/sterilizine = 2)

/obj/item/stack/medical/mesh/Initialize()
	. = ..()
	if(amount == max_amount)	 //only seal full mesh packs
		is_open = FALSE
		update_icon()

/obj/item/stack/medical/mesh/update_icon()
	if(is_open)
		return ..()
	icon_state = "regen_mesh_closed"

/obj/item/stack/medical/mesh/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, span_warning("[M] is dead! You can not help [M.p_them()]."))
		return
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, heal_burn)
	to_chat(user, span_warning("You can't heal [M] with \the [src]!"))


/obj/item/stack/medical/mesh/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	. = ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user)
	if(!is_open && user.get_inactive_held_item() == src)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, span_notice("You open the sterile mesh package."))
		update_icon()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	. = ..()

/obj/item/stack/medical/mesh/advanced
	name = "advanced regenerative mesh"
	desc = "An advanced mesh made with sterilizing chemicals, used to treat burns."
	gender = PLURAL
	singular_name = "advanced regenerative mesh"
	icon_state = "aloe_mesh"
	amount = 25
	max_amount = 25
	heal_burn = 15
	sanitization = 1.25
	flesh_regeneration = 3.5
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/mesh/advanced/update_icon()
	if(is_open)
		return ..()
	icon_state = "aloe_mesh_closed"

/obj/item/stack/medical/aloe
	name = "aloe cream"
	desc = "A healing paste you can apply on wounds."
	icon_state = "aloe_paste"
	apply_sounds = list('sound/effects/ointment.ogg')
	self_delay = 20
	other_delay = 10
	novariants = TRUE
	repeating = TRUE
	amount = 20
	max_amount = 20
	var/heal = 5 //aloe is good for the burns but does not sterilize much at all
	sanitization = 0.1
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/aloe/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, span_warning("[M] is dead! You can not help [M.p_them()]."))
		return FALSE
	if(iscarbon(M))
		M.adjustFireLoss(-heal, TRUE) //there's other, infinitely better ways to heal brute damage.
		return
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, span_warning("You cannot use \the [src] on [M]!"))
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, span_notice("[M] is at full health."))
			return FALSE
		user.visible_message(span_green("[user] applies \the [src] on [M]."), span_green("You apply \the [src] on [M]."))
		M.heal_bodypart_damage(heal, heal)
		return TRUE

	to_chat(user, span_warning("You can't heal [M] with the \the [src]!"))

	/*
	The idea is for these medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	 */

/obj/item/stack/medical/bone_gel
	name = "bone gel"
	singular_name = "bone gel"
	desc = "A potent medical gel that, when applied to a damaged bone in a proper surgical setting, triggers an intense melding reaction to repair the wound. Can be directly applied alongside surgical sticky tape to a broken bone in dire circumstances, though this is very harmful to the patient and not recommended."

	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = list('sound/effects/ointment.ogg')

	amount = 4
	self_delay = 20
	grind_results = list(/datum/reagent/medicine/c2/libital = 10)
	novariants = TRUE

/obj/item/stack/medical/bone_gel/attack(mob/living/M, mob/user)
	to_chat(user, span_warning("Bone gel can only be used on fractured limbs!"))
	return

/obj/item/stack/medical/bone_gel/suicide_act(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.visible_message(span_suicide("[C] is squirting all of \the [src] into [C.p_their()] mouth! That's not proper procedure! It looks like [C.p_theyre()] trying to commit suicide!"))
		if(do_after(C, 2 SECONDS))
			C.emote("scream")
			for(var/i in C.bodyparts)
				var/obj/item/bodypart/bone = i
				var/datum/wound/blunt/severe/oof_ouch = new
				oof_ouch.apply_wound(bone)
				var/datum/wound/blunt/critical/oof_OUCH = new
				oof_OUCH.apply_wound(bone)

			for(var/i in C.bodyparts)
				var/obj/item/bodypart/bone = i
				bone.receive_damage(brute=60)
			use(1)
			return (BRUTELOSS)
		else
			C.visible_message(span_suicide("[C] screws up like an idiot and still dies anyway!"))
			return (BRUTELOSS)

/obj/item/stack/medical/bone_gel/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 250

/obj/item/stack/medical/poultice
	name = "mourning poultices"
	singular_name = "mourning poultice"
	desc = "A type of primitive herbal poultice.\nWhile traditionally used to prepare corpses for the mourning feast, it can also treat scrapes and burns on the living, however, it is liable to cause shortness of breath when employed in this manner.\nIt is imbued with ancient wisdom."
	icon_state = "poultice"
	apply_sounds = list('sound/misc/soggy.ogg')
	amount = 15
	max_amount = 15
	heal_brute = 10
	heal_burn = 10
	self_delay = 40
	other_delay = 10
	repeating = TRUE
	hitsound = 'sound/misc/moist_impact.ogg'
	merge_type = /obj/item/stack/medical/poultice

/obj/item/stack/medical/poultice/heal(mob/living/M, mob/user)
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, heal_burn)
	return ..()

/obj/item/stack/medical/poultice/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	healed_mob.adjustOxyLoss(amount_healed)
