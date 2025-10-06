/// This script is executed in the Create or Step event of an enemy object (e.g., Bee, Butterfly).
/// It sets up initial variables, assigns movement paths based on wave and pattern, and manages rogue enemy behavior.
/// The code assumes the existence of a oGameManager object with variables (e.g., rogueyes, count1, count2, alt),
/// global variables (e.g., global.wave, global.pattern), and predefined paths (e.g., Ent1e1Flip, Rogue1e1).
event_inherited();

///// @section Enemy Behavior Variables

//// Flag to prohibit upward movement, initialized to 0 (0 = allowed, 1 = prohibited).
//// Used to restrict enemy movement in specific scenarios.
//uprohib = 0;

//// Flag indicating if the enemy is an escort, initialized to 0 (0 = not escort, 1 = escort).
//// Escorts may have special behaviors, such as accompanying a boss or following unique paths.
//escort = 0;

//// Direction of the enemy in degrees, initialized to 0.
//// Used for movement or orientation, possibly updated during path following or diving.
//dir = 0;

//// Flag for a second dive behavior, initialized to 0 (0 = inactive, 1 = active).
//// Used for specific enemy attack patterns, such as a secondary dive toward the player.
//dive2 = 0;

//// Speed of the enemy, set to 3 pixels per step.
//// Controls the movement speed along paths or during free movement.
//spd = 3;

//// Flag for transformation state, initialized to 0 (0 = normal, 1 = transformed).
//// Used for enemies that change form or behavior (e.g., Butterfly transforming).
//trans = 0;

//// Flag for shooting or "spitting" behavior, initialized to 0 (0 = not shooting, 1 = shooting).
//// Indicates whether the enemy fires projectiles at the player.
//spit = 0;

//// Additional flag, initialized to 0.
//// Purpose unclear; possibly a placeholder or used for specific enemy mechanics.
//add = 0;

//// Flag indicating the enemy is entering the screen, initialized to 1 (1 = entering, 0 = positioned).
//// Controls whether the enemy is in its initial entry phase.
//enter = 1;

//// Flag for primary dive behavior, initialized to 1 (1 = diving, 0 = not diving).
//// Indicates whether the enemy is performing a dive attack toward the player.
//dive = 1;

//// Flag indicating if the enemy is a rogue, initialized to 0 (0 = normal, 1 = rogue).
//// Rogue enemies may follow unique paths or behaviors compared to standard enemies.
//rogue = 0;

//// Flag for directing the enemy to a specific target or position, initialized to 0.
//// Used for navigation or homing behavior.
//goto = 0;

//// Timer variable, initialized to 0.
//// Used to control timing of enemy actions (e.g., shooting, diving).
//tim = 0;

//// X-coordinate offset for a breathing animation, initialized to 0.
//// Used for visual effects, such as pulsating or moving enemies (e.g., boss-related).
//breathex = 0;

//// Y-coordinate offset for a breathing animation, initialized to 0.
//// Complements breathex for enemy animation effects.
//breathey = 0;

//// Target X-coordinate for movement, initialized to 0.
//// Used to guide the enemy toward a specific point (e.g., during a dive or goto behavior).
//targx = 0;

//// Target Y-coordinate for movement, initialized to 0.
//// Complements targx for navigation or attack patterns.
//targy = 0;

/// @section Path Assignment Based on Wave and Pattern
/// Assigns movement paths to the enemy based on global.pattern, global.wave, and rogue status.
/// Paths define how enemies enter or move (e.g., swooping, diving) with a speed of 6 pixels per step.
/// oGameManager.rogueyes determines whether to use standard (Ent*) or rogue (Rogue*) paths.

