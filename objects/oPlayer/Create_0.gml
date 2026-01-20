/// ========================================================================
/// oPlayer - CREATE EVENT (Initialization)
/// ========================================================================
/// @description Player object initialization - sets up all variables and 
///              constants needed for player ship behavior throughout gameplay
/// 
/// This event runs once when the player object is first created in the room.
/// It initializes:
///   • Ship boundaries and movement constants (based on game mode)
///   • Ship state machine (ShipState enum)
///   • Input handling variables (direction, movement)
///   • Shooting mechanics (shot mode, cooldowns)
///   • Capture/rescue system variables
/// 
/// @author Galaga Wars Team
/// @event Create (Event 0)
/// @related Step_0.gml - Main game loop that uses these variables
/// @related Draw_0.gml - Rendering that uses shipImage and shotMode
/// ========================================================================

// ========================================================================
// SHIP CONFIGURATION - Movement Boundaries & Parameters
// ========================================================================
/// @section Ship Configuration
/// @description Sets ship boundaries and movement parameters based on room type
///              Currently configured for GalagaWars mode (wider screen)
///              These constants come from GameConstants.gml
/// 
/// Note: These values determine the playable area for the player ship.
///       For Galaga mode, use PLAYER_SHIP_MIN_X_GALAGA and PLAYER_SHIP_MAX_X_GALAGA
/// ========================================================================

/// @var SHIP_MIN_X - Minimum X position the player ship can move to (left boundary)
SHIP_MIN_X = PLAYER_SHIP_MIN_X_WARS;

/// @var SHIP_MAX_X - Maximum X position the player ship can move to (right boundary)
SHIP_MAX_X = PLAYER_SHIP_MAX_X_WARS;

/// @var SHOT_OFFSCREEN - Y coordinate threshold for determining when shots are off-screen
///                       Used to recycle missiles back to the object pool
SHOT_OFFSCREEN = PLAYER_SHOT_OFFSCREEN;

/// @var SHOT_SPEED - Base speed of player missiles (pixels per frame)
///                   Higher values = faster projectiles
SHOT_SPEED = PLAYER_SHOT_SPEED_WARS;

/// @var SHIP_SPACE - Horizontal spacing between dual fighters when in DOUBLE mode
///                   Used to calculate second fighter position and boundary adjustments
SHIP_SPACE = PLAYER_SHIP_SPACE_WARS;

/// @var SHIP_MOVE_INCREMENT - Pixel distance the ship moves per input frame
///                            Used for discrete movement calculations (not currently used in Step_0)
SHIP_MOVE_INCREMENT = PLAYER_SHIP_MOVE_INCREMENT_WARS;

// ========================================================================
// SHIP STATE MACHINE - Life Cycle Management
// ========================================================================
/// @section Ship State
/// @description The ship's current life state, controlled by the ShipState enum.
///              This is the primary state machine that drives all player behavior.
/// 
/// State Values (from ShipState enum in GameConstants.gml):
///   • ACTIVE     - Normal gameplay, player has full control
///   • CAPTURED   - Player is held by enemy tractor beam (no control)
///   • DEAD       - Player destroyed, waiting for respawn or game over
///   • RESPAWN    - Respawn animation in progress
///   • RELEASING  - Player is being released from capture (rescue sequence)
/// 
/// State transitions are handled in Step_0.gml switch statement.
/// @related ShipState enum in GameConstants.gml
/// ========================================================================

/// @var shipState - Current state of the player ship (ShipState enum value)
///                   Initialized to ACTIVE to start gameplay immediately
shipState = ShipState.ACTIVE;

// ========================================================================
// SHOT MODE ENUM - Single vs Dual Fighter Configuration
// ========================================================================
/// @section Shot Mode Enumeration
/// @description Defines the player's shooting mode: single fighter or dual fighters
/// 
/// SINGLE mode: One fighter, 2 max missiles on screen
/// DOUBLE mode: Two fighters side-by-side, 4 max missiles on screen (double firepower)
/// 
/// Mode changes:
///   • Starts in SINGLE mode
///   • Changes to DOUBLE when a captured fighter is rescued
///   • Reverts to SINGLE when dual fighter is destroyed
/// ========================================================================

/// @enum ShotMode - Player shooting configuration mode
enum ShotMode {
	SINGLE,   /// Single fighter mode - standard gameplay
	DOUBLE    /// Dual fighter mode - rescued fighter docks with player
}

// ========================================================================
// MOVEMENT & INPUT VARIABLES
// ========================================================================
/// @section Movement Variables
/// @description Variables that track player input and movement calculations
///              These are updated every frame in Step_0.gml based on keyboard/gamepad input
/// ========================================================================

/// @var xDirection - Horizontal movement direction (-1 = left, 0 = none, 1 = right)
///                   Updated every frame based on input in Step_0.gml
///                   Used to calculate dx (displacement) and select ship sprite
xDirection = 0;

/// @var shipImage - Sprite subimage index for ship sprite (0-3 range)
///                  Values:
///                    • 1 = Left-tilted ship (moving left)
///                    • 2 = Center ship (no horizontal movement)
///                    • 3 = Right-tilted ship (moving right)
///                  Synchronized with xDirection in Step_0.gml
shipImage = xDirection;

/// @var dx - Horizontal pixel displacement per frame (calculated from xDirection * movespeed)
///           Applied directly to x position each frame in Step_0.gml
///           Value is recalculated every frame based on input
dx = 0;

