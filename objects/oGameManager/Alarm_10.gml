/// @description Handles level progression and wave initialization in the space shooter game.
/// This script is executed in a Step event of a controller object to manage transitions to the next level or wave.
/// It assumes the existence of a Ship object, global variables (e.g., global.lvl, global.wave), scripts (newlevel, waverogue),
/// and controller variables (e.g., nextlevel, stage, rank). The code updates the level, calculates rank digits, and resets
/// game state for new waves, with specific handling for challenge modes and path adjustments.

/// @section Level Transition (nextlevel == 1)
/// Triggered when nextlevel is 1, indicating the game is ready to advance to the next level.
if (nextlevel == 1) {
    /// @subsection Check for Ship Regain or Active Enemies
    /// If the ship is in the regain state (Ship.regain == 1), delay the transition by setting alarm[10] to 1 step.
    /// This ensures the regain animation completes before proceeding.
    if (Ship.regain == 1) {
        alarm[10] = 1;
    } else {
        /// @subsection Check for Active Enemy Shots or Ship Death
        /// If there are active enemy shots (instance_number(EnemyShot) > 0) or the ship is shipStatus (Ship.shipStatus > 0),
        /// delay the transition by setting alarm[10] to 1 step to allow these states to resolve.
        if (instance_number(EnemyShot) > 0 || Ship.shipStatus > 0) {
            alarm[10] = 1;
        } else {
            /// @subsubsection Initialize New Level
            /// Set stage to 1 to indicate the start of a new level or wave.
            global.stage = 1;
            
            /// Reset global.results flag to 0, likely to clear any previous level-end global.results display.
            global.results = 0;
            
            /// Increment the global level counter (global.lvl) to advance to the next level or wave.
            global.lvl += 1;
            
			/// set the game state to ACTIVE
			//global.gameMode = GameMode.GAME_ACTIVE;
			
            /// Execute the newlevel script to set up the new level (e.g., spawn enemies, reset timers).
            script_execute(newlevel);

            /// @subsubsection Calculate Rank Digits
            /// Calculate the hundreds, tens, and ones digits of the current level (global.lvl) for display.
            /// Adding 0 ensures numerical consistency in calculations.
            hund = floor((global.lvl + 0) / 100); // Hundreds digit of the level.
            ten = floor(((global.lvl + 0) - (hund * 100)) / 10); // Tens digit.
            one = (global.lvl + 0) - ((hund * 100) + (ten * 10)); // Ones digit.

            /// @subsubsection Reset Rank Components
            /// Initialize rank components for the ranking display to 0.
            onerank = 0; // Ones component of the rank.
            tenrank = 0; // Tens component of the rank.
            hundrank = 0; // Hundreds component of the rank.

            /// @subsubsection Assign Ones Rank Weight
            /// Assign a weight to onerank based on the ones digit to adjust the ranking display.
            /// Higher weights likely correspond to specific visual or scoring effects.
            if (one == 1 || one == 5) {
                onerank += 1;
            }
            if (one == 2 || one == 6) {
                onerank += 2;
            }
            if (one == 3 || one == 7) {
                onerank += 3;
            }
            if (one == 4 || one == 8) {
                onerank += 4;
            }
            if (one == 9) {
                onerank += 5;
            }

            /// @subsubsection Assign Tens Rank Weight
            /// Assign a weight to tenrank based on the tens digit for the ranking display.
            if (ten == 1 || ten == 2 || ten == 3 || ten == 5) {
                tenrank += 1;
            }
            if (ten == 4 || ten == 6 || ten == 7 || ten == 8) {
                tenrank += 2;
            }
            if (ten == 9) {
                tenrank += 3;
            }

            /// @subsubsection Assign Hundreds Rank Weight
            /// Calculate the hundreds rank weight as twice the hundreds digit.
            hundrank = (hund * 2);

            /// @subsubsection Calculate Total Rank
            /// Sum the rank components to determine the total rank for display.
            /// Used in the ranking display system (e.g., to position tiles or determine UI layout).
            rank = onerank + tenrank + hundrank;

            /// @subsubsection Clear Rank Display Layer
            /// Delete the tile layer at depth -10, likely clearing the previous rank display tiles.
            /// This prepares the screen for the new level’s rank or score display.
            tile_layer_delete(-10);

            /// @subsubsection Set Rank Update Timer
            /// Set alarm[1] to 7 steps (approximately 0.117 seconds at 60 FPS) to control the timing of rank updates.
            /// Likely used to animate or stagger the display of rank digits.
            alarm[1] = 7;
        }
    }
}

/// @section Wave Reset (nextlevel == 2)
/// Triggered when nextlevel is 2, indicating the completion of the level transition and the start of a new wave.
if (nextlevel == 2) {
    /// @subsection Reset Stage and Counters
    /// Reset stage to 0, indicating the start of a new wave or level phase.
    global.stage = 0;
    
    /// Reset alternate counter (alt) to 0, likely used for toggling states or animations.
    alt = 0;
    
    /// Reset general-purpose counters used for tracking events (e.g., enemy spawning, timing).
    count1 = 0;
    count2 = 0;
    count = 0;
    
    /// Reset shot counters (shotcount, global.shottotal) to 0, likely tracking shots fired or hit accuracy.
    global.shotcount = 0;
    global.shottotal = 0;
    
    /// Reset rogue enemy flags (rogue1, rogue2) to 0, indicating no active rogue behaviors.
    rogue1 = 0;
    rogue2 = 0;
    
    /// Reset global wave counter to 0 to start a new wave cycle.
    global.wave = 0;
    
    /// Execute the waverogue script to initialize rogue enemy behavior or wave setup.
    script_execute(waverogue);
    
    /// Reset rogueyes flag to 0, disabling any rogue-related mechanics.
    rogueyes = 0;
    
    /// Reset global.flip to 0, disabling any sprite or screen flipping effects.
    global.flip = 0;
    
    /// Reset breathing-related variables (global.breathing, global.breathe, exhale) to 0.
    /// Likely related to visual or sound effects for enemies (e.g., boss animations).
    global.breathing = 0;
    global.breathe = 0;
    exhale = 0;
    
    /// Reset global.transform to 0, disabling any transformation mechanics (e.g., enemy transformations).
    global.transform = 0;
    
    /// Reset global.beamcheck to 0, indicating no active boss beam mechanics.
    global.beamcheck = 0;
    
    /// Reset global.transcount to 0, likely tracking transformation events or counters.
    global.transcount = 0;
    
    /// Reset global.escortcount to 0, likely tracking escort enemy behaviors or counts.
    global.escortcount = 0;
    
    /// Reset nextlevel to 0 to indicate the level transition is complete.
    nextlevel = 0;

    /// @subsection Challenge Mode and Game Start   
	global.open = 1;
	/// If not in challenge mode (global.challcount == 0) and in the initial state (start == 0),
	/// set alarm[2] to 70 steps (approximately 1.167 seconds at 60 FPS) to delay the start of gameplay.
	if (global.challcount == 0) alarm[2] = 70;


    /// @subsection Challenge Mode Path Adjustment
    /// If in challenge mode 4 (global.chall == 4), adjust enemy paths (path1, path1flip) if their starting X position is 256.
    /// Shifts both paths by -64 pixels horizontally to reposition enemies for the challenge mode.
    if (global.chall == 4) {
        if (path_get_x(path1, 0) == 256) {
            path_shift(path1, -64, 0);
            path_shift(path1flip, -64, 0);
        }
    }
}