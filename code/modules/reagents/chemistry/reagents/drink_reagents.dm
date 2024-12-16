

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/consumable/orangejuice
	name = "Orange Juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8
	taste_description = "oranges"
	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/consumable/orangejuice/on_mob_life(mob/living/carbon/M)
	if(M.getOxyLoss() && prob(30))
		M.adjustOxyLoss(-1, 0)
		. = 1
	..()

/datum/reagent/consumable/tomatojuice
	name = "Tomato Juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "tomatoes"
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/consumable/tomatojuice/on_mob_life(mob/living/carbon/M)
	if(M.getFireLoss() && prob(20))
		M.heal_bodypart_damage(0,1, 0)
		. = 1
	..()

/datum/reagent/consumable/limejuice
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "unbearable sourness"
	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice."

/datum/reagent/consumable/limejuice/on_mob_life(mob/living/carbon/M)
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1*REM, 0)
		. = 1
	..()

/datum/reagent/consumable/carrotjuice
	name = "Carrot Juice"
	description = "It is just like a carrot but without crunching."
	color = "#973800" // rgb: 151, 56, 0
	taste_description = "carrots"
	glass_icon_state = "carrotjuice"
	glass_name = "glass of  carrot juice"
	glass_desc = "It's just like a carrot but without crunching."

/datum/reagent/consumable/carrotjuice/on_mob_life(mob/living/carbon/M)
	M.adjust_eye_blur(-1)
	M.adjust_blindness(-1)
	switch(current_cycle)
		if(21 to INFINITY)
			if(prob(current_cycle-10))
				M.cure_nearsighted(list(EYE_DAMAGE))
	..()
	return

/datum/reagent/consumable/berryjuice
	name = "Berry Juice"
	description = "A delicious blend of several different kinds of berries."
	color = "#770b0b" // rgb: 119, 11, 11
	taste_description = "berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/consumable/applejuice
	name = "Apple Juice"
	description = "The sweet juice of an apple, fit for all ages."
	color = "#e99e12" // rgb: 233, 158, 18
	taste_description = "apples"

/datum/reagent/consumable/poisonberryjuice
	name = "Poison Berry Juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83
	taste_description = "berries"
	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's poison. Who cares?"

/datum/reagent/consumable/poisonberryjuice/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	. = 1
	..()

/datum/reagent/consumable/watermelonjuice
	name = "Watermelon Juice"
	description = "Delicious juice made from watermelon."
	color = "#ff3561" // rgb: 255, 53, 97
	taste_description = "juicy watermelon"
	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "A glass of watermelon juice."

/datum/reagent/consumable/lemonjuice
	name = "Lemon Juice"
	description = "This juice is VERY sour."
	color = "#ECFF56" // rgb: 236, 255, 86
	taste_description = "sourness"
	glass_icon_state  = "lemonglass"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."

/datum/reagent/consumable/banana
	name = "Banana Juice"
	description = "The raw essence of a banana. HONK"
	color = "#fdff98" // rgb: 253, 255, 152
	taste_description = "banana"
	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK."

/datum/reagent/consumable/banana/on_mob_life(mob/living/carbon/M)
	if((ishuman(M) && M.job == "Clown") || ismonkey(M))
		M.heal_bodypart_damage(1,1, 0)
		. = 1
	..()

/datum/reagent/consumable/nothing
	name = "Nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"
	glass_icon_state = "nothing"
	glass_name = "nothing"
	glass_desc = "Absolutely nothing."
	shot_glass_icon_state = "shotglass"

/datum/reagent/consumable/nothing/on_mob_life(mob/living/carbon/M)
	if(ishuman(M) && M.job == "Mime")
		M.silent = max(M.silent, MIMEDRINK_SILENCE_DURATION)
		M.heal_bodypart_damage(1,1, 0)
		. = 1
	..()

/datum/reagent/consumable/laughter
	name = "Laughter"
	description = "Some say that this is the best medicine, but recent studies have proven that to be untrue."
	metabolization_rate = INFINITY
	color = "#FF4DD2"
	taste_description = "laughter"

/datum/reagent/consumable/laughter/on_mob_life(mob/living/carbon/M)
	M.emote("laugh")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "chemical_laughter", /datum/mood_event/chemical_laughter)
	..()

/datum/reagent/consumable/superlaughter
	name = "Super Laughter"
	description = "Funny until you're the one laughing."
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#FF4DD2"
	taste_description = "laughter"

