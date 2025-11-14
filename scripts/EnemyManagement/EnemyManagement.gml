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
	                       (oPlayer.alarm[4] == -1);

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
    // Check all enemy types in one pass using array iteration
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

/// @function controlEnemyFormation
/// @description Controls the breathing animation && sound for enemy formation
///              Manages the oscillating motion of enemies in formation && syncs
///              the breathing sound effect with visual animation
/// @return {undefined}
function controlEnemyFormation() {
	// Controls breathing motion of a visual/background element && audio

    if global.Game.State.breathing == 0 {
        // Not breathing yet; run animation to transition to breathing

        if global.Game.Controllers.visualEffects.exhaleFlag == 0 {
            x -= 0.5; // Inhale motion (move object left)
            if x == -48 {
                global.Game.Controllers.visualEffects.exhaleFlag = 1; // Switch to exhale
                skip = 1;   // Skip one frame on exhale start
            }
        }

        if global.Game.Controllers.visualEffects.exhaleFlag == 1 && skip == 0 {
            x += 0.5; // Exhale motion (move object right)
            if x == 80 {
                global.Game.Controllers.visualEffects.exhaleFlag = 0; // Loop back to inhale
            }
        }

        skip = 0;

        if global.Game.State.spawnOpen == 0 {
            if x == 16 {
                global.Game.State.breathing = 1; // Begin breathing animation loop
                global.Game.Controllers.visualEffects.exhaleFlag = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Loop breathing sound
            }
        }
    }

    if global.Game.State.breathing == 1 {
        // Active breathing animation && audio logic

        if global.Game.Controllers.visualEffects.exhaleFlag == 0 {
            global.Game.Enemy.breathePhase += BREATHING_RATE; // Simulate inhale rate
            if round(global.Game.Enemy.breathePhase) >= BREATHING_CYCLE_MAX {
                global.Game.Controllers.visualEffects.exhaleFlag = 1;
                exit; // Exit breathing update for this frame
            }
        }

        if global.Game.Controllers.visualEffects.exhaleFlag == 1 {
            global.Game.Enemy.breathePhase -= BREATHING_RATE; // Simulate exhale rate
            if round(global.Game.Enemy.breathePhase) <= 0 {
                global.Game.Controllers.visualEffects.exhaleFlag = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Restart breathing sound
                exit;
            }
        }

        // === BREATHING SOUND VOLUME CONTROL ===
        // OPTIMIZATION: Only check sound state && enemy count periodically (every 10 frames)
        // This reduces expensive function calls from 8 per frame to ~0.8 per frame
        // (5 sound checks + 3 instance_number calls are costly)
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
}