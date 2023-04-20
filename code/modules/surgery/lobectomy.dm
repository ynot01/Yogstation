/datum/surgery/lobectomy
	name = "Lobectomy"	//not to be confused with lobotomy
	desc = "Restores the lungs to a functional state if it is in a non-functional state, making it able to sustain life. Can only be performed once on an individual set of lungs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "lungs"
	steps = list(/datum/surgery_step/incise, 
				/datum/surgery_step/retract_skin, 
				/datum/surgery_step/saw, 
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/lobectomy, 
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/lungs/L = target.getorganslot(ORGAN_SLOT_LUNGS)
	if(L)
		if(L.damage > 60 && !L.operated)
			return TRUE
	return FALSE

/datum/surgery/lobectomy/mechanic
	steps = list(/datum/surgery_step/mechanic_open,
				/datum/surgery_step/open_hatch,
				/datum/surgery_step/mechanic_unwrench,
				/datum/surgery_step/prepare_electronics,
				/datum/surgery_step/lobectomy,
				/datum/surgery_step/mechanic_wrench,
				/datum/surgery_step/mechanic_close)
	requires_bodypart_type = BODYPART_ROBOTIC
	lying_required = FALSE
	self_operable = TRUE

//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "excise damaged lung node"
	implements = list(TOOL_SCALPEL = 95, /obj/item/melee/transforming/energy/sword = 65, /obj/item/kitchen/knife = 45,
		/obj/item/shard = 35)
	time = 4.2 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	fuckup_damage = 20

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to make an incision in [target]'s lungs..."),
		"[user] begins to make an incision in [target].",
		"[user] begins to make an incision in [target].")

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/lungs/L = H.getorganslot(ORGAN_SLOT_LUNGS)
		L.operated = TRUE
		H.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(user, target, span_notice("You successfully excise [H]'s most damaged lobe."),
			"Successfully removes a piece of [H]'s lungs.",
			"")
	return TRUE

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/lungs/L = H.getorganslot(ORGAN_SLOT_LUNGS)
		L.operated = TRUE
		H.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
		H.losebreath += 4
		display_results(user, target, span_warning("You screw up, failing to excise [H]'s damaged lobe!"),
			span_warning("[user] screws up!"),
			span_warning("[user] screws up!"))
	return FALSE
