/obj/item/suspiciousphone
	name = "suspicious phone"
	desc = "This device raises pink levels to unknown highs."
	icon = 'icons/obj/traitor.dmi'
	icon_state = "suspiciousphone"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("dumped")
	var/dumped = FALSE

/obj/item/suspiciousphone/attack_self(mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("This device is too advanced for you!"))
		return
	if(dumped)
		to_chat(user, span_warning("You already activated Protocol CRAB-17."))
		return FALSE
	if(tgui_alert(user, "Are you sure you want to crash this market with no survivors?", "Protocol CRAB-17", list("Yes", "No")) == "Yes")
		if(dumped || QDELETED(src)) //Prevents fuckers from cheesing alert
			return FALSE
		var/turf/targetturf = get_random_station_turf()
		if (!targetturf)
			return FALSE
		new /obj/effect/dumpeetTarget(targetturf, user)
		dumped = TRUE
		log_admin("[user] activated a CRAB-17 phone.")

/obj/structure/checkoutmachine
	name = "Nanotrasen Space-Coin Market"
	desc = "This is good for spacecoin because"
	icon = 'icons/obj/money_machine.dmi'
	icon_state = "bogdanoff"
	layer = TABLE_LAYER //So that the crate inside doesn't appear underneath
	armor = list(MELEE = 30, BULLET = 50, LASER = 50, ENERGY = 100, BOMB = 100, BIO = 0, RAD = 0, FIRE = 100, ACID = 80)
	density = TRUE
	pixel_z = -8
	layer = LARGE_MOB_LAYER
	max_integrity = 1800 //yogs doubled health
	var/list/accounts_to_rob
	var/mob/living/carbon/human/bogdanoff
	var/canwalk = FALSE

/obj/structure/checkoutmachine/examine(mob/living/user)
	. = ..()
	. += span_info("Its integrated integrity meter reads: <b>HEALTH: [obj_integrity]</b>.")

/obj/structure/checkoutmachine/proc/check_if_finished()
	for(var/i in accounts_to_rob)
		var/datum/bank_account/B = i
		if (B.being_dumped)
			return FALSE
	return TRUE

/obj/structure/checkoutmachine/attackby(obj/item/W, mob/user, params)
	if(check_if_finished())
		qdel(src)
		return
	if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/card = W
		if(!card.registered_account)
			to_chat(user, span_warning("This card does not have a registered account!"))
			return
		if(!card.registered_account.being_dumped)
			to_chat(user, span_warning("It appears that your funds are safe from draining!"))
			return
		if(do_after(user, 4 SECONDS, src))
			if(!card.registered_account.being_dumped)
				return
			to_chat(user, span_warning("You quickly cash out your funds to a more secure banking location. Funds are safu."))
			card.registered_account.being_dumped = FALSE
			card.registered_account.withdrawDelay = 0
			if(check_if_finished())
				qdel(src)
				return
	else
		return ..()

/obj/structure/checkoutmachine/Initialize(mapload, mob/living/user)
	. = ..()
	bogdanoff = user
	add_overlay("flaps")
	add_overlay("hatch")
	add_overlay("legs_retracted")
	addtimer(CALLBACK(src, .proc/startUp), 50)


/obj/structure/checkoutmachine/proc/startUp() //very VERY snowflake code that adds a neat animation when the pod lands.
	start_dumping() //The machine doesnt move during this time, giving people close by a small window to grab their funds before it starts running around
	sleep(1 SECONDS)
	if(QDELETED(src))
		return
	playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	cut_overlay("flaps")
	sleep(1 SECONDS)
	if(QDELETED(src))
		return
	playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	cut_overlay("hatch")
	sleep(3 SECONDS)
	if(QDELETED(src))
		return
	playsound(src,'sound/machines/twobeep.ogg',50,0)
	var/mutable_appearance/hologram = mutable_appearance(icon, "hologram")
	hologram.pixel_y = 16
	add_overlay(hologram)
	var/mutable_appearance/holosign = mutable_appearance(icon, "holosign")
	holosign.pixel_y = 16
	add_overlay(holosign)
	add_overlay("legs_extending")
	cut_overlay("legs_retracted")
	pixel_z += 4
	sleep(0.5 SECONDS)
	if(QDELETED(src))
		return
	add_overlay("legs_extended")
	cut_overlay("legs_extending")
	pixel_z += 4
	sleep(2 SECONDS)
	if(QDELETED(src))
		return
	add_overlay("screen_lines")
	sleep(0.5 SECONDS)
	if(QDELETED(src))
		return
	cut_overlay("screen_lines")
	sleep(0.5 SECONDS)
	if(QDELETED(src))
		return
	add_overlay("screen_lines")
	add_overlay("screen")
	sleep(0.5 SECONDS)
	if(QDELETED(src))
		return
	playsound(src,'sound/machines/triple_beep.ogg',50,0)
	add_overlay("text")
	sleep(1 SECONDS)
	if(QDELETED(src))
		return
	add_overlay("legs")
	cut_overlay("legs_extended")
	cut_overlay("screen")
	add_overlay("screen")
	cut_overlay("screen_lines")
	add_overlay("screen_lines")
	cut_overlay("text")
	add_overlay("text")
	canwalk = TRUE
	START_PROCESSING(SSfastprocess, src)

