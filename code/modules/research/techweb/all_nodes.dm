//Current rate: 135000 research points in 90 minutes

//Base Nodes
/datum/techweb_node/base
	id = "base"
	starting_node = TRUE
	display_name = "Basic Research Technology"
	description = "NT default research technologies."
	// Default research tech, prevents bricking
	design_ids = list("basic_matter_bin", "basic_cell", "basic_scanning", "basic_capacitor", "basic_micro_laser", "micro_mani", "desttagger", "handlabel", "packagewrap",
	"destructive_analyzer", "circuit_imprinter", "rack_creator", "experimentor", "rdconsole", "design_disk", "tech_disk", "rdserver", "rdservercontrol", "mechfab", "paystand", "ticket_machine", "ticket_remote", "light_tube", "light_bulb",
	"space_heater", "beaker", "large_beaker", "vial", "large_vial", "bucket", "fork", "tray","plate", "bowl", "mixing_bowl", "drinking_glass", "shot_glass", "shaker", "xlarge_beaker", "sec_rshot", "sec_beanbag_slug", "sec_bshot", "sec_slug", "sec_Islug", "sec_Brslug", "sec_38", "apc_control", "power control", "airlock_board", "firelock_board", "airalarm_electronics", "firealarm_electronics", "blastdoorcontroller", "aac_electronics", "mousetrap",
	"rglass","plasteel","plastitanium","plasmaglass","plasmareinforcedglass","titaniumglass","plastitaniumglass","wallframe/flasher", "rsf", "oven_tray", "bounced_radio", "signaler", "intercom_frame", "infrared_emitter", "health_sensor", "timer", "voice_analyser", "camera_assembly", "newscaster_frame", "prox_sensor", "flashlight", "extinguisher", "pocketfireextinguisher")

/datum/techweb_node/mmi
	id = "mmi"
	starting_node = TRUE
	display_name = "Man Machine Interface"
	description = "A slightly Frankensteinian device that allows human brains to interface natively with software APIs."
	design_ids = list("mmi")

/datum/techweb_node/cyborg
	id = "cyborg"
	starting_node = TRUE
	display_name = "Cyborg Construction"
	description = "Sapient robots with preloaded tool modules and programmable laws."
	design_ids = list("robocontrol", "sflash", "borg_suit", "borg_head", "borg_chest", "borg_r_arm", "borg_l_arm", "borg_r_leg", "borg_l_leg", "cyborgrecharger", "borg_upgrade_restart", "borg_upgrade_rename")

/datum/techweb_node/mech
	id = "mecha"
	starting_node = TRUE
	display_name = "Mechanical Exosuits"
	description = "Mechanized exosuits that are several magnitudes stronger and more powerful than the average human."
	design_ids = list("mecha_tracking", "mechacontrol", "mechapower", "mech_recharger", "ripley_chassis", "firefighter_chassis", "ripley_torso", "ripley_left_arm", "ripley_right_arm", "ripley_left_leg", "ripley_right_leg",
	"ripley_main", "ripley_peri", "ripleyupgrade", "mech_hydraulic_clamp")

/datum/techweb_node/mech_tools
	id = "mech_tools"
	starting_node = TRUE
	display_name = "Basic Exosuit Equipment"
	description = "Various tools fit for basic mech units"
	design_ids = list("mech_drill", "mech_mscanner", "mech_extinguisher", "mech_cable_layer")

/datum/techweb_node/clarke
	id = "mecha_clarke"
	display_name = "EXOSUIT: Clarke"
	description = "Clarke exosuit designs"
	prereq_ids = list("engineering")
	design_ids = list("clarke_chassis", "clarke_torso", "clarke_head", "clarke_left_arm", "clarke_right_arm", "clarke_main", "clarke_peri")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/basic_tools
	id = "basic_tools"
	starting_node = TRUE
	display_name = "Basic Tools"
	description = "Basic mechanical, electronic, surgical and botanical tools."
	design_ids = list("screwdriver", "wrench", "wirecutters", "crowbar", "multitool", "welding_tool", "tscanner", "analyzer", "cable_coil", "pipe_painter", "airlock_painter", "scalpel", "circular_saw", "bonesetter", "surgicaldrill", "retractor", "cautery", "hemostat", "syringe", "cultivator", "plant_analyzer", "shovel", "spade", "hatchet",  "mop", "decal_painter", "cable_coil", "rpd", "analyzer", "tscanner", "large_welding_tool", "geigercounter")

/////////////////////////Biotech/////////////////////////
/datum/techweb_node/biotech
	id = "biotech"
	display_name = "Biological Technology"
	description = "What makes us tick."	//the MC, silly!
	prereq_ids = list("base")
	design_ids = list("chem_heater", "chem_master", "chem_dispenser", "sleeper", "pandemic", "defibrillator", "defibmount", "surgical_mat", "operating", "soda_dispenser", "beer_dispenser", "healthanalyzer", "medspray", "genescanner", "rollerbed")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_biotech
	id = "adv_biotech"
	display_name = "Advanced Biotechnology"
	description = "Advanced Biotechnology"
	prereq_ids = list("biotech")
	design_ids = list("hypospray", "piercesyringe", "hypospraypierceupg", "hyposprayspeedupg", "pinpointer_crew", "smoke_machine", "plasmarefiller", "limbgrower", "meta_beaker", "healthanalyzer_advanced", "harvester", "holobarrier_med", "detective_scanner", "detective_scanner_advanced" , "defibrillator_compact", "vialbox")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/xenoorgan_biotech
	id = "xenoorgan_bio"
	display_name = "Xeno-organ Biology"
	description = "Plasmaman, Ethereals, Lizardpeople... What makes our non-human crewmembers tick?"
	prereq_ids = list("adv_biotech")
	design_ids = list("limbdesign_felinid", "limbdesign_lizard", "limbdesign_plasmaman", "limbdesign_ethereal", "limbdesign_polysmorph")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bio_process
	id = "bio_process"
	display_name = "Biological Processing"
	description = "From slimes to kitchens."
	prereq_ids = list("biotech")
	design_ids = list("smartfridge", "gibber", "deepfryer", "monkey_recycler", "processor", "microwave", "reagentgrinder", "dish_drive", "fat_sucker","griddle", "oven")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/xenology
	id = "xenology"
	display_name = "Basic Xenology"
	description = "Experimental research into replicating organs from the exotic species known commonly as \"xenos\""
	prereq_ids = list("cyber_organs_upgraded", "exp_surgery")
	design_ids = list("synthetic_plasmavessel")
	boost_item_paths = list(/obj/item/weed_extract, /obj/item/xenos_claw, /obj/item/stack/sheet/xenochitin, /obj/item/organ/alien, /obj/item/organ/brain/alien)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	hidden = TRUE

/datum/techweb_node/xenology/New() //this is faster and more readable than putting them all in
	. = ..()
	boost_item_paths |= typesof(/obj/item/organ/alien)

