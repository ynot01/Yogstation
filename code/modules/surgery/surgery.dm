/datum/surgery
	var/name = "surgery"
	var/desc = "surgery description"
	var/icon = 'icons/misc/surgery_icons.dmi'
	var/icon_state
	/// Determines what overlay to apply to the surgery icon
	var/tier = "0"
	var/status = 1
	/// Steps in a surgery
	var/list/steps = list()
	/// Actively performing a Surgery
	var/step_in_progress = 0
	/// Can cancel this surgery after step 1 with cautery
	var/can_cancel = 1
	/// Acceptable Species
	var/list/target_mobtypes = list(/mob/living/carbon/human)
	/// Surgery location
	var/location = BODY_ZONE_CHEST
	/// Prevents you from performing an operation on incorrect limbs. FALSE for any limb type
	var/requires_bodypart_type = BODYPART_ORGANIC
	/// Multiple locations
	var/list/possible_locs = list()
	/// If this surgery ignores clothes
	var/ignore_clothes = 0
	/// Operation target mob
	var/mob/living/carbon/target
	/// Operable body part
	var/obj/item/bodypart/operated_bodypart
	/// The actual wound datum instance we're targeting
	var/datum/wound/operated_wound
	/// The wound type this surgery targets
	var/datum/wound/targetable_wound
	/// Surgery available only when a bodypart is present, or only when it is missing.
	var/requires_bodypart = TRUE
	/// Step success propability multiplier
	var/success_multiplier = 0
	/// Some surgeries don't work on limbs that don't really exist
	var/requires_real_bodypart = 0
	/// Does the vicitm needs to be lying down.
	var/lying_required = TRUE
	/// Can the surgery be performed on yourself.
	var/self_operable = FALSE
	/// Handles techweb-oriented surgeries, previously restricted to the /advanced subtype (You still need to add designs)
	var/requires_tech = FALSE
	/// Type; doesn't show up if this type exists. Set to /datum/surgery if you want to hide a "base" surgery (useful for typing parents IE healing.dm just make sure to null it out again)
	var/replaced_by

/datum/surgery/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(surgery_target)
		target = surgery_target
		target.surgeries += src
		if(surgery_location)
			location = surgery_location
		if(surgery_bodypart)
			operated_bodypart = surgery_bodypart
			if(targetable_wound)
				operated_wound = operated_bodypart.get_wound_type(targetable_wound)
				operated_wound.attached_surgery = src

/datum/surgery/Destroy()
	if(operated_wound)
		operated_wound.attached_surgery = null
	if(target)
		target.surgeries -= src
	target = null
	operated_bodypart = null
	return ..()


/datum/surgery/proc/can_start(mob/user, mob/living/target) //FALSE to not show in list
	. = TRUE
	if(replaced_by == /datum/surgery)
		return FALSE

	if(HAS_TRAIT(user, TRAIT_SURGEON) || HAS_TRAIT(user.mind, TRAIT_SURGEON))
		if(replaced_by)
			return FALSE
		else
			return TRUE

	if(!requires_tech && !replaced_by)
		return TRUE
	// True surgeons (like abductor scientists) need no instructions

	if(requires_tech)
		. = FALSE

	var/turf/T = get_turf(target)
	var/list/adv_surgeries = list()

	//Get the surgery bed component and adds available surgeries to the list
	var/datum/component/surgery_bed/SB
	for(var/obj/op_table in T.GetAllContents())
		SB = op_table.GetComponent(/datum/component/surgery_bed)
		if(istype(SB))
			break

	if(istype(SB))
		adv_surgeries |= SB.get_surgeries()

	//Get the advanced health analyzer in the off hand or pockets if available and adds available surgeries to the list
	var/analyzerlocations = list(user.get_inactive_held_item(), user.get_item_by_slot(SLOT_L_STORE), user.get_item_by_slot(SLOT_R_STORE))
	var/obj/item/healthanalyzer/advanced/adv = locate() in analyzerlocations
	if(iscyborg(user) && !istype(adv))
		var/mob/living/silicon/robot/R = user
		adv = locate() in R.module.modules

	if(istype(adv))
		adv_surgeries |= adv.advanced_surgeries

	var/obj/item/rod_of_asclepius/snakestick = user.get_inactive_held_item() //this would be in the inactive hand, unless we let it start surgeries
	if(istype(snakestick))
		adv_surgeries |= snakestick.advanced_surgeries

	//Get the advanced health analyzer in the off had if available and adds available surgeries to the list
	if(replaced_by in adv_surgeries)
		return FALSE
	if(type in adv_surgeries)
		return TRUE

