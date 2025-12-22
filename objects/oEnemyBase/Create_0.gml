

/// ================================================================
/// ENEMY STATE MACHINE INITIALIZATION
/// ================================================================
/// All enemies begin in ENTER_SCREEN state && progress through:
///
/// STATE FLOW (Standard Mode):
///   ENTER_SCREEN ──> MOVE_INTO_FORMATION ──> IN_FORMATION ──┐
///                                                            │
///   ┌────────────────────────────────────────────────────────┘
///   │
///   ├──> IN_DIVE_ATTACK ──> IN_LOOP_ATTACK ──> MOVE_INTO_FORMATION
///   │           │                                      ▲
///   │           └──> (off screen) ──> RETURN_PATH ────┘
///   │
///   └──> IN_FINAL_ATTACK (when only 2-3 enemies remain)
///         └──> Continuous aggressive attacks
///
/// STATE FLOW (Challenge Mode):
///   ENTER_SCREEN ──> (path complete) ──> DESTROY
///
/// STATE FLOW (Rogue Mode):
///   ENTER_SCREEN ──> (path complete) ──> Target Player ──> DESTROY
///
/// ================================================================

// spawn new enemy in the ENTER_SCREEN mode
enemyState = EnemyState.ENTER_SCREEN;

// default is STANDARD enemy mode
enemyMode = EnemyMode.STANDARD;
	
// Flag indicating if the enemy is an escort, initialized to 0 (0 = not escort, 1 = escort).
// Escorts may have special behaviors, such as accompanying a boss || following unique paths.
escort = 0;

baseSpeed = 6;
moveSpeed = baseSpeed * global.Game.Difficulty.speedMultiplier;
entranceSpeed = baseSpeed  + (baseSpeed * global.Game.Difficulty.speedMultiplier);

// Flag for transformation state, initialized to 0 (0 = normal, 1 = transformed).
// Used for enemies that change form || behavior (e.g., Butterfly transforming).
trans = 0;

// Flag indicating if the enemy is a rogue, initialized to 0 (0 = normal, 1 = rogue).
// Rogue enemies may follow unique paths || behaviors compared to standard enemies.
rogue = 0;

// X-coordinate offset for a breathing animation, initialized to 0.
// Used for visual effects, such as pulsating || moving enemies (e.g., boss-related).
breathex = 0;

// Y-coordinate offset for a breathing animation, initialized to 0.
// Complements breathex for enemy animation effects.
breathey = 0;

// Target X-coordinate for movement, initialized to 0.
// Used to guide the enemy toward a specific point (e.g., during a dive || goto behavior).
targx = 0;

// Target Y-coordinate for movement, initialized to 0.
// Complements targx for navigation || attack patterns.
targy = 0;

/// ================================================================
/// SAFE DATA INITIALIZATION - Load global game data
/// ================================================================
/// Validates that required global data structures are loaded and
/// accessible. These structures contain game-wide configuration
/// loaded from JSON files during GameManager initialization.
///
/// Critical structures:
///   • global.Game.Data.formation: Grid positions for all enemies
///   • global.Game.Data.enemyAttributes: Stats (health, points, etc.) by type
/// ================================================================

// === SAFE DATA INITIALIZATION - Validate Formation Grid ===
// Validate formation data exists && contains required structure
if (!is_struct(global.Game.Data.formation)) {
	log_error("global.Game.Data.formation is not initialized", "oEnemyBase Create_0", 3);
	global.Game.Data.formation = { POSITION: [] };  // Fallback with empty POSITION array
}

// Additional check: Ensure POSITION array exists within formation struct
if (!variable_struct_exists(global.Game.Data.formation, "POSITION")) {
	log_error("global.Game.Data.formation missing POSITION array", "oEnemyBase Create_0", 3);
	global.Game.Data.formation.POSITION = [];  // Add empty array as fallback
}

// === SAFE DATA INITIALIZATION - Validate Enemy Attributes ===
// Validate enemy attributes map exists
if (!is_struct(global.Game.Data.enemyAttributes)) {
	log_error("global.Game.Data.enemyAttributes is not initialized", "oEnemyBase Create_0", 3);
	global.Game.Data.enemyAttributes = {};  // Fallback to empty structure
}

// === ASSIGNMENT ===
/// Store references to global data for use throughout object lifetime
formation = global.Game.Data.formation;

