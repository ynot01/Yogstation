GLOBAL_LIST_EMPTY(uplinks)

#define PEN_ROTATIONS 2
#define NT_ERT_TROOPER 1
#define NT_ERT_MEDIC 2
#define NT_ERT_ENGINEER 3

#define UPLINK_CATEGORY_DISCOUNTS "Discounts"
#define UPLINK_CATEGORY_BUNDLES "Bundles"
#define UPLINK_CATEGORY_CONSPICUOUS "Conspicuous Weapons"
#define UPLINK_CATEGORY_STEALTH_WEAPONS "Stealthy Weapons"
#define UPLINK_CATEGORY_AMMO "Ammunition"
#define UPLINK_CATEGORY_EXPLOSIVES "Explosives"
#define UPLINK_CATEGORY_SUPPORT "Support and Exosuits"
#define UPLINK_CATEGORY_STEALTH_GADGETS "Stealth Gadgets"
#define UPLINK_CATEGORY_SPACE_SUITS "Space Suits"
#define UPLINK_CATEGORY_IMPLANTS "Implants"
#define UPLINK_CATEGORY_INFILTRATION "Infiltration Gear"
#define UPLINK_CATEGORY_SPECIES "Species-Restricted"
#define UPLINK_CATEGORY_ROLE "Role-Restricted"
#define UPLINK_CATEGORY_MISC "Misc. Gadgets"
#define UPLINK_CATEGORY_BADASS "(Pointless) Badassery"
#define UPLINK_CATEGORY_ENERGY "Energy Weapons"
#define UPLINK_CATEGORY_BALLISTIC "Ballistic Weapons"
#define UPLINK_CATEGORY_EXOSUITS "Exosuits"
#define UPLINK_CATEGORY_CQC "Close Quarters Combat"
#define UPLINK_CATEGORY_NT_SUPPORT "Support"
#define UPLINK_CATEGORY_HARDSUITS "Armor & Hardsuits"
#define UPLINK_CATEGORY_OTHER "Other Gear"
/**
 * Uplinks
 *
 * All /obj/item(s) have a hidden_uplink var. By default it's null. Give the item one with 'new(src') (it must be in it's contents). Then add 'uses.'
 * Use whatever conditionals you want to check that the user has an uplink, and then call interact() on their uplink.
 * You might also want the uplink menu to open if active. Check if the uplink is 'active' and then interact() with it.
**/
/datum/component/uplink
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/name = "syndicate uplink"
	var/js_ui = "Uplink"
	var/obj/item/stack/currency = /obj/item/stack/telecrystal
	var/active = FALSE
	var/lockable = TRUE
	var/locked = TRUE
	var/allow_restricted = TRUE
	var/telecrystals
	var/selected_cat
	var/owner = null
	/// What antagonist role this uplink belongs to
	var/antagonist = null
	var/datum/uplink_purchase_log/purchase_log
	var/list/uplink_items
	var/hidden_crystals = 0
	var/unlock_note
	var/unlock_code
	/// Set to true if failsafe_code should blow up the device
	var/has_failsafe = FALSE
	var/failsafe_code
	var/debug = FALSE
	var/compact_mode = FALSE
	///Instructions on how to access the uplink based on location
	var/unlock_text
	var/list/previous_attempts
	var/nt_uplink_type = null //for NT uplinks to enforce team variety.

/datum/component/uplink/Initialize(_owner, _lockable = TRUE, _enabled = FALSE, _antagonist = ROLE_TRAITOR, starting_tc = TELECRYSTALS_DEFAULT)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE


	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(OnAttackBy))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(interact))
	if(istype(parent, /obj/item/implant))
		RegisterSignal(parent, COMSIG_IMPLANT_ACTIVATED, PROC_REF(implant_activation))
		RegisterSignal(parent, COMSIG_IMPLANT_IMPLANTING, PROC_REF(implanting))
		RegisterSignal(parent, COMSIG_IMPLANT_OTHER, PROC_REF(old_implant))
		RegisterSignal(parent, COMSIG_IMPLANT_EXISTING_UPLINK, PROC_REF(new_implant))
	else if(istype(parent, /obj/item/modular_computer))
		RegisterSignal(parent, COMSIG_NTOS_CHANGE_RINGTONE, PROC_REF(ntos_ringtone))
		RegisterSignal(parent, COMSIG_TABLET_CHECK_DETONATE, PROC_REF(check_detonate))
	else if(istype(parent, /obj/item/radio))
		RegisterSignal(parent, COMSIG_RADIO_NEW_FREQUENCY, PROC_REF(new_frequency))
	else if(istype(parent, /obj/item/pen))
		RegisterSignal(parent, COMSIG_PEN_ROTATED, PROC_REF(pen_rotation))

	GLOB.uplinks += src
	uplink_items = get_uplink_items(_antagonist, TRUE, allow_restricted, js_ui)

	if(_owner)
		owner = _owner
		LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
		if(GLOB.uplink_purchase_logs_by_key[owner])
			purchase_log = GLOB.uplink_purchase_logs_by_key[owner]
		else
			purchase_log = new(owner, src)
	lockable = _lockable
	active = _enabled
	antagonist = _antagonist
	telecrystals = starting_tc
	if(!lockable)
		active = TRUE
		locked = FALSE

	previous_attempts = list()

