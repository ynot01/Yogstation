#define EMP_RANDOMISE_TIME 300

/datum/action/item_action/chameleon/drone/randomise
	name = "Randomise Headgear"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "random"

/datum/action/item_action/chameleon/drone/randomise/Trigger()
	if(!IsAvailable())
		return

	// Damn our lack of abstract interfeces
	if (istype(target, /obj/item/clothing/head/chameleon/drone))
		var/obj/item/clothing/head/chameleon/drone/X = target
		X.chameleon_action.random_look(owner)
	if (istype(target, /obj/item/clothing/mask/chameleon/drone))
		var/obj/item/clothing/mask/chameleon/drone/Z = target
		Z.chameleon_action.random_look(owner)

	return 1


/datum/action/item_action/chameleon/drone/togglehatmask
	name = "Toggle Headgear Mode"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'

/datum/action/item_action/chameleon/drone/togglehatmask/New()
	..()

	if (istype(target, /obj/item/clothing/head/chameleon/drone))
		button_icon_state = "drone_camogear_helm"
	if (istype(target, /obj/item/clothing/mask/chameleon/drone))
		button_icon_state = "drone_camogear_mask"

/datum/action/item_action/chameleon/drone/togglehatmask/Trigger()
	if(!IsAvailable())
		return

	// No point making the code more complicated if no non-drone
	// is ever going to use one of these

	var/mob/living/simple_animal/drone/D

	if(istype(owner, /mob/living/simple_animal/drone))
		D = owner
	else
		return

	// The drone unEquip() proc sets head to null after dropping
	// an item, so we need to keep a reference to our old headgear
	// to make sure it's deleted.
	var/obj/old_headgear = target
	var/obj/new_headgear

	if(istype(old_headgear, /obj/item/clothing/head/chameleon/drone))
		new_headgear = new /obj/item/clothing/mask/chameleon/drone()
	else if(istype(old_headgear, /obj/item/clothing/mask/chameleon/drone))
		new_headgear = new /obj/item/clothing/head/chameleon/drone()
	else
		to_chat(owner, span_warning("You shouldn't be able to toggle a camogear helmetmask if you're not wearing it"))
	if(new_headgear)
		// Force drop the item in the headslot, even though
		// it's has TRAIT_NODROP
		D.dropItemToGround(target, TRUE)
		qdel(old_headgear)
		// where is `SLOT_HEAD` defined? WHO KNOWS
		D.equip_to_slot(new_headgear, SLOT_HEAD)
	return 1


/datum/action/chameleon_outfit
	name = "Select Chameleon Outfit"
	button_icon_state = "chameleon_outfit"
	var/list/outfit_options //By default, this list is shared between all instances. It is not static because if it were, subtypes would not be able to have their own. If you ever want to edit it, copy it first.
	syndicate = TRUE
	
/datum/action/chameleon_outfit/New()
	..()
	initialize_outfits()

/datum/action/chameleon_outfit/proc/initialize_outfits()
	var/static/list/standard_outfit_options
	if(!standard_outfit_options)
		standard_outfit_options = list()
		for(var/path in subtypesof(/datum/outfit/job))
			var/datum/outfit/O = path
			if(initial(O.can_be_admin_equipped))
				standard_outfit_options[initial(O.name)] = path
		sortTim(standard_outfit_options, /proc/cmp_text_asc)
	outfit_options = standard_outfit_options

/datum/action/chameleon_outfit/Trigger()
	return select_outfit(owner)

/datum/action/chameleon_outfit/proc/select_outfit(mob/user)
	if(!user || !IsAvailable())
		return FALSE
	var/selected = input("Select outfit to change into", "Chameleon Outfit") as null|anything in outfit_options
	if(!IsAvailable() || QDELETED(src) || QDELETED(user))
		return FALSE
	var/outfit_type = outfit_options[selected]
	if(!outfit_type)
		return FALSE
	var/datum/outfit/O = new outfit_type()
	var/list/outfit_types = O.get_chameleon_disguise_info()

	for(var/V in user.chameleon_item_actions)
		var/datum/action/item_action/chameleon/change/A = V
		var/done = FALSE
		for(var/T in outfit_types)
			for(var/name in A.chameleon_list)
				if(A.chameleon_list[name] == T)
					A.update_look(user, T)
					outfit_types -= T
					done = TRUE
					break
			if(done)
				break
	//hardsuit helmets/suit hoods
	if(O.toggle_helmet && (ispath(O.suit, /obj/item/clothing/suit/space/hardsuit) || ispath(O.suit, /obj/item/clothing/suit/hooded)) && ishuman(user))
		var/mob/living/carbon/human/H = user
		//make sure they are actually wearing the suit, not just holding it, and that they have a chameleon hat
		if(istype(H.wear_suit, /obj/item/clothing/suit/chameleon) && istype(H.head, /obj/item/clothing/head/chameleon))
			var/helmet_type
			if(ispath(O.suit, /obj/item/clothing/suit/space/hardsuit))
				var/obj/item/clothing/suit/space/hardsuit/hardsuit = O.suit
				helmet_type = initial(hardsuit.helmettype)
			else
				var/obj/item/clothing/suit/hooded/hooded = O.suit
				helmet_type = initial(hooded.hoodtype)

			if(helmet_type)
				var/obj/item/clothing/head/chameleon/hat = H.head
				hat.chameleon_action.update_look(user, helmet_type)
	qdel(O)
	return TRUE