/datum/reagent/consumable/superlaughter/on_mob_life(mob/living/carbon/M)
	if(prob(30))
		M.visible_message(span_danger("[M] bursts out into a fit of uncontrollable laughter!"), span_userdanger("You burst out in a fit of uncontrollable laughter!"))
		M.Stun(5)
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "chemical_laughter", /datum/mood_event/chemical_superlaughter)
	..()

/datum/reagent/consumable/potato_juice
	name = "Potato Juice"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "irish sadness"
	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Bleh..."

/datum/reagent/consumable/grapejuice
	name = "Grape Juice"
	description = "The juice of a bunch of grapes. Guaranteed non-alcoholic."
	color = "#290029" // rgn: 41, 0, 41 dark purple
	taste_description = "grape soda"

/datum/reagent/consumable/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"
	default_container = /obj/item/reagent_containers/food/condiment/milk

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(M.dna?.species?.toxic_food & DAIRY)
		M.adjust_disgust(min(volume / 2, 5))

/datum/reagent/consumable/milk/coconut
	name = "Coconut Milk"
	description = "An opaque white liquid produced by the mammary glands of a coconut... wait what?"
	taste_description = "coconut"
	glass_icon_state = "coconut_milk" //disregard it spawning the coconut shell out of nowhere
	glass_name = "glass of coconut milk"

/datum/reagent/consumable/cilk
	name = "Cilk"
	description = "A mixture of milk and.... cola? Who the fuck would do this?"
	color = "#EAC7A4"
	taste_description = "dairy and caffeine"
	glass_name = "glass of cilk"
	glass_desc = "A mixture of milk and... cola? Who the fuck would do this?"

/datum/reagent/consumable/cilk/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(iscatperson(M))
		quality = DRINK_GOOD
	else
		quality = initial(quality) //before you ask "why is this here" I will explain it is to stop people from feeding cilk to a feline just to extract it and give it to other people for the mood buff the same way a mother bird feeds its young I know the mood buff is small but someone would definitely realize they could do it eventually
	. = ..()

/datum/reagent/consumable/milk/goat
	name = "Goat Milk"
	description = "An opaque white liquid produced by the mammary glands of goats."
	taste_description = "goat"
	glass_name = "glass of goat milk"

/datum/reagent/consumable/milk/sheep
	name = "Sheep Milk"
	description = "An opaque white liquid produced by the mammary glands of sheep."
	taste_description = "sheep"
	glass_name = "glass of sheep milk"

/datum/reagent/consumable/milk/blue
	name = "Blue Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/brie
	name = "Brie Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/cheddar
	name = "Cheddar Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/feta
	name = "Feta Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/goatcheese
	name = "Goat Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/shoat
	name = "Shoat Milk"
	description = "An opaque white liquid."
	taste_description = "sheep and goat"
	glass_name = "glass of shoat milk"

/datum/reagent/consumable/milk/halloumi
	name = "Halloumi Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/mozzarella
	name = "Mozzarella Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/parmesan
	name = "Parmesan Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/swiss
	name = "Swiss Cheese Milk"
	description = "An opaque white liquid."
	taste_description = "bitter"
	glass_name = "glass of cheese milk"

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CALCIUM_HEALER))
		M.heal_bodypart_damage(1.5,0, 0)
		. = 1
	else
		if(M.getBruteLoss() && prob(20))
			M.heal_bodypart_damage(1,0, 0)
			. = 1
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 2)
	..()

/datum/reagent/consumable/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199
	taste_description = "soy milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"
	default_container = /obj/item/reagent_containers/food/condiment/soymilk

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	..()

/datum/reagent/consumable/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175
	taste_description = "creamy milk"
	glass_icon_state  = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

/datum/reagent/consumable/cream/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	..()

/datum/reagent/consumable/cream/bug
	name = "Gutlunch Honey"
	description = "A sweet, creamy substance produced by gutlunches, functioning as a sort of strange honey."
	color = "#800000"
	nutriment_factor = 2
	taste_description = "excessively sugary cream"
	glass_icon_state  = "chocolateglass"
	glass_name = "glass of bug cream"
	glass_desc = "This came from a WHAT?!"

