/// @section Macros for Game Constants
// Minimum X-coordinate for ship movement (left boundary, 16 pixels from room edge).
SHIP_MIN_X = 16;
	// Maximum X-coordinate for ship movement (right boundary, adjusted for double mode).
	// 432 is derived from the room width minus the ship's sprite width.
SHIP_MAX_X = 432;
	// Off-screen coordinate for shots (-32 ensures shots are not visible/processed).
SHOT_OFFSCREEN = -32;
	// Speed of shots in pixels per step (12 pixels for consistent movement).
SHOT_SPEED = 12;
	// Horizontal offset for double ship mode (28 pixels between left and right ships).
SHIP_SPACE = 28;
	
SHIP_MOVE_INCREMENT = 3;
	
if (global.roomname == "GalagaWars") {
	SHIP_MIN_X = 64;
	// Maximum X-coordinate for ship movement (right boundary, adjusted for double mode).
	// 432 is derived from the room width minus the ship's sprite width.
	SHIP_MAX_X = 832;
	// Off-screen coordinate for shots (-32 ensures shots are not visible/processed).
	SHOT_OFFSCREEN = -32;
	// Speed of shots in pixels per step (12 pixels for consistent movement).
	SHOT_SPEED = 24;
	// Horizontal offset for double ship mode (28 pixels between left and right ships).
	SHIP_SPACE = 56;
	SHIP_MOVE_INCREMENT = 6;
}

//enum _ShipState {
//	ACTIVE,
//	CAPTURED,
//	RELEASING,
//	DEAD,
//	RESPAWN
//}

/// @section Ship State
// Indicates the ship's life state (0 = alive, 1 = dead, 2 = respawning).
// Used to control movement, shooting, and collision behavior.
shipStatus = _ShipState.ACTIVE;

// Shot Mode; SINGLE or DOUBLE
enum _ShotMode {
	SINGLE,
	DOUBLE 
}

//// Affects movement boundaries, shooting, and collision detection.
//shotMode = ShotMode.SINGLE;

// 0 is level, 1 is left, 11 is right
//shipDirection = 0;
xDirection = 0;
shipImage = xDirection;

// increment of x steps to take
dx = 0;

// 
movespeed = 5;

missileInterval = 0;

/// @section Double Ship Mode
// Indicates if the ship is in double mode (0 = single ship, 1 = two ships).
// Affects movement boundaries, shooting, and collision detection.
shotMode = _ShotMode.SINGLE;

/// @section Ship Regain Logic
// Flag for regaining a ship after rescue (0 = not regaining, 1 = regaining).
// Triggered when a boss carrying a fighter is destroyed in specific conditions.
regain = 0;

/// ================================================================
/// BEAM CAPTURE SYSTEM - Player Capture Mechanics
/// ================================================================
/// When a player is captured by a beam weapon (from enemies like TIE Intercepters),
/// the player follows the enemy until rescued or the beam sequence completes.
///
/// Capture mechanics:
/// • captor: Reference to the enemy that captured the player
/// ================================================================

// Reference to the enemy that captured this player
captor = noone;

