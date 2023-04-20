/obj/mecha/proc/get_armour_facing(relative_dir)
	switch(abs(relative_dir))
		if(180) // BACKSTAB!
			return facing_modifiers[BACK_ARMOUR]
		if(0, 45)
			return facing_modifiers[FRONT_ARMOUR]
	return facing_modifiers[SIDE_ARMOUR] //always return non-0

/obj/mecha/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && obj_integrity > 0)
		spark_system.start()
		switch(damage_flag)
			if(FIRE)
				check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL))
			if(MELEE)
				check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
			else
				check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT))
		if(. >= 5 || prob(33))
			occupant_message(span_userdanger("Taking damage!"))
		log_message("Took [damage_amount] points of damage. Damage type: [damage_type]", LOG_MECHA)

/obj/mecha/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	. = ..()
	if(!damage_amount)
		return 0
	var/booster_deflection_modifier = 1
	var/booster_damage_modifier = 1
	if(damage_flag == BULLET || damage_flag == LASER || damage_flag == ENERGY)
		for(var/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/B in equipment)
			if(B.projectile_react())
				booster_deflection_modifier = B.deflect_coeff
				booster_damage_modifier = B.damage_coeff
				break
	else if(damage_flag == MELEE)
		for(var/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/B in equipment)
			if(B.attack_react())
				booster_deflection_modifier *= B.deflect_coeff
				booster_damage_modifier *= B.damage_coeff
				break

	if(attack_dir)
		var/facing_modifier = get_armour_facing(dir2angle(attack_dir) - dir2angle(dir))
		booster_damage_modifier /= facing_modifier
		booster_deflection_modifier *= facing_modifier
	if(prob(deflect_chance * booster_deflection_modifier))
		visible_message(span_danger("[src]'s armour deflects the attack!"))
		log_message("Armor saved.", LOG_MECHA)
		return 0
	if(.)
		. *= booster_damage_modifier


/obj/mecha/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE) // Ugh. Ideally we shouldn't be setting cooldowns outside of click code.
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	playsound(loc, 'sound/weapons/tap.ogg', 40, 1, -1)
	user.visible_message(span_danger("[user] hits [name]. Nothing happens."), null, null, COMBAT_MESSAGE_RANGE)
	log_message("Attack by hand/paw. Attacker - [user].", LOG_MECHA, color="red")

/obj/mecha/attack_paw(mob/user as mob)
	return attack_hand(user)


/obj/mecha/attack_alien(mob/living/user)
	log_message("Attack by alien. Attacker - [user].", LOG_MECHA, color="red")
	playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
	attack_generic(user, 15, BRUTE, MELEE, 0)

/obj/mecha/attack_animal(mob/living/simple_animal/user)
	log_message("Attack by simple animal. Attacker - [user].", LOG_MECHA, color="red")
	if(!user.melee_damage_upper && !user.obj_damage)
		user.emote("custom", message = "[user.friendly] [src].")
		return 0
	else
		var/play_soundeffect = 1
		if(user.environment_smash)
			play_soundeffect = 0
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
		var/animal_damage = rand(user.melee_damage_lower,user.melee_damage_upper)
		if(user.obj_damage)
			animal_damage = user.obj_damage
		animal_damage = min(animal_damage, 20*user.environment_smash)
		attack_generic(user, animal_damage, user.melee_damage_type, MELEE, play_soundeffect)
		log_combat(user, src, "attacked")
		return 1


/obj/mecha/hulk_damage()
	return 15

/obj/mecha/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(.)
		log_message("Attack by hulk. Attacker - [user].", LOG_MECHA, color="red")
		log_combat(user, src, "punched", "hulk powers")

/obj/mecha/blob_act(obj/structure/blob/B)
	take_damage(30, BRUTE, MELEE, 0, get_dir(src, B))

/obj/mecha/attack_tk()
	return

/obj/mecha/rust_heretic_act()
	take_damage(500,  BRUTE)

/obj/mecha/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum) //wrapper
	log_message("Hit by [AM].", LOG_MECHA, color="red")
	. = ..()


/obj/mecha/bullet_act(obj/item/projectile/Proj) //wrapper
	if ((!enclosed || istype(Proj, /obj/item/projectile/bullet/shotgun/slug/uranium))&& occupant && !silicon_pilot && !Proj.force_hit && (Proj.def_zone == BODY_ZONE_HEAD || Proj.def_zone == BODY_ZONE_CHEST)) //allows bullets to hit the pilot of open-canopy mechs
		occupant.bullet_act(Proj) //If the sides are open, the occupant can be hit
		return BULLET_ACT_HIT
	log_message("Hit by projectile. Type: [Proj.name]([Proj.flag]).", LOG_MECHA, color="red")
	. = ..()

/obj/mecha/ex_act(severity, target)
	log_message("Affected by explosion of severity: [severity].", LOG_MECHA, color="red")
	if(prob(deflect_chance))
		severity++
		log_message("Armor saved, changing severity to [severity]", LOG_MECHA)
	. = ..()

