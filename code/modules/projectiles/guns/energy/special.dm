#define PLASMA_BASE_RECHARGE 500

/obj/item/gun/energy/ionrifle
	name = "ion rifle"
	desc = "Invented in 2506 to quell attacks from SELF aligned IPCs, the NT-I1 is a bulky rifle designed to disable mechanical and electronic threats at range."
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
	desc = "The NT-I2 Prototype Ion Projector is a lightweight carbine version of the larger ion rifle, built to be ergonomic and efficient."
	icon_state = "ioncarbine"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	pin = null
	ammo_type = list(/obj/item/ammo_casing/energy/ion/weak)
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

/obj/item/gun/energy/decloner/update_overlays()
	. = ..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(!QDELETED(cell) && (cell.charge > shot.e_cost))
		. += "decloner_spin"

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
	desc = "A vicious weapon with the ability to lock up the motor neurons of the respiratory system and take advantage of the increasing suffocation of the brain to destroy it." //god this is such warcrime
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
	item_state = "ecrossbow"
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
	item_state = "ecrossbow"
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
	/// Contains the instances of installed upgrades
	var/list/installed_upgrades = list()
	/// Mod capacity of this item
	var/mod_capacity = 80

/obj/item/gun/energy/plasmacutter/proc/modify_projectile(obj/projectile/plasma/K)
	K.gun = src //do something special on-hit, easy!
	for(var/obj/item/borg/upgrade/plasmacutter/A in installed_upgrades)
		A.modify_projectile(K)

/obj/item/gun/energy/plasmacutter/proc/get_remaining_mod_capacity()
	. = mod_capacity
	for(var/obj/item/borg/upgrade/plasmacutter/a in installed_upgrades)
		. -= a.cost
	return .

/obj/item/gun/energy/plasmacutter/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	AddComponent(/datum/component/butchering, 25, 105, 0, 'sound/weapons/plasma_cutter.ogg')

/obj/item/gun/energy/plasmacutter/Destroy()
	. = ..()
	for(var/obj/item/borg/upgrade/plasmacutter/a in installed_upgrades)
		qdel(a)
	QDEL_NULL(installed_upgrades)

/obj/item/gun/energy/plasmacutter/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("[src] is [round(cell.percent())]% charged.")
	. += span_boldnotice("[get_remaining_mod_capacity()]%</b> mod capacity remaining.")
	for(var/obj/item/borg/upgrade/plasmacutter/a in installed_upgrades)
		. += span_notice("There is \a [a] installed, using [span_bold("[a.cost]%")] capacity.")

/obj/item/gun/energy/plasmacutter/attackby(obj/item/I, mob/user)
	var/charge_multiplier = 0 //2 = Refined stack, 1 = Ore
	if(istype(I, /obj/item/stack/sheet/mineral/plasma))
		charge_multiplier = 2
	if(istype(I, /obj/item/stack/ore/plasma))
		charge_multiplier = 1
	if(!charge_multiplier)
		return ..()

	var/obj/item/stack/S = I

	var/charge_amount = PLASMA_BASE_RECHARGE * charge_multiplier // Get the amount of charge per item
	// Get remaining capacity and get the ideal amount to recharge or all of the stack whichever is smaller
	var/amount_to_eat = ceil(min(((cell.maxcharge - cell.charge) / charge_amount), S.get_amount()))
	if(amount_to_eat == 0)
		to_chat(user, span_notice("You try to insert [I] into [src], but it's fully charged.")) //my cell is round and full
		return
	I.use(amount_to_eat)
	cell.give(charge_amount * amount_to_eat)
	to_chat(user, span_notice("You insert [I] in [src], recharging it."))
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
		var/mutable_appearance/sparks = mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
		target.add_overlay(sparks)
		. = ..()
		target.cut_overlay(sparks)
	else
		. = ..(amount=1)

/obj/item/gun/energy/plasmacutter/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/borg/upgrade/plasmacutter))
		var/obj/item/borg/upgrade/plasmacutter/PC = I
		PC.install(src, user)

/obj/item/gun/energy/plasmacutter/crowbar_act(mob/living/user, obj/item/I)
	. = TRUE
	if(installed_upgrades.len)
		to_chat(user, span_notice("You pry the modifications out."))
		I.play_tool_sound(src, 100)
		for(var/obj/item/borg/upgrade/plasmacutter/M in installed_upgrades)
			M.forceMove(drop_location()) // Uninstallation handled in Exited().
	else
		to_chat(user, span_notice("There are no modifications currently installed."))

/obj/item/gun/energy/plasmacutter/Exited(atom/movable/gone, direction)
	..()
	if(istype(src, /obj/item/gun/energy/plasmacutter/adv/cyborg))
		return // Cyborg should be handling their own thing: /mob/living/silicon/robot/remove_from_upgrades().
	if(gone in installed_upgrades)
		var/obj/item/borg/upgrade/plasmacutter/MK = gone
		MK.uninstall(src)