////////////////////////////////////////////////////////////////////////////////////
//----------------------------------Coffee----------------------------------------//
////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/consumable/coffee
	name = "Coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitterness"
	glass_icon_state = "glass_brown"
	glass_name = "glass of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/consumable/coffee/overdose_process(mob/living/M)
	. = ..()
	M.reagents.add_reagent(/datum/reagent/drug/caffeine, 3) //way too much caffeine

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.reagents.add_reagent(/datum/reagent/drug/caffeine, metabolization_rate) //effectively metabolize into caffeine

/**
 * hot coffee, heats you up
 * we do this because having chems impart temperature to you directly would let chemists fry people alive instantly
 */
/datum/reagent/consumable/coffee/hot
	var/heat = 25

/datum/reagent/consumable/coffee/hot/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_bodytemperature(heat * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5)

/datum/reagent/consumable/coffee/hot/latte
	name = "Cafe Latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	quality = DRINK_NICE
	taste_description = "bitter cream"
	glass_icon_state = "cafe_latte"
	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you're reading."
	heat = 5 //less hot becase of the milk

/datum/reagent/consumable/coffee/hot/latte/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
	
/datum/reagent/consumable/coffee/hot/latte/pumpkin
	name = "Pumpkin Latte"
	description = "A mix of pumpkin juice and coffee."
	color = "#F4A460"
	quality = DRINK_VERYGOOD
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "creamy pumpkin"
	glass_icon_state = "pumpkin_latte"
	glass_name = "pumpkin latte"
	glass_desc = "A mix of coffee and pumpkin juice."

/datum/reagent/consumable/coffee/hot/latte/soy
	name = "Soy Latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300" // rgb: 102, 67, 0
	quality = DRINK_NICE
	taste_description = "creamy coffee"
	glass_icon_state = "soy_latte"
	glass_name = "soy latte"
	glass_desc = "A nice and refreshing beverage while you're reading."
	
/**
 * cold coffee, cools you down
 * we do this because having chems impart temperature to you directly would let chemists fry people alive instantly
 */
/datum/reagent/consumable/coffee/ice
	name = "Iced Coffee"
	description = "Coffee and ice, refreshing and cool."
	taste_description = "bitter coldness"
	glass_icon_state = "icedcoffeeglass"
	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/datum/reagent/consumable/coffee/ice/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)

////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Tea-----------------------------------------//
////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/consumable/tea
	name = "Tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "tart black tea"
	glass_icon_state = "teaglass"
	glass_name = "glass of tea"
	glass_desc = "Drinking it from here would not seem right."

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.reagents.add_reagent(/datum/reagent/drug/caffeine, metabolization_rate) //effectively metabolize into caffeine
	M.adjust_jitter(-3 SECONDS)
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1, 0)

/**
 * hot tea, heats you up
 * we do this because having chems impart temperature to you directly would let chemists fry people alive instantly
 */
/datum/reagent/consumable/tea/hot

/datum/reagent/consumable/tea/hot/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_bodytemperature(20 * TEMPERATURE_DAMAGE_COEFFICIENT, 0, BODYTEMP_NORMAL)

/datum/reagent/consumable/tea/hot/arnold_palmer
	name = "Arnold Palmer"
	description = "Encourages the patient to go golfing."
	color = "#FFB766"
	quality = DRINK_NICE
	nutriment_factor = 2
	taste_description = "bitter tea"
	glass_icon_state = "arnold_palmer"
	glass_name = "Arnold Palmer"
	glass_desc = "You feel like taking a few golf swings after a few swigs of this."

/datum/reagent/consumable/tea/hot/arnold_palmer/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(prob(5))
		to_chat(M, "<span class = 'notice'>[pick("You remember to square your shoulders.","You remember to keep your head down.","You can't decide between squaring your shoulders and keeping your head down.","You remember to relax.","You think about how someday you'll get two strokes off your golf game.")]</span>")

/**
 * cold tea, cools you down
 * we do this because having chems impart temperature to you directly would let chemists fry people alive instantly
 */
/datum/reagent/consumable/tea/cold
	name = "Iced Tea"
	description = "No relation to a certain rap artist/actor."
	quality = DRINK_SODA // sweet tea is sugary
	nutriment_factor = 0
	taste_description = "sweet tea"
	glass_icon_state = "icedteaglass"
	glass_name = "iced tea"
	glass_desc = "All natural, antioxidant-rich flavour sensation."

/datum/reagent/consumable/tea/cold/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)

