//WT-550 Autocarbine

/obj/item/ammo_box/magazine/wt550m9
	name = "\improper WT-550 magazine (4.6x30mm)"
	desc = "A 20-round 4.6x30mm magazine, designed for the WT-550 Carbine."
	icon_state = "46x30mmt-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = "4.6x30mm"
	max_ammo = 20

/obj/item/ammo_box/magazine/wt550m9/update_icon()
	..()
	switch(ammo_count())
		if(17 to 21) //Considers the extra bullet in the chamber
			icon_state = "46x30mmt[sprite_designation]-20"
		if(13 to 16)
			icon_state = "46x30mmt[sprite_designation]-16"
		if(9 to 12)
			icon_state = "46x30mmt[sprite_designation]-12"
		if(5 to 8)
			icon_state = "46x30mmt[sprite_designation]-8"
		if(1 to 4)
			icon_state = "46x30mmt[sprite_designation]-4"
		else
			icon_state = "46x30mmt[sprite_designation]-0"

/obj/item/ammo_box/magazine/wt550m9/wtap
	name = "\improper WT-550 magazine (Armor-Piercing 4.6x30mm)"
	desc = "A 20-round AP 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds trade damage for armor-piercing capability."
	icon_state = "46x30mmtA-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap
	sprite_designation = "A"

/obj/item/ammo_box/magazine/wt550m9/wtic
	name = "\improper WT-550 magazine (Incendiary 4.6x30mm)"
	desc = "A 20-round Incendiary 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds trade damage for ignition of targets."
	icon_state = "46x30mmtI-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/inc
	sprite_designation = "I"

/obj/item/ammo_box/magazine/wt550m9/wtr
	name = "\improper WT-550 magazine (Rubber Rounds 4.6x30mm)"
	desc = "A 20-round 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds possess minimal lethality but deal high stamina damage to targets."
	icon_state = "46x30mmtR-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/rubber
	sprite_designation = "R"

//Experimental WT mags

/obj/item/ammo_box/magazine/wt550m9/wt_snakebite
	name = "\improper WT-550 magazine (snakebite Rounds 4.6x30mm)"
	desc = "A 20-round 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds, while not directly lethal, inject a fast acting toxin that deals damage instead."
	icon_state = "46x30mmtV-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/snakebite
	sprite_designation = "V"

/obj/item/ammo_box/magazine/wt550m9/wt_kraken
	name = "\improper WT-550 magazine (Kraken Rounds 4.6x30mm)"
	desc = "A 10-round 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds trade any AP capabilites for increased damage to un-armored opponents."
	icon_state = "46x30mmtK-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/kraken
	sprite_designation = "K"

/obj/item/ammo_box/magazine/wt550m9/wt_airburst
	name = "\improper WT-550 magazine (Airburst Rounds 4.6x30mm)"
	desc = "A 10-round 4.6x30mm magazine, designed for the WT-550 Carbine. \
			These rounds travel a few feet, then pop and split into many smaller projectiles. The initial bullet is nigh useless however."
	icon_state = "46x30mmtB-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/airburst
	sprite_designation = "B"
	max_ammo = 10

/obj/item/ammo_box/magazine/wt550m9/wt_airburst/update_icon() // Snowflake code snowflake code
	..()
	switch(ammo_count())
		if(9 to 11) //Considers the extra bullet in the chamber
			icon_state = "46x30mmtB-20"
		if(7 to 8)
			icon_state = "46x30mmtB-16"
		if(5 to 6)
			icon_state = "46x30mmtB-12"
		if(3 to 4)
			icon_state = "46x30mmtB-8"
		if(1 to 2)
			icon_state = "46x30mmtB-4"
		else
			icon_state = "46x30mmtB-0"

//Type T3 Uzi

/obj/item/ammo_box/magazine/uzim9mm
	name = "uzi magazine (9mm)"
	desc = "A 32-round magazine for the Type T3 Uzi that contains 9mm rounds."
	icon_state = "uzi9mm-32"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 32

/obj/item/ammo_box/magazine/uzim9mm/update_icon()
	..()
	icon_state = "uzi9mm-[round(ammo_count(),4)]"

//NT Saber SMG

/obj/item/ammo_box/magazine/smgm9mm
	name = "SMG magazine (9mm)"
	desc = "A 21-round magazine for the Nanotrasen Saber SMG that contains 9mm rounds."
	icon_state = "smg9mm-42"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 21

/obj/item/ammo_box/magazine/smgm9mm/update_icon()
	..()
	icon_state = "smg9mm[sprite_designation]-[ammo_count() ? "42" : "0"]"

/obj/item/ammo_box/magazine/smgm9mm/ap
	name = "SMG magazine (Armor-Piercing 9mm)"
	desc = "A 21-round magazine for the Nanotrasen Saber SMG that contains AP 9mm rounds. \
			These rounds inflict less harm but penetrate most standard protection."
	icon_state = "smg9mmA-42"
	ammo_type = /obj/item/ammo_casing/c9mm/ap
	sprite_designation = "A"

/obj/item/ammo_box/magazine/smgm9mm/inc
	name = "SMG Magazine (Incendiary 9mm)"
	desc = "A 21-round magazine for the Nanotrasen Saber SMG that contains incendiary 9mm rounds. \
			These rounds do less damage but ignite targets."
	icon_state = "smg9mmI-42"
	ammo_type = /obj/item/ammo_casing/c9mm/inc
	sprite_designation = "I"

//C-20r SMG

/obj/item/ammo_box/magazine/smgm45
	name = "SMG magazine (.45)"
	desc = "A 24-round magazine for the C-20r SMG that contains .45 rounds."
	icon_state = "c20r45-24"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 24

/obj/item/ammo_box/magazine/smgm45/update_icon()
	..()
	icon_state = "c20r45[sprite_designation]-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/smgm45/ap
	name = "SMG magazine (Armor-Piercing .45)"
	desc = "A 24-round magazine for the C-20r SMG that contains AP .45 rounds. \
			These rounds do less damage but bypass most standard body armor."
	icon_state = "c20r45A-24"
	ammo_type = /obj/item/ammo_casing/c45/ap
	sprite_designation = "A"

/obj/item/ammo_box/magazine/smgm45/hp
	name = "SMG magazine (Hollow-Point .45)"
	desc = "A 24-round magazine for the C-20r SMG that contains HP .45 rounds. \
			These rounds suffer against those wearing body armor but devastate those who do not."
	icon_state = "c20r45H-24"
	ammo_type = /obj/item/ammo_casing/c45/hp
	sprite_designation = "H"

/obj/item/ammo_box/magazine/smgm45/venom
	name = "SMG magazine (Venom .45)"
	desc = "A 24-round magazine for the C-20r SMG that contains Venom .45 rounds. \
			These rounds do less damage but poison targets."
	icon_state = "c20r45V-24"
	ammo_type = /obj/item/ammo_casing/c45/venom
	sprite_designation = "V"

//Thompson SMG

/obj/item/ammo_box/magazine/tommygunm45
	name = "drum magazine (.45)"
	desc = "A massive 50-round drum magazine for usage in the Thompson SMG. It contains .45 rounds."
	icon_state = "drum45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 50
