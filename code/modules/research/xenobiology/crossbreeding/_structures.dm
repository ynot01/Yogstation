GLOBAL_LIST_EMPTY(bluespace_slime_crystals)

/obj/structure/slime_crystal
	name = "slimic pylon"
	desc = "Glassy, pure, transparent. Powerful artifact that relays the slimecore's influence onto space around it."
	max_integrity = 30
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "slime_pylon"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	///Description of the crystal's effects.
	var/effect_desc
	///Assoc list of affected mobs, the key is the mob while the value of the map is the amount of ticks spent inside of the zone.
	var/list/affected_mobs = list()
	///Used to determine wether we use view or range.
	var/range_type = "range"
	///What color is it?
	var/colour
	///Does it use process?
	var/uses_process = TRUE

/obj/structure/slime_crystal/examine(mob/user)
	. = ..()
	if(effect_desc)
		. += span_notice("[effect_desc]")

/obj/structure/slime_crystal/New(loc, obj/structure/slime_crystal/master_crystal, ...)
	. = ..()
	if(master_crystal)
		invisibility = INVISIBILITY_MAXIMUM
		max_integrity = 1000
		obj_integrity = 1000

/obj/structure/slime_crystal/Initialize()
	. = ..()
	name =  "[colour] slimic pylon"
	var/itemcolor = "#FFFFFF"
	switch(colour)
		if("orange")
			itemcolor = "#FFA500"
		if("purple")
			itemcolor = "#B19CD9"
		if("blue")
			itemcolor = "#ADD8E6"
		if("metal")
			itemcolor = "#7E7E7E"
		if("yellow")
			itemcolor = "#FFFF00"
		if("dark purple")
			itemcolor = "#551A8B"
		if("dark blue")
			itemcolor = "#0000FF"
		if("silver")
			itemcolor = "#D3D3D3"
		if("bluespace")
			itemcolor = "#32CD32"
		if("sepia")
			itemcolor = "#704214"
		if("cerulean")
			itemcolor = "#2956B2"
		if("pyrite")
			itemcolor = "#FAFAD2"
		if("red")
			itemcolor = "#FF0000"
		if("green")
			itemcolor = "#00FF00"
		if("pink")
			itemcolor = "#FF69B4"
		if("gold")
			itemcolor = "#FFD700"
		if("oil")
			itemcolor = "#505050"
		if("black")
			itemcolor = "#000000"
		if("light pink")
			itemcolor = "#FFB6C1"
		if("adamantine")
			itemcolor = "#008B8B"
	add_atom_colour(itemcolor, FIXED_COLOUR_PRIORITY)
	if(uses_process)
		START_PROCESSING(SSobj, src)

/obj/structure/slime_crystal/Destroy()
	new /obj/effect/decal/cleanable/glass/plasma(src)
	if(uses_process)
		STOP_PROCESSING(SSobj, src)
	for(var/X in affected_mobs)
		on_mob_leave(X)
	return ..()

/obj/structure/slime_crystal/process()
	if(!uses_process)
		return PROCESS_KILL
	var/list/current_mobs = view_or_range(3, src, range_type)
	for(var/mob/living/mob_in_range in current_mobs)
		if(!(mob_in_range in affected_mobs))
			on_mob_enter(mob_in_range)
			affected_mobs[mob_in_range] = 0
		affected_mobs[mob_in_range]++
		on_mob_effect(mob_in_range)
	for(var/M in affected_mobs - current_mobs)
		on_mob_leave(M)
		affected_mobs -= M

/obj/structure/slime_crystal/proc/master_crystal_destruction()
	qdel(src)

/obj/structure/slime_crystal/proc/on_mob_enter(mob/living/affected_mob)
	return

/obj/structure/slime_crystal/proc/on_mob_effect(mob/living/affected_mob)
	return

/obj/structure/slime_crystal/proc/on_mob_leave(mob/living/affected_mob)
	return

/obj/structure/slime_crystal/grey
	colour = "grey"
	effect_desc = "It's slowly feeding nearby slimes."
	range_type = "view"

/obj/structure/slime_crystal/grey/on_mob_effect(mob/living/affected_mob)
	if(!istype(affected_mob, /mob/living/simple_animal/slime))
		return
	var/mob/living/simple_animal/slime/slime_mob = affected_mob
	slime_mob.nutrition += 2

