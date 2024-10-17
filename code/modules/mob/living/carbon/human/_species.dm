// This code handles different species in the game.

GLOBAL_LIST_EMPTY(roundstart_races)
GLOBAL_LIST_EMPTY(mentor_races)

/// An assoc list of species types to their features (from get_features())
GLOBAL_LIST_EMPTY(features_by_species)

/datum/species
	/// if the game needs to manually check your race to do something not included in a proc here, it will use this
	var/id
	///this is used if you want to use a different species limb sprites. Mainly used for angels as they look like humans.
	var/limbs_id
	/// this is the fluff name. these will be left generic (such as 'Lizardperson' for the lizard race) so servers can change them to whatever
	var/name
	/// The formatting of the name of the species in plural context. Defaults to "[name]\s" if unset.
	/// Ex "[Plasmamen] are weak", "[Mothmen] are strong", "[Lizardpeople] don't like", "[Golems] hate"
	var/plural_form
	/// if alien colors are disabled, this is the color that will be used by that race
	var/default_color = "#FFF"

	///A list that contains pixel offsets for various clothing features, if your species is a different shape
	var/list/offset_features = list(OFFSET_UNIFORM = list(0,0), OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_GLASSES = list(0,0), OFFSET_EARS = list(0,0), OFFSET_SHOES = list(0,0), OFFSET_S_STORE = list(0,0), OFFSET_FACEMASK = list(0,0), OFFSET_HEAD = list(0,0), OFFSET_FACE = list(0,0), OFFSET_BELT = list(0,0), OFFSET_BACK = list(0,0), OFFSET_SUIT = list(0,0), OFFSET_NECK = list(0,0))

	/// this allows races to have specific hair colors... if null, it uses the H's hair/facial hair colors. if "mutcolor", it uses the H's mutant_color
	var/hair_color
	/// the alpha used by the hair. 255 is completely solid, 0 is transparent.
	var/hair_alpha = 255
	///The gradient style used for the mob's hair.
	var/grad_style
	///The gradient color used to color the gradient.
	var/grad_color
	/// does it use skintones or not? (spoiler alert this is only used by humans)
	var/use_skintones = FALSE
	var/icon_husk
	var/forced_skintone

	/// What genders can this race be?
	var/list/possible_genders = list(MALE, PLURAL, FEMALE)
	/// If your race wants to bleed something other than bog standard blood, change this to reagent id.
	var/datum/reagent/exotic_blood
	///If your race uses a non standard bloodtype (A+, O-, AB-, etc)
	var/exotic_bloodtype = ""
	///What the species drops on gibbing
	var/meat = /obj/item/reagent_containers/food/snacks/meat/slab/human
	///What, if any, leather will be dropped
	var/skinned_type
	///What kind of foods the species loves
	var/liked_food = NONE
	///What kind of foods the species dislikes!
	var/disliked_food = GROSS
	///What kind of foods cause harm to the species
	var/toxic_food = TOXIC
	/// slots the race can't equip stuff to
	var/list/no_equip = list()
	/// slots the race can't equip stuff to that have been added externally that should be inherited on species change
	var/list/extra_no_equip = list()
	/// this is sorta... weird. it basically lets you equip stuff that usually needs jumpsuits without one, like belts and pockets and ids
	var/nojumpsuit = FALSE
	/// affects the speech message
	var/say_mod = "says"
	/// Weighted list. NOTE: Picks one of the list component and then does a prob() on it, since we can't do a proper weighted pick, since we need to take into account the regular say_mod.
	//TL;DR "meows" = 75 and "rawr" = 25 isn't actually 75% and 25%. It's 75% * 50% = 37.5% and 25% * 50% = 12.5%. Chance is divided by number of elements
	var/list/rare_say_mod = list()
	///Used if you want to give your species thier own language
	var/species_language_holder = /datum/language_holder
	/// Default mutant bodyparts for this species. Don't forget to set one for every mutant bodypart you allow this species to have.
	var/list/default_features = list()
	/// Visible CURRENT bodyparts that are unique to a species. DO NOT USE THIS AS A LIST OF ALL POSSIBLE BODYPARTS AS IT WILL FUCK SHIT UP! Changes to this list for non-species specific bodyparts (ie cat ears and tails) should be assigned at organ level if possible. Layer hiding is handled by handle_mutant_bodyparts() below.
	var/list/mutant_bodyparts = list()
	///Internal organs that are unique to this race.
	var/list/mutant_organs = list()
	/// this affects the race's speed. positive numbers make it move slower, negative numbers make it move faster
	var/speedmod = 0
	///overall defense for the race... or less defense, if it's negative.
	var/armor = 0
	/// multiplier for brute damage
	var/brutemod = 1
	/// multiplier for burn damage
	var/burnmod = 1
	/// multiplier for cold damage
	var/coldmod = 1
	/// multiplier for heat damage
	var/heatmod = 1
	/// multiplier for temperature adjustment
	var/tempmod = 1
	/// multiplier for acid damage // yogs - Old Plant People
	var/acidmod = 1
	/// multiplier for stun duration
	var/stunmod = 1
	/// multiplier for oxyloss
	var/oxymod = 1
	/// multiplier for cloneloss
	var/clonemod = 1
	/// multiplier for toxloss
	var/toxmod = 1
	/// multiplier for stun duration
	var/staminamod = 1
	/// multiplier for pressure damage
	var/pressuremod = 1
	/// multiplier for EMP severity
	var/emp_mod = 1
	///Type of damage attack does
	var/attack_type = BRUTE
	///lowest possible punch damage. if this is set to 0, punches will always miss
	var/punchdamagelow = 1
	///highest possible punch damage
	var/punchdamagehigh = 10
	///damage at which punches from this race will stun //yes it should be to the attacked race but it's not useful that way even if it's logical
	var/punchstunthreshold = 10
	///values of inaccuracy that adds to the spread of any ranged weapon
	var/aiminginaccuracy = 0
	///base electrocution coefficient
	var/siemens_coeff = 1
	///base action speed coefficient
	var/action_speed_coefficient = 1
	///what kind of damage overlays (if any) appear on our species when wounded?
	var/damage_overlay_type = "human"
	///to use MUTCOLOR with a fixed color that's independent of dna.feature["mcolor"]
	var/fixed_mut_color = ""
	///special mutation that can be found in the genepool. Dont leave empty or changing species will be a headache
	var/inert_mutation 	= DWARFISM
	///used to set the mobs deathsound on species change
	var/deathsound
	///Barefoot step sound
	var/barefoot_step_sound = FOOTSTEP_MOB_BAREFOOT
	///Sounds to override barefeet walking
	var/list/special_step_sounds
	///How loud to play the step override
	var/special_step_volume = 50
	///Sounds to play while walking regardless of wearing shoes
	var/list/special_walk_sounds
	///Special sound for grabbing
	var/grab_sound
	///yogs - audio of a species' scream
	var/screamsound  //yogs - grabs scream from screamsound list or string
	var/husk_color = "#A6A6A6"
	var/creampie_id = "creampie_human"
	/// The visual effect of the attack.
	var/attack_effect = ATTACK_EFFECT_PUNCH
	///is a flying species, just a check for some things
	var/flying_species = FALSE
	///the actual flying ability given to flying species
	var/datum/action/innate/flight/fly
	///the icon used for the wings + details icon of a different source colour
	var/wings_icon = "Angel"
	var/wings_detail
	/// What kind of gibs to spawn
	var/species_gibs = "human"
	/// Can this species use numbers in its name?
	var/allow_numbers_in_name = FALSE
	///Does this species have different sprites according to sex? A species may have sexes, but only one kind of bodypart sprite like chests
	var/is_dimorphic = TRUE
	/// species-only traits. Can be found in DNA.dm
	var/list/species_traits = list()
	/// generic traits tied to having the species
	var/list/inherent_traits = list()
	///biotypes, used for viruses and the like
	var/list/inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	/// punch-specific attack verbs
	var/list/attack_verbs = list("punch")
	///the melee attack sound
	var/sound/attack_sound = 'sound/weapons/punch1.ogg'
	///the swing and miss sound
	var/sound/miss_sound = 'sound/weapons/punchmiss.ogg'

	/// list of mobs that will ignore this species
	var/list/mob/living/ignored_by = list()
	//Breathing!
	///what type of gas is breathed
	var/breathid = GAS_O2

	/// Special typing indicators
	var/bubble_icon = BUBBLE_DEFAULT

	/// The icon_state of the fire overlay added when sufficently ablaze and standing. see onfire.dmi
	var/fire_overlay = "human" //not used until monkey is added as a species type rather than a mob

	//Do NOT remove by setting to null. use OR make a RESPECTIVE TRAIT (removing stomach? add the NOSTOMACH trait to your species)
	//why does it work this way? because traits also disable the downsides of not having an organ, removing organs but not having the trait will make your species die

	///Replaces default brain with a different organ
	var/obj/item/organ/brain/mutantbrain = /obj/item/organ/brain
	///Replaces default heart with a different organ
	var/obj/item/organ/heart/mutantheart = /obj/item/organ/heart
	///Replaces default lungs with a different organ
	var/obj/item/organ/lungs/mutantlungs = /obj/item/organ/lungs
	///Replaces default eyes with a different organ
	var/obj/item/organ/eyes/mutanteyes = /obj/item/organ/eyes
	///Replaces default ears with a different organ
	var/obj/item/organ/ears/mutantears = /obj/item/organ/ears
	///Replaces default tongue with a different organ
	var/obj/item/organ/tongue/mutanttongue = /obj/item/organ/tongue
	///Replaces default liver with a different organ
	var/obj/item/organ/liver/mutantliver = /obj/item/organ/liver
	///Replaces default stomach with a different organ
	var/obj/item/organ/stomach/mutantstomach = /obj/item/organ/stomach
	///Replaces default appendix with a different organ.
	var/obj/item/organ/appendix/mutantappendix = /obj/item/organ/appendix
	///Forces a species tail
	var/obj/item/organ/tail/mutanttail = /obj/item/organ/tail
	///Forces an item into this species' hands. Only an honorary mutantthing because this is not an organ and not loaded in the same way, you've been warned to do your research.
	var/obj/item/mutanthands

	var/override_float = FALSE

	///Bitflag that controls what in game ways can select this species as a spawnable source. Think magic mirror and pride mirror, slime extract, ERT etc, see defines in __DEFINES/mobs.dm, defaults to NONE, so people actually have to think about it
	var/changesource_flags = NONE

	//The component to add when swimming
	var/swimming_component = /datum/component/swimming

	var/smells_like = "something alien"

	//Should we preload this species's organs?
	var/preload = TRUE

	//for preternis + synths
	var/draining = FALSE
	///Does our species have colors for its' damage overlays?
	var/use_damage_color = TRUE

	/// Do we try to prevent reset_perspective() from working? Useful for Dullahans to stop perspective changes when they're looking through their head.
	var/prevent_perspective_change = FALSE

	/// List of the type path of every ability innate to this species
	var/list/species_abilities = list()
	/// List of the created abilities, stored for the purpose of removal later, please do not touch this if you don't need to
	var/list/datum/action/instantiated_abilities = list()

///////////
// PROCS //
///////////


/datum/species/New()
	if(!limbs_id)	//if we havent set a limbs id to use, just use our own id
		limbs_id = id

	if(!plural_form)
		plural_form = "[name]\s"

	return ..()

/// Gets a list of all species available to choose in roundstart.
/proc/get_selectable_species()
	RETURN_TYPE(/list)

	if (!GLOB.roundstart_races.len)
		GLOB.roundstart_races = generate_selectable_species()

	return GLOB.roundstart_races

/**
 * Generates species available to choose in character setup at roundstart
 *
 * This proc generates which species are available to pick from in character setup.
 * If there are no available roundstart species, defaults to human.
 */
/proc/generate_selectable_species()
	var/list/selectable_species = list()

	for(var/species_type in subtypesof(/datum/species))
		var/datum/species/species = new species_type
		if(species.check_roundstart_eligible())
			selectable_species += species.id
			qdel(species)

	if(!selectable_species.len)
		selectable_species += "human"

	return selectable_species

/**
 * Checks if a species is eligible to be picked at roundstart.
 *
 * Checks the config to see if this species is allowed to be picked in the character setup menu.
 * Used by [/proc/generate_selectable_species].
 */
/datum/species/proc/check_roundstart_eligible()
	if(id in (CONFIG_GET(keyed_list/roundstart_races)))
		return TRUE
	return FALSE

/datum/species/proc/check_mentor()
	if(id in (CONFIG_GET(keyed_list/mentor_races)))
		return TRUE
	return FALSE

/datum/species/proc/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_name(gender)

	var/randname
	if(gender == MALE)
		randname = pick(GLOB.first_names_male)
	else
		randname = pick(GLOB.first_names_female)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(GLOB.last_names)]"

	return randname

//used to add things to the no_equip list that'll get inherited on species changes
/datum/species/proc/add_no_equip_slot(mob/living/carbon/C, slot, source)
	if(!("[slot]" in extra_no_equip))
		extra_no_equip["[slot]"] = list(source)
	else
		extra_no_equip["[slot]"] |= list(source)
	var/obj/item/thing = C.get_item_by_slot(slot)
	if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
		C.dropItemToGround(thing)

//removes something from the extra_no_equip list as well as the normal no_equip list
/datum/species/proc/remove_no_equip_slot(mob/living/carbon/C, slot, source)
	extra_no_equip["[slot]"] -= source
	if(!length(extra_no_equip["[slot]"]))
		extra_no_equip -= "[slot]"

//Called when cloning, copies some vars that should be kept
/datum/species/proc/copy_properties_from(datum/species/old_species)
	return

//Please override this locally if you want to define when what species qualifies for what rank if human authority is enforced.
/datum/species/proc/qualifies_for_rank(rank, list/features)
	if(rank in GLOB.command_positions)
		return 0
	return 1

/datum/species/proc/has_toes()
	return FALSE

/// Sprite to show for photocopying mob butts
/datum/species/proc/get_butt_sprite(mob/living/carbon/human/human)
	return human.gender == FEMALE ? BUTT_SPRITE_HUMAN_FEMALE : BUTT_SPRITE_HUMAN_MALE

/**
 * Corrects organs in a carbon, removing ones it doesn't need and adding ones it does.
 *
 * Takes all organ slots, removes organs a species should not have, adds organs a species should have.
 * can use replace_current to refresh all organs, creating an entirely new set.
 *
 * Arguments:
 * * C - carbon, the owner of the species datum AKA whoever we're regenerating organs in
 * * old_species - datum, used when regenerate organs is called in a switching species to remove old mutant organs.
 * * replace_current - boolean, forces all old organs to get deleted whether or not they pass the species' ability to keep that organ
 * * visual_only - boolean, only load organs that change how the species looks. Do not use for normal gameplay stuff
 */
