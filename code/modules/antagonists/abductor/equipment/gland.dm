/obj/item/organ/heart/gland
	name = "fleshy mass"
	desc = "A nausea-inducing hunk of twisting flesh and metal."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "gland"
	status = ORGAN_ROBOTIC
	beating = TRUE
	var/true_name = "baseline placebo referencer"
	var/cooldown_low = 30 SECONDS
	var/cooldown_high = 30 SECONDS
	var/next_activation = 0
	var/uses = -1 // -1 For infinite
	var/human_only = FALSE
	var/active = FALSE

	var/mind_control_uses = 1
	var/mind_control_duration = 180 SECONDS
	var/active_mind_control = FALSE

/obj/item/organ/heart/gland/Initialize()
	. = ..()
	icon_state = pick(list("health", "spider", "slime", "emp", "species", "egg", "vent", "mindshock", "viral"))

/obj/item/organ/heart/gland/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ABDUCTOR_SCIENTIST_TRAINING) || isobserver(user))
		. += span_notice("It is \a [true_name].")

/obj/item/organ/heart/gland/proc/ownerCheck()
	if(ishuman(owner))
		return TRUE
	if(!human_only && iscarbon(owner))
		return TRUE
	return FALSE

/obj/item/organ/heart/gland/proc/Start()
	active = 1
	next_activation = world.time + rand(cooldown_low,cooldown_high)

/obj/item/organ/heart/gland/proc/update_gland_hud()
	if(!owner)
		return
	var/image/holder = owner.hud_list[GLAND_HUD]
	var/icon/I = icon(owner.icon, owner.icon_state, owner.dir)
	holder.pixel_y = I.Height() - world.icon_size
	if(active_mind_control)
		holder.icon_state = "hudgland_active"
	else if(mind_control_uses)
		holder.icon_state = "hudgland_ready"
	else
		holder.icon_state = "hudgland_spent"

/obj/item/organ/heart/gland/update_icon()
	return // stop it from switching to the non existent heart_on sprite
	
/obj/item/organ/heart/gland/proc/mind_control(command, mob/living/user)
	if(!ownerCheck() || !mind_control_uses || active_mind_control)
		return FALSE
	mind_control_uses--
	to_chat(owner, span_userdanger("You suddenly feel an irresistible compulsion to follow an order..."))
	to_chat(owner, "[span_mind_control("[command]")]")
	active_mind_control = TRUE
	message_admins("[key_name(user)] sent an abductor mind control message to [key_name(owner)]: [command]")
	update_gland_hud()
	var/atom/movable/screen/alert/mind_control/mind_alert = owner.throw_alert("mind_control", /atom/movable/screen/alert/mind_control)
	mind_alert.command = command
	addtimer(CALLBACK(src, .proc/clear_mind_control), mind_control_duration)
	return TRUE

/obj/item/organ/heart/gland/proc/clear_mind_control()
	if(!ownerCheck() || !active_mind_control)
		return FALSE
	to_chat(owner, span_userdanger("You feel the compulsion fade, and you <i>completely forget</i> about your previous orders."))
	owner.clear_alert("mind_control")
	active_mind_control = FALSE
	return TRUE

/obj/item/organ/heart/gland/Remove(mob/living/carbon/M, special = 0)
	active = 0
	if(initial(uses) == 1)
		uses = initial(uses)
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.remove_from_hud(owner)
	clear_mind_control()
	..()

/obj/item/organ/heart/gland/Insert(mob/living/carbon/M, special = 0)
	..()
	if(special != 2 && uses) // Special 2 means abductor surgery
		Start()
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.add_to_hud(owner)
	update_gland_hud()

/obj/item/organ/heart/gland/on_life()
	if(!beating)
		// alien glands are immune to stopping.
		beating = TRUE
	if(!active)
		return
	if(!ownerCheck())
		active = 0
		return
	if(next_activation <= world.time)
		activate()
		uses--
		next_activation  = world.time + rand(cooldown_low,cooldown_high)
	if(!uses)
		active = 0

