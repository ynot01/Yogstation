//Revenants: based off of wraiths from Goon
//"Ghosts" that are invisible and move like ghosts, cannot take damage while invisible
//Don't hear deadchat and are NOT normal ghosts
//Admin-spawn or random event

#define INVISIBILITY_REVENANT 50
#define REVENANT_NAME_FILE "revenant_names.json"

/mob/living/simple_animal/revenant
	name = "revenant"
	desc = "A malevolent spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "revenant_idle"
	var/icon_idle = "revenant_idle"
	var/icon_reveal = "revenant_revealed"
	var/icon_stun = "revenant_stun"
	var/icon_drain = "revenant_draining"
	var/stasis = FALSE
	mob_biotypes = list(MOB_SPIRIT)
	incorporeal_move = INCORPOREAL_MOVE_JAUNT
	invisibility = INVISIBILITY_REVENANT
	health = INFINITY //Revenants don't use health, they use essence instead
	maxHealth = INFINITY
	layer = GHOST_LAYER
	healable = FALSE
	spacewalk = TRUE
	sight = SEE_MOBS | SEE_OBJS | SEE_TURFS | SEE_SELF
	throwforce = 0

	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	response_help   = "passes through"
	response_disarm = "swings through"
	response_harm   = "punches through"
	unsuitable_atmos_damage = 0
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0) //I don't know how you'd apply those, but revenants no-sell them anyway.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	harm_intent_damage = 0
	friendly = "touches"
	status_flags = 0
	wander = FALSE
	density = FALSE
	movement_type = FLYING
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_TINY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	speed = 1
	unique_name = TRUE
	hud_possible = list(ANTAG_HUD)
	hud_type = /datum/hud/revenant

	var/essence = 75 //The resource, and health, of revenants.
	var/essence_regen_cap = 75 //The regeneration cap of essence (go figure); regenerates every Life() tick up to this amount.
	var/essence_regenerating = TRUE //If the revenant regenerates essence or not
	var/essence_regen_amount = 5 //How much essence regenerates
	var/essence_accumulated = 0 //How much essence the revenant has stolen
	var/essence_excess = 0 //How much stolen essence avilable for unlocks
	var/revealed = FALSE //If the revenant can take damage from normal sources.
	var/unreveal_time = 0 //How long the revenant is revealed for, is about 2 seconds times this var.
	var/unstun_time = 0 //How long the revenant is stunned for, is about 2 seconds times this var.
	var/inhibited = FALSE //If the revenant's abilities are blocked by a chaplain's power.
	var/essence_drained = 0 //How much essence the revenant will drain from the corpse it's feasting on.
	var/draining = FALSE //If the revenant is draining someone.
	var/list/drained_mobs = list() //Cannot harvest the same mob twice
	var/perfectsouls = 0 //How many perfect, regen-cap increasing souls the revenant has. //TODO, add objective for getting a perfect soul(s?)
	var/generated_objectives_and_spells = FALSE

/mob/living/simple_animal/revenant/Initialize(mapload)
	. = ..()
	flags_1 |= RAD_NO_CONTAMINATE_1
	ADD_TRAIT(src, TRAIT_SIXTHSENSE, INNATE_TRAIT)

	// Starting spells
	var/datum/action/cooldown/spell/night_vision/revenant/vision = new(src)
	vision.Grant(src)

	var/datum/action/cooldown/spell/list_target/telepathy/revenant/telepathy = new(src)
	telepathy.Grant(src)

	// Starting spells that start locked
	var/datum/action/cooldown/spell/aoe/revenant/overload/lights_go_zap = new(src)
	lights_go_zap.Grant(src)

	var/datum/action/cooldown/spell/aoe/revenant/defile/windows_go_smash = new(src)
	windows_go_smash.Grant(src)

	var/datum/action/cooldown/spell/aoe/revenant/blight/botany_go_mad = new(src)
	botany_go_mad.Grant(src)

	var/datum/action/cooldown/spell/aoe/revenant/malfunction/shuttle_go_emag = new(src)
	shuttle_go_emag.Grant(src)

	random_revenant_name()
	LoadComponent(/datum/component/walk/jaunt) //yogs

