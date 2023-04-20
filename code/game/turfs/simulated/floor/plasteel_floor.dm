/turf/open/floor/plasteel
	icon_state = "floor"
	floor_tile = /obj/item/stack/tile/plasteel
	broken_states = list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")
	burnt_states = list("floorscorched1", "floorscorched2")

/turf/open/floor/plasteel/examine(mob/user)
	. = ..()
	. += span_notice("There's a <b>small crack</b> on the edge of it.")

/turf/open/floor/plasteel/rust_heretic_act()
	if(prob(70))
		new /obj/effect/glowing_rune(src)
	ChangeTurf(/turf/open/floor/plating/rust)

/turf/open/floor/plasteel/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		icon = icon_regular_floor
		icon_state = icon_state_regular_floor

/turf/open/floor/plasteel/broken
	icon_state = "damaged1"
	broken = TRUE

/turf/open/floor/plasteel/broken/two
	icon_state = "damaged2"

/turf/open/floor/plasteel/broken/three
	icon_state = "damaged3"

/turf/open/floor/plasteel/burnt
	icon_state = "floorscorched1"
	burnt = TRUE

/turf/open/floor/plasteel/burnt/two
	icon_state = "floorscorched2"

/turf/open/floor/plasteel/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plasteel/airless/broken
	icon_state = "damaged1"
	broken = TRUE

/turf/open/floor/plasteel/airless/broken/two
	icon_state = "damaged2"

/turf/open/floor/plasteel/airless/broken/three
	icon_state = "damaged3"

/turf/open/floor/plasteel/airless/burnt
	icon_state = "floorscorched1"
	burnt = TRUE

/turf/open/floor/plasteel/airless/burnt/two
	icon_state = "floorscorched2"

/turf/open/floor/plasteel/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/plasteel/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/floor/plasteel/lavaland/broken
	icon_state = "damaged1"
	broken = TRUE

/turf/open/floor/plasteel/lavaland/broken/two
	icon_state = "damaged2"

/turf/open/floor/plasteel/lavaland/broken/three
	icon_state = "damaged3"

/turf/open/floor/plasteel/lavaland/burnt
	icon_state = "floorscorched1"
	burnt = TRUE

/turf/open/floor/plasteel/lavaland/burnt/two
	icon_state = "floorscorched2"

/turf/open/floor/plasteel/dark
	icon_state = "darkfull"

/turf/open/floor/plasteel/dark/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plasteel/dark/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/plasteel/airless/dark
	icon_state = "darkfull"

/turf/open/floor/plasteel/dark/side
	icon_state = "dark"

/turf/open/floor/plasteel/dark/corner
	icon_state = "darkcorner"

/turf/open/floor/plasteel/dark/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/floor/plasteel/checker
	icon_state = "checker"

/turf/open/floor/plasteel/white
	icon_state = "white"

/turf/open/floor/plasteel/whitegrad
	icon_state = "whitegreygrad"

/turf/open/floor/plasteel/white/side
	icon_state = "whitehall"

/turf/open/floor/plasteel/white/corner
	icon_state = "whitecorner"

/turf/open/floor/plasteel/airless/white
	icon_state = "white"

/turf/open/floor/plasteel/airless/white/side
	icon_state = "whitehall"

/turf/open/floor/plasteel/airless/white/corner
	icon_state = "whitecorner"

/turf/open/floor/plasteel/white/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/plasteel/white/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/floor/plasteel/yellowsiding
	icon_state = "yellowsiding"

/turf/open/floor/plasteel/yellowsiding/corner
	icon_state = "yellowcornersiding"

/turf/open/floor/plasteel/recharge_floor
	icon_state = "recharge_floor"

/turf/open/floor/plasteel/recharge_floor/asteroid
	icon_state = "recharge_floor_asteroid"

/turf/open/floor/plasteel/chapel
	icon_state = "chapel"

/turf/open/floor/plasteel/showroomfloor
	icon_state = "showroomfloor"