/////////////////////////Advanced Surgery/////////////////////////
/datum/techweb_node/imp_wt_surgery
	id = "imp_wt_surgery"
	display_name = "Improved Wound-Tending Surgery"
	description = "Who would have known being more gentle with a hemostat decreases patient pain?"
	prereq_ids = list("biotech")
	design_ids = list("surgery_heal_brute_upgrade","surgery_heal_burn_upgrade")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)


/datum/techweb_node/adv_surgery
	id = "adv_surgery"
	display_name = "Advanced Surgery"
	description = "When simple medicine doesn't cut it."
	prereq_ids = list("imp_wt_surgery")
	design_ids = list("surgery_lobotomy", "surgery_heal_brute_upgrade_femto","surgery_heal_burn_upgrade_femto","surgery_heal_combo", "surgery_revival", "surgery_adv_dissection")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/exp_surgery
	id = "exp_surgery"
	display_name = "Experimental Surgery"
	description = "When evolution isn't fast enough."
	prereq_ids = list("adv_surgery")
	design_ids = list("surgery_pacify","surgery_vein_thread","surgery_muscled_veins","surgery_nerve_splice","surgery_nerve_ground","surgery_ligament_hook","surgery_ligament_reinforcement","surgery_viral_bond", "surgery_heal_combo_upgrade", "surgery_dna_recovery", "surgery_exp_dissection")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/alien_surgery
	id = "alien_surgery"
	display_name = "Alien Surgery"
	description = "Abductors did nothing wrong."
	prereq_ids = list("exp_surgery", "alientech")
	design_ids = list("surgery_zombie","surgery_heal_combo_upgrade_femto", "surgery_brainwashing", "surgery_ext_dissection")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7000)

/////////////////////////data theory tech/////////////////////////
/datum/techweb_node/datatheory //Computer science
	id = "datatheory"
	display_name = "Data Theory"
	description = "Big Data, in space!"
	prereq_ids = list("base")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)


/////////////////////////engineering tech/////////////////////////
/datum/techweb_node/engineering
	id = "engineering"
	display_name = "Industrial Engineering"
	description = "A refresher course on modern engineering technology."
	prereq_ids = list("base")
	design_ids = list("solarcontrol", "recharger", "powermonitor", "rped", "pacman", "adv_capacitor", "adv_scanning", "emitter", "high_cell", "adv_matter_bin", "scanner_gate",
	"atmosalerts", "atmos_control", "recycler", "autolathe", "high_micro_laser", "nano_mani", "mesons", "thermomachine", "rad_collector", "tesla_coil", "grounding_rod",
	"cell_charger", "stack_console", "stack_machine", "conveyor_belt", "conveyor_switch",
	"oxygen_tank", "plasma_tank", "emergency_oxygen", "emergency_oxygen_engi", "plasmaman_tank_belt", "ipc_coolant_tank", "electrolyzer", "floorigniter", "crystallizer", "suit_storage_unit")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)