////////////////////////////////////////////////////////////////////////////////////
//--------------------------------Energy Drinks-----------------------------------//
////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/consumable/energy_drink
	name = "Energy drink"
	description = "This should only show up if an admin is doing something fucky."
	color = "#07f303"
	quality = DRINK_SODA

/datum/reagent/consumable/energy_drink/on_mob_life(mob/living/L)
	. = ..()
	L.reagents.add_reagent(/datum/reagent/drug/caffeine, metabolization_rate * 2) //effectively metabolize into double the amount of caffeine
	L.adjust_jitter_up_to(2 SECONDS, 10 SECONDS)
	L.adjust_dizzy(2 SECONDS * REM)
	L.remove_status_effect(/datum/status_effect/drowsiness)
	L.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)

/**
 * Monkey energy gives monkeys a speed boost
 */
/datum/reagent/consumable/energy_drink/monkey_energy
	name = "Monkey Energy"
	description = "The only drink that will make you unleash the ape."
	color = "#f39b03" // rgb: 243, 155, 3
	taste_description = "barbecue and nostalgia"
	glass_icon_state = "monkey_energy_glass"
	glass_name = "glass of Monkey Energy"
	glass_desc = "You can unleash the ape, but without the pop of the can?"

/datum/reagent/consumable/energy_drink/monkey_energy/on_mob_metabolize(mob/living/L)
	. = ..()
	if(ismonkey(L))
		L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/consumable/energy_drink/monkey_energy/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	return ..()

/**
 * Grey bull gives temporary shock immunity
 */
/datum/reagent/consumable/energy_drink/grey_bull
	name = "Grey Bull"
	description = "Grey Bull, it gives you gloves!"
	color = "#EEFF00" // rgb: 238, 255, 0
	quality = DRINK_VERYGOOD
	taste_description = "carbonated oil"
	glass_icon_state = "grey_bull_glass"
	glass_name = "glass of Grey Bull"
	glass_desc = "Surprisingly it isnt grey."

/datum/reagent/consumable/energy_drink/grey_bull/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_SHOCKIMMUNE, type)

/datum/reagent/consumable/energy_drink/grey_bull/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_SHOCKIMMUNE, type)
	return ..()

/**
 * Contrary to the name, nuka cola functioned more like an energy drink
 * so i've gathered it together as such
 */
/datum/reagent/consumable/energy_drink/nuka_cola
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	color = "#100800"
	quality = DRINK_VERYGOOD
	taste_description = "the future"
	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland."

/datum/reagent/consumable/energy_drink/nuka_cola/on_mob_metabolize(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_REDUCED_DAMAGE_SLOWDOWN, type)

/datum/reagent/consumable/energy_drink/nuka_cola/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_REDUCED_DAMAGE_SLOWDOWN, type)
	return ..()

/datum/reagent/consumable/energy_drink/nuka_cola/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_drugginess_up_to(2 SECONDS, 10 SECONDS)
	M.apply_effect(5, EFFECT_IRRADIATE, 0)

////////////////////////////////////////////////////////////////////////////////////
//----------------------------------Soft Drinks-----------------------------------//
////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/consumable/space_cola
	name = "Cola"
	description = "A refreshing beverage."
	color = "#100800" // rgb: 16, 8, 0
	quality = DRINK_SODA
	taste_description = "cola"
	glass_icon_state  = "spacecola_glass"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola."

/datum/reagent/consumable/space_cola/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.reagents.add_reagent(/datum/reagent/drug/caffeine, metabolization_rate) //effectively metabolize into caffeine
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)

/**
 * Dr pepper and float version
 */
/datum/reagent/consumable/space_cola/dr_gibb
	name = "Dr. Gibb"
	description = "A delicious blend of 42 different flavours."
	color = "#500014"
	quality = DRINK_SODA
	taste_description = "cherry soda" // FALSE ADVERTISING
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the glass_name might imply."

/datum/reagent/consumable/space_cola/dr_gibb/float
	name = "Gibb Float"
	description = "Dr. Gibb with ice cream on top."
	quality = DRINK_NICE
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "creamy cherry"
	glass_icon_state = "gibbfloats"
	glass_name = "Gibb float"
	glass_desc = "Dr. Gibb with ice cream on top."
	
/datum/reagent/consumable/space_cola/dr_gibb/float/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL) //colder because of the icecream

/**
 * some times affectionately referred to as "swamp water"
 */