/datum/species/proc/regenerate_organs(mob/living/carbon/C, datum/species/old_species, replace_current = TRUE, visual_only = FALSE)
	//what should be put in if there is no mutantorgan (brains handled separately)
	var/list/slot_mutantorgans = list(ORGAN_SLOT_BRAIN = mutantbrain, ORGAN_SLOT_HEART = mutantheart, ORGAN_SLOT_LUNGS = mutantlungs, ORGAN_SLOT_APPENDIX = mutantappendix, \
	ORGAN_SLOT_EYES = mutanteyes, ORGAN_SLOT_EARS = mutantears, ORGAN_SLOT_TONGUE = mutanttongue, ORGAN_SLOT_LIVER = mutantliver, ORGAN_SLOT_STOMACH = mutantstomach, ORGAN_SLOT_TAIL = mutanttail)

	for(var/slot in list(ORGAN_SLOT_BRAIN, ORGAN_SLOT_HEART, ORGAN_SLOT_LUNGS, ORGAN_SLOT_APPENDIX, \
	ORGAN_SLOT_EYES, ORGAN_SLOT_EARS, ORGAN_SLOT_TONGUE, ORGAN_SLOT_LIVER, ORGAN_SLOT_STOMACH, ORGAN_SLOT_TAIL))

		var/obj/item/organ/oldorgan = C.getorganslot(slot) //used in removing
		var/obj/item/organ/neworgan = slot_mutantorgans[slot] //used in adding

		if(visual_only && !initial(neworgan.visual))
			continue

		var/used_neworgan = FALSE
		neworgan = SSwardrobe.provide_type(neworgan)
		var/should_have = neworgan.get_availability(src) //organ proc that points back to a species trait (so if the species is supposed to have this organ)

		if(oldorgan && (!should_have || replace_current))
			if(slot == ORGAN_SLOT_BRAIN)
				var/obj/item/organ/brain/brain = oldorgan
				if(!brain.decoy_override)//"Just keep it if it's fake" - confucius, probably
					brain.Remove(C, TRUE, TRUE) //brain argument used so it doesn't cause any... sudden death.
					QDEL_NULL(brain)
					oldorgan = null //now deleted
			else
				oldorgan.Remove(C,TRUE)
				QDEL_NULL(oldorgan) //we cannot just tab this out because we need to skip the deleting if it is a decoy brain.

		if(oldorgan)
			oldorgan.setOrganDamage(0)
		else if(should_have)
			if(slot == ORGAN_SLOT_TAIL)
				// Special snowflake code to handle tail appearances
				var/obj/item/organ/tail/new_tail = neworgan
				if(iscatperson(C))
					new_tail.tail_type = C.dna.features["tail_human"]
				if(ispolysmorph(C))
					new_tail.tail_type = C.dna.features["tail_polysmorph"]
				if(islizard(C))
					var/obj/item/organ/tail/lizard/new_lizard_tail = neworgan
					new_lizard_tail.tail_type = C.dna.features["tail_lizard"]
					new_lizard_tail.spines = C.dna.features["spines"]
				if(isvox(C))
					var/obj/item/organ/tail/vox/new_vox_tail = neworgan
					new_vox_tail.tail_type = C.dna.features["vox_skin_tone"]
					new_vox_tail.tail_markings = C.dna.features["vox_tail_markings"]

	// if(tail && (!should_have_tail || replace_current))
	// 	tail.Remove(C,1)
	// 	QDEL_NULL(tail)
	// if(should_have_tail && !tail)
	// 	tail = new mutanttail
	// 	if(iscatperson(C))
	// 		tail.tail_type = C.dna.features["tail_human"]
	// 	if(ispolysmorph(C))
	// 		tail.tail_type = C.dna.features["tail_polysmorph"]
	// 	if(islizard(C))
	// 		var/obj/item/organ/tail/lizard/T = tail
	// 		T.tail_type = C.dna.features["tail_lizard"]
	// 		T.spines = C.dna.features["spines"]
	// 	tail.Insert(C)
			used_neworgan = TRUE
			neworgan.Insert(C, TRUE, FALSE)

		if(!used_neworgan)
			qdel(neworgan)

	if(old_species)
		for(var/mutantorgan in old_species.mutant_organs)
			// Snowflake check. If our species share this mutant organ, let's not remove it
			// just yet as we'll be properly replacing it later.
			if(mutantorgan in mutant_organs)
				continue
			var/obj/item/organ/I = C.getorgan(mutantorgan)
			if(I)
				I.Remove(C)
				QDEL_NULL(I)

	for(var/organ_path in mutant_organs)
		var/obj/item/organ/current_organ = C.getorgan(organ_path)
		if(!current_organ || replace_current)
			var/obj/item/organ/replacement = SSwardrobe.provide_type(organ_path)
			// If there's an existing mutant organ, we're technically replacing it.
			// Let's abuse the snowflake proc that skillchips added. Basically retains
			// feature parity with every other organ too.
			//if(current_organ)
			//	current_organ.before_organ_replacement(replacement)
			// organ.Insert will qdel any current organs in that slot, so we don't need to.
			replacement.Insert(C, TRUE, FALSE)

/datum/species/proc/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	// Change the gender to fit with the new species
	if(!possible_genders || possible_genders.len < 1)
		stack_trace("[type] has no possible genders!")
		C.gender = PLURAL // uh oh
	else if(possible_genders.len == 1)
		C.gender = possible_genders[1] // some species only have one gender
	else if(!(C.gender in possible_genders))
		C.gender = pick(possible_genders) // randomized gender
	// Drop the items the new species can't wear
	extra_no_equip = old_species.extra_no_equip.Copy()
	for(var/slot_id in no_equip)
		var/obj/item/thing = C.get_item_by_slot(slot_id)
		if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
			C.dropItemToGround(thing)
	if(C.hud_used)
		C.hud_used.update_locked_slots()

	// this needs to be FIRST because qdel calls update_body which checks if we have DIGITIGRADE legs or not and if not then removes DIGITIGRADE from species_traits
	if((DIGITIGRADE in species_traits) && !(DIGITIGRADE in old_species.species_traits))
		C.digitigrade_leg_swap(FALSE)

	C.mob_biotypes = inherent_biotypes
	C.bubble_icon = bubble_icon

	regenerate_organs(C,old_species)

	if(exotic_bloodtype && C.dna.blood_type != exotic_bloodtype)
		C.dna.blood_type = get_blood_type(exotic_bloodtype)

	if(old_species.mutanthands)
		for(var/obj/item/I in C.held_items)
			if(istype(I, old_species.mutanthands))
				qdel(I)

	if(mutanthands)
		// Drop items in hands
		// If you're lucky enough to have a TRAIT_NODROP item, then it stays.
		for(var/V in C.held_items)
			var/obj/item/I = V
			if(istype(I))
				C.dropItemToGround(I)
			else	//Entries in the list should only ever be items or null, so if it's not an item, we can assume it's an empty hand
				C.put_in_hands(new mutanthands())

	if(inherent_biotypes & MOB_ROBOTIC)
		for(var/obj/item/bodypart/B in C.bodyparts)
			B.change_bodypart_status(BODYPART_ROBOTIC) // Makes all Bodyparts robotic.
			B.render_like_organic = TRUE

	if(NOMOUTH in species_traits)
		for(var/obj/item/bodypart/head/head in C.bodyparts)
			head.mouth = FALSE

	for(var/X in inherent_traits)
		ADD_TRAIT(C, X, SPECIES_TRAIT)

	if(TRAIT_VIRUSIMMUNE in inherent_traits)
		for(var/datum/disease/A in C.diseases)
			A.cure(FALSE)

	if(flying_species && isnull(fly))
		fly = new
		fly.Grant(C)

	for(var/ability_path in species_abilities)
		var/datum/action/ability = new ability_path(C)
		ability.Grant(C)
		instantiated_abilities += ability

	C.add_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE, 100, override=TRUE, multiplicative_slowdown=speedmod, movetypes=(~FLYING))
	C.regenerate_icons()
	SEND_SIGNAL(C, COMSIG_SPECIES_GAIN, src, old_species)

	if(!(C.voice_type?.can_use(id)))
		C.voice_type = get_random_valid_voice(id)

/datum/species/proc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	if(C.dna.species.exotic_bloodtype)
		C.dna.blood_type = random_blood_type()
	if((DIGITIGRADE in species_traits) && !(DIGITIGRADE in new_species.species_traits))
		C.digitigrade_leg_swap(TRUE)
	if(inherent_biotypes & MOB_ROBOTIC)
		for(var/obj/item/bodypart/B in C.bodyparts)
			B.change_bodypart_status(BODYPART_ORGANIC, FALSE, TRUE)
			B.render_like_organic = FALSE
	if(NOMOUTH in species_traits)
		for(var/obj/item/bodypart/head/head in C.bodyparts)
			head.mouth = TRUE
	for(var/X in inherent_traits)
		REMOVE_TRAIT(C, X, SPECIES_TRAIT)

	//If their inert mutation is not the same, swap it out
	if((inert_mutation != new_species.inert_mutation) && LAZYLEN(C.dna.mutation_index) && (inert_mutation in C.dna.mutation_index))
		C.dna.remove_mutation(inert_mutation)
		//keep it at the right spot, so we can't have people taking shortcuts
		var/location = C.dna.mutation_index.Find(inert_mutation)
		C.dna.mutation_index[location] = new_species.inert_mutation
		C.dna.default_mutation_genes[location] = C.dna.mutation_index[location]
		C.dna.mutation_index[new_species.inert_mutation] = create_sequence(new_species.inert_mutation)
		C.dna.default_mutation_genes[new_species.inert_mutation] = C.dna.mutation_index[new_species.inert_mutation]

	if(flying_species)
		fly.Remove(C)
		QDEL_NULL(fly)
		if(C.movement_type & FLYING)
			ToggleFlight(C)
	if(C?.dna?.species && (C.dna.features["wings"] == wings_icon))
		if("wings" in C.dna.species.mutant_bodyparts)
			C.dna.species.mutant_bodyparts -= "wings"
		C.dna.features["wings"] = "None"
		if(wings_detail && C.dna.features["wingsdetail"] == wings_detail)
			if("wingsdetail" in C.dna.species.mutant_bodyparts)
				C.dna.species.mutant_bodyparts -= "wingsdetail"
			C.dna.features["wingsdetail"] = "None"
		C.update_body()

	for(var/datum/action/ability as anything in instantiated_abilities)
		ability.Remove(C)
		instantiated_abilities -= ability
		qdel(ability)

	C.remove_movespeed_modifier(MOVESPEED_ID_SPECIES)

	SEND_SIGNAL(C, COMSIG_SPECIES_LOSS, src)

