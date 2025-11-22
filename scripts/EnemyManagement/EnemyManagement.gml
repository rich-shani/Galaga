/// @file EnemyManagement.gml
/// @description Enemy counting, dive capacity management, formation control, && transformation logic
///
/// FUNCTIONS:
///   - nOfEnemies() - Counts active enemy instances
///   - canTransform() - Checks if enemy can undergo transformation
///   - checkDiveCapacity() - Calculates available dive slots for attacking enemies
///   - controlEnemyFormation() - Manages formation breathing animation && sound
///
/// RELATED FILES:
///   - objects/oEnemyBase - Base enemy class that uses these functions
///   - objects/oGameManager - Calls these functions during game loop

/// @function nOfEnemies
/// @description Counts the total number of active enemies using parent object
///              Uses oEnemyBase to automatically include all enemy types
///              This approach scales automatically when new enemy types are added
/// @return {Real} Total count of active enemy instances
function nOfEnemies() {
	// Count all instances of oEnemyBase (includes all enemy types that inherit from it)
	return instance_number(oEnemyBase);
}

/// @function canTransform
/// @description Checks if an enemy can undergo transformation
///              Breaks down complex transformation conditions into logical groups
///              Must be called from enemy instance context (use with statement)
///
/// TRANSFORMATION CONDITIONS:
///   1. Enemy State: Must be in formation
///   2. Game State: Dive capacity available, no prohibitions, spawning complete
///   3. Player State: Active && vulnerable (!invulnerable || firing)
///   4. Enemy Count: Less than 21 enemies on screen
///   5. Random Chance: 1 in 6 probability
///
/// @return {Bool} True if enemy can transform, false otherwise
function canTransform() {
	// === BASIC STATE CHECKS ===
	// Enemy must be in formation to transform
	var inValidState = (enemyState == EnemyState.IN_FORMATION);

	// === GAME STATE CHECKS ===
	// Game must allow transformations (capacity && no active prohibitions)
	var gameReady = (global.Game.Enemy.diveCapacity > 0) &&
	                (global.Game.State.prohibitDive == 0) &&
	                (global.Game.State.spawnOpen == 0);

	// === PLAYER STATE CHECKS ===
	// Player must be active && vulnerable for transformation to make sense
	var playerVulnerable = instance_exists(oPlayer) &&
	                       (oPlayer.shipStatus == ShipState.ACTIVE) &&
	                       (oPlayer.regain == 0) &&
	                       (oPlayer.alarm[PlayerAlarmIndex.TiMER] == -1);

	// === ENEMY COUNT CHECK ===
	// Don't transform if too many enemies already on screen (performance/balance)
	var notTooManyEnemies = global.Game.Enemy.count < 21;

	// === RANDOM CHANCE ===
	// 1 in 6 chance (approximately 16.7% probability)
	var randomChance = (irandom(5) == 0);

	// All conditions must be met for transformation to occur
	return inValidState && gameReady && playerVulnerable && notTooManyEnemies && randomChance;
}

/// @function checkDiveCapacity
/// @description Calculates && updates the available dive capacity for enemies
///              Limits how many enemies can be diving || attacking simultaneously
///              Checks all enemy types && reduces capacity for active divers
///
/// OPTIMIZATION: Uses loop-based approach to check all enemy types
///               Makes it easy to add new enemy types without code duplication
///
/// @return {undefined}
function checkDiveCapacity() {

    // Reset dive cap to its starting value at the beginning of each frame
    global.Game.Enemy.diveCapacity = global.Game.Enemy.diveCapacityStart;

    // === DIVE CAPACITY CALCULATION ===
    // Check all enemy types in global.Game.Controllers.uiManager.scoreDisplay.ones pass using array iteration
    // An enemy consumes dive capacity if:
    //   1. Not in formation (actively diving/attacking)
    //   2. About to dive (alarm[2] is active)

    var enemy_types = [oTieFighter, oTieIntercepter, oImperialShuttle];

    for (var i = 0; i < array_length(enemy_types); i++) {
        with (enemy_types[i]) {
            if (enemyState != EnemyState.IN_FORMATION || alarm[EnemyAlarmIndex.DIVE_ATTACK] > -1) {
                global.Game.Enemy.diveCapacity -= 1;
            }
        }
    }

    // Boss dive cap handling: maximum of 2 bosses can dive
    global.Game.Enemy.bossCap = 2;
}