/datum/reagent/consumable/space_cola/gravedigger
	name = "Grave-Digger"
	description = "What happens when you mix all the sodas in the fountain? You get this monstrosity!"
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "liquid diabetes"
	glass_icon_state = "cream_soda"
	glass_name = "glass of Grave-Digger"
	glass_desc = "Just looking at this is making you feel sick."

/**
 * root beer
 * no one has made a float version yet for some reason
 */
/datum/reagent/consumable/space_cola/rootbeer
	name = "Root Beer"
	description = "Beer, but not."
	color = "#251505"
	quality = DRINK_SODA
	taste_description = "root and beer"
	glass_icon_state  = "glass_brown"
	glass_name = "glass of root beer"
	glass_desc = "A glass of refreshing fizzing root beer."

/**
 * initially thought it was a sierra mist reference, but i'm pretty sure it's a mountain dew reference
 */
/datum/reagent/consumable/space_cola/spacemountainwind
	name = "SM Wind"
	description = "Blows right through you like a space wind."
	color = "#2e5c00"
	quality = DRINK_SODA
	taste_description = "sweet citrus soda"
	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/datum/reagent/consumable/space_cola/spacemountainwind/on_mob_life(mob/living/carbon/M)	
	M.reagents.add_reagent(/datum/reagent/drug/caffeine, metabolization_rate) //twice as caffinated (not quite an energy drink)
	return ..()

////////////////////////////////////////////////////////////////////////////////////
//-----------------------------Divider from other stuff---------------------------//
////////////////////////////////////////////////////////////////////////////////////
/datum/reagent/consumable/space_up
	name = "Space-Up"
	description = "Tastes like a hull breach in your mouth."
	color = "#00FF00" // rgb: 0, 255, 0
	quality = DRINK_SODA
	taste_description = "cherry soda"
	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-Up"
	glass_desc = "Space-up. It helps you keep your cool."

/datum/reagent/consumable/space_up/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/lemon_lime
	name = "Spite"
	description = "A tangy substance made of 0.5% natural citrus!"
	color = "#8CFF00" // rgb: 135, 255, 0
	quality = DRINK_SODA
	taste_description = "tangy lime and lemon soda"
	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon-lime"
	glass_desc = "You're pretty certain a real fruit has never actually touched this."

/datum/reagent/consumable/lemon_lime/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/pwr_game
	name = "Pwr Game"
	description = "The only drink with the PWR that true gamers crave."
	color = "#9385bf" // rgb: 58, 52, 75
	quality = DRINK_SODA
	taste_description = "sweet and salty tang"
	glass_icon_state = "pwrgame_glass"
	glass_name = "glass of Pwr Game"
	glass_desc = "Goes well with a Vlad's salad."

/datum/reagent/consumable/pwr_game/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/shamblers
	name = "Shambler's Juice"
	description = "~Shake me up some of that Shambler's Juice!~"
	color = "#f00060" // rgb: 94, 0, 38
	quality = DRINK_SODA
	taste_description = "carbonated metallic soda"
	glass_icon_state = "shamblerjuice_glass"
	glass_name = "glass of Shambler's juice"
	glass_desc = "Mmm mm, shambly."

/datum/reagent/consumable/shamblers/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/aloejuice
	name = "Aloe Juice"
	color = "#A3C48B"
	description = "A healthy and refreshing juice."
	taste_description = "vegetable"
	glass_icon_state = "glass_yellow"
	glass_name = "glass of aloe juice"
	glass_desc = "A healthy and refreshing juice."

/datum/reagent/consumable/aloejuice/on_mob_life(mob/living/M, delta_time, times_fired)
	if(M.getToxLoss() && prob(16))
		M.adjustToxLoss(-1, 0)
	..()
	. = TRUE

/datum/reagent/consumable/lemonade
	name = "Lemonade"
	description = "Sweet, tangy lemonade. Good for the soul."
	color = "#ECFF56" // rgb: 236, 255, 86 Same as the lemon juice if this ever matters
	quality = DRINK_NICE
	taste_description = "sunshine and summertime"
	glass_icon_state = "lemonpitcher"
	glass_name = "pitcher of lemonade"
	glass_desc = "This drink leaves you feeling nostalgic for some reason."