/datum/action/item_action/chameleon/change
	name = "Chameleon Change"
	var/list/chameleon_blacklist = list() //This is a typecache
	var/list/chameleon_list = list()
	var/chameleon_type = null
	var/chameleon_name = "Item"
	var/emp_timer
	var/current_disguise = null

/datum/action/item_action/chameleon/change/Grant(mob/M)
	if(M && (owner != M))
		if(!M.chameleon_item_actions)
			M.chameleon_item_actions = list(src)
			var/datum/action/chameleon_outfit/O = new /datum/action/chameleon_outfit()
			O.Grant(M)
		else
			M.chameleon_item_actions |= src
	..()

/datum/action/item_action/chameleon/change/Remove(mob/M)
	if(M && (M == owner))
		LAZYREMOVE(M.chameleon_item_actions, src)
		if(!LAZYLEN(M.chameleon_item_actions))
			var/datum/action/chameleon_outfit/O = locate(/datum/action/chameleon_outfit) in M.actions
			qdel(O)
	..()

/datum/action/item_action/chameleon/change/proc/initialize_disguises()
	if(button)
		button.name = "Change [chameleon_name] Appearance"

	chameleon_blacklist |= typecacheof(target.type)
	for(var/V in typesof(chameleon_type))
		if(ispath(V) && ispath(V, /obj/item))
			var/obj/item/I = V
			if(chameleon_blacklist[V] || (initial(I.item_flags) & ABSTRACT) || !initial(I.icon_state))
				continue
			var/chameleon_item_name = "[initial(I.name)] ([initial(I.icon_state)])"
			chameleon_list[chameleon_item_name] = I


/datum/action/item_action/chameleon/change/proc/select_look(mob/user)
	var/obj/item/picked_item
	var/picked_name
	picked_name = input("Select [chameleon_name] to change into", "Chameleon [chameleon_name]", picked_name) as null|anything in chameleon_list
	if(!picked_name)
		return
	picked_item = chameleon_list[picked_name]
	if(!picked_item)
		return
	update_look(user, picked_item)

/datum/action/item_action/chameleon/change/proc/random_look(mob/user)
	var/picked_name = pick(chameleon_list)
	// If a user is provided, then this item is in use, and we
	// need to update our icons and stuff

	if(user)
		update_look(user, chameleon_list[picked_name])

	// Otherwise, it's likely a random initialisation, so we
	// don't have to worry

	else
		update_item(chameleon_list[picked_name])

/datum/action/item_action/chameleon/change/proc/update_look(mob/user, obj/item/picked_item)
	if(isliving(user))
		var/mob/living/C = user
		if(C.stat != CONSCIOUS)
			return

		update_item(picked_item)
		var/obj/item/thing = target
		thing.update_slot_icon()
	UpdateButtonIcon()

/datum/action/item_action/chameleon/change/proc/update_item(obj/item/picked_item, obj/item/target = src.target) //yogs -- add support for cham hardsuits
	target.name = initial(picked_item.name)
	target.desc = initial(picked_item.desc)
	target.icon_state = initial(picked_item.icon_state)
	if(isitem(target))
		var/obj/item/I = target
		I.item_state = initial(picked_item.item_state)
		I.mob_overlay_icon = initial(picked_item.mob_overlay_icon)
		if(istype(I, /obj/item/clothing) && istype(picked_item, /obj/item/clothing))
			var/obj/item/clothing/CL = I
			var/obj/item/clothing/PCL = picked_item
			CL.flags_cover = initial(PCL.flags_cover)
			CL.flags_inv = initial(PCL.flags_inv)
			if(istype(CL, /obj/item/clothing/mask/chameleon))
				var/obj/item/clothing/mask/chameleon/CH = CL
				if(CH.vchange)
					CH.flags_inv |= HIDEFACE // We want the chameleon mask hiding the face to retain voice changing!
	if(istype(target, /obj/item/clothing/suit/space/hardsuit/infiltration)) //YOGS START
		var/obj/item/clothing/suit/space/hardsuit/infiltration/I = target
		var/obj/item/clothing/suit/space/hardsuit/HS = picked_item
		var/obj/item/clothing/head/helmet/helmet = initial(HS.helmettype)
		I.head_piece.initial_state = initial(helmet.icon_state)
		update_item(helmet, I.head_piece)
		I.head_piece.update_icon()
		qdel(helmet)
		//YOGS END
	target.icon = initial(picked_item.icon)
	target.on_chameleon_change()
	current_disguise = picked_item

