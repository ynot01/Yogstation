/datum/outfit/vr
	name = "Basic VR"
	uniform = /obj/item/clothing/under/rank/cargo/tech
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id/no_bank

/datum/outfit/vr/pre_equip(mob/living/carbon/human/H)
	H.dna.species.before_equip_job(null, H)

/datum/outfit/vr/post_equip(mob/living/carbon/human/H)
	var/obj/item/card/id/id = H.wear_id
	if (istype(id))
		id.access |= get_all_accesses()
	if(isplasmaman(H)) //sorry plasma people
		H.set_species(/datum/species/human)

/datum/outfit/vr/syndicate
	name = "Syndicate VR Operative - Basic"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/syndicate
	belt = /obj/item/gun/ballistic/automatic/pistol
	l_pocket = /obj/item/paper/fluff/vr/fluke_ops
	box = /obj/item/storage/box/survival/syndie
	backpack_contents = list(/obj/item/kitchen/knife/combat/survival)

/datum/outfit/vr/syndicate/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/uplink/U = new /obj/item/uplink/nuclear_restricted(H, H.key, 80)
	H.equip_to_slot_or_del(U, ITEM_SLOT_BACKPACK)
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(H)
	W.implant(H)
	var/obj/item/implant/explosive/E = new/obj/item/implant/explosive(H)
	E.implant(H)
	H.faction |= ROLE_ANTAG
	H.update_icons()

/obj/item/paper/fluff/vr/fluke_ops
	name = "Where is my uplink?"
	info = "Use the radio in your backpack."
