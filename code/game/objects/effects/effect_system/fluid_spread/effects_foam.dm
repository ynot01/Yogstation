/// The minimum foam range required to start diluting the reagents past the minimum dilution rate.
#define MINIMUM_FOAM_DILUTION_RANGE 3
/// The minumum foam-area based divisor used to decrease foam exposure volume.
#define MINIMUM_FOAM_DILUTION DIAMOND_AREA(MINIMUM_FOAM_DILUTION_RANGE)
///	The effective scaling of the reagents in the foam. (Total delivered at or below [MINIMUM_FOAM_DILUTION])
#define FOAM_REAGENT_SCALE 3.2

/**
 * ## Foam
 *
 * Similar to smoke, but slower and mobs absorb its reagent through their exposed skin.
 */
/obj/effect/particle_effect/fluid/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = EDGED_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = NO_STEPS
	/// The types of turfs that this foam cannot spread to.
	var/static/list/blacklisted_turfs = typecacheof(list(
		/turf/open/space/transit,
		/turf/open/chasm,
		/turf/open/lava,
	))
	/// The typepath for what this foam leaves behind when it dissipates.
	var/atom/movable/result_type = null
	/// Whether or not this foam can produce a remnant movable if something of the same type is already on its turf.
	var/allow_duplicate_results = TRUE
	/// The amount of time this foam stick around for before it dissipates.
	var/lifetime = 8 SECONDS
	/// Whether or not this foam should be slippery.
	var/slippery_foam = TRUE


/obj/effect/particle_effect/fluid/foam/Initialize(mapload)
	. = ..()
	if(slippery_foam)
		AddComponent(/datum/component/slippery, 100)
	create_reagents(1000)
	playsound(src, 'sound/effects/bubbles2.ogg', 80, TRUE, -3)
	//AddElement(/datum/element/atmos_sensitive, mapload)
	SSfoam.start_processing(src)

/obj/effect/particle_effect/fluid/foam/Destroy()
	SSfoam.stop_processing(src)
	if (spread_bucket)
		SSfoam.cancel_spread(src)
	return ..()

/**
 * Makes the foam dissipate and create whatever remnants it must.
 */
/obj/effect/particle_effect/fluid/foam/proc/kill_foam()
	SSfoam.stop_processing(src)
	if (spread_bucket)
		SSfoam.cancel_spread(src)
	make_result()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 0.5 SECONDS)

/**
 * Makes the foam leave behind something when it dissipates.
 *
 * Returns the thing the foam leaves behind for further modification by subtypes.
 */
/obj/effect/particle_effect/fluid/foam/proc/make_result()
	if(isnull(result_type))
		return null

	var/atom/location = loc
	var/atom/movable/result = (!allow_duplicate_results && (locate(result_type) in location)) || (new result_type(location))
	transfer_fingerprints_to(result)
	return result

/obj/effect/particle_effect/fluid/foam/process(delta_time)
	var/ds_delta_time = delta_time SECONDS
	lifetime -= ds_delta_time
	if(lifetime <= 0)
		kill_foam()
		return

	var/fraction = (ds_delta_time * MINIMUM_FOAM_DILUTION) / (initial(lifetime) * max(MINIMUM_FOAM_DILUTION, group.total_size))
	var/turf/location = loc
	for(var/obj/object in location)
		if(object == src)
			continue
		if(isturf(object.loc))
			if(location.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && HAS_TRAIT(object, TRAIT_T_RAY_VISIBLE))
				continue
		reagents.reaction(object, TOUCH|VAPOR, fraction)

	var/hit = 0
	for(var/mob/living/foamer in location)
		if(istype(foamer) && !foamer.foam_delay)
			hit += foam_mob(foamer, delta_time)
	if(hit)
		lifetime += ds_delta_time //this is so the decrease from mobs hit and the natural decrease don't cumulate.

	reagents.reaction(location, TOUCH|VAPOR, fraction)

/**
 * Applies the effect of this foam to a mob.
 *
 * Arguments:
 * - [foaming][/mob/living]: The mob that this foam is acting on.
 * - delta_time: The amount of time that this foam is acting on them over.
 *
 * Returns:
 * - [TRUE]: If the foam was successfully applied to the mob. Used to scale how quickly foam dissipates according to the number of mobs it is applied to.
 * - [FALSE]: Otherwise.
 */
