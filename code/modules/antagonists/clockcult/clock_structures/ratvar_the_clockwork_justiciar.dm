//Ratvar himself. Impossible to damage by most standard means, and converts nearby objects and players into clockwork variants and Servants.
/obj/structure/destructible/clockwork/massive/ratvar
	name = "Ratvar, the Clockwork Justiciar"
	desc = "..."
	clockwork_desc = "<span class='large_brass bold italics'>Ratvar, free at last!</span>"
	icon = 'icons/effects/512x512.dmi'
	icon_state = "ratvar"
	pixel_x = -235
	pixel_y = -248
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	appearance_flags = 0
	light_power = 0.7
	light_range = 15
	light_color = "#BE8700"
	var/atom/prey //Whatever Ratvar is chasing
	var/clashing = FALSE //If Ratvar is fighting with Nar'sie
	var/convert_range = 10
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION

/obj/structure/destructible/clockwork/massive/ratvar/Initialize(mapload)
	. = ..()
	GLOB.ratvar_awakens++
	for(var/obj/O in GLOB.all_clockwork_objects)
		O.ratvar_act()
	for(var/mob/living/simple_animal/hostile/clockwork/M in GLOB.all_clockwork_mobs)
		M.ratvar_act()
	START_PROCESSING(SSobj, src)
	if(prob(25))
		send_to_playing_players(span_ratvar("[text2ratvar("COGGERS")]!"))
	else
		send_to_playing_players(span_ratvar("[text2ratvar("ONCE AGAIN MY LIGHT SHINES AMONG THESE PATHETIC STARS")]"))

	sound_to_playing_players('sound/effects/ratvar_reveal.ogg')
	var/mutable_appearance/alert_overlay = mutable_appearance('icons/effects/clockwork_effects.dmi', "ratvar_alert")
	notify_ghosts("The Justiciar's light calls to you! Reach out to Ratvar in [get_area_name(src)] to be granted a shell to spread his glory!", null, source = src, alert_overlay = alert_overlay)
	INVOKE_ASYNC(SSshuttle.emergency, TYPE_PROC_REF(/obj/docking_port/mobile/emergency, request), null, 10, null, FALSE, 0)

/obj/structure/destructible/clockwork/massive/ratvar/Destroy()
	GLOB.ratvar_awakens--
	for(var/obj/O in GLOB.all_clockwork_objects)
		O.ratvar_act()
	STOP_PROCESSING(SSobj, src)
	return ..()

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/destructible/clockwork/massive/ratvar/attack_ghost(mob/dead/observer/O)
	var/alertresult = alert(O, "Embrace the Justiciar's light? You can no longer be cloned!",,"Yes", "No")
	if(alertresult == "No" || QDELETED(O) || !istype(O) || !O.key)
		return FALSE
	var/mob/living/simple_animal/drone/cogscarab/ratvar/R = new/mob/living/simple_animal/drone/cogscarab/ratvar(get_turf(src))
	R.visible_message("[span_heavy_brass("[R] forms, and its eyes blink open, glowing bright red!")]")
	R.key = O.key

/obj/structure/destructible/clockwork/massive/ratvar/Bump(atom/A)
	var/turf/T = get_turf(A)
	if(T == loc)
		T = get_step(T, dir) //please don't run into a window like a bird, ratvar
	forceMove(T)

/obj/structure/destructible/clockwork/massive/ratvar/Process_Spacemove()
	return clashing

