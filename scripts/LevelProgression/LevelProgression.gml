/// @file LevelProgression.gml
/// @description Level advancement and extra life management functions
///
/// FUNCTIONS:
///   - checkForExtraLives() - Awards extra lives at score milestones
///   - readyForNextLevel() - Validates conditions for level progression
///
/// RELATED FILES:
///   - objects/oGameManager - Calls these functions during game loop
///   - scripts/GameConstants.gml - Defines EXTRA_LIFE thresholds
///
/// IMPORTANT: These functions rely on being called from oGameManager context
///            where instance variables (alarm, nextlevel) are available

/// @function checkForExtraLives
/// @description Checks if the player has reached score milestones and awards extra lives
///              Tracks milestones using global.Game.Player.firstlife and .additional
///              First life at EXTRA_LIFE_FIRST_THRESHOLD (default 20,000)
///              Subsequent lives at EXTRA_LIFE_ADDITIONAL_THRESHOLD intervals (default 70,000)
///              Stops awarding lives after MAX_SCORE_FOR_EXTRA_LIVES (default 1,000,000)
///
/// NOTE: Must be called from oGameManager context
///
/// @return {undefined}
function checkForExtraLives() {
	// === EXTRA LIFE THRESHOLD LOGIC ===
	// Award life if:
	//   1. Score > firstlife threshold
	//   2. Score < max score limit (prevents infinite lives)
	//   3. Player hasn't reached max lives cap

	var max_score = get_config_value("SCORE", "MAX_SCORE_FOR_EXTRA_LIVES", MAX_SCORE_FOR_EXTRA_LIVES);

	if (global.Game.Player.score > global.Game.Player.firstlife &&
	    global.Game.Player.score < max_score) {

	    // === RESET FIRST LIFE MARKER ===
	    // After awarding first life at 20k, reset the marker to 0
	    // This ensures the threshold calculation works correctly
	    if (global.Game.Player.firstlife == EXTRA_LIFE_FIRST_THRESHOLD) {
	        global.Game.Player.firstlife = 0;
	    }

	    // === INCREMENT THRESHOLD ===
	    // Move to next threshold (e.g., 20k -> 90k -> 160k -> 230k)
	    global.Game.Player.firstlife += global.Game.Player.additional;

	    // === AWARD EXTRA LIFE ===
	    sound_play(GLife);  // Play extra life sound effect
	    global.Game.Player.lives += 1;

	    // === LOG FOR DEBUG ===
	    log_error("Extra life awarded at score: " + string(global.Game.Player.score), "checkForExtraLives", 1);
	}
}

/// @function readyForNextLevel
/// @description Validates that all conditions are met for advancing to the next level
///              Ensures no active spawning, all enemies cleared, and player is ready
///
/// CONDITIONS CHECKED:
///   1. Level advance alarm not already running
///   2. All enemies cleared (count == 0)
///   3. Not already transitioning (nextlevel == 0)
///   4. Spawn window closed (spawnOpen == 0)
///   5. Player exists and is in ACTIVE state
///   6. Game is in GAME_ACTIVE mode
///
/// NOTE: Must be called from oGameManager context where alarm[] and nextlevel exist
///
/// @return {Bool} True if transitioning to next level, false otherwise
function readyForNextLevel() {
	// === EARLY EXIT: ALREADY TRANSITIONING ===
	// If alarm[LEVEL_ADVANCE] is already set, we're transitioning
	if (alarm[AlarmIndex.LEVEL_ADVANCE] != -1) {
		return true;
	}

	// === CONDITION 1: ALL ENEMIES CLEARED ===
	var allEnemiesCleared = (global.Game.Enemy.count == 0);

	// === CONDITION 2: NOT ALREADY TRANSITIONING ===
	var notTransitioning = (nextlevel == 0);

	// === CONDITION 3: SPAWN WINDOW CLOSED ===
	var spawnComplete = (global.Game.State.spawnOpen == 0);

	// === CONDITION 4: PLAYER READY ===
	var playerReady = instance_exists(oPlayer) &&
	                  (oPlayer.shipStatus == ShipState.ACTIVE);

	// === CONDITION 5: GAME IN ACTIVE MODE ===
	var gameActive = (global.Game.State.mode == GameMode.GAME_ACTIVE);

	// === CHECK ALL CONDITIONS ===
	if (allEnemiesCleared && notTransitioning && spawnComplete && playerReady && gameActive) {

		// === TRIGGER LEVEL TRANSITION ===
		// Set nextlevel flag to 1 to indicate transition starting
		// This skips the 'PLAYER 1' message above STAGE 1 on subsequent levels
		nextlevel = 1;

		// === SET ALARM FOR LEVEL ADVANCE ===
		// Alarm[LEVEL_ADVANCE] handles the actual level increment and setup
		alarm[AlarmIndex.LEVEL_ADVANCE] = 1;

		// === SET FORMATION SPAWN TIMER ===
		// 90 frames delay before enemies start spawning in new level
		alarm[AlarmIndex.SPAWN_FORMATION_TIMER] = 90;

		return true;
	}

	return false;
}