/datum/surgery/proc/next_step(mob/user, intent)
	if(location != user.zone_selected)
		return FALSE
	if(step_in_progress)
		return TRUE

	var/try_to_fail = FALSE
	if(intent == INTENT_DISARM)
		try_to_fail = TRUE

	var/datum/surgery_step/S = get_surgery_step()
	if(S)
		var/obj/item/tool = user.get_active_held_item()
		if(S.try_op(user, target, user.zone_selected, tool, src, try_to_fail))
			return TRUE
		if(tool)
			if(tool.tool_behaviour == TOOL_CAUTERY || (requires_bodypart_type == BODYPART_ROBOTIC && tool.tool_behaviour == TOOL_SCREWDRIVER))
				// Cancel the surgery if a cautery/screwdriver is used AND it's not the tool used in the next step.
				attempt_cancel_surgery(src, tool, target, user)
				return TRUE
			if(tool.item_flags & SURGICAL_TOOL) //Just because you used the wrong tool it doesn't mean you meant to whack the patient with it
				to_chat(user, span_warning("This step requires a different tool!"))
				return TRUE
	return FALSE

/datum/surgery/proc/get_surgery_step()
	var/step_type = steps[status]
	return new step_type

/datum/surgery/proc/get_surgery_next_step()
	if(status < steps.len)
		var/step_type = steps[status + 1]
		return new step_type
	else
		return null

/datum/surgery/proc/complete()
	SSblackbox.record_feedback("tally", "surgeries_completed", 1, type)
	qdel(src)

/datum/surgery/proc/get_probability_multiplier()
	var/probability = 0.5
	var/turf/T = get_turf(target)

	for(var/obj/op_table in T.GetAllContents())
		var/datum/component/surgery_bed/SB = op_table.GetComponent(/datum/component/surgery_bed)
		if(SB)
			probability = SB.success_chance
			break

	return probability + success_multiplier

/datum/surgery/proc/get_icon()
	var/mutable_appearance/new_icon = mutable_appearance(icon, icon_state)
	new_icon.add_overlay(image('icons/misc/surgery_icons.dmi', icon_state = tier))
	if(requires_bodypart_type == BODYPART_ROBOTIC)
		new_icon.add_overlay(image('icons/misc/surgery_icons.dmi', "robotic"))
	return new_icon

/datum/surgery/advanced
	name = "advanced surgery"
	requires_tech = TRUE

/obj/item/disk/surgery
	name = "Surgery Procedure Disk"
	desc = "A disk that contains advanced surgery procedures, must be loaded into an Operating Console."
	icon_state = "datadisk1"
	materials = list(/datum/material/iron=300, /datum/material/glass=100)
	var/list/surgeries

/obj/item/disk/surgery/debug
	name = "Debug Surgery Disk"
	desc = "A disk that contains all existing surgery procedures."
	icon_state = "datadisk1"
	materials = list(/datum/material/iron=300, /datum/material/glass=100)

/obj/item/disk/surgery/debug/Initialize()
	. = ..()
	surgeries = list()
	var/list/req_tech_surgeries = subtypesof(/datum/surgery)
	for(var/i in req_tech_surgeries)
		var/datum/surgery/beep = i
		if(initial(beep.requires_tech))
			surgeries += beep

//INFO
//Check /mob/living/carbon/attackby for how surgery progresses, and also /mob/living/carbon/attack_hand.
//As of Feb 21 2013 they are in code/modules/mob/living/carbon/carbon.dm, lines 459 and 51 respectively.
//Other important variables are var/list/surgeries (/mob/living) and var/list/internal_organs (/mob/living/carbon)
// var/list/bodyparts (/mob/living/carbon/human) is the LIMBS of a Mob.
//Surgical procedures are initiated by attempt_initiate_surgery(), which is called by surgical drapes and bedsheets.


//TODO
//specific steps for some surgeries (fluff text)
//more interesting failure options
//randomised complications
//more surgeries!
//add a probability modifier for the state of the surgeon- health, twitching, etc. blindness, god forbid.
//helper for converting a zone_sel.selecting to body part (for damage)


//RESOLVED ISSUES //"Todo" jobs that have been completed
//combine hands/feet into the arms - Hands/feet were removed - RR
//surgeries (not steps) that can be initiated on any body part (corresponding with damage locations) - Call this one done, see possible_locs var - c0