/datum/species/proc/handle_hair(mob/living/carbon/human/H, forced_colour)
	H.remove_overlay(HAIR_LAYER)
	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	if(!HD) //Decapitated
		return

	if(HAS_TRAIT(H, TRAIT_HUSK))
		return
	var/datum/sprite_accessory/S
	var/list/standing = list()

	var/hair_hidden = FALSE //ignored if the matching dynamic_X_suffix is non-empty
	var/facialhair_hidden = FALSE // ^

	var/dynamic_hair_suffix = "" //if this is non-null, and hair+suffix matches an iconstate, then we render that hair instead
	var/dynamic_fhair_suffix = ""

	//for augmented heads
	if(HD.status == BODYPART_ROBOTIC && !yogs_draw_robot_hair) //yogs - allow for robot head hair
		return

	//we check if our hat or helmet hides our facial hair.
	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_fhair_suffix = C.dynamic_fhair_suffix
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		dynamic_fhair_suffix = M.dynamic_fhair_suffix //mask > head in terms of facial hair
		if(M.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(("vox_facial_quills" in H.dna.species.mutant_bodyparts) && !facialhair_hidden)
		S = GLOB.vox_facial_quills_list[H.dna.features["vox_facial_quills"]]
		if(S)
			var/mutable_appearance/facial_quills_overlay = mutable_appearance(layer = -HAIR_LAYER, appearance_flags = KEEP_TOGETHER)
			var/mutable_appearance/facial_quills_base = mutable_appearance(S.icon, S.icon_state)
			facial_quills_base.color = forced_colour || H.facial_hair_color
			if(S.color_blend_mode == COLOR_BLEND_ADD)
				facial_quills_base.color = COLOR_MATRIX_ADD(facial_quills_base.color)
			facial_quills_overlay.overlays += facial_quills_base
			facial_quills_overlay.alpha = hair_alpha
			standing += facial_quills_overlay
	if(H.facial_hair_style && (FACEHAIR in species_traits) && (!facialhair_hidden || dynamic_fhair_suffix))
		S = GLOB.facial_hair_styles_list[H.facial_hair_style]
		if(S)

			//List of all valid dynamic_fhair_suffixes
			var/static/list/fextensions
			if(!fextensions)
				var/icon/fhair_extensions = icon('icons/mob/facialhair_extensions.dmi')
				fextensions = list()
				for(var/s in fhair_extensions.IconStates(1))
					fextensions[s] = TRUE
				qdel(fhair_extensions)

			//Is hair+dynamic_fhair_suffix a valid iconstate?
			var/fhair_state = S.icon_state
			var/fhair_file = S.icon
			if(fextensions[fhair_state+dynamic_fhair_suffix])
				fhair_state += dynamic_fhair_suffix
				fhair_file = 'icons/mob/facialhair_extensions.dmi'

			var/mutable_appearance/facial_overlay = mutable_appearance(fhair_file, fhair_state, -HAIR_LAYER)

			if(!forced_colour)
				if(hair_color)
					if(hair_color == "mutcolor")
						facial_overlay.color =  H.dna.features["mcolor"]
					else if(hair_color == "fixedmutcolor")
						facial_overlay.color = fixed_mut_color
					else
						facial_overlay.color = hair_color
				else
					facial_overlay.color = H.facial_hair_color
			else
				facial_overlay.color = forced_colour

			facial_overlay.alpha = hair_alpha

			standing += facial_overlay

	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		if(!dynamic_hair_suffix) //head > mask in terms of head hair
			dynamic_hair_suffix = M.dynamic_hair_suffix
		if(M.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(!hair_hidden || dynamic_hair_suffix)
		var/mutable_appearance/hair_overlay = mutable_appearance(layer = -HAIR_LAYER)
		var/mutable_appearance/gradient_overlay = mutable_appearance(layer = -HAIR_LAYER)
		if(!hair_hidden && !H.getorgan(/obj/item/organ/brain)) //Applies the debrained overlay if there is no brain
			if(!(NOBLOOD in species_traits))
				hair_overlay.icon = 'icons/mob/human_face.dmi'
				hair_overlay.icon_state = "debrained"

		else if(H.hair_style && (HAIR in species_traits))
			S = GLOB.hair_styles_list[H.hair_style]
			if(S)

				//List of all valid dynamic_hair_suffixes
				var/static/list/extensions
				if(!extensions)
					var/icon/hair_extensions = icon('icons/mob/hair_extensions.dmi') //hehe
					extensions = list()
					for(var/s in hair_extensions.IconStates(1))
						extensions[s] = TRUE
					qdel(hair_extensions)

				//Is hair+dynamic_hair_suffix a valid iconstate?
				var/hair_state = S.icon_state
				var/hair_file = S.icon
				if(extensions[hair_state+dynamic_hair_suffix])
					hair_state += dynamic_hair_suffix
					hair_file = 'icons/mob/hair_extensions.dmi'

				hair_overlay.icon = hair_file
				hair_overlay.icon_state = hair_state

				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							hair_overlay.color =  H.dna.features["mcolor"]
						else if(hair_color == "fixedmutcolor")
							hair_overlay.color = fixed_mut_color
						else
							hair_overlay.color = hair_color
					else
						hair_overlay.color = H.hair_color

					//Gradients
					grad_style = H.grad_style
					grad_color = H.grad_color
					if(grad_style)
						var/datum/sprite_accessory/gradient = GLOB.hair_gradients_list[grad_style]
						var/icon/temp = icon(gradient.icon, gradient.icon_state)
						var/icon/temp_hair = icon(hair_file, hair_state)
						temp.Blend(temp_hair, ICON_ADD)
						gradient_overlay.icon = temp
						gradient_overlay.color = grad_color

				else
					hair_overlay.color = forced_colour

				hair_overlay.alpha = hair_alpha
				if(OFFSET_FACE in H.dna.species.offset_features)
					hair_overlay.pixel_x += H.dna.species.offset_features[OFFSET_FACE][1]
					hair_overlay.pixel_y += H.dna.species.offset_features[OFFSET_FACE][2]
		if(hair_overlay.icon)
			standing += hair_overlay
			standing += gradient_overlay
		if("pod_hair" in H.dna.species.mutant_bodyparts)
		//alright bear with me for a second while i explain this awful code since it was literally 3 days of me bumbling through blind
		//for hair code to work, you need to start by removing the layer, as in the beginning with remove_overlay(head), then you need to use a mutable appearance variable
		//the mutable appearance will store the sprite file dmi, the name of the sprite (icon_state), and the layer this will go on (in this case HAIR_LAYER)
		//those are the basic variables, then you color the sprite with whatever source color you're using and set the alpha. from there it's added to the "standing" list
		//which is storing all the individual mutable_appearance variables (each one is a sprite), and then standing is loaded into the H.overlays_standing and finalized
		//with apply_overlays.
		//if you're working with sprite code i hope this helps because i wish i was dead now.
			S = GLOB.pod_hair_list[H.dna.features["pod_hair"]]
			if(S)
				if(ReadHSV(RGBtoHSV(H.hair_color))[3] <= ReadHSV("#777777")[3])
					H.hair_color = H.dna.species.default_color
				var/hair_state = S.icon_state
				var/hair_file = S.icon
				hair_overlay.icon = hair_file
				hair_overlay.icon_state = hair_state
				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							hair_overlay.color = H.dna.features["mcolor"]
						else if(hair_color == "fixedmutcolor")
							hair_overlay.color = fixed_mut_color
						else
							hair_overlay.color = hair_color
					else
						hair_overlay.color = H.hair_color
				hair_overlay.alpha = hair_alpha
				standing+=hair_overlay
			//var/mutable_appearance/pod_flower = mutable_appearance(GLOB.pod_flower_list[H.dna.features["pod_flower"]].icon, GLOB.pod_flower_list[H.dna.features["pod_flower"]].icon_state, -HAIR_LAYER)
				S = GLOB.pod_flower_list[H.dna.features["pod_flower"]]
				if(S)
					var/flower_state = S.icon_state
					var/flower_file = S.icon
					// flower_overlay.icon = flower_file
					// flower_overlay.icon_state = flower_state
					var/mutable_appearance/flower_overlay = mutable_appearance(flower_file, flower_state, -HAIR_LAYER)
					if(!forced_colour)
						if(hair_color)
							if(hair_color == "mutcolor")
								flower_overlay.color = H.dna.features["mcolor"]
							else if(hair_color == "fixedmutcolor")
								flower_overlay.color = fixed_mut_color
							else
								flower_overlay.color = hair_color
						else
							flower_overlay.color = H.facial_hair_color
					flower_overlay.alpha = hair_alpha
					standing += flower_overlay
		if(("vox_quills" in H.dna.species.mutant_bodyparts) && !hair_hidden)
			S = GLOB.vox_quills_list[H.dna.features["vox_quills"]]
			if(S)
				var/mutable_appearance/quills_overlay = mutable_appearance(layer = -HAIR_LAYER, appearance_flags = KEEP_TOGETHER)
				var/mutable_appearance/quills_base = mutable_appearance(S.icon, S.icon_state)
				quills_base.color = forced_colour || H.hair_color
				if(S.color_blend_mode == COLOR_BLEND_ADD)
					quills_base.color = COLOR_MATRIX_ADD(quills_base.color)
				quills_overlay.overlays += quills_base
				//Gradients
				grad_style = H.grad_style
				grad_color = H.grad_color
				if(grad_style)
					var/datum/sprite_accessory/gradient = GLOB.hair_gradients_list[grad_style]
					var/mutable_appearance/gradient_quills = mutable_appearance(gradient.icon, gradient.icon_state)
					gradient_quills.color = COLOR_MATRIX_OVERLAY(grad_color)
					gradient_quills.blend_mode = BLEND_INSET_OVERLAY
					quills_overlay.overlays += gradient_quills
				quills_overlay.alpha = hair_alpha
				standing += quills_overlay
	if(standing.len)
		H.overlays_standing[HAIR_LAYER] = standing

	H.apply_overlay(HAIR_LAYER)

/datum/species/proc/handle_body(mob/living/carbon/human/H)
	H.remove_overlay(BODY_LAYER)

	var/list/standing = list()

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)

	if(HD && !(HAS_TRAIT(H, TRAIT_HUSK)))
		// lipstick
		if(H.lip_style && (LIPS in species_traits))
			var/mutable_appearance/lip_overlay = mutable_appearance('icons/mob/human_face.dmi', "lips_[H.lip_style]", -BODY_LAYER)
			lip_overlay.color = H.lip_color
			if(OFFSET_FACE in H.dna.species.offset_features)
				lip_overlay.pixel_x += H.dna.species.offset_features[OFFSET_FACE][1]
				lip_overlay.pixel_y += H.dna.species.offset_features[OFFSET_FACE][2]
			standing += lip_overlay

#define OFFSET_X 1
#define OFFSET_Y 2
		// eyes
		if(!(NOEYESPRITES in species_traits))
			var/obj/item/organ/eyes/parent_eyes = H.getorganslot(ORGAN_SLOT_EYES)
			var/mutable_appearance/eye_overlay
			if(parent_eyes)
				eye_overlay += parent_eyes.generate_body_overlay(H)
			else
				var/mutable_appearance/missing_eyes = mutable_appearance(HD.eyes_icon, "eyes_missing", -BODY_LAYER)
				if(OFFSET_FACE in offset_features)
					missing_eyes.pixel_x += offset_features[OFFSET_FACE][1]
					missing_eyes.pixel_y += offset_features[OFFSET_FACE][2]
				eye_overlay += missing_eyes
			standing += eye_overlay
#undef OFFSET_X
#undef OFFSET_Y

	//Underwear, Undershirts & Socks
	if(!(NO_UNDERWEAR in species_traits))
		if(H.underwear)
			var/datum/sprite_accessory/underwear/underwear = GLOB.underwear_list[H.underwear]
			if(underwear)
				if(HAS_TRAIT(H, TRAIT_SKINNY))
					standing += wear_skinny_version(underwear.icon_state, underwear.icon, BODY_LAYER) //Neat, this works
				else
					var/mutable_appearance/underwear_overlay = mutable_appearance(underwear.icon, underwear.icon_state, -BODY_LAYER)
					if(H.dna.species.id in underwear.sprite_sheets)
						if(icon_exists(underwear.sprite_sheets[H.dna.species.id], underwear.icon_state))
							underwear_overlay.icon = underwear.sprite_sheets[H.dna.species.id]
					standing += underwear_overlay

		if(H.undershirt)
			var/datum/sprite_accessory/undershirt/undershirt = GLOB.undershirt_list[H.undershirt]
			if(undershirt)
				if(HAS_TRAIT(H, TRAIT_SKINNY)) //Check for skinny first
					standing += wear_skinny_version(undershirt.icon_state, undershirt.icon, BODY_LAYER)
				else if((H.gender == FEMALE && (FEMALE in possible_genders)) && H.dna.species.is_dimorphic)
					standing += wear_female_version(undershirt.icon_state, undershirt.icon, BODY_LAYER)
				else
					var/mutable_appearance/undershirt_overlay = mutable_appearance(undershirt.icon, undershirt.icon_state, -BODY_LAYER)
					if(H.dna.species.id in undershirt.sprite_sheets)
						if(icon_exists(undershirt.sprite_sheets[H.dna.species.id], undershirt.icon_state))
							undershirt_overlay.icon = undershirt.sprite_sheets[H.dna.species.id]
					standing += undershirt_overlay

		if(H.socks && H.get_num_legs(FALSE) >= 2 && !(DIGITIGRADE in species_traits))
			var/datum/sprite_accessory/socks/socks = GLOB.socks_list[H.socks]
			if(socks)
				var/mutable_appearance/socks_overlay = mutable_appearance(socks.icon, socks.icon_state, -BODY_LAYER)
				if(H.dna.species.id in socks.sprite_sheets)
					if(icon_exists(socks.sprite_sheets[H.dna.species.id], socks.icon_state))
						socks_overlay.icon = socks.sprite_sheets[H.dna.species.id]
				standing += socks_overlay

	if(standing.len)
		H.overlays_standing[BODY_LAYER] = standing

	H.apply_overlay(BODY_LAYER)
	handle_mutant_bodyparts(H)

/datum/species/proc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/list/standing	= list()

	H.remove_overlay(BODY_BEHIND_LAYER)
	H.remove_overlay(BODY_ADJ_LAYER)
	H.remove_overlay(BODY_FRONT_LAYER)

	if(!mutant_bodyparts)
		return

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)

	if("tail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_lizard"

	if("waggingtail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_lizard"
		else if ("tail_lizard" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_lizard"

	if("tail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_human"


	if("waggingtail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_human"
		else if ("tail_human" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_human"

	if("tail_polysmorph" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_polysmorph"

	if("spines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "spines"

	if("waggingspines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingspines"
		else if ("tail" in mutant_bodyparts)
			bodyparts_to_add -= "waggingspines"

	if("snout" in mutant_bodyparts) //Take a closer look at that snout!
		if((H.wear_mask && !(H.wear_mask.mutantrace_variation & DIGITIGRADE_VARIATION) && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "snout"

	if("frills" in mutant_bodyparts)
		if(!H.dna.features["frills"] || H.dna.features["frills"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "frills"

	if("horns" in mutant_bodyparts)
		if(!H.dna.features["horns"] || H.dna.features["horns"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "horns"

	if("ears" in mutant_bodyparts)
		if(!H.dna.features["ears"] || H.dna.features["ears"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "ears"

	if("wings" in mutant_bodyparts)
		if(!H.dna.features["wings"] || H.dna.features["wings"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))
			bodyparts_to_add -= "wings"

	if("wings_open" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception)))
			bodyparts_to_add -= "wings_open"
		else if ("wings" in mutant_bodyparts)
			bodyparts_to_add -= "wings_open"

	if("wingsdetail" in mutant_bodyparts)
		if(!H.dna.features["wingsdetail"] || H.dna.features["wingsdetail"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))
			bodyparts_to_add -= "wingsdetail"

	if("wingsdetail_open" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception)))
			bodyparts_to_add -= "wingsdetail_open"
		else if ("wingsdetail" in mutant_bodyparts)
			bodyparts_to_add -= "wingsdetail_open"

	if("ipc_screen" in mutant_bodyparts)
		if(!H.dna.features["ipc_screen"] || H.dna.features["ipc_screen"] == "None" || (H.wear_mask && (H.wear_mask.flags_inv & HIDEEYES)) || !HD)
			bodyparts_to_add -= "ipc_screen"

	if("ipc_antenna" in mutant_bodyparts)
		if(!H.dna.features["ipc_antenna"] || H.dna.features["ipc_antenna"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "ipc_antenna"

	if("teeth" in mutant_bodyparts)
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "teeth"

	if("dome" in mutant_bodyparts)
		if(!H.dna.features["dome"] || H.dna.features["dome"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "dome"

	if("ethereal_mark" in mutant_bodyparts)
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEEYES)) || (H.head && (H.head.flags_inv & HIDEEYES)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "ethereal_mark"

	if("preternis_antenna" in mutant_bodyparts)
		if(H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "preternis_antenna"

	if("preternis_eye" in mutant_bodyparts)
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEEYES)) || (H.head && (H.head.flags_inv & HIDEEYES)) || !HD)
			bodyparts_to_add -= "preternis_eye"


	if("preternis_core" in mutant_bodyparts)
		if(!get_location_accessible(H, BODY_ZONE_CHEST))
			bodyparts_to_add -= "preternis_core"
	if("pod_hair" in mutant_bodyparts)
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || (H.head && (H.head.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "pod_hair"

	if("pod_flower" in mutant_bodyparts)
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || (H.head && (H.head.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "pod_flower"
		if(H.dna.features["pod_flower"] != H.dna.features["pod_hair"])
			H.dna.features["pod_flower"] = H.dna.features["pod_hair"]

	if("vox_tail" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "vox_tail"
	
	if("wagging_vox_tail" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "wagging_vox_tail"
		else if ("vox_tail" in mutant_bodyparts)
			bodyparts_to_add -= "wagging_vox_tail"

	if("vox_tail_markings" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "vox_tail_markings"

	if("wagging_vox_tail_markings" in mutant_bodyparts)
		if(!H.dna.features["vox_tail_markings"] || H.dna.features["vox_tail_markings"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "vox_tail_markings"
		else if ("vox_tail" in mutant_bodyparts)
			bodyparts_to_add -= "wagging_vox_tail_markings"

	if(!bodyparts_to_add)
		return

	var/g = (H.gender == FEMALE) ? "f" : "m"

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/S
			switch(bodypart)
				if("tail_lizard")
					S = GLOB.tails_list_lizard[H.dna.features["tail_lizard"]]
				if("waggingtail_lizard")
					S = GLOB.animated_tails_list_lizard[H.dna.features["tail_lizard"]]
				if("tail_human")
					S = GLOB.tails_list_human[H.dna.features["tail_human"]]
				if("tail_polysmorph")
					S = GLOB.tails_list_polysmorph[H.dna.features["tail_polysmorph"]]
				if("waggingtail_human")
					S = GLOB.animated_tails_list_human[H.dna.features["tail_human"]]
				if("spines")
					S = GLOB.spines_list[H.dna.features["spines"]]
				if("waggingspines")
					S = GLOB.animated_spines_list[H.dna.features["spines"]]
				if("snout")
					S = GLOB.snouts_list[H.dna.features["snout"]]
				if("frills")
					S = GLOB.frills_list[H.dna.features["frills"]]
				if("horns")
					S = GLOB.horns_list[H.dna.features["horns"]]
				if("ears")
					S = GLOB.ears_list[H.dna.features["ears"]]
				if("body_markings")
					S = GLOB.body_markings_list[H.dna.features["body_markings"]]
				if("wings")
					S = GLOB.wings_list[H.dna.features["wings"]]
				if("wingsopen")
					S = GLOB.wings_open_list[H.dna.features["wings"]]
				if("wingsdetail")
					S = GLOB.wings_list[H.dna.features["wingsdetail"]]
				if("wingsdetailopen")
					S = GLOB.wings_open_list[H.dna.features["wingsdetail"]]
				if("moth_wings")
					S = GLOB.moth_wings_list[H.dna.features["moth_wings"]]
				if("moth_wingsopen")
					S = GLOB.moth_wingsopen_list[H.dna.features["moth_wings"]]
				if("caps")
					S = GLOB.caps_list[H.dna.features["caps"]]
				if("teeth")
					S = GLOB.teeth_list[H.dna.features["teeth"]]
				if("dome")
					S = GLOB.dome_list[H.dna.features["dome"]]
				if("dorsal_tubes")
					S = GLOB.dorsal_tubes_list[H.dna.features["dorsal_tubes"]]
				if("ethereal_mark")
					S = GLOB.ethereal_mark_list[H.dna.features["ethereal_mark"]]
				if("preternis_weathering")
					S = GLOB.preternis_weathering_list[H.dna.features["preternis_weathering"]]
				if("preternis_antenna")
					S = GLOB.preternis_antenna_list[H.dna.features["preternis_antenna"]]
				if("preternis_eye")
					S = GLOB.preternis_eye_list[H.dna.features["preternis_eye"]]
				if("preternis_core")
					S = GLOB.preternis_core_list[H.dna.features["preternis_core"]]
				if("ipc_screen")
					S = GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]
				if("ipc_antenna")
					S = GLOB.ipc_antennas_list[H.dna.features["ipc_antenna"]]
				if("ipc_chassis")
					S = GLOB.ipc_chassis_list[H.dna.features["ipc_chassis"]]
				if("vox_tail")
					var/obj/item/organ/tail/vox/vox_tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(vox_tail && istype(vox_tail))
						S = GLOB.vox_tails_list[vox_tail.tail_type]
				if("wagging_vox_tail")
					var/obj/item/organ/tail/vox/vox_tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(vox_tail && istype(vox_tail))
						S = GLOB.animated_vox_tails_list[vox_tail.tail_type]
				if("vox_body_markings")
					S = GLOB.vox_body_markings_list[H.dna.features["vox_body_markings"]]
				if("vox_tail_markings")
					var/obj/item/organ/tail/vox/vox_tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(vox_tail && istype(vox_tail))
						S = GLOB.vox_tail_markings_list[vox_tail.tail_markings]
				if("wagging_vox_tail_markings")
					var/obj/item/organ/tail/vox/vox_tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(vox_tail && istype(vox_tail))
						S = GLOB.animated_vox_tail_markings_list[vox_tail.tail_markings]
			if(!S || S.icon_state == "none")
				continue

			var/mutable_appearance/accessory_overlay = mutable_appearance(S.icon, layer = -layer)

			//A little rename so we don't have to use tail_lizard or tail_human when naming the sprites.
			if(bodypart == "tail_lizard" || bodypart == "tail_human" || bodypart == "tail_polysmorph" || bodypart == "vox_tail")
				bodypart = "tail"
			else if(bodypart == "waggingtail_lizard" || bodypart == "waggingtail_human" || bodypart == "wagging_vox_tail")
				bodypart = "waggingtail"

			if(S.gender_specific)
				accessory_overlay.icon_state = "[g]_[bodypart]_[S.icon_state]_[layertext]"
			else
				accessory_overlay.icon_state = "m_[bodypart]_[S.icon_state]_[layertext]"

			if(S.center)
				accessory_overlay = center_image(accessory_overlay, S.dimension_x, S.dimension_y)

			if(!(HAS_TRAIT(H, TRAIT_HUSK)))
				if(!forced_colour)
					switch(S.color_src)
						if(MUTCOLORS)
							if(H.dna.check_mutation(HULK))			//HULK GO FIRST
								accessory_overlay.color = "#00aa00"
							else if(fixed_mut_color)													//Then fixed color if applicable
								accessory_overlay.color = fixed_mut_color
							else																		//Then snowflake color
								accessory_overlay.color = H.dna.features["mcolor"]
						if(MUTCOLORS_SECONDARY)
							if(fixed_mut_color)
								accessory_overlay.color = fixed_mut_color
							else
								accessory_overlay.color = H.dna.features["mcolor_secondary"]
						if(HAIR)
							if(hair_color == "mutcolor")
								accessory_overlay.color = H.dna.features["mcolor"]
							else if(hair_color == "fixedmutcolor")
								accessory_overlay.color = fixed_mut_color
							else
								accessory_overlay.color = H.hair_color
						if(FACEHAIR)
							accessory_overlay.color = H.facial_hair_color
						if(EYECOLOR)
							accessory_overlay.color = H.eye_color
				else
					accessory_overlay.color = forced_colour
			if(S.color_blend_mode == COLOR_BLEND_ADD)
				accessory_overlay.color = COLOR_MATRIX_ADD(accessory_overlay.color)
			standing += accessory_overlay

			if(S.emissive && !(HAS_TRAIT(H, TRAIT_HUSK)) && !istype(H, /mob/living/carbon/human/dummy))//don't put emissives on dummy mobs as they're used for the preference menu, which doesn't draw emissives properly
				var/mutable_appearance/emissive_accessory_overlay = emissive_appearance(S.icon, "placeholder", H)

				//A little rename so we don't have to use tail_lizard or tail_human when naming the sprites.
				if(S.gender_specific)
					emissive_accessory_overlay.icon_state = "[g]_[bodypart]_[S.icon_state]_[layertext]"
				else
					emissive_accessory_overlay.icon_state = "m_[bodypart]_[S.icon_state]_[layertext]"

				if(S.center)
					emissive_accessory_overlay = center_image(emissive_accessory_overlay, S.dimension_x, S.dimension_y)

				if(!forced_colour)
					switch(S.color_src)
						if(MUTCOLORS)
							if(H.dna.check_mutation(HULK))			//HULK GO FIRST
								emissive_accessory_overlay.color = "#00aa00"
							else if(fixed_mut_color)													//Then fixed color if applicable
								emissive_accessory_overlay.color = fixed_mut_color
							else																		//Then snowflake color
								emissive_accessory_overlay.color = H.dna.features["mcolor"]
						if(HAIR)
							if(hair_color == "mutcolor")
								emissive_accessory_overlay.color = H.dna.features["mcolor"]
							else if(hair_color == "fixedmutcolor")
								emissive_accessory_overlay.color = fixed_mut_color
							else
								emissive_accessory_overlay.color = H.hair_color
						if(FACEHAIR)
							emissive_accessory_overlay.color = H.facial_hair_color
						if(EYECOLOR)
							emissive_accessory_overlay.color = H.eye_color
				else
					emissive_accessory_overlay.color = forced_colour
				standing += emissive_accessory_overlay

			if(length(S.body_slots) || length(S.external_slots))
				standing += return_accessory_layer(layer, S, H, accessory_overlay.color)
			if(S.hasinner)
				var/mutable_appearance/inner_accessory_overlay = mutable_appearance(S.icon, layer = -layer)
				if(S.gender_specific)
					inner_accessory_overlay.icon_state = "[g]_[bodypart]inner_[S.icon_state]_[layertext]"
				else
					inner_accessory_overlay.icon_state = "m_[bodypart]inner_[S.icon_state]_[layertext]"

				if(S.center)
					inner_accessory_overlay = center_image(inner_accessory_overlay, S.dimension_x, S.dimension_y)

				standing += inner_accessory_overlay
			if(HAS_TRAIT(H, TRAIT_HUSK))
				for(var/image/sprite_image as anything in standing)
					huskify_image(sprite_image, H, draw_blood = FALSE)
					sprite_image.color = H.dna.species.husk_color
		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(BODY_BEHIND_LAYER)
	H.apply_overlay(BODY_ADJ_LAYER)
	H.apply_overlay(BODY_FRONT_LAYER)

//This exists so sprite accessories can still be per-layer without having to include that layer's
//number in their sprite name, which causes issues when those numbers change.
/datum/species/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_FRONT_LAYER)
			return "FRONT"

/datum/species/proc/spec_life(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		H.setOxyLoss(0)
		H.losebreath = 0

		var/takes_crit_damage = (!HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		if((H.health < H.crit_threshold) && takes_crit_damage)
			H.adjustBruteLoss(1)
	if(flying_species)
		HandleFlight(H)

//I wag in death
/datum/species/proc/spec_death(gibbed, mob/living/carbon/human/H)
	stop_wagging_tail(H)
	return

//Now checks if the item is already equipped to that slot before instantly returning false because of it being there, so you can now check if an item is able to remain in a slot
/datum/species/proc/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if((slot in no_equip) || ("[slot]" in extra_no_equip))
		if(!I.species_exception || !is_type_in_list(src, I.species_exception))
			return FALSE

	var/num_arms = H.get_num_arms(FALSE)
	var/num_legs = H.get_num_legs(FALSE)

	switch(slot)
		if(ITEM_SLOT_HANDS)
			if(H.get_empty_held_indexes())
				return TRUE
			return FALSE
		if(ITEM_SLOT_MASK)
			if(H.wear_mask && H.wear_mask != I)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_MASK))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_NECK)
			if(H.wear_neck && H.wear_neck != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_NECK) )
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACK)
			if(H.back && H.back != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_BACK) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_OCLOTHING)
			if(H.wear_suit && H.wear_suit != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_OCLOTHING) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_GLOVES)
			if(H.gloves && H.gloves != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_GLOVES) )
				return FALSE
			if(num_arms < 2)
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_FEET)
			if(H.shoes && H.shoes != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_FEET) )
				return FALSE
			if(num_legs < 2)
				return FALSE
			var/obj/item/clothing/shoes/S = I
			if(istype(S) && (HAS_TRAIT(H, TRAIT_DIGITIGRADE) ? S.xenoshoe == NO_DIGIT : S.xenoshoe == YES_DIGIT)) // Checks leg compatibilty with shoe digitigrade or not flag
				if(!disable_warning)
					to_chat(H, span_warning("This footwear isn't compatible with your feet!"))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_BELT)
			if(H.belt && H.belt != I)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_CHEST)

			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, span_warning("You need a jumpsuit before you can attach this [I.name]!"))
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_BELT))
				return
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_EYES)
			if(H.glasses && H.glasses != I)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_EYES))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)
			if(E?.no_glasses)
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_HEAD)
			if(H.head && H.head != I)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_HEAD))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_EARS)
			if(H.ears && H.ears != I)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_EARS))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_ICLOTHING)
			if(H.w_uniform && H.w_uniform != I)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_ICLOTHING) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_ID)
			if(H.wear_id && H.wear_id != I)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_CHEST)
			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, span_warning("You need a jumpsuit before you can attach this [I.name]!"))
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_ID) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(ITEM_SLOT_LPOCKET)
			if(HAS_TRAIT(I, TRAIT_NODROP)) //Pockets aren't visible, so you can't move TRAIT_NODROP items into them.
				return FALSE
			if(H.l_store && H.l_store != I)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_L_LEG)

			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, span_warning("You need a jumpsuit before you can attach this [I.name]!"))
				return FALSE
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & ITEM_SLOT_POCKETS) )
				return TRUE
		if(ITEM_SLOT_RPOCKET)
			if(HAS_TRAIT(I, TRAIT_NODROP))
				return FALSE
			if(H.r_store && H.r_store != I)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_LEG)

			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, span_warning("You need a jumpsuit before you can attach this [I.name]!"))
				return FALSE
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & ITEM_SLOT_POCKETS) )
				return TRUE
			return FALSE
		if(ITEM_SLOT_SUITSTORE)
			if(HAS_TRAIT(I, TRAIT_NODROP))
				return FALSE
			if(H.s_store && H.s_store != I)
				return FALSE
			if(!H.wear_suit)
				if(!disable_warning)
					to_chat(H, span_warning("You need a suit before you can attach this [I.name]!"))
				return FALSE
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(H, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
				return FALSE
			if(I.w_class > WEIGHT_CLASS_BULKY)
				if(!disable_warning)
					to_chat(H, "The [I.name] is too big to attach.") //should be src?
				return FALSE
			if( istype(I, /obj/item/modular_computer/tablet/pda) || istype(I, /obj/item/pen) || is_type_in_list(I, H.wear_suit.allowed) )
				return TRUE
			return FALSE
		if(ITEM_SLOT_HANDCUFFED)
			if(H.handcuffed && H.handcuffed != I)
				return FALSE
			if(!istype(I, /obj/item/restraints/handcuffs))
				return FALSE
			if(num_arms < 2)
				return FALSE
			return TRUE
		if(ITEM_SLOT_LEGCUFFED)
			if(H.legcuffed && H.legcuffed != I)
				return FALSE
			if(!istype(I, /obj/item/restraints/legcuffs))
				return FALSE
			if(num_legs < 2)
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACKPACK)
			if(H.back && H.back != I)
				if(SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			return FALSE
	return FALSE //Unsupported slot

/datum/species/proc/equip_delay_self_check(obj/item/I, mob/living/carbon/human/H, bypass_equip_delay_self)
	if(!I.equip_delay_self || bypass_equip_delay_self)
		return TRUE
	H.visible_message(span_notice("[H] start putting on [I]..."), span_notice("You start putting on [I]..."))
	return do_after(H, I.equip_delay_self, H)

/datum/species/proc/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	return

/datum/species/proc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.update_mutant_bodyparts()

// Do species-specific reagent handling here
// Return 1 if it should do normal processing too
// Return 0 if it shouldn't deplete and do its normal effect
// Other return values will cause weird badness
/datum/species/proc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == exotic_blood)
		H.blood_volume = min(H.blood_volume + round(chem.volume, 0.1), BLOOD_VOLUME_MAXIMUM(H))
		H.reagents.del_reagent(chem.type)
		return TRUE
	//This handles dumping unprocessable reagents.
	if(!(chem.compatible_biotypes & H.mob_biotypes))
		chem.holder.remove_reagent(chem.type, chem.metabolization_rate)
		return TRUE
	return FALSE

