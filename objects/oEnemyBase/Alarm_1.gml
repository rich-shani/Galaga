/// @description ENEMY SHOOTING TIMER
/// Controls enemy shot frequency during gameplay.
///
/// This alarm is set in Step_0.gml at specific intervals (60, 40, 20 frames) to
/// create a timed firing pattern. The alarm creates enemy shots when conditions are met.
///
/// Shooting conditions:
///   • Game must be in GAME_ACTIVE state
///   • Player must be ACTIVE (not dead, captured, or respawning)
///   • Maximum 8 enemy shots on screen (prevents bullet spam)
///   • Shot difficulty level (global.shotnumber) must be > 3
///
/// Shot difficulty (global.shotnumber) increases as game progresses:
///   • Higher values = more frequent shots
///   • Value checked multiple times per alarm cycle in Step_0.gml
///
/// @related oEnemyBase/Step_0.gml:69-81 - Where this alarm is set
/// @related EnemyShot object - The projectile created by this event

if (global.gameMode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == _ShipState.ACTIVE) {
	// Check if we can spawn more shots (limit 8 concurrent enemy shots)
	if instance_number(EnemyShot) < 8{
		// Only shoot if difficulty level is high enough
		if global.shotnumber > 3 {
			instance_create(x,y,EnemyShot);
		}
	}
}