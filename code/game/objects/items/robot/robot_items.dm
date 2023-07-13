/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
/obj/item/borg
	icon = 'icons/mob/robot_items.dmi'


/obj/item/borg/stun
	name = "electrically-charged arm"
	icon_state = "elecarm"
	var/charge_cost = 750
	var/stunforce = 100
	var/stamina_damage = 90

/obj/item/borg/stun/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.check_shields(src, 0, "[M]'s [name]", MELEE_ATTACK))
			playsound(M, 'sound/weapons/genhit.ogg', 50, 1)
			return FALSE
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell.use(charge_cost))
			return

	user.do_attack_animation(M)

	var/obj/item/bodypart/affecting = M.get_bodypart(user.zone_selected)
	var/armor_block = M.run_armor_check(affecting, ENERGY)
	M.apply_damage(stamina_damage, STAMINA, user.zone_selected, armor_block)
	SEND_SIGNAL(M, COMSIG_LIVING_MINOR_SHOCK)
	var/current_stamina_damage = M.getStaminaLoss()

	if(current_stamina_damage >= 90)
		if(!M.IsParalyzed())
			to_chat(M, span_warning("You muscles seize, making you collapse!"))
		else
			M.Paralyze(stunforce)
		M.adjust_jitter(20 SECONDS)
		M.adjust_confusion_up_to(8 SECONDS, 40 SECONDS)
		M.apply_effect(EFFECT_STUTTER, stunforce)
	else if(current_stamina_damage > 70)
		M.adjust_jitter(10 SECONDS)
		M.adjust_confusion_up_to(8 SECONDS, 40 SECONDS)
		M.apply_effect(EFFECT_STUTTER, stunforce)
	else if(current_stamina_damage >= 20)
		M.adjust_jitter(5 SECONDS)
		M.apply_effect(EFFECT_STUTTER, stunforce)

	M.visible_message(span_danger("[user] has prodded [M] with [src]!"), \
					span_userdanger("[user] has prodded you with [src]!"))

	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)

	log_combat(user, M, "stunned", src, "(INTENT: [uppertext(user.a_intent)])")

/obj/item/borg/cyborghug
	name = "hugging module"
	icon_state = "hugmodule"
	desc = "For when a someone really needs a hug."
	var/mode = 0 //0 = Hugs 1 = "Hug" 2 = Shock 3 = CRUSH
	var/ccooldown = 0
	var/scooldown = 0
	var/shockallowed = FALSE//Can it be a stunarm when emagged. Only PK borgs get this by default.
	var/boop = FALSE