/datum/species/proc/check_species_weakness(obj/item, mob/living/attacker)
	return 0 //This is not a boolean, it's the multiplier for the damage that the user takes from the item.It is added onto the check_weakness value of the mob, and then the force of the item is multiplied by this value

	////////
	//LIFE//
	////////

/datum/species/proc/handle_digestion(mob/living/carbon/human/H)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return //hunger is for BABIES

	//The fucking TRAIT_FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(HAS_TRAIT(H, TRAIT_FAT))//I share your pain, past coder.
		if(H.overeatduration < 100)
			to_chat(H, span_notice("You feel fit again!"))
			REMOVE_TRAIT(H, TRAIT_FAT, OBESITY)
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()
	else if(!HAS_TRAIT(H, TRAIT_POWERHUNGRY)) // why would you get fat if you run on electricity
		if(H.overeatduration >= 100)
			to_chat(H, span_danger("You suddenly feel blubbery!"))
			ADD_TRAIT(H, TRAIT_FAT, OBESITY)
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()

	// nutrition decrease and satiety
	if (H.nutrition > 0 && H.stat != DEAD && !HAS_TRAIT(H, TRAIT_NOHUNGER))
		// THEY HUNGER
		var/hunger_rate = HUNGER_FACTOR
		var/datum/component/mood/mood = H.GetComponent(/datum/component/mood)
		if(mood && mood.sanity > SANITY_DISTURBED)
			hunger_rate *= max(0.5, 1 - 0.002 * mood.sanity) //0.85 to 0.75
		if(HAS_TRAIT(H, TRAIT_EAT_LESS))
			hunger_rate *= 0.75 //hunger rate reduced by about 25%
		if(HAS_TRAIT(H, TRAIT_EAT_MORE))
			hunger_rate *= 3 //hunger rate tripled
		if(HAS_TRAIT(H, TRAIT_BOTTOMLESS_STOMACH))
			H.nutrition = min(H.nutrition, NUTRITION_LEVEL_MOSTLY_FULL) //capped, can never be truly full
		// Whether we cap off our satiety or move it towards 0
		if(H.satiety > MAX_SATIETY)
			H.satiety = MAX_SATIETY
		else if(H.satiety > 0)
			H.satiety--
		else if(H.satiety < -MAX_SATIETY)
			H.satiety = -MAX_SATIETY
		else if(H.satiety < 0)
			H.satiety++
			if(prob(round(-H.satiety/40)))
				H.adjust_jitter(5 SECONDS)
			hunger_rate = 3 * HUNGER_FACTOR
		hunger_rate *= H.physiology.hunger_mod
		H.adjust_nutrition(-hunger_rate)


	if (H.nutrition > NUTRITION_LEVEL_FULL)
		if(H.overeatduration < 600) //capped so people don't take forever to unfat
			H.overeatduration++
	else
		if(H.overeatduration > 1)
			H.overeatduration -= 2 //doubled the unfat rate

	//metabolism change
	if(H.nutrition > NUTRITION_LEVEL_FAT)
		H.metabolism_efficiency = 1
	else if(H.nutrition > NUTRITION_LEVEL_FED && H.satiety > 80)
		if(H.metabolism_efficiency != 1.25 && !HAS_TRAIT(H, TRAIT_NOHUNGER))
			to_chat(H, span_notice("You feel vigorous."))
			H.metabolism_efficiency = 1.25
	else if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if(H.metabolism_efficiency != 0.8)
			to_chat(H, span_notice("You feel sluggish."))
		H.metabolism_efficiency = 0.8
	else
		if(H.metabolism_efficiency == 1.25)
			to_chat(H, span_notice("You no longer feel vigorous."))
		H.metabolism_efficiency = 1

	get_hunger_alert(H)

/datum/species/proc/get_hunger_alert(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_POWERHUNGRY))
		var/obj/item/organ/cell = H.getorganslot(ORGAN_SLOT_STOMACH)
		if(!(cell && istype(cell, /obj/item/organ/stomach/cell)))
			H.throw_alert("nutrition", /atom/movable/screen/alert/nocell)
			return
		switch(H.nutrition)
			if(NUTRITION_LEVEL_FED to INFINITY)
				H.clear_alert("nutrition")
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				H.throw_alert("nutrition", /atom/movable/screen/alert/lowcell, 1)
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				H.throw_alert("nutrition", /atom/movable/screen/alert/lowcell, 2)
			if(1 to NUTRITION_LEVEL_STARVING)
				H.throw_alert("nutrition", /atom/movable/screen/alert/lowcell, 3)
			if(0)
				H.throw_alert("nutrition", /atom/movable/screen/alert/emptycell)
		return
	switch(H.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			H.throw_alert("nutrition", /atom/movable/screen/alert/fat)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FULL)
			H.clear_alert("nutrition")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			H.throw_alert("nutrition", /atom/movable/screen/alert/hungry)
		if(0 to NUTRITION_LEVEL_STARVING)
			H.throw_alert("nutrition", /atom/movable/screen/alert/starving)

/datum/species/proc/update_health_hud(mob/living/carbon/human/H)
	return 0

/datum/species/proc/handle_mutations_and_radiation(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_RADIMMUNE))
		H.radiation = 0
		return TRUE

	. = FALSE
	var/radiation = H.radiation

	if(radiation > RAD_MOB_KNOCKDOWN && prob(RAD_MOB_KNOCKDOWN_PROB))
		if(!H.IsParalyzed())
			H.emote("collapse")
		H.Paralyze(RAD_MOB_KNOCKDOWN_AMOUNT)
		to_chat(H, span_danger("You feel weak."))

	if(radiation > RAD_MOB_VOMIT && prob(RAD_MOB_VOMIT_PROB))
		H.vomit(10, TRUE)

	if(radiation > RAD_MOB_MUTATE)
		if(prob(1))
			to_chat(H, span_danger("You mutate!"))
			H.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
			H.emote("gasp")
			H.domutcheck()

	if(radiation > RAD_MOB_HAIRLOSS)
		if(prob(15) && !(H.hair_style == "Bald") && (HAIR in species_traits))
			to_chat(H, span_danger("Your hair starts to fall out in clumps..."))
			addtimer(CALLBACK(src, PROC_REF(go_bald), H), 50)

/datum/species/proc/go_bald(mob/living/carbon/human/H)
	if(QDELETED(H))	//may be called from a timer
		return
	H.facial_hair_style = "Shaved"
	H.hair_style = "Bald"
	H.update_hair()

////////////////
// MOVE SPEED //
////////////////

/datum/species/proc/movement_delay(mob/living/carbon/human/H)
	. = 0	//We start at 0.
	var/flight = 0	//Check for flight and flying items
	var/gravity = H.has_gravity()
	if(H.movement_type & FLYING)
		flight = 1

	if(!HAS_TRAIT(H, TRAIT_IGNORESLOWDOWN) && gravity)
		// Clothing slowdown
		if(H.wear_suit)
			. += H.wear_suit.slowdown
		if(H.shoes)
			. += H.shoes.slowdown
		if(H.back)
			. += H.back.slowdown
		if(H.head)
			. += H.head.slowdown
		for(var/obj/item/I in H.held_items)
			if(I.item_flags & SLOWS_WHILE_IN_HAND)
				. += I.slowdown
		if(!HAS_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN))
			var/health_deficiency = max(H.maxHealth - H.health, min(H.staminaloss, H.maxHealth))
			if(HAS_TRAIT(H, TRAIT_REDUCED_DAMAGE_SLOWDOWN))
				health_deficiency -= H.maxHealth * 0.2 //20% more damage required for slowdown
			if(health_deficiency >= H.maxHealth * 0.4)
				if(HAS_TRAIT(H, TRAIT_RESISTDAMAGESLOWDOWN))
					health_deficiency *= 0.5
				if(HAS_TRAIT(H, TRAIT_HIGHRESISTDAMAGESLOWDOWN))
					health_deficiency *= 0.25
				if(flight)
					health_deficiency *= 0.333
				if(health_deficiency < 100) // https://i.imgur.com/W4nusN8.png https://www.desmos.com/calculator/qsf6iakqgp
					. += (health_deficiency / 50) ** 2.58
				else
					. += (health_deficiency / 100) + 5
		if(CONFIG_GET(flag/disable_human_mood) && !H.mood_enabled) // Yogs -- Mood as preference
			if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
				var/hungry = (500 - H.nutrition) / 5 //So overeat would be 100 and default level would be 80
				if((hungry >= 70) && !flight) //Being hungry will still allow you to use a flightsuit/wings.
					. += hungry / 50

		if(gravity > STANDARD_GRAVITY)
			var/grav_force = min(gravity - STANDARD_GRAVITY,3)
			. += 1 + grav_force

		if(HAS_TRAIT(H, TRAIT_FAT))
			. += (1.5 - flight)
		if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTCOLD))
			. += (BODYTEMP_COLD_DAMAGE_LIMIT - H.bodytemperature) / COLD_SLOWDOWN_FACTOR
	return .

//////////////////
// ATTACK PROCS //
//////////////////

/datum/species/proc/spec_updatehealth(mob/living/carbon/human/H)
	return

/datum/species/proc/spec_fully_heal(mob/living/carbon/human/H)
	return

/datum/species/proc/spec_rad_act(mob/living/carbon/human/H, amount, collectable_radiation)
	return

/datum/species/proc/spec_emp_act(mob/living/carbon/human/H, severity)
	return

/datum/species/proc/spec_emag_act(mob/living/carbon/human/H, mob/user, obj/item/card/emag/emag_card)
	return FALSE

/datum/species/proc/spec_electrocute_act(mob/living/carbon/human/H, shock_damage, obj/source, siemens_coeff = 1, zone = BODY_ZONE_R_ARM, override = 0, tesla_shock = 0, illusion = 0, stun = TRUE)
	return

/datum/species/proc/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.try_extinguish(user))
		return 1
	else if(!((target.health < 0 || HAS_TRAIT(target, TRAIT_FAKEDEATH)) && !(target.mobility_flags & MOBILITY_STAND)))
		target.help_shake_act(user)
		if(target != user)
			log_combat(user, target, "shaken")
		return 1
	else
		user.do_cpr(target)

/datum/species/proc/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	var/datum/martial_art/M = target.check_block()
	if(user.pulledby && user.pulledby.grab_state >= GRAB_AGGRESSIVE)
		return FALSE
	if(M)
		M.handle_counter(target, user)
		return FALSE
	if(attacker_style && attacker_style.grab_act(user,target))
		return TRUE
	else
		target.grabbedby(user)
		return TRUE

/datum/species/proc/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(!attacker_style?.nonlethal && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm [target]!"))
		return FALSE
	if(!synth_check(user, SYNTH_ORGANIC_HARM))
		to_chat(user, span_warning("You don't want to harm [target]!"))
		return
	var/datum/martial_art/M = target.check_block()
	if(M)
		M.handle_counter(target, user)
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	else

		var/atk_verb = pick(user.dna.species.attack_verbs)
		var/atk_effect = user.dna.species.attack_effect
		if(!(target.mobility_flags & MOBILITY_STAND))
			atk_verb = "kick"
			atk_effect = ATTACK_EFFECT_KICK
		user.do_attack_animation(target, atk_effect)
		var/damage = rand(user.get_punchdamagelow(), user.get_punchdamagehigh())

		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))

		var/miss_chance = 100//calculate the odds that a punch misses entirely. considers stamina and brute damage of the puncher. punches miss by default to prevent weird cases
		if(user.get_punchdamagelow())
			if(atk_effect == ATTACK_EFFECT_KICK) //kicks never miss (provided your species deals more than 0 damage)
				miss_chance = 0
			else
				miss_chance = min((user.get_punchdamagelow()/user.get_punchdamagehigh()) + user.getStaminaLoss() + (user.getBruteLoss()*0.5), 100) //old base chance for a miss + various damage. capped at 100 to prevent weirdness in prob()

		if(!damage || !affecting || prob(miss_chance))//future-proofing for species that have 0 damage/weird cases where no zone is targeted
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message(span_danger("[user] has attempted to [atk_verb] [target]!"),\
			span_userdanger("[user] has attempted to [atk_verb] [target]!"), null, COMBAT_MESSAGE_RANGE)
			log_combat(user, target, "attempted to punch")
			return FALSE

		var/armor_block = target.run_armor_check(affecting, MELEE)

		playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)

		target.visible_message(span_danger("[user] has [atk_verb]ed [target]!"), \
					span_userdanger("[user] has [atk_verb]ed [target]!"), null, COMBAT_MESSAGE_RANGE)

		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		user.dna.species.spec_unarmedattacked(user, target)

		if(user.limb_destroyer)
			target.dismembering_strike(user, affecting.body_zone)

		var/attack_direction = get_dir(user, target)
		if(atk_effect == ATTACK_EFFECT_KICK)//kicks deal 1.5x raw damage
			target.apply_damage(damage*1.5, user.dna.species.attack_type, affecting, armor_block, attack_direction = attack_direction)
			log_combat(user, target, "kicked")
		else//other attacks deal full raw damage + 1.5x in stamina damage
			target.apply_damage(damage, user.dna.species.attack_type, affecting, armor_block, attack_direction = attack_direction)
			target.apply_damage(damage*1.5, STAMINA, affecting, armor_block)
			log_combat(user, target, "punched")

		if((target.stat != DEAD) && damage >= user.get_punchstunthreshold())
			target.visible_message(span_danger("[user] has knocked [target] down!"), \
							span_userdanger("[user] has knocked [target] down!"), null, COMBAT_MESSAGE_RANGE)
			var/knockdown_duration = 40 + (target.getStaminaLoss() + (target.getBruteLoss()*0.5))*0.8 //50 total damage = 40 base stun + 40 stun modifier = 80 stun duration, which is the old base duration
			target.apply_effect(knockdown_duration, EFFECT_KNOCKDOWN, armor_block)
			target.forcesay(GLOB.hit_appends)
			log_combat(user, target, "got a stun punch with their previous punch")
		else if(!(target.mobility_flags & MOBILITY_STAND))
			target.forcesay(GLOB.hit_appends)

/datum/species/proc/spec_unarmedattacked(mob/living/carbon/human/user, mob/living/carbon/human/target, modifiers)
	return

