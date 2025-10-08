/// @section Enemy Behavior Variables

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

// Flag indicating the enemy is entering the screen, initialized to 1 (1 = entering, 0 = positioned).
// Controls whether the enemy is in its initial entry phase.
enter = 1;

// Flag for primary dive behavior, initialized to 1 (1 = diving, 0 = not diving).
// Indicates whether the enemy is performing a dive attack toward the player.
dive = 1;

// Flag indicating if the enemy is a rogue, initialized to 0 (0 = normal, 1 = rogue).
// Rogue enemies may follow unique paths or behaviors compared to standard enemies.
rogue = 0;

// Flag for directing the enemy to a specific target or position, initialized to 0.
// Used for navigation or homing behavior.
goto = 0;

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

formation_positions = load_formation_position("Patterns/formation_coordinates.json");