/datum/component/uplink/InheritComponent(datum/component/uplink/U)
	lockable |= U.lockable
	active |= U.active
	if(!antagonist)
		antagonist = U.antagonist
	telecrystals += U.telecrystals
	if(purchase_log && U.purchase_log)
		purchase_log.MergeWithAndDel(U.purchase_log)

/datum/component/uplink/Destroy()
	GLOB.uplinks -= src
	antagonist = null
	purchase_log = null
	return ..()

/datum/component/uplink/proc/LoadTC(mob/user, obj/item/stack/TC, silent = FALSE)
	if(!silent)
		to_chat(user, span_notice("You slot [TC] into [parent] and charge its internal uplink."))
	var/amt = TC.amount
	telecrystals += amt
	TC.use(amt)

/datum/component/uplink/proc/set_antagonist(_antagonist)
	antagonist = _antagonist
	uplink_items = get_uplink_items(antagonist, TRUE, allow_restricted, js_ui)

/datum/component/uplink/proc/OnAttackBy(datum/source, obj/item/I, mob/user)
	if(!active)
		return	//no hitting everyone/everything just to try to slot tcs in!
	if(istype(I, currency))
		LoadTC(user, I)
		return
	var/datum/component/refundable/R = I.GetComponent(/datum/component/refundable)
	if (!R || R.buyer != user.mind || !SEND_SIGNAL(I, COMSIG_ITEM_REFUND, user))
		return
	telecrystals += R.tc_cost
	if(purchase_log)
		purchase_log.total_spent -= R.tc_cost
		to_chat(user, span_notice("[I] was refunded for [span_bold("[R.tc_cost] TC")]."))
	qdel(I)

/datum/component/uplink/proc/interact(datum/source, mob/user)
	if(locked)
		return
	active = TRUE
	if(user)
		ui_interact(user)
	// an unlocked uplink blocks also opening the PDA or headset menu
	return COMPONENT_NO_INTERACT

/datum/component/uplink/ui_state(mob/user)
	return GLOB.inventory_state

/datum/component/uplink/ui_interact(mob/user, datum/tgui/ui)
	active = TRUE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, js_ui, name)
		// This UI is only ever opened by one person,
		// and never is updated outside of user input.
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/component/uplink/ui_data(mob/user)
	if(!user.mind)
		return
	var/list/data = list()
	data["telecrystals"] = telecrystals
	data["lockable"] = lockable
	data["compactMode"] = compact_mode
	return data

/datum/component/uplink/ui_static_data(mob/user)
	var/list/data = list()
	data["categories"] = list()
	for(var/category in uplink_items)
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(I.limited_stock == 0)
				continue
			if(I.restricted_roles.len)
				var/is_inaccessible = TRUE
				for(var/R in I.restricted_roles)
					if(R == user.mind.assigned_role || debug)
						is_inaccessible = FALSE
				if(is_inaccessible)
					continue
			if(I.restricted_species)
				if(ishuman(user))
					var/is_inaccessible = TRUE
					var/mob/living/carbon/human/H = user
					for(var/F in I.restricted_species)
						if(F == H.dna.species.id || debug)
							is_inaccessible = FALSE
							break
					if(is_inaccessible)
						continue
			if(istype(I, /datum/uplink_item/nt))
				var/datum/uplink_item/nt/M = I
				if(nt_uplink_type != null && M.required_ert_uplink != null && nt_uplink_type != M.required_ert_uplink) //Different roles in ERT uplinks have different equipment avaliable
					continue
			cat["items"] += list(list(
				"name" = I.name,
				"cost" = I.manufacturer && user.mind.is_employee(I.manufacturer) ? CEILING(I.cost * 0.8, 1) : I.cost,
				"desc" = I.desc,
				"path" = replacetext(replacetext("[I.item]", "/obj/item/", ""), "/", "-"),
				"manufacturer" = I.manufacturer ? initial(I.manufacturer.name) : null,
			))
		data["categories"] += list(cat)
	return data

/datum/component/uplink/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!active)
		return
	switch(action)
		if("buy")
			var/item_name = params["name"]
			var/list/buyable_items = list()
			for(var/category in uplink_items)
				buyable_items += uplink_items[category]
			if(item_name in buyable_items)
				var/datum/uplink_item/I = buyable_items[item_name]
				MakePurchase(usr, I)
				return TRUE
		if("lock")
			active = FALSE
			locked = TRUE
			telecrystals += hidden_crystals
			hidden_crystals = 0
			SStgui.close_uis(src)
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

/datum/component/uplink/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/uplink),
	)

