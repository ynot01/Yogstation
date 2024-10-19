/mob/living/simple_animal/cockroach
	name = "cockroach"
	desc = "This station is just crawling with bugs."
	icon_state = "cockroach"
	icon_dead = "cockroach"
	health = 1
	maxHealth = 1
	turns_per_move = 5
	loot = list(/obj/effect/decal/cleanable/insectguts)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	response_help  = "pokes"
	response_disarm = "shoos"
	response_harm   = "splats"
	attack_vis_effect = ATTACK_EFFECT_SLASH
	speak_emote = list("chitters")
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "chitters"
	verb_ask = "chitters inquisitively"
	verb_exclaim = "chitters loudly"
	verb_yell = "chitters loudly"
	var/squish_chance = 50
	del_on_death = 1


/mob/living/simple_animal/cockroach/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/squashable, \
		squash_chance = squish_chance, \
		squash_damage = 1, \
		squash_flags = SQUASHED_SHOULD_BE_GIBBED|SQUASHED_ALWAYS_IF_DEAD|SQUASHED_DONT_SQUASH_IN_CONTENTS, \
	)

/mob/living/simple_animal/cockroach/death(gibbed)
	if(SSgamemode?.station_was_nuked) //If the nuke is going off, then cockroaches are invincible. Keeps the nuke from killing them, cause cockroaches are immune to nukes.
		return
	..()

/mob/living/simple_animal/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return
	
/mob/living/simple_animal/cockroach/clownbug
	name = "clown bug"
	desc = "Absolutely disgusting... almost as horrid as that one green clown."
	icon_state = "clowngoblin"
	icon_dead = "clowngoblin"
	gold_core_spawnable = HOSTILE_SPAWN
	verb_say = "honks"
	verb_ask = "honks inquisitively"
	verb_exclaim = "honks loudly"
	verb_yell = "honks loudly"
	speak_emote = list("honks")

/mob/living/simple_animal/cockroach/clownbug/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 40)

/mob/living/simple_animal/cockroach/clownbug/death(gibbed)
	var/turf/T = get_turf(src)
	if(T)
		var/mob/living/simple_animal/cockroach/clownbug/C = new /mob/living/simple_animal/cockroach/clownbug(T)
		if(mind)
			mind.transfer_to(C)
		playsound(loc, 'sound/items/bikehorn.ogg', 100, 0)
	..()
