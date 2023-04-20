/*
April 3rd, 2014 marks the day this machine changed the face of the kitchen on NTStation13
God bless America.
          ___----------___
        _--                ----__
       -                         ---_
      -___    ____---_              --_
  __---_ .-_--   _ O _-                -
 -      -_-       ---                   -
-   __---------___                       -
- _----                                  -
 -     -_                                 _
 `      _-                                 _
       _                           _-_  _-_ _
      _-                   ____    -_  -   --
      -   _-__   _    __---    -------       -
     _- _-   -_-- -_--                        _
     -_-                                       _
    _-                                          _
    -
*/

#define DEEPFRYER_COOKTIME 60
#define DEEPFRYER_BURNTIME 120

/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "fryer_off"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	layer = BELOW_OBJ_LAYER
	var/obj/item/reagent_containers/food/snacks/deepfryholder/frying	//What's being fried RIGHT NOW?
	var/cook_time = 0
	var/oil_use = 0.025 //How much cooking oil is used per second
	var/fry_speed = 1 //How quickly we fry food
	var/superfry = 0
	var/frying_fried //If the object has been fried; used for messages
	var/frying_burnt //If the object has been burnt
	var/static/list/deepfry_blacklisted_items = typecacheof(list(
		/obj/item/screwdriver,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/weldingtool,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/food/condiment,
		/obj/item/storage,
		/obj/item/smallDelivery,
		/obj/item/his_grace,
		/obj/item/syndicate_basket
		))
	var/datum/looping_sound/deep_fryer/fry_loop