if (global.challcount > 0) { // If not in challenge stage

	// --- STANDARD ENEMY PATHS ---
	if (oGameManager.rogueyes == 0) { // Not a rogue enemy

		/// @subsection Pattern 0
		if (global.pattern == 0) {
			// For waves 0-3, use Ent1e1 path; for wave 4+, use Ent1e1Flip path
			if (global.wave < 4) {
				path_start(Ent1e1, 6*global.scale, 0, 0);
			} else {
				path_start(Ent1e1Flip, 6*global.scale, 0, 0);
			}
		}

		/// @subsection Pattern 1
		if (global.pattern == 1) {
			// For wave 0, use Ent1e1Flip path
			if (global.wave == 0) {
				path_start(Ent1e1Flip, 6*global.scale, 0, 0);
			}
			// For wave 3, alternate between Ent1e1 and Ent2e1 based on oGameManager.alt
			else if (global.wave == 3) {
				if (oGameManager.alt == 0) {
					path_start(Ent1e1, 6*global.scale, 0, 0);
				} else {
					path_start(Ent2e1, 6*global.scale, 0, 0);
				}
			}
			// For wave 4, alternate between Ent1e1Flip and Ent2e1Flip based on oGameManager.alt
			else if (global.wave == 4) {
				if (oGameManager.alt == 0) {
					path_start(Ent1e1Flip, 6*global.scale, 0, 0);
				} else {
					path_start(Ent2e1Flip, 6*global.scale, 0, 0);
				}
			}
		}

		/// @subsection Pattern 2
		if (global.pattern == 2) {
			// For wave 0, use Ent1e1; otherwise, alternate between Ent1e1 and Ent1e1Flip based on oGameManager.alt
			if (global.wave == 0) {
				path_start(Ent1e1, 6*global.scale, 0, 0);
			} else if (oGameManager.alt == 0) {
				path_start(Ent1e1, 6*global.scale, 0, 0);
			} else {
				path_start(Ent1e1Flip, 6*global.scale, 0, 0);
			}
		}
	}
	// --- ROGUE ENEMY PATHS ---
	else {
		/// @subsection Rogue Paths
		if (global.pattern == 0) {
			// For waves 0-3, use Rogue1e1; for wave 4+, use Rogue1e1Flip
			if (global.wave < 4) {
				path_start(Rogue1e1, 6*global.scale, 0, 0);
			} else {
				path_start(Rogue1e1Flip, 6*global.scale, 0, 0);
			}
		}

		if (global.pattern == 1) {
			// For wave 0, use Rogue1e1Flip
			if (global.wave == 0) {
				path_start(Rogue1e1Flip, 6*global.scale, 0, 0);
			}
			// For wave 3, alternate between Rogue1e1 and Rogue2e1 based on oGameManager.alt
			else if (global.wave == 3) {
				if (oGameManager.alt == 0) {
					path_start(Rogue1e1, 6*global.scale, 0, 0);
				} else {
					path_start(Rogue2e1, 6*global.scale, 0, 0);
				}
			}
			// For wave 4, alternate between Rogue1e1Flip and Rogue2e1Flip based on oGameManager.alt
			else if (global.wave == 4) {
				if (oGameManager.alt == 0) {
					path_start(Rogue1e1Flip, 6*global.scale, 0, 0);
				} else {
					path_start(Rogue2e1Flip, 6*global.scale, 0, 0);
				}
			}
		}

		if (global.pattern == 2) {
			// For wave 0, use Rogue1e1; otherwise, alternate between Rogue1e1 and Rogue1e1Flip based on oGameManager.alt
			if (global.wave == 0) {
				path_start(Rogue1e1, 6*global.scale, 0, 0);
			} else {
				if (oGameManager.alt == 0) {
					path_start(Rogue1e1, 6*global.scale, 0, 0);
				} else {
					path_start(Rogue1e1Flip, 6*global.scale, 0, 0);
				}
			}
		}
	}

	/// @section Rogue Behavior Activation
	// If oGameManager.rogueyes == 1, mark this enemy as rogue and reset oGameManager.rogueyes to 0.
	// Ensures only one enemy processes the rogue state activation.
	if (oGameManager.rogueyes == 1) {
		rogue = 1;
		oGameManager.rogueyes = 0;
	}

	/// @section Dive Alarm Setup
	// Set alarm[5] to control the timing of dive behavior for non-rogue enemies.
	// For waves 1 or 2, use 75 steps (1.25 seconds) or 63 steps if global.fastenter == 1 (faster entry).
	// For wave 0, use a shorter 10-step delay (0.167 seconds).
	if (rogue == 0) {
		if (global.wave == 1 || global.wave == 2) {
			alarm[5] = 75;
			if (global.fastenter == 1) { alarm[5] = 63; }
		} else {
			alarm[5] = 10;
		}
	}

	/// @section Wave-Specific Counter Updates
	// Update counters and assign numb values based on global.wave and rogue status.
	// numb likely determines the enemy's position or role in the formation.
	if (global.wave == 0) {
		if (rogue == 0) {
			// Decrease oGameManager.count1 to track the number of enemies in the wave.
			oGameManager.count1 -= 1;
			// Assign numb based on oGameManager.count1 to define the enemy's position.
			if (oGameManager.count1 == 3) { numb = 1; }
			if (oGameManager.count1 == 2) { numb = 3; }
			if (oGameManager.count1 == 1) { numb = 5; }
			if (oGameManager.count1 == 0) { numb = 7; }
		} else {
			// For rogue enemies, decrease oGameManager.rogue1 to track rogue enemy counts.
			oGameManager.rogue1 -= 1;
		}
	}
	else if (global.wave == 3) {
		if (oGameManager.alt == 0) {
			if (rogue == 0) {
				// Decrease oGameManager.count1 for non-rogue enemies when oGameManager.alt is 0.
				oGameManager.count1 -= 1;
				// Assign numb values for wave 3, starting at 25.
				if (oGameManager.count1 == 3) { numb = 25; }
				if (oGameManager.count1 == 2) { numb = 27; }
				if (oGameManager.count1 == 1) { numb = 29; }
				if (oGameManager.count1 == 0) { numb = 31; }
			} else {
				// Decrease oGameManager.rogue1 for rogue enemies.
				oGameManager.rogue1 -= 1;
			}
		} else {
			if (rogue == 0) {
				// Decrease oGameManager.count2 for non-rogue enemies when oGameManager.alt is 1.
				oGameManager.count2 -= 1;
				// Assign different numb values for alternate wave 3 behavior.
				if (oGameManager.count2 == 3) { numb = 26; }
				if (oGameManager.count2 == 2) { numb = 28; }
				if (oGameManager.count2 == 1) { numb = 30; }
				if (oGameManager.count2 == 0) { numb = 32; }
			} else {
				// Decrease oGameManager.rogue2 for rogue enemies.
				oGameManager.rogue2 -= 1;
			}
		}
	}
	else if (global.wave == 4) {
		if (oGameManager.alt == 0) {
			if (rogue == 0) {
				// Decrease oGameManager.count1 for non-rogue enemies when oGameManager.alt is 0.
				oGameManager.count1 -= 1;
				// Assign numb values for wave 4, starting at 33.
				if (oGameManager.count1 == 3) { numb = 33; }
				if (oGameManager.count1 == 2) { numb = 35; }
				if (oGameManager.count1 == 1) { numb = 37; }
				if (oGameManager.count1 == 0) { numb = 39; }
			} else {
				// Decrease oGameManager.rogue1 for rogue enemies.
				oGameManager.rogue1 -= 1;
			}
		} else {
			if (rogue == 0) {
				// Decrease oGameManager.count2 for non-rogue enemies when oGameManager.alt is 1.
				oGameManager.count2 -= 1;
				// Assign different numb values for alternate wave 4 behavior.
				if (oGameManager.count2 == 3) { numb = 34; }
				if (oGameManager.count2 == 2) { numb = 36; }
				if (oGameManager.count2 == 1) { numb = 38; }
				if (oGameManager.count2 == 0) { numb = 40; }
			} else {
				// Decrease oGameManager.rogue2 for rogue enemies.
				oGameManager.rogue2 -= 1;
			}
		}
	}

	/// @section Fast Entry Adjustment
	// If global.fastenter == 1, adjust timing variables for faster enemy entry.
	// fasty set to 50 steps to speed up entry animations.
    if (global.fastenter == 1) fasty = 50;
}
else { // --- CHALLENGE STAGE LOGIC ---
	// Increment the challenge stage enemy counter
	oGameManager.count += 1

	// Start the appropriate path if the enemy is at the starting point of a challenge path
    if (x == path_get_x(oGameManager.path1,0) && y == path_get_y(oGameManager.path1,0))
        path_start(oGameManager.path1, 6*global.scale, 0, 0);
    if (x == path_get_x(oGameManager.path1flip,0) && y == path_get_y(oGameManager.path1flip,0))
        path_start(oGameManager.path1flip, 6*global.scale, 0, 0);
    if (x == path_get_x(oGameManager.path2,0) && y == path_get_y(oGameManager.path2,0))
        path_start(oGameManager.path2, 6*global.scale, 0, 0);
    if (x == path_get_x(oGameManager.path2flip,0) && y == path_get_y(oGameManager.path2flip,0))
        path_start(oGameManager.path2flip, 6*global.scale, 0, 0);

	// Special handling for challenge 3: certain enemies switch paths based on their count and wave
	if global.chall == 3 {
		switch oGameManager.count {
			case 2: case 4: case 6: case 8:
				// For wave 4, switch to path1; for wave 0 or 3, switch to path1flip
				if global.wave == 4 {
					path_end();
					path_start(oGameManager.path1, 6*global.scale, 0, 0)
				}
				if global.wave == 0 or global.wave == 3 {
					path_end();
					path_start(oGameManager.path1flip, 6*global.scale, 0, 0)
				}
				break;
		}
	}
}
