
// Legacy preference toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define SOUND_ADMINHELP				(1<<0)
#define SOUND_MIDI					(1<<1)
#define SOUND_AMBIENCE				(1<<2)
#define SOUND_LOBBY					(1<<3)
#define MEMBER_PUBLIC				(1<<4)
#define INTENT_STYLE				(1<<5)
#define MIDROUND_ANTAG				(1<<6)
#define SOUND_INSTRUMENTS			(1<<7)
#define SOUND_SHIP_AMBIENCE			(1<<8)
#define SOUND_PRAYERS				(1<<9)
#define ANNOUNCE_LOGIN				(1<<10)
#define SOUND_ANNOUNCEMENTS			(1<<11)
#define DISABLE_DEATHRATTLE			(1<<12)
#define DISABLE_ARRIVALRATTLE		(1<<13)
#define COMBOHUD_LIGHTING			(1<<14)
#define SOUND_JUKEBOX				(1<<15)

#define DEADMIN_ALWAYS				(1<<16)
#define DEADMIN_ANTAGONIST			(1<<17)
#define DEADMIN_POSITION_HEAD		(1<<18)
#define DEADMIN_POSITION_SECURITY	(1<<19)
#define DEADMIN_POSITION_SILICON	(1<<20)
#define DEADMIN_POSITION_CRITICAL	(1<<21)

#define SOUND_VOX					(1<<22)
#define SOUND_ALT					(1<<23)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MEMBER_PUBLIC|INTENT_STYLE|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|SOUND_JUKEBOX|SOUND_VOX|SOUND_ALT)

//Extra Preferences
#define SPLIT_ADMIN_TABS 			(1<<0)
#define FAST_MC_REFRESH				(1<<1)

#define TOGGLES_DEFAULT_EXTRA (FAST_MC_REFRESH)

//Chat toggles
#define CHAT_OOC (1<<0)
#define CHAT_DEAD (1<<1)
#define CHAT_GHOSTEARS (1<<2)
#define CHAT_GHOSTSIGHT (1<<3)
#define CHAT_PRAYER (1<<4)
#define CHAT_RADIO (1<<5)
#define CHAT_PULLR (1<<6)
#define CHAT_GHOSTWHISPER (1<<7)
#define CHAT_GHOSTPDA (1<<8)
#define CHAT_GHOSTRADIO (1<<9)
#define CHAT_BANKCARD  (1<<10)
#define CHAT_LOOC (1<<11)
#define GHOST_CKEY (1<<12)
#define CHAT_TYPING_INDICATOR (1<<13)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD|CHAT_LOOC|GHOST_CKEY|CHAT_TYPING_INDICATOR)

#define PARALLAX_INSANE "Insane"
#define PARALLAX_HIGH "High"
#define PARALLAX_MED "Medium"
#define PARALLAX_LOW "Low"
#define PARALLAX_DISABLE "Disabled"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_RANDOM "Random"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"
#define SEC_DEPT_SERVICE "Service"

#define ENG_DEPT_NONE "None"
#define ENG_DEPT_RANDOM "Random"
#define ENG_DEPT_MEDICAL "Medical"
#define ENG_DEPT_SCIENCE "Science"
#define ENG_DEPT_SUPPLY "Supply"
#define ENG_DEPT_SERVICE "Service"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING			"Living"
#define EXP_TYPE_CREW			"Crew"
#define EXP_TYPE_COMMAND		"Command"
#define EXP_TYPE_ENGINEERING	"Engineering"
#define EXP_TYPE_MEDICAL		"Medical"
#define EXP_TYPE_SCIENCE		"Science"
#define EXP_TYPE_SUPPLY			"Supply"
#define EXP_TYPE_SECURITY		"Security"
#define EXP_TYPE_SILICON		"Silicon"
#define EXP_TYPE_SERVICE		"Service"
#define EXP_TYPE_ANTAG			"Antag"
#define EXP_TYPE_SPECIAL		"Special"
#define EXP_TYPE_GHOST			"Ghost"
#define EXP_TYPE_ADMIN			"Admin"
#define EXP_TYPE_MENTOR			"Mentor"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3


//recommened client FPS
#define RECOMMENDED_FPS 100


// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_SPECIES (1<<0)
#define RANDOMIZE_NAME (1<<1)


//randomised elements
#define RANDOM_ANTAG_ONLY 1
#define RANDOM_DISABLED 2
#define RANDOM_ENABLED 3


// Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_PLAYER "player"

// Values for /datum/preferences/current_tab
/// Open the character preference window
#define PREFERENCE_TAB_CHARACTER_PREFERENCES 0

/// Open the game preferences window
#define PREFERENCE_TAB_GAME_PREFERENCES 1

/// Open the keybindings window
#define PREFERENCE_TAB_KEYBINDINGS 2

/// These will be shown in the character sidebar, but at the bottom.
#define PREFERENCE_CATEGORY_FEATURES "features"

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING "clothing"

/// Preferences that will be put into the 3rd list, and are not contextual.
#define PREFERENCE_CATEGORY_NON_CONTEXTUAL "non_contextual"

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"

/// These will show in the list to the right of the character preview.
#define PREFERENCE_CATEGORY_SECONDARY_FEATURES "secondary_features"

/// These are preferences that are supplementary for main features,
/// such as hair color being affixed to hair.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"