/obj/effect/particle_effect/fluid/foam/proc/foam_mob(mob/living/foaming, delta_time)
	if(lifetime <= 0)
		return FALSE
	if(!istype(foaming))
		return FALSE
	if(foaming.foam_delay)
		return

	delta_time = min(delta_time SECONDS, lifetime)
	var/fraction = (delta_time * MINIMUM_FOAM_DILUTION) / (initial(lifetime) * max(MINIMUM_FOAM_DILUTION, group.total_size))
	reagents.reaction(foaming, TOUCH|VAPOR, fraction)
	lifetime -= delta_time
	foaming.foam_delay = TRUE
	addtimer(VARSET_CALLBACK(foaming, foam_delay, FALSE), 1 SECONDS)
	return TRUE

/obj/effect/particle_effect/fluid/foam/spread(delta_time = 0.2 SECONDS)
	if(group.total_size > group.target_size)
		return
	var/turf/location = get_turf(src)
	if(!istype(location))
		return FALSE

	for(var/turf/spread_turf as anything in location.reachableAdjacentAtmosTurfs())
		var/obj/effect/particle_effect/fluid/foam/foundfoam = locate() in spread_turf //Don't spread foam where there's already foam!
		if(foundfoam)
			continue

		if(is_type_in_typecache(spread_turf, blacklisted_turfs))
			continue

		for(var/mob/living/foaming in spread_turf)
			foam_mob(foaming, delta_time)

		var/obj/effect/particle_effect/fluid/foam/spread_foam = new type(spread_turf, group, src)
		reagents.copy_to(spread_foam, (reagents.total_volume))
		spread_foam.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		spread_foam.result_type = result_type
		SSfoam.queue_spread(spread_foam)

/obj/effect/particle_effect/fluid/foam/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 475)))   //foam dissolves when heated
		kill_foam()

/obj/effect/particle_effect/fluid/foam/metal/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/// A factory for foam fluid floods.
/datum/effect_system/fluid_spread/foam
	effect_type = /obj/effect/particle_effect/fluid/foam
	/// A container for all of the chemicals we distribute through the foam.
	var/datum/reagents/chemholder
	/// The amount that
	var/reagent_scale = FOAM_REAGENT_SCALE
	/// What type of thing the foam should leave behind when it dissipates.
	var/atom/movable/result_type = null


/datum/effect_system/fluid_spread/foam/New()
	..()
	chemholder = new(1000, NO_REACT)

/datum/effect_system/fluid_spread/foam/Destroy()
	QDEL_NULL(chemholder)
	return ..()

/datum/effect_system/fluid_spread/foam/set_up(range = 1, amount = DIAMOND_AREA(range), atom/holder, atom/location = null, datum/reagents/carry = null, result_type = null)
	. = ..()
	carry?.copy_to(chemholder, carry.total_volume)
	if(!isnull(result_type))
		src.result_type = result_type

/datum/effect_system/fluid_spread/foam/start(log = FALSE)
	var/obj/effect/particle_effect/fluid/foam/foam = new effect_type(location, new /datum/fluid_group(amount))
	var/foamcolor = mix_color_from_reagents(chemholder.reagent_list)
	if(reagent_scale > 1) // Make room in case we were created by a particularly stuffed payload.
		foam.reagents.maximum_volume *= reagent_scale
	chemholder.copy_to(foam, chemholder.total_volume, reagent_scale) // Foam has an amplifying effect on the reagents it is supplied with. This is balanced by the reagents being diluted as the area the foam covers increases.
	foam.add_atom_colour(foamcolor, FIXED_COLOUR_PRIORITY)
	if(!isnull(result_type))
		foam.result_type = result_type
	if (log)
		help_out_the_admins(foam, holder, location)
	SSfoam.queue_spread(foam)


// Short-lived foam
/// A foam variant which dissipates quickly.
/obj/effect/particle_effect/fluid/foam/short_life
	lifetime = 1 SECONDS

/datum/effect_system/fluid_spread/foam/short
	effect_type = /obj/effect/particle_effect/fluid/foam/short_life

// Long lasting foam
/// A foam variant which lasts for an extended amount of time.
/obj/effect/particle_effect/fluid/foam/long_life
	lifetime = 30 SECONDS

/// A factory which produces foam with an extended lifespan.
/datum/effect_system/fluid_spread/foam/long
	effect_type = /obj/effect/particle_effect/fluid/foam/long_life
	reagent_scale = FOAM_REAGENT_SCALE * (30 / 8)