/// === LOAD ENEMY-SPECIFIC ATTRIBUTES ===
/// Safely retrieve this enemy type's stats from the attributes map
/// Uses safe_struct_get() to avoid crashes if enemy type not found
attributes = safe_struct_get(global.Game.Data.enemyAttributes, ENEMY_NAME, {});

// === VALIDATE REQUIRED FIELDS ===
/// Check that essential attributes exist, provide safe defaults
/// HEALTH is critical - determines how many hits enemy can take
if (!struct_exists(attributes, "HEALTH")) {
	log_error("Enemy attributes missing HEALTH for: " + ENEMY_NAME, "oEnemyBase Create_0", 2);
	attributes.HEALTH = 1;  // Default: 1 hit to kill (fallback)
}

/// === INITIALIZE HITCOUNT ===
/// hitCount tracks damage taken. When hitCount reaches 0, enemy dies.
hitCount = attributes.HEALTH;

/// ================================================================
/// PATH INITIALIZATION - Set up entrance animation
/// ================================================================
/// Each enemy follows a predefined path from spawn point to formation.
/// Paths are visual in GameMaker editor, providing choreographed entry
/// animations. Path names vary by spawn direction (top/bottom, left/right).
/// ================================================================

if (PATH_NAME != noone && is_string(PATH_NAME)) {
	// Safely retrieve path asset with error handling
	var path_id = safe_get_asset(PATH_NAME, -1);

	if (path_id != -1) {
		/// Path found - begin entrance animation
		/// Parameters:
		///   path_id: Asset ID of the path to follow
		///   entranceSpeed: Speed along path (pixels per frame)
		///   0: Path mode (point-to-point, not smooth)
		///   0: Closed path (false - open-ended)
		path_start(path_id, entranceSpeed, 0, 0);
	} else {
		/// Path asset not found
		/// Enemy will be created but won't move during entrance
		/// This is non-fatal but indicates missing path asset
		log_error("Failed to start path for enemy: " + ENEMY_NAME + " (path: " + PATH_NAME + ")", "oEnemyBase Create_0", 2);
	}
}

/// ================================================================
/// GAME MODE INITIALIZATION
/// ================================================================
/// Set the game mode which determines enemy behavior patterns.
/// Three modes exist: STANDARD (normal waves), CHALLENGE (bonus), ROGUE (special)
/// ================================================================

if (MODE == EnemyMode.STANDARD) {
	/// === STANDARD MODE ===
	/// Normal enemy spawned from regular waves
	/// Uses all standard behaviors: formation, diving, attacking

	enemyMode = EnemyMode.STANDARD;

	/// === DIVE ATTACK TIMING ===
	/// Set alarm[5] to control when this enemy can fire shots
	///
	/// Timing varies by wave:
	///   • Waves 0: 10 frames (0.167s) - quick, scattered attacks
	///   • Waves 1-2: 75 frames (1.25s) - standard 1-2s interval
	///   • Waves 1-2 (fast): 63 frames (1.05s) - slightly faster during fast entry
	///
	/// This stagger prevents all enemies shooting simultaneously

	if (global.Game.Level.wave == 1 || global.Game.Level.wave == 2) {
		alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_STANDARD;
		if (global.Game.State.fastEnter == 1) {
			alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_FAST;  // Faster intervals during fast entry mode
		}
	} else {
		alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_INITIAL;  // Wave 0: shorter delay
	}
}
else if (MODE == EnemyMode.CHALLENGE) {
	enemyMode = EnemyMode.CHALLENGE;
}
else if (MODE == EnemyMode.ROGUE) {
	enemyMode = EnemyMode.ROGUE;
}

/// @section Fast Entry Adjustment
// If global.Game.State.fastEnter == 1, adjust timing variables for faster enemy entry.
// fasty set to TRANSFORM_ALARM_DELAY steps to speed up entry animations.
if (global.Game.State.fastEnter == 1) fasty = TRANSFORM_ALARM_DELAY;

beam_weapon = {
	available : false,

	// state machine for beam charging phases (0 = normal, -1 = charging, -2 = firing, etc)
	state : BEAM_STATE.READY,
	
	// Animation frame counter (used for beam sprite animation)
	animation : 0,
	
	player_x : 0,
	player_y : 0
};