/obj/structure/destructible/clockwork/massive/ratvar/process()
	if(clashing) //I'm a bit occupied right now, thanks
		return
	for(var/I in circle_range_turfs(src, convert_range))
		var/turf/T = I
		T.ratvar_act()
	for(var/I in circleviewturfs(src, round(convert_range * 0.5)))
		var/turf/T = I
		T.ratvar_act(TRUE)
	var/dir_to_step_in = pick(GLOB.cardinals)
	var/list/meals = list()
	for(var/mob/living/L in GLOB.alive_mob_list) //we want to know who's alive so we don't lose and retarget a single person
		if(L.z == z && !is_servant_of_ratvar(L) && L.mind)
			meals += L
	if(GLOB.cult_narsie && GLOB.cult_narsie.z == z)
		meals = list(GLOB.cult_narsie) //if you're in the way, handy for him, but ratvar only cares about Nar'sie!
		prey = GLOB.cult_narsie
		if(get_dist(src, prey) <= 10)
			clash()
			return
	if(!prey)
		if(!prey && LAZYLEN(meals))
			var/mob/living/L = prey
			prey = pick(meals)
			to_chat(prey, "<span class='heavy_brass'><font size=5>\"You will do, heretic.\"</font></span>\n\
			[span_userdanger("You feel something massive turn its crushing focus to you...")]")
			L.playsound_local(prey, 'sound/effects/ratvar_reveal.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		if((!istype(prey, /obj/singularity/narsie) && prob(10) && LAZYLEN(meals) > 1) || prey.z != z || !(prey in meals))
			if(is_servant_of_ratvar(prey))
				to_chat(prey, "<span class='heavy_brass'><font size=5>\"Serve me well.\"</font></span>\n\
				[span_big_brass("You feel great joy as your god turns His eye to another heretic...")]")
			else
				to_chat(prey, "<span class='heavy_brass'><font size=5>\"No matter. I will find you later, heretic.\"</font></span>\n\
				[span_userdanger("You feel tremendous relief as the crushing focus relents...")]")
			prey = null
		else
			dir_to_step_in = get_dir(src, prey) //Unlike Nar'sie, Ratvar ruthlessly chases down his target
	step(src, dir_to_step_in)

/obj/structure/destructible/clockwork/massive/ratvar/proc/clash()
	if(clashing || prey != GLOB.cult_narsie)
		return
	clashing = TRUE
	GLOB.cult_narsie.clashing = TRUE
	send_to_playing_players("<span class='bold brass'><font size=5>\"YOU.\"</font></span>")
	send_to_playing_players("<span class='bold cult'><font size=5>\"Ratvar?!\"</font></span>")
	clash_of_the_titans(GLOB.cult_narsie) // >:(
	return TRUE

//Put me in Reebe, will you? Ratvar has found and is going to do a hecking murder on Nar'sie
/obj/structure/destructible/clockwork/massive/ratvar/proc/clash_of_the_titans(obj/singularity/narsie/narsie)
	var/winner = "Undeclared"
	var/base_victory_chance = 1
	while(src && narsie)
		sound_to_playing_players('sound/magic/clockwork/ratvar_attack.ogg')
		sleep(0.52 SECONDS)
		for(var/mob/M in GLOB.mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#966400", flash_time=1)
				shake_camera(M, 4, 3)
		var/ratvar_chance = min(LAZYLEN(SSgamemode.servants_of_ratvar), 50)
		var/narsie_chance = min(LAZYLEN(SSgamemode.cult), 50)
		ratvar_chance = rand(base_victory_chance, ratvar_chance)
		narsie_chance = rand(base_victory_chance, narsie_chance)
		if(ratvar_chance > narsie_chance)
			winner = "Ratvar"
			break
		sleep(rand(0.2 SECONDS, 0.5 SECONDS))
		sound_to_playing_players('sound/magic/clockwork/narsie_attack.ogg')
		sleep(0.74 SECONDS)
		for(var/mob/M in GLOB.mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#C80000", flash_time=1)
				shake_camera(M, 4, 3)
		if(narsie_chance > ratvar_chance)
			winner = "Nar'sie"
			break
		base_victory_chance *= 2 //The clash has a higher chance of resolving each time both gods attack one another
	switch(winner)
		if("Ratvar")
			send_to_playing_players("<span class='heavy_brass'><font size=5>\"[pick("DIE.", "ROT.")]\"</font></span>\n\
			<span class='cult'><font size=5>\"<b>[pick("Nooooo...", "Not die. To y-", "Die. Ratv-", "Sas tyen re-")]\"</b></font></span>") //Nar'sie get out
			sound_to_playing_players('sound/magic/clockwork/anima_fragment_attack.ogg')
			sound_to_playing_players('sound/magic/demon_dies.ogg', 50)
			clashing = FALSE
			qdel(narsie)
		if("Nar'sie")
			send_to_playing_players(span_cult("<font size=5>\"<b>[pick("Ha.", "Ra'sha fonn dest.", "You fool. To come here.")]</b>\"</font>")) //Broken English
			sound_to_playing_players('sound/magic/demon_attack1.ogg')
			sound_to_playing_players('sound/magic/clockwork/anima_fragment_death.ogg', 62)
			narsie.clashing = FALSE
			qdel(src)