/obj/item/organ/heart/gland/proc/activate()
	return

/obj/item/organ/heart/gland/heals
	true_name = "coherency harmonizer"
	cooldown_low = 20 SECONDS
	cooldown_high = 40 SECONDS
	icon_state = "health"
	mind_control_uses = 3
	mind_control_duration = 5 MINUTES

/obj/item/organ/heart/gland/heals/activate()
	to_chat(owner, span_notice("You feel curiously revitalized."))
	owner.adjustToxLoss(-20, FALSE, TRUE)
	owner.heal_bodypart_damage(20, 20, 0, TRUE)
	owner.adjustOxyLoss(-20)

/obj/item/organ/heart/gland/slime
	true_name = "gastric animation galvanizer"
	cooldown_low = 1 MINUTES
	cooldown_high = 2 MINUTES
	icon_state = "slime"
	mind_control_uses = 1
	mind_control_duration = 4 MINUTES

/obj/item/organ/heart/gland/slime/Insert(mob/living/carbon/M, special = 0)
	..()
	owner.faction |= "slime"
	owner.grant_language(/datum/language/slime)

/obj/item/organ/heart/gland/slime/Remove(mob/living/carbon/M, special)
	. = ..()
	owner.faction -= "slime"
	owner.remove_language(/datum/language/slime)

/obj/item/organ/heart/gland/slime/activate()
	to_chat(owner, span_warning("You feel nauseated!"))
	owner.vomit(20)

	var/mob/living/simple_animal/slime/Slime = new(get_turf(owner), "grey")
	Slime.set_friends(list(owner))
	Slime.set_leader(owner)

/obj/item/organ/heart/gland/mindshock
	true_name = "neural crosstalk uninhibitor"
	cooldown_low = 40 SECONDS
	cooldown_high = 70 SECONDS
	icon_state = "mindshock"
	mind_control_uses = 1
	mind_control_duration = 10 MINUTES
	var/list/mob/living/carbon/human/broadcasted_mobs = list()

/obj/item/organ/heart/gland/mindshock/activate()
	to_chat(owner, span_notice("You get a headache."))

	var/turf/T = get_turf(owner)
	for(var/mob/living/carbon/H in orange(4,T))
		if(H == owner)
			continue
		switch(pick(1,3))
			if(1)
				to_chat(H, span_userdanger("You hear a loud buzz in your head, silencing your thoughts!"))
				H.Stun(50)
			if(2)
				to_chat(H, span_warning("You hear an annoying buzz in your head."))
				H.confused += 15
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, 160)
			if(3)
				H.hallucination += 60

/obj/item/organ/heart/gland/mindshock/mind_control(command, mob/living/user)
	if(!ownerCheck() || !mind_control_uses || active_mind_control)
		return FALSE
	mind_control_uses--
	for(var/mob/M in oview(7, owner))
		if(!ishuman(M))
			continue
		var/mob/living/carbon/human/H = M
		if(H.stat)
			continue

		broadcasted_mobs += H
		to_chat(H, span_userdanger("You suddenly feel an irresistible compulsion to follow an order..."))
		to_chat(H, "[span_mind_control("[command]")]")

		message_admins("[key_name(user)] broadcasted an abductor mind control message from [key_name(owner)] to [key_name(H)]: [command]")

		var/atom/movable/screen/alert/mind_control/mind_alert = H.throw_alert("mind_control", /atom/movable/screen/alert/mind_control)
		mind_alert.command = command

	if(LAZYLEN(broadcasted_mobs))
		active_mind_control = TRUE
		addtimer(CALLBACK(src, .proc/clear_mind_control), mind_control_duration)

	update_gland_hud()
	return TRUE

