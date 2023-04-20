/*
procs:

handle_charge - called in spec_life(),handles the alert indicators,the power loss death and decreasing the charge level
adjust_charge - take a positive or negative value to adjust the charge level
*/

/datum/species/preternis
	name = "Preternis"
	plural_form = "Preterni"
	id = "preternis"
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	inherent_traits = list(TRAIT_NOHUNGER, TRAIT_RADIMMUNE, TRAIT_MEDICALIGNORE) //Medical Ignore doesn't prevent basic treatment,only things that cannot help preternis,such as cryo and medbots
	species_traits = list(DYNCOLORS, EYECOLOR, HAIR, LIPS, AGENDER, NOHUSK, ROBOTIC_LIMBS, DIGITIGRADE)//they're fleshy metal machines, they are efficient, and the outside is metal, no getting husked
	inherent_biotypes = list(MOB_ORGANIC, MOB_ROBOTIC, MOB_HUMANOID)
	sexes = FALSE //they're basically ken dolls, come straight out of a printer
	no_equip = list(SLOT_SHOES)//this is just easier than using the digitigrade trait for now, making them digitigrade is part of the sprite rework pr
	say_mod = "intones"
	attack_verb = "assault"
	skinned_type = /obj/item/stack/sheet/plasteel{amount = 5} //coated in plasteel
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/synthmeat
	exotic_bloodtype = "U" //synthetic blood that works for literally everyone
	toxic_food = NONE
	liked_food = FRIED | SUGAR | JUNKFOOD
	disliked_food = GROSS | VEGETABLES
	brutemod = 0.9 //Have you ever punched a metal plate?
	burnmod = 1.1 //The plasteel has a really high heat capacity, however, if the heat does get through it will REALLY burn the flesh on the inside
	coldmod = 3 //The plasteel around them saps their body heat quickly if it gets cold
	heatmod = 2 //Once the heat gets through it's gonna BURN
	tempmod = 0.1 //The high heat capacity of the plasteel makes it take far longer to heat up or cool down
	stunmod = 1.1 //Big metal body has difficulty getting back up if it falls down
	staminamod = 1.1 //Big metal body has difficulty holding it's weight if it gets tired
	action_speed_coefficient = 0.9 //worker drone do the fast
	punchdamagelow = 2 //if it hits you, it's always gonna hurt
	punchdamagehigh = 8 //not built for large high speed acts like punches
	punchstunthreshold = 7 //if they get a good punch off, you're still seeing lights
	siemens_coeff = 1.75 //Circuits REALLY don't like extra electricity flying around
	payday_modifier = 0.6 //Highly efficient workers, but significant political tension between SIC and Remnants = next to no protection or people willing to fight the obvious wage cut
	//mutant_bodyparts = list("head", "body_markings")
	mutanteyes = /obj/item/organ/eyes/robotic/preternis
	mutantlungs = /obj/item/organ/lungs/preternis
	mutantstomach = /obj/item/organ/stomach/preternis
	yogs_virus_infect_chance = 20
	virus_resistance_boost = 10 //YEOUTCH,good luck getting it out
	special_step_sounds = list('sound/effects/footstep/catwalk1.ogg', 'sound/effects/footstep/catwalk2.ogg', 'sound/effects/footstep/catwalk3.ogg', 'sound/effects/footstep/catwalk4.ogg')
	attack_sound = 'sound/items/trayhit2.ogg'
	//deathsound = //change this when sprite gets reworked
	yogs_draw_robot_hair = TRUE //remove their hair when they get the new sprite
	screamsound = 'goon/sound/robot_scream.ogg' //change this when sprite gets reworked
	wings_icon = "Robotic" //maybe change this eventually
	species_language_holder = /datum/language_holder/machine
	//new variables
	var/datum/action/innate/maglock/maglock
	var/lockdown = FALSE
	var/charge = PRETERNIS_LEVEL_FULL
	var/eating_msg_cooldown = FALSE
	var/emag_lvl = 0
	var/power_drain = 0.5 //probably going to have to tweak this shit
	var/tesliumtrip = FALSE
	var/draining = FALSE
	var/soggy = FALSE

	smells_like = "lemony steel"

