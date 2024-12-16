/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese and bread. Arthur Dent would be proud."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("meat" = 2, "cheese" = 1, "bread" = 2)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/sandwich/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/reagent_containers/food/snacks/toastedsandwich, rand(20 SECONDS, 30 SECONDS), TRUE)

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/carbon = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/carbon = 2)
	tastes = list("meat" = 2, "cheese" = 1, "toast" = 1)
	foodtype = GRAIN | MEAT
	burns_on_grill = TRUE

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "cheese sandwich"
	desc = "Goes great with tomato soup!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("bread" = 1, "cheese" = 1)
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellysandwich"
	bitesize = 3
	tastes = list("bread" = 1, "jelly" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/jellysandwich/slime
	bonus_reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype  = GRAIN | TOXIC

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry
	bonus_reagents = list(/datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/notasandwich
	name = "not-a-sandwich"
	desc = "Something seems to be wrong with this, you can't quite figure what. Maybe it's his moustache."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "notasandwich"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("nothing suspicious" = 1)
	foodtype = GRAIN | GROSS

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of toast covered with delicious jam."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellytoast"
	bitesize = 3
	tastes = list("toast" = 1, "jelly" = 1)
	foodtype = GRAIN | BREAKFAST

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry
	bonus_reagents = list(/datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime
	bonus_reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | TOXIC | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/butteredtoast
	name = "buttered toast"
	desc = "Butter lightly spread over a piece of toast."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butteredtoast"
	bitesize = 3
	filling_color = "#FFA500"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("butter" = 1, "toast" = 1)
	foodtype = GRAIN | DAIRY | BREAKFAST

/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "This seems awfully bitter."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "twobread"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("bread" = 2)
	foodtype = GRAIN | ALCOHOL

/obj/item/reagent_containers/food/snacks/breadslice/toast
	name = "toast"
	desc = "A piece of toast."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toast"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("toast" = 2)
	foodtype = GRAIN | BREAKFAST
	burns_on_grill = TRUE

/obj/item/reagent_containers/food/snacks/pbj_sandwich
	name = "peanut butter and jelly sandwich"
	desc = "A classic PB&J sandwich, just like your mom used to make."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "pbj_sandwich"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("peanut butter" = 1, "jelly" = 1, "bread" = 2)
	foodtype = GRAIN | FRUIT | NUTS

/obj/item/reagent_containers/food/snacks/pbb_sandwich
	name = "peanut butter and banana sandwich"
	desc = "A peanut butter sandwich with banana slices mixed in, a good high protein treat."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "pbb_sandwich"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("peanut butter" = 1, "banana" = 1, "bread" = 2)
	foodtype = GRAIN | FRUIT | NUTS