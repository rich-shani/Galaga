/// @description Initializes an enemy object and controls its movement behavior in a space shooter game.
/// This script is executed in the Create or Step event of an enemy object (e.g., Bee, Butterfly).
/// It sets up initial variables, assigns movement paths based on wave and pattern, and manages rogue enemy behavior.
/// The code assumes the existence of a oGameManager object with variables (e.g., rogueyes, count1, count2, alt),
/// global variables (e.g., global.wave, global.pattern), and predefined paths (e.g., Ent1e1Flip, Rogue1e1).

event_inherited();

/// @section Path Assignment Based on Wave and Pattern
/// Assigns movement paths to the enemy based on global.pattern, global.wave, and rogue status.
/// Paths define how enemies enter or move (e.g., swooping, diving) with a speed of 6 pixels per step.
/// oGameManager.rogueyes determines whether to use standard (Ent*) or rogue (Rogue*) paths.
if (oGameManager.rogueyes == 0) {
	
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

	// input global.pattern, global.wave, and oGameManager.alt to determine path
	// use data/oTieFighter.json for pattern reference
	// assign_enemy_path("Patterns/oTieFighter.json", global.pattern, global.wave, oGameManager.alt);

	if (PATH_NAME != noone) {
		// NEW CODE
		var path_id = asset_get_index(PATH_NAME);
		if (path_id != -1) path_start(path_id, 6*global.scale, 0, 0);
		
		// just use INDEX and we can remove numb ...
		numb = INDEX;
	}
	else {
		
	    /// @subsection Pattern 0
	    /// Standard enemy paths for pattern 0, typically a specific formation or entry sequence.
	    if (global.pattern == 0) {
	        // Wave 0: Start the enemy on the Ent1e1Flip path (flipped entry path 1).
	        if (global.wave == 0) { path_start(Ent1e1Flip, 6*global.scale, 0, 0); }
	        // Wave 1: Start on the Ent1e2 path (second entry path).
	        if (global.wave == 1) { path_start(Ent1e2, 6*global.scale, 0, 0); }
	        // Wave 2: Start on the Ent1e2Flip path (flipped second entry path).
	        if (global.wave == 2) { path_start(Ent1e2Flip, 6*global.scale, 0, 0); }
	    }
 
	    /// @subsection Pattern 1
	    /// Standard enemy paths for pattern 1, possibly a different formation or behavior.
	    if (global.pattern == 1) {
	        // Wave 0: Start on the Ent1e1 path (first entry path).
	        if (global.wave == 0) { path_start(Ent1e1, 6*global.scale, 0, 0); }
	        // Wave 1: Start on the Ent2e2In path (second entry path with inward movement).
	        if (global.wave == 1) { path_start(Ent2e2In, 6*global.scale, 0, 0); }
	        // Wave 2: Choose between Ent2e2Flip (flipped) or Ent2e2InFlip based on oGameManager.alt.
	        // oGameManager.alt toggles alternate behavior (0 = normal, 1 = alternate).
	        if (global.wave == 2) {
	            if (oGameManager.alt == 0) { path_start(Ent2e2Flip, 6*global.scale, 0, 0); }
	            else { path_start(Ent2e2InFlip, 6*global.scale, 0, 0); }
	        }
	    }
 
	    /// @subsection Pattern 2
	    /// Standard enemy paths for pattern 2, likely another distinct formation or sequence.
	    if (global.pattern == 2) {
	        // Wave 0: Start on the Ent1e1Flip path.
	        if (global.wave == 0) { path_start(Ent1e1Flip, 6*global.scale, 0, 0); }
	        // Wave 1: Start on the Ent1e2Flip path.
	        if (global.wave == 1) { path_start(Ent1e2Flip, 6*global.scale, 0, 0); }
	        // Wave 2: Choose between Ent1e2 or Ent1e2Flip based on oGameManager.alt.
	        if (global.wave == 2) {
	            if (oGameManager.alt == 0) { path_start(Ent1e2, 6*global.scale, 0, 0); }
	            else { path_start(Ent1e2Flip, 6*global.scale, 0, 0); }
	        }
		} else {
		    /// @subsection Rogue Paths
		    /// Rogue enemy paths, used when oGameManager.rogueyes == 1 for unique or aggressive behaviors.
		    if (global.pattern == 0) {
		        // Wave 0: Start on the Rogue1e1Flip path.
		        if (global.wave == 0) { path_start(Rogue1e1Flip, 6*global.scale, 0, 0); }
		        // Wave 1: Start on the Rogue1e2 path.
		        if (global.wave == 1) { path_start(Rogue1e2, 6*global.scale, 0, 0); }
		        // Wave 2: Start on the Rogue1e2Flip path.
		        if (global.wave == 2) { path_start(Rogue1e2Flip, 6*global.scale, 0, 0); }
		    }

		    if (global.pattern == 1) {
		        // Wave 0: Start on the Rogue1e1 path.
		        if (global.wave == 0) { path_start(Rogue1e1, 6*global.scale, 0, 0); }
		        // Wave 1: Start on the Rogue2e2In path.
		        if (global.wave == 1) { path_start(Rogue2e2In, 6*global.scale, 0, 0); }
		        // Wave 2: Choose between Rogue2e2Flip or Rogue2e2InFlip based on oGameManager.alt.
		        if (global.wave == 2) {
		            if (oGameManager.alt == 0) { path_start(Rogue2e2Flip, 6*global.scale, 0, 0); }
		            else { path_start(Rogue2e2InFlip, 6*global.scale, 0, 0); }
		        }
		    }

		    if (global.pattern == 2) {
		        // Wave 0: Start on the Rogue1e1Flip path.
		        if (global.wave == 0) { path_start(Rogue1e1Flip, 6*global.scale, 0, 0); }
		        // Wave 1: Start on the Rogue1e2Flip path.
		        if (global.wave == 1) { path_start(Rogue1e2Flip, 6*global.scale, 0, 0); }
		        // Wave 2: Choose between Rogue1e2 or Rogue1e2Flip based on oGameManager.alt.
		        if (global.wave == 2) {
		            if (oGameManager.alt == 0) { path_start(Rogue1e2, 6*global.scale, 0, 0); }
		            else { path_start(Rogue1e2Flip, 6*global.scale, 0, 0); }
		        }
		    } 
		}
		
		/// @section Wave-Specific Counter Updates
		// Update counters and assign numb values based on global.wave and rogue status.
		// numb likely determines the enemy's position or role in the formation.
		if (global.wave == 0) {
		    if (rogue == 0) {
		        // Decrease oGameManager.count2 to track the number of enemies in the wave.
		        oGameManager.count2 -= 1;
		        // Assign numb based on oGameManager.count2 to define the enemy's position.
		        if (oGameManager.count2 == 3) { numb = 2; }
		        if (oGameManager.count2 == 2) { numb = 4; }
		        if (oGameManager.count2 == 1) { numb = 6; }
		        if (oGameManager.count2 == 0) { numb = 8; }
		    } else {
		        // For rogue enemies, decrease oGameManager.rogue2 to track rogue enemy counts.
		        oGameManager.rogue2 -= 1;
		    }
		}

		if (global.wave == 1) {
		    if (rogue == 0) {
		        // Decrease oGameManager.count2 for non-rogue enemies.
		        oGameManager.count2 -= 1;
		        // Assign higher numb values for wave 1 to position enemies differently.
		        if (oGameManager.count2 == 3) { numb = 10; }
		        if (oGameManager.count2 == 2) { numb = 12; }
		        if (oGameManager.count2 == 1) { numb = 14; }
		        if (oGameManager.count2 == 0) { numb = 16; }
		    } else {
		        // Decrease oGameManager.rogue2 for rogue enemies.
		        oGameManager.rogue2 -= 1;
		    }
		}

		if (global.wave == 2) {
		    if (oGameManager.alt == 0) {
		        if (rogue == 0) {
		            // Decrease oGameManager.count1 for non-rogue enemies when oGameManager.alt is 0.
		            oGameManager.count1 -= 1;
		            // Assign numb values for wave 2, starting at 17.
		            if (oGameManager.count1 == 3) { numb = 17; }
		            if (oGameManager.count1 == 2) { numb = 19; }
		            if (oGameManager.count1 == 1) { numb = 21; }
		            if (oGameManager.count1 == 0) { numb = 23; }
		        } else {
		            // Decrease oGameManager.rogue1 for rogue enemies.
		            oGameManager.rogue1 -= 1;
		        }
		    } else {
		        if (rogue == 0) {
		            // Decrease oGameManager.count2 for non-rogue enemies when oGameManager.alt is 1.
		            oGameManager.count2 -= 1;
		            // Assign different numb values for alternate wave 2 behavior.
		            if (oGameManager.count2 == 3) { numb = 18; }
		            if (oGameManager.count2 == 2) { numb = 20; }
		            if (oGameManager.count2 == 1) { numb = 22; }
		            if (oGameManager.count2 == 0) { numb = 24; }
		        } else {
		            // Decrease oGameManager.rogue2 for rogue enemies.
		            oGameManager.rogue2 -= 1;
		        }
		    }
		}
	}
}

/// @section Timing Fix
// Set the timey variable to 90 steps (approximately 1.5 seconds at 60 FPS).
// Likely used to control the timing of enemy actions or path transitions (commented as "time attempt fix").
timey = 90;

/// @section Rogue Behavior Activation
// If oGameManager.rogueyes == 1, mark this enemy as rogue and reset oGameManager.rogueyes to 0.
// Ensures only one enemy processes the rogue state activation.
//if (oGameManager.rogueyes == 1) {
//    rogue = 1;
//    oGameManager.rogueyes = 0;
//}


/// @section Fast Entry Adjustment
// If global.fastenter == 1, adjust timing variables for faster enemy entry.
// fasty set to 50 steps and timey to 63 steps to speed up entry animations.
if (global.fastenter == 1) {
    fasty = 50;
    timey = 63;
}