/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is a small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if.<BR>There are bolts under it's glass cover for easy disassembly using a wrench."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 50, BULLET = 20, LASER = 0, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 90, ACID = 50)
	max_integrity = 200//yogs - increase durability to 200
	integrity_failure = 50
	var/locked = TRUE
	var/open = FALSE
	var/obj/item/twohanded/fireaxe/fireaxe
	var/obj/item/card/id/captains_spare/spareid
	var/obj/item/twohanded/fishingrod/collapsible/miningmedic/olreliable //what the fuck?
	var/alert = TRUE
	var/axe = TRUE

//yogs NOTICE - Initialize() function MIRRORED to yogstation/code/game/objects/structure/fireaxe.dm
//changes made to the below function will have no effect
/obj/structure/fireaxecabinet/Initialize()
	. = ..()
	fireaxe = new
	update_icon()

//yogs NOTICE - Destroy() function MIRRORED to yogstation/code/game/objects/structure/fireaxe.dm
//changes made to the below function will have no effect
/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe || spareid)
		if(spareid)
			fireaxe = spareid
		QDEL_NULL(fireaxe)
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/I, mob/user, params)
	check_deconstruct(I, user)//yogs - deconstructible cabinet
	if(iscyborg(user) || I.tool_behaviour == TOOL_MULTITOOL)
		reset_lock(user) //yogs - adds reset option
	else if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP && !broken)
		//Repairing light damage with a welder
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return
			to_chat(user, span_notice("You begin repairing [src]."))
			if(I.use_tool(src, user, 40, volume=50, amount=2))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, span_notice("You repair [src]."))
		else
			to_chat(user, span_warning("[src] is already in good condition!"))
		return
	else if(istype(I, /obj/item/stack/sheet/rglass) && broken)//yogs - change to reinforced glass
		//Repairing a heavily damaged fireaxe cabinet with glass
		var/obj/item/stack/sheet/rglass/G = I//yogs - change to reinforced glass
		if(G.get_amount() < 2)
			to_chat(user, span_warning("You need two reinforced glass sheets to fix [src]!"))//yogs - change to reinforced glass
			return
		to_chat(user, span_notice("You start fixing [src]..."))
		if(do_after(user, 2 SECONDS, src) && G.use(2))
			broken = 0
			obj_integrity = max_integrity
			update_icon()
	//yogs start - warn user if they use the wrong type of glass to repair
	else if(istype(I, /obj/item/stack/sheet/glass) && broken)
		to_chat(user, span_warning("You need reinforced glass sheets to fix [src]!"))
	//yogs end
	else if(open || broken)
		//Fireaxe cabinet is open or broken, so we can access it's axe slot
		if(istype(I, /obj/item/twohanded/fireaxe) && !fireaxe && axe)
			var/obj/item/twohanded/fireaxe/F = I
			if(F.wielded)
				to_chat(user, span_warning("Unwield the [F.name] first."))
				return
			if(!user.transferItemToLoc(F, src))
				return
			fireaxe = F
			to_chat(user, span_caution("You place the [F.name] back in the [name]."))
			update_icon()
			return
		else if(istype(I, /obj/item/card/id/captains_spare) && !spareid && !axe)
			var/obj/item/card/id/captains_spare/S = I
			if(!user.transferItemToLoc(S, src))
				return
			spareid = S
			to_chat(user, span_caution("You place the [S.name] back in the [name]."))
			update_icon()
			return
		else if(istype(I, /obj/item/twohanded/fishingrod/collapsible/miningmedic) && !olreliable && !axe)
			var/obj/item/twohanded/fishingrod/collapsible/miningmedic/R = I
			if(R.opened)
				to_chat(user, span_caution("[R.name] won't seem to fit!"))
				return
			if(!user.transferItemToLoc(R, src))
				return
			olreliable = R
			to_chat(user, span_caution("You place the [R.name] back in the [name]."))
			update_icon()
			return
		else if(!broken)
			//open the cabinet normally.
			toggle_open()
	//yogs start - adds unlock if authorized
	else if (I.GetID())
		if(obj_flags & EMAGGED)
			to_chat(user, span_notice("The [name]'s locking modules are unresponsive."))
			return
		if (allowed(user))
			toggle_lock(user)
		else
			to_chat(user, span_danger("Access denied."))
	//yogs end
	else
		return ..()

/obj/structure/fireaxecabinet/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(broken)
				playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 90, 1)
			else
				playsound(loc, 'sound/effects/glasshit.ogg', 90, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)

/obj/structure/fireaxecabinet/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	//yogs start - adds sparks on damage
	if(prob(30))
		spark_system.start()
	//yogs end
	if(open)
		return
	. = ..()
	if(.)
		update_icon()

/obj/structure/fireaxecabinet/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		update_icon()
		broken = TRUE
		playsound(src, 'sound/effects/glassbr3.ogg', 100, 1)
		new /obj/item/shard(loc)
		new /obj/item/shard(loc)
		new /obj/item/stack/rods(loc)//yogs - adds metal rods for reinforced glass
		new /obj/item/stack/rods(loc)//yogs - adds metal rods for reinforced glass
	trigger_alarm()