/datum/techweb_node/adv_engi
	id = "adv_engi"
	display_name = "Advanced Engineering"
	description = "Pushing the boundaries of physics, one chainsaw-fist at a time."
	prereq_ids = list("engineering", "emp_basic")
	design_ids = list("engine_goggles", "magboots", "forcefield_projector", "weldingmask", "decontamination_unit", "rangedanalyzer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/anomaly
	id = "anomaly_research"
	display_name = "Anomaly Research"
	description = "Unlock the potential of the mysterious anomalies that appear on station."
	prereq_ids = list("adv_engi", "practical_bluespace")
	design_ids = list("reactive_armor", "anomaly_neutralizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/high_efficiency
	id = "high_efficiency"
	display_name = "High Efficiency Parts"
	description = "Finely-tooled manufacturing techniques allowing for picometer-perfect precision levels."
	prereq_ids = list("engineering", "datatheory")
	design_ids = list("pico_mani", "super_matter_bin")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)

/datum/techweb_node/adv_power
	id = "adv_power"
	display_name = "Advanced Power Manipulation"
	description = "How to get more zap."
	prereq_ids = list("engineering")
	design_ids = list("smes", "super_cell", "hyper_cell", "super_capacitor", "superpacman", "mrspacman", "power_turbine", "power_turbine_console", "power_compressor", "circulator", "teg")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////Bluespace tech/////////////////////////
/datum/techweb_node/bluespace_basic //Bluespace-memery
	id = "bluespace_basic"
	display_name = "Basic Bluespace Theory"
	description = "Basic studies into the mysterious alternate dimension known as bluespace."
	prereq_ids = list("base")
	design_ids = list("beacon", "telesci_gps", "bluespace_crystal")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bluespace_travel
	id = "bluespace_travel"
	display_name = "Bluespace Travel"
	description = "Application of Bluespace for static teleportation technology."
	prereq_ids = list("practical_bluespace")
	design_ids = list("tele_station", "tele_hub", "teleconsole", "quantumpad", "launchpad", "launchpad_console", "bluespace_pod", "bluespace_pipe")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/micro_bluespace
	id = "micro_bluespace"
	display_name = "Miniaturized Bluespace Research"
	description = "Extreme reduction in space required for bluespace engines, leading to portable bluespace technology."
	prereq_ids = list("bluespace_travel", "practical_bluespace", "high_efficiency")
	design_ids = list("bluespace_matter_bin", "femto_mani", "bluespacebodybag", "triphasic_scanning", "quantum_keycard", "wormholeprojector")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/techweb_node/advanced_bluespace
	id = "bluespace_storage"
	display_name = "Advanced Bluespace Storage"
	description = "With the use of bluespace we can create even more advanced storage devices than we could have ever done"
	prereq_ids = list("micro_bluespace", "janitor")
	design_ids = list("bag_holding")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/practical_bluespace
	id = "practical_bluespace"
	display_name = "Applied Bluespace Research"
	description = "Using bluespace to make things faster and better."
	prereq_ids = list("bluespace_basic", "engineering")
	design_ids = list("bs_rped","minerbag_holding", "bluespacebeaker", "bluespacevial", "bluespacesyringe", "phasic_scanning", "roastingstick", "ore_silo", "xenobioconsole")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/bluespace_power
	id = "bluespace_power"
	display_name = "Bluespace Power Technology"
	description = "Even more powerful.. power!"
	prereq_ids = list("adv_power", "practical_bluespace")
	design_ids = list("bluespace_cell", "quadratic_capacitor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/unregulated_bluespace
	id = "unregulated_bluespace"
	display_name = "Unregulated Bluespace Research"
	description = "Bluespace technology using unstable or unbalanced procedures, prone to damaging the fabric of bluespace. Outlawed by galactic conventions."
	prereq_ids = list("bluespace_travel", "syndicate_basic")
	design_ids = list("desynchronizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)


/////////////////////////plasma tech/////////////////////////
/datum/techweb_node/basic_plasma
	id = "basic_plasma"
	display_name = "Basic Plasma Research"
	description = "Research into the mysterious and dangerous substance, plasma."
	prereq_ids = list("engineering")
	design_ids = list("mech_generator")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_plasma
	id = "adv_plasma"
	display_name = "Advanced Plasma Research"
	description = "Research on how to fully exploit the power of plasma."
	prereq_ids = list("basic_plasma")
	design_ids = list("mech_plasma_cutter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////shuttle tech/////////////////////////
/datum/techweb_node/basic_shuttle_tech
	id = "basic_shuttle"
	display_name = "Basic Shuttle Research"
	description = "Research the technology required to create and use basic shuttles."
	prereq_ids = list("bluespace_travel", "adv_engi")
	design_ids = list("shuttle_creator", "engine_plasma", "engine_heater", "shuttle_control", "shuttle_docker", "engine_ion", "engine_capacitor_bank")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/techweb_node/shuttle_route_upgrade
	id = "shuttle_route_upgrade"
	display_name = "Route Optimisation Upgrade"
	description = "Research into bluespace tunnelling, allowing us to reduce flight times by up to 20%!"
	prereq_ids = list("basic_shuttle")
	design_ids = list("disk_shuttle_route")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/shuttle_route_upgrade_hyper
	id = "shuttle_route_upgrade_hyper"
	display_name = "Hyperlane Optimisation Upgrade"
	description = "Research into bluespace hyperlane, allowing us to reduce flight times by up to 40%!"
	prereq_ids = list("shuttle_route_upgrade", "micro_bluespace")
	design_ids = list("disk_shuttle_route_hyper")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/shuttle_route_upgrade_void
	id = "shuttle_route_upgrade_void"
	display_name = "Nullspace Breaching Upgrade"
	description = "Research into voidspace tunnelling, allowing us to significantly reduce flight times."
	prereq_ids = list("shuttle_route_upgrade_hyper", "alientech")
	design_ids = list("disk_shuttle_route_void", "engine_void")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)

/////////////////////////robotics tech/////////////////////////
/datum/techweb_node/robotics
	id = "robotics"
	display_name = "Basic Robotics Research"
	description = "Programmable machines that make our lives lazier."
	prereq_ids = list("base")
	design_ids = list("paicard")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_robotics
	id = "adv_robotics"
	display_name = "Advanced Robotics Research"
	description = "It can even do the dishes!"
	prereq_ids = list("robotics")
	design_ids = list("borg_upgrade_diamonddrill", "borg_upgrade_trashofholding", "borg_upgrade_advancedmop")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/neural_programming
	id = "neural_programming"
	display_name = "Neural Programming"
	description = "Study into networks of processing units that mimic our brains."
	prereq_ids = list("biotech", "datatheory")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/posibrain
	id = "posibrain"
	display_name = "Positronic Brain"
	description = "Applied usage of neural technology allowing for autonomous AI units based on special metallic cubes with conductive and processing circuits."
	prereq_ids = list("neural_programming")
	design_ids = list("mmi_posi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cyborg_upg_util
	id = "cyborg_upg_util"
	display_name = "Cyborg Upgrades: Utility"
	description = "Utility upgrades for cyborgs."
	prereq_ids = list("engineering")
	design_ids = list("borg_upgrade_holding", "borg_upgrade_lavaproof", "borg_upgrade_thrusters", "borg_upgrade_selfrepair", "borg_upgrade_expand", "borg_upgrade_rped", "borg_upgrade_language")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/cyborg_upg_med
	id = "cyborg_upg_med"
	display_name = "Cyborg Upgrades: Medical"
	description = "Medical upgrades for cyborgs."
	prereq_ids = list("adv_biotech")
	design_ids = list("borg_upgrade_defibrillator", "borg_upgrade_piercinghypospray", "borg_upgrade_expandedsynthesiser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/cyborg_upg_surgkit
	id = "cyborg_upg_surgkit"
	display_name = "Cyborg Upgrade: Medical Advanced Medical Tools"
	description = "Advanced Surgical Kit and Advanced Health Scanner upgrade design for medical cyborgs."
	prereq_ids = list("cyborg_upg_med", "exp_tools")
	design_ids = list("borg_upgrade_surgerykit", "borg_upgrade_analyzer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/ai
	id = "ai"
	display_name = "Artificial Intelligence"
	description = "AI unit research."
	prereq_ids = list("base")
	design_ids = list("server_cabinet", "ai_data_core", "ai_core_display", "ai_server_overview", "ram1", "basic_ai_cpu", "ai_resource_distribution", "aifixer", "safeguard_module", "onehuman_module", "protectstation_module", "quarantine_module", "oxygen_module", "freeform_module", "reset_module", "purge_module", "remove_module", "freeformcore_module", "asimov_module", "crewsimov_module", "paladin_module", "tyrant_module", "overlord_module", "ceo_module", "cowboy_module", "mother_module", "silicop_module", "construction_module", "metaexperiment_module", "researcher_module", "siliconcollective_module", "spotless_module", "clown_module", "chapai_module", "druid_module", "detective_module", "reporter_module", "default_module", "borg_ai_control", "mecha_tracking_ai_control", "intellicard")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 1000)

/////////////////////////EMP tech/////////////////////////
/datum/techweb_node/emp_basic //EMP tech for some reason
	id = "emp_basic"
	display_name = "Electromagnetic Theory"
	description = "Study into usage of frequencies in the electromagnetic spectrum."
	prereq_ids = list("base")
	design_ids = list("holosign", "holosignsec", "holosignengi", "holosignatmos", "inducer", "tray_goggles", "holopad")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/emp_adv
	id = "emp_adv"
	display_name = "Advanced Electromagnetic Theory"
	description = "Determining whether reversing the polarity will actually help in a given situation."
	prereq_ids = list("emp_basic")
	design_ids = list("ultra_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/datum/techweb_node/emp_super
	id = "emp_super"
	display_name = "Quantum Electromagnetic Technology"	//bs
	description = "Even better electromagnetic technology."
	prereq_ids = list("emp_adv")
	design_ids = list("quadultra_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/////////////////////////Clown tech/////////////////////////
/datum/techweb_node/clown
	id = "clown"
	display_name = "Clown Technology"
	description = "Honk?!"
	prereq_ids = list("base")
	design_ids = list("air_horn", "honker_main", "honker_peri", "honker_targ", "honk_chassis", "honk_head", "honk_torso", "honk_left_arm", "honk_right_arm",
	"honk_left_leg", "honk_right_leg", "mech_banana_mortar", "mech_mousetrap_mortar", "mech_honker", "mech_punching_face", "implant_trombone", "borg_transform_clown", "clown_mine", "clownshot", "clownshoesimplant",
	"holosignclown")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

////////////////////////Computer tech////////////////////////
/datum/techweb_node/comptech
	id = "comptech"
	display_name = "Computer Consoles"
	description = "Computers and how they work."
	prereq_ids = list("datatheory")
	design_ids = list("cargo", "cargorequest", "libraryconsole", "mining", "crewconsole", "rdcamera", "comconsole", "idcardconsole", "seccamera")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/computer_hardware_basic				//Modular computers are shitty and nearly useless so until someone makes them actually useful this can be easy to get.
	id = "computer_hardware_basic"
	display_name = "Computer Hardware"
	description = "How computer hardware are made."
	prereq_ids = list("comptech")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)  //they are really shitty
	design_ids = list("hdd_basic", "hdd_advanced", "hdd_super", "hdd_cluster", "ssd_small", "ssd_micro", "netcard_basic", "netcard_advanced", "netcard_wired",
	"portadrive_basic", "portadrive_advanced", "portadrive_super", "cardslot", "secondcardslot", "aislot", "miniprinter", "APClink", "bat_control", "bat_normal", "bat_advanced",
	"bat_super", "bat_micro", "bat_nano", "cpu_normal", "pcpu_normal", "cpu_small", "pcpu_small", "sensorpackage")

/datum/techweb_node/computer_board_gaming
	id = "computer_board_gaming"
	display_name = "Arcade Games"
	description = "For the slackers on the station."
	prereq_ids = list("comptech")
	design_ids = list("arcade_battle", "arcade_orion", "slotmachine", "minesweeper")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/comp_recordkeeping
	id = "comp_recordkeeping"
	display_name = "Computerized Recordkeeping"
	description = "Organized record databases and how they're used."
	prereq_ids = list("comptech")
	design_ids = list("secdata", "med_data", "prisonmanage", "vendor", "automated_announcement")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/telecomms
	id = "telecomms"
	display_name = "Telecommunications Technology"
	description = "Subspace transmission technology for near-instant communications devices."
	prereq_ids = list("comptech", "bluespace_basic")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	design_ids = list("s-receiver", "s-bus", "s-broadcaster", "s-processor", "s-hub", "s-server", "s-relay", "comm_monitor", "comm_server",
	"s-ansible", "s-filter", "s-amplifier", "ntnet_relay", "s-treatment", "s-analyzer", "s-crystal", "s-transmitter", "s-traffic", "s-messaging")

/datum/techweb_node/integrated_HUDs
	id = "integrated_HUDs"
	display_name = "Integrated HUDs"
	description = "The usefulness of computerized records, projected straight onto your eyepiece!"
	prereq_ids = list("comp_recordkeeping", "emp_basic")
	design_ids = list("health_hud", "security_hud", "diagnostic_hud", "scigoggles", "health_hud_meson")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/NVGtech
	id = "NVGtech"
	display_name = "Night Vision Technology"
	description = "Allows seeing in the dark without actual light!"
	prereq_ids = list("integrated_HUDs", "adv_engi", "emp_adv")
	design_ids = list("health_hud_night", "security_hud_night", "diagnostic_hud_night", "night_visision_goggles", "nvgmesons", "nightscigoggles")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

////////////////////////Medical////////////////////////
/datum/techweb_node/cloning
	id = "cloning"
	display_name = "Genetic Engineering"
	description = "We have the technology to make him."
	prereq_ids = list("biotech")
	design_ids = list("clonecontrol", "clonepod", "clonescanner", "scan_console", "cloning_disk")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cryotech
	id = "cryotech"
	display_name = "Cryostasis Technology"
	description = "Smart freezing of objects to preserve them!"
	prereq_ids = list("adv_engi", "biotech")
	design_ids = list("splitbeaker", "cryotube", "cryo_Grenade", "stasis", "holobed_projector")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)

/datum/techweb_node/subdermal_implants
	id = "subdermal_implants"
	display_name = "Subdermal Implants"
	description = "Electronic implants buried beneath the skin."
	prereq_ids = list("biotech")
	design_ids = list("implanter", "implantcase", "implant_chem", "implant_tracking", "locator", "pinpointer_tracker")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/cyber_organs
	id = "cyber_organs"
	display_name = "Cybernetic Organs"
	description = "We have the technology to rebuild him."
	prereq_ids = list("adv_biotech")
	design_ids = list("cybernetic_heart", "cybernetic_liver", "cybernetic_lungs", "cybernetic_stomach", "cybernetic_ears", "cybernetic_appendix")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/cyber_organs_upgraded
	id = "cyber_organs_upgraded"
	display_name = "Upgraded Cybernetic Organs"
	description = "We have the technology to upgrade him."
	prereq_ids = list("cyber_organs")
	design_ids = list("cybernetic_heart_u", "cybernetic_liver_u", "cybernetic_lungs_u", "cybernetic_stomach_u")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/ipc_organs
	id = "ipc_organs"
	display_name = "IPC Parts"
	description = "We have the technology to replace him."
	prereq_ids = list("cyber_organs","robotics")
	design_ids = list("robotic_liver", "robotic_eyes", "robotic_tongue", "robotic_stomach", "robotic_ears", "power_cord", "ipcrevive", "ipc_lungs", "blankipc")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1500)

/datum/techweb_node/cyber_implants
	id = "cyber_implants"
	display_name = "Cybernetic Implants"
	description = "Electronic implants that improve humans."
	prereq_ids = list("adv_biotech", "datatheory")
	design_ids = list("ci-nutriment", "ci-breather", "ci-gloweyes", "ci-meson", "ci-welding", "ci-medhud", "ci-sechud", "ci-scihud", "ci-diaghud")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_cyber_implants
	id = "adv_cyber_implants"
	display_name = "Advanced Cybernetic Implants"
	description = "Upgraded and more powerful cybernetic implants."
	prereq_ids = list("neural_programming", "cyber_implants","integrated_HUDs")
	design_ids = list("ci-toolset", "ci-surgery", "ci-reviver", "ci-nutrimentplus", "ci-magboots")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/combat_cyber_implants
	id = "combat_cyber_implants"
	display_name = "Combat Cybernetic Implants"
	description = "Military grade combat implants to improve performance."
	prereq_ids = list("adv_cyber_implants","weaponry","NVGtech","high_efficiency")
	design_ids = list("ci-thermals", "ci-antidrop", "ci-antistun", "ci-thrusters", "ci-jumpboots", "ci-wheelies")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/illegal_cyber_implants
	id = "illegal_cyber_implants"
	display_name = "Illegal Cybernetic Implants"
	description = "Nanotrasen would like to remind employees that use of unlicensed cybernetic implants violates multiple employee contract clauses."
	prereq_ids = list("combat_cyber_implants","syndicate_basic")
	design_ids = list("ci-xray", "ci-noslipwater")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

////////////////////////Tools////////////////////////

/datum/techweb_node/basic_mining
	id = "basic_mining"
	display_name = "Mining Technology"
	description = "Better than Efficiency V."
	prereq_ids = list("engineering", "basic_plasma")
	design_ids = list("drill", "superresonator", "triggermod", "damagemod", "cooldownmod", "rangemod", "ore_redemption", "mining_equipment_vendor", "cargoexpress", "plasmacutter", "mecha_kineticgun",)//e a r l y    g a  m e)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_mining
	id = "adv_mining"
	display_name = "Advanced Mining Technology"
	description = "Efficiency Level 127"	//dumb mc references
	prereq_ids = list("basic_mining", "adv_engi", "adv_power", "adv_plasma")
	design_ids = list("drill_diamond", "jackhammer", "hypermod", "plasmacutter_adv", "borg_upgrade_plasmacutter","miningcharge")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/magmite_mining
	id = "magmite_mining"
	display_name = "Magmite Technology"
	description = "Who needs a pickaxe when you have a nuke?"
	prereq_ids = list("adv_mining")
	design_ids = list("miningcharge_mega")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000)
	hidden = TRUE
	boost_item_paths = list(/obj/item/magmite,/obj/item/grenade/plastic/miningcharge/mega) //you can get mega mining charges from necropolis chests

/datum/techweb_node/camera_theory
	id = "cam_theory"
	display_name = "Camera Theory"
	description = "NT is watching you..."
	design_ids = list("minercam", "bodycam")
	prereq_ids = list("basic_mining","sec_basic")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/janitor
	id = "janitor"
	display_name = "Advanced Sanitation Technology"
	description = "Clean things better, faster, stronger, and harder!"
	prereq_ids = list("adv_engi")
	design_ids = list("advmop", "buffer", "blutrash", "light_replacer", "spraybottle", "beartrap")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/botany
	id = "botany"
	display_name = "Botanical Engineering"
	description = "Botanical tools"
	prereq_ids = list("adv_engi", "biotech")
	design_ids = list("diskplantgene", "portaseeder", "plantgenes", "flora_gun", "hydro_tray", "biogenerator", "seed_extractor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/exp_tools
	id = "exp_tools"
	display_name = "Experimental Tools"
	description = "Highly advanced tools."
	design_ids = list("exwelder", "jawsoflife", "handdrill", "laserscalpel", "mechanicalpinches", "searingtool", "tool_switcher", "tricorder")
	prereq_ids = list("adv_engi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/sec_basic
	id = "sec_basic"
	display_name = "Basic Security Equipment"
	description = "Standard equipment used by security."
	design_ids = list("seclite", "pepperspray", "bola_energy", "zipties", "evidencebag", "sflash", "handcuffs", "receiver", "simple_sight")
	prereq_ids = list("base")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/rcd_upgrade
	id = "rcd_upgrade"
	display_name = "RCD designs upgrade"
	description = "Unlocks new RCD designs."
	design_ids = list("rcd_upgrade_frames", "rcd_upgrade_simple_circuits", "rcd_upgrade_furnishing", "rcd_upgrade_conveyor")
	prereq_ids = list("adv_engi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_rcd_upgrade
	id = "adv_rcd_upgrade"
	display_name = "Advanced RCD designs upgrade"
	description = "Unlocks new RCD designs."
	design_ids = list("rcd_upgrade_silo_link")
	prereq_ids = list("rcd_upgrade", "bluespace_travel")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 25000)

/////////////////////////weaponry tech/////////////////////////

/datum/techweb_node/landmine
	id = "nonlethal_mines"
	display_name = "Nonlethal Landmine Technology"
	description = "Our weapons technicians could perhaps work out methods for the creation of nonlethal landmines for security teams."
	prereq_ids = list("sec_basic")
	design_ids = list("stunmine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/weaponry
	id = "weaponry"
	display_name = "Weapon Development Technology"
	description = "Our researchers have found new ways to weaponize just about everything now."
	prereq_ids = list("engineering", "sec_basic")
	design_ids = list("pin_testing", "tele_shield", "platingmki", "platingmkiii", "vert_grip", "laser_sight", "infra_sight")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/techweb_node/smartmine
	id = "smart_mines"
	display_name = "Smart Landmine Technology"
	description = "Using IFF technology, we could develop smartmines that do not trigger for those who are mindshielded."
	prereq_ids = list("weaponry", "nonlethal_mines", "engineering")
	design_ids = list("stunmine_adv")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_weaponry
	id = "adv_weaponry"
	display_name = "Advanced Weapon Development Technology"
	description = "Our weapons are breaking the rules of reality by now."
	prereq_ids = list("adv_engi", "weaponry")
	design_ids = list("borg_transform_security", "platingmkii", "platingmkiv", "holo_sight")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/techweb_node/advmine
	id = "adv_mines"
	display_name = "Advanced Landmine Technology"
	description = "We can further develop our smartmines to build some extremely capable designs."
	prereq_ids = list("weaponry", "smart_mines", "adv_engi")
	design_ids = list("stunmine_rapid", "stunmine_heavy")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/electric_weapons
	id = "electronic_weapons"
	display_name = "Electric Weapons"
	description = "Weapons using electric technology"
	prereq_ids = list("weaponry", "adv_power", "emp_basic")
	design_ids = list("stunrevolver", "ioncarbine")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/hardlight_weapons
	id = "hardlight weapons"
	display_name = "Hardlight Weaponry"
	description = "Weaponized forcefields!"
	prereq_ids = list("weaponry", "emp_super")
	design_ids = list("hardlightbow", "ntusp_conversion", "vib_blade")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/radioactive_weapons
	id = "radioactive_weapons"
	display_name = "Radioactive Weaponry"
	description = "Weapons using radioactive technology."
	prereq_ids = list("adv_engi", "adv_weaponry")
	design_ids = list("nuclear_gun", "xray_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/medical_weapons
	id = "medical_weapons"
	display_name = "Medical Weaponry"
	description = "Weapons using medical technology."
	prereq_ids = list("adv_biotech", "adv_weaponry","syndicate_basic")
	design_ids = list("syringegun", "dartsyringe","sec_dart")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/beam_weapons
	id = "beam_weapons"
	display_name = "Beam Weaponry"
	description = "Various basic beam weapons"
	prereq_ids = list("adv_weaponry")
	design_ids = list("temp_gun", "bouncer_egun")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_beam_weapons
	id = "adv_beam_weapons"
	display_name = "Advanced Beam Weaponry"
	description = "Various advanced beam weapons"
	prereq_ids = list("beam_weapons")
	design_ids = list("beamrifle")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/explosive_weapons
	id = "explosive_weapons"
	display_name = "Explosive & Pyrotechnical Weaponry"
	description = "If the light stuff just won't do it."
	prereq_ids = list("adv_weaponry")
	design_ids = list("large_Grenade", "pyro_Grenade", "adv_Grenade")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/ballistic_weapons
	id = "ballistic_weapons"
	display_name = "Ballistic Weaponry"
	description = "This isn't research.. This is reverse-engineering!"
	prereq_ids = list("weaponry")
	design_ids = list("mag_oldsmg", "mag_oldsmg_ap", "mag_oldsmg_ic", "mag_oldsmg_rubber")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/exotic_ammo
	id = "exotic_ammo"
	display_name = "Exotic Ammunition"
	description = "They won't know what hit em."
	prereq_ids = list("adv_weaponry")
	design_ids = list("c38_hotshot", "c38_iceblox", "c38_gutterpunch")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/gravity_gun
	id = "gravity_gun"
	display_name = "One-point Bluespace-gravitational Manipulator"
	description = "Fancy wording for gravity gun."
	prereq_ids = list("adv_weaponry", "bluespace_travel")
	design_ids = list("gravitygun", "mech_gravcatapult")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/exotic_ammo
	id = "experimental_ammo"
	display_name = "Experimental Ammunition"
	description = "We're hitting levels of power that shouldn't be possible."
	prereq_ids = list("exotic_ammo","ballistic_weapons")
	design_ids = list("techshotshell", "mag_oldsmg_kraken", "mag_oldsmg_snakebite")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

////////////////////////mech technology////////////////////////
/datum/techweb_node/adv_mecha
	id = "adv_mecha"
	display_name = "Advanced Exosuits"
	description = "For when you just aren't Gundam enough."
	prereq_ids = list("adv_robotics")
	design_ids = list("mech_repair_droid")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/odysseus
	id = "mecha_odysseus"
	display_name = "EXOSUIT: Odysseus"
	description = "Odysseus exosuit designs"
	prereq_ids = list("base")
	design_ids = list("odysseus_chassis", "odysseus_torso", "odysseus_head", "odysseus_left_arm", "odysseus_right_arm" ,"odysseus_left_leg", "odysseus_right_leg",
	"odysseus_main", "odysseus_peri")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/gygax
	id = "mech_gygax"
	display_name = "EXOSUIT: Gygax"
	description = "Gygax exosuit designs"
	prereq_ids = list("adv_mecha", "weaponry")
	design_ids = list("gygax_chassis", "gygax_torso", "gygax_head", "gygax_left_arm", "gygax_right_arm", "gygax_left_leg", "gygax_right_leg", "gygax_main",
	"gygax_peri", "gygax_targ", "gygax_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/durand
	id = "mech_durand"
	display_name = "EXOSUIT: Durand"
	description = "Durand exosuit designs"
	prereq_ids = list("adv_mecha", "adv_weaponry")
	design_ids = list("durand_chassis", "durand_torso", "durand_head", "durand_left_arm", "durand_right_arm", "durand_left_leg", "durand_right_leg", "durand_main",
	"durand_peri", "durand_targ", "durand_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/phazon
	id = "mecha_phazon"
	display_name = "EXOSUIT: Phazon"
	description = "Phazon exosuit designs"
	prereq_ids = list("adv_mecha", "weaponry" , "micro_bluespace")
	design_ids = list("phazon_chassis", "phazon_torso", "phazon_head", "phazon_left_arm", "phazon_right_arm", "phazon_left_leg", "phazon_right_leg", "phazon_main",
	"phazon_peri", "phazon_targ", "phazon_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/sidewinder
	id = "mech_sidewinder"
	display_name = "EXOSUIT: Sidewinder"
	description = "Sidewinder exosuit designs"
	prereq_ids = list("adv_weaponry", "mech_gygax")
	design_ids = list("sidewinder_chassis", "sidewinder_torso", "sidewinder_head", "sidewinder_left_arm", "sidewinder_right_arm", "sidewinder_left_leg", "sidewinder_right_leg", "sidewinder_main",
	"sidewinder_peri", "sidewinder_targ", "sidewinder_armor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_mecha_tools
	id = "adv_mecha_tools"
	display_name = "Advanced Exosuit Equipment"
	description = "Tools for high level mech suits"
	prereq_ids = list("adv_mecha")
	design_ids = list("mech_rcd")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/med_mech_tools
	id = "med_mech_tools"
	display_name = "Medical Exosuit Equipment"
	description = "Tools for high level mech suits"
	prereq_ids = list("adv_biotech")
	design_ids = list("mech_sleeper", "mech_syringe_gun", "mech_medi_beam")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_modules
	id = "adv_mecha_modules"
	display_name = "Simple Exosuit Modules"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha", "bluespace_power")
	design_ids = list("mech_energy_relay", "mech_ccw_armor", "mech_proj_armor", "mech_generator_nuclear")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_scattershot
	id = "mecha_tools"
	display_name = "Exosuit Weapon (LBX AC 10 \"Scattershot\")"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_scattershot", "mech_scattershot_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_carbine
	id = "mech_carbine"
	display_name = "Exosuit Weapon (FNX-99 \"Hades\" Carbine)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_carbine", "mech_carbine_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_ion
	id = "mmech_ion"
	display_name = "Exosuit Weapon (MKIV Ion Heavy Cannon)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("electronic_weapons", "emp_adv")
	design_ids = list("mech_ion")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_tesla
	id = "mech_tesla"
	display_name = "Exosuit Weapon (MKI Tesla Cannon)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("electronic_weapons", "adv_power")
	design_ids = list("mech_tesla")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_laser
	id = "mech_laser"
	display_name = "Exosuit Weapon (CH-PS \"Immolator\" Laser)"
	description = "A basic piece of mech weaponry"
	prereq_ids = list("beam_weapons")
	design_ids = list("mech_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_laser_heavy
	id = "mech_laser_heavy"
	display_name = "Exosuit Weapon (CH-LC \"Solaris\" Laser Cannon)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_beam_weapons")
	design_ids = list("mech_laser_heavy")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_xray
	id = "mech_xray"
	display_name = "Exosuit Weapon (CH-XC \"Transitum\" X-Ray Laser)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_beam_weapons")
	design_ids = list("mech_xray")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_disabler
	id = "mech_disabler"
	display_name =  "Exosuit Weapon (CH-DS \"Peacemaker\" Mounted Disabler)"
	description = "A basic piece of mech weaponry"
	prereq_ids = list("beam_weapons")
	design_ids = list("mech_disabler")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_grenade_launcher
	id = "mech_grenade_launcher"
	display_name = "Exosuit Weapon (SGL-6 Grenade Launcher)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("explosive_weapons")
	design_ids = list("mech_grenade_launcher", "mech_grenade_launcher_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_missile_rack
	id = "mech_missile_rack"
	display_name = "Exosuit Weapon (BRM-6 Missile Rack)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("explosive_weapons")
	design_ids = list("mech_missile_rack", "mech_missile_rack_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/clusterbang_launcher
	id = "clusterbang_launcher"
	display_name = "Exosuit Module (SOB-3 Clusterbang Launcher)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("explosive_weapons")
	design_ids = list("clusterbang_launcher", "clusterbang_launcher_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_teleporter
	id = "mech_teleporter"
	display_name = "Exosuit Module (Teleporter Module)"
	description = "An advanced piece of mech Equipment"
	prereq_ids = list("micro_bluespace")
	design_ids = list("mech_teleporter")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_wormhole_gen
	id = "mech_wormhole_gen"
	display_name = "Exosuit Module (Localized Wormhole Generator)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("bluespace_travel")
	design_ids = list("mech_wormhole_gen")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_lmg
	id = "mech_lmg"
	display_name = "Exosuit Weapon (\"Ultra AC 2\" LMG)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("ballistic_weapons")
	design_ids = list("mech_lmg", "mech_lmg_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_diamond_drill
	id = "mech_diamond_drill"
	display_name =  "Exosuit Diamond Drill"
	description = "A diamond drill fit for a large exosuit"
	prereq_ids = list("adv_mining")
	design_ids = list("mech_diamond_drill")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_rocket_fist
	id = "mech_rocket_fist"
	display_name = "Exosuit Weapon (DD-2 \"Atom Smasher\" Rocket Fist)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","weaponry")
	design_ids = list("mech_rocket_fist")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_shortsword
	id = "mech_shortsword"
	display_name = "Exosuit Weapon (GD6 \"Jaeger\" Shortsword)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","adv_weaponry")
	design_ids = list("mech_shortsword")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_katana
	id = "mech_katana"
	display_name = "Exosuit Weapon (OWM-5 \"Ronin\" katana)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","mech_shortsword")
	design_ids = list("mech_katana")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_batong
	id = "mech_batong"
	display_name = "Exosuit Weapon (AV-98 \"Ingram\" heavy stun baton)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","adv_weaponry", "sec_basic")
	design_ids = list("mech_batong")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_trogdor
	id = "mech_trogdor"
	display_name = "Exosuit Weapon (TO-4 \"Tahu\" flaming chainsword)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","mech_shortsword")
	design_ids = list("mech_trogdor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_maul
	id = "mech_maul"
	display_name = "Exosuit Weapon (CX-22 \"Barbatos\" heavy maul)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","mech_shortsword")
	design_ids = list("mech_maul")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mech_spear
	id = "mech_spear"
	display_name = "Exosuit Weapon (S5-C \"White Witch\" shortspear)"
	description = "An advanced piece of mech weaponry"
	prereq_ids = list("adv_mecha","adv_weaponry")
	design_ids = list("mech_spear")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////Nanites/////////////////////////
/datum/techweb_node/nanite_base
	id = "nanite_base"
	display_name = "Basic Nanite Programming"
	description = "The basics of nanite construction and programming."
	prereq_ids = list("datatheory")
	design_ids = list("nanite_disk","nanite_remote","nanite_comm_remote","nanite_scanner",\
						"nanite_chamber","public_nanite_chamber","nanite_chamber_control","nanite_programmer","nanite_program_hub","nanite_cloud_control",\
						"relay_nanites", "monitoring_nanites", "access_nanites", "repairing_nanites","sensor_nanite_volume", "repeater_nanites", "relay_repeater_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/nanite_smart
	id = "nanite_smart"
	display_name = "Smart Nanite Programming"
	description = "Nanite programs that require nanites to perform complex actions, act independently, roam or seek targets."
	prereq_ids = list("nanite_base","adv_robotics")
	design_ids = list("purging_nanites", "research_nanites", "metabolic_nanites", "stealth_nanites", "memleak_nanites","sensor_voice_nanites", "voice_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500, TECHWEB_POINT_TYPE_NANITES = 500)

/datum/techweb_node/nanite_mesh
	id = "nanite_mesh"
	display_name = "Mesh Nanite Programming"
	description = "Nanite programs that require static structures and membranes."
	prereq_ids = list("nanite_base","engineering")
	design_ids = list("hardening_nanites", "dermal_button_nanites", "refractive_nanites", "cryo_nanites", "conductive_nanites", "shock_nanites", "emp_nanites", "temperature_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500, TECHWEB_POINT_TYPE_NANITES = 500)

/datum/techweb_node/nanite_bio
	id = "nanite_bio"
	display_name = "Biological Nanite Programming"
	description = "Nanite programs that require complex biological interaction."
	prereq_ids = list("nanite_base","biotech")
	design_ids = list("regenerative_nanites", "bloodheal_nanites", "coagulating_nanites","poison_nanites","flesheating_nanites",\
					"sensor_crit_nanites","sensor_death_nanites", "sensor_health_nanites", "sensor_damage_nanites", "sensor_race_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/nanite_neural
	id = "nanite_neural"
	display_name = "Neural Nanite Programming"
	description = "Nanite programs affecting nerves and brain matter."
	prereq_ids = list("nanite_bio")
	design_ids = list("nervous_nanites", "brainheal_nanites", "stun_nanites", "selfscan_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 1000)

/datum/techweb_node/nanite_synaptic
	id = "nanite_synaptic"
	display_name = "Synaptic Nanite Programming"
	description = "Nanite programs affecting mind and thoughts."
	prereq_ids = list("nanite_neural","neural_programming")
	design_ids = list("mindshield_nanites", "pacifying_nanites", "blinding_nanites", "sleep_nanites", "mute_nanites", "speech_nanites","hallucination_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000, TECHWEB_POINT_TYPE_NANITES = 1000)

/datum/techweb_node/nanite_harmonic
	id = "nanite_harmonic"
	display_name = "Harmonic Nanite Programming"
	description = "Nanite programs that require seamless integration between nanites and biology."
	prereq_ids = list("nanite_bio","nanite_smart","nanite_mesh")
	design_ids = list("researchplus_nanites","aggressive_nanites","defib_nanites","regenerative_plus_nanites","brainheal_plus_nanites","purging_plus_nanites","nanite_heart")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2000, TECHWEB_POINT_TYPE_NANITES = 2000)

/datum/techweb_node/nanite_combat
	id = "nanite_military"
	display_name = "Military Nanite Programming"
	description = "Nanite programs that perform military-grade functions."
	prereq_ids = list("nanite_harmonic", "syndicate_basic")
	design_ids = list("explosive_nanites","pyro_nanites","meltdown_nanites","viral_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500, TECHWEB_POINT_TYPE_NANITES = 2500)

/datum/techweb_node/nanite_hazard
	id = "nanite_hazard"
	display_name = "Hazard Nanite Programs"
	description = "Extremely advanced Nanite programs with the potential of being extremely dangerous."
	prereq_ids = list("nanite_harmonic", "alientech")
	design_ids = list("spreading_nanites","mitosis_nanites")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000, TECHWEB_POINT_TYPE_NANITES = 4000)

////////////////////////Alien technology////////////////////////
/datum/techweb_node/alientech //AYYYYYYYYLMAOO tech
	id = "alientech"
	display_name = "Alien Technology"
	description = "Things used by the greys."
	prereq_ids = list("biotech","engineering")
	boost_item_paths = list(/obj/item/gun/energy/alien, /obj/item/scalpel/alien, /obj/item/hemostat/alien, /obj/item/retractor/alien, /obj/item/circular_saw/alien,
	/obj/item/cautery/alien, /obj/item/surgicaldrill/alien, /obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/abductor/baton, /obj/item/abductor)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	hidden = TRUE
	design_ids = list("alienalloy", "mind_flayer")

/datum/techweb_node/alien_bio
	id = "alien_bio"
	display_name = "Alien Biological Tools"
	description = "Advanced biological tools."
	prereq_ids = list("alientech", "adv_biotech")
	design_ids = list("alien_scalpel", "alien_hemostat", "alien_retractor", "alien_saw", "alien_drill", "alien_cautery")
	boost_item_paths = list(/obj/item/gun/energy/alien, /obj/item/scalpel/alien, /obj/item/hemostat/alien, /obj/item/retractor/alien, /obj/item/circular_saw/alien,
	/obj/item/cautery/alien, /obj/item/surgicaldrill/alien, /obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/abductor/baton, /obj/item/abductor)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE

/datum/techweb_node/alien_engi
	id = "alien_engi"
	display_name = "Alien Engineering"
	description = "Alien engineering tools"
	prereq_ids = list("alientech", "adv_engi")
	design_ids = list("alien_wrench", "alien_wirecutters", "alien_screwdriver", "alien_crowbar", "alien_welder", "alien_multitool")
	boost_item_paths = list(/obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/crowbar/abductor, /obj/item/multitool/abductor,
	/obj/item/weldingtool/abductor, /obj/item/wirecutters/abductor, /obj/item/circuitboard/machine/abductor, /obj/item/abductor/baton, /obj/item/abductor)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = TRUE

/datum/techweb_node/syndicate_basic
	id = "syndicate_basic"
	display_name = "Illegal Technology"
	description = "Dangerous research used to create dangerous objects."
	prereq_ids = list("adv_engi", "adv_weaponry", "explosive_weapons")
	design_ids = list("decloner", "borg_syndicate_module", "ai_cam_upgrade", "suppressor", "donksofttoyvendor", "donksoft_refill")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	hidden = TRUE

/datum/techweb_node/syndicate_basic/New()		//Crappy way of making syndicate gear decon supported until there's another way.
	. = ..()
	boost_item_paths = list()
	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/UI = new path
		if(!UI.item || !UI.illegal_tech)
			continue
		boost_item_paths |= UI.item	//allows deconning to unlock.

////////////////////////AI Hardware////////////////////////
/datum/techweb_node/ai_cpu_advanced
	id = "ai_cpu_advanced"
	display_name = "Advanced Neural Processing"
	description = "Using breakthroughs in high-efficiency fabrication it should be possible to drastically increase the speed of Neural Processing Units, at the cost of increased power consumption."
	design_ids = list("advanced_ai_cpu")
	prereq_ids = list("high_efficiency", "ai")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 3000)

/datum/techweb_node/ai_cpu_experimental
	id = "ai_cpu_experimental"
	display_name = "Experimental Neural Processing"
	description = "Previously discarded NPUs could be repurposed with minor tweaks. This comes at the expense of increased powerconsumption, but enhanced overclocking capabilities."
	design_ids = list("experimental_ai_cpu")
	prereq_ids = list("ai_cpu_advanced")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_cpu_bluespace
	id = "ai_cpu_bluespace"
	display_name = "Bluespace Neural Processing"
	description = "Breakthroughts in bluespace allows the fabrication of ultra fast NPUs. This however comes at the expense of greatly higher power consumption."
	design_ids = list("bluespace_ai_cpu")
	prereq_ids = list("ai_cpu_advanced", "practical_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 10000)

/datum/techweb_node/ai_ram_high_cap
	id = "ai_ram_high_cap"
	display_name = "High Capacity Memory Sticks"
	description = "Further advances in memory production should allow higher density sticks."
	design_ids = list("ram2")
	prereq_ids = list("high_efficiency", "ai")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 3000)

/datum/techweb_node/ai_ram_hyper
	id = "ai_ram_hyper"
	display_name = "Hyper Capacity Memory Sticks"
	description = "Further refinement of memory technology allows previously unimaginable data-density."
	design_ids = list("ram3")
	prereq_ids = list("ai_ram_high_cap")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_ram_bluespace
	id = "ai_ram_bluespace"
	display_name = "Bluespace Memory Sticks"
	description = "Breakthroughs in bluespace technology allows memory chips to store data in special bluespace pockets. Greatly improves data density at the cost of higher fabrication costs."
	design_ids = list("ram4")
	prereq_ids = list("ai_ram_hyper", "practical_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 7500)



/datum/techweb_node/ai_cpu_1
	id = "ai_cpu_2"
	display_name = "Improved CPU Sockets"
	description = "Refinements in general data theory should allow the mounting of an extra CPU core in each AI server rack."
	prereq_ids = list("ai")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_ram_1
	id = "ai_ram_2"
	display_name = "Improved Memory Bus"
	description = "Refinements in general data theory should allow the addition of another memory stick in each AI server rack."
	prereq_ids = list("ai")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_architecture_256
	id = "ai_arch_256"
	display_name = "256bit Computing"
	description = "Experience with creating computer hardware highlights the need for additional CPU cores and memory sticks in each rack. This acts as a gateway to those technologies."
	prereq_ids = list("ai_ram_2", "ai_cpu_2")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_architecture_bluespace
	id = "ai_arch_bluespace"
	display_name = "Bluespace Computing"
	description = "Bluespace advances allow the instant teleportation of data across a server rack. This acts as a gateway to the final tier of computing."
	prereq_ids = list("ai_arch_256", "practical_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 7500)


/datum/techweb_node/ai_cpu_2
	id = "ai_cpu_3"
	display_name = "Advanced CPU Sockets"
	description = "256 bit computing allows the introduction of another CPU core."
	prereq_ids = list("ai_arch_256", "ai_cpu_2")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 5000)

/datum/techweb_node/ai_cpu_3
	id = "ai_cpu_4"
	display_name = "Bluespace CPU Sockets"
	description = "Instant teleportation of data across CPU caches allows the installation of a fourth CPU core."
	prereq_ids = list("ai_arch_bluespace", "ai_cpu_3")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 10000)

/datum/techweb_node/ai_ram_2
	id = "ai_ram_3"
	display_name = "Advanced Memory Bus"
	description = "256 bit computing allows the introduction of another memory module."
	prereq_ids = list("ai_arch_256", "ai_ram_2")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 4000)

/datum/techweb_node/ai_ram_3
	id = "ai_ram_4"
	display_name = "Bluespace Memory Bus"
	description = "Bluespace teleportation allows the removal of all bottlenecks. Allows for the introduction of a fourth memory module."
	prereq_ids = list("ai_ram_3", "ai_arch_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_AI = 8000)

/proc/total_techweb_points()
	var/list/datum/techweb_node/processing = list()
	for(var/i in subtypesof(/datum/techweb_node))
		processing += new i
	var/datum/techweb/TW = new
	TW.research_points = list()
	for(var/i in processing)
		var/datum/techweb_node/TN = i
		TW.add_point_list(TN.research_costs)
	return TW.research_points

/proc/total_techweb_points_printout()
	var/list/datum/techweb_node/processing = list()
	for(var/i in subtypesof(/datum/techweb_node))
		processing += new i
	var/datum/techweb/TW = new
	TW.research_points = list()
	for(var/i in processing)
		var/datum/techweb_node/TN = i
		TW.add_point_list(TN.research_costs)
	return TW.printout_points()
	