/obj/item/borg/cyborghug/attack_self(mob/living/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/P = user
		if(P.emagged&&shockallowed == 1)
			if(mode < 3)
				mode++
			else
				mode = 0
		else if(mode < 1)
			mode++
		else
			mode = 0
	switch(mode)
		if(0)
			to_chat(user, "Power reset. Hugs!")
		if(1)
			to_chat(user, "Power increased!")
		if(2)
			to_chat(user, "BZZT. Electrifying arms...")
		if(3)
			to_chat(user, "ERROR: ARM ACTUATORS OVERLOADED.")

/obj/item/borg/cyborghug/attack(mob/living/M, mob/living/silicon/robot/user)
	if(M == user)
		return
	switch(mode)
		if(0)
			if(M.health >= 0)
				if(user.zone_selected == BODY_ZONE_HEAD)
					user.visible_message(span_notice("[user] playfully boops [M] on the head!"), \
									span_notice("You playfully boop [M] on the head!"))
					user.do_attack_animation(M, ATTACK_EFFECT_BOOP)
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1, -1)
				else if(ishuman(M))
					if(!(M.mobility_flags & MOBILITY_STAND))
						user.visible_message(span_notice("[user] shakes [M] trying to get [M.p_them()] up!"), \
										span_notice("You shake [M] trying to get [M.p_them()] up!"))
					else
						user.visible_message(span_notice("[user] hugs [M] to make [M.p_them()] feel better!"), \
								span_notice("You hug [M] to make [M.p_them()] feel better!"))
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message(span_notice("[user] pets [M]!"), \
							span_notice("You pet [M]!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(1)
			if(M.health >= 0)
				if(ishuman(M))
					M.adjust_status_effects_on_shake_up()
					if(!(M.mobility_flags & MOBILITY_STAND))
						user.visible_message(span_notice("[user] shakes [M] trying to get [M.p_them()] up!"), \
										span_notice("You shake [M] trying to get [M.p_them()] up!"))
					else if(user.zone_selected == BODY_ZONE_HEAD)
						user.visible_message(span_warning("[user] bops [M] on the head!"), \
										span_warning("You bop [M] on the head!"))
						user.do_attack_animation(M, ATTACK_EFFECT_PUNCH)
					else
						user.visible_message(span_warning("[user] hugs [M] in a firm bear-hug! [M] looks uncomfortable..."), \
								span_warning("You hug [M] firmly to make [M.p_them()] feel better! [M] looks uncomfortable..."))
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message(span_warning("[user] bops [M] on the head!"), \
							span_warning("You bop [M] on the head!"))
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1, -1)
		if(2)
			if(scooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M)||ismonkey(M))
						M.electrocute_act(5, "[user]", safety = 1, tesla_shock = 1)
						user.visible_message(span_userdanger("[user] electrocutes [M] with [user.p_their()] touch!"), \
							span_danger("You electrocute [M] with your touch!"))
						M.update_mobility()
					else
						if(!iscyborg(M))
							M.adjustFireLoss(10)
							user.visible_message(span_userdanger("[user] shocks [M]!"), \
								span_danger("You shock [M]!"))
						else
							user.visible_message(span_userdanger("[user] shocks [M]. It does not seem to have an effect"), \
								span_danger("You shock [M] to no effect."))
					playsound(loc, 'sound/effects/sparks2.ogg', 50, 1, -1)
					user.cell.charge -= 500
					scooldown = world.time + 20
		if(3)
			if(ccooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M))
						user.visible_message(span_userdanger("[user] crushes [M] in [user.p_their()] grip!"), \
							span_danger("You crush [M] in your grip!"))
					else
						user.visible_message(span_userdanger("[user] crushes [M]!"), \
								span_danger("You crush [M]!"))
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1, -1)
					M.adjustBruteLoss(15)
					user.cell.charge -= 300
					ccooldown = world.time + 10

/obj/item/borg/cyborghug/peacekeeper
	shockallowed = TRUE

/obj/item/borg/cyborghug/medical
	boop = TRUE

/obj/item/borg/charger
	name = "power connector"
	icon_state = "charger_draw"
	item_flags = NOBLUDGEON
	var/mode = "draw"
	var/static/list/charge_machines = typecacheof(list(/obj/machinery/cell_charger, /obj/machinery/recharger, /obj/machinery/recharge_station, /obj/machinery/mech_bay_recharge_port))
	var/static/list/charge_items = typecacheof(list(/obj/item/stock_parts/cell, /obj/item/gun/energy))

/obj/item/borg/charger/Initialize(mapload)
	. = ..()

/obj/item/borg/charger/update_icon()
	..()
	icon_state = "charger_[mode]"

/obj/item/borg/charger/attack_self(mob/user)
	if(mode == "draw")
		mode = "charge"
	else
		mode = "draw"
	to_chat(user, span_notice("You toggle [src] to \"[mode]\" mode."))
	update_icon()

