/datum/surgery/stomach_pump
	name = "Stomach Pump"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "stomach"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/stomach_pump,
		/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = TRUE
	ignore_clothes = FALSE

/datum/surgery/stomach_pump/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/stomach/target_stomach = target.getorganslot(ORGAN_SLOT_STOMACH)
	if(HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	if(!target_stomach)
		return FALSE
	return ..()

/datum/surgery/stomach_pump/mechanic
	steps = list(/datum/surgery_step/mechanic_open,
				/datum/surgery_step/open_hatch,
				/datum/surgery_step/mechanic_unwrench,
				/datum/surgery_step/prepare_electronics,
				/datum/surgery_step/stomach_pump,
				/datum/surgery_step/mechanic_wrench,
				/datum/surgery_step/mechanic_close)
	requires_bodypart_type = BODYPART_ROBOTIC
	lying_required = FALSE
	self_operable = TRUE

//Working the stomach by hand in such a way that you induce vomiting.
/datum/surgery_step/stomach_pump
	name = "Pump Stomach"
	accept_hand = TRUE
	repeatable = TRUE
	time = 2 SECONDS
	bloody_chance = 100
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/stomach_pump/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin pumping [target]'s stomach..."),
		span_notice("[user] begins to pump [target]'s stomach."),
		span_notice("[user] begins to press on [target]'s chest."))
	display_pain(target, "You feel a horrible sloshing feeling in your gut! You're going to be sick!")

/datum/surgery_step/stomach_pump/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(user, target, span_notice("[user] forces [target_human] to vomit, cleansing their stomach of some chemicals!"),
				span_notice("[user] forces [target_human] to vomit, cleansing their stomach of some chemicals!"),
				"[user] forces [target_human] to vomit!")
		target_human.vomit(20, FALSE, TRUE, 1, TRUE, FALSE, force = TRUE, purge_ratio = 0.67) //higher purge ratio than regular vomiting
	return ..()

/datum/surgery_step/stomach_pump/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(user, target, span_warning("You screw up, brusing [target_human]'s chest!"),
			span_warning("[user] screws up, brusing [target_human]'s abdomen!"),
			span_warning("[user] screws up!"))
		target_human.adjustOrganLoss(ORGAN_SLOT_STOMACH, 10)
		target_human.adjustBruteLoss(5)