// Firefighting foam
/// A variant of foam which absorbs plasma in the air if there is a fire.
/obj/effect/particle_effect/fluid/foam/firefighting
	name = "firefighting foam"
	lifetime = 20 //doesn't last as long as normal foam
	result_type = /obj/effect/decal/cleanable/plasma
	allow_duplicate_results = FALSE
	slippery_foam = FALSE
	/// The amount of plasma gas this foam has absorbed. To be deposited when the foam dissipates.
	var/absorbed_plasma = 0
	/// The turf this foam is affecting. Its flammability is set to -10 and later reset to its initial value.
	var/turf/open/affecting_turf

/obj/effect/particle_effect/fluid/foam/firefighting/Initialize(mapload)
	. = ..()
	var/turf/open/T = get_turf(src)
	if(istype(T))
		affecting_turf = T
		affecting_turf.flammability = -10 // set the turf to be non-flammable while the foam is covering it
	//Remove_element(/datum/element/atmos_sensitive)
	var/static/list/loc_connections = list(
		COMSIG_TURF_HOTSPOT_EXPOSE = PROC_REF(on_hotspot_expose),
		COMSIG_TURF_IGNITED = PROC_REF(on_turf_ignite),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/particle_effect/fluid/foam/firefighting/proc/on_hotspot_expose()
	return SUPPRESS_FIRE

/obj/effect/particle_effect/fluid/foam/firefighting/proc/on_turf_ignite()
	return SUPPRESS_FIRE

/obj/effect/particle_effect/fluid/foam/firefighting/Destroy()
	if(affecting_turf && !QDELETED(affecting_turf))
		affecting_turf.flammability = initial(affecting_turf.flammability)
	return ..()

/obj/effect/particle_effect/fluid/foam/firefighting/process()
	. = ..()

	var/turf/open/location = loc
	if(!istype(location))
		return

	var/datum/gas_mixture/air = location.air
	var/scrub_amt = min(30, air.get_moles(GAS_PLASMA)) //Absorb some plasma
	air.adjust_moles(GAS_PLASMA, -scrub_amt)
	absorbed_plasma += scrub_amt

	location.extinguish_turf()

/obj/effect/particle_effect/fluid/foam/firefighting/make_result()
	if(!absorbed_plasma) // don't bother if it didn't scrub any plasma
		return
	var/atom/movable/deposit = ..()
	if(istype(deposit) && deposit.reagents)
		deposit.reagents.add_reagent(/datum/reagent/stable_plasma, absorbed_plasma)
		absorbed_plasma = 0
	return deposit

/obj/effect/particle_effect/fluid/foam/firefighting/foam_mob(mob/living/foaming, delta_time)
	if(!istype(foaming))
		return
	foaming.adjust_wet_stacks(2)
	foaming.extinguish_mob()

/// A factory which produces firefighting foam
/datum/effect_system/fluid_spread/foam/firefighting
	effect_type = /obj/effect/particle_effect/fluid/foam/firefighting

// Metal foam

/// A foam variant which
/obj/effect/particle_effect/fluid/foam/metal
	name = "aluminium foam"
	result_type = /obj/structure/foamedmetal
	icon_state = "mfoam"
	slippery_foam = FALSE

/// A factory which produces aluminium metal foam.
/datum/effect_system/fluid_spread/foam/metal
	effect_type = /obj/effect/particle_effect/fluid/foam/metal

/// FOAM STRUCTURE. Formed by metal foams. Dense and opaque, but easy to break
/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = TRUE // changed in New()
	anchored = TRUE
	layer = EDGED_TURF_LAYER
	resistance_flags = FIRE_PROOF | ACID_PROOF
	name = "foamed metal"
	desc = "A lightweight foamed metal wall that can be used as base to construct a wall."
	gender = PLURAL
	max_integrity = 20
	can_atmos_pass = ATMOS_PASS_DENSITY
	obj_flags = CAN_BE_HIT | BLOCK_Z_IN_DOWN | BLOCK_Z_IN_UP
	///Var used to prevent spamming of the construction sound
	var/next_beep = 0

/obj/structure/foamedmetal/Initialize(mapload)
	. = ..()
	air_update_turf()

/obj/structure/foamedmetal/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/foamedmetal/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/foamedmetal/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src.loc, 'sound/weapons/tap.ogg', 100, TRUE)