/// @function _init_breathing_state
/// @description Initializes breathing animation setup phase (before active breathing)
///              Moves formation into position for breathing animation
/// @return {undefined}
function _init_breathing_state() {
	// Run one-time initialization animation

	if global.Game.Controllers.visualEffects.exhaleFlag == 0 {
		x -= 0.5; // Inhale motion (move object left)
		if x == -48 {
			global.Game.Controllers.visualEffects.exhaleFlag = 1; // Switch to exhale
			skip = 1;   // Skip frame on exhale start to synchronize animation
		}
	}

	if global.Game.Controllers.visualEffects.exhaleFlag == 1 && skip == 0 {
		x += 0.5; // Exhale motion (move object right)
		if x == 80 {
			global.Game.Controllers.visualEffects.exhaleFlag = 0; // Loop back to inhale
		}
	}

	skip = 0;

	// Check if animation is complete && ready to start breathing loop
	if global.Game.State.spawnOpen == 0 {
		if x == 16 {
			global.Game.State.breathing = 1; // Begin breathing animation loop
			global.Game.Controllers.visualEffects.exhaleFlag = 0;
			global.Game.Controllers.audioManager.stopSound(GBreathe);
			global.Game.Controllers.audioManager.loopSound(GBreathe); // Loop breathing sound
		}
	}
}

/// @function _update_breathing_phase
/// @description Updates the breathing animation phase (oscillating motion)
///              Handles inhale and exhale cycles
/// @return {undefined}
function _update_breathing_phase() {
	// Update the oscillating phase value for breathing animation

	if global.Game.Controllers.visualEffects.exhaleFlag == 0 {
		// Inhale phase
		global.Game.Enemy.breathePhase += BREATHING_RATE;
		if round(global.Game.Enemy.breathePhase) >= BREATHING_CYCLE_MAX {
			global.Game.Controllers.visualEffects.exhaleFlag = 1;
			exit; // Exit for this frame
		}
	}

	if global.Game.Controllers.visualEffects.exhaleFlag == 1 {
		// Exhale phase
		global.Game.Enemy.breathePhase -= BREATHING_RATE;
		if round(global.Game.Enemy.breathePhase) <= 0 {
			global.Game.Controllers.visualEffects.exhaleFlag = 0;
			global.Game.Controllers.audioManager.stopSound(GBreathe);
			global.Game.Controllers.audioManager.loopSound(GBreathe); // Restart breathing sound
			exit;
		}
	}
}

/// @function _sync_breathing_audio
/// @description Synchronizes breathing sound volume with game state
///              Mutes breathing when action sounds (dive, beam) are playing
///              Only checks every 10 frames for performance
/// @return {undefined}
function _sync_breathing_audio() {
	// OPTIMIZATION: Only check sound state && enemy count periodically (every 10 frames)
	// This reduces expensive function calls from 8 per frame to ~0.8 per frame

	if (global.Game.Level.current % 10 == 0) {
		// Check only critical action sounds (dive && beam) at full volume
		var actionSoundPlaying = sound_isplaying(GDive) || sound_isplaying(GBeam);

		// Use cached enemy count instead of 3 instance_number calls
		var enemyCountHigh = global.Game.Enemy.count > global.Game.State.lastAttack;

		if (!actionSoundPlaying && enemyCountHigh) {
			sound_volume(GBreathe, 1); // Play breathing sound at full volume
		} else {
			sound_volume(GBreathe, 0); // Mute if any action sounds playing
		}
	}
}

/// @function controlEnemyFormation
/// @description Main orchestrator for breathing animation && sound synchronization
///              Routes to specific animation phases based on current state
///
/// FLOW:
///   1. BREATHING_STATE == 0: Initialize breathing (setup animation)
///   2. BREATHING_STATE == 1: Active breathing (oscillation + audio sync)
/// @return {undefined}
function controlEnemyFormation() {
	// Breathing state machine: 0 = initialization, 1 = active breathing

	if global.Game.State.breathing == 0 {
		// Initialization phase: move formation into breathing position
		_init_breathing_state();
	}

	if global.Game.State.breathing == 1 {
		// Active breathing: oscillate && synchronize audio
		_update_breathing_phase();
		_sync_breathing_audio();
	}
}