/obj/structure/slime_crystal/orange
	colour = "orange"
	effect_desc = "Ignites anyone in range of the crystal and heats the surrounding air. Effect is blocked by walls."
	range_type = "view"

/obj/structure/slime_crystal/orange/on_mob_effect(mob/living/affected_mob)
	if(!istype(affected_mob, /mob/living/carbon))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	carbon_mob.fire_stacks++
	carbon_mob.IgniteMob()

/obj/structure/slime_crystal/orange/process()
	. = ..()
	var/turf/open/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/gas = T.return_air()
	gas.set_temperature(T0C + 200)
	T.air_update_turf()

/obj/structure/slime_crystal/purple
	colour = "purple"
	effect_desc = "It's slowly healing humans and creatures in range of all types of damage."
	var/heal_amt = 2

/obj/structure/slime_crystal/purple/on_mob_effect(mob/living/affected_mob)
	if(!istype(affected_mob, /mob/living/carbon))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	var/rand_dam_type = rand(0, 10)
	new /obj/effect/temp_visual/heal(get_turf(affected_mob), "#e180ff")
	switch(rand_dam_type)
		if(0)
			carbon_mob.adjustBruteLoss(-heal_amt)
		if(1)
			carbon_mob.adjustFireLoss(-heal_amt)
		if(2)
			carbon_mob.adjustOxyLoss(-heal_amt)
		if(3)
			carbon_mob.adjustToxLoss(-heal_amt)
		if(4)
			carbon_mob.adjustCloneLoss(-heal_amt)
		if(5)
			carbon_mob.adjustStaminaLoss(-heal_amt)
		if(6 to 10)
			carbon_mob.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN,ORGAN_SLOT_HEART,ORGAN_SLOT_LIVER,ORGAN_SLOT_LUNGS), -heal_amt)

/obj/structure/slime_crystal/blue
	colour = "blue"
	effect_desc = "It stabilizes air around it to the standard O2/N2 mixture, and stabilizes the temperature. Effect is blocked by walls."
	range_type = "view"

/obj/structure/slime_crystal/blue/process()
	for(var/turf/open/T in view(2, src))
		if(isspaceturf(T))
			continue
		var/datum/gas_mixture/gas = T.return_air()
		gas.parse_gas_string(OPENTURF_DEFAULT_ATMOS)
		T.air_update_turf()

/obj/structure/slime_crystal/metal
	colour = "metal"
	effect_desc = "Slowly heals cyborgs in range."
	var/heal_amt = 1

/obj/structure/slime_crystal/metal/on_mob_effect(mob/living/affected_mob)
	if(!iscyborg(affected_mob))
		return
	var/mob/living/silicon/borgo = affected_mob
	borgo.adjustBruteLoss(-heal_amt)

/obj/structure/slime_crystal/yellow
	colour = "yellow"
	effect_desc = "When struck by a cell, the cell will be instantly charged. Fully charged cells will explode when striking the crystal."
	light_color = LIGHT_COLOR_YELLOW //a good, sickly atmosphere
	light_power = 0.75
	uses_process = FALSE

/obj/structure/slime_crystal/yellow/Initialize()
	. = ..()
	set_light(3)