/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message(span_warning("[target] blocks [user]'s shoving attempt!"))
		return FALSE
	if(attacker_style && attacker_style.disarm_act(user,target))
		return TRUE
	if(user.resting || user.IsKnockdown())
		return FALSE
	if(user == target)
		return FALSE
	if(user.loc == target.loc)
		return FALSE
	if(!QDELETED(target.pulledby) && HAS_TRAIT(target.pulledby, TRAIT_STRONG_GRIP) && target.pulledby != user)
		return FALSE
	if(user.pulledby && user.pulledby.grab_state >= GRAB_AGGRESSIVE)
		return FALSE
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		var/randomized_zone = ran_zone(user.zone_selected)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(randomized_zone)

		var/shove_dir = get_dir(user.loc, target.loc)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/carbon/human/target_collateral_human
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		//Thank you based whoneedsspace
		target_collateral_human = locate(/mob/living/carbon/human) in target_shove_turf.contents
		var/bothstanding = target_collateral_human && (target.mobility_flags & MOBILITY_STAND) && (target_collateral_human.mobility_flags & MOBILITY_STAND)
		if(target_collateral_human && bothstanding)
			shove_blocked = TRUE
		else
			target.Move(target_shove_turf, shove_dir)
			if(get_turf(target) != target_shove_turf)
				shove_blocked = TRUE

		if(target.IsKnockdown() && !target.IsParalyzed())
			var/armor_block = target.run_armor_check(affecting, MELEE, "Your armor prevents your fall!", "Your armor softens your fall!")
			target.apply_effect(SHOVE_CHAIN_PARALYZE, EFFECT_PARALYZE, armor_block)
			target.visible_message(span_danger("[user.name] kicks [target.name] onto their side!"),
				span_danger("[user.name] kicks you onto your side!"), null, COMBAT_MESSAGE_RANGE)
			var/reset_timer = SHOVE_CHAIN_PARALYZE * (100-armor_block)/100
			addtimer(CALLBACK(target, /mob/living/proc/SetKnockdown, 0), reset_timer)
			log_combat(user, target, "kicks", "onto their side (paralyzing)")

		if(shove_blocked && !target.is_shove_knockdown_blocked() && !target.buckled)
			var/directional_blocked = FALSE
			if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
				var/target_turf = get_turf(target)
				for(var/obj/O in target_turf)
					if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
						directional_blocked = TRUE
						break
				if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
					for(var/obj/O in target_shove_turf)
						if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
							directional_blocked = TRUE
							break
			if(!bothstanding || directional_blocked)
				var/obj/item/I = target.get_active_held_item()
				if(target.dropItemToGround(I))
					user.visible_message(span_danger("[user.name] shoves [target.name], disarming them!"),
						span_danger("You shove [target.name], disarming them!"), null, COMBAT_MESSAGE_RANGE)
					log_combat(user, target, "shoved", "disarming them")
			else if(bothstanding)
				target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				if(!target_collateral_human.is_shove_knockdown_blocked())
					target_collateral_human.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				user.visible_message(span_danger("[user.name] shoves [target.name] into [target_collateral_human.name]!"),
					span_danger("You shove [target.name] into [target_collateral_human.name]!"), null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "into [target_collateral_human.name]")
		else
			user.visible_message(span_danger("[user.name] shoves [target.name]!"),
				span_danger("You shove [target.name]!"), null, COMBAT_MESSAGE_RANGE)
			var/target_held_item = target.get_active_held_item()
			var/knocked_item = FALSE
			if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types))
				target_held_item = null
			if(isgun(target_held_item) && prob(70))
				var/turf/curloc = get_turf(src)
				var/atom/target_aimed_atom = target.client?.mouse_object_ref?.resolve()
				var/turf/aimloc = get_turf(target_aimed_atom)
				if(target_aimed_atom && istype(aimloc) && istype(curloc))
					var/obj/item/gun/held_gun = target_held_item
					held_gun.process_fire(target_aimed_atom, target, bonus_spread = 10)
			if(!target.has_movespeed_modifier(MOVESPEED_ID_SHOVE))
				target.add_movespeed_modifier(MOVESPEED_ID_SHOVE, multiplicative_slowdown = SHOVE_SLOWDOWN_STRENGTH)
				if(target_held_item)
					target.visible_message(span_danger("[target.name]'s grip on \the [target_held_item] loosens!"),
						span_danger("Your grip on \the [target_held_item] loosens!"), null, COMBAT_MESSAGE_RANGE)
				addtimer(CALLBACK(target, /mob/living/carbon/human/proc/clear_shove_slowdown), SHOVE_SLOWDOWN_LENGTH)
			else if(target_held_item)
				target.dropItemToGround(target_held_item)
				knocked_item = TRUE
				target.visible_message(span_danger("[target.name] drops \the [target_held_item]!!"),
					span_danger("You drop \the [target_held_item]!!"), null, COMBAT_MESSAGE_RANGE)
			var/append_message = ""
			if(target_held_item)
				if(knocked_item)
					append_message = "causing them to drop [target_held_item]"
				else
					append_message = "loosening their grip on [target_held_item]"
			log_combat(user, target, "shoved", append_message)

/datum/species/proc/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	return

/datum/species/proc/spec_attack_hand(mob/living/carbon/human/attacker, mob/living/carbon/human/defender, datum/martial_art/attacker_style, modifiers)
	if(!istype(attacker))
		return
	CHECK_DNA_AND_SPECIES(attacker)
	CHECK_DNA_AND_SPECIES(defender)

	if(!istype(attacker)) //sanity check for drones.
		return
	if(attacker.mind)
		attacker_style = attacker.mind.martial_art
	var/disarming = (modifiers && modifiers[RIGHT_CLICK])
	if((attacker != defender) && (attacker.combat_mode || disarming) && defender.check_shields(attacker, 0, attacker.name, UNARMED_ATTACK, 0, attacker.dna.species.attack_type))
		if(istype(attacker_style, /datum/martial_art/flyingfang) && disarming)
			disarm(attacker, defender, attacker_style)
			return
		log_combat(attacker, defender, "attempted to touch")
		defender.visible_message(span_warning("[attacker] attempted to touch [defender]!"))
		return
	SEND_SIGNAL(attacker, COMSIG_MOB_ATTACK_HAND, attacker, defender, attacker_style, modifiers)
	if(disarming)
		disarm(attacker, defender, attacker_style)
	else if(attacker.grab_mode)
		grab(attacker, defender, attacker_style)
	else if(attacker.combat_mode)
		harm(attacker, defender, attacker_style)
	else
		help(attacker, defender, attacker_style)

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, mob/living/carbon/human/H)
	// Allows you to put in item-specific reactions based on species
	if(user != H && H.check_shields(I, I.force, "the [I.name]", MELEE_ATTACK, I.armour_penetration, I.damtype))
		return FALSE
	var/datum/martial_art/M = H.check_block()
	if(M)
		M.handle_counter(H, user)
		return FALSE

	var/hit_area
	if(!affecting) //Something went wrong. Maybe the limb is missing?
		affecting = H.bodyparts[1]

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/armor_block = H.run_armor_check(affecting, MELEE, span_notice("Your armor has protected your [hit_area]."), span_notice("Your armor has softened a hit to your [hit_area]."),I.armour_penetration)
	armor_block = min(90,armor_block) //cap damage reduction at 90%
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)
	var/Iwound_bonus = I.wound_bonus

	// this way, you can't wound with a surgical tool without combat mode if they have a surgery active and are laying down, so a misclick with a circular saw on the wrong limb doesn't bleed them dry (they still get hit tho)
	if((I.item_flags & SURGICAL_TOOL) && !user.combat_mode && (H.mobility_flags & ~MOBILITY_STAND) && (LAZYLEN(H.surgeries) > 0))
		Iwound_bonus = CANT_WOUND

	var/weakness = H.check_weakness(I, user)

	H.send_item_attack_message(I, user, hit_area, affecting)

	var/attack_direction = get_dir(user, H)
	apply_damage(I.force * weakness, I.damtype, def_zone, armor_block, H, wound_bonus = Iwound_bonus, bare_wound_bonus = I.bare_wound_bonus, sharpness = I.sharpness, attack_direction = attack_direction)

	if(!I.force)
		return FALSE //item force is zero

	var/bloody = 0
	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			if(prob(I.force * 2))	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				if(istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if(BODY_ZONE_HEAD)
				if(!I.is_sharp() && armor_block < 50)
					if(prob(I.force))
						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20)
						if(H.stat == CONSCIOUS)
							H.visible_message(span_danger("[H] has been knocked senseless!"), \
											span_userdanger("[H] has been knocked senseless!"))
							H.set_confusion_if_lower(20 SECONDS)
							H.adjust_eye_blur(10)
						if(prob(10))
							H.gain_trauma(/datum/brain_trauma/mild/concussion)
					else
						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, I.force * 0.2)

					if(H.mind && H.stat == CONSCIOUS && H != user && prob(I.force + ((100 - H.health) * 0.5))) // rev deconversion through blunt trauma.
						var/datum/antagonist/rev/rev = H.mind.has_antag_datum(/datum/antagonist/rev)
						if(rev)
							rev.remove_revolutionary(FALSE, user)

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if(BODY_ZONE_CHEST)
				if(H.stat == CONSCIOUS && !I.is_sharp() && armor_block < 50)
					if(prob(I.force))
						H.visible_message(span_danger("[H] has been knocked down!"), \
									span_userdanger("[H] has been knocked down!"))
						H.apply_effect(60, EFFECT_KNOCKDOWN, armor_block)

				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_mob_blood(H)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_mob_blood(H)
						H.update_inv_w_uniform()

		if(Iforce > 10 || Iforce >= 5 && prob(33))
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
	return TRUE

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE, attack_direction = null)
	if(SEND_SIGNAL(H, COMSIG_MOB_APPLY_DAMAGE, damage, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction) & COMPONENT_NO_APPLY_DAMAGE) // make sure putting wound_bonus here doesn't screw up other signals or uses for this signal)
		return FALSE

	var/hit_percent = (100-(blocked+armor))/100
	hit_percent = (hit_percent * (100-H.physiology.damage_resistance))/100
	if(!damage || hit_percent <= 0)
		return 0

	var/obj/item/bodypart/BP = null
	if(isbodypart(def_zone))
		BP = def_zone
	else
		if(!def_zone)
			def_zone = ran_zone(def_zone)
		BP = H.get_bodypart(check_zone(def_zone))
		if(!BP)
			BP = H.bodyparts[1]

	switch(damagetype)
		if(BRUTE)
			H.damageoverlaytemp = 20
			if(BP)
				if(BP.receive_damage(damage * hit_percent * brutemod * H.physiology.brute_mod, 0, wound_bonus = wound_bonus, bare_wound_bonus = bare_wound_bonus, sharpness = sharpness, attack_direction = attack_direction))
					H.update_damage_overlays()
			else//no bodypart, we deal damage with a more general method.
				H.adjustBruteLoss(damage * hit_percent * brutemod * H.physiology.brute_mod)
		if(BURN)
			H.damageoverlaytemp = 20
			if(BP)
				if(BP.receive_damage(0, damage * hit_percent * burnmod * H.physiology.burn_mod, wound_bonus = wound_bonus, bare_wound_bonus = bare_wound_bonus, sharpness = sharpness, attack_direction = attack_direction))
					H.update_damage_overlays()
			else
				H.adjustFireLoss(damage * hit_percent * burnmod * H.physiology.burn_mod)
		if(TOX)
			H.adjustToxLoss(damage * hit_percent * toxmod * H.physiology.tox_mod)
		if(OXY)
			H.adjustOxyLoss(damage * hit_percent * oxymod * H.physiology.oxy_mod)
		if(CLONE)
			H.adjustCloneLoss(damage * hit_percent * clonemod * H.physiology.clone_mod)
		if(STAMINA)
			if(BP)
				if(BP.receive_damage(0, 0, damage * staminamod * hit_percent * H.physiology.stamina_mod))
					H.update_stamina()
			else
				H.adjustStaminaLoss(damage * hit_percent * H.physiology.stamina_mod)
		if(BRAIN)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, damage * hit_percent * H.physiology.brain_mod)

	if(H.stat == DEAD && (H.mobility_flags & MOBILITY_STAND))
		if(H.buckled && istype(H.buckled, /obj/structure))//prevent buckling corpses to chairs to make indestructible projectile walls
			var/obj/structure/sitter = H.buckled
			sitter.take_damage(damage, damagetype)
	return damage * hit_percent

/datum/species/proc/on_hit(obj/projectile/P, mob/living/carbon/human/H)
	// called when hit by a projectile
	switch(P.type)
		if(/obj/projectile/energy/floramut) // overwritten by plants/pods
			H.show_message(span_notice("The radiation beam dissipates harmlessly through your body."))
		if(/obj/projectile/energy/florayield)
			H.show_message(span_notice("The radiation beam dissipates harmlessly through your body."))

/datum/species/proc/bullet_act(obj/projectile/P, mob/living/carbon/human/H)
	// called before a projectile hit
	return 0

/////////////
//BREATHING//
/////////////

