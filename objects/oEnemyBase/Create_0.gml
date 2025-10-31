/// @section Enemy Behavior Variables
//enum EnemyState {
//	ENTER_SCREEN,
//	MOVE_INTO_FORMATION,
//	IN_FORMATION,
//	IN_DIVE_ATTACK,
//	IN_LOOP_ATTACK,
//	IN_FINAL_ATTACK
//}

// spawn new enemy in the ENTER_SCREEN mode
enemyState = EnemyState.ENTER_SCREEN;

//enum EnemyMode {
//	STANDARD,
//	CHALLENGE,
//	ROGUE
//}

// default is STANDARD enemy
enemyMode = EnemyMode.STANDARD;
	
//#macro ENEMY_BASE_SPEED					6
//#macro ENEMY_ENTRANCE_SPEED_MULTIPLIER	2
//#macro FORMATION_ROTATION_ANGLE_STEP	6
//#macro BREATHING_CYCLE_MAX				120
//#macro DIVE_ALARM_STANDARD				75
//#macro DIVE_ALARM_FAST					63
//#macro DIVE_ALARM_INITIAL				10
//#macro MAX_ENEMY_SHOTS					8
//#macro ENEMY_SHOT_TIMING_1				60
//#macro ENEMY_SHOT_TIMING_2				40
//#macro ENEMY_SHOT_TIMING_3				20

// Flag indicating if the enemy is an escort, initialized to 0 (0 = not escort, 1 = escort).
// Escorts may have special behaviors, such as accompanying a boss or following unique paths.
escort = 0;

baseSpeed = 6;
moveSpeed = baseSpeed * global.speedMultiplier;
entranceSpeed = baseSpeed  + (baseSpeed * global.speedMultiplier);

// Flag for transformation state, initialized to 0 (0 = normal, 1 = transformed).
// Used for enemies that change form or behavior (e.g., Butterfly transforming).
trans = 0;

// Flag indicating if the enemy is a rogue, initialized to 0 (0 = normal, 1 = rogue).
// Rogue enemies may follow unique paths or behaviors compared to standard enemies.
rogue = 0;

// X-coordinate offset for a breathing animation, initialized to 0.
// Used for visual effects, such as pulsating or moving enemies (e.g., boss-related).
breathex = 0;

// Y-coordinate offset for a breathing animation, initialized to 0.
// Complements breathex for enemy animation effects.
breathey = 0;

// Target X-coordinate for movement, initialized to 0.
// Used to guide the enemy toward a specific point (e.g., during a dive or goto behavior).
targx = 0;

// Target Y-coordinate for movement, initialized to 0.
// Complements targx for navigation or attack patterns.
targy = 0;

formation = global.formation_data;
attributes = global.enemy_attributes[$ ENEMY_NAME];
  
//formation = load_json_datafile("Patterns/formation_coordinates.json");
//attributes = load_json_datafile("Patterns/" + ENEMY_NAME + ".json");

hitCount = attributes.HEALTH;

if (PATH_NAME != noone) {
	var path_id = asset_get_index(PATH_NAME);
	if (path_id != -1) path_start(path_id, entranceSpeed, 0, 0);
}

if (MODE == "STANDARD") {
	enemyMode = EnemyMode.STANDARD;
	
	/// @section Dive Alarm Setup
	// Set alarm[5] to control the timing of enemy shots
	// For waves 1 or 2, use 75 steps (1.25 seconds) or 63 steps if global.fastenter == 1 (faster entry).
	// For wave 0, use a shorter 10-step delay (0.167 seconds).
	if (global.wave == 1 || global.wave == 2) {
	    alarm[5] = 75;
	    if (global.fastenter == 1) { alarm[5] = 63; }
	} else {
	    alarm[5] = 10;
	}
}
else if (MODE == "CHALLENGE") {
	enemyMode = EnemyMode.CHALLENGE;
}
else if (MODE == "ROGUE") {
	enemyMode = EnemyMode.ROGUE;
}

/// @section Fast Entry Adjustment
// If global.fastenter == 1, adjust timing variables for faster enemy entry.
// fasty set to 50 steps to speed up entry animations.
if (global.fastenter == 1) fasty = 50;