/datum/species/preternis/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	fixed_mut_color = C.dna.features["pretcolor"]

	for (var/obj/item/bodypart/BP in C.bodyparts)
		BP.render_like_organic = TRUE 	// Makes limbs render like organic limbs instead of augmented limbs, check bodyparts.dm
		BP.burn_reduction = 2
		BP.brute_reduction = 1
		if(istype(BP,/obj/item/bodypart/l_arm) || istype(BP,/obj/item/bodypart/r_arm))
			BP.max_damage = 40
			continue
		if(istype(BP,/obj/item/bodypart/l_leg) || istype(BP,/obj/item/bodypart/r_leg))//my dudes skip leg day
			BP.max_damage = 30

	RegisterSignal(C, COMSIG_MOB_ALTCLICKON, .proc/drain_power_from)

	if(ishuman(C))
		maglock = new
		maglock.Grant(C)
		lockdown = FALSE
		
	C.AddComponent(/datum/component/empprotection, EMP_PROTECT_SELF)

/datum/species/preternis/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for (var/V in C.bodyparts)
		var/obj/item/bodypart/BP = V
		BP.change_bodypart_status(ORGAN_ORGANIC,FALSE,TRUE)
		BP.burn_reduction = initial(BP.burn_reduction)
		BP.brute_reduction = initial(BP.brute_reduction)

	UnregisterSignal(C, COMSIG_MOB_ALTCLICKON)
		
	var/datum/component/empprotection/empproof = C.GetExactComponent(/datum/component/empprotection)
	empproof.RemoveComponent()//remove emp proof if they stop being a preternis

	C.clear_alert("preternis_emag") //this means a changeling can transform from and back to a preternis to clear the emag status but w/e i cant find a solution to not do that
	C.clear_fullscreen("preternis_emag")
	C.remove_movespeed_modifier("preternis_teslium")
	C.remove_movespeed_modifier("preternis_water")
	C.remove_movespeed_modifier("preternis_maglock")

	if(lockdown)
		maglock.Trigger(TRUE)
	if(maglock)
		maglock.Remove(C)


/datum/action/innate/maglock
	var/datum/species/preternis/owner_species
	var/lockdown = FALSE
	name = "Maglock"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "magboots0"
	icon_icon = 'icons/obj/clothing/shoes.dmi'
	background_icon_state = "bg_default"

/datum/action/innate/maglock/Grant(mob/M)
	if(!ispreternis(M))
		return
	var/mob/living/carbon/human/H = M 
	owner_species = H.dna.species
	. = ..()

/datum/action/innate/maglock/Trigger(silent = FALSE)
	var/mob/living/carbon/human/H = usr
	if(!lockdown)
		ADD_TRAIT(H, TRAIT_NOSLIPWATER, "preternis_maglock")
		ADD_TRAIT(H, TRAIT_NOSLIPICE, "preternis_maglock")
		button_icon_state = "magboots1"
	else
		REMOVE_TRAIT(H, TRAIT_NOSLIPWATER, "preternis_maglock")
		REMOVE_TRAIT(H, TRAIT_NOSLIPICE, "preternis_maglock")
		button_icon_state = "magboots0"
	UpdateButtonIcon()
	lockdown = !lockdown
	owner_species.lockdown = !owner_species.lockdown
	if(!silent)
		to_chat(H, span_notice("You [lockdown ? "enable" : "disable"] your mag-pulse traction system."))
	H.update_gravity(H.has_gravity())

/datum/species/preternis/negates_gravity(mob/living/carbon/human/H)
	return (..() || lockdown)

/datum/species/preternis/has_heavy_gravity()
	return (..() || lockdown)

