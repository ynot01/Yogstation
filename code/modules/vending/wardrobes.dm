/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe
	default_price = 50
	extra_price = 75
	payment_department = NO_FREEBIES
	input_display_header = "Returned Clothing"
	panel_type = "panel19"
	light_mask = "wardrobe-light-mask"


/obj/machinery/vending/wardrobe/canLoadItem(obj/item/I,mob/user)
	if(I.type in products)
		// Yogs -- weird snowflake check to make sure you can't print an endless amount of encryption chips.
		// In general, vending machines should try to ensure that anything they dare accept as input is in the exact same state that it came out of them with.
		if(istype(I,/obj/item/radio/headset) && I.type != /obj/item/radio/headset)
			var/obj/item/radio/headset/HS = I
			if(HS.keyslot != initial(HS.keyslot)) // Hey, you stole something!
				return FALSE
		if(istype(I, /obj/item/storage/box)) //no putting boxes back, sorry
			return FALSE
		return TRUE

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper SecDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;It's red so you can't see the blood!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using the SecDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security = 3,
					/obj/item/storage/backpack/security = 3,
					/obj/item/storage/backpack/satchel/sec = 3,
					/obj/item/storage/backpack/duffelbag/sec = 3,
					/obj/item/clothing/under/rank/security/officer = 3,
					/obj/item/clothing/under/yogs/armyuniform = 3,
					/obj/item/clothing/shoes/jackboots = 3,
					/obj/item/clothing/shoes/xeno_wraps/jackboots = 3,
					/obj/item/clothing/head/beret/sec = 3,
					/obj/item/clothing/head/beret/corpsec = 3,
					/obj/item/clothing/head/soft/sec = 3,
					/obj/item/clothing/mask/bandana/red = 3,
					/obj/item/clothing/suit/armor/vest/secmiljacket = 3,
					/obj/item/clothing/shoes/yogs/namboots = 5,
					/obj/item/clothing/gloves/yogs/namgloves = 5,
					/obj/item/clothing/under/yogs/namjumpsuit = 5,
					/obj/item/clothing/suit/armor/vest/namflakjacket = 5,
					/obj/item/clothing/head/helmet/namhelm = 5,
					/obj/item/clothing/under/yogs/redcoatuniform = 5,
					/obj/item/clothing/suit/armor/vest/redcoatcoat = 5,
					/obj/item/clothing/head/yogs/tricornhat = 5,
					/obj/item/clothing/under/rank/security/officer/skirt = 3,
					/obj/item/clothing/under/rank/security/officer/grey = 3,
					/obj/item/clothing/under/rank/security/officer/shitcurity = 3,
					/obj/item/clothing/under/pants/khaki = 3,
					/obj/item/clothing/under/rank/security/blueshirt = 3,
					/obj/item/clothing/under/rank/security/secconuniform = 3,
					/obj/item/clothing/head/helmet/secconhelm = 3,
					/obj/item/clothing/suit/armor/secconcoat = 3,
					/obj/item/clothing/head/beret/sec/secconhat = 3,
					/obj/item/clothing/suit/armor/secconvest = 3)
	premium = list(/obj/item/clothing/under/rank/security/navyblue = 3,
					/obj/item/clothing/suit/armor/officerjacket = 3,
					/obj/item/clothing/head/beret/sec/navyofficer = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MOSTLY_PURE_RED

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "SecDrobe"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "\improper MediDrobe"
	desc = "A vending machine rumoured to be capable of dispensing clothing for medical personnel."
	icon_state = "medidrobe"
	product_ads = "Make those blood stains look fashionable!!"
	vend_reply = "Thank you for using the MediDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 4,
					/obj/item/storage/backpack/duffelbag/med = 4,
					/obj/item/storage/backpack/satchel/med = 4,
					/obj/item/storage/backpack/medic = 4,
					/obj/item/clothing/head/soft/emt = 4,
					/obj/item/clothing/head/soft/emt/green = 4,
					/obj/item/clothing/head/beret/emt/green = 4,
					/obj/item/clothing/head/beret/emt= 4,
					/obj/item/clothing/head/beret/med = 4,
					/obj/item/clothing/head/nursehat = 4,
					/obj/item/clothing/mask/surgical = 4,
					/obj/item/clothing/under/yogs/nursedress = 4,
					/obj/item/clothing/suit/toggle/labcoat/md = 4,
					/obj/item/clothing/suit/toggle/labcoat/emt = 4,
					/obj/item/clothing/suit/toggle/labcoat/emt/green = 4,
					/obj/item/clothing/suit/hooded/wintercoat/medical = 4,
					/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic = 4,
					/obj/item/clothing/suit/apron/surgical = 4,
					/obj/item/clothing/under/rank/medical/doctor/skirt = 4,
					/obj/item/clothing/under/rank/medical/doctor/blue = 4,
					/obj/item/clothing/under/rank/medical/doctor/green = 4,
					/obj/item/clothing/under/rank/medical/doctor/purple = 4,
					/obj/item/clothing/under/rank/medical/doctor = 4,
					/obj/item/clothing/under/rank/medical/nursesuit = 4,
					/obj/item/clothing/shoes/sneakers/white = 4,
					/obj/item/clothing/shoes/xeno_wraps/medical = 4,
					/obj/item/clothing/accessory/armband/medblue = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "MediDrobe"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "EngiDrobe"
	desc = "A vending machine renowned for vending industrial grade clothing."
	icon_state = "engidrobe"
	product_ads = "Guaranteed to protect your feet from industrial accidents!;Afraid of radiation? Then wear yellow!"
	vend_reply = "Thank you for using the EngiDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/duffelbag/engineering = 3,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
					/obj/item/clothing/under/rank/engineering/engineer = 3,
					/obj/item/clothing/under/rank/engineering/engineer/skirt = 3,
					/obj/item/clothing/under/rank/engineering/engineer/hazard = 3,
					/obj/item/clothing/suit/hazardvest = 3,
					/obj/item/clothing/shoes/workboots = 3,
					/obj/item/clothing/shoes/xeno_wraps/engineering = 3,
					/obj/item/clothing/head/beret/eng = 3,
					/obj/item/clothing/head/hardhat = 3,
					/obj/item/clothing/head/welding/demon = 1,
					/obj/item/clothing/head/welding/knight = 1,
					/obj/item/clothing/head/welding/engie = 1,
					/obj/item/clothing/head/hardhat/weldhat = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW
/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "EngiDrobe"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "AtmosDrobe"
	desc = "This relatively unknown vending machine delivers clothing for Atmospherics Technicians, an equally unknown job."
	icon_state = "atmosdrobe"
	product_ads = "Get your inflammable clothing right here!!!"
	vend_reply = "Thank you for using the AtmosDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 2,
					/obj/item/storage/backpack/duffelbag/engineering = 2,
					/obj/item/storage/backpack/satchel/eng = 2,
					/obj/item/storage/backpack/industrial = 2,
					/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
					/obj/item/clothing/head/beret/atmos = 3,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician = 3,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt = 3,
					/obj/item/clothing/shoes/sneakers/black = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "AtmosDrobe"

/obj/machinery/vending/wardrobe/sig_wardrobe
	name = "NetDrobe"
	desc = "A rarely used vending machine that provides clothing for Network Admins."
	icon = 'yogstation/icons/obj/vending.dmi'
	icon_state = "sigdrobe"
	panel_type = "panel-sigdrobe"
	product_ads = "Dress to impress yourself!;The drones will love you!;Get your clothing here!"
	vend_reply = "Thank you for using the NetDrobe!"
	products = list(/obj/item/storage/backpack/duffelbag/engineering = 1,
					/obj/item/storage/backpack/industrial = 1,
					/obj/item/storage/backpack/satchel/eng = 1,
					/obj/item/clothing/suit/hooded/wintercoat/engineering/tcomms = 1,
					/obj/item/clothing/under/yogs/rank/network_admin = 1,
					/obj/item/clothing/shoes/workboots = 1,
					/obj/item/clothing/under/yogs/rank/network_admin/skirt = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/sig_wardrobe
	payment_department = ACCOUNT_ENG
/obj/item/vending_refill/wardrobe/sig_wardrobe
	machine_name = "NetDrobe"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "CargoDrobe"
	desc = "A highly advanced vending machine for buying cargo related clothing for free."
	icon_state = "cargodrobe"
	product_ads = "Upgraded Assistant Style! Pick yours today!;These shorts are comfy and easy to wear, get yours now!"
	vend_reply = "Thank you for using the CargoDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
					/obj/item/clothing/under/rank/cargo/tech = 3,
					/obj/item/clothing/under/rank/cargo/tech/skirt = 3,
					/obj/item/clothing/under/rank/cargo/tech/turtleneck = 3,
					/obj/item/clothing/under/rank/cargo/tech/skirt/turtleneck = 3,
					/obj/item/clothing/shoes/sneakers/black = 3,
					/obj/item/clothing/shoes/xeno_wraps/cargo = 3,
					/obj/item/clothing/shoes/xeno_wraps/cargo/cleated = 1,
					/obj/item/clothing/gloves/fingerless = 3,
					/obj/item/clothing/head/soft = 3,
					/obj/item/radio/headset/headset_cargo = 3,
					/obj/item/clothing/accessory/armband/cargo = 2,
					/obj/item/storage/bag/mail = 3)
	premium = list(/obj/item/clothing/under/rank/cargo/miner = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe
	payment_department = ACCOUNT_CAR
/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "CargoDrobe"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "RoboDrobe"
	desc = "A vending machine designed to dispense clothing known only to roboticists."
	icon_state = "robodrobe"
	product_ads = "You turn me TRUE, use defines!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101"
	vend_reply = "Thank you for using the RoboDrobe!"
	products = list(/obj/item/clothing/glasses/hud/diagnostic = 2,
					/obj/item/clothing/head/welding/carp = 1,
					/obj/item/clothing/head/welding/fancy = 1,
					/obj/item/clothing/head/welding/demon = 1,
					/obj/item/clothing/under/rank/rnd/roboticist = 2,
					/obj/item/clothing/under/rank/rnd/roboticist/skirt = 2,
					/obj/item/clothing/suit/toggle/labcoat = 2,
					/obj/item/clothing/suit/toggle/labcoat/wardtlab = 2,
					/obj/item/clothing/suit/toggle/labcoat/aeneasrinil = 2,
					/obj/item/clothing/suit/hooded/wintercoat/science/robotics = 3,
					/obj/item/clothing/shoes/sneakers/black = 2,
					/obj/item/clothing/gloves/fingerless = 2,
					/obj/item/clothing/head/soft/black = 2,
					/obj/item/clothing/mask/bandana/skull = 2,
					/obj/item/clothing/suit/hooded/amech = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "RoboDrobe"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "SciDrobe"
	desc = "A simple vending machine suitable to dispense well tailored science clothing. Endorsed by Space Cubans."
	icon_state = "scidrobe"
	product_ads = "Longing for the smell of plasma burnt flesh? Buy your science clothing now!;Made with 10% Auxetics, so you don't have to worry about losing your arm!"
	vend_reply = "Thank you for using the SciDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/storage/backpack/science = 3,
					/obj/item/storage/backpack/satchel/tox = 3,
					/obj/item/clothing/head/beret/sci = 3,
					/obj/item/clothing/suit/hooded/wintercoat/science = 3,
					/obj/item/clothing/under/rank/rnd/scientist = 3,
					/obj/item/clothing/under/rank/rnd/scientist/skirt = 3,
					/obj/item/clothing/suit/toggle/labcoat/science = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/shoes/xeno_wraps/science = 3,
					/obj/item/radio/headset/headset_sci = 3,
					/obj/item/clothing/mask/gas = 3,
					/obj/item/clothing/accessory/armband/science = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe
	payment_department = ACCOUNT_SCI
/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "SciDrobe"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "Hydrobe"
	desc = "A machine with a catchy name. It dispenses botany related clothing and gear."
	icon_state = "hydrobe"
	product_ads = "Do you love soil? Then buy our clothes!;Get outfits to match your green thumb here!"
	vend_reply = "Thank you for using the Hydrobe!"
	products = list(/obj/item/storage/backpack/botany = 2,
					/obj/item/storage/backpack/satchel/hyd = 2,
					/obj/item/clothing/suit/hooded/wintercoat/hydro = 2,
					/obj/item/clothing/suit/apron = 2,
					/obj/item/clothing/suit/apron/overalls = 3,
					/obj/item/clothing/under/yogs/botanyuniform = 3,
					/obj/item/clothing/under/rank/civilian/hydroponics = 3,
					/obj/item/clothing/under/rank/civilian/hydroponics/skirt = 3,
					/obj/item/clothing/mask/bandana = 3,
					/obj/item/clothing/accessory/armband/hydro = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe
	payment_department = ACCOUNT_SRV
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "HyDrobe"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "CuraDrobe"
	desc = "A lowstock vendor only capable of vending clothing for curators and librarians."
	icon_state = "curadrobe"
	product_ads = "Glasses for your eyes and literature for your soul, Curadrobe has it all!; Impress & enthrall your library guests with Curadrobe's extended line of pens!"
	vend_reply = "Thank you for using the CuraDrobe!"
	products = list(/obj/item/pen = 4,
					/obj/item/pen/red = 2,
					/obj/item/pen/blue = 2,
					/obj/item/pen/fourcolor = 1,
					/obj/item/pen/fountain = 2,
					/obj/item/toner = 3,
					/obj/item/clothing/accessory/pocketprotector = 2,
					/obj/item/clothing/under/rank/curator/skirt = 2,
					/obj/item/clothing/under/rank/command/captain/suit/skirt = 2,
					/obj/item/clothing/under/rank/command/head_of_personnel/suit/skirt = 2,
					/obj/item/storage/backpack/satchel/explorer = 1,
					/obj/item/clothing/under/yogs/treasure = 1,
					/obj/item/clothing/under/yogs/colony = 1,
					/obj/item/clothing/glasses/regular = 2,
					/obj/item/clothing/glasses/regular/jamjar = 1,
					/obj/item/storage/bag/books = 1,
					/obj/item/clothing/accessory/armband/service = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe
	payment_department = ACCOUNT_CIV
/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "CuraDrobe"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "BarDrobe"
	desc = "A stylish vendor to dispense the most stylish bar clothing!"
	icon_state = "bardrobe"
	product_ads = "Guaranteed to prevent stains from spilled drinks!"
	vend_reply = "Thank you for using the BarDrobe!"
	products = list(/obj/item/clothing/head/that = 2,
					/obj/item/radio/headset/headset_srv = 2,
					/obj/item/clothing/under/suit/sl_suit = 2,
					/obj/item/clothing/under/rank/civilian/bartender = 2,
					/obj/item/clothing/under/yogs/billydonka = 2,
					/obj/item/clothing/head/yogs/billydonkahat = 2,
					/obj/item/cane = 2,
					/obj/item/clothing/under/yogs/callumsuit = 2,
					/obj/item/clothing/under/rank/civilian/bartender/purple = 2,
					/obj/item/clothing/under/rank/civilian/bartender/skirt = 2,
					/obj/item/clothing/accessory/waistcoat = 2,
					/obj/item/clothing/suit/apron/purple_bartender = 2,
					/obj/item/clothing/head/soft/black = 2,
					/obj/item/clothing/shoes/sneakers/black = 2,
					/obj/item/reagent_containers/glass/rag = 2,
					/obj/item/storage/box/beanbag = 1,
					/obj/item/clothing/suit/armor/vest/alt = 1,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/glasses/sunglasses/reagent = 1,
					/obj/item/storage/belt/bandolier = 1,
					/obj/item/clothing/accessory/armband/service = 1)
	premium = list(/obj/item/storage/box/dishdrive = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "BarDrobe"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "ChefDrobe"
	desc = "This vending machine might not dispense meat, but it certainly dispenses chef related clothing."
	icon_state = "chefdrobe"
	product_ads = "Our clothes are guaranteed to protect you from food splatters!"
	vend_reply = "Thank you for using the ChefDrobe!"
	products = list(/obj/item/clothing/under/suit/waiter = 2,
					/obj/item/radio/headset/headset_srv = 2,
					/obj/item/clothing/accessory/waistcoat = 2,
					/obj/item/clothing/suit/apron/chef = 3,
					/obj/item/clothing/head/soft/mime = 2,
					/obj/item/storage/box/mousetraps = 2,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/suit/toggle/chef = 1,
					/obj/item/clothing/under/rank/civilian/chef = 2,
					/obj/item/clothing/under/rank/civilian/chef/skirt = 2,
					/obj/item/clothing/head/chefhat = 1,
					/obj/item/reagent_containers/glass/rag = 2,
					/obj/item/clothing/suit/hooded/wintercoat = 2,
					/obj/item/clothing/accessory/armband/service = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe
	payment_department = ACCOUNT_SRV
/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "ChefDrobe"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "JaniDrobe"
	desc = "A self cleaning vending machine capable of dispensing clothing for janitors."
	icon_state = "janidrobe"
	product_ads = "Come and get your janitorial clothing, now endorsed by lizard janitors everywhere!"
	vend_reply = "Thank you for using the JaniDrobe!"
	products = list(/obj/item/clothing/under/rank/civilian/janitor = 2,
					/obj/item/clothing/under/yogs/casualjanitorsuit = 2,
					/obj/item/clothing/suit/yogs/janitorcoat = 2,
					/obj/item/clothing/suit/hooded/wintercoat/janitor = 2,
					/obj/item/clothing/under/rank/civilian/janitor/skirt = 2,
					/obj/item/clothing/under/rank/civilian/janitor/maid = 2,
					/obj/item/clothing/gloves/color/black = 2,
					/obj/item/clothing/head/soft/purple = 2,
					/obj/item/broom = 2,
					/obj/item/paint/paint_remover = 2,
					/obj/item/melee/flyswatter = 2,
					/obj/item/flashlight = 2,
					/obj/item/clothing/suit/caution = 6,
					/obj/item/holosign_creator/janibarrier = 2,
					/obj/item/lightreplacer = 2,
					/obj/item/soap/nanotrasen = 2,
					/obj/item/storage/bag/trash = 2,
					/obj/item/clothing/shoes/galoshes = 2,
					/obj/item/watertank/janitor = 2,
					/obj/item/storage/belt/janitor = 2,
					/obj/item/clothing/accessory/armband/service = 1,
					/obj/item/reagent_containers/spray/cleaner = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe
	payment_department = ACCOUNT_SRV
	light_color = COLOR_STRONG_MAGENTA

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "JaniDrobe"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "LawDrobe"
	desc = "Objection! This wardrobe dispenses the rule of law... and lawyer clothing."
	icon_state = "lawdrobe"
	product_ads = "OBJECTION! Get the rule of law for yourself!"
	vend_reply = "Thank you for using the LawDrobe!"
	products = list(/obj/item/clothing/under/rank/civilian/lawyer/female = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/black = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/black/skirt = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/red = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/red/skirt = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/bluesuit = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt = 2,
					/obj/item/clothing/under/yogs/prosecutorsuit = 2,
					/obj/item/clothing/suit/toggle/lawyer = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt = 2,
					/obj/item/clothing/suit/toggle/lawyer/purple = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/blacksuit = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/blacksuit/skirt = 2,
					/obj/item/clothing/suit/toggle/lawyer/black = 2,
					/obj/item/clothing/shoes/laceup = 2,
					/obj/item/clothing/accessory/lawyers_badge = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe
	payment_department = ACCOUNT_CIV
/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "LawDrobe"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "ChapDrobe"
	desc = "This most blessed and holy machine vends clothing only suitable for chaplains to gaze upon."
	icon_state = "chapdrobe"
	product_ads = "Are you being bothered by cultists or pesky revenants? Then come and dress like the holy man!;Clothes for men of the cloth!"
	vend_reply = "Thank you for using the ChapDrobe!"
	products = list(/obj/item/choice_beacon/holy = 1,
					/obj/item/storage/backpack/cultpack = 1,
					/obj/item/reagent_containers/glass/urn = 10,
					/obj/item/clothing/accessory/pocketprotector/cosmetology = 1,
					/obj/item/clothing/under/rank/civilian/chaplain = 1,
					/obj/item/clothing/under/rank/civilian/chaplain/skirt = 2,
					/obj/item/clothing/shoes/sneakers/black = 1,
					/obj/item/clothing/suit/chaplainsuit/nun = 1,
					/obj/item/clothing/head/nun_hood = 1,
					/obj/item/clothing/suit/chaplainsuit/holidaypriest = 1,
					/obj/item/clothing/suit/yogs/witchhuntblue = 1,
					/obj/item/clothing/under/yogs/fiendsuit = 1,
					/obj/item/clothing/suit/hooded/fiendcowl = 1,
					/obj/item/clothing/under/yogs/caretaker = 1,
					/obj/item/clothing/suit/hooded/caretakercloak = 1,
					/obj/item/clothing/suit/yogs/monkrobes = 1,
					/obj/item/clothing/suit/hooded/amech = 2,
					/obj/item/storage/fancy/candle_box = 2,
					/obj/item/clothing/head/kippah = 3,
					/obj/item/clothing/suit/chaplainsuit/whiterobe = 1,
					/obj/item/clothing/head/taqiyahwhite = 1,
					/obj/item/clothing/head/taqiyahred = 3,
					/obj/item/clothing/suit/hooded/techpriest = 2)
	contraband = list(/obj/item/toy/plush/plushvar = 1,
					/obj/item/toy/plush/narplush = 1,
					/obj/item/clothing/head/medievaljewhat = 3,
					/obj/item/clothing/suit/chaplainsuit/clownpriest = 1,
					/obj/item/clothing/head/clownmitre = 1,
					/obj/item/clothing/head/yogs/goatpope = 1)
	premium = list(/obj/item/clothing/suit/chaplainsuit/bishoprobe = 1,
					/obj/item/clothing/head/bishopmitre = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe
	payment_department = ACCOUNT_CIV
/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "ChapDrobe"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "ChemDrobe"
	desc = "A vending machine for dispensing chemistry related clothing."
	icon_state = "chemdrobe"
	product_ads = "Our clothes are 0.5% more resistant to acid spills! Get yours now!"
	vend_reply = "Thank you for using the ChemDrobe!"
	products = list(/obj/item/clothing/under/rank/medical/chemist = 2,
					/obj/item/clothing/under/rank/medical/chemist/skirt = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
					/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry = 2,
					/obj/item/clothing/head/beret/chem = 2,
					/obj/item/storage/backpack/chemistry = 2,
					/obj/item/storage/backpack/satchel/chem = 2,
					/obj/item/storage/bag/chemistry = 4)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe
	payment_department = ACCOUNT_MED
/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "ChemDrobe"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "GeneDrobe"
	desc = "A machine for dispensing clothing related to genetics."
	icon_state = "genedrobe"
	product_ads = "Perfect for the mad scientist in you!"
	vend_reply = "Thank you for using the GeneDrobe!"
	products = list(/obj/item/clothing/under/rank/rnd/geneticist = 2,
					/obj/item/clothing/under/rank/rnd/geneticist/skirt = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/genetics = 2,
					/obj/item/clothing/suit/hooded/wintercoat/science/genetics = 2,
					/obj/item/storage/backpack/genetics = 2,
					/obj/item/storage/backpack/satchel/gen = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe
	payment_department = ACCOUNT_MED
/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "GeneDrobe"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "ViroDrobe"
	desc = "An unsterilized machine for dispending virology related clothing."
	icon_state = "virodrobe"
	product_ads = " Viruses getting you down? Then upgrade to sterilized clothing today!"
	vend_reply = "Thank you for using the ViroDrobe"
	products = list(/obj/item/clothing/under/rank/medical/virologist = 2,
					/obj/item/clothing/under/rank/medical/virologist/skirt = 2,
					/obj/item/clothing/shoes/sneakers/white = 2,
					/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
					/obj/item/clothing/suit/hooded/wintercoat/medical/viro = 2,
					/obj/item/clothing/mask/surgical = 2,
					/obj/item/storage/backpack/virology = 2,
					/obj/item/storage/backpack/satchel/vir = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe
	payment_department = ACCOUNT_MED
/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "ViroDrobe"

/obj/machinery/vending/wardrobe/hop_wardrobe
	name = "HopDrobe"
	desc = "A machine that will dispense clothing meant for the head of personnel."
	icon_state = "hopdrobe"
	product_ads = "Get your Ian approved clothing here!"
	vend_reply = "Thank you for using the HopDrobe!"
	products = list(/obj/item/clothing/under/rank/command/head_of_personnel = 2,
					/obj/item/clothing/under/rank/command/head_of_personnel/skirt = 2,
					/obj/item/clothing/under/rank/command/head_of_personnel/turtleneck = 2,
					/obj/item/clothing/under/rank/command/head_of_personnel/skirt/turtleneck = 2,
					/obj/item/clothing/head/hopcap = 2,
					/obj/item/clothing/head/beret/hop = 2,
					/obj/item/clothing/shoes/sneakers/brown = 2,
					/obj/item/clothing/shoes/xeno_wraps/command = 2,
					/obj/item/clothing/suit/armor/vest/rurmcoat = 1,
					/obj/item/clothing/suit/armor/vest/sovietcoat = 1,
					/obj/item/clothing/suit/armor/vest/hop_formal = 1,
					/obj/item/clothing/under/yogs/hopcasual = 2,
					/obj/item/clothing/suit/hooded/wintercoat/hop = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/hop_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/hop_wardrobe
	machine_name = "HopDrobe"