
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = /datum/reagent/space_cleaner/sterilizine
	results = list(/datum/reagent/space_cleaner/sterilizine = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/charcoal = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = /datum/reagent/lube
	results = list(/datum/reagent/lube = 4)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/naniteremover
	name = "Nanolytic Agent"
	id = /datum/reagent/medicine/naniteremover
	results = list(/datum/reagent/medicine/naniteremover = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/ammonia = 1)

/datum/chemical_reaction/itching_powder
	name = "Itching Powder"
	id = /datum/reagent/itching_powder
	results = list(/datum/reagent/itching_powder = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/ammonia = 1, /datum/reagent/medicine/charcoal = 1)

/datum/chemical_reaction/spraytan
	name = "Spray Tan"
	id = /datum/reagent/spraytan
	results = list(/datum/reagent/spraytan = 2)
	required_reagents = list(/datum/reagent/consumable/orangejuice = 1, /datum/reagent/oil = 1)

/datum/chemical_reaction/spraytan2
	name = "Spray Tan"
	id = /datum/reagent/spraytan
	results = list(/datum/reagent/spraytan = 2)
	required_reagents = list(/datum/reagent/consumable/orangejuice = 1, /datum/reagent/consumable/cornoil = 1)

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = /datum/reagent/impedrezene
	results = list(/datum/reagent/impedrezene = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = /datum/reagent/cryptobiolin
	results = list(/datum/reagent/cryptobiolin = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = /datum/reagent/glycerol
	results = list(/datum/reagent/glycerol = 1)
	required_reagents = list(/datum/reagent/consumable/cornoil = 3, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = /datum/reagent/consumable/sodiumchloride
	results = list(/datum/reagent/consumable/sodiumchloride = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/plasmasolidification
	name = "Solid Plasma"
	id = "solidplasma"
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/consumable/frostoil = 5, /datum/reagent/toxin/plasma = 20)
	mob_react = FALSE

/datum/chemical_reaction/plasmasolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/plasma(location)

/datum/chemical_reaction/goldsolidification
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/gold = 20, /datum/reagent/iron = 1)
	mob_react = FALSE

/datum/chemical_reaction/goldsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/gold(location)

/datum/chemical_reaction/capsaicincondensation
	name = "Capsaicincondensation"
	id = "capsaicincondensation"
	results = list(/datum/reagent/consumable/condensedcapsaicin = 5)
	required_reagents = list(/datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/ethanol = 5)

/datum/chemical_reaction/soapification
	name = "Soapification"
	id = "soapification"
	results = list(/datum/reagent/liquidsoap = 12)
	required_reagents = list(/datum/reagent/consumable/cornoil = 10, /datum/reagent/lye  = 2)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/soapification2
	name = "Soapification2"
	id = "soapification2"
	results = list(/datum/reagent/liquidsoap = 12)
	required_reagents = list(/datum/reagent/consumable/cooking_oil = 10, /datum/reagent/lye  = 2)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/candlefication
	name = "Candlefication"
	id = "candlefication"
	required_reagents = list(/datum/reagent/consumable/cornoil = 5, /datum/reagent/hydrogen  = 5)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/candle(location)

/datum/chemical_reaction/candlefication2
	name = "Candlefication2"
	id = "candlefication2"
	required_reagents = list(/datum/reagent/consumable/cooking_oil = 5, /datum/reagent/hydrogen  = 5)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/candlefication2/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/candle(location)

/datum/chemical_reaction/meatification
	name = "Meatification"
	id = "meatification"
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/consumable/nutriment = 10, /datum/reagent/carbon = 10)
	mob_react = FALSE

/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/slab/meatproduct(location)
	return

/datum/chemical_reaction/carbondioxide
	name = "Direct Carbon Oxidation"
	id = "burningcarbon"
	results = list(/datum/reagent/carbondioxide = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 2)
	required_temp = 777 // pure carbon isn't especially reactive.

/datum/chemical_reaction/nitrous_oxide
	name = "Nitrous Oxide"
	id = /datum/reagent/nitrous_oxide
	results = list(/datum/reagent/nitrous_oxide = 5)
	required_reagents = list(/datum/reagent/ammonia = 2, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 2)
	required_temp = 525

/datum/chemical_reaction/lemolime
	name = "Lemoline"
	id = /datum/reagent/lemoline
	required_reagents = list(/datum/reagent/consumable/lemonjuice = 2, /datum/reagent/consumable/limejuice = 2, /datum/reagent/consumable/ethanol = 4)
	results = list(/datum/reagent/lemoline = 4)

//Technically a mutation toxin
/datum/chemical_reaction/mulligan
	name = "Mulligan"
	id = /datum/reagent/mulligan
	results = list(/datum/reagent/mulligan = 1)
	required_reagents = list(/datum/reagent/slime_toxin = 1, /datum/reagent/toxin/mutagen = 1)


////////////////////////////////// VIROLOGY //////////////////////////////////////////

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = /datum/reagent/consumable/virus_food
	results = list(/datum/reagent/consumable/virus_food = 15)
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/consumable/milk = 5)

/datum/chemical_reaction/virus_food_mutagen
	name = "mutagenic agar"
	id = /datum/reagent/toxin/mutagen/mutagenvirusfood
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_synaptizine
	name = "virus rations"
	id = /datum/reagent/medicine/synaptizine/synaptizinevirusfood
	results = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_plasma
	name = "virus plasma"
	id = /datum/reagent/toxin/plasma/plasmavirusfood
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/plasma = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_plasma_synaptizine
	name = "weakened virus plasma"
	id = /datum/reagent/toxin/plasma/plasmavirusfood/weak
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 2)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/toxin/plasma/plasmavirusfood = 1)