/obj/mecha/contents_explosion(severity, target)
	severity++
	for(var/X in equipment)
		var/obj/item/mecha_parts/mecha_equipment/ME = X
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += ME
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += ME
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += ME
	for(var/Y in trackers)
		var/obj/item/mecha_parts/mecha_tracking/MT = Y
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += MT
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += MT
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += MT
	if(occupant)
		occupant.ex_act(severity,target)

/obj/mecha/handle_atom_del(atom/A)
	if(A == occupant)
		occupant = null
		icon_state = initial(icon_state)+"-open"
		setDir(dir_in)

/obj/mecha/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(get_charge())
		use_power((cell.charge/3)/(severity*2))
		take_damage(40 / severity, BURN, ENERGY, 1)
	log_message("EMP detected", LOG_MECHA, color="red")

	if(istype(src, /obj/mecha/combat))
		mouse_pointer = 'icons/mecha/mecha_mouse-disable.dmi'
		occupant?.update_mouse_pointer()
	if(!equipment_disabled && occupant) //prevent spamming this message with back-to-back EMPs
		to_chat(occupant, "<span=danger>Error -- Connection to equipment control unit has been lost.</span>")
	overload_action.Activate(0)
	addtimer(CALLBACK(src, /obj/mecha/proc/restore_equipment), 3 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	equipment_disabled = 1

/obj/mecha/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>max_temperature)
		log_message("Exposed to dangerous temperature.", LOG_MECHA, color="red")
		take_damage(5, BURN, 0, 1)

/obj/mecha/attackby(obj/item/W as obj, mob/user as mob, params)

	if(istype(W, /obj/item/mmi))
		if(mmi_move_inside(W,user))
			to_chat(user, "[src]-[W] interface initialized successfully.")
		else
			to_chat(user, "[src]-[W] interface initialization failed.")
		return

	if(istype(W, /obj/item/mecha_ammo))
		ammo_resupply(W, user)
		return

	if(W.GetID())
		if(add_req_access || maint_access)
			if(internals_access_allowed(user))
				var/obj/item/card/id/id_card
				if(istype(W, /obj/item/card/id))
					id_card = W
				else
					var/obj/item/pda/pda = W
					id_card = pda.id
				output_maintenance_dialog(id_card, user)
				return
			else
				to_chat(user, span_warning("Invalid ID: Access denied."))
		else
			to_chat(user, span_warning("Maintenance protocols disabled by operator."))
	else if(W.tool_behaviour == TOOL_WRENCH)
		if(state==1)
			state = 2
			to_chat(user, span_notice("You undo the securing bolts."))
		else if(state==2)
			state = 1
			to_chat(user, span_notice("You tighten the securing bolts."))
		return
	else if(W.tool_behaviour == TOOL_CROWBAR)
		if(state==2)
			state = 3
			to_chat(user, span_notice("You open the hatch to the power unit."))
		else if(state==3)
			state=2
			to_chat(user, span_notice("You close the hatch to the power unit."))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		if(state == 3 && (internal_damage & MECHA_INT_SHORT_CIRCUIT))
			var/obj/item/stack/cable_coil/CC = W
			if(CC.use(2))
				clearInternalDamage(MECHA_INT_SHORT_CIRCUIT)
				to_chat(user, span_notice("You replace the fused wires."))
			else
				to_chat(user, span_warning("You need two lengths of cable to fix this mech!"))
		return

	else if(istype(W, /obj/item/stock_parts/cell))
		if(state==3)
			if(!cell)
				if(!user.transferItemToLoc(W, src, silent = FALSE))
					return
				var/obj/item/stock_parts/cell/C = W
				to_chat(user, span_notice("You install the power cell."))
				playsound(src, 'sound/items/screwdriver2.ogg', 50, FALSE)
				cell = C
				log_message("Powercell installed", LOG_MECHA)
			else
				to_chat(user, span_notice("There's already a power cell installed."))
		return

	if(istype(W, /obj/item/stock_parts/scanning_module))
		if(state == 3)
			if(!scanmod)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, span_notice("You install the scanning module."))
				playsound(src, 'sound/items/screwdriver2.ogg', 50, FALSE)
				scanmod = W
				log_message("[W] installed", LOG_MECHA)
				update_part_values()
			else
				to_chat(user, span_notice("There's already a scanning module installed."))
		return

	if(istype(W, /obj/item/stock_parts/capacitor))
		if(state == 3)
			if(!capacitor)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, span_notice("You install the capacitor."))
				playsound(src, 'sound/items/screwdriver2.ogg', 50, FALSE)
				capacitor = W
				log_message("[W] installed", LOG_MECHA)
				update_part_values()
			else
				to_chat(user, span_notice("There's already a capacitor installed."))
		return

	else if(W.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM)
		user.changeNext_move(CLICK_CD_MELEE)
		if(obj_integrity < max_integrity)
			if(W.use_tool(src, user, 0, volume=50, amount=1))
				if (internal_damage & MECHA_INT_TANK_BREACH)
					clearInternalDamage(MECHA_INT_TANK_BREACH)
					to_chat(user, span_notice("You repair the damaged gas tank."))
				else
					user.visible_message(span_notice("[user] repairs some damage to [name]."), span_notice("You repair some damage to [src]."))
					obj_integrity += min(10, max_integrity-obj_integrity)
					if(obj_integrity == max_integrity)
						to_chat(user, span_notice("It looks to be fully repaired now."))
			return 1
		else
			to_chat(user, span_warning("The [name] is at full integrity!"))
		return 1

	else if(istype(W, /obj/item/mecha_parts))
		var/obj/item/mecha_parts/P = W
		P.try_attach_part(user, src)
		return

	else if(istype(W, /obj/item/airlock_scanner))		//yogs start
		var/obj/item/airlock_scanner/S = W
		S.show_access(src, user)					//yogs end

	else
		return ..()

