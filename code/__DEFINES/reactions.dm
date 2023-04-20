//Defines used in atmos gas reactions. Used to be located in ..\modules\atmospherics\gasmixtures\reactions.dm, but were moved here because fusion added so fucking many.

//Plasma fire properties
#define OXYGEN_BURN_RATE_BASE				1.4
#define PLASMA_BURN_RATE_DELTA				9
#define HYDROGEN_BURN_RATE_DELTA			8
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define FIRE_CARBON_ENERGY_RELEASED			100000	//Amount of heat released per mole of burnt carbon into the tile
#define FIRE_HYDROGEN_ENERGY_RELEASED		2800000  //Yogs -- Amount of heat released per mole of burnt hydrogen and/or tritium(hydrogen isotope). Increased significantly due to a bugfix leading to much lower burn temperatures.
#define FIRE_PLASMA_ENERGY_RELEASED			3000000	//Amount of heat released per mole of burnt plasma into the tile

// Water Vapor:
/// The temperature required for water vapor to condense.
#define WATER_VAPOR_CONDENSATION_POINT (T20C + 10)
/// The temperature required for water vapor to condense as ice instead of water.
#define WATER_VAPOR_DEPOSITION_POINT 200

//freon reaction
#define FREON_BURN_RATE_DELTA				4
#define FIRE_FREON_ENERGY_RELEASED			-300000 //amount of heat absorbed per mole of burnt freon in the tile

#define N2O_DECOMPOSITION_MIN_HEAT			800+T0C	//minimum heat for n2o to decompose
#define N2O_DECOMPOSITION_MAX_HEAT			100000	//maximum heat n2o can decompose at, completely arbitrary
#define N2O_DECOMPOSITION_ENERGY			82050	//energy released for each mole of n2o decomposed
#define N2O_DECOMPOSITION_RATE				0.5		//maximum percentage of n2o that can decompose in one tick

// Nitrium:
/// The minimum temperature necessary for nitrium to form from plasma, nitrogen, and BZ (with N2O as a catalyst)
#define NITRIUM_FORMATION_MIN_TEMP 50000
/// The amount of thermal energy consumed when a mole of nitrium is formed
#define NITRIUM_FORMATION_ENERGY 100000

// Nitro ball:
#define NITRO_BALL_GAS_AMOUNT 5
/// Up to 36 moles of each reactant consumed per reaction, somewhere around twice that of plasma
#define NITRO_BALL_MAX_REACT_RATE 36
/// Moles of reactant per radball emitted
#define NITRO_BALL_MOLES_REQUIRED 2
/// Amount of energy released when plasma is consumed (into radballs) by nitroball 
#define NITRO_BALL_PLASMA_ENERGY 20000000
/// Fraction of plasma consumed during reaction	
#define NITRO_BALL_PLASMA_COEFFICIENT 0.2
#define NITRO_BALL_HEAT_SCALE 100000

//tritium reaction
#define TRITIUM_BURN_OXY_FACTOR				100
#define TRITIUM_BURN_TRIT_FACTOR			10
#define TRITIUM_BURN_RADIOACTIVITY_FACTOR	50000 	//The neutrons gotta go somewhere. Completely arbitrary number.
#define TRITIUM_MINIMUM_RADIATION_ENERGY	0.1  	//minimum 0.01 moles trit or 10 moles oxygen to start producing rads
#define MINIMUM_TRIT_OXYBURN_ENERGY 		2000000	//This is calculated to help prevent singlecap bombs(Overpowered tritium/oxygen single tank bombs)
//hydrogen reaction
#define HYDROGEN_BURN_OXY_FACTOR			100
#define HYDROGEN_BURN_H2_FACTOR				5		//Burns faster and with half the energy of tritium
#define MINIMUM_H2_OXYBURN_ENERGY 			2000000	//This is calculated to help prevent singlecap bombs(Overpowered hydrogen/oxygen single tank bombs)
//ammonia reaction
#define AMMONIA_FORMATION_FACTOR			250
#define AMMONIA_FORMATION_ENERGY			1000
//metal hydrogen
#define METAL_HYDROGEN_MINIMUM_HEAT			1e7
#define METAL_HYDROGEN_MINIMUM_PRESSURE		1e7
#define METAL_HYDROGEN_FORMATION_ENERGY		20000000
#define SUPER_SATURATION_THRESHOLD			96
#define REACTION_OPPRESSION_THRESHOLD		5
#define NOBLIUM_FORMATION_ENERGY			2e9 	//1 Mole of Noblium takes the planck energy to condense.
//Research point amounts
#define BZ_RESEARCH_SCALE					4
#define METAL_HYDROGEN_RESEARCH_MAX_AMOUNT	3000
#define NOBLIUM_RESEARCH_AMOUNT				200
#define NOBLIUM_RESEARCH_MAX_AMOUNT			10000*NOBLIUM_RESEARCH_AMOUNT
#define BZ_RESEARCH_AMOUNT					4
#define BZ_RESEARCH_MAX_AMOUNT				10000*BZ_RESEARCH_AMOUNT
#define MIASMA_RESEARCH_AMOUNT				40
#define MIASMA_RESEARCH_MAX_AMOUNT			10000*MIASMA_RESEARCH_AMOUNT
//Plasma fusion properties
#define FUSION_MOLE_THRESHOLD				250 	//Mole count required (tritium/plasma) to start a fusion reaction
#define FUSION_TRITIUM_CONVERSION_COEFFICIENT (1e-10)
#define INSTABILITY_GAS_POWER_FACTOR 		0.003
#define FUSION_TRITIUM_MOLES_USED  			1
#define PLASMA_BINDING_ENERGY  				20000000
#define TOROID_VOLUME_BREAKEVEN				1000
#define FUSION_TEMPERATURE_THRESHOLD	    9000
#define PARTICLE_CHANCE_CONSTANT 			(-20000000)
#define FUSION_RAD_MAX						1500
#define FUSION_RAD_COEFFICIENT				(-1000)
#define FUSION_INSTABILITY_ENDOTHERMALITY   2