/datum/component/uplink/proc/MakePurchase(mob/user, datum/uplink_item/U)
	if(!istype(U))
		return
	if (!user || user.incapacitated())
		return
	if(U.manufacturer && user.mind.is_employee(U.manufacturer))
		if(telecrystals < CEILING(U.cost*0.8, 1) || U.limited_stock == 0)
			return
		telecrystals -= CEILING(U.cost*0.8, 1)
	else 
		if(telecrystals < U.cost || U.limited_stock == 0)
			return
		telecrystals -= U.cost

	U.purchase(user, src)

	if(U.limited_stock > 0)
		U.limited_stock -= 1

	SSblackbox.record_feedback("nested tally", "traitor_uplink_items_bought", 1, list("[initial(U.name)]", "[U.cost]"))
	return TRUE

// Implant signal responses

/datum/component/uplink/proc/implant_activation()
	var/obj/item/implant/implant = parent
	locked = FALSE
	interact(null, implant.imp_in)

/datum/component/uplink/proc/implanting(datum/source, list/arguments)
	var/mob/target = arguments[1]
	var/mob/user = arguments[2] // YOGS START -- Fix runtime when implanting infiltrators
	owner = "[user ? user.key : target.key]" // YOGS END

/datum/component/uplink/proc/old_implant(datum/source, list/arguments, obj/item/implant/new_implant)
	// It kinda has to be weird like this until implants are components
	return SEND_SIGNAL(new_implant, COMSIG_IMPLANT_EXISTING_UPLINK, src)

/datum/component/uplink/proc/new_implant(datum/source, datum/component/uplink/uplink)
	uplink.telecrystals += telecrystals
	return COMPONENT_DELETE_NEW_IMPLANT

// PDA signal responses
/datum/component/uplink/proc/ntos_ringtone(datum/source, mob/living/user, new_ring_text)
	if(trim(lowertext(new_ring_text)) != trim(lowertext(unlock_code)))
		if(trim(lowertext(new_ring_text)) == trim(lowertext(failsafe_code)))
			failsafe()
			return COMPONENT_STOP_RINGTONE_CHANGE
		return
	locked = FALSE
	interact(null, user)
	to_chat(user, "The [parent] softly beeps.")
	return COMPONENT_STOP_RINGTONE_CHANGE

/datum/component/uplink/proc/check_detonate()
	return COMPONENT_TABLET_NO_DETONATE

// Radio signal responses

/datum/component/uplink/proc/new_frequency(datum/source, list/arguments)
	var/obj/item/radio/master = parent
	var/frequency = arguments[1]
	if(frequency != unlock_code)
		if(frequency == failsafe_code)
			failsafe()
		return
	locked = FALSE
	if(ismob(master.loc))
		interact(null, master.loc)

// Pen signal responses

/datum/component/uplink/proc/pen_rotation(datum/source, degrees, mob/living/carbon/user)
	var/obj/item/pen/master = parent
	previous_attempts += degrees
	if(length(previous_attempts) > PEN_ROTATIONS)
		popleft(previous_attempts)

	if(compare_list(previous_attempts, unlock_code))
		locked = FALSE
		previous_attempts.Cut()
		master.degrees = 0
		interact(null, user)
		to_chat(user, span_warning("Your pen makes a clicking noise, before quickly rotating back to 0 degrees!"))

	else if(compare_list(previous_attempts, failsafe_code))
		failsafe()

/datum/component/uplink/proc/setup_unlock_code()
	unlock_code = generate_code()
	var/obj/item/P = parent
	if(istype(parent, /obj/item/modular_computer))
		unlock_note = "<B>Uplink Passcode:</B> [unlock_code] ([P.name])."
	else if(istype(parent,/obj/item/radio))
		unlock_note = "<B>Radio Frequency:</B> [format_frequency(unlock_code)] ([P.name])."
	else if(istype(parent,/obj/item/pen))
		unlock_note = "<B>Uplink Degrees:</B> [english_list(unlock_code)] ([P.name])."

/datum/component/uplink/proc/generate_code()
	if(istype(parent,/obj/item/modular_computer))
		return "[rand(100,999)] [pick(GLOB.phonetic_alphabet)]"
	else if(istype(parent,/obj/item/radio))
		return sanitize_frequency(rand(FREQ_COMMON+1, MAX_FREQ))
	else if(istype(parent,/obj/item/pen))
		var/list/L = list()
		for(var/i in 1 to PEN_ROTATIONS)
			L += rand(1, 360)
		return L

/datum/component/uplink/proc/failsafe()
	if(!parent || !has_failsafe)
		return
	var/turf/T = get_turf(parent)
	if(!T)
		return
	explosion(T,1,2,3)
	qdel(parent) //Alternatively could brick the uplink.


/// NT Uplink
/datum/component/uplink/nanotrasen
	name = "nanotrasen uplink"
	js_ui = "NTUplink"
	currency = /obj/item/stack/ore/bluespace_crystal/refined/nt

/datum/component/uplink/nanotrasen/trooper
	nt_uplink_type = NT_ERT_TROOPER
/datum/component/uplink/nanotrasen/medic
	nt_uplink_type = NT_ERT_MEDIC
/datum/component/uplink/nanotrasen/engineer
	nt_uplink_type = NT_ERT_ENGINEER