/mob/living/simple_animal/revenant/canUseTopic(atom/movable/M, be_close=FALSE, no_dextery=FALSE, no_tk=FALSE)
	return FALSE

/mob/living/simple_animal/revenant/proc/random_revenant_name()
	var/built_name = ""
	built_name += pick(strings(REVENANT_NAME_FILE, "spirit_type"))
	built_name += " of "
	built_name += pick(strings(REVENANT_NAME_FILE, "adverb"))
	built_name += pick(strings(REVENANT_NAME_FILE, "theme"))
	name = built_name

/mob/living/simple_animal/revenant/Login()
	..()
	to_chat(src, span_deadsay("<span class='big bold'>You are a revenant.</span>"))
	to_chat(src, "<b>Your formerly mundane spirit has been infused with alien energies and empowered into a revenant.</b>")
	to_chat(src, "<b>You are not dead, not alive, but somewhere in between. You are capable of limited interaction with both worlds.</b>")
	to_chat(src, "<b>You are invincible and invisible to everyone but other ghosts. Most abilities will reveal you, rendering you vulnerable.</b>")
	to_chat(src, "<b>To function, you are to drain the life essence from humans. This essence is a resource, as well as your health, and will power all of your abilities.</b>")
	to_chat(src, "<b><i>You do not remember anything of your past lives, nor will you remember anything about this one after your death.</i></b>")
	to_chat(src, "<b>Be sure to read <a href=\"https://wiki.yogstation.net/wiki/Revenant\">the wiki page</a> to learn more.</b>")
	if(!generated_objectives_and_spells)
		generated_objectives_and_spells = TRUE
		mind.assigned_role = ROLE_REVENANT
		mind.special_role = ROLE_REVENANT
		SEND_SOUND(src, sound('sound/effects/ghost.ogg'))
		mind.add_antag_datum(/datum/antagonist/revenant)

//Life, Stat, Hud Updates, and Say
/mob/living/simple_animal/revenant/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(stasis)
		return
	if(revealed && essence <= 0)
		death()
	if(unreveal_time && world.time >= unreveal_time)
		unreveal_time = 0
		revealed = FALSE
		incorporeal_move = INCORPOREAL_MOVE_JAUNT
		AddComponent(/datum/component/walk/jaunt)
		invisibility = INVISIBILITY_REVENANT
		to_chat(src, span_revenboldnotice("You are once more concealed."))
	if(unstun_time && world.time >= unstun_time)
		unstun_time = 0
		notransform = FALSE
		to_chat(src, span_revenboldnotice("You can move again!"))
	if(essence_regenerating && !inhibited && essence < essence_regen_cap) //While inhibited, essence will not regenerate
		essence = min(essence_regen_cap, essence+essence_regen_amount)
		update_mob_action_buttons() //because we update something required by our spells in life, we need to update our buttons
	update_spooky_icon()
	update_health_hud()
	..()

/mob/living/simple_animal/revenant/get_status_tab_items()
	. = ..()
	. += "Current essence: [essence]/[essence_regen_cap]E"
	. += "Stolen essence: [essence_accumulated]E"
	. += "Unused stolen essence: [essence_excess]E"
	. += "Stolen perfect souls: [perfectsouls]"

/mob/living/simple_animal/revenant/update_health_hud()
	if(hud_used)
		var/essencecolor = "#8F48C6"
		if(essence > essence_regen_cap)
			essencecolor = "#9A5ACB" //oh boy you've got a lot of essence
		else if(!essence)
			essencecolor = "#1D2953" //oh jeez you're dying
		hud_used.healths.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='[essencecolor]'>[essence]E</font></div>"

/mob/living/simple_animal/revenant/med_hud_set_health()
	return //we use no hud

/mob/living/simple_animal/revenant/med_hud_set_status()
	return //we use no hud

