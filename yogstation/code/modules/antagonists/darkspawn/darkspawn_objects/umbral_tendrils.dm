//Created by Pass.
/obj/item/umbral_tendrils
	name = "umbral tendrils"
	desc = "A mass of pulsing, chitonous tendrils with exposed violet flesh."
	force = 15
	icon = 'yogstation/icons/obj/darkspawn_items.dmi'
	icon_state = "umbral_tendrils"
	item_state = "umbral_tendrils"
	lefthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_lefthand.dmi'
	righthand_file = 'yogstation/icons/mob/inhands/antag/darkspawn_righthand.dmi'
	hitsound = 'yogstation/sound/magic/pass_attack.ogg'
	attack_verb = list("impaled", "tentacled", "torn")
	item_flags = ABSTRACT | DROPDEL
	var/datum/antagonist/darkspawn/darkspawn
	var/obj/item/umbral_tendrils/twin

/obj/item/umbral_tendrils/Initialize(mapload, new_darkspawn)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	darkspawn = new_darkspawn
	for(var/obj/item/umbral_tendrils/U in loc)
		if(U != src)
			twin = U
			U.twin = src
			force = 12
			U.force = 12

/obj/item/umbral_tendrils/Destroy()
	if(!QDELETED(twin))
		qdel(twin)
	. = ..()

/obj/item/umbral_tendrils/examine(mob/user)
	. = ..()
	if(isobserver(user) || isdarkspawn(user))
		to_chat(user, "<span class='velvet bold'>Functions:<span>")
		to_chat(user, span_velvet("<b>Help intent:</b> Click on an open tile within seven tiles to jump to it for 10 Psi."))
		to_chat(user, span_velvet("<b>Disarm intent:</b> Click on an airlock to force it open for 15 Psi (or 30 if it's bolted.)"))
		to_chat(user, span_velvet("<b>Harm intent:</b> Fire a projectile that travels up to five tiles, knocking down[twin ? " and pulling forwards" : ""] the first creature struck."))
		to_chat(user, span_velvet("The tendrils will break any lights hit in melee,"))
		to_chat(user, span_velvet("The tendrils will shatter light fixtures instantly, as opposed to in several attacks."))
		to_chat(user, span_velvet("Also functions to pry open depowered airlocks on any intent other than harm."))

/obj/item/umbral_tendrils/attack(mob/living/target, mob/living/user, twinned_attack = TRUE)
	set waitfor = FALSE
	..()
	sleep(0.1 SECONDS)
	if(twin && twinned_attack && user.Adjacent(target))
		twin.attack(target, user, FALSE)

/obj/item/umbral_tendrils/afterattack(atom/target, mob/living/user, proximity)
	if(!darkspawn)
		return
	if(proximity)
		if(istype(target, /obj/structure/glowshroom))
			visible_message(span_warning("[src] tears [target] to shreds!"))
			qdel(target)
		if(isliving(target))
			var/mob/living/L = target
			if(isethereal(target))
				target.emp_act(EMP_LIGHT)
			for(var/obj/item/O in target.GetAllContents())
				if(O.light_range && O.light_power)
					disintegrate(O)
				if(L.pulling && L.pulling.light_range && isitem(L.pulling))
					disintegrate(L.pulling)
		else if(isitem(target))
			var/obj/item/I = target
			if(I.light_range && I.light_power)
				disintegrate(I)
		// Double hit structures if duality
		else if(!QDELETED(target) && (isstructure(target) || ismachinery(target)) && twin && user.get_active_held_item() == src)
			target.attackby(twin, user)
	switch(user.a_intent) //Note that airlock interactions can be found in airlock.dm.
		if(INTENT_HELP)
			if(isopenturf(target))
				tendril_jump(user, target)
		if(INTENT_HARM)
			tendril_swing(user, target)

/obj/item/umbral_tendrils/proc/disintegrate(obj/item/O)
	if(istype(O, /obj/item/pda))
		var/obj/item/pda/PDA = O
		PDA.set_light_on(FALSE)
		PDA.update_icon()
		visible_message(span_danger("The light in [PDA] shorts out!"))
	else
		visible_message(span_danger("[O] is disintegrated by [src]!"))
		O.burn()
	playsound(src, 'sound/items/welder.ogg', 50, 1)

/obj/item/umbral_tendrils/proc/tendril_jump(mob/living/user, turf/open/target) //throws the user towards the target turf
	if(!darkspawn.has_psi(10))
		to_chat(user, span_warning("You need at least 10 Psi to jump!"))
		return
	if(!(target in view(7, user)))
		to_chat(user, span_warning("You can't access that area, or it's too far away!"))
		return
	to_chat(user, span_velvet("You pull yourself towards [target]."))
	playsound(user, 'sound/magic/tail_swing.ogg', 10, TRUE)
	user.throw_at(target, 5, 3)
	darkspawn.use_psi(10)

/obj/item/umbral_tendrils/proc/tendril_swing(mob/living/user, mob/living/target) //swing the tendrils to knock someone down
	if(isliving(target) && target.lying)
		to_chat(user, span_warning("[target] is already knocked down!"))
		return
	user.visible_message(span_warning("[user] draws back [src] and swings them towards [target]!"), \
	span_velvet("<b>opehhjaoo</b><br>You swing your tendrils towards [target]!"))
	playsound(user, 'sound/magic/tail_swing.ogg', 50, TRUE)
	var/obj/item/projectile/umbral_tendrils/T = new(get_turf(user))
	T.preparePixelProjectile(target, user)
	T.twinned = twin
	T.firer = user
	T.fire()
	qdel(src)

/obj/item/projectile/umbral_tendrils
	name = "umbral tendrils"
	icon_state = "cursehand0"
	hitsound = 'yogstation/sound/magic/pass_attack.ogg'
	layer = LARGE_MOB_LAYER
	damage = 0
	nodamage = TRUE
	knockdown = 40
	speed = 1
	range = 5
	var/twinned = FALSE
	var/beam

/obj/item/projectile/umbral_tendrils/fire(setAngle)
	beam = firer.Beam(src, icon_state = "curse0", time = INFINITY, maxdistance = INFINITY)
	..()

/obj/item/projectile/umbral_tendrils/Destroy()
	qdel(beam)
	. = ..()

/obj/item/projectile/umbral_tendrils/on_hit(atom/movable/target, blocked = FALSE)
	if(blocked >= 100)
		return
	. = TRUE
	if(isliving(target))
		var/mob/living/L = target
		if(!iscyborg(target))
			playsound(target, 'yogstation/sound/magic/pass_attack.ogg', 50, TRUE)
			if(!twinned)
				target.visible_message(span_warning("[firer]'s [name] slam into [target], knocking them off their feet!"), \
				span_userdanger("You're knocked off your feet!"))
				L.Knockdown(6 SECONDS)
			else
				L.Immobilize(0.15 SECONDS) // so they cant cancel the throw by moving
				target.throw_at(get_step_towards(firer, target), 7, 2) //pull them towards us!
				target.visible_message(span_warning("[firer]'s [name] slam into [target] and drag them across the ground!"), \
				span_userdanger("You're suddenly dragged across the floor!"))
				L.Knockdown(8 SECONDS) //these can't hit people who are already on the ground but they can be spammed to all shit
				addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, target, 'yogstation/sound/magic/pass_attack.ogg', 50, TRUE), 1)
		else
			var/mob/living/silicon/robot/R = target
			R.toggle_headlamp(TRUE) //disable headlamps
			target.visible_message(span_warning("[firer]'s [name] smashes into [target]'s chassis!"), \
			span_userdanger("Heavy percussive impact detected. Recalibrating motor input."))
			R.playsound_local(target, 'sound/misc/interference.ogg', 25, FALSE)
			playsound(R, 'sound/effects/bang.ogg', 50, TRUE)
			R.Paralyze(40) //this is the only real anti-borg spell  get
			R.adjustBruteLoss(10)