/datum/species/preternis/spec_emag_act(mob/living/carbon/human/H, mob/user)
	. = ..()
	if(emag_lvl == 2)
		return
	emag_lvl = min(emag_lvl + 1,2)
	playsound(H.loc, 'sound/machines/warning-buzzer.ogg', 50, 1, 1)
	H.Paralyze(60)
	switch(emag_lvl)
		if(1)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50) //HALP AM DUMB
			to_chat(H,span_danger("ALERT! MEMORY UNIT [rand(1,5)] FAILURE.NERVEOUS SYSTEM DAMAGE."))
		if(2)
			H.overlay_fullscreen("preternis_emag", /atom/movable/screen/fullscreen/high)
			H.throw_alert("preternis_emag", /atom/movable/screen/alert/high/preternis)
			to_chat(H,span_danger("ALERT! OPTIC SENSORS FAILURE.VISION PROCESSOR COMPROMISED."))

/datum/species/preternis/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	. = ..()

	if(H.reagents.has_reagent(/datum/reagent/oil))
		H.adjustFireLoss(-2*REAGENTS_EFFECT_MULTIPLIER,FALSE,FALSE, BODYPART_ANY)

	if(H.reagents.has_reagent(/datum/reagent/teslium))
		H.add_movespeed_modifier("preternis_teslium", update=TRUE, priority=101, multiplicative_slowdown=-3, blacklisted_movetypes=(FLYING|FLOATING))
		H.adjustOxyLoss(-2*REAGENTS_EFFECT_MULTIPLIER)
		H.adjustBruteLoss(-2*REAGENTS_EFFECT_MULTIPLIER,FALSE,FALSE, BODYPART_ANY)
		H.adjustFireLoss(-2*REAGENTS_EFFECT_MULTIPLIER,FALSE,FALSE, BODYPART_ANY)
		H.AdjustParalyzed(-3)
		H.AdjustStun(-3)
		H.AdjustKnockdown(-3)
		H.adjustStaminaLoss(-5*REAGENTS_EFFECT_MULTIPLIER)
		charge = clamp(charge + 10 * REAGENTS_METABOLISM, PRETERNIS_LEVEL_NONE, PRETERNIS_LEVEL_FULL)//more power charges you, why would it drain you
		burnmod = 10
		tesliumtrip = TRUE

	if (istype(chem,/datum/reagent/consumable))
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			var/nutrition = food.nutriment_factor * 0.2
			charge = clamp(charge + nutrition,PRETERNIS_LEVEL_NONE,PRETERNIS_LEVEL_FULL)
			if (!eating_msg_cooldown)
				eating_msg_cooldown = TRUE
				addtimer(VARSET_CALLBACK(src, eating_msg_cooldown, FALSE), 2 MINUTES)
				to_chat(H,span_info("NOTICE: Digestive subroutines are inefficient. Seek sustenance via power-cell C.O.N.S.U.M.E. technology induction."))

	if(chem.current_cycle >= 20)
		H.reagents.del_reagent(chem.type)

	return FALSE

/datum/species/preternis/spec_fully_heal(mob/living/carbon/human/H)
	. = ..()
	charge = PRETERNIS_LEVEL_FULL
	emag_lvl = 0
	H.clear_alert("preternis_emag")
	H.clear_fullscreen("preternis_emag")
	burnmod = initial(burnmod)
	tesliumtrip = FALSE
	H.remove_movespeed_modifier("preternis_teslium") //full heal removes chems so it wont update the teslium speed up until they eat something

/datum/species/preternis/movement_delay(mob/living/carbon/human/H)
	. = ..()

	if(lockdown && !HAS_TRAIT(H, TRAIT_IGNORESLOWDOWN) && H.has_gravity())
		H.add_movespeed_modifier("preternis_magboot", update=TRUE, priority=100, multiplicative_slowdown=1, blacklisted_movetypes=(FLYING|FLOATING))
	else if(H.has_movespeed_modifier("preternis_magboot"))
		H.remove_movespeed_modifier("preternis_magboot")
	
/datum/species/preternis/spec_life(mob/living/carbon/human/H)
	. = ..()

	if(tesliumtrip && !H.reagents.has_reagent(/datum/reagent/teslium))//remove teslium effects if you don't have it in you
		burnmod = initial(burnmod)
		tesliumtrip = FALSE
		H.remove_movespeed_modifier("preternis_teslium")

	if(H.stat == DEAD)
		return

	handle_wetness(H)	
	handle_charge(H)

