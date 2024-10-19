/datum/species/skeleton
	// 2spooky
	name = "Spooky Scary Skeleton"
	id = SPECIES_SKELETON
	say_mod = "rattles"
	possible_genders = list(NEUTER)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	species_traits = list(NOBLOOD,HAS_BONE, NO_DNA_COPY, NOTRANSSTING, NOHUSK, NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_EASYDISMEMBER,TRAIT_LIMBATTACHMENT,TRAIT_FAKEDEATH, TRAIT_CALCIUM_HEALER)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutanttongue = /obj/item/organ/tongue/bone
	barefoot_step_sound = FOOTSTEP_MOB_CLAW
	damage_overlay_type = ""//let's not show bloody wounds or burns over bones.
	wings_icon = "Skeleton"
	disliked_food = NONE
	liked_food = GROSS | MEAT | RAW | MICE
	//They can technically be in an ERT
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

/datum/species/skeleton/lowcalcium
	// these are the ones players can be roundstart during halloween
	name = "Lesser Spooky Scary Skeleton"
	id = "weakskeleton"
	brutemod = 1.5 // Their low calcium bones are much weaker to being smashed.
	punchdamagehigh = 5 // their weak bones don't let them punch very well.
	limbs_id = SPECIES_SKELETON //they are just normal skeletons but weaker

/datum/species/skeleton/lowcalcium/check_roundstart_eligible()
	if(SSgamemode.holidays && SSgamemode.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/skeleton/get_species_description()
	return "A rattling skeleton! They descend upon Space Station 13 \
		Every year to spook the crew! \"I've got a BONE to pick with you!\""

/datum/species/skeleton/get_species_lore()
	return list(
		"Skeletons want to be feared again! Their presence in media has been destroyed, \
		or at least that's what they firmly believe. They're always the first thing fought in an RPG, \
		they're Flanderized into pun rolling JOKES, and it's really starting to get to them. \
		You could say they're deeply RATTLED. Hah."
	)
