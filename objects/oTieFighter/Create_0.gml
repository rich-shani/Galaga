/// This script is executed in the Create or Step event of an enemy object (e.g., Bee, Butterfly).
/// It sets up initial variables, assigns movement paths based on wave and pattern, and manages rogue enemy behavior.
/// The code assumes the existence of a oGameManager object with variables (e.g., rogueyes, count1, count2, alt),
/// global variables (e.g., global.wave, global.pattern), and predefined paths (e.g., Ent1e1Flip, Rogue1e1).
event_inherited();

/// @section Path Assignment Based on Wave and Pattern
/// Assigns movement paths to the enemy based on global.pattern, global.wave, and rogue status.
/// Paths define how enemies enter or move (e.g., swooping, diving) with a speed of 6 pixels per step.
/// oGameManager.rogueyes determines whether to use standard (Ent*) or rogue (Rogue*) paths.

if (global.challcount > 0) { // If not in challenge stage

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
	
	// --- STANDARD ENEMY PATHS ---

	// input global.pattern, global.wave, and oGameManager.alt to determine path
	// use data/oTieFighter.json for pattern reference
	// assign_enemy_path("Patterns/oTieFighter.json", global.pattern, global.wave, oGameManager.alt);

	if (PATH != noone) {
		// NEW CODE
		var path_id = asset_get_index(PATH);
		if (path_id != -1) path_start(path_id, 6*global.scale, 0, 0);
		
		// just use INDEX and we can remove numb ...
		numb = INDEX;
	}
	else {
		
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
