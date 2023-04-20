/obj/item/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man-portable anti-armor weapon designed to disable mechanical threats at range."
	icon_state = "ionrifle"
	item_state = null	//so the human update icon uses the icon_state instead.
	can_flashlight = TRUE
	w_class = WEIGHT_CLASS_HUGE
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/ion)
	ammo_x_offset = 3
	flight_x_offset = 17
	flight_y_offset = 9

/obj/item/gun/energy/ionrifle/emp_act(severity)
	return

/obj/item/gun/energy/ionrifle/carbine
	name = "ion carbine"
	desc = "The MK.II Prototype Ion Projector is a lightweight carbine version of the larger ion rifle, built to be ergonomic and efficient."
	icon_state = "ioncarbine"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	pin = null
	ammo_x_offset = 2
	flight_x_offset = 18
	flight_y_offset = 11

/obj/item/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	ammo_type = list(/obj/item/ammo_casing/energy/declone)
	pin = null
	ammo_x_offset = 1

/obj/item/gun/energy/decloner/update_icon()
	..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(!QDELETED(cell) && (cell.charge > shot.e_cost))
		add_overlay("decloner_spin")

/obj/item/gun/energy/decloner/unrestricted
	pin = /obj/item/firing_pin
	ammo_type = list(/obj/item/ammo_casing/energy/declone/weak)

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "flora"
	item_state = "gun"
	ammo_type = list(/obj/item/ammo_casing/energy/flora/yield, /obj/item/ammo_casing/energy/flora/mut)
	modifystate = 1
	ammo_x_offset = 1
	selfcharge = 1

/obj/item/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "meteor_gun"
	item_state = "c20r"
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/meteor)
	cell_type = "/obj/item/stock_parts/cell/potato"
	clumsy_check = 0 // Yogs Might as well let clowns use it.
	/*selfcharge = 1*/ // Yogs Not admeme only anymore

/obj/item/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'yogstation/icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A vicious weapon locking up the motor neurons of the respiratory system and taking advantage of the increasing suffocation of the brain to destroy it." //god this is such warcrime
	icon_state = "mindflayer"
	item_state = "mindflayer"
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = list(/obj/item/ammo_casing/energy/mindflayer)
	pin = null
	ammo_x_offset = 2

/obj/item/gun/energy/kinetic_accelerator/crossbow
	name = "mini energy crossbow"
	desc = "A weapon favored by syndicate stealth specialists. Each bolt injects some poison into the victim."
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(/datum/material/iron=2000)
	suppressed = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/bolt)
	weapon_weight = WEAPON_LIGHT
	obj_flags = 0
	overheat_time = 10 SECONDS
	holds_charge = TRUE
	unique_frequency = TRUE
	can_flashlight = FALSE
	max_mod_capacity = 0

/obj/item/gun/energy/kinetic_accelerator/crossbow/halloween
	name = "candy corn crossbow"
	desc = "A weapon favored by Syndicate trick-or-treaters."
	icon_state = "crossbow_halloween"
	item_state = "crossbow"
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/halloween)

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff."
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma)
	flags_1 = CONDUCT_1
	attack_verb = list("attacked", "slashed", "cut", "sliced")
	force = 12
	sharpness = SHARP_EDGED
	can_charge = FALSE

	heat = 3800
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	tool_behaviour = TOOL_WELDER
	toolspeed = 0.7 //plasmacutters can be used as welders, and are faster than standard welders
	var/progress_flash_divisor = 10  //copypasta is best pasta
	var/light_intensity = 1
	var/charge_weld = 25 //amount of charge used up to start action (multiplied by amount) and per progress_flash_divisor ticks of welding

/obj/item/gun/energy/plasmacutter/mini
	name = "mini plasma cutter"
	desc = "A weak plasma based mining tool."
	icon_state = "plasmacutter_mini"
	item_state = "plasmacutter_mini"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/weak)
	toolspeed = 2

/obj/item/gun/energy/plasmacutter/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 25, 105, 0, 'sound/weapons/plasma_cutter.ogg')

/obj/item/gun/energy/plasmacutter/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("[src] is [round(cell.percent())]% charged.")

/obj/item/gun/energy/plasmacutter/attackby(obj/item/I, mob/user)
	var/charge_multiplier = 0 //2 = Refined stack, 1 = Ore
	if(istype(I, /obj/item/stack/sheet/mineral/plasma))
		charge_multiplier = 2
	if(istype(I, /obj/item/stack/ore/plasma))
		charge_multiplier = 1
	if(charge_multiplier)
		if(cell.charge == cell.maxcharge)
			to_chat(user, span_notice("You try to insert [I] into [src], but it's fully charged.")) //my cell is round and full
			return
		I.use(1)
		cell.give(500*charge_multiplier)
		to_chat(user, span_notice("You insert [I] in [src], recharging it."))
	else
		..()

// Tool procs, in case plasma cutter is used as welder
// Can we start welding?
/obj/item/gun/energy/plasmacutter/tool_start_check(mob/living/user, amount)
	. = tool_use_check(user, amount)
	if(. && user)
		user.flash_act(light_intensity)

