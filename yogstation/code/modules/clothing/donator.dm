/obj/item/clothing/head/yogs/beanie
	name = "beanie"
	desc = "A nice comfy beanie hat."
	icon_state = "beanie"
	item_state = "beanie"

/obj/item/clothing/head/yogs/bike
	name = "bike helmet"
	desc = "A bike helmet. Although it looks cool, it is made from recycled materials and is extremely flimsy. You can plainly see the face of the wearer through the darkened visor."
	icon_state = "bike"
	item_state = "bike"

/obj/item/clothing/head/yogs/hardsuit_helm_clown
	name = "clown hardsuit helm"
	desc = "An incredibly flimsy helm made to look like a hardsuit helm. You can plainly see the face of the wearer through the visor."
	icon_state = "hardsuit_helm_clown"
	item_state = "hardsuit_helm_clown"

/obj/item/clothing/head/yogs/cowboy
	name = "cowboy hat"
	desc = "A cowboy hat. YEEEHAWWWWW."
	icon_state = "cowboy_hat"
	item_state = "cowboy_hat"

/obj/item/clothing/head/yogs/crusader
	name = "crusader helmet"
	desc = "A thin metal crusader helmet. It looks like it wouldn't take much of a beating."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/head/yogs/cowboy_sheriff
	name = "sheriff cowboy hat"
	desc = "A sheriffs hat. YEEEHAWWWWW!"
	icon_state = "cowboy_sheriff"
	item_state = "cowboy_sheriff"

/obj/item/clothing/head/yogs/dallas
	name = "dallas hat"
	desc = "A patriotic hat."
	icon_state = "dallas"
	item_state = "dallas"

/obj/item/clothing/head/yogs/drinking_hat
	name = "drinking hat"
	desc = "An utilitarian drinking hat."
	icon_state = "drinking_hat"
	item_state = "drinking_hat"

/obj/item/clothing/head/yogs/microwave
	name = "microwave hat"
	desc = "A microwave hat. Luckily the harmful components were removed. Safety first!"
	icon_state = "microwave"
	item_state = "microwave"

/obj/item/clothing/head/yogs/sith_hood
	name = "sith hood"
	desc = "A sith hood."
	icon_state = "sith_hood"
	item_state = "sith_hood"

/obj/item/clothing/head/yogs/turban
	name = "turban"
	desc = "A turban."
	icon_state = "turban"
	item_state = "turban"

/obj/item/clothing/neck/yogs/sith_cloak
	name = "sith cloak"
	desc = "A sith cloak."
	icon_state = "sith_cloak"
	item_state = "sith_cloak"

/obj/item/clothing/suit/yogs/armor/sith_suit
	name = "sith suit"
	desc = "A sith suit."
	icon_state = "sith_suit"
	item_state = "sith_suit"

/obj/item/clothing/suit/yogs/armor/hardsuit_clown
	name = "clown hardsuit"
	desc = "A clown hardsuit. The joke being that it is anything but."
	icon_state = "hardsuit_clown"
	item_state = "hardsuit_clown"

/obj/item/clothing/suit/yogs/megumu
	name = "Megumu's dress"
	desc = "Tofu!"
	mob_overlay_icon = 'yogstation/icons/mob/clothing/suit/suit.dmi'
	icon = 'yogstation/icons/obj/clothing/suits.dmi'
	icon_state = "megumu_dress"
	item_state = "megumu_dress"
/obj/item/clothing/suit/yogs/adventurerskirt
	name = "adventurer skirt"
	desc = "Retrofitted skirt designed by a well known felind brand Tailor"
	icon_state = "adventurer_skirt"
	item_state = "adventurer_skirt"
	body_parts_covered = CHEST|GROIN|ARMS|HANDS
/obj/item/clothing/gloves/yogs/arm_sleeves
	name = "Arm Sleeves"
	desc = "White marked sleeves, signal of a skillful Hunter."
	icon_state = "arm_sleeves"
	item_state = "arm_sleeves"
/obj/item/clothing/under/yogs/skin_tight_garmet
	name = "Skin Tight Garmet"
	desc = "With this on you can barely breath."
	icon_state = "skin_tight_garmet"
	item_state = "skin_tight_garmet"