/datum/reagent/consumable/sodawater
	name = "Soda Water"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "carbonated water"
	glass_icon_state = "glass_clear"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/datum/reagent/consumable/sodawater/on_mob_life(mob/living/carbon/M)
	M.adjust_dizzy(-5 SECONDS)
	M.adjust_drowsiness(-3 SECONDS)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/tonic
	name = "Tonic Water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#0064C8" // rgb: 0, 100, 200
	taste_description = "tart and fresh"
	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/consumable/tonic/on_mob_life(mob/living/carbon/M)
	M.adjust_dizzy(-5 SECONDS)
	M.adjust_drowsiness(-3 SECONDS)
	M.AdjustSleeping(-40, FALSE)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()
	. = 1

/datum/reagent/consumable/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "ice"
	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

/datum/reagent/consumable/ice/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/doctor_delight
	name = "The Doctor's Delight"
	description = "A gulp a day keeps the Medibot away! A mixture of juices that heals most damage types fairly quickly at the cost of hunger."
	color = "#FF8CFF" // rgb: 255, 140, 255
	quality = DRINK_VERYGOOD
	taste_description = "homely fruit"
	glass_icon_state = "doctorsdelightglass"
	glass_name = "Doctor's Delight"
	glass_desc = "The space doctor's favorite. Guaranteed to restore bodily injury; side effects include cravings and hunger."

/datum/reagent/consumable/doctor_delight/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(-0.5, 0)
	M.adjustFireLoss(-0.5, 0)
	M.adjustToxLoss(-0.5, 0)
	M.adjustOxyLoss(-0.5, 0)
	if(M.nutrition && (M.nutrition - 2 > 0))
		if(!(M.mind?.assigned_role == "Medical Doctor")) //Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			M.adjust_nutrition(-2)
	..()
	. = 1

/datum/reagent/consumable/chocolatepudding
	name = "Chocolate Pudding"
	description = "A great dessert for chocolate lovers."
	color = "#800000"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "sweet chocolate"
	glass_icon_state = "chocolatepudding"
	glass_name = "chocolate pudding"
	glass_desc = "Tasty."

/datum/reagent/consumable/chocolate/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CALCIUM_HEALER))
		M.heal_bodypart_damage(2.0,0, 0)
	..()
	. = TRUE

/datum/reagent/consumable/chocolate/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & INGEST)
		if(HAS_TRAIT(M, TRAIT_CALCIUM_HEALER))
			to_chat(M, span_notice("This is like Milk, but better!?"))
	return ..()

/datum/reagent/consumable/vanillapudding
	name = "Vanilla Pudding"
	description = "A great dessert for vanilla lovers."
	color = "#FAFAD2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "sweet vanilla"
	glass_icon_state = "vanillapudding"
	glass_name = "vanilla pudding"
	glass_desc = "Tasty."

/datum/reagent/consumable/vanillapudding/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CALCIUM_HEALER))
		M.heal_bodypart_damage(2.0,0, 0)
	..()
	. = TRUE

/datum/reagent/consumable/vanillapudding/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & INGEST)
		if(HAS_TRAIT(M, TRAIT_CALCIUM_HEALER))
			to_chat(M, span_notice("This is like Milk, but better!?"))
	return ..()

/datum/reagent/consumable/cherryshake
	name = "Cherry Shake"
	description = "A cherry flavored milkshake."
	color = "#FFB6C1"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "creamy cherry"
	glass_icon_state = "cherryshake"
	glass_name = "cherry shake"
	glass_desc = "A cherry flavored milkshake."

/datum/reagent/consumable/cherryshake/on_mob_life(mob/living/carbon/C)
	if(isjellyperson(C))
		if(C.blood_volume < BLOOD_VOLUME_NORMAL(C))
			C.blood_volume = min(BLOOD_VOLUME_NORMAL(C), C.blood_volume + 4.0)
	..()

/datum/reagent/consumable/cherryshake/reaction_mob(mob/living/C, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & INGEST)
		if(isjellyperson(C))
			to_chat(C, span_notice("Just like us, just like jelly!"))
	return ..()

/datum/reagent/consumable/bluecherryshake
	name = "Blue Cherry Shake"
	description = "An exotic milkshake."
	color = "#00F1FF"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "creamy blue cherry"
	glass_icon_state = "bluecherryshake"
	glass_name = "blue cherry shake"
	glass_desc = "An exotic blue milkshake."

/datum/reagent/consumable/bluecherryshake/on_mob_life(mob/living/carbon/C)
	if(isjellyperson(C))
		if(C.blood_volume < BLOOD_VOLUME_NORMAL(C))
			C.blood_volume = min(BLOOD_VOLUME_NORMAL(C), C.blood_volume + 4.0)
	..()

