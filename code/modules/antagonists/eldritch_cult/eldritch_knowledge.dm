
/**
  * #Eldritch Knowledge
  *
  * Datum that makes eldritch cultist interesting.
  *
  * Eldritch knowledge isn't instantiated anywhere roundstart, and is initalized and destroyed as the round goes on.
  */
/datum/eldritch_knowledge
	///Name of the knowledge
	var/name = "Basic knowledge"
	///Description of the knowledge
	var/desc = "Basic knowledge of forbidden arts."
	///What shows up
	var/gain_text = ""
	///Cost of knowledge in souls
	var/cost = 0
	///tier of the spell, 3 of any tier is required to purchase the next ugprade knowledge, and upgrades unlock the next tier. TIER_NONE will not advance anything.
	var/tier = TIER_NONE
	///What knowledge is incompatible with this. This will simply make it impossible to research knowledges that are in banned_knowledge once this gets researched.
	var/list/banned_knowledge = list()
	///What path is this on defaults to "Side"
	var/route = PATH_SIDE
	///transmutation recipes unlocked by this knowledge
	var/list/unlocked_transmutations = list()
	///spells unlocked by this knowledge
	var/list/spells_to_add = list()

/** The Lores and their Thematic Representation
 * 
 * 	Ash is the principle of spirit and ambition, and the everlasting flame that burns bright with the kindling of life
 * 	Blade is the principle of violence and tradition, and the fundamental conflicts that arise from proximity
 * 	Bronze is the principle of time and empire, and the unstoppable force of innovation
 * 	Flesh is the principle of temptation and obedience, and the malformation of will
 * 	Rust is the principle of that which makes and unmakes, and the slow decline of all things civilized
 * 	Void is the principle of the inevitable end, and the darkness which will claim all light
 * 
 */

/**
  * What happens when this is assigned to an antag datum
  *
  * This proc is called whenever a new eldritch knowledge is added to an antag datum
  */
/datum/eldritch_knowledge/proc/on_gain(mob/user)
	to_chat(user, span_warning("[gain_text]"))
	for(var/S in spells_to_add)
		var/obj/effect/proc_holder/spell/spell2add = new S
		user.mind.AddSpell(spell2add)
	var/datum/antagonist/heretic/EC = user.mind?.has_antag_datum(/datum/antagonist/heretic)
	for(var/X in unlocked_transmutations)
		var/datum/eldritch_transmutation/ET = new X
		EC.transmutations |= ET
	return
/**
  * What happens when you lose this
  *
  * This proc is called whenever antagonist looses his antag datum, put cleanup code in here
  */
/datum/eldritch_knowledge/proc/on_lose(mob/user)
	for(var/S in spells_to_add)
		var/obj/effect/proc_holder/spell/spell2remove = S
		user.mind.RemoveSpell(spell2remove)
	return
/**
  * What happens every tick
  *
  * This proc is called on SSprocess in eldritch cultist antag datum. SSprocess happens roughly every second
  */
/datum/eldritch_knowledge/proc/on_life(mob/user)
	return



/**
  * Mansus grasp act
  *
  * Gives addtional effects to mansus grasp spell
  */
/datum/eldritch_knowledge/proc/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	return FALSE


/**
  * Sickly blade act
  *
  * Gives addtional effects to sickly blade weapon
  */
/datum/eldritch_knowledge/proc/on_eldritch_blade(atom/target,mob/user,proximity_flag,click_parameters)
	return

///////////////
///Base lore///
///////////////

/datum/eldritch_knowledge/basic
	name = "Break of Dawn"
	desc = "Begins your journey in the Mansus. Allows you to select a target transmuting a living heart on a transmutation rune, create new living hearts by transmuting a heart, poppy, and pool of blood, and create new Codex Cicatrixes by transmuting human skin, a bible, a poppy and a pen."
	gain_text = "Gates to the Mansus open in your mind's passion."
	cost = 0
	spells_to_add = list(/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp)
	unlocked_transmutations = list(/datum/eldritch_transmutation/basic, /datum/eldritch_transmutation/living_heart, /datum/eldritch_transmutation/codex_cicatrix)
	route = "Start"