/datum/species/proc/breathe(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return TRUE


/datum/species/proc/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/H)
	if(!environment)
		return

	var/human_loc = H.loc

	if(istype(human_loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	if(environment.get_moles(GAS_H2O) > 10)//water vapour above a certain amount makes you wet
		if(environment.get_moles(GAS_H2O) > 40)//if there's a lot of water vapour, preterni ded
			H.adjust_wet_stacks(3)
		else
			H.adjust_wet_stacks(2)

	var/loc_temp = H.get_temperature(environment)
	var/heat_capacity_factor = min(1, environment.heat_capacity() / environment.return_volume())

	//Body temperature is adjusted in two parts: first there your body tries to naturally preserve homeostasis (shivering/sweating), then it reacts to the surrounding environment
	//Thermal protection (insulation) has mixed benefits in two situations (hot in hot places, cold in hot places)
	if(!H.on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		var/natural = 0
		if(H.stat != DEAD)
			natural = H.natural_bodytemperature_stabilization()
		var/thermal_protection = 1
		if(loc_temp < H.bodytemperature) //Place is colder than we are
			thermal_protection -= H.get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			thermal_protection *= heat_capacity_factor
			if(ismovable(human_loc))
				var/atom/movable/occupied_space = human_loc
				thermal_protection *= (1 - occupied_space.contents_thermal_insulation)
			if(!HAS_TRAIT(H, TRAIT_NO_PASSIVE_COOLING))
				if(H.bodytemperature < BODYTEMP_NORMAL) //we're cold, insulation helps us retain body heat and will reduce the heat we lose to the environment
					H.adjust_bodytemperature((thermal_protection+1)*natural + max(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX))
				else //we're sweating, insulation hinders our ability to reduce heat - and it will reduce the amount of cooling you get from the environment
					H.adjust_bodytemperature(natural*(1/(thermal_protection+1)) + max((thermal_protection * (loc_temp - H.bodytemperature) + BODYTEMP_NORMAL - H.bodytemperature) / BODYTEMP_COLD_DIVISOR , BODYTEMP_COOLING_MAX)) //Extra calculation for hardsuits to bleed off heat
	if (loc_temp > H.bodytemperature) //Place is hotter than we are
		var/natural = 0
		if(H.stat != DEAD)
			natural = H.natural_bodytemperature_stabilization()
		var/thermal_protection = 1
		thermal_protection -= H.get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		thermal_protection *= heat_capacity_factor
		if(ismovable(human_loc))
			var/atom/movable/occupied_space = human_loc
			thermal_protection *= (1 - occupied_space.contents_thermal_insulation)
		if(!HAS_TRAIT(H, TRAIT_NO_PASSIVE_HEATING))
			if(H.bodytemperature < BODYTEMP_NORMAL) //and we're cold, insulation enhances our ability to retain body heat but reduces the heat we get from the environment
				H.adjust_bodytemperature((thermal_protection+1)*natural + min(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX))
			else //we're sweating, insulation hinders out ability to reduce heat - but will reduce the amount of heat we get from the environment
				H.adjust_bodytemperature(natural*(1/(thermal_protection+1)) + min(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX))

	// +/- 50 degrees from 310K is the 'safe' zone, where no damage is dealt.
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTHEAT))
		//Body temperature is too hot.

		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "cold")
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "hot", /datum/mood_event/hot)

		var/burn_damage
		var/firemodifier = H.fire_stacks / 50
		if (H.on_fire)
			burn_damage = max(log(2-firemodifier,(H.bodytemperature-BODYTEMP_NORMAL))-5,0)
		else
			firemodifier = min(firemodifier, 0)
			burn_damage = max(log(2-firemodifier,(H.bodytemperature-BODYTEMP_NORMAL))-5,0) // this can go below 5 at log 2.5
		if (burn_damage)
			switch(burn_damage)
				if(0 to 2)
					H.throw_alert("temp", /atom/movable/screen/alert/hot, 1)
				if(2 to 4)
					H.throw_alert("temp", /atom/movable/screen/alert/hot, 2)
				else
					H.throw_alert("temp", /atom/movable/screen/alert/hot, 3)
		burn_damage = burn_damage * heatmod * H.physiology.heat_mod
		if (H.stat < UNCONSCIOUS && (prob(burn_damage) * 10) / 4) //40% for level 3 damage on humans
			H.emote("scream")
		H.apply_damage(burn_damage, BURN)

	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTCOLD))
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "hot")
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "cold", /datum/mood_event/cold)
		switch(H.bodytemperature)
			if(200 to BODYTEMP_COLD_DAMAGE_LIMIT)
				H.throw_alert("temp", /atom/movable/screen/alert/cold, 1)
				H.apply_damage(COLD_DAMAGE_LEVEL_1*coldmod*H.physiology.cold_mod, BURN)
			if(120 to 200)
				H.throw_alert("temp", /atom/movable/screen/alert/cold, 2)
				H.apply_damage(COLD_DAMAGE_LEVEL_2*coldmod*H.physiology.cold_mod, BURN)
			else
				H.throw_alert("temp", /atom/movable/screen/alert/cold, 3)
				H.apply_damage(COLD_DAMAGE_LEVEL_3*coldmod*H.physiology.cold_mod, BURN)

	else
		H.clear_alert("temp")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "cold")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "hot")

	// Infrared luminosity, how far away can you pick up someone's heat with infrared (NOT THERMAL) vision
	// 37C has 12 range (11 tiles)
	// 20C has 7 range (6 tiles)
	// 10C has 3 range (2 tiles)
	// 0C has 0 range (0 tiles)
	H.infra_luminosity = round(max((H.bodytemperature - T0C)/3, 0))

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
	switch(adjusted_pressure)
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			if(!HAS_TRAIT(H, TRAIT_RESISTHIGHPRESSURE))
				H.adjustBruteLoss(min(((adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 ) * PRESSURE_DAMAGE_COEFFICIENT, MAX_HIGH_PRESSURE_DAMAGE) * H.physiology.pressure_mod * H.dna.species.pressuremod)
				H.throw_alert("pressure", /atom/movable/screen/alert/highpressure, 2)
			else
				H.clear_alert("pressure")
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			H.throw_alert("pressure", /atom/movable/screen/alert/highpressure, 1)
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
			H.clear_alert("pressure")
		if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
			H.throw_alert("pressure", /atom/movable/screen/alert/lowpressure, 1)
		else
			if(HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
				H.clear_alert("pressure")
			else
				H.adjustBruteLoss(LOW_PRESSURE_DAMAGE * H.physiology.pressure_mod * H.dna.species.pressuremod)
				H.throw_alert("pressure", /atom/movable/screen/alert/lowpressure, 2)

//////////
// FIRE //
//////////

/datum/species/proc/handle_fire(mob/living/carbon/human/H, seconds_per_tick, no_protection = FALSE)
	return no_protection

/datum/species/proc/Canignite_mob(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOFIRE))
		return FALSE
	return TRUE

/datum/species/proc/extinguish_mob(mob/living/carbon/human/H)
	return

/datum/species/proc/spec_revival(mob/living/carbon/human/H, admin_revive = FALSE)
	return

////////////
//  Stun  //
////////////

/datum/species/proc/spec_stun(mob/living/carbon/human/H,amount)
	if(!HAS_TRAIT(H, TRAIT_STUNIMMUNE))
		if(flying_species && H.movement_type & FLYING)
			ToggleFlight(H)
			flyslip(H)
		stop_wagging_tail(H)
	return stunmod * H.physiology.stun_mod * amount


//////////////
//Space Move//
//////////////

/datum/species/proc/space_move(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return TRUE
	return FALSE

/datum/species/proc/negates_gravity(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		return TRUE
	return FALSE

/datum/species/proc/has_heavy_gravity(mob/living/carbon/human/H)
	return FALSE

////////////////
//Tail Wagging//
////////////////

/datum/species/proc/can_wag_tail(mob/living/carbon/human/H)
	if(H.IsParalyzed() || H.IsStun())
		return FALSE
	// var/obj/item/organ/tail = H.getorganslot(ORGAN_SLOT_TAIL)
	return ("tail_human" in mutant_bodyparts) || ("waggingtail_human" in mutant_bodyparts) || ("tail_lizard" in mutant_bodyparts) || ("waggingtail_lizard" in mutant_bodyparts) || ("vox_tail" in mutant_bodyparts) || ("wagging_vox_tail" in mutant_bodyparts)

/datum/species/proc/is_wagging_tail(mob/living/carbon/human/H)
	return ("waggingtail_human" in mutant_bodyparts) || ("waggingtail_lizard" in mutant_bodyparts) || ("wagging_vox_tail" in mutant_bodyparts)

/datum/species/proc/start_wagging_tail(mob/living/carbon/human/H)
	if("tail_human" in mutant_bodyparts)
		mutant_bodyparts -= "tail_human"
		mutant_bodyparts |= "waggingtail_human"
	if("tail_lizard" in mutant_bodyparts)
		mutant_bodyparts -= "tail_lizard"
		mutant_bodyparts -= "spines"
		mutant_bodyparts |= "waggingtail_lizard"
		mutant_bodyparts |= "waggingspines"
	if("vox_tail" in mutant_bodyparts)
		mutant_bodyparts -= "vox_tail"
		mutant_bodyparts -= "vox_tail_markings"
		mutant_bodyparts |= "wagging_vox_tail"
		mutant_bodyparts |= "wagging_vox_tail_markings"
	H.update_body()

/datum/species/proc/stop_wagging_tail(mob/living/carbon/human/H)
	if("waggingtail_human" in mutant_bodyparts)
		mutant_bodyparts -= "waggingtail_human"
		mutant_bodyparts |= "tail_human"
	if("waggingtail_lizard" in mutant_bodyparts)
		mutant_bodyparts -= "waggingtail_lizard"
		mutant_bodyparts -= "waggingspines"
		mutant_bodyparts |= "tail_lizard"
		mutant_bodyparts |= "spines"
	if("wagging_vox_tail" in mutant_bodyparts)
		mutant_bodyparts |= "vox_tail"
		mutant_bodyparts |= "vox_tail_markings"
		mutant_bodyparts -= "wagging_vox_tail"
		mutant_bodyparts -= "wagging_vox_tail_markings"
	H.update_body()

///////////////
//FLIGHT SHIT//
///////////////

/datum/species/proc/GiveSpeciesFlight(mob/living/carbon/human/H)
	if(flying_species) //species that already have flying traits should not work with this proc
		return
	flying_species = TRUE
	if(isnull(fly))
		fly = new
		fly.Grant(H)
	if(ismoth(H)) //mothpeople don't grow new wings, they already have theirs
		return
	if(H.dna.features["wings"] != wings_icon)
		mutant_bodyparts |= "wings"
		H.dna.features["wings"] = wings_icon
		if(wings_detail && H.dna.features["wingsdetail"] != wings_detail)
			mutant_bodyparts |= "wingsdetail"
			H.dna.features["wingsdetail"] = wings_detail
		H.update_body()

/datum/species/proc/HandleFlight(mob/living/carbon/human/H)
	if(H.movement_type & FLYING)
		if(!CanFly(H))
			ToggleFlight(H)
			return FALSE
		return TRUE
	else
		return FALSE

/datum/species/proc/CanFly(mob/living/carbon/human/H)
	if(H.stat || !(H.mobility_flags & MOBILITY_STAND))
		return FALSE
	if(ismoth(H) && H.dna.features["moth_wings"] == "Burnt Off") //this is so tragic can we get an "F" in the chat
		to_chat(H, "<span>Your crispy wings won't work anymore!</span>")
		return FALSE
	if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))	//Jumpsuits have tail holes, so it makes sense they have wing holes too
		to_chat(H, "Your suit blocks your wings from extending!")
		return FALSE
	if(isskeleton(H))
		to_chat(H, "Your wings are just bones; You can't actually fly!")
		return FALSE
	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	var/datum/gas_mixture/environment = T.return_air()
	if(environment && !(environment.return_pressure() > 30))
		to_chat(H, span_warning("The atmosphere is too thin for you to fly!"))
		return FALSE
	else
		return TRUE

/datum/species/proc/flyslip(mob/living/carbon/human/H)
	var/obj/buckled_obj
	if(H.buckled)
		buckled_obj = H.buckled

	to_chat(H, span_notice("Your wings spazz out and launch you!"))

	playsound(H.loc, 'sound/misc/slip.ogg', 50, TRUE, -3)

	for(var/obj/item/I in H.held_items)
		H.accident(I)

	var/olddir = H.dir

	H.stop_pulling()
	if(buckled_obj)
		buckled_obj.unbuckle_mob(H)
		step(buckled_obj, olddir)
	else
		new /datum/forced_movement(H, get_ranged_target_turf(H, olddir, 4), 1, FALSE, CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon, spin), 1, 1))
	return TRUE

//UNSAFE PROC, should only be called through the Activate or other sources that check for CanFly
/datum/species/proc/ToggleFlight(mob/living/carbon/human/H)
	if(!(H.movement_type & FLYING))
		stunmod *= 2
		speedmod -= 0.35
		H.setMovetype(H.movement_type | FLYING)
		override_float = TRUE
		H.pass_flags |= PASSTABLE
		H.OpenWings()
		H.update_mobility()
	else
		stunmod *= 0.5
		speedmod += 0.35
		H.setMovetype(H.movement_type & ~FLYING)
		override_float = FALSE
		H.pass_flags &= ~PASSTABLE
		H.CloseWings()

/datum/action/innate/flight
	name = "Toggle Flight"
	check_flags = AB_CHECK_CONSCIOUS| AB_CHECK_IMMOBILE
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/flight/Activate()
	var/mob/living/carbon/human/H = owner
	var/datum/species/S = H.dna.species
	if(S.CanFly(H))
		S.ToggleFlight(H)
		if(!(H.movement_type & FLYING))
			to_chat(H, span_notice("You settle gently back onto the ground..."))
		else
			to_chat(H, span_notice("You beat your wings and begin to hover gently above the ground..."))
			H.set_resting(FALSE, TRUE)

/**
  * The human species version of [/mob/living/carbon/proc/get_biological_state]. Depends on the HAS_FLESH and HAS_BONE species traits, having bones lets you have bone wounds, having flesh lets you have burn, slash, and piercing wounds
  */
/datum/species/proc/get_biological_state(mob/living/carbon/human/H)
	. = BIO_INORGANIC
	if(HAS_FLESH in species_traits)
		. |= BIO_JUST_FLESH
	if(HAS_BONE in species_traits)
		. |= BIO_JUST_BONE

/datum/species/proc/get_footprint_sprite()
	return null

/datum/species/proc/eat_text(fullness, eatverb, obj/O, mob/living/carbon/C, mob/user)
	. = TRUE
	if(C == user)
		if(fullness <= 50)
			user.visible_message(span_notice("[user] frantically [eatverb]s \the [O], scarfing it down!"), span_notice("You frantically [eatverb] \the [O], scarfing it down!"))
		else if((fullness > 50 && fullness < 150) || HAS_TRAIT(C, TRAIT_BOTTOMLESS_STOMACH))
			user.visible_message(span_notice("[user] hungrily [eatverb]s \the [O]."), span_notice("You hungrily [eatverb] \the [O]."))
		else if(fullness > 150 && fullness < 500)
			user.visible_message(span_notice("[user] [eatverb]s \the [O]."), span_notice("You [eatverb] \the [O]."))
		else if(fullness > 500 && fullness < 600)
			user.visible_message(span_notice("[user] unwillingly [eatverb]s a bit of \the [O]."), span_notice("You unwillingly [eatverb] a bit of \the [O]."))
		else if(fullness > (600 * (1 + C.overeatduration / 2000)))	// The more you eat - the more you can eat
			user.visible_message(span_warning("[user] cannot force any more of \the [O] to go down [user.p_their()] throat!"), span_warning("You cannot force any more of \the [O] to go down your throat!"))
			return FALSE
	else
		C.visible_message(span_danger("[user] forces [C] to eat [O]."), \
									span_userdanger("[user] forces [C] to eat [O]."))

/datum/species/proc/force_eat_text(fullness, obj/O, mob/living/carbon/C, mob/user)
	. = TRUE
	if(fullness <= (600 * (1 + C.overeatduration / 1000)))
		C.visible_message(span_danger("[user] attempts to feed [C] [O]."), \
							span_userdanger("[user] attempts to feed [C] [O]."))
	else
		C.visible_message(span_warning("[user] cannot force any more of [O] down [C]'s throat!"), \
							span_warning("[user] cannot force any more of [O] down [C]'s throat!"))
		return FALSE

/datum/species/proc/drink_text(obj/O, mob/living/carbon/C, mob/user)
	. = TRUE
	if(C == user)
		user.visible_message(span_notice("[user] swallows a gulp of [O]."), span_notice("You swallow a gulp of [O]."))
	else
		C.visible_message(span_danger("[user] feeds the contents of [O] to [C]."), span_userdanger("[user] feeds the contents of [O] to [C]."))

/datum/species/proc/force_drink_text(obj/O, mob/living/carbon/C, mob/user)
	. = TRUE
	C.visible_message(span_danger("[user] attempts to feed the contents of [O] to [C]."), span_userdanger("[user] attempts to feed the contents of [O] to [C]."))