/datum/chemical_reaction/virus_food_mutagen_sugar
	name = "sucrose agar"
	id = /datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_mutagen_salineglucose
	name = "sucrose agar"
	id = "salineglucosevirusfood"
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/medicine/salglu_solution = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_uranium
	name = "Decaying uranium gel"
	id = /datum/reagent/uranium/uraniumvirusfood
	results = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_uranium_plasma
	name = "Unstable uranium gel"
	id = "uraniumvirusfood_plasma"
	results = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	required_reagents = list(/datum/reagent/uranium = 5, /datum/reagent/toxin/plasma/plasmavirusfood = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_gold
	name = "Stable uranium gel"
	id = "uraniumvirusfood_gold"
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/gold = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_silver
	name = "Stable uranium gel"
	id = "uraniumvirusfood_silver"
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/silver = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	results = list(/datum/reagent/blood = 1)
	required_reagents = list(/datum/reagent/consumable/virus_food = 1)
	required_catalysts = list(/datum/reagent/blood = 1)
	var/level_min = 1
	var/level_max = 2

/datum/chemical_reaction/mix_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)


/datum/chemical_reaction/mix_virus/mix_virus_2

	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list(/datum/reagent/toxin/mutagen = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_3

	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_4

	name = "Mix Virus 4"
	id = "mixvirus4"
	required_reagents = list(/datum/reagent/uranium = 1)
	level_min = 5
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_5

	name = "Mix Virus 5"
	id = "mixvirus5"
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	level_min = 3
	level_max = 3

/datum/chemical_reaction/mix_virus/mix_virus_6

	name = "Mix Virus 6"
	id = "mixvirus6"
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 1)
	level_min = 4
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_7

	name = "Mix Virus 7"
	id = "mixvirus7"
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 1)
	level_min = 5
	level_max = 5

/datum/chemical_reaction/mix_virus/mix_virus_8

	name = "Mix Virus 8"
	id = "mixvirus8"
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	level_min = 6
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_9

	name = "Mix Virus 9"
	id = "mixvirus9"
	required_reagents = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	level_min = 1
	level_max = 1