/obj/item/gun/energy/plasmacutter/mini
	name = "mini plasma cutter"
	desc = "A weak plasma based mining tool."
	icon_state = "plasmacutter_mini"
	item_state = "plasmacutter_mini"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/weak)
	toolspeed = 2
	mod_capacity = 50

/obj/item/gun/energy/plasmacutter/adv
	name = "advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	item_state = "adv_plasmacutter"
	force = 15
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv)
	mod_capacity = 100

/obj/item/gun/energy/plasmacutter/adv/mega
	name = "mega plasma cutter"
	icon_state = "adv_plasmacutter_m"
	item_state = "plasmacutter_mega"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff. This one has been enhanced with plasma magmite."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/mega)
	mod_capacity = 120

/obj/item/gun/energy/plasmacutter/adv/mega/glacite
	name = "mega plasma cutter"
	icon_state = "adv_plasmacutter_g"
	item_state = "plasmacutter_glacite"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff. This one has been enhanced with plasma glacite."

/obj/item/gun/energy/plasmacutter/scatter
	name = "plasma cutter shotgun"
	icon_state = "miningshotgun"
	item_state = "miningshotgun"
	desc = "An industrial-grade, heavy-duty mining shotgun."
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/scatter)
	mod_capacity = 100

/obj/item/gun/energy/plasmacutter/scatter/mega
	name = "mega plasma cutter shotgun"
	icon_state = "miningshotgun_mega"
	item_state = "miningshotgun_mega"
	desc = "An industrial-grade, heavy-duty mining shotgun. This one seems... mega!"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/scatter/adv/mega)
	mod_capacity = 120

/obj/item/gun/energy/plasmacutter/scatter/mega/glacite
	name = "mega plasma cutter shotgun"
	icon_state = "miningshotgun_glacite"
	item_state = "miningshotgun_glacite"

/obj/item/gun/energy/plasmacutter/adv/cyborg
	name = "cyborg advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	force = 15
	selfcharge = 1
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/cyborg)
	mod_capacity = 70

/obj/item/gun/energy/plasmacutter/adv/malf // Can't be subtype of cyborg or it will interfere with upgrades
	name = "cyborg malfunctioning plasma cutter"
	desc = "A mining tool capable o=#9v@3-M!a%R=KILLING AND MURDERING ORGANICS."
	color = "red"
	force = 15
	selfcharge = 1
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv/cyborg/malf)
	mod_capacity = 100

// Upgrades for plasma cutters
/obj/item/borg/upgrade/plasmacutter
	name = "generic upgrade kit"
	desc = "An upgrade for plasma cutters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "modkit"
	w_class = WEIGHT_CLASS_SMALL

	var/cost = 10
	var/stackable = FALSE

/obj/item/borg/upgrade/plasmacutter/examine(mob/user)
	. = ..()
	. += span_notice("This mod takes up [cost] mod capacity.")

	if(stackable)
		. += span_notice("This mod is stackable.")
	else
		. += span_notice("This mod is not stackable.")

/obj/item/borg/upgrade/plasmacutter/action(mob/living/silicon/robot/R)
	. = ..()
	if(!.)
		return FALSE
	for(var/obj/item/gun/energy/plasmacutter/P in R.module.modules)
		return install(P, usr)

/obj/item/borg/upgrade/plasmacutter/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(!.)
		return FALSE

	for(var/obj/item/gun/energy/plasmacutter/P in R.module.modules)
		uninstall(P)

/obj/item/borg/upgrade/plasmacutter/proc/modify_projectile(obj/projectile/plasma/K)
	return

/obj/item/borg/upgrade/plasmacutter/proc/install(obj/item/gun/energy/plasmacutter/P, mob/user)
	if(P.get_remaining_mod_capacity() < cost)
		to_chat(user, span_warning("There is no more room for this upgrade."))
		return FALSE
	if(!stackable && is_type_in_list(src, P.installed_upgrades))
		to_chat(user, span_notice("[src] has already been installed in [P]"))
		return FALSE
	to_chat(user, span_notice("You install [src] into [P]"))
	playsound(loc, 'sound/items/screwdriver.ogg', 100, 1)
	P.installed_upgrades += src
	forceMove(P)
	return TRUE

/obj/item/borg/upgrade/plasmacutter/proc/uninstall(obj/item/gun/energy/plasmacutter/P)
	P.installed_upgrades -= src // Allows you to put the mod back in

/obj/item/borg/upgrade/plasmacutter/defuser
	name = "plasma cutter defusal kit"
	desc = "An upgrade for plasma cutters that allows it to automatically defuse gibtonite."

/obj/item/borg/upgrade/plasmacutter/defuser/modify_projectile(obj/projectile/plasma/K)
	K.defuse = TRUE

/obj/item/borg/upgrade/plasmacutter/capacity
	name = "plasma cutter capacity kit"
	desc = "An upgrade for plasma cutters that doubles the tank capacity."
	cost = 20

/obj/item/borg/upgrade/plasmacutter/capacity/install(obj/item/gun/energy/plasmacutter/P)
	. = ..()
	if(.)
		P.cell.maxcharge = initial(P.cell.maxcharge)*2

