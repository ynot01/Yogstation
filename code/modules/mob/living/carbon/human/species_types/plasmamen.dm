/datum/species/plasmaman
	name = "Plasmaman"
	plural_form = "Plasmamen"
	id = "plasmaman"
	say_mod = "rattles"
	sexes = FALSE
	meat = /obj/item/stack/sheet/mineral/plasma
	species_traits = list(NOBLOOD,NOTRANSSTING, HAS_BONE, AGENDER, NOHUSK)
	// plasmemes get hard to wound since they only need a severe bone wound to dismember, but unlike skellies, they can't pop their bones back into place.
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_NOHUNGER,TRAIT_CALCIUM_HEALER,TRAIT_ALWAYS_CLEAN,TRAIT_HARDLY_WOUNDED)
	inherent_biotypes = list(MOB_UNDEAD, MOB_HUMANOID)
	mutant_bodyparts = list("plasmaman_helmet")
	default_features = list("plasmaman_helmet" = "None")
	mutantlungs = /obj/item/organ/lungs/plasmaman
	mutanttongue = /obj/item/organ/tongue/bone/plasmaman
	mutantliver = /obj/item/organ/liver/plasmaman
	mutantstomach = /obj/item/organ/stomach/plasmaman
	burnmod = 1.5 //Lives in suits and burns easy. Lasers are bad for this
	heatmod = 1.5 //Same goes for hot hot hot
	brutemod = 1.2 //Rattle me bones, but less because plasma bones are very hard
	siemens_coeff = 1.5 //Sparks are bad for the combustable race, mkay?
	punchdamagehigh = 7 //Bone punches are weak and usually inside soft suit gloves
	punchstunthreshold = 7 //Stuns on max hit as usual, somewhat higher stun chance because math
	payday_modifier = 1 //Former humans, employment restrictions arise from psychological and practical concerns; they won't be able to be some head positions, but they get human pay and NT can't weasel out of it
	breathid = "tox"
	damage_overlay_type = ""//let's not show bloody wounds or burns over bones.
	disliked_food = NONE
	liked_food = DAIRY
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	species_language_holder = /datum/language_holder/plasmaman

	smells_like = "plasma-caked calcium"

	/// If the bones themselves are burning clothes won't help you much
	var/internal_fire = FALSE

/datum/species/plasmaman/spec_life(mob/living/carbon/human/H)
	var/datum/gas_mixture/environment = H.loc.return_air()
	var/atmos_sealed = FALSE
	if (H.wear_suit && H.head && istype(H.wear_suit, /obj/item/clothing) && istype(H.head, /obj/item/clothing))
		var/obj/item/clothing/CS = H.wear_suit
		var/obj/item/clothing/CH = H.head
		if (CS.clothing_flags & CH.clothing_flags & STOPSPRESSUREDAMAGE)
			atmos_sealed = TRUE
	if((!istype(H.w_uniform, /obj/item/clothing/under/plasmaman) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasmaman)) && !atmos_sealed)
		if(environment)
			if(environment.total_moles())
				if(environment.get_moles(/datum/gas/oxygen) >= 1) //Same threshhold that extinguishes fire
					H.adjust_fire_stacks(0.5)
					if(!H.on_fire && H.fire_stacks > 0)
						H.visible_message(span_danger("[H]'s body reacts with the atmosphere and bursts into flames!"),span_userdanger("Your body reacts with the atmosphere and bursts into flame!"))
					H.IgniteMob()
					internal_fire = TRUE
	else
		if(H.fire_stacks)
			var/obj/item/clothing/under/plasmaman/P = H.w_uniform
			if(istype(P))
				P.Extinguish(H)
				internal_fire = FALSE
		else
			internal_fire = FALSE
	H.update_fire()

/datum/species/plasmaman/handle_fire(mob/living/carbon/human/H, no_protection)
	if(internal_fire)
		no_protection = TRUE
	. = ..()