/obj/mecha/attacked_by(obj/item/I, mob/living/user)
	log_message("Attacked by [I]. Attacker - [user]", LOG_MECHA)
	..()

/obj/mecha/proc/mech_toxin_damage(mob/living/target)
	playsound(src, 'sound/effects/spray2.ogg', 50, 1)
	if(target.reagents)
		if(target.reagents.get_reagent_amount(/datum/reagent/cryptobiolin) + force < force*2)
			target.reagents.add_reagent(/datum/reagent/cryptobiolin, force/2)
		if(target.reagents.get_reagent_amount(/datum/reagent/toxin) + force < force*2)
			target.reagents.add_reagent(/datum/reagent/toxin, force/2.5)


/obj/mecha/mech_melee_attack(obj/mecha/M, equip_allowed)
	if(!has_charge(melee_energy_drain))
		return 0
	use_power(melee_energy_drain)
	if(M.damtype == BRUTE || M.damtype == BURN)
		log_combat(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")
		. = ..()

/obj/mecha/proc/full_repair(charge_cell)
	obj_integrity = max_integrity
	if(cell && charge_cell)
		cell.charge = cell.maxcharge
	if(internal_damage & MECHA_INT_FIRE)
		clearInternalDamage(MECHA_INT_FIRE)
	if(internal_damage & MECHA_INT_TEMP_CONTROL)
		clearInternalDamage(MECHA_INT_TEMP_CONTROL)
	if(internal_damage & MECHA_INT_SHORT_CIRCUIT)
		clearInternalDamage(MECHA_INT_SHORT_CIRCUIT)
	if(internal_damage & MECHA_INT_TANK_BREACH)
		clearInternalDamage(MECHA_INT_TANK_BREACH)
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		clearInternalDamage(MECHA_INT_CONTROL_LOST)

/obj/mecha/narsie_act()
	emp_act(EMP_HEAVY)

/obj/mecha/ratvar_act()
	if((GLOB.ratvar_awakens || GLOB.clockwork_gateway_activated) && occupant)
		if(is_servant_of_ratvar(occupant)) //reward the minion that got a mech by repairing it
			full_repair(TRUE)
		else
			var/mob/living/L = occupant
			go_out(TRUE)
			if(L)
				L.ratvar_act()

/obj/mecha/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect)
		if(selected)
			used_item = selected
		else if(!visual_effect_icon)
			visual_effect_icon = ATTACK_EFFECT_SMASH
			if(damtype == BURN)
				visual_effect_icon = ATTACK_EFFECT_MECHFIRE
			else if(damtype == TOX)
				visual_effect_icon = ATTACK_EFFECT_MECHTOXIN
	..()

/obj/mecha/obj_destruction()
	if(wreckage)
		var/mob/living/silicon/ai/AI
		if(isAI(occupant))
			AI = occupant
			occupant = null
		var/obj/structure/mecha_wreckage/WR = new wreckage(loc, AI)
		if(capacitor)
			WR.repair_efficiency = capacitor.rating // Capacitor is destroyed regardless of rating
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			if(E.salvageable && prob(20*WR.repair_efficiency))
				E.detach(WR) //detaches from src into WR
				E.equip_ready = 1
				WR.equipment += E
			else
				E.detach(loc)
				qdel(E)
		if(scanmod && WR.repair_efficiency > 2) // Scanning module is retained if capacitor is T3+
			WR.scanmod = scanmod
			scanmod.forceMove(WR)
			scanmod = null
		if(cell && WR.repair_efficiency > 3) // Cell is retained if capacitor is T4
			WR.cell = cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
			cell = null
		if(WR.repair_efficiency <= 0)
			WR.can_be_reconstructed = FALSE
		else
			WR.can_be_reconstructed = TRUE
			WR.hint = span_notice("The parts are scattered apart, but can be <b>welded</b> back together.")
	. = ..()