/datum/action/item_action/chameleon/change/Trigger()
	if(!IsAvailable())
		return

	select_look(owner)
	return 1

/datum/action/item_action/chameleon/change/proc/emp_randomise(var/amount = EMP_RANDOMISE_TIME)
	START_PROCESSING(SSprocessing, src)
	random_look(owner)

	var/new_value = world.time + amount
	if(new_value > emp_timer)
		emp_timer = new_value

/datum/action/item_action/chameleon/change/process()
	if(world.time > emp_timer)
		STOP_PROCESSING(SSprocessing, src)
		return
	random_look(owner)

/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	desc = "It's a plain jumpsuit. It has a small dial on the wrist."
	sensor_mode = SENSOR_OFF //Hey who's this guy on the Syndicate Shuttle??
	random_sensor = FALSE
	resistance_flags = NONE
	can_adjust = FALSE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/under/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/under/chameleon/ratvar
	name = "ratvarian engineer's jumpsuit"
	desc = "A tough jumpsuit woven from alloy threads. It can take on the appearance of other jumpsuits."
	icon_state = "engine"
	item_state = "engi_suit"

/obj/item/clothing/under/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/under
	chameleon_action.chameleon_name = "Jumpsuit"
	chameleon_action.chameleon_blacklist = typecacheof(list(/obj/item/clothing/under, /obj/item/clothing/under/color, /obj/item/clothing/under/rank, /obj/item/clothing/under/changeling), only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/under/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/under/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)
	