/datum/species/preternis/proc/handle_wetness(mob/living/carbon/human/H)	
	if(H.fire_stacks <= -1 && (H.calculate_affecting_pressure(300) == 300 || soggy))//putting on a suit helps, but not if you're already wet
		H.fire_stacks++ //makes them dry off faster so it's less tedious, more punchy
		H.add_movespeed_modifier("preternis_water", update = TRUE, priority = 102, multiplicative_slowdown = 4, blacklisted_movetypes=(FLYING|FLOATING))
		//damage has a flat amount with an additional amount based on how wet they are
		H.adjustStaminaLoss(11 - (H.fire_stacks / 2))
		H.adjustFireLoss(5 - (H.fire_stacks / 2))
		H.Jitter(100)
		H.stuttering = 1
		if(!soggy)//play once when it starts
			H.emote("scream")
			to_chat(H, span_userdanger("Your entire being screams in agony as your wires short from getting wet!"))
		soggy = TRUE
		H.throw_alert("preternis_wet", /atom/movable/screen/alert/preternis_wet)
	else if(soggy)
		H.remove_movespeed_modifier("preternis_water")
		to_chat(H, "You breathe a sigh of relief as you dry off.")
		soggy = FALSE
		H.clear_alert("preternis_wet")
		H.jitteriness -= 100

/datum/species/preternis/proc/handle_charge(mob/living/carbon/human/H)
	var/chargemod = 1 //TRAIT_BOTTOMLESS_STOMACH isn't included because preternis charge doesn't work that way
	if(HAS_TRAIT(H, TRAIT_EAT_LESS))
		chargemod *= 0.75 //power consumption rate reduced by about 25%
	if(HAS_TRAIT(H, TRAIT_EAT_MORE))
		chargemod *= 3 //hunger rate tripled
	charge = clamp(charge - (power_drain * chargemod),PRETERNIS_LEVEL_NONE,PRETERNIS_LEVEL_FULL)

	if(charge == PRETERNIS_LEVEL_NONE)
		to_chat(H,span_danger("Warning! System power criti-$#@$"))
		H.death()
	else if(charge < PRETERNIS_LEVEL_STARVING)
		H.throw_alert("preternis_charge", /atom/movable/screen/alert/preternis_charge, 3)
	else if(charge < PRETERNIS_LEVEL_HUNGRY)
		H.throw_alert("preternis_charge", /atom/movable/screen/alert/preternis_charge, 2)
	else if(charge < PRETERNIS_LEVEL_FED)
		H.throw_alert("preternis_charge", /atom/movable/screen/alert/preternis_charge, 1)
	else
		H.clear_alert("preternis_charge")

/datum/species/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)//make them attack slower
	. = ..()
	if(!ispreternis(user) || attacker_style?.nonlethal || (user.gloves && istype(user.gloves, /obj/item/clothing/gloves/rapid)) || (user.mind.martial_art.type in subtypesof(/datum/martial_art)))
		return	
	user.next_move += 2 //adds 0.2 second delay to combat

/datum/species/preternis/has_toes()//their toes are mine, they shall never have them back
	return FALSE

/datum/species/preternis/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	// called before a projectile hit
	if(istype(P, /obj/item/projectile/energy/nuclear_particle))
		H.fire_nuclear_particle()
		H.visible_message(span_danger("[P] deflects off of [H]!"), span_userdanger("[P] deflects off of you!"))
		return 1
	return 0

/datum/species/preternis/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_preternis_name()
	return preternis_name()

/datum/species/preternis/get_features()
	var/list/features = ..()

	features += "feature_pretcolor"

	return features

/datum/species/preternis/get_species_description()
	return "Sentient tools left by the bygone Vxtvul Empire, preterni are a complex weaving of flesh and \
		cybernetics encased in a plasteel shell. Now left to their own devices among the forgotten ruins of their old civilization, \
		the preterni have formed their own nation and have established tense but stable relations with the SIC."

