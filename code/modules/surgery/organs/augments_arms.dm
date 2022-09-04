/obj/item/organ/cyberimp/arm
	name = "arm-mounted implant"
	desc = "You shouldn't see this! Adminhelp and report this as an issue on github!"
	zone = BODY_ZONE_R_ARM
	icon_state = "implant-toolkit"
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/organ_action/toggle)

	var/list/items_list = list()
	// Used to store a list of all items inside, for multi-item implants.
	// I would use contents, but they shuffle on every activation/deactivation leading to interface inconsistencies.

	var/obj/item/holder = null
	// You can use this var for item path, it would be converted into an item on New()

/obj/item/organ/cyberimp/arm/Initialize()
	. = ..()
	if(ispath(holder))
		holder = new holder(src)

	update_icon()
	SetSlotFromZone()
	items_list = contents.Copy()

/obj/item/organ/cyberimp/arm/proc/SetSlotFromZone()
	switch(zone)
		if(BODY_ZONE_L_ARM)
			slot = ORGAN_SLOT_LEFT_ARM_AUG
		if(BODY_ZONE_R_ARM)
			slot = ORGAN_SLOT_RIGHT_ARM_AUG
		else
			CRASH("Invalid zone for [type]")

/obj/item/organ/cyberimp/arm/update_icon()
	if(zone == BODY_ZONE_R_ARM)
		transform = null
	else // Mirroring the icon
		transform = matrix(-1, 0, 0, 0, 1, 0)

/obj/item/organ/cyberimp/arm/examine(mob/user)
	. = ..()
	. += span_info("[src] is assembled in the [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm configuration. You can use a screwdriver to reassemble it.")

/obj/item/organ/cyberimp/arm/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return TRUE
	I.play_tool_sound(src)
	if(zone == BODY_ZONE_R_ARM)
		zone = BODY_ZONE_L_ARM
	else
		zone = BODY_ZONE_R_ARM
	SetSlotFromZone()
	to_chat(user, span_notice("You modify [src] to be installed on the [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."))
	update_icon()

/obj/item/organ/cyberimp/arm/Remove(mob/living/carbon/M, special = 0)
	Retract()
	..()

/obj/item/organ/cyberimp/arm/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(15/severity) && owner)
		to_chat(owner, span_warning("[src] is hit by EMP!"))
		// give the owner an idea about why his implant is glitching
		Retract()