/// @var movespeed - Base movement speed multiplier (pixels per frame per direction unit)
///                  Combined with xDirection to calculate dx
///                  Set from PLAYER_BASE_MOVE_SPEED constant
movespeed = PLAYER_BASE_MOVE_SPEED;

// ========================================================================
// SHOOTING MECHANICS - Missile Cooldown System
// ========================================================================
/// @section Shooting Variables
/// @description Controls the rate of fire and missile spawning for the player
/// ========================================================================

/// @var missileInterval - Cooldown timer for missile firing (frames remaining until next shot allowed)
///                        • Decremented by 1 each frame in Step_0.gml
///                        • When <= 0, player can fire
///                        • Set to cooldown value (0.1 seconds) after each shot
///                        • Prevents spamming bullets and maintains game balance
missileInterval = 0;

// ========================================================================
// DUAL FIGHTER MODE - Double Ship Configuration
// ========================================================================
/// @section Double Ship Mode
/// @description Indicates if the ship is in single or dual fighter mode
///              Affects shooting power, movement boundaries, and collision detection
/// 
/// When in DOUBLE mode:
///   • Two fighters are drawn (main + docked fighter)
///   • Max missiles increases from 2 to 4
///   • Movement boundary is adjusted (SHIP_MAX_X - SHIP_SPACE) to prevent second fighter from going off-screen
///   • If one fighter is destroyed, mode reverts to SINGLE (no life loss)
/// ========================================================================

/// @var shotMode - Current shooting configuration (ShotMode.SINGLE or ShotMode.DOUBLE)
///                 Initialized to SINGLE - player starts with one fighter
shotMode = ShotMode.SINGLE;

// ========================================================================
// SHIP REGAIN LOGIC - Legacy Feature (Currently Unused)
// ========================================================================
/// @section Ship Regain Logic
/// @description Flag for regaining a ship after rescue (legacy feature)
///              Triggered when a boss carrying a fighter is destroyed in specific conditions
///              Currently set to 0 and not actively used in current game logic
/// ========================================================================

/// @var regain - Flag for regaining a ship after rescue (0 = not regaining, 1 = regaining)
///               Reserved for future use or legacy compatibility
regain = 0;

// ========================================================================
// BEAM CAPTURE SYSTEM - Player Capture & Rescue Mechanics
// ========================================================================
/// @section Beam Capture System
/// @description Variables for handling player capture by enemy tractor beams
///              and the rescue sequence when the captor is destroyed
/// 
/// Capture Sequence:
///   1. Enemy (TIE Intercepter) uses beam weapon to capture player
///   2. shipState changes to CAPTURED
///   3. captor variable stores reference to capturing enemy
///   4. Player follows captor's position (handled in enemy object)
///   5. When captor is destroyed, shipState changes to RELEASING
///   6. Rescued fighter descends from captor's position to dock with player
///   7. Once docked, shotMode changes to DOUBLE (dual fighter mode)
/// 
/// @related oEnemyBase/Step_0.gml - Enemy capture logic
/// @related Step_0.gml - RELEASING state handling
/// ========================================================================

/// @var captor - Instance ID reference to the enemy object that captured this player
///               Set by enemy when capture beam connects
///               Set to noone when player is released or captor is destroyed
///               Used to track position and determine rescue conditions
captor = noone;

/// @var rescued_fighter_x - X coordinate of the rescued fighter during RELEASING animation
///                          Starts at captor's X position when rescue begins
///                          Smoothly interpolates toward player's x + DUAL_FIGHTER_OFFSET_X
///                          Used only during RELEASING state in Step_0.gml and Draw_0.gml
rescued_fighter_x = 0;

/// @var rescued_fighter_y - Y coordinate of the rescued fighter during RELEASING animation
///                          Starts at captor's Y position when rescue begins
///                          Moves downward toward player's Y position
///                          When within 64 pixels of player, docking completes
///                          Used only during RELEASING state in Step_0.gml and Draw_0.gml
rescued_fighter_y = 0;

// ========================================================================
// SHIELD SYSTEM - Invincibility Power-Up
// ========================================================================
/// @section Shield System
/// @description Shield pickup system that grants temporary invincibility.
///              Shield timer ranges from 0 to 5, where 5 is maximum capacity.
///              When S key is pressed, shield activates and drains the timer.
/// 
/// Shield Mechanics:
///   • isShieldActive: Flag indicating if shield is currently active
///   • shieldTimer: Shield capacity (0 to 5 scale, where 5 is maximum)
///   • When S key is pressed: Shield activates if shieldTimer > 0
///   • While active: Player is invincible to enemy shots, shieldTimer drains
///   • Drain rate: 1 per second (1/60 per frame at 60 FPS)
///   • Visual: Glowing circular shield effect around player ship + health bar
/// ========================================================================

/// @var isShieldActive - Flag indicating if shield power-up is currently active
///                       When true, player is invincible to enemy shots
///                       Set to true when S key is pressed (if shieldTimer > 0)
///                       Set to false when shield timer reaches 0 or S key released
isShieldActive = false;

/// @var shieldTimer - Shield capacity value (0 to 5 scale, where 5 is maximum)
///                    Ranges from 0 (empty) to 5 (full capacity)
///                    Drains at 1 per second (1/60 per frame) when shield is active
///                    Increased when shield pickup is collected
///                    Clamped to maximum of 5
shieldTimer = 0;