/obj/structure/foamedmetal/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	to_chat(user, span_warning("You hit [src] but bounce off it!"))
	playsound(src.loc, 'sound/weapons/tap.ogg', 100, TRUE)

/// A metal foam variant which produces slightly sturdier walls.
/obj/effect/particle_effect/fluid/foam/metal/iron
	name = "iron foam"
	result_type = /obj/structure/foamedmetal/iron

/// A factory which produces iron metal foam.
/datum/effect_system/fluid_spread/foam/metal/iron
	effect_type = /obj/effect/particle_effect/fluid/foam/metal/iron

/// A variant of metal foam walls with higher durability.
/obj/structure/foamedmetal/iron
	max_integrity = 50
	icon_state = "ironfoam"

/// A variant of metal foam which only produces walls at area boundaries.
/obj/effect/particle_effect/fluid/foam/metal/smart
	name = "smart foam"

/// A factory which produces smart aluminium metal foam.
/datum/effect_system/fluid_spread/foam/metal/smart
	effect_type = /obj/effect/particle_effect/fluid/foam/metal/smart

/obj/effect/particle_effect/fluid/foam/metal/smart/make_result() //Smart foam adheres to area borders for walls
	var/turf/open/location = loc
	if(isspaceturf(location))
		location.place_on_top(/turf/open/floor/plating/foam)

	for(var/cardinal in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(location, cardinal)
		if(get_area(cardinal_turf) != get_area(location))
			return ..()
	return null

/datum/effect_system/fluid_spread/foam/metal/resin
	effect_type = /obj/effect/particle_effect/fluid/foam/metal/resin

/// A foam variant which produces atmos resin walls.
/obj/effect/particle_effect/fluid/foam/metal/resin
	name = "resin foam"
	result_type = /obj/structure/foamedmetal/resin

/// Atmos Backpack Resin, transparent, prevents atmos and filters the air
/obj/structure/foamedmetal/resin
	name = "\improper ATMOS Resin"
	desc = "A lightweight, transparent and passable resin used to suffocate fires, scrub the air of toxins, and restore the air to a safe temperature. It can be used as base to construct a wall."
	opacity = FALSE
	density = FALSE
	can_atmos_pass = ATMOS_PASS_NO
	icon_state = "atmos_resin"
	alpha = 120
	max_integrity = 10

/obj/structure/foamedmetal/resin/Initialize(mapload)
	. = ..()
	var/turf/open/location = loc
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	if(!istype(location))
		return

	location.ClearWet()
	if(location.air)
		var/datum/gas_mixture/air = location.air
		air.set_temperature(T20C)
		for(var/obj/effect/hotspot/fire in location)
			qdel(fire)

		for(var/gas_type in air.get_gases())
			switch(gas_type)
				if(GAS_O2, GAS_N2)
					continue
				else
					air.set_moles(gas_type, 0)

	for(var/obj/machinery/atmospherics/components/unary/comp in location)
		if(!comp.welded)
			comp.welded = TRUE
			comp.update_appearance(UPDATE_ICON)
			comp.visible_message(span_danger("[comp] sealed shut!"))

	for(var/mob/living/potential_tinder in location)
		potential_tinder.extinguish_mob()
	for(var/obj/item/potential_tinder in location)
		potential_tinder.extinguish()

/obj/structure/foamedmetal/resin/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER

	if(isliving(arrived)) //I guess living subtype is fine
		var/mob/living/living = arrived
		living.add_movespeed_modifier(MOVESPEED_ID_RESIN_FOAM, multiplicative_slowdown = 0.4)

/obj/structure/foamedmetal/resin/proc/on_exited(datum/source, atom/movable/gone, direction)
	if(isliving(gone))
		var/mob/living/living = gone
		var/turf/T = get_turf(src)
		var/turf/them = get_step(T, direction)

		for(var/obj/structure/foamedmetal/resin/S in them)
			if(S.loc == living.loc) //No removing speed if has same loc
				return

		living.remove_movespeed_modifier(MOVESPEED_ID_RESIN_FOAM)

/obj/structure/foamedmetal/resin/Destroy() //Make sure to remove the speed if the resin is destroyed while the mob is in it
	var/turf/T = get_turf(src)
	for(var/mob/living/living in T)
		living.remove_movespeed_modifier(MOVESPEED_ID_RESIN_FOAM)
	
	return ..()