/obj/item/organ/cyberimp/arm/proc/Retract()
	if(!holder || (holder in src))
		return

	UnregisterSignal(holder, COMSIG_ITEM_PREDROPPED)

	owner.visible_message(span_notice("[owner] retracts [holder] back into [owner.p_their()] [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_notice("[holder] snaps back into your [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_italics("You hear a short mechanical noise."))

	if(istype(holder, /obj/item/assembly/flash/armimplant))
		var/obj/item/assembly/flash/F = holder
		F.set_light(0)

	owner.transferItemToLoc(holder, src, TRUE)
	holder = null
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/cyberimp/arm/proc/on_drop(datum/source, mob/user)
	Retract()

/obj/item/organ/cyberimp/arm/proc/Extend(var/obj/item/item)
	if(!(item in src))
		return

	holder = item
	RegisterSignal(holder, COMSIG_ITEM_PREDROPPED, .proc/on_drop)
	ADD_TRAIT(holder, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

	holder.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	holder.slot_flags = null
	holder.materials = null

	if(istype(holder, /obj/item/assembly/flash/armimplant))
		var/obj/item/assembly/flash/F = holder
		F.set_light(7)

	var/obj/item/arm_item = owner.get_active_held_item()

	if(arm_item)
		if(!owner.dropItemToGround(arm_item))
			to_chat(owner, span_warning("Your [arm_item] interferes with [src]!"))
			return
		else
			to_chat(owner, span_notice("You drop [arm_item] to activate [src]!"))

	var/result = (zone == BODY_ZONE_R_ARM ? owner.put_in_r_hand(holder) : owner.put_in_l_hand(holder))
	if(!result)
		to_chat(owner, span_warning("Your [name] fails to activate!"))
		return

	// Activate the hand that now holds our item.
	owner.swap_hand(result)//... or the 1st hand if the index gets lost somehow

	owner.visible_message(span_notice("[owner] extends [holder] from [owner.p_their()] [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_notice("You extend [holder] from your [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_italics("You hear a short mechanical noise."))
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/cyberimp/arm/ui_action_click()
	if((organ_flags & ORGAN_FAILING) || (!holder && !contents.len))
		to_chat(owner, span_warning("The implant doesn't respond. It seems to be broken..."))
		return

	if(!holder || (holder in src))
		holder = null
		if(contents.len == 1)
			Extend(contents[1])
		else
			var/list/choice_list = list()
			for(var/obj/item/I in items_list)
				choice_list[I] = image(I)
			var/obj/item/choice = show_radial_menu(owner, owner, choice_list)
			if(owner && owner == usr && owner.stat != DEAD && (src in owner.internal_organs) && !holder && (choice in contents))
				// This monster sanity check is a nice example of how bad input is.
				Extend(choice)
	else
		Retract()


/obj/item/organ/cyberimp/arm/gun/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(30/severity) && owner && (organ_flags & ORGAN_FAILING))
		Retract()
		owner.visible_message(span_danger("A loud bang comes from [owner]\'s [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm!"))
		playsound(get_turf(owner), 'sound/weapons/flashbang.ogg', 100, 1)
		to_chat(owner, span_userdanger("You feel an explosion erupt inside your [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm as your implant breaks!"))
		owner.adjust_fire_stacks(20)
		owner.IgniteMob()
		owner.adjustFireLoss(25)
		organ_flags |= ORGAN_FAILING


/obj/item/organ/cyberimp/arm/gun/laser
	name = "arm-mounted laser implant"
	desc = "A variant of the arm cannon implant that fires lethal laser beams. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_laser"
	contents = newlist(/obj/item/gun/energy/laser/mounted)

/obj/item/organ/cyberimp/arm/gun/laser/l
	zone = BODY_ZONE_L_ARM


/obj/item/organ/cyberimp/arm/gun/taser
	name = "arm-mounted taser implant"
	desc = "A variant of the arm cannon implant that fires electrodes and disabler shots. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_taser"
	contents = newlist(/obj/item/gun/energy/e_gun/advtaser/mounted)

/obj/item/organ/cyberimp/arm/gun/taser/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/toolset
	name = "integrated toolset implant"
	desc = "A stripped-down version of the engineering cyborg toolset, designed to be installed on subject's arm. Contains all necessary tools."
	contents = newlist(/obj/item/screwdriver/cyborg, /obj/item/wrench/cyborg, /obj/item/weldingtool/largetank/cyborg,
		/obj/item/crowbar/cyborg, /obj/item/wirecutters/cyborg, /obj/item/multitool/cyborg)
	///currently used pallate
	var/obj/item/toolset_handler/linkedhandler

/obj/item/organ/cyberimp/arm/toolset/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/toolset/Initialize()
	. = ..()
	linkedhandler = new
	linkedhandler.linkedarm = src
	ADD_TRAIT(linkedhandler, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/organ/cyberimp/arm/toolset/emag_act()
	if(!(locate(/obj/item/kitchen/knife/combat/cyborg) in items_list))
		to_chat(usr, span_notice("You unlock [src]'s integrated knife!"))
		items_list += new /obj/item/kitchen/knife/combat/cyborg(src)
		return TRUE
	return FALSE

/obj/item/organ/cyberimp/arm/toolset/Retract()
	if(!linkedhandler || !(linkedhandler in owner.contents))
		return

	owner.visible_message(span_notice("[owner] retracts [linkedhandler] back into [owner.p_their()] [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_notice("[linkedhandler] snaps back into your [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_italics("You hear a short mechanical noise."))

	if(istype(linkedhandler.active_tool, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = linkedhandler.active_tool
		if(W.welding)
			W.switched_on(owner)

	owner.transferItemToLoc(linkedhandler, src, TRUE)
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/cyberimp/arm/toolset/Extend(var/obj/item/item)
	if(!(item in src))
		return

	if(istype(item, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = item
		if(!W.welding)
			W.switched_on(owner) //for some godawful reason this proc handles BOTH switching on and off while switching off just hard disables a welder

	linkedhandler.active_tool = item
	spawn(1) //so you are probably asking hey why are you using spawn(1) here and that's a good question the answer is the welder APPARENTLY doesn't update its icon immediately, meaning if we don't wait we'll get the pre-toggled icon
		linkedhandler.update_tool() //so we give it a little bit of breathing space

	var/obj/item/arm_item = owner.get_active_held_item()

	if(arm_item && arm_item != linkedhandler)
		if(!owner.dropItemToGround(arm_item))
			to_chat(owner, span_warning("Your [arm_item] interferes with [src]!"))
			return
		else
			to_chat(owner, span_notice("You drop [arm_item] to activate [src]!"))

	var/result = FALSE
	var/need_switch = TRUE
	if(linkedhandler in owner.contents)
		result = TRUE
		need_switch = FALSE
	else
		result = (zone == BODY_ZONE_R_ARM ? owner.put_in_r_hand(linkedhandler) : owner.put_in_l_hand(linkedhandler))
	if(!result)
		to_chat(owner, span_warning("Your [name] fails to activate!"))
		return

	// Activate the hand that now holds our item.
	if(need_switch)
		owner.swap_hand(result)//... or the 1st hand if the index gets lost somehow

	owner.visible_message(span_notice("[owner] extends [item] from [owner.p_their()] [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_notice("You extend [item] from your [zone == BODY_ZONE_R_ARM ? "right" : "left"] arm."),
		span_italics("You hear a short mechanical noise."))
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/cyberimp/arm/toolset/ui_action_click()
	if((organ_flags & ORGAN_FAILING) || (!holder && !contents.len) || !linkedhandler)
		to_chat(owner, span_warning("The implant doesn't respond. It seems to be broken..."))
		return

	var/list/choice_list = list()
	for(var/obj/item/I in items_list)
		choice_list[I] = image(I)
	choice_list["Retract"] = image(icon = 'icons/mob/landmarks.dmi', icon_state = "x")
	var/choice = show_radial_menu(owner, owner, choice_list)
	if(!choice)
		return
	Retract()
	if(owner && owner == usr && owner.stat != DEAD && (src in owner.internal_organs) && (choice in contents))
		// This monster sanity check is a nice example of how bad input is.
		Extend(choice)

/obj/item/organ/cyberimp/arm/toolset/surgery
	name = "surgical toolset implant"
	desc = "A set of surgical tools hidden behind a concealed panel on the user's arm."
	contents = newlist(/obj/item/retractor/augment, /obj/item/hemostat/augment, /obj/item/cautery/augment, /obj/item/surgicaldrill/augment, /obj/item/scalpel/augment, /obj/item/circular_saw/augment)

/obj/item/toolset_handler
	name = "cybernetic apparatus"
	desc = "A set of fine manipulators installed inside arm toolsets, significantly increasing the precision of which their user can manipulate any installed tools."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	toolspeed = 0.5
	///tracks the implant we are attacked to
	var/obj/item/organ/cyberimp/arm/linkedarm
	///tracks our current tool
	var/obj/item/active_tool

/obj/item/toolset_handler/examine(mob/user)
	. = active_tool.examine(user)
	. += span_notice("Use this in hand to switch tools, alt+click to use the tool itself in hand")

///inherit visual & functional aesthetic from our tool because it technically isn't doing anything
/obj/item/toolset_handler/proc/update_tool()
	name = active_tool.name
	desc = active_tool.desc
	force = active_tool.force
	sharpness = active_tool.sharpness
	usesound = active_tool.usesound
	appearance = active_tool.appearance
	hitsound = active_tool.hitsound
	item_state = active_tool.item_state
	tool_behaviour = active_tool.tool_behaviour
	lefthand_file = active_tool.lefthand_file
	righthand_file = active_tool.righthand_file
	linkedarm.owner.update_inv_hands()
	plane = 22

/obj/item/toolset_handler/attack_self(mob/user)
	linkedarm.ui_action_click()

/obj/item/toolset_handler/AltClick(mob/user)
	active_tool.attack_self(user)
	spawn(1)
		update_tool()

/obj/item/toolset_handler/pre_attack(atom/target, mob/living/user, params)
	if(istype(target, /obj/structure/reagent_dispensers) && active_tool?.tool_behaviour == TOOL_WELDER)
		target.attackby(active_tool, user, params)
		return
	. = ..()

/obj/item/toolset_handler/attack(mob/living/M, mob/user)
	if(active_tool)
		if(!(user.a_intent == INTENT_HARM) && attempt_initiate_surgery(src, M, user))
			return
	..()

//we still USE the tools because while we are pretending to use them we are actually pretending to pretend to use them
/obj/item/toolset_handler/tool_start_check(mob/living/user, amount)
	return active_tool.tool_start_check(user, amount)

/obj/item/toolset_handler/tool_use_check(mob/living/user, amount)
	return active_tool.tool_use_check(user, amount)

/obj/item/toolset_handler/use(amount)
	return active_tool.use(amount)

/obj/item/organ/cyberimp/arm/esword
	name = "arm-mounted energy blade"
	desc = "An illegal and highly dangerous cybernetic implant that can project a deadly blade of concentrated energy."
	contents = newlist(/obj/item/melee/transforming/energy/blade/hardlight)

/obj/item/organ/cyberimp/arm/medibeam
	name = "integrated medical beamgun"
	desc = "A cybernetic implant that allows the user to project a healing beam from their hand."
	contents = newlist(/obj/item/gun/medbeam)


/obj/item/organ/cyberimp/arm/flash
	name = "integrated high-intensity photon projector" //Why not
	desc = "An integrated projector mounted onto a user's arm that is able to be used as a powerful flash."
	contents = newlist(/obj/item/assembly/flash/armimplant)

/obj/item/organ/cyberimp/arm/flash/Initialize()
	. = ..()
	if(locate(/obj/item/assembly/flash/armimplant) in items_list)
		var/obj/item/assembly/flash/armimplant/F = locate(/obj/item/assembly/flash/armimplant) in items_list
		F.I = src

/obj/item/organ/cyberimp/arm/baton
	name = "arm electrification implant"
	desc = "An illegal combat implant that allows the user to administer disabling shocks from their arm."
	contents = newlist(/obj/item/borg/stun)

/obj/item/organ/cyberimp/arm/combat
	name = "combat cybernetics implant"
	desc = "A powerful cybernetic implant that contains combat modules built into the user's arm."
	contents = newlist(/obj/item/melee/transforming/energy/blade/hardlight, /obj/item/gun/medbeam, /obj/item/borg/stun, /obj/item/assembly/flash/armimplant)

/obj/item/organ/cyberimp/arm/combat/Initialize()
	. = ..()
	if(locate(/obj/item/assembly/flash/armimplant) in items_list)
		var/obj/item/assembly/flash/armimplant/F = locate(/obj/item/assembly/flash/armimplant) in items_list
		F.I = src

/obj/item/organ/cyberimp/arm/syndie_mantis
	name = "G.O.R.L.E.X. mantis blade implants"
	desc = "Modernized mantis blades designed and coined by Tiger operatives. Energy actuators makes the blade a much deadlier weapon."
	contents = newlist(/obj/item/mantis/blade/syndicate)
	syndicate_implant = TRUE

/obj/item/organ/cyberimp/arm/syndie_mantis/l
	zone = BODY_ZONE_L_ARM
	syndicate_implant = TRUE

/obj/item/organ/cyberimp/arm/nt_mantis
	name = "H.E.P.H.A.E.S.T.U.S. mantis blade implants"
	desc = "Retractable arm-blade implants to get you out of a pinch. Wielding two will let you double-attack."
	contents = newlist(/obj/item/mantis/blade/NT)

/obj/item/organ/cyberimp/arm/nt_mantis/l
	zone = BODY_ZONE_L_ARM

/obj/item/organ/cyberimp/arm/power_cord
	name = "power cord implant"
	desc = "An internal power cord hooked up to a battery. Useful if you run on volts."
	contents = newlist(/obj/item/apc_powercord)
	zone = "l_arm" 
