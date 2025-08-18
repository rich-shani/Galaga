/// @description Initializes the player ship's variables and state for the space shooter game.
/// This script sets up initial values for movement, shooting, collision detection, and state management.
/// It assumes the existence of a Controller object with gameMode and start properties, and a GameMode enum.

/// @section Shooting Initialization
// Number of shots the ship can fire (2 for single or double ship mode).
shot = 2;

// First shot's X-coordinate, initialized off-screen to indicate it's inactive.
// -32 is outside the room's visible area, ensuring the shot is not rendered or processed.
shot1x = -32;

// First shot's Y-coordinate, also set off-screen for inactivity.
shot1y = -32;

// First shot's direction in degrees (0 = no movement, typically set to 360 when fired).
// Used to calculate shot trajectory using sin and cos functions.
shot1dir = 0;

// Flag indicating if the first shot is part of a double shot (0 = no, 1 = yes).
// Used when the ship is in double mode to track paired shots.
dub1 = 0;

// Second shot's X-coordinate, initialized off-screen.
shot2x = -32;

// Second shot's Y-coordinate, initialized off-screen.
shot2y = -32;

// Second shot's direction, initialized to 0 (updated to 360 when fired).
shot2dir = 0;

// Flag for second shot in double mode, similar to dub1.
dub2 = 0;

/// @section Rendering and Depth
// Sets the ship's depth to -150, ensuring it renders above most game objects (e.g., enemies, background).
// Negative depth values in GameMaker indicate higher rendering priority.
depth = -150;

enum ShipState {
	ACTIVE,
	CAPTURED,
	RELEASING,
	DEAD,
	RESPAWN
}

/// @section Ship State
// Indicates the ship's life state (0 = alive, 1 = dead, 2 = respawning).
// Used to control movement, shooting, and collision behavior.
shipStatus = ShipState.ACTIVE;

// Spin animation angle in degrees, set to 360 for default upright position.
// Modified during caught or regain states to rotate the ship visually.
spinanim = 360;

/// @section Macros for Game Constants
// Minimum X-coordinate for ship movement (left boundary, 16 pixels from room edge).
#macro SHIP_MIN_X 16

// Maximum X-coordinate for ship movement (right boundary, adjusted for double mode).
// 432 is derived from the room width minus the ship's sprite width.
#macro SHIP_MAX_X 432

// Off-screen coordinate for shots (-32 ensures shots are not visible/processed).
#macro SHOT_OFFSCREEN -32

// Speed of shots in pixels per step (12 pixels for consistent movement).
#macro SHOT_SPEED 12

// Horizontal offset for double ship mode (28 pixels between left and right ships).
#macro SHIP_SPACE 28

// X-coordinate of the gravity point (boss's position) when caught.
// Used to pull the ship toward the boss during the capture state.
grav = 0;

// Flag to check if a boss is actively beaming (0 = no, 1 = yes).
// Used to manage capture state transitions.
beamcheck = 0;

enum ShotMode {
	SINGLE,
	DOUBLE 
}

/// @section Double Ship Mode
// Indicates if the ship is in double mode (0 = single ship, 1 = two ships).
// Affects movement boundaries, shooting, and collision detection.
shotMode = ShotMode.SINGLE;

/// @section Ship Regain Logic
// Flag for regaining a ship after rescue (0 = not regaining, 1 = regaining).
// Triggered when a boss carrying a fighter is destroyed in specific conditions.
regain = 0;

// X-coordinate of the new ship being regained, initialized to 0.
// Updated to the fighter's position when a rescue occurs.
newshipx = 0;

// Y-coordinate of the new ship, initialized to 0.
// Used to position the regained ship during the regain animation.
newshipy = 0;

// Flag indicating if the ship is moving to a formation position
// Used during regain or respawn to animate ship positioning.
in_formation = false;

/// @section Double Ship Death Animation
// X-coordinate of the second ship (right ship) when hit in double mode.
// Stores the position for the death animation of the right ship.
secondx = 0;

// Second death animation counter (0 to 4), used for the right ship's destruction in double mode.
// Incremented by 0.1 each step when the right ship is hit.
deadanim2 = 0;


/// @section Shooting Control
// Flag to manage double shot timing (0 = allow second shot, 1 = skip second shot).
// Prevents rapid firing of the second shot in quick succession.
skip = 0;

/// @section Collision Detection
// Collision radius for shots hitting enemies (11 pixels).
// Used to check if a shot is close enough to an enemy for a hit.
space = 11;

// Collision radius for enemies hitting the ship (13 pixels).
// Slightly larger than 'space' to account for ship size in collision checks.
space2 = 13;

/// @section Block Flags
// Purpose unclear without additional context; likely a placeholder or unused flag.
// Initialized to 0, possibly for future mechanics (e.g., blocking shots or movement).
block1 = 0;

// Similar to block1, likely a placeholder or unused flag.
block2 = 0;