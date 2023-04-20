/**
  * Determines what happens to an atom when a swarmer interacts with it
  *
  * Determines behavior upon being interacted on by a swarmer.
  * Arguments:
  * * S - A reference to the swarmer doing the interaction
  */
/atom/proc/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	return TRUE //return TRUE/FALSE whether or not an AI swarmer should try this swarmer_act() again, NOT whether it succeeded.

/obj/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(resistance_flags & INDESTRUCTIBLE)
		return FALSE
	for(var/mob/living/living_content in contents)
		if(!issilicon(living_content) && !isbrain(living_content))
			to_chat(S, span_warning("An organism has been detected inside this object. Aborting."))
			return FALSE
	return ..()

/obj/item/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	return S.Integrate(src)

/**
  * Return used to determine how many resources a swarmer gains when consuming an object
  */
/obj/proc/integrate_amount()
	return 0

/obj/item/integrate_amount() //returns the amount of resources gained when eating this item
	var/list/mats = get_material_composition(ALL) // Ensures that items made from plasteel, and plas/titanium/plastitaniumglass get integrated correctly.
	mats += materials
	if(length(mats) && (mats[getmaterialref(/datum/material/iron)] || mats[getmaterialref(/datum/material/glass)]))
		return 1
	return ..()

/obj/item/gun/swarmer_act()//Stops you from eating the entire armory
	return FALSE

/turf/open/swarmer_act()//ex_act() on turf calls it on its contents, this is to prevent attacking mobs by DisIntegrate()'ing the floor
	return FALSE

/obj/structure/lattice/catwalk/swarmer_catwalk/swarmer_act()
	return FALSE

/obj/structure/swarmer/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	if(actor.AIStatus == AI_ON)
		return FALSE
	return ..()

/obj/effect/swarmer_act()
	return FALSE

/obj/effect/decal/cleanable/robot_debris/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	qdel(src)
	return TRUE

/obj/structure/swarmer_beacon/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("This machine is required for further reproduction of swarmers. Aborting."))
	return FALSE

/obj/structure/flora/swarmer_act()
	return FALSE

/turf/open/lava/swarmer_act()
	if(!is_safe())
		new /obj/structure/lattice/catwalk/swarmer_catwalk(src)
	return FALSE

/obj/machinery/atmospherics/swarmer_act()
	return FALSE

/obj/structure/disposalpipe/swarmer_act()
	return FALSE

/obj/machinery/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dismantle_machine(src)
	return TRUE

/obj/machinery/light/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.dis_integrate(src)
	return TRUE

/obj/machinery/door/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/isonshuttle = istype(get_area(src), /area/shuttle)
	for(var/turf/T in range(1, src))
		var/area/A = get_area(T)
		var/datum/gas_mixture/turf_air = T.return_air()
		if(turf_air.get_moles(/datum/gas/hydrogen) > 1 || turf_air.get_moles(/datum/gas/tritium) > 1 || turf_air.get_moles(/datum/gas/plasma) > 1 || (locate(/obj/effect/hotspot) in T) || turf_air.return_pressure() > 500 || turf_air.return_temperature() > 750 || !turf_air.total_moles() || isspaceturf(T) || (!isonshuttle && (istype(A, /area/shuttle) || istype(A, /area/space))) || (isonshuttle && !istype(A, /area/shuttle)))
			to_chat(S, span_warning("Destroying this object has the potential to cause a hull breach. Aborting."))
			S.target = null
			return FALSE
		else if(istype(A, /area/engine/supermatter))
			to_chat(S, span_warning("Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting."))
			S.target = null
			return FALSE
	S.dis_integrate(src)
	return TRUE

/obj/machinery/camera/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	actor.dis_integrate(src)
	if(!QDELETED(actor)) //If it got blown up no need to turn it off.
		toggle_cam(actor, FALSE)
	return TRUE

/obj/machinery/particle_accelerator/control_box/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.dis_integrate(src)
	return TRUE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.dis_integrate(src)
	return TRUE

/obj/machinery/gravity_generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.dis_integrate(src)
	return TRUE

/obj/machinery/vending/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)//It's more visually interesting than dismantling the machine
	S.dis_integrate(src)
	return TRUE

/obj/machinery/turretid/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.dis_integrate(src)
	return TRUE

/obj/machinery/chem_dispenser/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("The volatile chemicals in this machine would destroy us. Aborting."))
	return FALSE

/obj/machinery/nuclearbomb/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("This device's destruction would result in the extermination of everything in the area. Aborting."))
	return FALSE

/obj/effect/rune/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("Searching... sensor malfunction! Target lost. Aborting."))
	return FALSE

/obj/structure/destructible/cult/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("Err: unresolved object. Aborting."))
	return FALSE

/obj/structure/reagent_dispensers/fueltank/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("Destroying this object could cause a chain reaction. Aborting."))
	return FALSE

/obj/structure/cable/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("Disrupting the power grid would bring no benefit to us. Aborting."))
	return FALSE

/obj/machinery/portable_atmospherics/canister/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("An inhospitable area may be created as a result of destroying this object. Aborting."))
	return FALSE

/obj/machinery/telecomms/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("This communications relay should be preserved, it will be a useful resource to our masters in the future. Aborting."))
	return FALSE

/obj/machinery/deepfryer/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("This kitchen appliance should be preserved, it will make delicious unhealthy snacks for our masters in the future. Aborting."))
	return FALSE

/obj/machinery/power/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("Disrupting the power grid would bring no benefit to us. Aborting."))
	return FALSE

/obj/machinery/gateway/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, span_warning("This bluespace source will be important to us later. Aborting."))
	return FALSE

/turf/closed/wall/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/isonshuttle = istype(loc, /area/shuttle)
	for(var/turf/T in range(1, src))
		var/area/A = get_area(T)
		var/datum/gas_mixture/turf_air = T.return_air()
		if(turf_air.get_moles(/datum/gas/hydrogen) > 1 || turf_air.get_moles(/datum/gas/tritium) > 1 || turf_air.get_moles(/datum/gas/plasma) > 1 || (locate(/obj/effect/hotspot) in T) || turf_air.return_pressure() > 500 || turf_air.return_temperature() > 750 || !turf_air.total_moles() || isspaceturf(T) || (!isonshuttle && (istype(A, /area/shuttle) || istype(A, /area/space))) || (isonshuttle && !istype(A, /area/shuttle)))
			to_chat(S, span_warning("Destroying this object has the potential to cause a hull breach. Aborting."))
			S.target = null
			return TRUE
		else if(istype(A, /area/engine/supermatter))
			to_chat(S, span_warning("Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting."))
			S.target = null
			return TRUE
	return ..()

/obj/structure/window/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/is_on_shuttle = istype(get_area(src), /area/shuttle)
	for(var/turf/adj_turf in range(1, src))
		var/area/adj_area = get_area(adj_turf)
		var/datum/gas_mixture/turf_air = adj_turf.return_air()
		if(turf_air.get_moles(/datum/gas/hydrogen) > 1 || turf_air.get_moles(/datum/gas/tritium) > 1 || turf_air.get_moles(/datum/gas/plasma) > 1 || (locate(/obj/effect/hotspot) in adj_turf) || turf_air.return_pressure() > 500 || turf_air.return_temperature() > 750 || !turf_air.total_moles() || isspaceturf(adj_turf) || (!is_on_shuttle && (istype(adj_area, /area/shuttle) || istype(adj_area, /area/space))) || (is_on_shuttle && !istype(adj_area, /area/shuttle)))
			to_chat(actor, span_warning("Destroying this object has the potential to cause a hull breach. Aborting."))
			actor.target = null
			return TRUE
		if(istype(adj_area, /area/engine/supermatter))
			to_chat(actor, span_warning("Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting."))
			actor.target = null
			return TRUE
	return ..()

/obj/item/stack/cable_coil/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)//Wiring would be too effective as a resource
	to_chat(actor, span_warning("This object does not contain enough materials to work with."))
	return FALSE

/obj/machinery/porta_turret/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Attempting to dismantle this machine would result in an immediate counterattack. Aborting."))
	return FALSE

/obj/machinery/porta_turret_cover/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Attempting to dismantle this machine would result in an immediate counterattack. Aborting."))
	return FALSE

/obj/structure/lattice/catwalk/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	var/turf/here = get_turf(src)
	for(var/a in here.contents)
		if(istype(a, /obj/structure/cable))
			to_chat(actor, span_warning("Disrupting the power grid would bring no benefit to us. Aborting."))
			return FALSE
	return ..()

/obj/machinery/hydroponics/soil/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("This object does not contain enough materials to work with."))
	return FALSE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Destroying this object would cause a catastrophic chain reaction. Aborting."))
	return FALSE

/obj/machinery/field/containment/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("This object does not contain solid matter. Aborting."))
	return FALSE

/obj/machinery/power/shieldwallgen/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("Destroying this object would have an unpredictable effect on structure integrity. Aborting."))
	return FALSE

/obj/machinery/shieldwall/swarmer_act(mob/living/simple_animal/hostile/swarmer/actor)
	to_chat(actor, span_warning("This object does not contain solid matter. Aborting."))
	return FALSE