/turf/open/floor/plasteel/solarpanel
	icon_state = "solarpanel"

turf/open/floor/plasteel/airless/solarpanel
	icon_state = "solarpanel"

/turf/open/floor/plasteel/freezer
	icon_state = "freezerfloor"

/turf/open/floor/plasteel/freezer/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plasteel/kitchen_coldroom
	name = "cold room floor"
	initial_gas_mix = KITCHEN_COLDROOM_ATMOS

/turf/open/floor/plasteel/kitchen_coldroom/broken
	icon_state = "damaged1"
	broken = TRUE

/turf/open/floor/plasteel/kitchen_coldroom/broken/two
	icon_state = "damaged2"

/turf/open/floor/plasteel/kitchen_coldroom/broken/three
	icon_state = "damaged3"

/turf/open/floor/plasteel/kitchen_coldroom/burnt
	icon_state = "floorscorched1"
	burnt = TRUE

/turf/open/floor/plasteel/kitchen_coldroom/burnt/two
	icon_state = "floorscorched2"

/turf/open/floor/plasteel/kitchen_coldroom/freezerfloor
	icon_state = "freezerfloor"

/turf/open/floor/plasteel/grimy
	icon_state = "grimy"
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cafeteria
	icon_state = "cafeteria"

/turf/open/floor/plasteel/airless/cafeteria
	icon_state = "cafeteria"

/turf/open/floor/plasteel/cult
	icon_state = "cult"
	broken_states = list("damage1", "damage2", "damage3", "damage4", "damage5")
	name = "engraved floor"

/turf/open/floor/plasteel/cult/broken
	icon_state = "damage1"
	broken = TRUE

/turf/open/floor/plasteel/cult/broken/two
	icon_state = "damage2"

/turf/open/floor/plasteel/cult/broken/three
	icon_state = "damage3"

/turf/open/floor/plasteel/cult/broken/three
	icon_state = "damage4"

/turf/open/floor/plasteel/cult/broken/three
	icon_state = "damage5"

/turf/open/floor/plasteel/vaporwave
	icon_state = "pinkblack"

/turf/open/floor/plasteel/goonplaque
	icon_state = "plaque"
	name = "commemorative plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."
	tiled_dirt = FALSE

/turf/open/floor/plasteel/cult/narsie_act()
	return
/turf/open/floor/plasteel/cult/airless
	initial_gas_mix = AIRLESS_ATMOS


/turf/open/floor/plasteel/cult/airless/broken
	icon_state = "damage1"
	broken = TRUE

/turf/open/floor/plasteel/cult/airless/broken/two
	icon_state = "damage2"

/turf/open/floor/plasteel/cult/airless/broken/three
	icon_state = "damage3"

/turf/open/floor/plasteel/cult/airless/broken/three
	icon_state = "damage4"

/turf/open/floor/plasteel/cult/airless/broken/three
	icon_state = "damage5"

/turf/open/floor/plasteel/stairs
	icon_state = "stairs"
	tiled_dirt = FALSE

/turf/open/floor/plasteel/stairs/left
	icon_state = "stairs-l"

/turf/open/floor/plasteel/stairs/medium
	icon_state = "stairs-m"

/turf/open/floor/plasteel/stairs/right
	icon_state = "stairs-r"

/turf/open/floor/plasteel/stairs/old
	icon_state = "stairs-old"

/turf/open/floor/plasteel/rockvault
	icon_state = "rockvault"

/turf/open/floor/plasteel/rockvault/alien
	icon_state = "alienvault"

/turf/open/floor/plasteel/rockvault/sandstone
	icon_state = "sandstonevault"

/turf/open/floor/plasteel/elevatorshaft
	icon_state = "elevatorshaft"

/turf/open/floor/plasteel/bluespace
	icon_state = "bluespace"

/turf/open/floor/plasteel/sepia
	icon_state = "sepia"