/datum/chemical_reaction/mix_virus/mix_virus_10

	name = "Mix Virus 10"
	id = "mixvirus10"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	level_min = 6
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_11

	name = "Mix Virus 11"
	id = "mixvirus11"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	level_min = 7
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_12

	name = "Mix Virus 12"
	id = "mixvirus12"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	level_min = 8
	level_max = 8

/datum/chemical_reaction/mix_virus/rem_virus

	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()

/datum/chemical_reaction/mix_virus/neuter_virus
	name = "Neuter Virus"
	id = "neutervirus"
	required_reagents = list(/datum/reagent/toxin/formaldehyde = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/neuter_virus/on_reaction(datum/reagents/holder, created_volume)

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Neuter()



////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	results = list(/datum/reagent/fluorosurfactant = 5)
	required_reagents = list(/datum/reagent/fluorine = 2, /datum/reagent/carbon = 2, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	required_reagents = list(/datum/reagent/fluorosurfactant = 1, /datum/reagent/water = 1)
	mob_react = FALSE

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam, 2 * created_volume, notification = span_danger("The solution spews out foam!"))

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam/metal, 5 * created_volume, /obj/structure/foamedmetal, span_danger("The solution spews out a metallic foam!"))

/datum/chemical_reaction/smart_foam
	name = "Smart Metal Foam"
	id = "smart_metal_foam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/smart_foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = TRUE

/datum/chemical_reaction/smart_foam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam/metal/smart, 5 * created_volume, /obj/structure/foamedmetal, span_danger("The solution spews out metallic foam!"))

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam/metal/iron, 5 * created_volume, /obj/structure/foamedmetal/iron, span_danger("The solution spews out a metallic foam!"))

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = /datum/reagent/foaming_agent
	results = list(/datum/reagent/foaming_agent = 1)
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/smart_foaming_agent
	name = "Smart foaming Agent"
	id = /datum/reagent/smart_foaming_agent
	results = list(/datum/reagent/smart_foaming_agent = 3)
	required_reagents = list(/datum/reagent/foaming_agent = 3, /datum/reagent/acetone = 1, /datum/reagent/iron = 1)
	mix_message = "The solution mixes into a frothy metal foam and conforms to the walls of its container."


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = /datum/reagent/ammonia
	results = list(/datum/reagent/ammonia = 3)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/nitrogen = 1)

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = /datum/reagent/diethylamine
	results = list(/datum/reagent/diethylamine = 2)
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/consumable/ethanol = 1)

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = /datum/reagent/space_cleaner
	results = list(/datum/reagent/space_cleaner = 2)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = /datum/reagent/toxin/plantbgone
	results = list(/datum/reagent/toxin/plantbgone = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)

/datum/chemical_reaction/weedkiller
	name = "Weed Killer"
	id = /datum/reagent/toxin/plantbgone/weedkiller
	results = list(/datum/reagent/toxin/plantbgone/weedkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/ammonia = 4)

/datum/chemical_reaction/pestkiller
	name = "Pest Killer"
	id = /datum/reagent/toxin/pestkiller
	results = list(/datum/reagent/toxin/pestkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/consumable/ethanol = 4)

/datum/chemical_reaction/drying_agent
	name = "Drying agent"
	id = /datum/reagent/drying_agent
	results = list(/datum/reagent/drying_agent = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 2, /datum/reagent/consumable/ethanol = 1, /datum/reagent/sodium = 1)

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = /datum/reagent/acetone
	id = /datum/reagent/acetone
	results = list(/datum/reagent/acetone = 3)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/carpet
	name = /datum/reagent/carpet
	id = /datum/reagent/carpet
	results = list(/datum/reagent/carpet = 2)
	required_reagents = list(/datum/reagent/drug/space_drugs = 1, /datum/reagent/blood = 1)