/obj/structure/fireaxecabinet/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if((fireaxe || spareid) && loc)
			if(spareid)
				fireaxe = spareid
			fireaxe.forceMove(loc)
			fireaxe = null
		new /obj/item/stack/sheet/metal(loc, 2)
	qdel(src)

/obj/structure/fireaxecabinet/blob_act(obj/structure/blob/B)
	if(fireaxe || spareid)
		if(spareid)
			fireaxe = spareid
		fireaxe.forceMove(loc)
		fireaxe = null
	qdel(src)

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(open || broken)
		if(fireaxe || spareid || olreliable)
			if(spareid)
				fireaxe = spareid
			if(olreliable)
				fireaxe = olreliable
			user.put_in_hands(fireaxe)
			to_chat(user, span_caution("You take the [fireaxe.name] from the [name]."))
			fireaxe = null
			spareid = null
			olreliable = null
			src.add_fingerprint(user)
			update_icon()
			return
	toggle_open()//yogs - consolidates opening code
	return

/obj/structure/fireaxecabinet/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/fireaxecabinet/attack_ai(mob/user)
	toggle_lock(user)
	return

/obj/structure/fireaxecabinet/attack_tk(mob/user)
	toggle_open()//yogs - consolidates opening code
	return

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(fireaxe)
		add_overlay("axe")
	if(spareid)
		add_overlay("card")
	if(olreliable)
		add_overlay("rod")
	if(!open)
		var/hp_percent = obj_integrity/max_integrity * 100
		if(broken)
			add_overlay("glass4")
		else
			switch(hp_percent)
				if(-INFINITY to 40)
					add_overlay("glass3")
				if(40 to 60)
					add_overlay("glass2")
				if(60 to 80)
					add_overlay("glass1")
				if(80 to INFINITY)
					add_overlay("glass")
		if(locked)
			add_overlay("locked")
		else
			add_overlay("unlocked")
	else
		add_overlay("glass_raised")

//yogs NOTICE - toggle_lock() function MIRRORED to yogstation/code/game/objects/structure/fireaxe.dm
//changes made to the below function will have no effect
/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)
	to_chat(user, "<span class = 'caution'> Resetting circuitry...</span>")
	playsound(src, 'sound/machines/locktoggle.ogg', 50, 1)
	if(do_after(user, 2 SECONDS, src))
		to_chat(user, span_caution("You [locked ? "disable" : "re-enable"] the locking modules."))
		locked = !locked
		update_icon()

/obj/structure/fireaxecabinet/verb/toggle_open()
	set name = "Open/Close"
	set category = "Object"
	set src in oview(1)

	if(!isliving(usr))
		return

	if(locked)
		to_chat(usr, span_warning("The [name] won't budge!"))
		return
	else
		playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)//yogs - adds open/close sound
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/proc/trigger_alarm()
	//Activate Anti-theft
	if(alert)
		var/area/alarmed = get_area(src)
		alarmed.burglaralert(src)
		playsound(src, 'sound/effects/alert.ogg', 50, TRUE)

/obj/structure/fireaxecabinet/bridge/spare
	name = "spare id cabinet"
	desc = "There is a small label that reads \"For Emergency use only\". <BR>There are bolts under it's glass cover for easy disassembly using a wrench."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "spareid"
	alert = TRUE
	armor = list(MELEE = 30, BULLET = 20, LASER = 0, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 90, ACID = 50)
	axe = FALSE

/obj/structure/fireaxecabinet/bridge/spare/Initialize()
	. = ..()
	fireaxe = null
	spareid = new(src)
	update_icon()
	
/obj/structure/fireaxecabinet/bridge/spare/reset_lock(mob/user)
	//this happens when you hack the lock as a synthetic/AI, or with a multitool.
	if(obj_flags & EMAGGED)
		to_chat(user, span_notice("You try to reset the [name]'s circuits, but they're completely burnt out."))
		return
	if(!open)
		to_chat(user, "<span class = 'caution'>Resetting circuitry...</span>")
		if(alert)
			to_chat(user, span_danger("This will trigger the built in burglary alarm!"))
		if(do_after(user, 15 SECONDS, src))
			to_chat(user, span_caution("You [locked ? "disable" : "re-enable"] the locking modules."))
			src.add_fingerprint(user)
			if(locked)
				trigger_alarm() //already checks for alert var
			toggle_lock(user)

/obj/structure/fireaxecabinet/bridge/spare/emag_act(mob/user)
	. = ..()
	if(!.)
		return
	trigger_alarm()


/obj/structure/fireaxecabinet/fishingrod
	name = "fishing cabinet"
	desc = "There is a small label that reads \"Fo* Em**gen*y u*e *nly\". All the other text is scratched out and replaced with various fish weights. <BR>There are bolts under it's glass cover for easy disassembly using a wrench."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fishingrod"
	axe = FALSE
	alert = FALSE
	req_access = list(ACCESS_MEDICAL, ACCESS_MINING)

/obj/structure/fireaxecabinet/fishingrod/Initialize()
	. = ..()
	fireaxe = null
	olreliable = new(src)
	update_icon()
