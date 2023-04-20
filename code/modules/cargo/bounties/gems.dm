/datum/bounty/item/gems/ship(obj/O)
	..()
	var/obj/item/gem/sold = O
	var/obj/item/card/id/claim = sold?.claimed_by
	if(claim)
		var/area/shuttle/shuttle = get_area(O)
		shuttle.gem_payout[claim] += sold.point_value * 1.1 //bounty bonus

/datum/bounty/item/gems/rupees
	name = "Ruperium Crystals"
	description = "Nanotrasen has taken an interest in their resonating properties and requests you find three samples. You would be paid handsomely for this effort."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/gem/rupee)

/datum/bounty/item/gems/magma
	name = "Calcified Auric"
	description = "Nanotransen needs three of these for a secret project. Meet their demands and get paid for your endeavors."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/gem/magma)

/datum/bounty/item/gems/diamonds
	name = "Frost Diamonds"
	description = "A CentCom official is being married in the coming months. Get them those wedding rings!"
	reward = 10000
	required_count = 2
	wanted_types = list(/obj/item/gem/fdiamond)

/datum/bounty/item/gems/plasma //todo eventually: make these check megafauna spawns before being added
	name = "Stabilized Baroxuldium"
	description = "Central Command needs a plasma gem to showcase in their museum. Find one and be rewarded."
	reward = 15000
	wanted_types = list(/obj/item/gem/phoron)

/datum/bounty/item/gems/dilithium
	name = "Densified Dilithium"
	description = "CentCom wants to test a new, more compact network infrastructure using dilithium wavelengths. Help solve their problem while getting a sizeable sum."
	reward = 16000
	wanted_types = list(/obj/item/gem/purple) //why is it just "purple" wtf

/datum/bounty/item/gems/amber
	name = "Draconic Amber"
	description = "A son of a CentCom official wants to harness the power of the amber. Send one over to earn a quick buck."
	reward = 18000
	wanted_types = list(/obj/item/gem/amber)

/datum/bounty/item/gems/void
	name = "Null Crystal"
	description = "Central Command researchers are interested in its strange bluespace properties. Ship one for a sizable compensation."
	reward = 20000
	wanted_types = list(/obj/item/gem/void)

/datum/bounty/item/gems/blood
	name = "Ichorium Crystal"
	description = "Nanotrasen wants to experiment on the strange phenomena induced by this gem. Selling it to them would turn a massive profit."
	reward = 25000
	wanted_types = list(/obj/item/gem/bloodstone)

/datum/bounty/item/gems/dark
	name = "Dark Salt Lick"
	description = "Central Command's Research Director is particularly interested in the anomalous effects of this gem. Ship one over and he'll pay us directly."
	reward = 40000
	wanted_types = list(/obj/item/gem/dark)

/datum/bounty/item/gems/minor
	name = "Minor Lavaland Gems"
	description = "The jewerly business is booming and Nanotrasen needs to cover its bills. Send some rare gemstones so Nanotrasen can contribute to fast space fashion."
	reward = 12000
	required_count = 5
	wanted_types = list(/obj/item/gem/ruby,/obj/item/gem/sapphire,/obj/item/gem/emerald,/obj/item/gem/topaz)

/datum/bounty/item/gems/stalwart
	name = "Bluespace Data Crystal"
	description = "Central Command's Research Director is ecstatic over the possible uses and internal structure of this gem. Ship one over and he'll pay us directly."
	reward = 16500
	wanted_types = list(/obj/item/ai_cpu/stalwart)