/datum/reagent/consumable/bluecherryshake/reaction_mob(mob/living/C, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & INGEST)
		if(isjellyperson(C))
			to_chat(C, span_notice("Just like us, just like jelly!"))
	return ..()


/datum/reagent/consumable/pumpkinjuice
	name = "Pumpkin Juice"
	description = "Juiced from real pumpkin."
	color = "#FFA500"
	taste_description = "pumpkin"

/datum/reagent/consumable/blumpkinjuice
	name = "Blumpkin Juice"
	description = "Juiced from real blumpkin."
	color = "#00BFFF"
	taste_description = "a mouthful of pool water"

/datum/reagent/consumable/triple_citrus
	name = "Triple Citrus"
	description = "A solution."
	color = "#C8A5DC"
	quality = DRINK_NICE
	taste_description = "extreme bitterness"
	glass_icon_state = "triplecitrus" //needs own sprite mine are trash
	glass_name = "glass of triple citrus"
	glass_desc = "A mixture of citrus juices. Tangy, yet smooth."

/datum/reagent/consumable/grape_soda
	name = "Grape soda"
	description = "Beloved of children and teetotalers."
	color = "#E6CDFF"
	taste_description = "grape soda"
	glass_name = "glass of grape juice"
	glass_desc = "It's grape (soda)!"

/datum/reagent/consumable/grape_soda/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/milk/chocolate_milk
	name = "Chocolate Milk"
	description = "Milk for cool kids."
	color = "#7D4E29"
	quality = DRINK_NICE
	taste_description = "chocolate milk"
	glass_name = "glass of chocolate milk"
	glass_desc = "Milk for cool kids."
	glass_icon_state = "chocolateglass"

/datum/reagent/consumable/menthol
	name = "Menthol"
	description = "Alleviates coughing symptoms one might have."
	color = "#80AF9C"
	taste_description = "mint"
	glass_icon_state = "glass_green"
	glass_name = "glass of menthol"
	glass_desc = "Tastes naturally minty, and imparts a very mild numbing sensation."

/datum/reagent/consumable/menthol/on_mob_life(mob/living/L)
	L.apply_status_effect(/datum/status_effect/throat_soothed)
	..()

/datum/reagent/consumable/grenadine
	name = "Grenadine"
	description = "Not cherry flavored!"
	color = "#EA1D26"
	taste_description = "sweet pomegranates"
	glass_name = "glass of grenadine"
	glass_desc = "Delicious flavored syrup."

/datum/reagent/consumable/parsnipjuice
	name = "Parsnip Juice"
	description = "Why..."
	color = "#FFA500"
	taste_description = "parsnip"
	glass_name = "glass of parsnip juice"

/datum/reagent/consumable/pineapplejuice
	name = "Pineapple Juice"
	description = "Tart, tropical, and hotly debated."
	color = "#F7D435"
	taste_description = "pineapple"
	glass_name = "glass of pineapple juice"
	glass_desc = "Tart, tropical, and hotly debated."

/datum/reagent/consumable/peachjuice //Intended to be extremely rare due to being the limiting ingredients in the blazaam drink
	name = "Peach Juice"
	description = "Just peachy."
	color = "#E78108"
	taste_description = "peaches"
	glass_name = "glass of peach juice"

/datum/reagent/consumable/cream_soda
	name = "Cream Soda"
	description = "A classic space-American vanilla flavored soft drink."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "fizzy vanilla"
	glass_icon_state = "cream_soda"
	glass_name = "Cream Soda"
	glass_desc = "A classic space-American vanilla flavored soft drink."

/datum/reagent/consumable/cream_soda/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/sol_dry
	name = "Sol Dry"
	description = "A soothing, mellow drink made from ginger."
	color = "#f7d26a"
	quality = DRINK_NICE
	taste_description = "sweet ginger spice"
	glass_icon_state = "soldry_glass"
	glass_name = "Sol Dry"
	glass_desc = "A soothing, mellow drink made from ginger."

/datum/reagent/consumable/sol_dry/on_mob_life(mob/living/carbon/M)
	M.adjust_disgust(-1)
	..()

/datum/reagent/consumable/red_queen
	name = "Red Queen"
	description = "DRINK ME."
	color = "#e6ddc3"
	quality = DRINK_GOOD
	taste_description = "wonder"
	glass_icon_state = "red_queen"
	glass_name = "Red Queen"
	glass_desc = "DRINK ME."

