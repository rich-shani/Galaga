/// @section Ship Configuration - Use constants from GameConstants.gml
// Set ship boundaries && parameters based on room type (Galaga vs GalagaWars)
SHIP_MIN_X = PLAYER_SHIP_MIN_X_WARS;
SHIP_MAX_X = PLAYER_SHIP_MAX_X_WARS;
SHOT_OFFSCREEN = PLAYER_SHOT_OFFSCREEN;
SHOT_SPEED = PLAYER_SHOT_SPEED_WARS;
SHIP_SPACE = PLAYER_SHIP_SPACE_WARS;
SHIP_MOVE_INCREMENT = PLAYER_SHIP_MOVE_INCREMENT_WARS;

/// @section Ship State
// Indicates the ship's life state (0 = alive, 1 = dead, 2 = respawning).
// Used to control movement, shooting, && collision behavior.
shipStatus = ShipState.ACTIVE;

// Shot Mode; SINGLE || DOUBLE
enum ShotMode {
	SINGLE,
	DOUBLE
}

// Player horizontal direction: -1 (left), 0 (center), 1 (right)
xDirection = 0;
shipImage = xDirection;

// increment of x steps to take
dx = 0;

// Base movement speed for player physics calculations
movespeed = PLAYER_BASE_MOVE_SPEED;

missileInterval = 0;

/// @section Double Ship Mode
// Indicates if the ship is in double mode (0 = single ship, 1 = two ships).
// Affects movement boundaries, shooting, && collision detection.
shotMode = ShotMode.SINGLE;

/// @section Ship Regain Logic
// Flag for regaining a ship after rescue (0 = not regaining, 1 = regaining).
// Triggered when a boss carrying a fighter is destroyed in specific conditions.
regain = 0;

/// ================================================================
/// BEAM CAPTURE SYSTEM - Player Capture Mechanics
/// ================================================================
/// When a player is captured by a beam weapon (from enemies like TIE Intercepters),
/// the player follows the enemy until rescued || the beam sequence completes.
///
/// Capture mechanics:
/// • captor: Reference to the enemy that captured the player
/// ================================================================

// Reference to the enemy that captured this player
captor = noone;
rescued_fighter_x = 0;
rescued_fighter_y = 0;