/obj/item/borg/upgrade/plasmacutter/capacity/uninstall(obj/item/gun/energy/plasmacutter/P)
	P.cell.maxcharge = initial(P.cell.maxcharge)
	P.cell.charge = min(P.cell.charge, P.cell.maxcharge)
	..()

/obj/item/borg/upgrade/plasmacutter/cooldown
	name = "plasma cutter cooldown kit"
	desc = "An upgrade for plasma cutters that reduces the cooldown."
	cost = 40
	stackable = TRUE

/obj/item/borg/upgrade/plasmacutter/cooldown/install(obj/item/gun/energy/plasmacutter/P)
	. = ..()
	if(.)
		P.fire_delay *= 0.5

/obj/item/borg/upgrade/plasmacutter/cooldown/uninstall(obj/item/gun/energy/plasmacutter/P)
	P.fire_delay *= 2
	..()

/obj/item/borg/upgrade/plasmacutter/range
	name = "plasma cutter range kit"
	desc = "An upgrade for plasma cutters that increases the range."
	cost = 30

/obj/item/borg/upgrade/plasmacutter/range/modify_projectile(obj/projectile/plasma/K)
	K.range += 4

/obj/item/borg/upgrade/plasmacutter/ore
	name = "plasma cutter ore kit"
	desc = "An upgrade for plasma cutters that doubles ore output."
	cost = 30

/obj/item/borg/upgrade/plasmacutter/ore/modify_projectile(obj/projectile/plasma/K)
	K.explosive = TRUE

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

/obj/item/gun/energy/wormhole_projector/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][select]"
	item_state = icon_state

/obj/item/gun/energy/wormhole_projector/update_ammo_types()
	. = ..()
	for(var/i in 1 to ammo_type.len)
		var/obj/item/ammo_casing/energy/wormhole/W = ammo_type[i]
		if(istype(W))
			W.gun = src
			var/obj/projectile/beam/wormhole/WH = W.BB
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

/obj/item/gun/energy/wormhole_projector/proc/create_portal(obj/projectile/beam/wormhole/W, turf/target)
	var/obj/effect/portal/P = new /obj/effect/portal(target, src, 300, null, FALSE, null, atmos_link)
	if(istype(W, /obj/projectile/beam/wormhole/orange))
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

/obj/item/gun/energy/printer/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/gun/energy/printer/flamethrower
	name = "cyborg flame projector"
	desc = "Originally intended for cyborgs to assist in atmospherics projects, was soon scrapped due to safety concerns."
	icon = 'yogstation/icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	ammo_type = list(/obj/item/ammo_casing/energy/flame_projector)
	can_charge = FALSE
	use_cyborg_cell = TRUE

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
	charge_sections = 5
	ammo_x_offset = 2
	shaded_charge = FALSE

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

// 40K Weapons Below

/obj/item/gun/energy/grimdark
	name = "Plasma Weapon"
	desc = "A very deadly weapon. Fires plasma."
	icon_state = "ppistol"
	item_state = "plaspistol"
	icon = 'icons/obj/guns/grimdark.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/grimdark)
	cell_type = "/obj/item/stock_parts/cell/high"
	COOLDOWN_DECLARE(overheat_alert)

/obj/item/gun/energy/grimdark/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/gun/energy/grimdark/process()
	if(heat > 0)
		heat --
	if(icon_state == "[initial(icon_state)]-crit" && heat < 25)
		icon_state = "[initial(icon_state)]"

/obj/item/gun/energy/grimdark/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	heat += 2
	if(heat >= 25)
		icon_state = "[initial(icon_state)]-crit"
		if(COOLDOWN_FINISHED(src, overheat_alert))
			to_chat(user, span_warning("The gun begins to heat up in your hands! Careful!"))
			COOLDOWN_START(src, overheat_alert, 2 SECONDS)
	if(heat >= 30 && prob(20))
		var/turf/T = get_turf(src.loc)
		if (isliving(loc))
			var/mob/living/M = loc
			M.show_message("\red Your [src] critically overheats!", 1)
			M.adjust_fire_stacks(3)
		if(T)
			T.hotspot_expose(700,125)
			explosion(T, -1, -1, 2, 3)
		STOP_PROCESSING(SSobj, src)
		qdel(src)
	return

/obj/item/gun/energy/grimdark/pistol
	name = "Plasma Pistol"
	desc = "A very deadly weapon used by high-ranking members of the Imperium."
	icon = 'icons/obj/guns/grimdark.dmi'
	icon_state = "ppistol"
	item_state = "ppistol"
	ammo_type = list(/obj/item/ammo_casing/energy/grimdark/pistol)
	w_class = WEIGHT_CLASS_SMALL


/obj/item/gun/energy/grimdark/rifle
	name = "Heavy Plasma Rifle"
	desc = "A very deadly weapon used by high-ranking members of the Imperium."
	icon = 'icons/obj/guns/grimdark.dmi'
	icon_state = "prifle"
	item_state = "prifle"
	ammo_type = list(/obj/item/ammo_casing/energy/grimdark)	

#undef PLASMA_BASE_RECHARGE