// Can we weld? Plasma cutter does not use charge continuously.
// Amount cannot be defaulted to 1: most of the code specifies 0 in the call.
/obj/item/gun/energy/plasmacutter/tool_use_check(mob/living/user, amount)
	if(QDELETED(cell))
		to_chat(user, span_warning("[src] does not have a cell, and cannot be used!"))
		return FALSE
	// Amount cannot be used if drain is made continuous, e.g. amount = 5, charge_weld = 25
	// Then it'll drain 125 at first and 25 periodically, but fail if charge dips below 125 even though it still can finish action
	// Alternately it'll need to drain amount*charge_weld every period, which is either obscene or makes it free for other uses
	if(amount ? cell.charge < charge_weld * amount : cell.charge < charge_weld)
		to_chat(user, span_warning("You need more charge to complete this task!"))
		return FALSE

	return TRUE

/obj/item/gun/energy/plasmacutter/use(amount)
	return (!QDELETED(cell) && cell.use(amount ? amount * charge_weld : charge_weld))

// This only gets called by use_tool(delay > 0)
// It's also supposed to not get overridden in the first place.
/obj/item/gun/energy/plasmacutter/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	. = ..() //return tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())
	if(. && user)
		if (progress_flash_divisor == 0)
			user.flash_act(min(light_intensity,1))
			progress_flash_divisor = initial(progress_flash_divisor)
		else
			progress_flash_divisor--

/obj/item/gun/energy/plasmacutter/use_tool(atom/target, mob/living/user, delay, amount=1, volume=0, datum/callback/extra_checks, robo_check)
	if(amount)
		target.add_overlay(GLOB.welding_sparks)
		. = ..()
		target.cut_overlay(GLOB.welding_sparks)	
	else
		. = ..(amount=1)


/obj/item/gun/energy/plasmacutter/update_icon()
	return

/obj/item/gun/energy/plasmacutter/adv
	name = "advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	item_state = "adv_plasmacutter"
	force = 15
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv)

/obj/item/gun/energy/plasmacutter/adv/mega
	name = "mega plasma cutter"
	icon_state = "adv_plasmacutter_m"
	item_state = "plasmacutter_mega"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff. This one has been enhanced with plasma magmite."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/mega)

/obj/item/gun/energy/plasmacutter/scatter
	name = "plasma cutter shotgun"
	icon_state = "miningshotgun"
	item_state = "miningshotgun"
	desc = "An industrial-grade, heavy-duty mining shotgun."
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/scatter)



/obj/item/gun/energy/plasmacutter/attackby(obj/item/I, mob/user)
	. = ..()
	if(try_upgrade(I))
		to_chat(user, span_notice("You install [I] into [src]"))
		playsound(loc, 'sound/items/screwdriver.ogg', 100, 1)
		qdel(I)

/obj/item/gun/energy/plasmacutter/scatter/mega
	name = "mega plasma cutter shotgun"
	icon_state = "miningshotgun_mega"
	item_state = "miningshotgun_mega"
	desc = "An industrial-grade, heavy-duty mining shotgun. This one seems... mega!"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/scatter/adv/mega)

/obj/item/gun/energy/plasmacutter/adv/cyborg
	name = "cyborg advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	force = 15
	selfcharge = 1
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/cyborg)

/obj/item/gun/energy/plasmacutter/adv/malf // Can't be subtype of cyborg or it will interfere with upgrades
	name = "cyborg malfunctioning plasma cutter"
	desc = "A mining tool capable o=#9v@3-M!a%R=KILLING AND MURDERING ORGANICS."
	color = "red"
	force = 15
	selfcharge = 1
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/cyborg/malf)

// Upgrades for plasma cutters
/obj/item/upgrade/plasmacutter
	name = "generic upgrade kit"
	desc = "An upgrade for plasma shotguns."
	icon = 'icons/obj/objects.dmi'
	icon_state = "modkit"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/upgrade/plasmacutter/defuser
	name = "plasma cutter defusal kit"
	desc = "An upgrade for plasma shotguns that allows it to automatically defuse gibtonite."

/obj/item/gun/energy/plasmacutter/proc/try_upgrade(obj/item/I)
	return // no upgrades for the plasmacutter

/obj/item/gun/energy/plasmacutter/scatter/try_upgrade(obj/item/I)
	if(.)
		return
	if(istype(I, /obj/item/upgrade/plasmacutter/defuser))
		var/kaboom = new/obj/item/ammo_casing/energy/plasma/scatter/adv
		ammo_type = list(kaboom)
		return TRUE
	return FALSE

//no upgrading this one either (for now)
/obj/item/gun/energy/plasmacutter/scatter/mega/try_upgrade(obj/item/I)
	return

/obj/item/gun/energy/wormhole_projector
	name = "bluespace wormhole projector"
	desc = "A projector that emits high density quantum-coupled bluespace beams."
	ammo_type = list(/obj/item/ammo_casing/energy/wormhole, /obj/item/ammo_casing/energy/wormhole/orange)
	item_state = null
	icon_state = "wormhole_projector"
	var/obj/effect/portal/p_blue
	var/obj/effect/portal/p_orange
	var/atmos_link = FALSE

