//rare and valulable gems- designed to eventually be used for archeology, or to be given as opposed to money as loot. Auctioned off at export, or kept as a trophy. -MemedHams

/obj/item/gem
	name = "gem"
	desc = "Oooh! Shiny!"
	icon = 'icons/obj/gems.dmi'
	icon_state = "rupee"
	w_class = WEIGHT_CLASS_SMALL

	///owning ID, used to give points when sold
	var/obj/item/card/id/claimed_by = null
	///How many points we grant to whoever discovers us
	var/point_value = 100
	///what's our real name that will show upon discovery? null to do nothing
	var/true_name
	///the message given when you discover this gem.
	var/analysed_message = null
	///the thing that spawns in the item.
	var/sheet_type = null

	var/image/shine_overlay //shows this overlay when not claimed

/obj/item/gem/Initialize()
	. = ..()
	shine_overlay = image(icon = 'icons/obj/gems.dmi',icon_state = "shine")
	add_overlay(shine_overlay)
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)

/obj/item/gem/examine(mob/user)
	. = ..()
	. += span_notice("Its value of [point_value] mining points can be registered by hitting it with an ID, to be claimed when sold.")

/obj/item/gem/attackby(obj/item/item, mob/living/user, params) //Stolen directly from geysers, removed the internal gps
	if(!istype(item, /obj/item/card/id))
		return ..()

	if(claimed_by)
		to_chat(user, span_warning("This gem has already been claimed!"))
		return

	to_chat(user, span_notice("You register the precious gemstone to your ID card, and will gain [point_value] mining points when it is sold!"))
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	if(analysed_message)
		to_chat(user, analysed_message)

	claimed_by = item
	if(true_name)
		name = true_name

	if(shine_overlay)
		cut_overlay(shine_overlay)
		qdel(shine_overlay)

/obj/item/gem/welder_act(mob/living/user, obj/item/I) //Jank code that detects if the gem in question has a sheet_type and spawns the items specifed in it
	if(I.use_tool(src, user, 0, volume=50))
		if(src.sheet_type)
			new src.sheet_type(user.loc)
			to_chat(user, span_notice("You carefully cut [src]."))
			qdel(src)
		else
			to_chat(user, span_notice("You can't seem to cut [src]."))
	return TRUE

/obj/item/gem/rupee
	name = "ruperium crystal"
	desc = "A radioactive, crystalline compound rarely found in the goldgrubs. While able to be cut into sheets of uranium, the mineral's true value is in its resonating, humming properties, often sought out by ethereal musicians to work into their gem-encrusted instruments. As a result, they fetch a fine price in most exchanges."
	icon_state = "rupee"
	materials = list(/datum/material/uranium=20000)
	sheet_type = /obj/item/stack/sheet/mineral/uranium{amount = 10}
	point_value = 300

/obj/item/gem/magma
	name = "calcified auric"
	desc = "A hot, lightly glowing mineral born from the inner workings of magmawing watchers. It is most commonly smelted down into deposits of pure gold. However, it also possesses powerful conductivity, leading some to believe it a major power component utilized by the Vxtvul Empire."
	icon_state = "magma"
	materials = list(/datum/material/gold=50000)
	sheet_type = /obj/item/stack/sheet/mineral/gold{amount = 25}
	point_value = 450
	light_range = 2
	light_power = 1
	light_color = "#ff7b00"

/obj/item/gem/fdiamond
	name = "frost diamond"
	desc = "A unique diamond that is produced within icewing watchers. Rarely used in traditional marriage bands, various gemstone companies now try to effect a monopoly on it, to little success. It looks like it can be cut into smaller sheets of diamond ore."
	icon_state = "diamond"
	materials = list(/datum/material/diamond=30000)
	sheet_type = /obj/item/stack/sheet/mineral/diamond{amount = 15}
	point_value = 750

/obj/item/gem/phoron
	name = "stabilized baroxuldium"
	desc = "A soft, glowing crystal only found in the deepest veins of plasma. Famed for its exceptional durability and uncommon beauty: widely considered to be a jackpot by mining crews. It looks like it could be destructively analyzed to extract the condensed materials within."
	icon_state = "phoron"
	materials = list(/datum/material/plasma=80000)
	point_value = 1200
	light_range = 2
	light_power = 2
	light_color = "#62326a"

/obj/item/gem/purple
	name = "densified dilithium"
	desc = "A strange mass of dilithium which pulses to a steady rhythm. Its strange surface exudes a unique radio signal detectable by GPS. It looks like it could be destructively analyzed to extract the condensed materials within."
	icon_state = "purple"
	materials = list(/datum/material/dilithium=64000)
	point_value = 1600
	light_range = 2
	light_power = 1
	light_color = "#b714cc"

	var/obj/item/gps/internal //stolen from the world anvil

