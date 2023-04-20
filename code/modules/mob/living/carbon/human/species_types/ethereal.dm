#define ETHEREAL_COLORS list("#00ffff", "#ffc0cb", "#9400D3", "#4B0082", "#0000FF", "#00FF00", "#FFFF00", "#FF7F00", "#FF0000")

/datum/species/ethereal
	name = "Ethereal"
	id = "ethereal"
	attack_verb = "burn"
	attack_sound = 'sound/weapons/etherealhit.ogg'
	miss_sound = 'sound/weapons/etherealmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ethereal
	mutantstomach = /obj/item/organ/stomach/ethereal
	exotic_blood = /datum/reagent/consumable/liquidelectricity //Liquid Electricity. fuck you think of something better gamer
	siemens_coeff = 0.5 //They thrive on energy
	brutemod = 1.5 //Don't rupture their membranes
	burnmod = 0.8 //Bodies are resilient to heat and energy
	heatmod = 0.5 //Bodies are resilient to heat and energy
	coldmod = 2.0 //Don't extinguish the stars
	speedmod = -0.1 //Light and energy move quickly
	punchdamagehigh  = 11 //Fire hand more painful
	punchstunthreshold = 11 //Still stuns on max hit, but subsequently lower chance to stun overall
	payday_modifier = 0.7 //Moths have to be compensated slightly more to be willing to work for NT bcuz drug therapy, both ethereal and moth are neutral though
	attack_type = BURN //burn bish
	damage_overlay_type = "" //We are too cool for regular damage overlays
	species_traits = list(NOEYESPRITES, EYECOLOR, DYNCOLORS, AGENDER, HAIR, FACEHAIR, HAS_FLESH, HAS_BONE) // i mean i guess they have blood so they can have wounds too
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	inherent_traits = list(TRAIT_NOHUNGER)
	mutant_bodyparts = list("ethereal_mark")
	default_features = list("ethereal_mark" = "Eyes")
	species_language_holder = /datum/language_holder/ethereal
	deathsound = 'yogstation/sound/voice/ethereal/deathsound.ogg'
	screamsound = list('sound/voice/ethereal/ethereal_scream_1.ogg', 'sound/voice/ethereal/ethereal_scream_2.ogg', 'sound/voice/ethereal/ethereal_scream_3.ogg')
	sexes = FALSE //no fetish content allowed
	toxic_food = NONE
	inert_mutation = SHOCKTOUCH
	hair_color = "fixedmutcolor"
	hair_alpha = 140
	swimming_component = /datum/component/swimming/ethereal

	var/current_color
	var/EMPeffect = FALSE
	var/emageffect = FALSE
	var/r1
	var/g1
	var/b1
	var/static/r2 = 237
	var/static/g2 = 164
	var/static/b2 = 149
	//this is shit but how do i fix it? no clue.

	smells_like = "crackling sweetness"

	var/obj/effect/dummy/lighting_obj/ethereal_light


/datum/species/ethereal/Destroy(force)
	if(ethereal_light)
		QDEL_NULL(ethereal_light)
	return ..()


/datum/species/ethereal/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	if(!ishuman(C))
		return

	var/mob/living/carbon/human/ethereal = C
	default_color = "#[ethereal.dna.features["ethcolor"]]"
	r1 = GETREDPART(default_color)
	g1 = GETGREENPART(default_color)
	b1 = GETBLUEPART(default_color)
	ethereal_light = ethereal.mob_light()
	spec_updatehealth(ethereal)

/datum/species/ethereal/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	QDEL_NULL(ethereal_light)
	C.set_light(0)
	return ..()

/datum/species/ethereal/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_ethereal_name()

	var/randname = ethereal_name()

	return randname

/datum/species/ethereal/spec_updatehealth(mob/living/carbon/human/H)
	. = ..()
	if(H.stat != DEAD && !EMPeffect)
		var/healthpercent = max(H.health, 0) / 100
		var/light_range = 1 + (4 * healthpercent)
		var/light_power = 1 + healthpercent
		if(!emageffect)
			current_color = rgb(r2 + ((r1-r2)*healthpercent), g2 + ((g1-g2)*healthpercent), b2 + ((b1-b2)*healthpercent))
		H.set_light(light_range + 1, 0.1, current_color)//this just controls actual view range, not the overlay
		ethereal_light.set_light_range_power_color(light_range, light_power, current_color)
		ethereal_light.set_light_on(TRUE)
		fixed_mut_color = copytext_char(current_color, 2)
	else
		H.set_light(0)
		ethereal_light.set_light_on(FALSE)
		fixed_mut_color = rgb(128,128,128)
	H.update_body()

/datum/species/ethereal/spec_emp_act(mob/living/carbon/human/H, severity)
	.=..()
	EMPeffect = TRUE
	spec_updatehealth(H)
	to_chat(H, span_notice("You feel the light of your body leave you."))
	switch(severity)
		if(EMP_LIGHT)
			addtimer(CALLBACK(src, .proc/stop_emp, H), 100, TIMER_UNIQUE|TIMER_OVERRIDE) //We're out for 10 seconds
		if(EMP_HEAVY)
			addtimer(CALLBACK(src, .proc/stop_emp, H), 200, TIMER_UNIQUE|TIMER_OVERRIDE) //We're out for 20 seconds