/mob/living/simple_animal/revenant/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	src.log_talk(message, LOG_SAY)
	var/rendered = span_revennotice("<b>[src]</b> says, \"[message]\"")
	for(var/mob/M in GLOB.mob_list)
		if(isrevenant(M))
			to_chat(M, rendered)
		else if(isobserver(M))
			var/link = FOLLOW_LINK(M, src)
			to_chat(M, "[link] [rendered]")
	return


//Immunities

/mob/living/simple_animal/revenant/ex_act(severity, target)
	return 1 //Immune to the effects of explosions.

/mob/living/simple_animal/revenant/blob_act(obj/structure/blob/B)
	return //blah blah blobs aren't in tune with the spirit world, or something.

/mob/living/simple_animal/revenant/singularity_act()
	return //don't walk into the singularity expecting to find corpses, okay?

/mob/living/simple_animal/revenant/narsie_act()
	return //most humans will now be either bones or harvesters, but we're still un-alive.

/mob/living/simple_animal/revenant/ratvar_act()
	return //clocks get out reee

/mob/living/simple_animal/revenant/bullet_act()
	if(!revealed || stasis)
		return BULLET_ACT_FORCE_PIERCE
	return ..()

//damage, gibbing, and dying
/mob/living/simple_animal/revenant/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(istype(W, /obj/item/nullrod))
		visible_message(span_warning("[src] violently flinches!"), \
						span_revendanger("As \the [W] passes through you, you feel your essence draining away!"))
		adjustBruteLoss(25) //hella effective
		inhibited = TRUE
		update_mob_action_buttons()
		addtimer(CALLBACK(src, PROC_REF(reset_inhibit)), 30)

/mob/living/simple_animal/revenant/proc/reset_inhibit()
	inhibited = FALSE
	update_mob_action_buttons()

/mob/living/simple_animal/revenant/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && !revealed)
		return FALSE
	. = amount
	essence = max(0, essence-amount)
	if(updating_health)
		update_health_hud()
	if(!essence)
		death()

/mob/living/simple_animal/revenant/dust(just_ash, drop_items, force)
	death()

/mob/living/simple_animal/revenant/gib()
	death()

/mob/living/simple_animal/revenant/death()
	if(!revealed || stasis) //Revenants cannot die if they aren't revealed //or are already dead
		return 0
	stasis = TRUE
	to_chat(src, span_revendanger("NO! No... it's too late, you can feel your essence [pick("breaking apart", "drifting away")]..."))
	notransform = TRUE
	revealed = TRUE
	invisibility = 0
	playsound(src, 'sound/effects/screech.ogg', 100, 1)
	visible_message(span_warning("[src] lets out a waning screech as violet mist swirls around its dissolving body!"))
	icon_state = "revenant_draining"
	for(var/i = alpha, i > 0, i -= 10)
		stoplag()
		alpha = i
	visible_message(span_danger("[src]'s body breaks apart into a fine pile of blue dust."))
	var/reforming_essence = essence_regen_cap //retain the gained essence capacity
	var/obj/item/ectoplasm/revenant/R = new(get_turf(src))
	R.essence = max(reforming_essence - 15 * perfectsouls, 75) //minus any perfect souls
	R.old_key = client.key //If the essence reforms, the old revenant is put back in the body
	R.revenant = src
	invisibility = INVISIBILITY_ABSTRACT
	revealed = FALSE
	ghostize(0)//Don't re-enter invisible corpse


//reveal, stun, icon updates, cast checks, and essence changing
/mob/living/simple_animal/revenant/proc/reveal(time)
	if(!src)
		return
	if(time <= 0)
		return
	revealed = TRUE
	invisibility = 0
	incorporeal_move = FALSE
	qdel(GetComponent(/datum/component/walk/jaunt))
	if(!unreveal_time)
		to_chat(src, span_revendanger("You have been revealed!"))
		unreveal_time = world.time + time
	else
		to_chat(src, span_revenwarning("You have been revealed!"))
		unreveal_time = unreveal_time + time
	update_spooky_icon()

/mob/living/simple_animal/revenant/proc/stun(time)
	if(!src)
		return
	if(time <= 0)
		return
	notransform = TRUE
	if(!unstun_time)
		to_chat(src, span_revendanger("You cannot move!"))
		unstun_time = world.time + time
	else
		to_chat(src, span_revenwarning("You cannot move!"))
		unstun_time = unstun_time + time
	update_spooky_icon()