/obj/item/gun/energy/wormhole_projector/upgraded
	desc = "A projector that emits high density quantum-coupled bluespace beams. This one seems to be modified to go through glass."
	ammo_type = list(/obj/item/ammo_casing/energy/wormhole/upgraded, /obj/item/ammo_casing/energy/wormhole/orange/upgraded)

/obj/item/gun/energy/wormhole_projector/update_icon()
	icon_state = "[initial(icon_state)][select]"
	item_state = icon_state

/obj/item/gun/energy/wormhole_projector/update_ammo_types()
	. = ..()
	for(var/i in 1 to ammo_type.len)
		var/obj/item/ammo_casing/energy/wormhole/W = ammo_type[i]
		if(istype(W))
			W.gun = src
			var/obj/item/projectile/beam/wormhole/WH = W.BB
			if(istype(WH))
				WH.gun = src

/obj/item/gun/energy/wormhole_projector/process_chamber()
	..()
	select_fire()

/obj/item/gun/energy/wormhole_projector/proc/on_portal_destroy(obj/effect/portal/P)
	if(P == p_blue)
		p_blue = null
	else if(P == p_orange)
		p_orange = null

/obj/item/gun/energy/wormhole_projector/proc/has_blue_portal()
	if(istype(p_blue) && !QDELETED(p_blue))
		return TRUE
	return FALSE

/obj/item/gun/energy/wormhole_projector/proc/has_orange_portal()
	if(istype(p_orange) && !QDELETED(p_orange))
		return TRUE
	return FALSE

/obj/item/gun/energy/wormhole_projector/proc/crosslink()
	if(!has_blue_portal() && !has_orange_portal())
		return
	if(!has_blue_portal() && has_orange_portal())
		p_orange.link_portal(null)
		return
	if(!has_orange_portal() && has_blue_portal())
		p_blue.link_portal(null)
		return
	p_orange.link_portal(p_blue)
	p_blue.link_portal(p_orange)

/obj/item/gun/energy/wormhole_projector/proc/create_portal(obj/item/projectile/beam/wormhole/W, turf/target)
	var/obj/effect/portal/P = new /obj/effect/portal(target, src, 300, null, FALSE, null, atmos_link)
	if(istype(W, /obj/item/projectile/beam/wormhole/orange))
		qdel(p_orange)
		p_orange = P
		P.icon_state = "portal1"
	else
		qdel(p_blue)
		p_blue = P
	crosslink()

/* 3d printer 'pseudo guns' for borgs */

/obj/item/gun/energy/printer
	name = "cyborg lmg"
	desc = "An LMG that fires 3D-printed flechettes. They are slowly resupplied using the cyborg's internal power source."
	icon_state = "l6_cyborg"
	icon = 'icons/obj/guns/projectile.dmi'
	cell_type = "/obj/item/stock_parts/cell/secborg"
	ammo_type = list(/obj/item/ammo_casing/energy/c3dbullet)
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/printer/flamethrower
	name = "cyborg flame projector"
	desc = "Originally intended for cyborgs to assist in atmospherics projects, was soon scrapped due to safety concerns."
	icon = 'yogstation/icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	ammo_type = list(/obj/item/ammo_casing/energy/flamethrower)
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/printer/update_icon()
	return

/obj/item/gun/energy/printer/emp_act()
	return

/obj/item/gun/energy/temperature
	name = "temperature gun"
	icon_state = "freezegun"
	desc = "A gun that changes temperatures."
	ammo_type = list(/obj/item/ammo_casing/energy/temp, /obj/item/ammo_casing/energy/temp/hot)
	cell_type = "/obj/item/stock_parts/cell/high"
	pin = null

/obj/item/gun/energy/temperature/security
	name = "security temperature gun"
	desc = "A weapon that can only be used to its full potential by the truly robust."
	pin = /obj/item/firing_pin

/obj/item/gun/energy/laser/instakill
	name = "instakill rifle"
	icon_state = "instagib"
	item_state = "instagib"
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit."
	ammo_type = list(/obj/item/ammo_casing/energy/instakill)
	force = 60

/obj/item/gun/energy/laser/instakill/red
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit. This one has a red design."
	icon_state = "instagibred"
	item_state = "instagibred"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/red)

/obj/item/gun/energy/laser/instakill/blue
	desc = "A specialized ASMD laser-rifle, capable of flat-out disintegrating most targets in a single hit. This one has a blue design."
	icon_state = "instagibblue"
	item_state = "instagibblue"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/blue)

/obj/item/gun/energy/laser/instakill/emp_act() //implying you could stop the instagib
	return

/obj/item/gun/energy/gravity_gun
	name = "one-point bluespace-gravitational manipulator"
	desc = "An experimental, multi-mode device that fires bolts of Zero-Point Energy, causing local distortions in gravity."
	ammo_type = list(/obj/item/ammo_casing/energy/gravity/repulse, /obj/item/ammo_casing/energy/gravity/attract, /obj/item/ammo_casing/energy/gravity/chaos)
	item_state = "gravity_gun"
	icon_state = "gravity_gun"
	var/power = 4