/obj/machinery/deepfryer/Initialize()
	. = ..()
	create_reagents(50, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/consumable/cooking_oil, 25)
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/deep_fryer(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	RefreshParts()
	fry_loop = new(list(src), FALSE)

/obj/machinery/deepfryer/RefreshParts()
	var/oil_efficiency
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		oil_efficiency += M.rating
	oil_use = initial(oil_use) - (oil_efficiency * 0.00475)
	fry_speed = oil_efficiency

/obj/machinery/deepfryer/examine(mob/user)
	. = ..()
	if(frying)
		. += "You can make out \a [frying] in the oil."
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Frying at <b>[fry_speed*100]%</b> speed.<br>Using <b>[oil_use]</b> units of oil per second.<span>"

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/pill))
		if(!reagents.total_volume)
			to_chat(user, span_warning("There's nothing to dissolve [I] in!"))
			return
		user.visible_message(span_notice("[user] drops [I] into [src]."), span_notice("You dissolve [I] in [src]."))
		I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = user)
		qdel(I)
		return
	if(istype(I, /obj/item/syndicate_basket))
		if(!superfry)
			to_chat(user, span_warning("You add [I] to the [src]. "))
			qdel(I)
			icon_state = "syndie_fryer_off"
			superfry = 1
			return
		else
			to_chat(user, span_warning("There is already a syndicate frying basket in [src]."))
			return
	if(!reagents.has_reagent(/datum/reagent/consumable/cooking_oil))
		to_chat(user, span_warning("[src] has no cooking oil to fry with!"))
		return
	if(I.resistance_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("You don't feel it would be wise to fry [I]..."))
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/deepfryholder))
		to_chat(user, span_userdanger("Your cooking skills are not up to the legendary Doublefry technique."))
		return
	if(istype(I, /obj/item/crowbar))
		if(superfry)
			to_chat(user, "<span class ='warning'>You pry the syndicate frying basket out of [src].</span>")
			icon_state = "fryer_off"
			superfry = 0
			var/turf/T = get_turf(src)
			new /obj/item/syndicate_basket(T)
			return
	if(default_unfasten_wrench(user, I))
		return
	else if(default_deconstruction_screwdriver(user, "fryer_off", "fryer_off" ,I))	//where's the open maint panel icon?!
		return
	else
		if(user.a_intent != INTENT_HELP)
			return ..()
		if((!superfry && !I.fryable) || HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
			to_chat(user, span_warning("Your cooking skills do not allow you to fry [I]..."))
			return
		else if(!frying && user.transferItemToLoc(I, src))
			to_chat(user, span_notice("You put [I] into [src]."))
			var/item_reags = I.grind_results
			frying = new/obj/item/reagent_containers/food/snacks/deepfryholder(src, I)
			frying.reagents.add_reagent_list(item_reags)
			icon_state = "fryer_on"
			if(superfry)
				icon_state = "syndie_fryer_on"
			fry_loop.start()

/obj/machinery/deepfryer/process(delta_time)
	..()
	var/datum/reagent/consumable/cooking_oil/C = reagents.has_reagent(/datum/reagent/consumable/cooking_oil)
	if(!C)
		return
	reagents.chem_temp = C.fry_temperature
	if(frying)
		reagents.trans_to(frying, oil_use * delta_time, multiplier = fry_speed * 3) //Fried foods gain more of the reagent thanks to space magic
		cook_time += fry_speed * delta_time
		if(cook_time >= DEEPFRYER_COOKTIME && !frying_fried)
			frying_fried = TRUE //frying... frying... fried
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			audible_message(span_notice("[src] dings!"))
		else if (cook_time >= DEEPFRYER_BURNTIME && !frying_burnt)
			frying_burnt = TRUE
			visible_message(span_warning("[src] emits an acrid smell!"))

/obj/machinery/deepfryer/attack_ai(mob/user)
	return

/obj/machinery/deepfryer/attack_hand(mob/user)
	if(frying)
		if(frying.loc == src)
			to_chat(user, span_notice("You eject [frying] from [src]."))
			frying.fry(cook_time)
			icon_state = "fryer_off"
			if(superfry)
				icon_state = "syndie_fryer_off"
			frying.forceMove(drop_location())
			if(Adjacent(user) && !issilicon(user))
				user.put_in_hands(frying)
			frying = null
			cook_time = 0
			frying_fried = FALSE
			frying_burnt = FALSE
			fry_loop.stop()
			return
	if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		if(superfry)
			var/mob/living/H = user.pulling
			if(H.stat == DEAD)
				to_chat(user, "<span class ='notice'>You dunk [H] into [src],</span>")
				frying = new/obj/item/reagent_containers/food/snacks/deepfryholder(src, H)
				icon_state = "fryer_on"
				if(superfry)	
					icon_state = "syndie_fryer_on"
				for(var/obj/item/W in H)
					if(!H.dropItemToGround(W))
						qdel(W)
						H.regenerate_icons()
				qdel(H)
				fry_loop.start()
				return
	if(user.pulling && user.a_intent == INTENT_GRAB && ishuman(user.pulling))
		var/mob/living/carbon/human/the_guy = user.pulling
		var/list/missing_limbs = the_guy.get_missing_limbs()
		if(missing_limbs.len >= 4)
			to_chat(user, "<span class ='notice'>You dunk [the_guy] into [src],</span>")
			frying = new /obj/item/reagent_containers/food/snacks/deepfryholder(src, the_guy)
			fry_loop.start()
			icon_state = "fryer_on"
			var /obj/item/reagent_containers/food/snacks/nugget/the_nugget = new /obj/item/reagent_containers/food/snacks/nugget(drop_location(src))
			if(istype(the_guy) && the_guy.mind)
				the_nugget.nugget_man = new(the_nugget)
				the_nugget.nugget_man.real_name = the_nugget.name
				the_nugget.nugget_man.name = the_nugget.name
				the_nugget.nugget_man.stat = CONSCIOUS
				the_guy.mind.transfer_to(the_nugget.nugget_man)
			qdel(the_guy)
			return
				
	if(user.pulling && user.a_intent == INTENT_GRAB && iscarbon(user.pulling) && reagents.total_volume && isliving(user.pulling))
		var/mob/living/carbon/C = user.pulling
		if(user.grab_state < GRAB_AGGRESSIVE)
			to_chat(user, span_warning("You need a better grip to do that!"))
			return
		user.visible_message("<span class = 'danger'>[user] dunks [C]'s face in [src]!</span>")
		reagents.reaction(C, TOUCH)
		var/permeability = 1 - C.get_permeability_protection(list(HEAD))
		C.apply_damage(min(30 * permeability, reagents.total_volume), BURN, BODY_ZONE_HEAD)
		reagents.remove_any((reagents.total_volume/2))
		C.Paralyze(60)
		user.changeNext_move(CLICK_CD_MELEE)
	return ..()

/obj/item/syndicate_basket
	name = "syndicate frying basket"
	icon = 'icons/obj/kitchen.dmi' 
	icon_state = "syndicate_basket"
	item_state = "syndicate_basket"
	desc = "It looks like it could be attached to a deep fryer."


#undef DEEPFRYER_COOKTIME
#undef DEEPFRYER_BURNTIME