/obj/structure/slime_crystal/yellow/attacked_by(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/cell = I
		//Punishment for greed
		if(cell.charge == cell.maxcharge)
			to_chat("<span class = 'danger'> You try to charge the cell, but it is already fully energized. You are not sure if this was a good idea...")
			cell.explode()
			return
		to_chat("<span class = 'notice'> You charged the [I.name] on [name]!")
		cell.give(cell.maxcharge)
		return
	return ..()

/obj/structure/slime_crystal/darkpurple
	colour = "dark purple"
	effect_desc = "It consumes plasma in the air, converting it into plasma sheets. Crystal releases and ignites a small amount of plasma when destroyed."

/obj/structure/slime_crystal/darkpurple/process()
	var/turf/T = get_turf(src)
	if(!istype(T, /turf/open))
		return
	var/turf/open/open_turf = T
	var/datum/gas_mixture/air = open_turf.return_air()
	if(air.get_moles(/datum/gas/plasma) > 15)
		air.adjust_moles(/datum/gas/plasma, -15)
		new /obj/item/stack/sheet/mineral/plasma(open_turf)

/obj/structure/slime_crystal/darkpurple/Destroy()
	atmos_spawn_air("plasma=[20];TEMP=[500]")
	return ..()

/obj/structure/slime_crystal/darkblue
	colour = "dark blue"
	effect_desc = "Cleans and dries tiles in the area around it."

/obj/structure/slime_crystal/darkblue/process()
	var/list/listie = range(5,src)
	for(var/turf/open/T in listie)
		if(prob(75))
			continue
		var/turf/open/open_turf = T
		open_turf.MakeDry(TURF_WET_LUBE)
	for(var/obj/item/trash/trashie in listie)
		if(prob(25))
			qdel(trashie)

/obj/structure/slime_crystal/silver
	colour = "silver"
	effect_desc = "Plants grow faster in the area around it. Crystal also prevents weeds and pests from growing at all."

/obj/structure/slime_crystal/silver/process()
	for(var/obj/machinery/hydroponics/hydr in range(5,src))
		hydr.weedlevel = 0
		hydr.pestlevel = 0
		hydr.age ++

/obj/structure/slime_crystal/bluespace
	colour = "bluespace"
	effect_desc = "Acts as a beacon to other crystals of this type. Click with an empty hand to teleport between them."
	density = FALSE
	uses_process = FALSE
	///Is it in use?
	var/in_use = FALSE

/obj/structure/slime_crystal/bluespace/Initialize()
	. = ..()
	GLOB.bluespace_slime_crystals += src

/obj/structure/slime_crystal/bluespace/Destroy()
	GLOB.bluespace_slime_crystals -= src
	return ..()

/obj/structure/slime_crystal/bluespace/attack_hand(mob/user)
	if(in_use)
		return
	var/list/local_bs_list = GLOB.bluespace_slime_crystals.Copy()
	local_bs_list -= src
	if(!LAZYLEN(local_bs_list))
		return ..()
	if(local_bs_list.len == 1)
		do_teleport(user, local_bs_list[1])
		return
	in_use = TRUE
	var/list/assoc_list = list()
	for(var/BSC in local_bs_list)
		var/area/bsc_area = get_area(BSC)
		var/name = "[bsc_area.name] bluespace slimic pylon"
		var/counter = 0
		do
			counter++
		while(assoc_list["[name]([counter])"])
		name += "([counter])"
		assoc_list[name] = BSC
	var/chosen_input = input(user,"What destination do you want to choose",null) as null|anything in assoc_list
	in_use = FALSE
	if(!chosen_input || !assoc_list[chosen_input])
		return
	do_teleport(user ,assoc_list[chosen_input])

/obj/structure/slime_crystal/sepia
	colour = "sepia"
	effect_desc = "Everything in the area around it is put in stasis as if on a stasis bed. Does not stun like a stasis bed."

/obj/structure/slime_crystal/sepia/on_mob_enter(mob/living/affected_mob)
	ADD_TRAIT(affected_mob,TRAIT_NOBREATH,type)
	ADD_TRAIT(affected_mob,TRAIT_NOCRITDAMAGE,type)
	ADD_TRAIT(affected_mob,TRAIT_RESISTLOWPRESSURE,type)
	ADD_TRAIT(affected_mob,TRAIT_RESISTHIGHPRESSURE,type)
	ADD_TRAIT(affected_mob,TRAIT_NOSOFTCRIT,type)
	ADD_TRAIT(affected_mob,TRAIT_NOHARDCRIT,type)

/obj/structure/slime_crystal/sepia/on_mob_leave(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob,TRAIT_NOBREATH,type)
	REMOVE_TRAIT(affected_mob,TRAIT_NOCRITDAMAGE,type)
	REMOVE_TRAIT(affected_mob,TRAIT_RESISTLOWPRESSURE,type)
	REMOVE_TRAIT(affected_mob,TRAIT_RESISTHIGHPRESSURE,type)
	REMOVE_TRAIT(affected_mob,TRAIT_NOSOFTCRIT,type)
	REMOVE_TRAIT(affected_mob,TRAIT_NOHARDCRIT,type)

/obj/structure/cerulean_slime_crystal
	name = "Cerulean slime poly-crystal"
	desc = "Translucent and irregular, it can duplicate matter on a whim"
	anchored = TRUE
	density = FALSE
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "cerulean_crystal"
	max_integrity = 5
	var/stage = 0
	var/max_stage = 5

/obj/structure/cerulean_slime_crystal/Initialize()
	. = ..()
	transform *= 1/(max_stage-1)
	stage_growth()

/obj/structure/cerulean_slime_crystal/proc/stage_growth()
	if(stage == max_stage)
		return
	if(stage == 3)
		density = TRUE
	stage ++
	var/matrix/M = new
	M.Scale(1/max_stage * stage)
	animate(src, transform = M, time = 60 SECONDS)
	addtimer(CALLBACK(src, .proc/stage_growth), 60 SECONDS)

/obj/structure/cerulean_slime_crystal/Destroy()
	if(stage > 1)
		var/obj/item/cerulean_slime_crystal/crystal = new(get_turf(src))
		crystal.amt = stage
	return ..()

/obj/structure/slime_crystal/cerulean
	colour = "cerulean"
	effect_desc = "Nearby tiles will gradually grow slime crystals. These slime crystals, when harvested, may be combined with any material sheet to increase its stack size by 5."

/obj/structure/slime_crystal/cerulean/process()
	for(var/turf/T in range(2,src))
		if(is_blocked_turf(T) || isspaceturf(T)  || T == get_turf(src) || prob(50))
			continue
		var/obj/structure/cerulean_slime_crystal/CSC = locate() in range(1,T)
		if(CSC)
			continue
		new /obj/structure/cerulean_slime_crystal(T)

/obj/structure/slime_crystal/pyrite
	colour = "pyrite"
	effect_desc = "It causes nearby floor tiles to be randomly colored."
	uses_process = FALSE

/obj/structure/slime_crystal/pyrite/Initialize()
	. = ..()
	change_colour()

/obj/structure/slime_crystal/pyrite/proc/change_colour()
	var/list/color_list = list("#FFA500","#B19CD9", "#ADD8E6","#7E7E7E","#FFFF00","#551A8B","#0000FF","#D3D3D3", "#32CD32","#704214","#2956B2","#FAFAD2", "#FF0000",
					"#00FF00", "#FF69B4","#FFD700", "#505050", "#FFB6C1","#008B8B")
	for(var/turf/T in RANGE_TURFS(4,src))
		T.add_atom_colour(pick(color_list), FIXED_COLOUR_PRIORITY)
	addtimer(CALLBACK(src,.proc/change_colour),rand(0.75 SECONDS,1.25 SECONDS))

/obj/structure/slime_crystal/red
	colour = "red"
	effect_desc = "This crystal cleans blood from the ground in a wide area and may store up to 300u of gathered blood. Touching the crystal will consume 50u blood and create a piece of meat or a random functional organ. Containers may also be used on the crystal to transfer blood directly out of it."
	var/blood_amt = 0
	var/max_blood_amt = 300
/obj/structure/slime_crystal/red/examine(mob/user)
	. = ..()
	. += "It has [blood_amt] u of blood."


/obj/structure/slime_crystal/red/process()
	if(blood_amt == max_blood_amt)
		return
	for(var/obj/effect/decal/cleanable/B in range(5,src))
		if(istype(B, /obj/effect/decal/cleanable/blood))
			blood_amt += 10
			if(blood_amt > max_blood_amt)
				blood_amt = max_blood_amt
				break
			qdel(B)
		else if (istype(B, /obj/effect/decal/cleanable/trail_holder))
			blood_amt += 3
			if(blood_amt > max_blood_amt)
				blood_amt = max_blood_amt
				break
			qdel(B)
		return

/obj/structure/slime_crystal/red/attack_hand(mob/user)
	if(blood_amt < 50)
		return ..()
	blood_amt -= 50
	to_chat(user, span_notice("You touch the crystal, and see blood transforming into an organ!"))
	playsound(src, 'sound/magic/demon_consume.ogg', 50, 1)
	var/type = pick(/obj/item/reagent_containers/food/snacks/meat/slab,/obj/item/organ/heart,/obj/item/organ/heart/freedom,/obj/item/organ/lungs,/obj/item/organ/lungs/plasmaman,/obj/item/organ/lungs/slime,/obj/item/organ/liver,/obj/item/organ/liver/plasmaman,/obj/item/organ/liver/alien,/obj/item/organ/eyes,/obj/item/organ/eyes/night_vision/alien,/obj/item/organ/eyes/night_vision,/obj/item/organ/eyes/night_vision/mushroom,/obj/item/organ/tongue,/obj/item/organ/stomach,/obj/item/organ/stomach/plasmaman,/obj/item/organ/stomach/ethereal,/obj/item/organ/ears,/obj/item/organ/ears/cat,/obj/item/organ/ears/penguin)
	new type(get_turf(src))

/obj/structure/slime_crystal/red/attacked_by(obj/item/I, mob/living/user)
	if(blood_amt < 10)
		return ..()
	if(!istype(I, /obj/item/reagent_containers/glass/beaker))
		return ..()
	var/obj/item/reagent_containers/glass/beaker/item_beaker = I
	if(!item_beaker.is_refillable() || (item_beaker.reagents.total_volume + 10 > item_beaker.reagents.maximum_volume))
		return ..()
	blood_amt -= 10
	item_beaker.reagents.add_reagent(/datum/reagent/blood,10)
	to_chat(user, span_notice("You transfer some of strored blood into [I]!"))

/obj/structure/slime_crystal/green
	colour = "green"
	effect_desc = "Crystal stores one random mutation from the last player who interacted with it (starts with none). People standing near it are gradually cured of their mutations but will be forcefully given the mutation stored in the crystal"
	var/datum/mutation/stored_mutation

/obj/structure/slime_crystal/green/examine(mob/user)
	. = ..()
	if(stored_mutation)
		. += "It currently stores [stored_mutation.name]"
	else
		. += "It doesn't hold any mutations"

/obj/structure/slime_crystal/green/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	var/list/mutation_list = human_user.dna.mutations
	stored_mutation = pick(mutation_list)
	stored_mutation = stored_mutation.type

/obj/structure/slime_crystal/green/on_mob_effect(mob/living/affected_mob)
	if(!ishuman(affected_mob) || !stored_mutation || HAS_TRAIT(affected_mob,TRAIT_BADDNA))
		return
	var/mob/living/carbon/human/human_mob = affected_mob
	human_mob.dna.add_mutation(stored_mutation)
	if(affected_mobs[affected_mob] % 60 != 0)
		return
	var/list/mut_list = human_mob.dna.mutations
	var/list/secondary_list = list()
	for(var/X in mut_list)
		if(istype(X,stored_mutation))
			continue
		var/datum/mutation/t_mutation = X
		secondary_list += t_mutation.type
	var/datum/mutation/mutation = pick(secondary_list)
	human_mob.dna.remove_mutation(mutation)

/obj/structure/slime_crystal/green/on_mob_leave(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/human_mob = affected_mob
	human_mob.dna.remove_mutation(stored_mutation)

/obj/structure/slime_crystal/pink
	colour = "pink"
	effect_desc = "Anyone near this crystal is pacified."

/obj/structure/slime_crystal/pink/on_mob_enter(mob/living/affected_mob)
	ADD_TRAIT(affected_mob,TRAIT_PACIFISM,type)

/obj/structure/slime_crystal/pink/on_mob_leave(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob,TRAIT_PACIFISM,type)

/obj/structure/slime_crystal/gold
	colour = "gold"
	effect_desc = "Touching it will transform you into a random pet. Effects are undone when leaving the area."
	var/list/gold_pet_options = list(/mob/living/simple_animal/pet/dog/corgi , /mob/living/simple_animal/pet/dog/pug , /mob/living/simple_animal/pet/dog/bullterrier , /mob/living/simple_animal/crab , /mob/living/simple_animal/pet/fox , /mob/living/simple_animal/pet/cat/kitten , /mob/living/simple_animal/pet/cat/space , /mob/living/simple_animal/pet/penguin/emperor , /mob/living/simple_animal/pet/penguin/baby)

/obj/structure/slime_crystal/gold/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_mob = user
	var/mob/living/simple_animal/chosen_pet = pick(gold_pet_options)
	chosen_pet = new chosen_pet(get_turf(human_mob))
	if(chosen_pet)
		to_chat(user, span_notice("You touch the crystal, and become a small animal!"))
		playsound(src, 'sound/magic/fireball.ogg', 50, 1)
		human_mob.forceMove(chosen_pet)
		human_mob.notransform = 1
		ADD_TRAIT(human_mob, TRAIT_MUTE, STASIS_MUTE)
		human_mob.status_flags |= GODMODE
		human_mob.mind.transfer_to(chosen_pet)

/obj/structure/slime_crystal/gold/on_mob_leave(mob/living/affected_mob)
	if(!is_type_in_list(affected_mob, gold_pet_options))
		return
	var/mob/living/carbon/human/human_mob = locate() in affected_mob
	if(!human_mob)
		return
	REMOVE_TRAIT(human_mob, TRAIT_MUTE, STASIS_MUTE)
	human_mob.status_flags &= ~GODMODE
	human_mob.notransform = 0
	affected_mob.mind.transfer_to(human_mob)
	human_mob.forceMove(get_turf(affected_mob))
	qdel(affected_mob)



/obj/structure/slime_crystal/oil
	colour = "oil"
	effect_desc = "It's covering nearbly floors with lube."

/obj/structure/slime_crystal/oil/process()
	for(var/T in RANGE_TURFS(3,src))
		if(!isopenturf(T))
			continue
		var/turf/open/turf_in_range = T
		turf_in_range.MakeSlippery(TURF_WET_LUBE,5 SECONDS)

/obj/structure/slime_crystal/black
	colour = "black"
	effect_desc = "People standing near this crystal will begin slowly transforming into a random slimeperson. Has no effect on slimepeople."

/obj/structure/slime_crystal/black/on_mob_effect(mob/living/affected_mob)
	if(!ishuman(affected_mob) || isjellyperson(affected_mob))
		return

	if(affected_mobs[affected_mob] < 30) //Around a minute
		return

	var/mob/living/carbon/human/human_transformed = affected_mob
	human_transformed.set_species(pick(typesof(/datum/species/jelly)))

/obj/structure/slime_crystal/lightpink
	colour = "light pink"
	effect_desc = "Crystal converts lost souls into harmless, healing lightgheists that disappear when too far away from the crystal."

/obj/structure/slime_crystal/lightpink/attack_ghost(mob/user)
	. = ..()
	var/be_helper = alert("Become a Lightgeist? (Warning, You can no longer be cloned!)",,"Yes","No")
	if(be_helper == "Yes" && !QDELETED(src) && isobserver(user))
		var/mob/living/simple_animal/hostile/lightgeist/healing/W = new /mob/living/simple_animal/hostile/lightgeist/healing/slime(get_turf(loc))
		W.key = user.key

/obj/structure/slime_crystal/lightpink/on_mob_leave(mob/living/affected_mob)
	if(istype(affected_mob,/mob/living/simple_animal/hostile/lightgeist/healing/slime))
		affected_mob.ghostize(TRUE)
		qdel(affected_mob)

/obj/structure/slime_crystal/adamantine
	colour = "adamantine"
	effect_desc = "It makes everyone nearby more resistant."
	max_integrity = 70 //Crystal is more resistant itself

/obj/structure/slime_crystal/adamantine/on_mob_enter(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/human = affected_mob
	human.dna.species.brutemod *= 0.5  //Hefty resistance, great for point defence.
	human.dna.species.burnmod *= 0.5

/obj/structure/slime_crystal/adamantine/on_mob_leave(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/human = affected_mob
	human.dna.species.brutemod *= 2
	human.dna.species.burnmod *= 2
/obj/structure/slime_crystal/rainbow
	colour = "rainbow"
	effect_desc = "It absorbs other crystal slime cores and combines their powers."
	uses_process = FALSE
	max_integrity = 100 //It would suck destroying this by accident
	var/list/inserted_cores = list()

/obj/structure/slime_crystal/rainbow/Initialize()
	. = ..()
	for(var/X in subtypesof(/obj/item/slimecross/crystalized) - /obj/item/slimecross/crystalized/rainbow)
		inserted_cores[X] = FALSE

/obj/structure/slime_crystal/rainbow/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(!istype(I,/obj/item/slimecross/crystalized) || istype(I,/obj/item/slimecross/crystalized/rainbow))
		return
	var/obj/item/slimecross/crystalized/slimecross = I
	if(inserted_cores[slimecross.type])
		return
	inserted_cores[slimecross.type] = new slimecross.crystal_type(get_turf(src),src)
	qdel(slimecross)

/obj/structure/slime_crystal/rainbow/Destroy()
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.master_crystal_destruction()
	return ..()

/obj/structure/slime_crystal/rainbow/attack_hand(mob/user)
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.attack_hand(user)
	. = ..()

/obj/structure/slime_crystal/rainbow/attacked_by(obj/item/I, mob/living/user)
	for(var/X in inserted_cores)
		if(inserted_cores[X])
			var/obj/structure/slime_crystal/SC = inserted_cores[X]
			SC.attacked_by(user)
	. = ..()