/obj/structure/checkoutmachine/Destroy()
	stop_dumping()
	STOP_PROCESSING(SSfastprocess, src)
	priority_announce("The credit deposit machine at [get_area(src)] has been destroyed. Station funds have stopped draining!", sender_override = "CRAB-17 Protocol")
	explosion(src, 0,0,1, flame_range = 2)
	return ..()

/obj/structure/checkoutmachine/proc/start_dumping()
	accounts_to_rob = SSeconomy.bank_accounts.Copy()
	if(bogdanoff)
		accounts_to_rob -= "[bogdanoff.get_bank_account().account_id]"
	for(var/i in accounts_to_rob)
		var/datum/bank_account/B = accounts_to_rob[i]
		B.dumpeet()
	dump()

/obj/structure/checkoutmachine/proc/dump()
	var/percentage_lost = (rand(5, 15) / 100)
	for(var/i in accounts_to_rob)
		var/datum/bank_account/B = i
		if(!B.being_dumped)
			continue
		var/amount = B.account_balance * percentage_lost
		var/datum/bank_account/account
		if(bogdanoff)
			account = bogdanoff.get_bank_account()
		if (account) // get_bank_account() may return FALSE
			account.transfer_money(B, amount)
			B.bank_card_talk("You have lost [percentage_lost * 100]% of your funds! A spacecoin credit deposit machine is located at: [get_area(src)].")
	addtimer(CALLBACK(src, .proc/dump), 150) //Drain every 15 seconds

/obj/structure/checkoutmachine/process()
	var/anydir = pick(GLOB.cardinals)
	if(Process_Spacemove(anydir))
		Move(get_step(src, anydir), anydir)

/obj/structure/checkoutmachine/proc/stop_dumping()
	for(var/i in accounts_to_rob)
		var/datum/bank_account/B = i
		B.being_dumped = FALSE

/obj/effect/dumpeetFall //Falling pod
	name = ""
	icon = 'icons/obj/money_machine_64.dmi'
	pixel_z = 300
	desc = "Get out of the way!"
	layer = FLY_LAYER//that wasnt flying, that was falling with style!
	icon_state = "missile_blur"

/obj/effect/dumpeetTarget
	name = "Landing Zone Indicator"
	desc = "A holographic projection designating the landing zone of something. It's probably best to stand back."
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	light_range = 2
	var/obj/effect/dumpeetFall/DF
	var/obj/structure/checkoutmachine/dump
	var/mob/living/carbon/human/bogdanoff

/obj/effect/ex_act()
	return

/obj/effect/dumpeetTarget/Initialize(mapload, user)
	. = ..()
	bogdanoff = user
	addtimer(CALLBACK(src, .proc/startLaunch), 100)
	sound_to_playing_players('sound/items/dump_it.ogg', 20)
	deadchat_broadcast("Protocol CRAB-17 has been activated. A spacecoin market has been launched at the station!", turf_target = get_turf(src))

/obj/effect/dumpeetTarget/proc/startLaunch()
	DF = new /obj/effect/dumpeetFall(drop_location())
	dump = new /obj/structure/checkoutmachine(null, bogdanoff)
	priority_announce("The spacecoin bubble has popped! Get to the credit deposit machine at [get_area(src)] and cash out before you lose all of your funds!", sender_override = "CRAB-17 Protocol")
	animate(DF, pixel_z = -8, time = 0.5 SECONDS, , easing = LINEAR_EASING)
	playsound(src,  'sound/weapons/mortar_whistle.ogg', 70, 1, 6)
	addtimer(CALLBACK(src, .proc/endLaunch), 5, TIMER_CLIENT_TIME) //Go onto the last step after a very short falling animation



/obj/effect/dumpeetTarget/proc/endLaunch()
	QDEL_NULL(DF) //Delete the falling machine effect, because at this point its animation is over. We dont use temp_visual because we want to manually delete it as soon as the pod appears
	playsound(src, "explosion", 80, 1)
	dump.forceMove(get_turf(src))
	qdel(src) //The target's purpose is complete. It can rest easy now
