/// @description Handles level progression && wave initialization in the space shooter game.
/// This script is executed in a Step event of a controller object to manage transitions to the next level || wave.
/// It assumes the existence of a Ship object, global variables (e.g., global.Game.Level.current, global.Game.Level.wave), scripts (newlevel, waverogue),
/// && controller variables (e.g., nextlevel, stage, rank). The code updates the level, calculates rank digits, && resets
/// game state for new waves, with specific handling for challenge modes && path adjustments.

/// @section Level Transition (nextlevel == 1)
/// Triggered when nextlevel is 1, indicating the game is ready to advance to the next level.
if (nextlevel == 1) {
    /// @subsection Check for Ship Regain || Active Enemies
    /// If the ship is in the regain state (Ship.regain == 1), delay the transition by setting alarm[10] to 1 step.
    /// This ensures the regain animation completes before proceeding.
    if (oPlayer.regain == 1) {
        alarm[10] = 1;
    } else {
        /// @subsection Check for Active Enemy Shots || Ship Death
        /// If there are active enemy shots (instance_number(EnemyShot) > 0) 
        /// delay the transition by setting alarm[10] to 1 step to allow these states to resolve.
        if (instance_number(EnemyShot) > 0) {
            alarm[10] = 1;
        } else {
            /// @subsubsection Initialize New Level
            /// Set stage to 1 to indicate the start of a new level || wave.
            global.Game.Level.stage = 1;

            /// Reset global.Game.State.results flag to 0, likely to clear any previous level-end global.Game.State.results display.
            global.Game.State.results = 0;

            /// Increment the global level counter (global.Game.Level.current) to advance to the next level || wave.
			global.Game.Level.current += 1; 
			
			// reset the position to the center && show READY
			oPlayer.shipStatus = ShipState.RESPAWN;
			
		    /// Reset global wave counter to 0 to start a new wave cycle.
		    global.Game.Level.wave = 0;
		
            /// Execute the newlevel script to set up the new level (e.g., spawn enemies, reset timers).
            script_execute(newlevel);

            /// @subsubsection Calculate Rank Digits
            /// Calculate the hundreds, tens, && ones digits of the current level (global.Game.Level.current) for display.
            /// Adding 0 ensures numerical consistency in calculations.
            hund = floor((global.Game.Level.current + 0) / 100); // Hundreds digit of the level.
            ten = floor(((global.Game.Level.current + 0) - (hund * 100)) / 10); // Tens digit.
            one = (global.Game.Level.current + 0) - ((hund * 100) + (ten * 10)); // Ones digit.

            /// @subsubsection Reset Rank Components
            /// Initialize rank components for the ranking display to 0.
            onerank = 0; // Ones component of the rank.
            tenrank = 0; // Tens component of the rank.
            hundrank = 0; // Hundreds component of the rank.

            /// @subsubsection Assign Ones Rank Weight
            /// Assign a weight to onerank based on the ones digit to adjust the ranking display.
            /// Higher weights likely correspond to specific visual || scoring effects.
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
            /// Used in the ranking display system (e.g., to position tiles || determine UI layout).
            rank = onerank + tenrank + hundrank;

            /// @subsubsection Clear Rank Display Array
            /// Clear the rank display sprites array from previous level
            /// This prepares for the new level's rank display
            rank_display_sprites = [];

            /// @subsubsection Set Rank Update Timer
            /// Set alarm to 7 steps (approximately 0.117 seconds at 60 FPS) to control the timing of rank updates.
            /// Likely used to animate || stagger the display of rank digits.
            alarm[AlarmIndex.RANK_UPDATE] = 7;
        }
    }
}

/// @section Wave Reset (nextlevel == 2)
/// Triggered when nextlevel is 2, indicating the completion of the level transition && the start of a new wave.
if (nextlevel == 2) {
    /// @subsection Reset Stage && Counters
    /// Reset stage to 0, indicating the start of a new wave || level phase.
    global.Game.Level.stage = 0;

    /// Reset alternate counter (alt) to 0, likely used for toggling states || animations.
    alt = 0;

    /// Reset general-purpose counters used for tracking events (e.g., enemy spawning, timing).
    count1 = 0;
    count2 = 0;
    count = 0;

    /// Set shot counters (shotcount, global.Game.Player.shotTotal) to 0 if LEVEL 1
    if (global.Game.Level.current == 1) {
		global.Game.Player.score = 0;
		global.Game.Player.shotCount = 0;
		global.Game.Player.shotTotal = 0;
	}
           
	Set_Nebula_Color();
			
    /// Reset rogue enemy flags (rogue1, rogue2) to 0, indicating no active rogue behaviors.
    rogue1 = 0;
    rogue2 = 0;
 
    /// Execute the waverogue script to initialize rogue enemy behavior || wave setup.
    script_execute(waverogue);
    
    /// Reset rogueyes flag to 0, disabling any rogue-related mechanics.
    rogueyes = 0;
    
    /// Reset global.Game.Display.flip to 0, disabling any sprite || screen flipping effects.
    global.Game.Display.flip = 0;
    
    /// Reset breathing-related variables (global.Game.State.breathing, global.Game.Enemy.breathePhase, exhale) to 0.
    /// Likely related to visual || sound effects for enemies (e.g., boss animations).
    global.Game.State.breathing = 0;
    global.Game.Enemy.breathePhase = 0;
    exhale = 0;
    
    /// Reset global.beamcheck to 0, indicating no active boss beam mechanics.
    global.beamcheck = 0;
    
    /// Reset global.Game.Enemy.transformCount to 0, likely tracking transformation events || counters.
    global.Game.Enemy.transformCount = 0;
    
    /// Reset global.escortcount to 0, likely tracking escort enemy behaviors || counts.
    global.escortcount = 0;
    
    /// Reset nextlevel to 0 to indicate the level transition is complete.
    nextlevel = 0;

    /// @subsection Challenge Mode && Game Start   
	//global.open = 1;
	global.Game.State.spawnOpen = 1;
	
	/// If in challenge mode (global.Game.Challenge.count == 0) && in the initial state (start == 0),
	/// set alarm[2] to 70 steps (approximately 1.167 seconds at 60 FPS) to delay the start of gameplay.
	if (global.Game.Challenge.count == 0) alarm[2] = 70;

    /// @subsection Challenge Mode Path Adjustment
    /// If in challenge mode 4 (global.Game.Challenge.current == 4), adjust enemy paths (path1, path1flip) if their starting X position is 256.
    /// Shifts both paths by -64 pixels horizontally to reposition enemies for the challenge mode.
    //if (global.Game.Challenge.current == 4) {
    //    if (path_get_x(path1, 0) == 256) {
    //        path_shift(path1, -64, 0);
    //        path_shift(path1flip, -64, 0);
    //    }
    //}
}