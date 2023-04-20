/datum/surgery/advanced/bioware/ligament_reinforcement
	name = "Ligament Reinforcement"
	desc = "A surgical procedure which adds a protective tissue and bone cage around the connections between the torso and limbs, preventing dismemberment. \
	However, the nerve connections as a result are more easily interrupted, making it easier to wound limbs with damage."
	icon_state = "surgery_chest"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/reinforce_ligaments,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_LIGAMENTS

/datum/surgery_step/reinforce_ligaments
	name = "reinforce ligaments"
	accept_hand = TRUE
	time = 12.5 SECONDS
	preop_sound = 'sound/surgery/bone1.ogg'
	success_sound = 'sound/surgery/bone3.ogg'

/datum/surgery_step/reinforce_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You start reinforcing [target]'s ligaments."),
		"[user] starts reinforce [target]'s ligaments.",
		"[user] starts manipulating [target]'s ligaments.")

/datum/surgery_step/reinforce_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You reinforce [target]'s ligaments!"),
		"[user] reinforces [target]'s ligaments!",
		"[user] finishes manipulating [target]'s ligaments.")
	new /datum/bioware/reinforced_ligaments(target)
	return TRUE

/datum/bioware/reinforced_ligaments
	name = "Reinforced Ligaments"
	desc = "The ligaments and nerve endings that connect the torso to the limbs are protected by a mix of bone and tissues, and are much harder to separate from the body, but are also easier to disable."
	mod_type = BIOWARE_LIGAMENTS

/datum/bioware/reinforced_ligaments/on_gain()
	..()
	ADD_TRAIT(owner, TRAIT_NODISMEMBER, "reinforced_ligaments")
	ADD_TRAIT(owner, TRAIT_EASILY_WOUNDED, "reinforced_ligaments")

/datum/bioware/reinforced_ligaments/on_lose()
	..()
	REMOVE_TRAIT(owner, TRAIT_NODISMEMBER, "reinforced_ligaments")
	REMOVE_TRAIT(owner, TRAIT_EASILY_WOUNDED, "reinforced_ligaments")
