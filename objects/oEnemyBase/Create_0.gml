/// @section Enemy Behavior Variables
enum EnemyState {
	ENTER_SCREEN,
	MOVE_INTO_FORMATION,
	IN_FORMATION,
	IN_DIVE_ATTACK,
	IN_LOOP_ATTACK,
	IN_FINAL_ATTACK
}

// spawn new enemy in the ENTER_SCREEN mode
enemyState = EnemyState.ENTER_SCREEN;

enum EnemyMode {
	STANDARD,
	ROGUE
}

enemyMode = EnemyMode.STANDARD;

// Flag to prohibit upward movement, initialized to 0 (0 = allowed, 1 = prohibited).
// Used to restrict enemy movement in specific scenarios.
uprohib = 0;

// Flag indicating if the enemy is an escort, initialized to 0 (0 = not escort, 1 = escort).
// Escorts may have special behaviors, such as accompanying a boss or following unique paths.
escort = 0;

// Direction of the enemy in degrees, initialized to 0.
// Used for movement or orientation, possibly updated during path following or diving.
dir = 0;

// Flag for a second dive behavior, initialized to 0 (0 = inactive, 1 = active).
// Used for specific enemy attack patterns, such as a secondary dive toward the player.
dive2 = 0;

// Speed of the enemy, set to 3 pixels per step.
// Controls the movement speed along paths or during free movement.
spd = 3;

// Flag for transformation state, initialized to 0 (0 = normal, 1 = transformed).
// Used for enemies that change form or behavior (e.g., Butterfly transforming).
trans = 0;

// Flag for shooting or "spitting" behavior, initialized to 0 (0 = not shooting, 1 = shooting).
// Indicates whether the enemy fires projectiles at the player.
spit = 0;

// Additional flag, initialized to 0.
// Purpose unclear; possibly a placeholder or used for specific enemy mechanics.
add = 0;

// Flag indicating if the enemy is a rogue, initialized to 0 (0 = normal, 1 = rogue).
// Rogue enemies may follow unique paths or behaviors compared to standard enemies.
rogue = 0;

// Timer variable, initialized to 0.
// Used to control timing of enemy actions (e.g., shooting, diving).
tim = 0;

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

formation = load_json_datafile("Patterns/formation_coordinates.json");
attributes = load_json_datafile("Patterns/" + ENEMY_NAME + ".json");

if (PATH_NAME != noone) {
	var path_id = asset_get_index(PATH_NAME);
	if (path_id != -1) path_start(path_id, 6*global.scale, 0, 0);
}
	
/// @section Fast Entry Adjustment
// If global.fastenter == 1, adjust timing variables for faster enemy entry.
// fasty set to 50 steps to speed up entry animations.
if (global.fastenter == 1) fasty = 50;
	