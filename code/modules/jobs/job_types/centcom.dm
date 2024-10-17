/datum/outfit/centcom
	implants = list(/obj/item/implant/mindshield)
	box = /obj/item/storage/box/survival

/datum/outfit/centcom/official //Generic centcom person. Whatever rank you want that is Lieutenant or lower.
	name = "CentCom Official"
	var/pdaequip = TRUE

	uniform = /obj/item/clothing/under/rank/centcom/officer
	suit = null
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/beret/sec/centcom
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/pen
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/modular_computer/tablet/pda/preset/bureaucrat
	l_hand = /obj/item/clipboard
	id = /obj/item/card/id/centcom
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1, /obj/item/stamp/cent = 1,)


	chameleon_extras = /obj/item/stamp/cent

/datum/outfit/centcom/official/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.icon = 'icons/obj/card.dmi' //Bypasses modularisation.
	W.icon_state = "centcom"
	W.access = get_centcom_access("CentCom Official")
	W.access += ACCESS_WEAPONS_PERMIT
	W.assignment = "CentCom Official"
	W.originalassignment = "CentCom Official"
	W.registered_name = H.real_name
	W.update_label()

	if(pdaequip)
		var/obj/item/modular_computer/tablet/phone/preset/advanced/command/command_phone = H.r_store
		command_phone.update_label(W)

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/official/nopda
	pdaequip = FALSE
/datum/outfit/centcom/captain //CentCom Captain. Essentially a station captain.
	name = "CentCom Captain"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/centcom
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/centhat
	belt = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/silver
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/silver/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_silver" //Not gold because he doesn't command a station.
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Official")
	W.assignment = "CentCom Captain"
	W.originalassignment = "CentCom Captain"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/major //CentCom Major.
	name = "CentCom Major"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/centcom
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/centhat
	neck = /obj/item/clothing/neck/pauldron
	belt = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/silver
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/major/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/silver/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_silver" //Neither does this guy
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Official")
	W.assignment = "CentCom Major"
	W.originalassignment = "CentCom Major"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/commander //CentCom Commander.
	name = "CentCom Commodore"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/centcom
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/cohiba
	head = /obj/item/clothing/head/centhat
	neck = /obj/item/clothing/neck/pauldron/commander
	belt = /obj/item/gun/ballistic/revolver/mateba //The time for negotiations have come to an end.
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/ammo_box/m44
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/gold
	backpack_contents = list(/obj/item/ammo_box/m44 =2, /obj/item/restraints/handcuffs/cable/zipties=1, /obj/item/melee/classic_baton/telescopic=1)

/datum/outfit/centcom/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/gold/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_gold" //Important enough to have one.
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Commodore"
	W.originalassignment = "CentCom Commodore"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/colonel //CentCom Commander.
	name = "CentCom Colonel"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/centcom
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/centhat
	neck = /obj/item/clothing/neck/pauldron/colonel
	belt = /obj/item/gun/ballistic/revolver/mateba
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/ammo_box/m44
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/gold
	backpack_contents = list(/obj/item/ammo_box/m44 =2, /obj/item/restraints/handcuffs/cable/zipties=1, /obj/item/melee/classic_baton/telescopic=1)

/datum/outfit/centcom/colonel/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/gold/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_gold"
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Colonel"
	W.originalassignment = "CentCom Colonel"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/rear_admiral //CentCom Rear-Admiral. Low-tier admiral.
	name = "CentCom Rear-Admiral"

	uniform = /obj/item/clothing/under/rank/centcom/admiral
	suit = null
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/centhat/admiral
	neck = null
	belt = /obj/item/gun/energy/e_gun //The time for negotiations have been reconsidered.
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/gold
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/rear_admiral/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/gold/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_gold"
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Rear-Admiral"
	W.originalassignment = "CentCom Rear-Admiral"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/admiral //CentCom Admiral.
	name = "CentCom Admiral"

	uniform = /obj/item/clothing/under/rank/centcom/admiral
	suit = null
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/centhat/admiral
	neck = /obj/item/clothing/neck/cape
	belt = /obj/item/gun/energy/pulse/pistol //THE TIME FOR NEGOTIATIONS HAVE COME TO AND END.
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/transforming/energy/sword/saber/green
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/gold
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/admiral/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/gold/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_gold"
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Admiral"
	W.originalassignment = "CentCom Admiral"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/centcom/executive_admiral //CentCom Executive Admiral. The final boss.
	name = "CentCom Executive Admiral"

	uniform = /obj/item/clothing/under/rank/centcom/admiral/executive
	suit = null
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/color/captain/centcom/admiral
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	head = /obj/item/clothing/head/centhat/admiral/executive
	neck = /obj/item/clothing/neck/cape/executive
	belt = /obj/item/gun/energy/pulse/pistol
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/transforming/energy/sword/saber/green
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/gold
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/centcom/executive_admiral/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/gold/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_gold"
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Executive Admiral"
	W.originalassignment = "CentCom Executive Admiral"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake
