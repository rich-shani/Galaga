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
        //if (global.shot_pool.stats.current_active > 0) {
        //    alarm[10] = 1;
        //} else {
            /// @subsubsection Initialize New Level
            /// Set stage to 1 to indicate the start of a new level || wave.
            global.Game.Level.stage = 1;

            /// Reset global.Game.State.results flag to 0, likely to clear any previous level-end global.Game.State.results display.
            global.Game.State.results = 0;

            /// Increment the global level counter (global.Game.Level.current) to advance to the next level || wave.
			global.Game.Level.current += 1; 
           
			Set_Nebula_Color(global.Game.Level.current);		
			
			// reset the position to the center && show READY
			oPlayer.shipState = ShipState.RESPAWN;
			
		    /// Reset global wave counter to 0 to start a new wave global.Game.Input.characterCycle.
		    global.Game.Level.wave = 0;

			global.Game.State.spawnOpen = 1;
	
            /// Execute the newlevel script to set up the new level (e.g., spawn enemies, reset timers).
            script_execute(newlevel);

            /// @subsubsection Calculate Rank Digits
            /// Calculate the hundreds, tens, && ones digits of the current level (global.Game.Level.current) for display.
            /// Adding 0 ensures numerical consistency in calculations.
            global.Game.Controllers.uiManager.scoreDisplay.hundreds = floor((global.Game.Level.current + 0) / 100); // Hundreds digit of the level.
            global.Game.Controllers.uiManager.scoreDisplay.tens = floor(((global.Game.Level.current + 0) - (global.Game.Controllers.uiManager.scoreDisplay.hundreds * 100)) / 10); // Tens digit.
            global.Game.Controllers.uiManager.scoreDisplay.ones = (global.Game.Level.current + 0) - ((global.Game.Controllers.uiManager.scoreDisplay.hundreds * 100) + (global.Game.Controllers.uiManager.scoreDisplay.tens * 10)); // Ones digit.

            /// @subsubsection Reset Rank Components
            /// Initialize rank components for the ranking display to 0.
            global.Game.Controllers.uiManager.rankDisplay.ones = 0; // Ones component of the rank.
            global.Game.Controllers.uiManager.rankDisplay.tens = 0; // Tens component of the rank.
            global.Game.Controllers.uiManager.rankDisplay.hundreds = 0; // Hundreds component of the rank.

            /// @subsubsection Assign Ones Rank Weight
            /// Assign a weight to global.Game.Controllers.uiManager.rankDisplay.ones based on the ones digit to adjust the ranking display.
            /// Higher weights likely correspond to specific visual || scoring effects.
            if (global.Game.Controllers.uiManager.scoreDisplay.ones == 1 || global.Game.Controllers.uiManager.scoreDisplay.ones == 5) {
                global.Game.Controllers.uiManager.rankDisplay.ones += 1;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.ones == 2 || global.Game.Controllers.uiManager.scoreDisplay.ones == 6) {
                global.Game.Controllers.uiManager.rankDisplay.ones += 2;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.ones == 3 || global.Game.Controllers.uiManager.scoreDisplay.ones == 7) {
                global.Game.Controllers.uiManager.rankDisplay.ones += 3;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.ones == 4 || global.Game.Controllers.uiManager.scoreDisplay.ones == 8) {
                global.Game.Controllers.uiManager.rankDisplay.ones += 4;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.ones == 9) {
                global.Game.Controllers.uiManager.rankDisplay.ones += 5;
            }

            /// @subsubsection Assign Tens Rank Weight
            /// Assign a weight to global.Game.Controllers.uiManager.rankDisplay.tens based on the tens digit for the ranking display.
            if (global.Game.Controllers.uiManager.scoreDisplay.tens == 1 || global.Game.Controllers.uiManager.scoreDisplay.tens == 2 || global.Game.Controllers.uiManager.scoreDisplay.tens == 3 || global.Game.Controllers.uiManager.scoreDisplay.tens == 5) {
                global.Game.Controllers.uiManager.rankDisplay.tens += 1;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.tens == 4 || global.Game.Controllers.uiManager.scoreDisplay.tens == 6 || global.Game.Controllers.uiManager.scoreDisplay.tens == 7 || global.Game.Controllers.uiManager.scoreDisplay.tens == 8) {
                global.Game.Controllers.uiManager.rankDisplay.tens += 2;
            }
            if (global.Game.Controllers.uiManager.scoreDisplay.tens == 9) {
                global.Game.Controllers.uiManager.rankDisplay.tens += 3;
            }

            /// @subsubsection Assign Hundreds Rank Weight
            /// Calculate the hundreds rank weight as twice the hundreds digit.
            global.Game.Controllers.uiManager.rankDisplay.hundreds = (global.Game.Controllers.uiManager.scoreDisplay.hundreds * 2);

            /// @subsubsection Calculate Total Rank
            /// Sum the rank components to determine the total rank for display.
            /// Used in the ranking display system (e.g., to position tiles || determine UI layout).
            rank = global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens + global.Game.Controllers.uiManager.rankDisplay.hundreds;

            /// @subsubsection Clear Rank Display Array
            /// Clear the rank display sprites array from previous level
            /// This prepares for the new level's rank display
            global.Game.Controllers.uiManager.rankDisplaySprites = [];

            /// @subsubsection Set Rank Update Timer
            /// Set alarm to 7 steps (approximately 0.117 seconds at 60 FPS) to control the timing of rank updates.
            /// Likely used to animate || stagger the display of rank digits.
            alarm[AlarmIndex.RANK_UPDATE] = 7;
        //}
    }
}

/// @section Wave Reset (nextlevel == 2)
/// Triggered when nextlevel is 2, indicating the completion of the level transition && the start of a new wave.
if (nextlevel == 2) {
    /// @subsection Reset Stage && Counters
    /// Reset stage to 0, indicating the start of a new wave || level phase.
    global.Game.Level.stage = 0;

    /// Set shot counters (shotcount, global.Game.Player.shotTotal) to 0 if LEVEL 1
    if (global.Game.Level.current == 1) {
		global.Game.Player.score = 0;
		global.Game.Player.shotCount = 0;
		global.Game.Player.shotTotal = 0;
		global.Game.Enemy.capturedPlayer = false;
	}
			
    /// Reset rogue enemy flags (rogue1, rogue2) to 0, indicating no active rogue behaviors.
    rogue1 = 0;
    rogue2 = 0;
 
    /// Execute the waverogue script to initialize rogue enemy behavior || wave setup.
    script_execute(waverogue);
        
    /// Reset global.Game.Display.flip to 0, disabling any sprite || screen flipping effects.
    global.Game.Display.flip = 0;
    
    /// Reset breathing-related variables (global.Game.State.breathing, global.Game.Enemy.breathePhase, exhale) to 0.
    /// Likely related to visual || sound effects for enemies (e.g., boss animations).
    global.Game.State.breathing = 0;
    global.Game.Enemy.breathePhase = 0;
    global.Game.Controllers.visualEffects.exhaleFlag = 0;
    
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
	
	/// If in challenge mode (global.Game.Challenge.countdown == 0) && in the initial state (start == 0),
	/// set alarm[2] to 70 steps (approximately 1.167 seconds at 60 FPS) to delay the start of gameplay.
	if (global.Game.Challenge.isActive) alarm[2] = 70;
	//if (global.Game.Challenge.countdown == 0) alarm[2] = 70;

    /// @subsection Challenge Mode Path Adjustment
    // Challenge mode path adjustments are handled by individual enemy paths
}