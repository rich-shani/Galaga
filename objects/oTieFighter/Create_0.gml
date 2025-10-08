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
	
	/// @section Fast Entry Adjustment
	// If global.fastenter == 1, adjust timing variables for faster enemy entry.
	// fasty set to 50 steps to speed up entry animations.
    if (global.fastenter == 1) fasty = 50;
}
//else { // --- CHALLENGE STAGE LOGIC ---
//	// Increment the challenge stage enemy counter
//	oGameManager.count += 1

//	// Start the appropriate path if the enemy is at the starting point of a challenge path
//    if (x == path_get_x(oGameManager.path1,0) && y == path_get_y(oGameManager.path1,0))
//        path_start(oGameManager.path1, 6*global.scale, 0, 0);
//    if (x == path_get_x(oGameManager.path1flip,0) && y == path_get_y(oGameManager.path1flip,0))
//        path_start(oGameManager.path1flip, 6*global.scale, 0, 0);
//    if (x == path_get_x(oGameManager.path2,0) && y == path_get_y(oGameManager.path2,0))
//        path_start(oGameManager.path2, 6*global.scale, 0, 0);
//    if (x == path_get_x(oGameManager.path2flip,0) && y == path_get_y(oGameManager.path2flip,0))
//        path_start(oGameManager.path2flip, 6*global.scale, 0, 0);

//	// Special handling for challenge 3: certain enemies switch paths based on their count and wave
//	if global.chall == 3 {
//		switch oGameManager.count {
//			case 2: case 4: case 6: case 8:
//				// For wave 4, switch to path1; for wave 0 or 3, switch to path1flip
//				if global.wave == 4 {
//					path_end();
//					path_start(oGameManager.path1, 6*global.scale, 0, 0)
//				}
//				if global.wave == 0 or global.wave == 3 {
//					path_end();
//					path_start(oGameManager.path1flip, 6*global.scale, 0, 0)
//				}
//				break;
//		}
//	}
//}
