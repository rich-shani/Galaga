

// spawn new enemy in the ENTER_SCREEN mode
enemyState = EnemyState.ENTER_SCREEN;

// default is STANDARD enemy
enemyMode = EnemyMode.STANDARD;
	
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

/// ================================================================
/// SAFE DATA INITIALIZATION - Load global game data
/// ================================================================
/// Validates that required global data structures are loaded and
/// accessible. These structures contain game-wide configuration
/// loaded from JSON files during GameManager initialization.
///
/// Critical structures:
///   • global.formation_data: Grid positions for all enemies
///   • global.enemy_attributes: Stats (health, points, etc.) by type
/// ================================================================

// Validate formation data exists
if (!is_struct(global.formation_data)) {
	log_error("global.formation_data is not initialized", "oEnemyBase Create_0", 3);
	global.formation_data = {};  // Fallback to empty structure
}

// Validate enemy attributes map exists
if (!is_struct(global.enemy_attributes)) {
	log_error("global.enemy_attributes is not initialized", "oEnemyBase Create_0", 3);
	global.enemy_attributes = {};  // Fallback to empty structure
}

// === ASSIGNMENT ===
/// Store references to global data for use throughout object lifetime
formation = global.formation_data;

/// === LOAD ENEMY-SPECIFIC ATTRIBUTES ===
/// Safely retrieve this enemy type's stats from the attributes map
/// Uses safe_struct_get() to avoid crashes if enemy type not found
attributes = safe_struct_get(global.enemy_attributes, ENEMY_NAME, {});

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

if (MODE == "STANDARD") {
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

	if (global.wave == 1 || global.wave == 2) {
		alarm[5] = 75;
		if (global.fastenter == 1) {
			alarm[5] = 63;  // Faster intervals during fast entry mode
		}
	} else {
		alarm[5] = 10;  // Wave 0: shorter delay
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

/// ================================================================
/// BEAM WEAPON SYSTEM - Special Ability
/// ================================================================
/// The beam weapon system allows special enemy types (like TIE Intercepters)
/// to charge and fire a powerful energy beam at the player ship.
///
/// Beam mechanics:
/// • beam: Flag indicating if this enemy can use beam weapon (0 = no, 1 = yes)
/// • beamsignal: Tracks beam charging state during activation
/// • loop: State machine for beam charging and firing phases
/// • anim: Animation frame counter for beam sprite cycling
///
/// Beam can only activate once per dive attack when:
/// • No other beam currently active
/// • Player is in single-ship mode (not dual/doubled)
/// • No fighters are captured
/// • Global beam check flag is clear
/// ================================================================

// Beam weapon flag - set to 0 by default (disable until enabled by subclass)
beam = 0;

// Beam signal/state tracking during charge sequence
beamsignal = 0;

// Loop state machine for beam charging phases (0 = normal, -1 = charging, -2 = firing, etc)
loop = 0;

// Animation frame counter (used for beam sprite animation)
anim = 0;