/obj/item/clothing/neck/yogs/megumu
	name = "Megumu's Cape"
	desc = "Tofu!"
	mob_overlay_icon = 'yogstation/icons/mob/clothing/neck/neck.dmi'
	icon = 'yogstation/icons/obj/clothing/neck.dmi'
	icon_state = "megumu_cape"
	item_state = "megumu_cape"

/obj/item/clothing/head/soft/fishfear
	name = "novelty fishing cap"
	desc = "It's an extra-tall snap-back hat with a picture of a fish, and text that reads: \"Women fear me. Fish fear me. Men turn their eyes away from me as I walk. No beast dares make a sound in my presence. I am alone on this barren Earth.\""
	mob_overlay_icon = 'icons/mob/clothing/head/fishfear.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 64
	icon_state = "fishfearsoft"
	soft_type = "fishfear"
	dog_fashion = /datum/dog_fashion/head/fishfear

/obj/item/clothing/head/soft/fishfear/Initialize()
	. = ..()
	AddComponent(/datum/component/fishingbonus,5)

/obj/item/clothing/head/yogs/froghat
	name = "frog hat"
	desc = "A strange hat that looks somewhat like a frog?"
	icon_state = "froghat"
	item_state = "froghat"

/obj/item/clothing/head/yogs/froghat/Initialize()
	. = ..()
	AddComponent(/datum/component/fishingbonus,10)

/obj/item/storage/box/megumu
	name = "Megumu's box"
	desc = "Contains Tofu"

/obj/item/storage/box/megumu/PopulateContents()
	. = ..()
	new /obj/item/clothing/suit/yogs/megumu(src)
	new /obj/item/clothing/neck/yogs/megumu(src)
	new /obj/item/clothing/head/yogs/froghat(src)

/obj/item/storage/box/isotope
	name = "radioactive box"
	desc = "WARNING: not actually radioactive."

/obj/item/storage/box/isotope/PopulateContents() 
	. = ..()
	new /obj/item/clothing/under/rank/scientist/black(src)
	new /obj/item/lighter/badass(src)

/obj/item/storage/box/hisa
	name = "Hunters Stash"
	desc = "Legend has it if this box is not held by a hunter, its held by prey" 

/obj/item/storage/box/hisa/PopulateContents()
	. = ..()
	new /obj/item/clothing/suit/yogs/adventurerskirt(src)
	new /obj/item/clothing/under/yogs/skin_tight_garmet(src)
	new /obj/item/clothing/gloves/yogs/arm_sleeves(src)

/obj/item/storage/box/manatee
	name = "Discharge package"
	desc = "Thank you for your service. Please dont come back."

/obj/item/storage/box/manatee/PopulateContents() 
	. = ..()
	new /obj/item/clothing/accessory/dogtags(src)
	new /obj/item/clothing/head/peacekeeperberet(src)

/obj/item/toy/plush/axolotlplushie
	name = "axolotl plushie"
	desc = "An adorable stuffed toy that resembles an axolotl. Not to be mistaken for the real thing."
	icon_state = "plushie_axolotl"
	lefthand_file = 'icons/mob/pets_held_lh.dmi'
	righthand_file = 'icons/mob/pets_held_rh.dmi'
	item_state = "axolotl"
	attack_verb = list("nibbles", "splats")
	squeak_override = list('sound/effects/axolotl.ogg' = 1)

/obj/item/storage/box/boxta
	name = "Inmate belongings box"
	desc = "A criminals' belongings, returned upon their release. Just stop killing people."

/obj/item/storage/box/boxta/PopulateContents() 
	. = ..()
	new /obj/item/clothing/neck/falcon(src)
	new /obj/item/clothing/head/fedora/gtrim_fedora(src)

/obj/item/bedsheet/pride
	name = "Pride Bedsheet"
	desc = "A very prideful queen size bedsheet. How you are carrying all that weight is beyond me though."
	mob_overlay_icon = 'icons/mob/clothing/neck/sheets.dmi'
	icon_state = "sheetpride"
	item_state = "sheetpride"