/obj/item/organ/heart/gland/mindshock/clear_mind_control()
	if(!active_mind_control || !LAZYLEN(broadcasted_mobs))
		return FALSE
	for(var/M in broadcasted_mobs)
		var/mob/living/carbon/human/H = M
		to_chat(H, span_userdanger("You feel the compulsion fade, and you <i>completely forget</i> about your previous orders."))
		H.clear_alert("mind_control")
	active_mind_control = FALSE
	return TRUE

/obj/item/organ/heart/gland/access
	true_name = "anagraphic electro-scrambler"
	cooldown_low = 1 MINUTES
	cooldown_high = 2 MINUTES
	uses = 1
	icon_state = "mindshock"
	mind_control_uses = 3
	mind_control_duration = 90 SECONDS

/obj/item/organ/heart/gland/access/activate()
	to_chat(owner, span_notice("You feel like a VIP for some reason."))
	RegisterSignal(owner, COMSIG_MOB_ALLOWED, .proc/free_access)

/obj/item/organ/heart/gland/access/proc/free_access(datum/source, obj/O)
	return TRUE

/obj/item/organ/heart/gland/access/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_MOB_ALLOWED)
	..()

/obj/item/organ/heart/gland/pop
	true_name = "anthropomorphic transmorphosizer"
	cooldown_low = 90 SECONDS
	cooldown_high = 3 MINUTES
	human_only = TRUE
	icon_state = "species"
	mind_control_uses = 7
	mind_control_duration = 30 SECONDS

/obj/item/organ/heart/gland/pop/activate()
	to_chat(owner, span_notice("You feel unlike yourself."))
	randomize_human(owner)
	var/species = pick(list(/datum/species/human, /datum/species/lizard, /datum/species/gorilla, /datum/species/moth, /datum/species/fly)) // yogs -- gorilla people
	owner.set_species(species)

/obj/item/organ/heart/gland/ventcrawling
	true_name = "pliant cartilage enabler"
	cooldown_low = 3 MINUTES
	cooldown_high = 4 MINUTES
	uses = 1
	icon_state = "vent"
	mind_control_uses = 4
	mind_control_duration = 3 MINUTES
	var/previous_ventcrawling

/obj/item/organ/heart/gland/ventcrawling/activate()
	to_chat(owner, span_notice("You feel very stretchy."))
	previous_ventcrawling = owner.ventcrawler
	owner.ventcrawler = VENTCRAWLER_ALWAYS

/obj/item/organ/heart/gland/ventcrawling/Remove(mob/living/carbon/M, special)
	. = ..()
	owner.ventcrawler = previous_ventcrawling
	previous_ventcrawling = VENTCRAWLER_NONE

/obj/item/organ/heart/gland/viral
	true_name = "contamination incubator"
	cooldown_low = 3 MINUTES
	cooldown_high = 4 MINUTES
	uses = 1
	icon_state = "viral"
	mind_control_uses = 1
	mind_control_duration = 3 MINUTES

/obj/item/organ/heart/gland/viral/activate()
	to_chat(owner, span_warning("You feel sick."))
	var/datum/disease/advance/A = random_virus(pick(2,6),6)
	A.carrier = TRUE
	owner.ForceContractDisease(A, FALSE, TRUE)

/obj/item/organ/heart/gland/viral/proc/random_virus(max_symptoms, max_level)
	if(max_symptoms > VIRUS_SYMPTOM_LIMIT)
		max_symptoms = VIRUS_SYMPTOM_LIMIT
	var/datum/disease/advance/A = new /datum/disease/advance()
	var/list/datum/symptom/possible_symptoms = list()
	for(var/symptom in subtypesof(/datum/symptom))
		var/datum/symptom/S = symptom
		if(initial(S.level) > max_level)
			continue
		if(initial(S.level) <= 0) //unobtainable symptoms
			continue
		possible_symptoms += S
	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/symptom/S = new chosen_symptom
			A.symptoms += S
	A.Refresh() //just in case someone already made and named the same disease
	return A