/obj/item/clothing/under/plasmaman/chameleon
	name = "envirosuit"
	icon_state = "plasmaman"
	item_state = "plasmaman"
	desc = "The latest generation of Nanotrasen-designed plasmamen envirosuits. This new version has an extinguisher built into the uniform's workings. While airtight, the suit is not EVA-rated."
	sensor_mode = SENSOR_OFF
	random_sensor = FALSE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 95, ACID = 95)
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/under/plasmaman/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/under/plasmaman/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/under
	chameleon_action.chameleon_name = "Jumpsuit"
	chameleon_action.chameleon_blacklist = typecacheof(list(/obj/item/clothing/under, /obj/item/clothing/under/color, /obj/item/clothing/under/rank, /obj/item/clothing/under/changeling), only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/under/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/suit/chameleon
	name = "armor"
	desc = "A slim armored vest that protects against most types of damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/suit/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/suit/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/suit
	chameleon_action.chameleon_name = "Suit"
	chameleon_action.chameleon_blacklist = typecacheof(list(/obj/item/clothing/suit/armor/abductor, /obj/item/clothing/suit/changeling), only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/suit/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/suit/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting condition."
	icon_state = "meson"
	item_state = "meson"
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/glasses/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/glasses/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/glasses
	chameleon_action.chameleon_name = "Glasses"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/glasses/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/glasses/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/glasses/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/clothing/gloves/chameleon
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"

	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/gloves/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/gloves/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/gloves
	chameleon_action.chameleon_name = "Gloves"
	chameleon_action.chameleon_blacklist = typecacheof(list(/obj/item/clothing/gloves, /obj/item/clothing/gloves/color, /obj/item/clothing/gloves/changeling), only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/gloves/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/gloves/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/clothing/head/chameleon
	name = "grey cap"
	desc = "It's a baseball hat in a tasteful grey colour."
	icon_state = "greysoft"

	resistance_flags = NONE
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/head/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/head/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/head
	chameleon_action.chameleon_name = "Hat"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/head/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/head/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/head/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)
	
/obj/item/clothing/head/helmet/space/plasmaman/chameleon
	name = "purple envirosuit helmet"
	desc = "A generic purple envirohelm of Nanotrasen design. This updated model comes with a built-in lamp."
	icon_state = "purple_envirohelm"
	item_state = "purple_envirohelm"
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 100, ACID = 75)
	actions_types = list()
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/head/helmet/space/plasmaman/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/head/helmet/space/plasmaman/chameleon/Initialize()
	. = ..()
	chameleon_action = new /datum/action/item_action/chameleon/change
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/head/helmet/space
	chameleon_action.chameleon_name = "Hat"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/head/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/head/helmet/space/plasmaman/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/head/chameleon/drone
	// The camohat, I mean, holographic hat projection, is part of the
	// drone itself.
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	// which means it offers no protection, it's just air and light

/obj/item/clothing/head/chameleon/drone/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	chameleon_action.random_look()
	var/datum/action/item_action/chameleon/drone/togglehatmask/togglehatmask_action = new(src)
	togglehatmask_action.UpdateButtonIcon()
	var/datum/action/item_action/chameleon/drone/randomise/randomise_action = new(src)
	randomise_action.UpdateButtonIcon()

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow." //More accurate
	icon_state = "gas_alt"
	item_state = "gas_alt"
	resistance_flags = NONE
	armor = list(MELEE = 5, BULLET = 5, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH

	var/vchange = 1

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/mask/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/mask/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/mask
	chameleon_action.chameleon_name = "Mask"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/mask/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/mask/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/mask/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/clothing/mask/chameleon/attack_self(mob/user)
	vchange = !vchange
	to_chat(user, span_notice("The voice changer is now [vchange ? "on" : "off"]!"))
	if(vchange)
		flags_inv |= HIDEFACE
	else if(chameleon_action.current_disguise && isitem(chameleon_action.current_disguise))
		var/obj/item/I = chameleon_action.current_disguise
		flags_inv = initial(I.flags_inv)

/obj/item/clothing/mask/chameleon/drone
	//Same as the drone chameleon hat, undroppable and no protection
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	// Can drones use the voice changer part? Let's not find out.
	vchange = 0

/obj/item/clothing/mask/chameleon/drone/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	chameleon_action.random_look()
	var/datum/action/item_action/chameleon/drone/togglehatmask/togglehatmask_action = new(src)
	togglehatmask_action.UpdateButtonIcon()
	var/datum/action/item_action/chameleon/drone/randomise/randomise_action = new(src)
	randomise_action.UpdateButtonIcon()

/obj/item/clothing/mask/chameleon/drone/attack_self(mob/user)
	to_chat(user, span_notice("[src] does not have a voice changer."))

/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."
	permeability_coefficient = 0.05
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes

	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/shoes/chameleon/syndicate
	syndicate = TRUE

/obj/item/clothing/shoes/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/clothing/shoes
	chameleon_action.chameleon_name = "Shoes"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/shoes/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/clothing/shoes/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/clothing/shoes/chameleon/noslip
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."
	clothing_flags = NOSLIP
	can_be_bloody = FALSE

/obj/item/clothing/shoes/chameleon/noslip/syndicate
	syndicate = TRUE

/obj/item/clothing/shoes/chameleon/noslip/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/storage/backpack/chameleon
	name = "backpack"
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/storage/backpack/chameleon/syndicate
	syndicate = TRUE

/obj/item/storage/backpack/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/storage/backpack
	chameleon_action.chameleon_name = "Backpack"
	chameleon_action.initialize_disguises()

/obj/item/storage/backpack/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/storage/backpack/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/storage/belt/chameleon
	name = "toolbelt"
	desc = "Holds tools."
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/storage/belt/chameleon/syndicate
	syndicate = TRUE

/obj/item/storage/belt/chameleon/Initialize()
	. = ..()

	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/storage/belt
	chameleon_action.chameleon_name = "Belt"
	chameleon_action.initialize_disguises()

/obj/item/storage/belt/chameleon/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/belt/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/storage/belt/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/radio/headset/chameleon
	name = "radio headset"
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/radio/headset/chameleon/syndicate
	syndicate = TRUE

/obj/item/radio/headset/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/radio/headset
	chameleon_action.chameleon_name = "Headset"
	chameleon_action.initialize_disguises()

/obj/item/radio/headset/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/radio/headset/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/pda/chameleon
	name = "PDA"
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/pda/chameleon/syndicate
	syndicate = TRUE

/obj/item/pda/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/pda
	chameleon_action.chameleon_name = "PDA"
	chameleon_action.chameleon_blacklist = typecacheof(list(/obj/item/pda/heads, /obj/item/pda/ai, /obj/item/pda/ai/pai), only_root_path = TRUE)
	chameleon_action.initialize_disguises()

/obj/item/pda/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/pda/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/pda/chameleon/on_chameleon_change()
	. = ..()
	update_label()

/obj/item/stamp/chameleon
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/stamp/chameleon/syndicate
	syndicate = TRUE

/obj/item/stamp/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	if(syndicate)
		chameleon_action.syndicate = TRUE
	chameleon_action.chameleon_type = /obj/item/stamp
	chameleon_action.chameleon_name = "Stamp"
	chameleon_action.initialize_disguises()

/obj/item/stamp/chameleon/broken/Initialize()
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/proc/on_chameleon_change()
	return
