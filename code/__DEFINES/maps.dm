/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded Z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See code/datums/map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in _maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded Z-level.

As of April 26th, 2022, the typical Z-levels for a single-level station are:
1: CentCom
2: Station
3-4: Randomized Space (Ruins)
5: Mining
6-11: Randomized Space (Ruins)
12: Transit/Reserved Space

However, if away missions are enabled:
12: Away Mission
13: Transit/Reserved Space

Multi-Z stations are supported and Multi-Z mining and away missions would
require only minor tweaks. They also handle their Z-Levels differently on their
own case by case basis.

This information will absolutely date quickly with how we handle Z-Levels, and will
continue to handle them in the future. Currently, you can go into the Debug tab
of your stat-panel (in game) and hit "Mapping verbs - Enable". You will then get a new tab
called "Mapping", as well as access to the verb "Debug-Z-Levels". Although the information
presented in this comment is factual for the time it was written for, it's ill-advised
to trust the words presented within.

We also provide this information to you so that you can have an at-a-glance look at how
Z-Levels are arranged. It is extremely ill-advised to ever use the location of a Z-Level
to assign traits to it or use it in coding. Use Z-Traits (ZTRAITs) for these.

If you want to start toying around with Z-Levels, do not take these words for fact.
Always compile, always use that verb, and always make sure that it works for what you want to do.
*/

// helpers for modifying jobs, used in various job_changes.dm files

#define MAP_CURRENT_VERSION 1

#define SPACERUIN_MAP_EDGE_PAD 15

/// Distance from edge to move to another z-level
#define TRANSITIONEDGE 7

// Maploader bounds indices
/// The maploader index for the maps minimum x
#define MAP_MINX 1
/// The maploader index for the maps minimum y
#define MAP_MINY 2
/// The maploader index for the maps minimum z
#define MAP_MINZ 3
/// The maploader index for the maps maximum x
#define MAP_MAXX 4
/// The maploader index for the maps maximum y
#define MAP_MAXY 5
/// The maploader index for the maps maximum z
#define MAP_MAXZ 6

/// Path for the next_map.json file, if someone, for some messed up reason, wants to change it.
#define PATH_TO_NEXT_MAP_JSON "data/next_map.json"

/// List of directories we can load map .json files from
#define MAP_DIRECTORY_MAPS "_maps"
#define MAP_DIRECTORY_DATA "data"
#define MAP_DIRECTORY_WHITELIST list(MAP_DIRECTORY_MAPS,MAP_DIRECTORY_DATA)

/// Special map path value for custom adminloaded stations.
#define CUSTOM_MAP_PATH "custom"

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_REEBE "Reebe"
#define ZTRAIT_PROCEDURAL_MAINTS "Random Maints"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
#define ZTRAIT_SPACE_RUINS "Space Ruins"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"
#define ZTRAIT_ICE_RUINS "Ice Ruins"
#define ZTRAIT_ICE_RUINS_UNDERGROUND "Ice Ruins Underground"
#define ZTRAIT_ISOLATED_RUINS "Isolated Ruins" //Placing ruins on z levels with this trait will use turf reservation instead of usual placement.

// boolean - weather types that occur on the level
#define ZTRAIT_SNOWSTORM "Weather_Snowstorm"
#define ZTRAIT_ASHSTORM "Weather_Ashstorm"
#define ZTRAIT_ACIDRAIN "Weather_Acidrain"
#define ZTRAIT_VOIDSTORM "Weather_Voidstorm"

/// boolean - does this z prevent ghosts from observing it
#define ZTRAIT_SECRET "Secret"

/// boolean - does this z prevent phasing
#define ZTRAIT_NOPHASE "No Phase"

/// boolean - does this z prevent xray/meson/thermal vision
#define ZTRAIT_NOXRAY "No X-Ray"

// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

// Whether this z level is linked up/down. Bool.
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
    // UNAFFECTED if absent - no space transitions
    #define UNAFFECTED null
    // SELFLOOPING - space transitions always self-loop
    #define SELFLOOPING "Self"
    // CROSSLINKED - mixed in with the cross-linked space pool
    #define CROSSLINKED "Cross"

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

///boolean - does this z disable parallax?
#define ZTRAIT_NOPARALLAX "No Parallax"

// default trait definitions, used by SSmapping
///Z level traits for CentCom
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_NOPHASE = TRUE)
///Z level traits for Space Station 13
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE)
///Z level traits for Deep Space
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE)
///Z level traits for Lavaland
#define ZTRAITS_LAVALAND list(\
    ZTRAIT_MINING = TRUE, \
	ZTRAIT_NOPARALLAX = TRUE, \
    ZTRAIT_ASHSTORM = TRUE, \
    ZTRAIT_LAVA_RUINS = TRUE, \
    ZTRAIT_BOMBCAP_MULTIPLIER = 2.5, \
    ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)

#define ZTRAITS_REEBE list(ZTRAIT_REEBE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 0.60)

#define ZTRAITS_BACKROOM_MAINTS list(\
	ZTRAIT_PROCEDURAL_MAINTS = TRUE, \
	ZTRAIT_LINKAGE = SELFLOOPING, \
	ZTRAIT_GRAVITY = TRUE, \
	ZTRAIT_NOPHASE = TRUE, \
	ZTRAIT_NOXRAY = TRUE, \
    ZTRAIT_BOMBCAP_MULTIPLIER = 0.5, \
    ZTRAIT_BASETURF = /turf/open/floor/plating/backrooms)

///Z level traits for Away Missions
#define ZTRAITS_AWAY list(ZTRAIT_AWAY = TRUE)
///Z level traits for Secret Away Missions
#define ZTRAITS_AWAY_SECRET list(ZTRAIT_AWAY = TRUE, ZTRAIT_SECRET = TRUE, ZTRAIT_NOPHASE = TRUE)

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
    DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)

// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4
#define CAMERA_LOCK_REEBE 8

//Reserved/Transit turf type
#define RESERVED_TURF_TYPE /turf/open/space/basic			//What the turf is when not being used

//Ruin Generation

#define PLACEMENT_TRIES 100 //How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)

#define PLACE_DEFAULT "random"
///On same z level as original ruin
#define PLACE_SAME_Z "same"
///On space ruin z level(s)
#define PLACE_SPACE_RUIN "space"
///On z levl below - centered on same tile
#define PLACE_BELOW "below"
///On lavaland ruin z levels(s)
#define PLACE_LAVA_RUIN "lavaland"
#define PLACE_ICE_RUIN "icesurface"
#define PLACE_ICE_UNDERGROUND_RUIN "iceunderground"

///Map generation defines
#define DEFAULT_SPACE_RUIN_LEVELS 7
#define DEFAULT_SPACE_EMPTY_LEVELS 1

/// A map key that corresponds to being one exclusively for Space.
#define SPACE_KEY "space"

// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

/// Checks the job changes in the map config for the passed change key.
#define CHECK_MAP_JOB_CHANGE(job, change) SSmapping.config.job_changes?[job]?[change]
