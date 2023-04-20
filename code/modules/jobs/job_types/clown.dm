/datum/job/clown
	title = "Clown"
	description = "Entertain the crew, make bad jokes, go on a holy quest to find bananium, HONK!"
	flag = CLOWN
	orbit_icon = "face-grin-tears"
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/clown

	alt_titles = list("Entertainer", "Comedian", "Jester", "Improv Artist")

	added_access = list()
	base_access = list(ACCESS_THEATRE)
	paycheck = PAYCHECK_MINIMAL
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_CLOWN
	minimal_character_age = 18 //Honk
	
	departments_list = list(
		/datum/job_department/service,
	)

	mail_goodies = list(
		/obj/item/reagent_containers/food/snacks/grown/banana = 100,
		/obj/item/reagent_containers/food/snacks/pie/cream = 50,
		/obj/item/clothing/shoes/clown_shoes/combat = 10,
		/obj/item/reagent_containers/spray/waterflower/lube = 20 // lube
		///obj/item/reagent_containers/spray/waterflower/superlube = 1 // Superlube, good lord.
	)

	smells_like = "kinda funny"


/datum/job/clown/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	H.apply_pref_name(/datum/preference/name/clown, M.client)

/datum/outfit/job/clown
	name = "Clown"
	jobtype = /datum/job/clown

	pda_type = /obj/item/modular_computer/tablet/pda/preset/basic/clown

	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/bikehorn
	backpack_contents = list(
		/obj/item/stamp/clown = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/instrument/bikehorn = 1,
		)

	implants = list(/obj/item/implant/sad_trombone)

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	duffelbag = /obj/item/storage/backpack/duffelbag/clown //strangely has a duffel

	box = /obj/item/storage/box/hug/survival

	chameleon_extras = /obj/item/stamp/clown

/datum/outfit/job/clown/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		backpack_contents[/obj/item/stack/sheet/mineral/bananium/five] = 1

/datum/outfit/job/clown/get_types_to_preload()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		. += /obj/item/stack/sheet/mineral/bananium/five

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	if(H.mind)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/woodenducky)
	H.fully_replace_character_name(H.real_name, pick(GLOB.clown_names)) //rename the mob AFTER they're equipped so their ID gets updated properly.
	H.dna.add_mutation(CLOWNMUT)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE
