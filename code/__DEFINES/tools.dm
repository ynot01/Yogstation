// Tool types
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WIRING			"wiring"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
#define TOOL_HATCHET		"hatchet"

#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
#define TOOL_BONESET		"bone setter"

#define MECHANICAL_TOOLS list(TOOL_CROWBAR, TOOL_MULTITOOL, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH, TOOL_WELDER, TOOL_ANALYZER)
#define MEDICAL_TOOLS list(TOOL_RETRACTOR, TOOL_HEMOSTAT, TOOL_CAUTERY, TOOL_DRILL, TOOL_SCALPEL, TOOL_SAW, TOOL_BONESET)

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20

// tool_act chain flags

/// When a tooltype_act proc is successful
#define TOOL_ACT_TOOLTYPE_SUCCESS (1<<0)
/// When [COMSIG_ATOM_TOOL_ACT] blocks the act
#define TOOL_ACT_SIGNAL_BLOCKING (1<<1)

/// When [TOOL_ACT_TOOLTYPE_SUCCESS] or [TOOL_ACT_SIGNAL_BLOCKING] are set
#define TOOL_ACT_MELEE_CHAIN_BLOCKING (TOOL_ACT_TOOLTYPE_SUCCESS | TOOL_ACT_SIGNAL_BLOCKING)