/datum/species/plasmaman/before_equip_job(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
	var/current_job = J.title
	var/datum/outfit/plasmaman/O = new /datum/outfit/plasmaman
	switch(current_job)
		if("Bartender")
			O = new /datum/outfit/job/plasmaman/bartender

		if("Cook")
			O = new /datum/outfit/job/plasmaman/cook

		if("Botanist")
			O = new /datum/outfit/job/plasmaman/botanist

		if("Curator")
			O = new /datum/outfit/job/plasmaman/curator

		if("Chaplain")
			O = new /datum/outfit/job/plasmaman/chaplain

		if("Janitor")
			O = new /datum/outfit/job/plasmaman/janitor

		if("Security Officer")
			O = new /datum/outfit/job/plasmaman/security

		if("Detective")
			O = new /datum/outfit/job/plasmaman/detective

		if("Warden")
			O = new /datum/outfit/job/plasmaman/warden

		if("Cargo Technician")
			O = new /datum/outfit/job/plasmaman/cargo_tech

		if("Quartermaster")
			O = new /datum/outfit/job/plasmaman/quartermaster

		if("Shaft Miner")
			O = new /datum/outfit/job/plasmaman/miner

		if("Lawyer")
			O = new /datum/outfit/job/plasmaman/lawyer

		if("Medical Doctor")
			O = new /datum/outfit/job/plasmaman/doctor

		if("Virologist")
			O = new /datum/outfit/job/plasmaman/virologist

		if("Chemist")
			O = new /datum/outfit/job/plasmaman/chemist

		if("Geneticist")
			O = new /datum/outfit/job/plasmaman/geneticist

		if("Scientist")
			O = new /datum/outfit/job/plasmaman/scientist

		if("Roboticist")
			O = new /datum/outfit/job/plasmaman/roboticist

		if("Station Engineer")
			O = new /datum/outfit/job/plasmaman/engineer

		if("Atmospheric Technician")
			O = new /datum/outfit/job/plasmaman/atmos

		if("Mime")
			O = new /datum/outfit/job/plasmaman/mime

		if("Clown")
			O = new /datum/outfit/job/plasmaman/clown

		if("Network Admin")
			O = new /datum/outfit/job/plasmaman/sigtech

		if("Mining Medic")
			O = new /datum/outfit/job/plasmaman/miningmedic

		if("Paramedic")
			O = new /datum/outfit/job/plasmaman/paramedic

		if("Psychiatrist")
			O = new /datum/outfit/job/plasmaman/psych

		if("Brig Physician")
			O = new /datum/outfit/job/plasmaman/brigphysician

		if("Clerk")
			O = new /datum/outfit/job/plasmaman/clerk

		if("Tourist")
			O = new /datum/outfit/job/plasmaman/tourist

		if("Assistant")
			O = new /datum/outfit/job/plasmaman/assistant

		if("Artist")
			O = new /datum/outfit/job/plasmaman/artist

		if("Chief Engineer")
			O = new /datum/outfit/job/plasmaman/ce

		if("Research Director")
			O = new /datum/outfit/job/plasmaman/rd

		if("Chief Medical Officer")
			O = new /datum/outfit/job/plasmaman/cmo

		if("Head of Personnel")
			O = new /datum/outfit/job/plasmaman/hop

	H.equipOutfit(O, visualsOnly)
	H.open_internals(H.get_item_for_held_index(2))

	var/obj/item/clothing/head/helmet/space/plasmaman/plasmeme_helmet = H.head
	plasmeme_helmet.set_design(H)

/datum/species/plasmaman/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_plasmaman_name()

	var/randname = plasmaman_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/plasmaman/get_species_description()
	return "Reanimated skeletons of those who died in plasma fires, plasmamen are the first alien sapient beings to be \
		discovered, even though they're mainly former humans. While horrifying, most manage to return to their previous position in society before their transformation."

/datum/species/plasmaman/get_species_lore()
	return list(
		"In 2384 on the NVS Grey Voyager, tests were conducted on a new element found by Nanotrasen: baroxuldium, \
		also called plasma. During one test, a catastrophic accident caused the entire ship's inside to be \
		incinerated by a plasma fire, killing the whole crew.",

		"To the surprise of the rescue party, inside the ship's plasma-soaked shell were the first ever non-human, \
		sapient beings encountered by humanity: plasmamen. Once rescued, they were kept in cells with an air composed \
		exclusively of plasma, as it was quickly discovered that their body was unable to \"live\" without a steady supply \
		of it and even igniting when exposed to oxygen. After the development of the first envirosuits, the plasmamen were \
		able to leave their confinement to return working for Nanotrasen.",

		"While subject to discrimination from others due to their morbid appearance, most plasmamen are former \
		humans and, as such, tend to get better treatment than most other non-humans. Notably, all plasmamen keep \
		their SIC citizenship and legal rights as humans, even though artificial intelligence refuses to \
		acknowledge them as such. There is no central authority for plasmamen. They often pledge the same allegiance \
		of their previous life if they retain national impulses, which is rare. They are noted to form communities \
		with other plasmamen to better understand their new existence, often called \"Lazarus groups\"",

		"Plasmamen remember only fragments of their own lives, but they are curiously blurred with \
		memories of those who died in the same fire as them. This often creates confusion about the past \
		self which leads them to sometimes seek new beginnings under a new name. They tend to be somewhat distant or \
		apathetic, working tirelessly toward whatever goal they have. Furthermore, they have no physical or \
		psychological needs for food, sleep, a home, or a social relationship, though they can sometimes feel \
		a desire for them.",

		"With plasma usage spreading, more and more accidents lead to the creations of more plasmamen. \
		As Nanotrasen is the leader in the field of plasma research, most plasmamen are among their ranks, \
		but they can be rarely found in other parts of the SIC.",
	)

/datum/species/plasmaman/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "user-shield",
			SPECIES_PERK_NAME = "Protected",
			SPECIES_PERK_DESC = "Plasmamen are immune to radiation, poisons, and most diseases.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bone",
			SPECIES_PERK_NAME = "Wound Resistance",
			SPECIES_PERK_DESC = "Plasmamen have higher tolerance for damage that would wound others.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Plasma Healing",
			SPECIES_PERK_DESC = "Plasmamen can heal wounds by consuming plasma.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "hard-hat",
			SPECIES_PERK_NAME = "Protective Helmet",
			SPECIES_PERK_DESC = "Plasmamen's helmets provide them shielding from the flashes of welding, as well as an inbuilt flashlight.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fire",
			SPECIES_PERK_NAME = "Living Torch",
			SPECIES_PERK_DESC = "Plasmamen instantly ignite when their body makes contact with oxygen.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Plasma Breathing",
			SPECIES_PERK_DESC = "Plasmamen must breathe plasma to survive. You receive a tank when you arrive.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "briefcase-medical",
			SPECIES_PERK_NAME = "Complex Biology",
			SPECIES_PERK_DESC = "Plasmamen take specialized medical knowledge to be \
				treated. Do not expect speedy revival, if you are lucky enough to get \
				one at all.",
		),
	)

	return to_add