/mob/living/simple_animal/revenant/proc/update_spooky_icon()
	if(revealed)
		if(notransform)
			if(draining)
				icon_state = icon_drain
			else
				icon_state = icon_stun
		else
			icon_state = icon_reveal
	else
		icon_state = icon_idle

/mob/living/simple_animal/revenant/proc/castcheck(essence_cost)
	if(!src)
		return
	var/turf/T = get_turf(src)
	if(isclosedturf(T))
		to_chat(src, span_revenwarning("You cannot use abilities from inside of a wall."))
		return FALSE
	for(var/obj/O in T)
		if(O.density && !O.CanPass(src, T))
			to_chat(src, span_revenwarning("You cannot use abilities inside of a dense object."))
			return FALSE
	if(inhibited)
		to_chat(src, span_revenwarning("Your powers have been suppressed by nulling energy!"))
		return FALSE
	if(!change_essence_amount(essence_cost, TRUE))
		to_chat(src, span_revenwarning("You lack the essence to use that ability."))
		return FALSE
	return TRUE

/mob/living/simple_animal/revenant/proc/unlock(essence_cost)
	if(essence_excess < essence_cost)
		return FALSE
	essence_excess -= essence_cost
	update_mob_action_buttons()
	return TRUE

/mob/living/simple_animal/revenant/proc/change_essence_amount(essence_amt, silent = FALSE, source = null)
	if(!src)
		return
	if(essence + essence_amt < 0)
		return
	essence = max(0, essence+essence_amt)
	update_health_hud()
	if(essence_amt > 0)
		essence_accumulated = max(0, essence_accumulated+essence_amt)
		essence_excess = max(0, essence_excess+essence_amt)
	update_mob_action_buttons()
	if(!silent)
		if(essence_amt > 0)
			to_chat(src, span_revennotice("Gained [essence_amt]E[source ? " from [source]":""]."))
		else
			to_chat(src, span_revenminor("Lost [essence_amt]E[source ? " from [source]":""]."))
	return 1

/mob/living/simple_animal/revenant/proc/death_reset()
	revealed = FALSE
	unreveal_time = 0
	notransform = 0
	unstun_time = 0
	inhibited = FALSE
	draining = FALSE
	incorporeal_move = INCORPOREAL_MOVE_JAUNT
	if (!GetComponent(/datum/component/walk/jaunt))
		AddComponent(/datum/component/walk/jaunt)
	invisibility = INVISIBILITY_REVENANT
	alpha=255
	stasis = FALSE


//reforming
/obj/item/ectoplasm/revenant
	name = "glimmering residue"
	desc = "A pile of fine blue dust. Small tendrils of violet mist swirl around it."
	icon = 'icons/effects/effects.dmi'
	icon_state = "revenantEctoplasm"
	w_class = WEIGHT_CLASS_SMALL
	var/essence = 75 //the maximum essence of the reforming revenant
	var/reforming = TRUE
	var/inert = FALSE
	var/old_key //key of the previous revenant, will have first pick on reform.
	var/mob/living/simple_animal/revenant/revenant

/obj/item/ectoplasm/revenant/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(try_reform)), 600)

/obj/item/ectoplasm/revenant/proc/scatter()
	qdel(src)

/obj/item/ectoplasm/revenant/proc/try_reform()
	if(reforming)
		reforming = FALSE
		reform()
	else
		inert = TRUE
		visible_message(span_warning("[src] settles down and seems lifeless."))

/obj/item/ectoplasm/revenant/attack_self(mob/user)
	if(!reforming || inert)
		return ..()
	user.visible_message(span_notice("[user] scatters [src] in all directions."), \
						 span_notice("You scatter [src] across the area. The particles slowly fade away."))
	user.dropItemToGround(src)
	scatter()

/obj/item/ectoplasm/revenant/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(inert)
		return
	visible_message(span_notice("[src] breaks into particles upon impact, which fade away to nothingness."))
	scatter()