/datum/chemical_reaction/oil
	name = "Oil"
	id = /datum/reagent/oil
	results = list(/datum/reagent/oil = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/phenol
	name = /datum/reagent/phenol
	id = /datum/reagent/phenol
	results = list(/datum/reagent/phenol = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/chlorine = 1, /datum/reagent/oil = 1)

/datum/chemical_reaction/ash
	name = "Ash"
	id = /datum/reagent/ash
	results = list(/datum/reagent/ash = 1)
	required_reagents = list(/datum/reagent/oil = 1)
	required_temp = 480

/datum/chemical_reaction/colorful_reagent
	name = /datum/reagent/colorful_reagent
	id = /datum/reagent/colorful_reagent
	results = list(/datum/reagent/colorful_reagent = 5)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1, /datum/reagent/medicine/cryoxadone = 1, /datum/reagent/consumable/triple_citrus = 1)

/datum/chemical_reaction/life
	name = "Life"
	id = "life"
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/blood = 1)
	required_temp = 374

/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (hostile)") //defaults to HOSTILE_SPAWN

/datum/chemical_reaction/life_friendly
	name = "Life (Friendly)"
	id = "life_friendly"
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/consumable/sugar = 1)
	required_temp = 374

/datum/chemical_reaction/life_friendly/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (friendly)", FRIENDLY_SPAWN)

/datum/chemical_reaction/corgium
	name = "corgium"
	id = "corgium"
	required_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/colorful_reagent = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/blood = 1)
	required_temp = 374

/datum/chemical_reaction/corgium/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = rand(1, created_volume), i <= created_volume, i++) // More lulz.
		new /mob/living/simple_animal/pet/dog/corgi(location)
	..()