/datum/species/proc/get_types_to_preload()
	var/list/to_store = list()
	to_store += mutant_organs
	//Don't preload brains, cause reuse becomes a horrible headache
	to_store += mutantheart
	to_store += mutantlungs
	to_store += mutanteyes
	to_store += mutantears
	to_store += mutanttongue
	to_store += mutantliver
	to_store += mutantstomach
	to_store += mutantappendix
	to_store += mutanttail
	//We don't cache mutant hands because it's not constrained enough, too high a potential for failure
	return to_store

/// Returns a list of strings representing features this species has.
/// Used by the preferences UI to know what buttons to show.
/datum/species/proc/get_features()
	var/cached_features = GLOB.features_by_species[type]
	if (!isnull(cached_features))
		return cached_features

	var/list/features = list()

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]

		if ( \
			(preference.relevant_mutant_bodypart in mutant_bodyparts) \
			|| (preference.relevant_species_trait in species_traits) \
		)
			features += preference.savefile_key

	/*for (var/obj/item/organ/external/organ_type as anything in external_organs)
		var/preference = initial(organ_type.preference)
		if (!isnull(preference))
			features += preference*/

	GLOB.features_by_species[type] = features

	return features

/// Given a human, will adjust it before taking a picture for the preferences UI.
/// This should create a CONSISTENT result, so the icons don't randomly change.
/datum/species/proc/prepare_human_for_preview(mob/living/carbon/human/human)
	return

/// Returns the species' scream sound.
/datum/species/proc/get_scream_sound(mob/living/carbon/human/human)
	if(islist(screamsound))
		return pick(screamsound)
	return screamsound

/// Returns the species' cry sound.
/datum/species/proc/get_cry_sound(mob/living/carbon/human/human)
	return

/// Returns the species' cough sound.
/datum/species/proc/get_cough_sound(mob/living/carbon/human/human)
	return

/// Returns the species' laugh sound
/datum/species/proc/get_laugh_sound(mob/living/carbon/human/human)
	return

/// Returns the species' sneeze sound.
/datum/species/proc/get_sneeze_sound(mob/living/carbon/human/human)
	return

/**
 * Gets a short description for the specices. Should be relatively succinct.
 * Used in the preference menu.
 *
 * Returns a string.
 */
/datum/species/proc/get_species_description()
	SHOULD_CALL_PARENT(FALSE)

	stack_trace("Species [name] ([type]) did not have a description set, and is a selectable roundstart race! Override get_species_description.")
	return "No species description set, file a bug report!"

/**
 * Gets the lore behind the type of species. Can be long.
 * Used in the preference menu.
 *
 * Returns a list of strings.
 * Between each entry in the list, a newline will be inserted, for formatting.
 */
/datum/species/proc/get_species_lore()
	SHOULD_CALL_PARENT(FALSE)
	RETURN_TYPE(/list)

	stack_trace("Species [name] ([type]) did not have lore set, and is a selectable roundstart race! Override get_species_lore.")
	return list("No species lore set, file a bug report!")

/**
 * Translate the species liked foods from bitfields into strings
 * and returns it in the form of an associated list.
 *
 * Returns a list, or null if they have no diet.
 */
/datum/species/proc/get_species_diet()
	if(TRAIT_NOHUNGER in inherent_traits)
		return null

	if(TRAIT_POWERHUNGRY in inherent_traits)
		return null

	var/list/food_flags = FOOD_FLAGS

	return list(
		"liked_food" = bitfield_to_list(liked_food, food_flags),
		"disliked_food" = bitfield_to_list(disliked_food, food_flags),
		"toxic_food" = bitfield_to_list(toxic_food, food_flags),
	)

/**
 * Generates a list of "perks" related to this species
 * (Postives, neutrals, and negatives)
 * in the format of a list of lists.
 * Used in the preference menu.
 *
 * "Perk" format is as followed:
 * list(
 *   SPECIES_PERK_TYPE = type of perk (postiive, negative, neutral - use the defines)
 *   SPECIES_PERK_ICON = icon shown within the UI
 *   SPECIES_PERK_NAME = name of the perk on hover
 *   SPECIES_PERK_DESC = description of the perk on hover
 * )
 *
 * Returns a list of lists.
 * The outer list is an assoc list of [perk type]s to a list of perks.
 * The innter list is a list of perks. Can be empty, but won't be null.
 */
/datum/species/proc/get_species_perks()
	var/list/species_perks = list()

	// Let us get every perk we can concieve of in one big list.
	// The order these are called (kind of) matters.
	// Species unique perks first, as they're more important than genetic perks,
	// and language perk last, as it comes at the end of the perks list
	species_perks += create_pref_unique_perks()
	species_perks += create_pref_blood_perks()
	species_perks += create_pref_combat_perks()
	species_perks += create_pref_damage_perks()
	species_perks += create_pref_temperature_perks()
	species_perks += create_pref_traits_perks()
	species_perks += create_pref_biotypes_perks()
	species_perks += create_pref_language_perk()

	// Some overrides may return `null`, prevent those from jamming up the list.
	listclearnulls(species_perks)

	// Now let's sort them out for cleanliness and sanity
	var/list/perks_to_return = list(
		SPECIES_POSITIVE_PERK = list(),
		SPECIES_NEUTRAL_PERK = list(),
		SPECIES_NEGATIVE_PERK =  list(),
	)

	for(var/list/perk as anything in species_perks)
		var/perk_type = perk[SPECIES_PERK_TYPE]
		// If we find a perk that isn't postiive, negative, or neutral,
		// it's a bad entry - don't add it to our list. Throw a stack trace and skip it instead.
		if(isnull(perks_to_return[perk_type]))
			stack_trace("Invalid species perk ([perk[SPECIES_PERK_NAME]]) found for species [name]. \
				The type should be positive, negative, or neutral. (Got: [perk_type])")
			continue

		perks_to_return[perk_type] += list(perk)

	return perks_to_return

/**
 * Used to add any species specific perks to the perk list.
 *
 * Returns null by default. When overriding, return a list of perks.
 */
/datum/species/proc/create_pref_unique_perks()
	return null

/**
 * Adds adds any perks related to combat.
 * For example, the damage type of their punches.
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_combat_perks()
	var/list/to_add = list()

	if(attack_type != BRUTE)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "fist-raised",
			SPECIES_PERK_NAME = "Elemental Attacker",
			SPECIES_PERK_DESC = "[plural_form] deal [attack_type] damage with their punches instead of brute.",
		))

	return to_add

/**
 * Adds adds any perks related to sustaining damage.
 * For example, brute damage vulnerability, or fire damage resistance.
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_damage_perks()
	var/list/to_add = list()

	// Brute related
	if(brutemod > 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "band-aid",
			SPECIES_PERK_NAME = "Brutal Weakness",
			SPECIES_PERK_DESC = "[plural_form] are weak to bruising and brute damage.",
		))

	if(brutemod < 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield-alt",
			SPECIES_PERK_NAME = "Brutal Resilience",
			SPECIES_PERK_DESC = "[plural_form] are resilient to bruising and brute damage.",
		))

	// Burn related
	if(burnmod > 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "burn",
			SPECIES_PERK_NAME = "Fire Weakness",
			SPECIES_PERK_DESC = "[plural_form] are weak to fire and burn damage.",
		))

	if(burnmod < 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield-alt",
			SPECIES_PERK_NAME = "Fire Resilience",
			SPECIES_PERK_DESC = "[plural_form] are resilient to fire and burn damage.",
		))

	// Shock damage
	if(siemens_coeff > 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Shock Vulnerability",
			SPECIES_PERK_DESC = "[plural_form] are vulnerable to being shocked.",
		))

	if(siemens_coeff < 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield-alt",
			SPECIES_PERK_NAME = "Shock Resilience",
			SPECIES_PERK_DESC = "[plural_form] are resilient to being shocked.",
		))

	if(emp_mod > 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "thunderstorm",
			SPECIES_PERK_NAME = "EM Weakness",
			SPECIES_PERK_DESC = "[plural_form] are weak to electromagnetic interference.",
		))

	if(emp_mod < 1)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "thunderstorm", //if we update font awesome, please swap to bolt-slash
			SPECIES_PERK_NAME = "EM Resistance",
			SPECIES_PERK_DESC = "[plural_form] are resistant to electromagnetic interference.",
		))

	return to_add

/**
 * Adds adds any perks related to how the species deals with temperature.
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_temperature_perks()
	var/list/to_add = list()

	// Hot temperature tolerance
	if(heatmod > 1/* || bodytemp_heat_damage_limit < BODYTEMP_HEAT_DAMAGE_LIMIT*/)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "temperature-high",
			SPECIES_PERK_NAME = "Heat Vulnerability",
			SPECIES_PERK_DESC = "[plural_form] are vulnerable to high temperatures.",
		))

	if(heatmod < 1/* || bodytemp_heat_damage_limit > BODYTEMP_HEAT_DAMAGE_LIMIT*/)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "thermometer-full",
			SPECIES_PERK_NAME = "Heat Resilience",
			SPECIES_PERK_DESC = "[plural_form] are resilient to hotter environments.",
		))

	// Cold temperature tolerance
	if(coldmod > 1/* || bodytemp_cold_damage_limit > BODYTEMP_COLD_DAMAGE_LIMIT*/)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "temperature-low",
			SPECIES_PERK_NAME = "Cold Vulnerability",
			SPECIES_PERK_DESC = "[plural_form] are vulnerable to cold temperatures.",
		))

	if(coldmod < 1/* || bodytemp_cold_damage_limit < BODYTEMP_COLD_DAMAGE_LIMIT*/)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "thermometer-empty",
			SPECIES_PERK_NAME = "Cold Resilience",
			SPECIES_PERK_DESC = "[plural_form] are resilient to colder environments.",
		))

	return to_add

/**
 * Adds adds any perks related to the species' blood (or lack thereof).
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_blood_perks()
	var/list/to_add = list()

	// NOBLOOD takes priority by default
	if(NOBLOOD in species_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "tint-slash",
			SPECIES_PERK_NAME = "Bloodless",
			SPECIES_PERK_DESC = "[plural_form] do not have blood.",
		))

	// Otherwise, check if their exotic blood is a valid typepath
	else if(ispath(exotic_blood))
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "tint",
			SPECIES_PERK_NAME = initial(exotic_blood.name),
			SPECIES_PERK_DESC = "[name] blood is [initial(exotic_blood.name)], which can make recieving medical treatment harder.",
		))

	// Otherwise otherwise, see if they have an exotic bloodtype set
	else if(exotic_bloodtype)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "tint",
			SPECIES_PERK_NAME = "Exotic Blood",
			SPECIES_PERK_DESC = "[plural_form] have \"[exotic_bloodtype]\" type blood, which can make recieving medical treatment harder.",
		))

	return to_add

/**
 * Adds adds any perks related to the species' inherent_traits list.
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_traits_perks()
	var/list/to_add = list()

	if(TRAIT_RADIMMUNE in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "radiation",
			SPECIES_PERK_NAME = "Radiation Immunity",
			SPECIES_PERK_DESC = "[plural_form] are completely unaffected by radiation. However, this doesn't mean they can't be irradiated.",
		))
	if(TRAIT_LIMBATTACHMENT in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "user-plus",
			SPECIES_PERK_NAME = "Limbs Easily Reattached",
			SPECIES_PERK_DESC = "[plural_form] limbs are easily readded, and as such do not \
				require surgery to restore. Simply pick it up and pop it back in, champ!",
		))
	if(TRAIT_POWERHUNGRY in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "battery-4", //would prefer battery-bolt, but it doesn't show up
			SPECIES_PERK_NAME = "Power-Hungry",
			SPECIES_PERK_DESC = "[plural_form] run off electricity rather than food.",
		))
	if(TRAIT_EASYDISMEMBER in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "user-minus",
			SPECIES_PERK_NAME = "Limbs Easily Dismembered",
			SPECIES_PERK_DESC = "[plural_form] limbs are not secured well, and as such they are easily dismembered.",
		))

	if(TRAIT_EASILY_WOUNDED in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "user-injured",
			SPECIES_PERK_NAME = "Easily Wounded",
			SPECIES_PERK_DESC = "[plural_form] skin is very weak and fragile. They are much easier to apply serious wounds to.",
		))

	if(TRAIT_TOXINLOVER in inherent_traits)
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "syringe",
			SPECIES_PERK_NAME = "Toxins Lover",
			SPECIES_PERK_DESC = "Toxins damage dealt to [plural_form] are reversed - healing toxins will instead cause harm, and \
				causing toxins will instead cause healing. Be careful around purging chemicals!",
		))

	return to_add

/**
 * Adds adds any perks related to the species' inherent_biotypes flags.
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_biotypes_perks()
	var/list/to_add = list()

	if((inherent_biotypes & MOB_UNDEAD) && (TRAIT_NOBREATH in inherent_traits)) // We check NOBREATH so plasmamen don't get this
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "skull",
			SPECIES_PERK_NAME = "Undead",
			SPECIES_PERK_DESC = "[plural_form] are of the undead! The undead do not have the need to eat or breathe, and \
				most viruses will not be able to infect a walking corpse. Their worries mostly stop at remaining in one piece, really.",
		))

	if(inherent_biotypes & MOB_ROBOTIC)//species traits is basically inherent traits
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "fa-solid fa-gear",
			SPECIES_PERK_NAME = "Robotic",
			SPECIES_PERK_DESC = "[plural_form] have limbs comprised entirely of metal and circuitry, this will make standard surgery ineffective. \
				However, this gives [plural_form] the ability to do self-maintenance with just simple tools.",
		))

	if(DIGITIGRADE in species_traits) // Intentionally vague as preterni have DIGITIGRADE, feel free to change this when that changes
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "shoe-prints",
			SPECIES_PERK_NAME = "Nonstandard Limbs",
			SPECIES_PERK_DESC = "[plural_form] have oddly shaped legs, and cannot fit into most standard footwear. Footwraps may be worn instead.",
		))

	return to_add

/**
 * Adds in a language perk based on all the languages the species
 * can speak by default (according to their language holder).
 *
 * Returns a list containing perks, or an empty list.
 */
/datum/species/proc/create_pref_language_perk()
	var/list/to_add = list()

	// Grab galactic common as a path, for comparisons
	var/datum/language/common_language = /datum/language/common

	// Now let's find all the languages they can speak that aren't common
	var/list/bonus_languages = list()
	var/datum/language_holder/temp_holder = new species_language_holder()
	for(var/datum/language/language_type as anything in temp_holder.spoken_languages)
		if(ispath(language_type, common_language))
			continue
		bonus_languages += initial(language_type.name)

	// If we have any languages we can speak: create a perk for them all
	if(length(bonus_languages))
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "book",
			SPECIES_PERK_NAME = "[english_list(bonus_languages)] Fluency",
			SPECIES_PERK_DESC = "Alongside [initial(common_language.name)], [plural_form] can speak and understand [english_list(bonus_languages)].",
		))

	qdel(temp_holder)

	return to_add