/datum/reagent/consumable/red_queen/on_mob_life(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, -4*REM)
	..()

/datum/reagent/consumable/sprited_cranberry
	name = "Sprited Cranberry"
	description = "A limited edition winter spiced cranberry drink."
	quality = DRINK_GOOD
	color = "#fffafa"
	taste_description = "cranberry"
	glass_name = "glass of sprited cranberry"

/datum/reagent/consumable/buzz_fuzz
	name = "Buzz Fuzz"
	description = "~A Hive of Flavour!~ NOTICE: Addicting."
	addiction_threshold = 14
	color = "#8CFF00" // rgb: 135, 255, 0
	taste_description = "carbonated honey and pollen"
	glass_icon_state = "buzz_fuzz"
	glass_name = "honeycomb of Buzz Fuzz"
	glass_desc = "Stinging with flavour."

/datum/reagent/consumable/buzz_fuzz/on_mob_life(mob/living/carbon/M)
	M.reagents.add_reagent("sugar",2)
	if(prob(25))
		M.reagents.add_reagent("honey",1)
	..()

/datum/reagent/consumable/buzz_fuzz/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(iscarbon(M) && (methods & (TOUCH|VAPOR|PATCH)))
		var/mob/living/carbon/C = M
		for(var/s in C.surgeries)
			var/datum/surgery/S = s
			S.success_multiplier = max(0.1, S.success_multiplier) // +10% success probability on each step, compared to bacchus' blessing's ~46%
	..()

/datum/reagent/consumable/buzz_fuzz/addiction_act_stage1(mob/living/M)
	if(prob(5))
		to_chat(M, "<span class = 'notice'>[pick("Buzz Buzz.", "Stinging with flavour.", "A Hive of Flavour")]</span>")
	..()

/datum/reagent/consumable/buzz_fuzz/addiction_act_stage2(mob/living/M)
	if(prob(10))
		to_chat(M, "<span class = 'notice'>[pick("Buzz Buzz.", "Stinging with flavour.", "A Hive of Flavour", "The Queen approved it!")]</span>")
	..()

/datum/reagent/consumable/buzz_fuzz/addiction_act_stage3(mob/living/M)
	if(prob(15))
		to_chat(M, "<span class = 'notice'>[pick("Buzz Buzz.", "Stinging with flavour.", "Ideal of the worker drone", "A Hive of Flavour", "The Queen approved it!")]</span>")
	..()

/datum/reagent/consumable/buzz_fuzz/addiction_act_stage4(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class = 'notice'>[pick("Buzz Buzz.", "Stinging with flavour.", "Ideal of the worker drone", "A Hive of Flavour", "Sap back that missing energy!", "Got Honey?", "The Queen approved it!")]</span>")
	..()

/datum/reagent/consumable/mushroom_tea
	name = "Mushroom Tea"
	description = "A savoury glass of tea made from polypore mushroom shavings, originally native to Sangris."
	color = "#674945" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "mushrooms"
	glass_icon_state = "mushroom_tea_glass"
	glass_name = "glass of mushroom tea"
	glass_desc = "Oddly savoury for a drink."

/datum/reagent/consumable/mushroom_tea/on_mob_life(mob/living/carbon/C)
	if(islizard(C))
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2.5*REM)
	..()

/datum/reagent/consumable/mushroom_tea/reaction_mob(mob/living/M, methods=TOUCH, reac_volume, show_message = TRUE, permeability = 1)
	if(methods & INGEST)
		if(islizard(M))
			to_chat(M, span_notice("The most important thing to a Lizard is their brains.... Probably"))
	return ..()

/datum/reagent/consumable/cucumberjuice
	name = "Cucumber Juice"
	description = "Ordinary cucumber juice."
	color = "#6cd87a" // rgb: 108, 216, 122
	taste_description = "light cucumber"
	glass_name = "glass of cucumber juice"
	glass_desc = "A glass of cucumber juice."

/datum/reagent/consumable/cucumberlemonade
	name = "Cucumber Lemonade"
	description = "Cucumber juice, sugar and soda, what else is needed for happiness?"
	color = "#6cd87a"
	taste_description = "citrus soda with cucumber"
	glass_icon_state = "cucumber_lemonade"
	glass_name = "cucumber lemonade"
	glass_desc = "Lemonade, with added cucumber."