/obj/item/organ/heart/gland/trauma
	true_name = "white matter randomiser"
	cooldown_low = 80 SECONDS
	cooldown_high = 2 MINUTES
	uses = 5
	icon_state = "emp"
	mind_control_uses = 3
	mind_control_duration = 3 MINUTES

/obj/item/organ/heart/gland/trauma/activate()
	to_chat(owner, span_warning("You feel a spike of pain in your head."))
	if(prob(33))
		owner.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
	else
		if(prob(20))
			owner.gain_trauma_type(BRAIN_TRAUMA_SEVERE, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
		else
			owner.gain_trauma_type(BRAIN_TRAUMA_MILD, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))

/obj/item/organ/heart/gland/quantum
	true_name = "quantic de-observation matrix"
	cooldown_low = 15 SECONDS
	cooldown_high = 15 SECONDS
	icon_state = "emp"
	mind_control_uses = 2
	mind_control_duration = 2 MINUTES
	var/mob/living/carbon/entangled_mob

/obj/item/organ/heart/gland/quantum/activate()
	if(entangled_mob)
		return
	for(var/mob/M in oview(owner, 7))
		if(!iscarbon(M))
			continue
		entangled_mob = M
		addtimer(CALLBACK(src, .proc/quantum_swap), rand(1 MINUTES, 4 MINUTES))
		return

/obj/item/organ/heart/gland/quantum/proc/quantum_swap()
	if(QDELETED(entangled_mob))
		entangled_mob = null
		return
	var/turf/T = get_turf(owner)
	do_teleport(owner, get_turf(entangled_mob),null,TRUE,channel = TELEPORT_CHANNEL_QUANTUM)
	do_teleport(entangled_mob, T,null,TRUE,channel = TELEPORT_CHANNEL_QUANTUM)
	to_chat(owner, span_warning("You suddenly find yourself somewhere else!"))
	to_chat(entangled_mob, span_warning("You suddenly find yourself somewhere else!"))
	if(!active_mind_control) //Do not reset entangled mob while mind control is active
		entangled_mob = null

/obj/item/organ/heart/gland/quantum/mind_control(command, mob/living/user)
	if(..())
		if(entangled_mob && ishuman(entangled_mob) && (entangled_mob.stat < DEAD))
			to_chat(entangled_mob, span_userdanger("You suddenly feel an irresistible compulsion to follow an order..."))
			to_chat(entangled_mob, "[span_mind_control("[command]")]")
			var/atom/movable/screen/alert/mind_control/mind_alert = entangled_mob.throw_alert("mind_control", /atom/movable/screen/alert/mind_control)
			mind_alert.command = command
			message_admins("[key_name(owner)] mirrored an abductor mind control message to [key_name(entangled_mob)]: [command]")
			update_gland_hud()

/obj/item/organ/heart/gland/quantum/clear_mind_control()
	if(active_mind_control)
		to_chat(entangled_mob, span_userdanger("You feel the compulsion fade, and you completely forget about your previous orders."))
		entangled_mob.clear_alert("mind_control")
	..()

/obj/item/organ/heart/gland/spiderman
	true_name = "araneae cloister accelerator"
	cooldown_low = 45 SECONDS
	cooldown_high = 90 SECONDS
	icon_state = "spider"
	mind_control_uses = 2
	mind_control_duration = 4 MINUTES

/obj/item/organ/heart/gland/spiderman/activate()
	to_chat(owner, span_warning("You feel something crawling in your skin."))
	owner.faction |= "spiders"
	var/obj/structure/spider/spiderling/S = new(owner.drop_location())
	S.directive = "Protect your nest inside [owner.real_name]."

/obj/item/organ/heart/gland/egg
	true_name = "roe/enzymatic synthesizer"
	cooldown_low = 30 SECONDS
	cooldown_high = 40 SECONDS
	icon_state = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	mind_control_uses = 2
	mind_control_duration = 3 MINUTES