/obj/item/gem/purple/Initialize()
	. = ..()
	internal = new /obj/item/gps/internal/purple(src)

/obj/item/gps/internal/purple
	icon_state = null
	gpstag = "Harmonic Signal"
	desc = "It's ringing."
	invisibility = 100

/obj/item/gem/amber
	name = "draconic amber"
	desc = "A brittle, strange mineral that forms when an ash drake's blood hardens after death. Cherished by gemcutters for its faint glow and unique, soft warmth. Poacher tales whisper of the dragon's strength being bestowed to one that wears a necklace of this amber, though such rumors are fictitious."
	icon_state = "amber"
	point_value = 1600
	light_range = 2
	light_power = 2
	light_color = "#FFBF00"

/obj/item/gem/void
	name = "null crystal"
	desc = "A shard of stellar, crystallized energy. These strange objects occasionally appear spontaneously in areas where the bluespace fabric is largely unstable. Its surface gives a light jolt to those who touch it. Despite its size, it's absurdly light."
	icon_state ="void"
	point_value = 1800
	light_range = 2
	light_power = 1
	light_color = "#4785a4"
	w_class = WEIGHT_CLASS_TINY

/obj/item/gem/bloodstone
	name = "ichorium"
	desc = "A weird, sticky substance, known to coalesce in the presence of otherworldly phenomena. While shunned by most spiritual groups, this gemstone has unique ties to the occult which find it handsomely valued by mysterious patrons."
	icon_state = "red"
	point_value = 2000
	light_range = 2
	light_power = 3
	light_color = "#800000"

/obj/item/gem/dark
	name = "dark salt lick"
	desc = "An ominous cylinder that glows with an unnerving aura, seeming to hungrily draw in the space around it. The round edges of the lick are uneven patches of rough texture. Its only known property is that of anti-magic."
	icon_state = "dark"
	point_value = 3000
	light_range = 3
	light_power = 3
	light_color = "#380a41"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gem/dark/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/gem/random
	name = "random gem"
	icon_state = "ruby"
	var/gem_list = list(/obj/item/gem/ruby, /obj/item/gem/sapphire, /obj/item/gem/emerald, /obj/item/gem/topaz)

/obj/item/gem/random/Initialize(quantity)
	. = ..()
	var/q = quantity ? quantity : 1
	for(var/i = 0, i < q, i++)
		var/obj/item/gem/G = pick(gem_list)
		new G(loc)
	qdel(src)

/obj/item/gem/ruby
	name = "ruby"
	icon_state = "ruby"
	point_value = 200

/obj/item/gem/sapphire
	name = "sapphire"
	icon_state = "sapphire"
	point_value = 200

/obj/item/gem/emerald
	name = "emerald"
	icon_state = "emerald"
	point_value = 200

/obj/item/gem/topaz
	name = "topaz"
	icon_state = "topaz"
	point_value = 200

/obj/item/ai_cpu/stalwart //very jank code-theft because it's not directly a gem
	name = "bluespace data crystal"
	desc = "A large bluespace crystal, etched internally with nano-circuits, it seemingly draws power from nowhere. Once acting as the brain of the Stalwart, perhaps this could be used in an AI server?"
	icon = 'icons/obj/gems.dmi'
	icon_state = "cpu"
	materials = list(/datum/material/bluespace=24000)
	speed = 20
	base_power_usage = 0.5 * AI_CPU_BASE_POWER_USAGE/5
	minimum_max_power = 0.5
	maximum_max_power = 10.0
	minimum_growth = 2.0
	maximum_growth = 8.0
	light_range = 2
	light_power = 6
	light_color = "#0004ff"
	///Have we been analysed with a mining scanner?
	var/analysed = FALSE
	///How many points we grant to whoever discovers us
	var/point_value = 2000

/obj/item/ai_cpu/stalwart/attackby(obj/item/item, mob/living/user, params) //Stolen directly from geysers, removed the internal gps
	if(!istype(item, /obj/item/mining_scanner) && !istype(item, /obj/item/t_scanner/adv_mining_scanner))
		return ..()

	if(analysed)
		to_chat(user, span_warning("This gem has already been analysed!"))
		return
	else
		to_chat(user, span_notice("You analyse the precious gemstone!"))
		analysed = TRUE

	if(isliving(user))
		var/mob/living/living = user

		var/obj/item/card/id/card = living.get_idcard()
		if(card)
			to_chat(user, span_notice("[point_value] mining points have been paid out!"))
			card.mining_points += point_value
			playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
