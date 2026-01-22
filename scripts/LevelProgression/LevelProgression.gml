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
/// REFACTORED: Now accepts manager state as parameters for testability
///
/// @param {Real} _alarm_level_advance Current value of alarm[AlarmIndex.LEVEL_ADVANCE]
/// @param {Real} _nextlevel Current value of nextlevel flag
/// @return {Struct|undefined} Struct with {shouldAdvance, alarmLevelAdvance, alarmSpawnTimer, nextlevel} or undefined if not ready
function readyForNextLevel(_alarm_level_advance, _nextlevel) {
	// === EARLY EXIT: ALREADY TRANSITIONING ===
	// If alarm[LEVEL_ADVANCE] is already set, we're transitioning
	//if (_alarm_level_advance != -1) {
	//	return { shouldAdvance: true, alarmLevelAdvance: _alarm_level_advance, alarmSpawnTimer: -1, nextlevel: _nextlevel };
	//}

	// === CONDITION 1: ALL ENEMIES CLEARED ===
	var allEnemiesCleared = (global.Game.Enemy.count == 0);

	// === CONDITION 2: NOT ALREADY TRANSITIONING ===
	var notTransitioning = (_nextlevel == 0);

	// === CONDITION 3: SPAWN WINDOW CLOSED ===
	var spawnComplete = (global.Game.State.spawnOpen == 0);

	// === CONDITION 4: PLAYER READY ===
	var playerReady = instance_exists(oPlayer) &&
	                  (oPlayer.shipState == ShipState.ACTIVE);

	// === CONDITION 5: GAME IN ACTIVE MODE ===
	var gameActive = (global.Game.State.mode == GameMode.GAME_ACTIVE);

	// === CHECK ALL CONDITIONS ===
	if (allEnemiesCleared && notTransitioning && spawnComplete && playerReady && gameActive) {

		// === TRIGGER LEVEL TRANSITION ===
		// Return struct with values to set in caller
		return {
			shouldAdvance: true,
			alarmLevelAdvance: 1,                    // Alarm[LEVEL_ADVANCE] handles the actual level increment
			alarmSpawnTimer: LEVEL_SPAWN_DELAY,      // Frames delay before enemies start spawning
			nextlevel: 1                              // Flag to indicate transition starting
		};
	}

	return undefined;  // Not ready to advance
}