/obj/item/organ/heart/gland/egg/activate()
	owner.visible_message(span_alertalien("[owner] [pick(EGG_LAYING_MESSAGES)]"))
	var/turf/T = owner.drop_location()
	new /obj/item/reagent_containers/food/snacks/egg/gland(T)


/obj/item/organ/heart/gland/blood
	true_name = "pseudonuclear hemo-destabilizer"
	cooldown_low = 2 MINUTES
	cooldown_high = 3 MINUTES
	icon_state = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	mind_control_uses = 3
	mind_control_duration = 3 MINUTES

/obj/item/organ/heart/gland/blood/activate()
	if(!ishuman(owner) || !owner.dna.species)
		return
	var/mob/living/carbon/human/H = owner
	var/datum/species/species = H.dna.species
	to_chat(H, span_warning("You feel your blood heat up for a moment."))
	species.exotic_blood = get_random_reagent_id()

/obj/item/organ/heart/gland/electric
	true_name = "electron accumulator/discharger"
	cooldown_low = 80 SECONDS
	cooldown_high = 2 MINUTES
	icon_state = "species"
	mind_control_uses = 2
	mind_control_duration = 90 SECONDS

/obj/item/organ/heart/gland/electric/Insert(mob/living/carbon/M, special = 0)
	..()
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, "abductor_gland")

/obj/item/organ/heart/gland/electric/Remove(mob/living/carbon/M, special = 0)
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, "abductor_gland")
	..()

/obj/item/organ/heart/gland/electric/activate()
	owner.visible_message(span_danger("[owner]'s skin starts emitting electric arcs!"),\
	span_warning("You feel electric energy building up inside you!"))
	playsound(get_turf(owner), "sparks", 100, 1, -1)
	addtimer(CALLBACK(src, .proc/zap), rand(30, 100))

/obj/item/organ/heart/gland/electric/proc/zap()
	tesla_zap(owner, 4, 8000, TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE | TESLA_MOB_STUN)
	playsound(get_turf(owner), 'sound/magic/lightningshock.ogg', 50, 1)

/obj/item/organ/heart/gland/chem
	true_name = "intrinsic pharma-provider"
	cooldown_low = 5 SECONDS
	cooldown_high = 5 SECONDS
	icon_state = "viral"
	mind_control_uses = 3
	mind_control_duration = 1200
	var/list/possible_reagents = list()

/obj/item/organ/heart/gland/chem/Initialize()
	. = ..()
	for(var/R in subtypesof(/datum/reagent/drug) + subtypesof(/datum/reagent/medicine) + typesof(/datum/reagent/toxin))
		possible_reagents += R

/obj/item/organ/heart/gland/chem/activate()
	var/chem_to_add = pick(possible_reagents)
	owner.reagents.add_reagent(chem_to_add, 2)
	owner.adjustToxLoss(-5, TRUE, TRUE)
	..()

/obj/item/organ/heart/gland/gas //Yogstation change: plasma -> gas
	true_name = "effluvium sanguine-synonym emitter"
	cooldown_low = 2 MINUTES
	cooldown_high = 3 MINUTES
	icon_state = "slime"
	mind_control_uses = 1
	mind_control_duration = 80 SECONDS

/obj/item/organ/heart/gland/gas/activate() //Yogstation change: plasma -> gas
	to_chat(owner, span_warning("You feel bloated."))
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, owner, span_userdanger("A massive stomachache overcomes you.")), 15 SECONDS)
	addtimer(CALLBACK(src, .proc/vomit_gas), 20 SECONDS) //Yogstation change: plasma -> gas

/obj/item/organ/heart/gland/gas/proc/vomit_gas() //Yogstation change: plasma -> gas
	if(!owner)
		return
	owner.visible_message(span_danger("[owner] vomits a cloud of miasma!")) //Yogstation change: plasma -> miasma
	var/turf/open/T = get_turf(owner)
	if(istype(T))
		T.atmos_spawn_air("miasma=50;TEMP=[T20C]") //Yogstation change: plasma -> miasma
	owner.vomit()