/obj/item/borg/charger/afterattack(obj/item/target, mob/living/silicon/robot/user, proximity_flag)
	. = ..()
	if(!proximity_flag || !iscyborg(user))
		return
	if(mode == "draw")
		if(is_type_in_list(target, charge_machines))
			var/obj/machinery/M = target
			if((M.stat & (NOPOWER|BROKEN)) || !M.anchored)
				to_chat(user, span_warning("[M] is unpowered!"))
				return

			to_chat(user, span_notice("You connect to [M]'s power line..."))
			while(do_after(user, 1.5 SECONDS, M, progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if((M.stat & (NOPOWER|BROKEN)) || !M.anchored)
					break

				if(!user.cell.give(150))
					break

				M.use_power(200)

			to_chat(user, span_notice("You stop charging yourself."))

		else if(is_type_in_list(target, charge_items))
			var/obj/item/stock_parts/cell/cell = target
			if(!istype(cell))
				cell = locate(/obj/item/stock_parts/cell) in target
			if(!cell)
				to_chat(user, span_warning("[target] has no power cell!"))
				return

			if(istype(target, /obj/item/gun/energy))
				var/obj/item/gun/energy/E = target
				if(!E.can_charge)
					to_chat(user, span_warning("[target] has no power port!"))
					return

			if(!cell.charge)
				to_chat(user, span_warning("[target] has no power!"))


			to_chat(user, span_notice("You connect to [target]'s power port..."))

			while(do_after(user, 1.5 SECONDS, target, progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if(!cell || !target)
					return

				if(cell != target && cell.loc != target)
					return

				var/draw = min(cell.charge, cell.chargerate*0.5, user.cell.maxcharge-user.cell.charge)
				if(!cell.use(draw))
					break
				if(!user.cell.give(draw))
					break
				target.update_icon()

			to_chat(user, span_notice("You stop charging yourself."))

	else if(is_type_in_list(target, charge_items))
		var/obj/item/stock_parts/cell/cell = target
		if(!istype(cell))
			cell = locate(/obj/item/stock_parts/cell) in target
		if(!cell)
			to_chat(user, span_warning("[target] has no power cell!"))
			return

		if(istype(target, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = target
			if(!E.can_charge)
				to_chat(user, span_warning("[target] has no power port!"))
				return

		if(cell.charge >= cell.maxcharge)
			to_chat(user, span_warning("[target] is already charged!"))

		to_chat(user, span_notice("You connect to [target]'s power port..."))

		while(do_after(user, 1.5 SECONDS, target, progress = FALSE))
			if(!user || !user.cell || mode != "charge")
				return

			if(!cell || !target)
				return

			if(cell != target && cell.loc != target)
				return

			var/draw = min(user.cell.charge, cell.chargerate*0.5, cell.maxcharge-cell.charge)
			if(!user.cell.use(draw))
				break
			if(!cell.give(draw))
				break
			target.update_icon()

		to_chat(user, span_notice("You stop charging [target]."))

/obj/item/harmalarm
	name = "\improper Sonic Harm Prevention Tool"
	desc = "Releases a harmless blast that confuses most organics. For when the harm is JUST TOO MUCH."
	icon = 'icons/obj/device.dmi'
	icon_state = "megaphone"
	var/cooldown = 0

/obj/item/harmalarm/emag_act(mob/user)
	obj_flags ^= EMAGGED
	if(obj_flags & EMAGGED)
		to_chat(user, "<font color='red'>You short out the safeties on [src]!</font>")
	else
		to_chat(user, "<font color='red'>You reset the safeties on [src]!</font>")

/obj/item/harmalarm/attack_self(mob/user)
	var/safety = !(obj_flags & EMAGGED)
	if(cooldown > world.time)
		to_chat(user, "<font color='red'>The device is still recharging!</font>")
		return

	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell || R.cell.charge < 1200)
			to_chat(user, "<font color='red'>You don't have enough charge to do this!</font>")
			return
		R.cell.charge -= 1000
		if(R.emagged)
			safety = FALSE

	if(safety == TRUE)
		user.visible_message("<font color='red' size='2'>[user] blares out a near-deafening siren from its speakers!</font>", \
			span_userdanger("Your siren blares around [iscyborg(user) ? "you" : "and confuses you"]!"), \
			span_danger("The siren pierces your hearing!"))
		for(var/mob/living/carbon/M in get_hearers_in_view(9, user))
			if(M.get_ear_protection() == FALSE)
				M.adjust_confusion(6 SECONDS)
		audible_message("<font color='red' size='7'>HUMAN HARM</font>")
		playsound(get_turf(src), 'sound/ai/default/harmalarm.ogg', 70, 3)
		cooldown = world.time + 200
		log_game("[key_name(user)] used a Cyborg Harm Alarm in [AREACOORD(user)]")
		if(iscyborg(user))
			var/mob/living/silicon/robot/R = user
			to_chat(R.connected_ai, "<br>[span_notice("NOTICE - Peacekeeping 'HARM ALARM' used by: [user]")]<br>")

		return

	if(safety == FALSE)
		user.audible_message("<font color='red' size='7'>BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZT</font>")
		for(var/mob/living/carbon/C in get_hearers_in_view(9, user))
			var/bang_effect = C.soundbang_act(2, 0, 0, 5)
			switch(bang_effect)
				if(1)
					C.adjust_confusion(5 SECONDS)
					C.adjust_stutter(10 SECONDS)
					C.adjust_jitter(10 SECONDS)
				if(2)
					C.Paralyze(4 SECONDS)
					C.adjust_confusion(10 SECONDS)
					C.adjust_stutter(15 SECONDS)
					C.adjust_jitter(25 SECONDS)
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		cooldown = world.time + 1 MINUTES
		log_game("[key_name(user)] used an emagged Cyborg Harm Alarm in [AREACOORD(user)]")

#define DISPENSE_LOLLIPOP_MODE 1
#define THROW_LOLLIPOP_MODE 2
#define THROW_GUMBALL_MODE 3
#define DISPENSE_ICECREAM_MODE 4

/obj/item/borg/lollipop
	name = "treat fabricator"
	desc = "Reward humans with various treats. Toggle in-module to switch between dispensing and high velocity ejection modes."
	icon_state = "lollipop"
	var/candy = 30
	var/candymax = 30
	var/charge_delay = 10
	var/charging = FALSE
	var/mode = DISPENSE_LOLLIPOP_MODE

	var/firedelay = 0
	var/hitspeed = 2
	var/hitdamage = 0
	var/emaggedhitdamage = 3

/obj/item/borg/lollipop/clown
	emaggedhitdamage = 0

/obj/item/borg/lollipop/equipped()
	. = ..()
	check_amount()

/obj/item/borg/lollipop/dropped()
	. = ..()
	check_amount()

/obj/item/borg/lollipop/proc/check_amount()	//Doesn't even use processing ticks.
	if(charging)
		return
	if(candy < candymax)
		addtimer(CALLBACK(src, PROC_REF(charge_lollipops)), charge_delay)
		charging = TRUE

/obj/item/borg/lollipop/proc/charge_lollipops()
	candy++
	charging = FALSE
	check_amount()

/obj/item/borg/lollipop/proc/dispense(atom/A, mob/user)
	if(candy <= 0)
		to_chat(user, span_warning("No treats left in storage!"))
		return FALSE
	var/turf/T = get_turf(A)
	if(!T || !istype(T) || !isopenturf(T))
		return FALSE
	if(isobj(A))
		var/obj/O = A
		if(O.density)
			return FALSE

	var/obj/item/reagent_containers/food/snacks/L
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			L = new /obj/item/reagent_containers/food/snacks/lollipop(T)
		if(DISPENSE_ICECREAM_MODE)
			L = new /obj/item/reagent_containers/food/snacks/icecream(T)
			var/obj/item/reagent_containers/food/snacks/icecream/I = L
			I.add_ice_cream("vanilla")
			I.desc = "Eat the ice cream."

	var/into_hands = FALSE
	if(ismob(A))
		var/mob/M = A
		into_hands = M.put_in_hands(L)

	candy--
	check_amount()

	if(into_hands)
		user.visible_message(span_notice("[user] dispenses a treat into the hands of [A]."), span_notice("You dispense a treat into the hands of [A]."), span_italics("You hear a click."))
	else
		user.visible_message(span_notice("[user] dispenses a treat."), span_notice("You dispense a treat."), span_italics("You hear a click."))

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	return TRUE

/obj/item/borg/lollipop/proc/shootL(atom/target, mob/living/user, params)
	if(candy <= 0)
		to_chat(user, span_warning("Not enough lollipops left!"))
		return FALSE
	candy--
	var/obj/item/ammo_casing/caseless/lollipop/A = new /obj/item/ammo_casing/caseless/lollipop(src)
	A.BB.damage = hitdamage
	if(hitdamage)
		A.BB.nodamage = FALSE
	A.BB.speed = 0.5
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	A.fire_casing(target, user, params, 0, 0, null, 0, src)
	user.visible_message(span_warning("[user] blasts a flying lollipop at [target]!"))
	check_amount()

/obj/item/borg/lollipop/proc/shootG(atom/target, mob/living/user, params)	//Most certainly a good idea.
	if(candy <= 0)
		to_chat(user, span_warning("Not enough gumballs left!"))
		return FALSE
	candy--
	var/obj/item/ammo_casing/caseless/gumball/A = new /obj/item/ammo_casing/caseless/gumball(src)
	A.BB.damage = hitdamage
	if(hitdamage)
		A.BB.nodamage = FALSE
	A.BB.speed = 0.5
	A.BB.color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	playsound(src.loc, 'sound/weapons/bulletflyby3.ogg', 50, 1)
	A.fire_casing(target, user, params, 0, 0, null, 0, src)
	user.visible_message(span_warning("[user] shoots a high-velocity gumball at [target]!"))
	check_amount()

/obj/item/borg/lollipop/afterattack(atom/target, mob/living/user, proximity, click_params)
	. = ..()
	check_amount()
	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		if(!R.cell.use(12))
			to_chat(user, span_warning("Not enough power."))
			return FALSE
		if(R.emagged)
			hitdamage = emaggedhitdamage
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE, DISPENSE_ICECREAM_MODE)
			if(!proximity)
				return FALSE
			dispense(target, user)
		if(THROW_LOLLIPOP_MODE)
			shootL(target, user, click_params)
		if(THROW_GUMBALL_MODE)
			shootG(target, user, click_params)
	hitdamage = initial(hitdamage)

/obj/item/borg/lollipop/attack_self(mob/living/user)
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			mode = THROW_LOLLIPOP_MODE
			to_chat(user, span_notice("Module is now throwing lollipops."))
		if(THROW_LOLLIPOP_MODE)
			mode = THROW_GUMBALL_MODE
			to_chat(user, span_notice("Module is now blasting gumballs."))
		if(THROW_GUMBALL_MODE)
			mode = DISPENSE_ICECREAM_MODE
			to_chat(user, span_notice("Module is now dispensing ice cream."))
		if(DISPENSE_ICECREAM_MODE)
			mode = DISPENSE_LOLLIPOP_MODE
			to_chat(user, span_notice("Module is now dispensing lollipops."))
	..()

#undef DISPENSE_LOLLIPOP_MODE
#undef THROW_LOLLIPOP_MODE
#undef THROW_GUMBALL_MODE
#undef DISPENSE_ICECREAM_MODE

/obj/item/ammo_casing/caseless/gumball
	name = "Gumball"
	desc = "Why are you seeing this?!"
	projectile_type = /obj/item/projectile/bullet/reusable/gumball
	click_cooldown_override = 2

/obj/item/projectile/bullet/reusable/gumball
	name = "gumball"
	desc = "Oh noes! A fast-moving gumball!"
	icon_state = "gumball"
	ammo_type = /obj/item/reagent_containers/food/snacks/gumball/cyborg
	nodamage = TRUE

/obj/item/projectile/bullet/reusable/gumball/Initialize(mapload)
	. = ..()
	ammo_type = new ammo_type(src)
	color = ammo_type.color

/obj/item/ammo_casing/caseless/lollipop	//NEEDS RANDOMIZED COLOR LOGIC.
	name = "Lollipop"
	desc = "Why are you seeing this?!"
	projectile_type = /obj/item/projectile/bullet/reusable/lollipop
	click_cooldown_override = 2

/obj/item/projectile/bullet/reusable/lollipop
	name = "lollipop"
	desc = "Oh noes! A fast-moving lollipop!"
	icon_state = "lollipop_1"
	ammo_type = /obj/item/reagent_containers/food/snacks/lollipop/cyborg
	var/color2 = rgb(0, 0, 0)
	nodamage = TRUE

/obj/item/projectile/bullet/reusable/lollipop/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/lollipop/S = new ammo_type(src)
	ammo_type = S
	color2 = S.headcolor
	var/mutable_appearance/head = mutable_appearance('icons/obj/projectiles.dmi', "lollipop_2")
	head.color = color2
	add_overlay(head)

#define PKBORG_DAMPEN_CYCLE_DELAY 20

//Peacekeeper Cyborg Projectile Dampenening Field
/obj/item/borg/projectile_dampen
	name = "\improper Hyperkinetic Dampening projector"
	desc = "A device that projects a dampening field that weakens kinetic energy above a certain threshold. <span class='boldnotice'>Projects a field that drains power per second while active, that will weaken and slow damaging projectiles inside its field.</span> Still being a prototype, it tends to induce a charge on ungrounded metallic surfaces."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield"
	var/maxenergy = 1500
	var/energy = 1500
	var/energy_recharge = 37.5
	var/energy_recharge_cyborg_drain_coefficient = 0.4
	var/cyborg_cell_critical_percentage = 0.05
	var/mob/living/silicon/robot/host = null
	var/datum/proximity_monitor/advanced/dampening_field
	var/projectile_damage_coefficient = 0.5
	var/projectile_damage_tick_ecost_coefficient = 10	//Lasers get half their damage chopped off, drains 50 power/tick. Note that fields are processed 5 times per second.
	var/projectile_speed_coefficient = 1.5		//Higher the coefficient slower the projectile.
	var/projectile_tick_speed_ecost = 75
	var/list/obj/item/projectile/tracked
	var/image/projectile_effect
	var/field_radius = 3
	var/active = FALSE
	var/cycle_delay = 0

/obj/item/borg/projectile_dampen/debug
	maxenergy = 50000
	energy = 50000
	energy_recharge = 5000

/obj/item/borg/projectile_dampen/Initialize(mapload)
	. = ..()
	projectile_effect = image('icons/effects/fields.dmi', "projectile_dampen_effect")
	tracked = list()
	icon_state = "shield0"
	START_PROCESSING(SSfastprocess, src)
	host = loc

/obj/item/borg/projectile_dampen/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/borg/projectile_dampen/attack_self(mob/user)
	if(cycle_delay > world.time)
		to_chat(user, span_boldwarning("[src] is still recycling its projectors!"))
		return
	cycle_delay = world.time + PKBORG_DAMPEN_CYCLE_DELAY
	if(!active)
		if(!user.has_buckled_mobs())
			activate_field()
		else
			to_chat(user, span_warning("[src]'s safety cutoff prevents you from activating it due to living beings being ontop of you!"))
	else
		deactivate_field()
	update_icon()
	to_chat(user, span_boldnotice("You [active? "activate":"deactivate"] [src]."))

/obj/item/borg/projectile_dampen/update_icon()
	icon_state = "[initial(icon_state)][active]"

/obj/item/borg/projectile_dampen/proc/activate_field()
	if(istype(dampening_field))
		QDEL_NULL(dampening_field)
	dampening_field = make_field(/datum/proximity_monitor/advanced/peaceborg_dampener, list("current_range" = field_radius, "host" = src, "projector" = src))
	var/mob/living/silicon/robot/owner = get_host()
	if(owner)
		owner.module.allow_riding = FALSE
	active = TRUE

/obj/item/borg/projectile_dampen/proc/deactivate_field()
	QDEL_NULL(dampening_field)
	visible_message(span_warning("\The [src] shuts off!"))
	for(var/P in tracked)
		restore_projectile(P)
	active = FALSE

	var/mob/living/silicon/robot/owner = get_host()
	if(owner)
		owner.module.allow_riding = TRUE

/obj/item/borg/projectile_dampen/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return null

/obj/item/borg/projectile_dampen/dropped()
	. = ..()
	host = loc

/obj/item/borg/projectile_dampen/equipped()
	. = ..()
	host = loc

/obj/item/borg/projectile_dampen/on_mob_death()
	deactivate_field()
	. = ..()

/obj/item/borg/projectile_dampen/process(delta_time)
	process_recharge(delta_time)
	process_usage(delta_time)
	update_location()

/obj/item/borg/projectile_dampen/proc/update_location()
	if(dampening_field)
		dampening_field.HandleMove()

/obj/item/borg/projectile_dampen/proc/process_usage(delta_time)
	var/usage = 0
	for(var/I in tracked)
		var/obj/item/projectile/P = I
		if(!P.stun && P.nodamage)	//No damage
			continue
		usage += projectile_tick_speed_ecost * delta_time
		usage += tracked[I] * projectile_damage_tick_ecost_coefficient * delta_time
	energy = clamp(energy - usage, 0, maxenergy)
	if(energy <= 0)
		deactivate_field()
		visible_message(span_warning("[src] blinks \"ENERGY DEPLETED\"."))

/obj/item/borg/projectile_dampen/proc/process_recharge(delta_time)
	if(!istype(host))
		if(iscyborg(host.loc))
			host = host.loc
		else
			energy = clamp(energy + (energy_recharge * delta_time), 0, maxenergy)
		return
	if(host.cell && (host.cell.charge >= (host.cell.maxcharge * cyborg_cell_critical_percentage)) && (energy < maxenergy))
		host.cell.use(energy_recharge * delta_time * energy_recharge_cyborg_drain_coefficient)
		energy += energy_recharge * delta_time

/obj/item/borg/projectile_dampen/proc/dampen_projectile(obj/item/projectile/P, track_projectile = TRUE)
	if(tracked[P])
		return
	if(track_projectile)
		tracked[P] = P.damage
	P.damage *= projectile_damage_coefficient
	P.speed *= projectile_speed_coefficient
	P.add_overlay(projectile_effect)

/obj/item/borg/projectile_dampen/proc/restore_projectile(obj/item/projectile/P)
	tracked -= P
	P.damage *= (1/projectile_damage_coefficient)
	P.speed *= (1/projectile_speed_coefficient)
	P.cut_overlay(projectile_effect)

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	var/sight_mode = null


/obj/item/borg/sight/xray
	name = "\proper X-ray vision"
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	sight_mode = BORGXRAY

/obj/item/borg/sight/xray/truesight_lens
	name = "truesight lens"
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "truesight_lens"

/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"

/obj/item/borg/sight/material
	name = "\proper material vision"
	sight_mode = BORGMATERIAL
	icon_state = "material"

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"

/obj/item/borg/sight/hud/med/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health(src)


/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"

/obj/item/borg/sight/hud/sec/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/security(src)

/**********************************************************************
						Grippers
***********************************************************************/
/obj/item/gripper
	name = "cyborg gripper"
	desc = "A simple grasping tool for interacting with various items."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"
	item_flags = NOBLUDGEON
	/// Whitelist of items types that can be held.
	var/list/can_hold = list()
	/// Blacklist of item subtypes that should not be held.
	var/list/cannot_hold = list()
	/// Item currently being held if any.
	var/obj/item/wrapped = null
	var/mutable_appearance/appearance_wrapped = null

/// Drops held item if possible.
/obj/item/gripper/proc/drop_held(silent = FALSE)
	if(wrapped)
		wrapped.forceMove(get_turf(wrapped))
		if(!silent)
			to_chat(usr, span_notice("You drop the [wrapped]."))
		wrapped = null
		update_icon()
		return TRUE
	return FALSE

/// Pick up item.
/obj/item/gripper/proc/take_item(obj/item/item, silent = FALSE)
	if(!silent)
		to_chat(usr, span_notice("You collect \the [item]."))
	item.loc = src
	wrapped = item
	update_icon()

/obj/item/gripper/pre_attack(atom/target, mob/living/silicon/robot/user, params)
	var/proximity = get_dist(user, target)
	if(proximity > 1)
		return
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break
	if(wrapped) //Already have an item.
		var/obj/item/item = wrapped
		drop_held(TRUE)
		//Temporary put wrapped into user so target's attackby() checks pass.
		item.loc = user
		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(item, user, params)
		if(!resolved && item && target)
			item.afterattack(target, user, proximity, params)
		//If wrapped was neither deleted nor put into target, put it back into the gripper.
		if(item && user && (item.loc == user))
			take_item(item, TRUE)
			return
		else
			item = null
		return
	else if(isitem(target))
		var/obj/item/I = target
		if(locate(target) in user.module.modules)//This prevents grabbing your own modules and grabbing similar items (if this is ever the case).
			to_chat(user, span_danger("Your gripper cannot grab something that you already have."))
			return
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				for(var/badpath in cannot_hold)
					if(istype(I,badpath) && user.emagged)
						grab = 0
						continue
		//Allowed to grab.
		if(grab)
			take_item(I)
			return
		to_chat(user, span_danger("Your gripper cannot hold \the [target]."))

/obj/item/gripper/attack_self(mob/user)
	if(wrapped)
		wrapped.attack_self(user)
		return
	. = ..()

/obj/item/gripper/AltClick(mob/user)
	if(wrapped)
		wrapped.AltClick(user)
		return
	. = ..()

/obj/item/gripper/CtrlClick(mob/user)
	if(wrapped)
		wrapped.CtrlClick(user)
		return
	. = ..()

/obj/item/gripper/CtrlShiftClick(mob/user)
	if(wrapped)
		wrapped.CtrlShiftClick(user)
		return
	. = ..()

/// Resets overlays and adds a overlay if there is a held item.
/obj/item/gripper/update_icon(updates)
	cut_overlays()
	if(wrapped)
		var/mutable_appearance/wrapped_appearance = mutable_appearance(wrapped.icon, wrapped.icon_state)
		// Shrinking it to 0.8 makes it a bit ugly, but this makes it obvious it is a held item.
		wrapped_appearance.transform = matrix(0.8,0,0,0,0.8,0)
		add_overlay(wrapped_appearance)

// Make it clear what we can do with it.
/obj/item/gripper/examine(mob/user)
	. = ..()
	if(wrapped)
		. += span_notice("It is holding [icon2html(wrapped, user)] [wrapped]." )
		. += span_notice("Attempting to drop the gripper will only drop [wrapped].")

// Drop the item if the gripper is unequipped.
/obj/item/gripper/cyborg_unequip(mob/user)
	. = ..()
	if(wrapped)
		drop_held()

/obj/item/gripper/engineering
	name = "engineering gripper"
	desc = "A simple grasping tool for interacting with a limited amount of engineering related items."
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/electronics,
		/obj/item/wallframe,
		/obj/item/stock_parts
	)