/datum/species/preternis/get_species_lore()
	return list(
		"Preterni were built by the Vxtrin to work in hazardous environments with minimal monitoring. Combining \
		the durability of metal with the versatility of organic matter, preterni worked in factories, engines, \
		and research facilities, enduring radiations, toxins, and extreme temperature- similarly to the silicon \
		units of this time, while able to adapt and improvise when faced with new problems and changing environments.",

		"Approximately seventeen millennia ago, the entire Vxtrin population disappeared along with the preterni, \
		leaving only deactivated factories and abandoned facilities. The first preternis factory was reactivated by \
		accident in 2431 by SIC colonists on the planet of Ur'lan. Communication between the newly-created preterni \
		and the colonists was made possible by the silicon units built using the MMI technology that had been uncovered \
		previously in Vxtvul ruins. Upon hearing of the discovery of preterni on Ur'lan, Nanotrasen immediately \
		bought the property of the colony for more than a thousand time its original value and attempted to claim \
		the preterni as their property. The scheme was unsuccessful and preterni formed the Remnants of Vxtvul as \
		a unifying government",

		"The SIC decided it was best if preterni and humanity worked together to uncover the secrets of the Vxtrin. \
		While SIC authorities desired an alliance, several groups and companies pillaged or sabotaged Vxtvul ruins \
		before the preterni could recover them, destroying hardware and stealing technologies. Such acts outraged \
		the Remnants and have led to great tension between them and the SIC. Using Vxtvul technology, the preterni \
		developed a navy and ground military forces to defend their ruins from scavengers, and while humans are \
		accepted among Remnant territories and stations, they are monitored constantly.",

		"Preterni strive for excellence and tend to be extremely work-focused. They tend to be slightly distrustful \
		of humans and prefer to rely on themselves for any important task. As silicon units are derived from Vxtrin \
		technology, preterni tend to have some affection and respect for them, even though silicon lawsets can mean \
		these relationships are one-sided.",

		"Preternis culture was lost for the most part along with their masters. Current customs involve was recovered \
		through archeological works, perpetuated in remembrance of the golden age when Vxtrin were still with them, \
		then combined with human practices that have been adopted due to the species' proximity to humanity. \
		Preterni have no hair naturally, but many have installed synthetic hairs on their head to better \
		differentiate themselves and mimic humans.",

		"The SIC and the Remnants are still wary of each others, but they nonetheless exchange goods, \
		and travel between the two empire is relatively unhindered. Preterni can be seen working in SIC \
		space, often hired to work in hazardous environments. Some join exploration crews and travel to far \
		away facilities in the hopes of stumbling upon ruins of their fallen empire.",
	)

/datum/species/preternis/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "cookie-bite",
			SPECIES_PERK_NAME = "Stone eater",
			SPECIES_PERK_DESC = "Preterni can eat ores to replenish their metal skin. All ores are not created equal.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "thunderstorm", //if we update font awesome, please swap to bolt-slash
			SPECIES_PERK_NAME = "Faraday \"Skin\"",
			SPECIES_PERK_DESC = "Being incased in plasteel rather than standard metal allows Preterni to be completely unaffected by EMPs.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "charging-station", //would prefer battery-bolt, but it doesn't show up
			SPECIES_PERK_NAME = "Plug-n-Play",
			SPECIES_PERK_DESC = "Preterni run off electricity rather than food.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "flask",
			SPECIES_PERK_NAME = "Chemical Purge",
			SPECIES_PERK_DESC = "Preterni will purge any foreign chemicals after a short time of them being in the blood stream.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "droplet-slash",
			SPECIES_PERK_NAME = "Keep Dry",
			SPECIES_PERK_DESC = "Preterni have exposed circuitry under cracks in their body, if water gets in they will short, causing weakness in the limbs and burns.",
		),
	)

	return to_add

/datum/species/preternis/create_pref_biotypes_perks()
	var/list/to_add = list()

	// TODO

	return to_add