//monkey powder heehoo
/datum/chemical_reaction/monkey_powder
	name = /datum/reagent/monkey_powder
	id = /datum/reagent/monkey_powder
	results = list(/datum/reagent/monkey_powder = 3)
	required_reagents = list(/datum/reagent/consumable/banana = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/chicken_powder
	name = /datum/reagent/chicken_powder
	id = /datum/reagent/chicken_powder
	results = list(/datum/reagent/chicken_powder = 3)
	required_reagents = list(/datum/reagent/consumable/eggyolk = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/sheep_powder
	name = /datum/reagent/sheep_powder
	id = /datum/reagent/sheep_powder
	results = list(/datum/reagent/sheep_powder = 3)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/cow_powder
	name = /datum/reagent/cow_powder
	id = /datum/reagent/cow_powder
	results = list(/datum/reagent/cow_powder = 3)
	required_reagents = list(/datum/reagent/consumable/milk = 5, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/goat_powder
	name = /datum/reagent/goat_powder
	id = /datum/reagent/goat_powder
	results = list(/datum/reagent/goat_powder = 3)
	required_reagents = list(/datum/reagent/toxin/plantbgone = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/mouse_powder
	name = /datum/reagent/mouse_powder
	id = /datum/reagent/mouse_powder
	results = list(/datum/reagent/mouse_powder = 3)
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/liquidgibs = 1)
	required_temp = 500

/datum/chemical_reaction/monkey
	name = "monkey"
	id = "monkey"
	required_reagents = list(/datum/reagent/monkey_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/monkey/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/carbon/monkey(location)

/datum/chemical_reaction/gorilla
	name = "gorilla"
	id = "gorilla"
	required_reagents = list(/datum/reagent/gorilla_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/gorilla/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/hostile/gorilla(location)

/datum/chemical_reaction/chicken
	name = "chicken"
	id = "chicken"
	required_reagents = list(/datum/reagent/chicken_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/chicken/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/chicken(location)

/datum/chemical_reaction/cow
	name = "cow"
	id = "cow"
	required_reagents = list(/datum/reagent/cow_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/cow/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/cow(location)

/datum/chemical_reaction/sheep
	name = "sheep"
	id = "sheep"
	required_reagents = list(/datum/reagent/sheep_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/sheep/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/sheep(location)

/datum/chemical_reaction/mouse
	name = "mouse"
	id = "mouse"
	required_reagents = list(/datum/reagent/mouse_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/mouse/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/mouse(location)

/datum/chemical_reaction/goat
	name = "goat"
	id = "goat"
	required_reagents = list(/datum/reagent/goat_powder = 30, /datum/reagent/water = 1)

/datum/chemical_reaction/goat/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/hostile/retaliate/goat(location)

/datum/chemical_reaction/goat/clown
	name = "clowngoat"
	id = "clowngoat"
	required_reagents = list(/datum/reagent/goat_powder = 30, /datum/reagent/consumable/laughter = 5)

/datum/chemical_reaction/goat/clown/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/hostile/retaliate/goat/clown(location)

/datum/chemical_reaction/goat/chaos //FOR CHAOS!
	name = "randomgoat"
	id = "randomgoat"
	required_reagents = list(/datum/reagent/goat_powder = 30, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/goat/chaos/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	var/goat = get_random_goat()
	new goat(location)

/datum/chemical_reaction/goat/huge //very hard to make but definitely not harmless
	name = "hugegoat"
	id = "hugegoat"
	required_reagents = list(/datum/reagent/goat_powder = 30, /datum/reagent/gorilla_powder = 30, /datum/reagent/uranium/radium = 2)

/datum/chemical_reaction/goat/huge/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	if (location) new /mob/living/simple_animal/hostile/retaliate/goat/huge(location)

/datum/chemical_reaction/goat/colorful //harmless
	name = "colorgoat"
	id = "colorgoat"
	required_reagents = list(/datum/reagent/goat_powder = 30, /datum/reagent/colorful_reagent = 5)

/datum/chemical_reaction/goat/colorful/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	var/goat = get_random_goat_colorful()
	new goat(location)

/datum/chemical_reaction/hair_dye
	name = /datum/reagent/hair_dye
	id = /datum/reagent/hair_dye
	results = list(/datum/reagent/hair_dye = 5)
	required_reagents = list(/datum/reagent/colorful_reagent = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/barbers_aid
	name = /datum/reagent/barbers_aid
	id = /datum/reagent/barbers_aid
	results = list(/datum/reagent/barbers_aid = 5)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/concentrated_barbers_aid
	name = /datum/reagent/concentrated_barbers_aid
	id = /datum/reagent/concentrated_barbers_aid
	results = list(/datum/reagent/concentrated_barbers_aid = 2)
	required_reagents = list(/datum/reagent/barbers_aid = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/saltpetre
	name = /datum/reagent/saltpetre
	id = /datum/reagent/saltpetre
	results = list(/datum/reagent/saltpetre = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 3)

/datum/chemical_reaction/lye
	name = /datum/reagent/lye
	id = /datum/reagent/lye
	results = list(/datum/reagent/lye = 3)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/lye2
	name = /datum/reagent/lye
	id = /datum/reagent/lye
	results = list(/datum/reagent/lye = 2)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/water = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/royal_bee_jelly
	name = "royal bee jelly"
	id = /datum/reagent/royal_bee_jelly
	results = list(/datum/reagent/royal_bee_jelly = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 10, /datum/reagent/consumable/honey = 40)

/datum/chemical_reaction/laughter
	name = /datum/reagent/consumable/laughter
	id = /datum/reagent/consumable/laughter
	results = list(/datum/reagent/consumable/laughter = 10) // Fuck it. I'm not touching this one.
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/banana = 1)

/datum/chemical_reaction/plastic_polymers
	name = "plastic polymers"
	id = /datum/reagent/plastic_polymers
	required_reagents = list(/datum/reagent/oil = 5, /datum/reagent/toxin/acid = 2, /datum/reagent/ash = 3)
	required_temp = 374

/datum/chemical_reaction/plastic_polymers/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/plastic(location)

/datum/chemical_reaction/plastic_solidification
	name = "plastic solidification"
	id = "plastic_solidification"
	required_reagents = list(/datum/reagent/plastic_polymers = 10)
	required_temp = 200
	is_cold_recipe = TRUE

/datum/chemical_reaction/plastic_solidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/plastic(location)

/datum/chemical_reaction/pax
	name = /datum/reagent/pax
	id = /datum/reagent/pax
	results = list(/datum/reagent/pax = 3)
	required_reagents  = list(/datum/reagent/toxin/mindbreaker = 1, /datum/reagent/medicine/synaptizine = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/liquidelectricity
	name = /datum/reagent/consumable/liquidelectricity
	id = /datum/reagent/consumable/liquidelectricity
	results = list(/datum/reagent/consumable/liquidelectricity = 2)
	required_reagents = list(/datum/reagent/teslium = 1, /datum/reagent/blood = 2)

/datum/chemical_reaction/cellulose_carbonization
	name = "Cellulose_Carbonization"
	id = /datum/reagent/carbon
	mix_message = "The fibers char, producing a soft black powder."
	results = list(/datum/reagent/carbon = 1)
	required_reagents = list(/datum/reagent/cellulose = 1)
	required_temp = 512

/datum/chemical_reaction/tribalnutriment
	name = "Mushroom Paste Congealation"
	id = "mushroom_paste"
	mix_message = "The mixture congeals into a foul smelling paste."
	results = list(/datum/reagent/plantnutriment/tribalnutriment = 6)
	required_reagents = list(/datum/reagent/consumable/cream/bug = 2, /datum/reagent/consumable/vitfro = 2, /datum/reagent/consumable/entpoly = 2)

/datum/chemical_reaction/resinsolidification
	name = "Ash Resin Solidification"
	id = "resin_solid"
	mix_message = "The resin mixes with the water and solidifies."
	required_reagents = list(/datum/reagent/consumable/ashresin = 5, /datum/reagent/water = 10)

/datum/chemical_reaction/resinsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/ashresin(location)

/datum/chemical_reaction/aloepastification
	name = "Aloepastification"
	id = "Aloepastification"
	required_reagents = list(/datum/reagent/consumable/aloejuice = 30, /datum/reagent/ash  = 30)
	mob_react = FALSE

/datum/chemical_reaction/aloepastification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/medical/aloe(location)

/datum/chemical_reaction/sulphuric_acid
	name = /datum/reagent/toxin/acid
	id = /datum/reagent/toxin/acid
	results = list(/datum/reagent/toxin/acid = 2)
	required_reagents = list(/datum/reagent/sulphur = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/sugar
	name = /datum/reagent/consumable/sugar
	id = /datum/reagent/consumable/sugar
	results = list(/datum/reagent/consumable/sugar = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 1, /datum/reagent/fuel = 1)

/datum/chemical_reaction/welding_fuel
	name = /datum/reagent/fuel
	id = /datum/reagent/fuel
	results = list(/datum/reagent/fuel = 4)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/toxin/acid = 3)
	required_temp = 180
	is_cold_recipe = TRUE

/datum/chemical_reaction/stableplasma
	name = /datum/reagent/stable_plasma
	id = /datum/reagent/stable_plasma
	results = list(/datum/reagent/stable_plasma = 6)
	required_reagents = list(/datum/reagent/toxin/plasma = 3, /datum/reagent/hydrogen = 3)
	required_catalysts =  list(/datum/reagent/consumable/ethanol = 5)
	required_temp = 100
	is_cold_recipe = TRUE

/datum/chemical_reaction/ice
	name = /datum/reagent/consumable/ice
	id = /datum/reagent/consumable/ice
	results = list(/datum/reagent/consumable/ice = 3)
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/lye = 1)
	required_temp = 200
	is_cold_recipe = TRUE

/datum/chemical_reaction/water2
	name = "melting_ice"
	id = "melting_ice"
	results = list(/datum/reagent/water = 1)
	required_reagents = list(/datum/reagent/consumable/ice = 1)
	required_temp = 400

/datum/chemical_reaction/meltedplastic
	name = "microplastic liquification"
	id = "melted_plastic"
	mix_message = "The microplastics turn back into liquid, with a strong unpleasent odor..."
	results = list(/datum/reagent/plastic_polymers = 10)
	required_reagents = list(/datum/reagent/microplastics = 10)
	required_temp = 600