/datum/species/ethereal/spec_emag_act(mob/living/carbon/human/H, mob/user)
	if(emageffect)
		return
	emageffect = TRUE
	to_chat(user, span_notice("You tap [H] on the back with your card."))
	H.visible_message(span_danger("[H] starts flickering in an array of colors!"))
	handle_emag(H)
	addtimer(CALLBACK(src, .proc/stop_emag, H), 300, TIMER_UNIQUE|TIMER_OVERRIDE) //Disco mode for 30 seconds! This doesn't affect the ethereal at all besides either annoying some players, or making someone look badass.


/datum/species/ethereal/spec_life(mob/living/carbon/human/H)
	.=..()
	if(H.stat == DEAD)
		return
	handle_charge(H)


/datum/species/ethereal/proc/stop_emp(mob/living/carbon/human/H)
	EMPeffect = FALSE
	spec_updatehealth(H)
	to_chat(H, span_notice("You feel more energized as your shine comes back."))


/datum/species/ethereal/proc/handle_emag(mob/living/carbon/human/H)
	if(!emageffect)
		return
	current_color = pick(ETHEREAL_COLORS)
	spec_updatehealth(H)
	addtimer(CALLBACK(src, .proc/handle_emag, H), 5) //Call ourselves every 0.5 seconds to change color

/datum/species/ethereal/proc/stop_emag(mob/living/carbon/human/H)
	emageffect = FALSE
	spec_updatehealth(H)
	H.visible_message(span_danger("[H] stops flickering and goes back to their normal state!"))

/datum/species/ethereal/proc/handle_charge(mob/living/carbon/human/H)
	brutemod = 1.25
	switch(get_charge(H))
		if(ETHEREAL_CHARGE_NONE)
			H.throw_alert("ethereal_charge", /atom/movable/screen/alert/etherealcharge, 3)
		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			H.throw_alert("ethereal_charge", /atom/movable/screen/alert/etherealcharge, 2)
			if(H.health > 10.5)
				apply_damage(0.65, TOX, null, null, H)
			brutemod = 1.75
		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			H.throw_alert("ethereal_charge", /atom/movable/screen/alert/etherealcharge, 1)
			brutemod = 1.5
		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			H.throw_alert("ethereal_overcharge", /atom/movable/screen/alert/ethereal_overcharge, 1)
			brutemod = 1.5
		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			H.throw_alert("ethereal_overcharge", /atom/movable/screen/alert/ethereal_overcharge, 2)
			brutemod = 1.75
			if(prob(10)) //10% each tick for ethereals to explosively release excess energy if it reaches dangerous levels
				discharge_process(H)
		else
			H.clear_alert("ethereal_charge")
			H.clear_alert("ethereal_overcharge")

/datum/species/ethereal/proc/discharge_process(mob/living/carbon/human/H)
	to_chat(H, "<span class='warning'>You begin to lose control over your charge!</span>")
	H.visible_message("<span class='danger'>[H] begins to spark violently!</span>")
	var/static/mutable_appearance/overcharge //shameless copycode from lightning spell copied from another codebase copied from another codebase
	overcharge = overcharge || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
	H.add_overlay(overcharge)
	if(do_mob(H, H, 50, 1))
		H.flash_lighting_fx(5, 7, current_color)
		var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
		playsound(H, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
		H.cut_overlay(overcharge)
		tesla_zap(H, 2, (stomach.crystal_charge / ETHEREAL_CHARGE_SCALING_MULTIPLIER) * 20, TESLA_OBJ_DAMAGE | TESLA_MOB_DAMAGE | TESLA_ALLOW_DUPLICATES)
		if(istype(stomach))
			stomach.adjust_charge(ETHEREAL_CHARGE_FULL - stomach.crystal_charge)
		to_chat(H, "<span class='warning'>You violently discharge energy!</span>")
		H.visible_message("<span class='danger'>[H] violently discharges energy!</span>")
		if(prob(10)) //chance of developing heart disease to dissuade overcharging oneself
			var/datum/disease/D = new /datum/disease/heart_failure
			H.ForceContractDisease(D)
			to_chat(H, "<span class='userdanger'>You're pretty sure you just felt your heart stop for a second there..</span>")
			H.playsound_local(H, 'sound/effects/singlebeat.ogg', 100, 0)
		H.Paralyze(100)
		return

/datum/species/ethereal/proc/get_charge(mob/living/carbon/H) //this feels like it should be somewhere else. Eh?
	var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		return stomach.crystal_charge
	return ETHEREAL_CHARGE_NONE

/datum/species/ethereal/get_features()
	var/list/features = ..()

	features += "feature_ethcolor"

	return features

/datum/species/ethereal/get_species_description()
	return /*"Coming from the planet of Sprout, the theocratic ethereals are \
		separated socially by caste, and espouse a dogma of aiding the weak and \
		downtrodden."*/

/datum/species/ethereal/get_species_lore()
	return list("TBD",/*
		"Ethereals are a species native to the planet Sprout. \
		When they were originally discovered, they were at a medieval level of technological progression, \
		but due to their natural acclimation with electricity, they felt easy among the large NanoTrasen installations.",
	*/)

/datum/species/ethereal/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Shockingly Tasty",
			SPECIES_PERK_DESC = "Ethereals can feed on electricity from APCs, and do not otherwise need to eat.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "lightbulb",
			SPECIES_PERK_NAME = "Disco Ball",
			SPECIES_PERK_DESC = "Ethereals passively generate their own light.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "biohazard",
			SPECIES_PERK_NAME = "Starving Artist",
			SPECIES_PERK_DESC = "Ethereals take toxin damage while starving.",
		),
	)

	return to_add