/obj/item/ectoplasm/revenant/examine(mob/user)
	. = ..()
	if(inert)
		. += span_revennotice("It seems inert.")
	else if(reforming)
		. += span_revenwarning("It is shifting and distorted. It would be wise to destroy this.")

/obj/item/ectoplasm/revenant/proc/reform()
	if(QDELETED(src) || QDELETED(revenant) || inert)
		return
	var/key_of_revenant
	message_admins("Revenant ectoplasm was left undestroyed for 1 minute and is reforming into a new revenant.")
	forceMove(drop_location()) //In case it's in a backpack or someone's hand
	revenant.forceMove(loc)
	if(old_key)
		for(var/mob/M in GLOB.dead_mob_list)
			if(M.client && M.client.key == old_key) //Only recreates the mob if the mob the client is in is dead
				key_of_revenant = old_key
				break
	if(!key_of_revenant)
		message_admins("The new revenant's old client either could not be found or is in a new, living mob - grabbing a random candidate instead...")
		var/list/candidates = pollCandidatesForMob("Do you want to be [revenant.name] (reforming)?", ROLE_REVENANT, null, ROLE_REVENANT, 50, revenant)
		if(!LAZYLEN(candidates))
			qdel(revenant)
			message_admins("No candidates were found for the new revenant. Oh well!")
			inert = TRUE
			visible_message(span_revenwarning("[src] settles down and seems lifeless."))
			return
		var/mob/dead/observer/C = pick(candidates)
		key_of_revenant = C.key
		if(!key_of_revenant)
			qdel(revenant)
			message_admins("No ckey was found for the new revenant. Oh well!")
			inert = TRUE
			visible_message(span_revenwarning("[src] settles down and seems lifeless."))
			return

	message_admins("[key_of_revenant] has been [old_key == key_of_revenant ? "re":""]made into a revenant by reforming ectoplasm.")
	log_game("[key_of_revenant] was [old_key == key_of_revenant ? "re":""]made as a revenant by reforming ectoplasm.")
	visible_message(span_revenboldnotice("[src] suddenly rises into the air before fading away."))

	revenant.essence = essence
	revenant.essence_regen_cap = essence
	revenant.death_reset()
	revenant.key = key_of_revenant
	revenant = null
	qdel(src)

/obj/item/ectoplasm/revenant/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is inhaling [src]! It looks like [user.p_theyre()] trying to visit the shadow realm!"))
	scatter()
	return (OXYLOSS)

/obj/item/ectoplasm/revenant/Destroy()
	if(!QDELETED(revenant))
		qdel(revenant)
	..()

//objectives
/datum/objective/revenant
	var/targetAmount = 100

/datum/objective/revenant/New()
	targetAmount = rand(350,600)
	explanation_text = "Absorb [targetAmount] points of essence from humans."
	..()

/datum/objective/revenant/check_completion()
	if(..())
		return TRUE
	if(!isrevenant(owner.current))
		return FALSE
	var/mob/living/simple_animal/revenant/R = owner.current
	if(!R || R.stat == DEAD)
		return FALSE
	var/essence_stolen = R.essence_accumulated
	if(essence_stolen < targetAmount)
		return FALSE
	return TRUE

/datum/objective/revenantFluff

/datum/objective/revenantFluff/New()
	var/list/explanationTexts = list("Assist and exacerbate existing threats at critical moments.", \
									 "Avoid killing in plain sight.", \
									 "Cause as much chaos and anger as you can without being killed.", \
									 "Damage and render as much of the station rusted and unusable as possible.", \
									 "Disable and cause malfunctions in as many machines as possible.", \
									 "Ensure that any holy weapons are rendered unusable.", \
									 "Hinder the crew while attempting to avoid being noticed.", \
									 "Make the crew as miserable as possible.", \
									 "Make the clown as miserable as possible.", \
									 "Make the captain as miserable as possible.", \
									 "Prevent the use of energy weapons where possible.")
	explanation_text = pick(explanationTexts)
	..()

/datum/objective/revenantFluff/check_completion()
	return TRUE
