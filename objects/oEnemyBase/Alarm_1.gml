/// @description ENEMY SHOOTING TIMER
/// Controls enemy shot frequency during gameplay.
///
/// This alarm is set in Step_0.gml at specific intervals (60, 40, 20 frames) to
/// create a timed firing pattern. The alarm creates enemy shots when conditions are met.
///
/// Shooting conditions:
///   • Game must be in GAME_ACTIVE state
///   • Player must be ACTIVE (!dead, captured, || respawning)
///   • Maximum 8 enemy shots on screen (prevents bullet spam)
///   • Shot difficulty level (global.Game.Enemy.shotNumber) must be > 3
///
/// Shot difficulty (global.Game.Enemy.shotNumber) increases as game progresses:
///   • Higher values = more frequent shots
///   • Value checked multiple times per alarm cycle in Step_0.gml
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode && MAX_ENEMY_SHOTS constant
///
/// @related oEnemyBase/Step_0.gml:56-67 - Where this alarm is set
/// @related EnemyShot object - The projectile created by this event

if (global.Game.State.mode == GameMode.GAME_ACTIVE && instance_exists(oPlayer) && oPlayer.shipStatus == ShipState.ACTIVE) {
	// Check if we can spawn more shots (limit MAX_ENEMY_SHOTS concurrent enemy shots)
	 if (global.Game.Enemy.shotNumber < MAX_ENEMY_SHOTS) {
		// Only shoot if difficulty level is high enough
		if global.Game.Enemy.shotNumber > 3 {
			// Use object pool if available for better performance
			if (global.shot_pool != undefined) {
				global.shot_pool.acquire(x, y);
			} else {
				instance_create_layer(x, y, "GameSprites", oEnemyShot);
			}
		}
	}
}