/// @description Enemy-Player Collision Handler
/// Processes collision between enemy and player ship when they make contact.
/// Handles damage application based on player's shield status and shot mode.
///
/// Collision Flow:
///   1. Enemy collides with player ship (detected by GameMaker collision system)
///   2. Check if player and game are in valid states for damage
///   3. If shield is not active, trigger player hit processing (alarm[11])
///   4. Enemy processes its own collision damage in Alarm_11.gml
///
/// State Requirements:
///   • Game mode must be GAME_ACTIVE (prevents hits during menus/transitions)
///   • Player shipStatus must be ACTIVE (prevents hits during death/respawn/capture)
///
/// Shield Protection:
///   • If player's shield is active (isShieldActive == true), skip damage
///   • Shield provides temporary invincibility when collected
///   • Shield effect is visual (drawn around player) and functional (blocks damage)
///
/// Damage Processing:
///   • Enemy processes its own damage in Alarm_11.gml (loses hitCount)
///   • Player damage is processed in oPlayer/Alarm_11.gml (loses life or dual fighter)
///   • Both alarms check shield status before applying damage
///
/// Dual Fighter Mode:
///   • In DOUBLE mode, collision can hit either primary or secondary fighter
///   • Alarm[10] handles secondary fighter hits (no life loss)
///   • Alarm[11] handles primary fighter hits (death if single mode)
///
/// @related oEnemyBase/Alarm_11.gml - Enemy collision damage processing
/// @related oPlayer/Alarm_11.gml - Player hit/damage processing
/// @related oPlayer/Alarm_10.gml - Secondary fighter hit processing (DOUBLE mode)

// Check if player is in valid state to be hit
// Must be ACTIVE (not CAPTURED, DEAD, RESPAWN, RELEASING)
// and game must be in GAME_ACTIVE mode (not menu, attract mode, etc.)
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {
	// Process enemy's collision damage (reduces enemy hitCount)
	// This alarm[11] handles the enemy side of the collision
	alarm[11] = 1;

	// ========================================================================
	// SHIELD CHECK - Skip Damage if Player's shield is Active
	// ========================================================================
	// If player has active shield, they are invincible - skip player damage
	// Shield provides visual feedback and prevents all damage sources
	// ========================================================================
	if (!oPlayer.isShieldActive) {
		// Notify the PLAYER that it was HIT
		// Only trigger if player's alarm[11] is not already active (prevents rapid-fire damage)
		if (oPlayer.alarm[11] < 0) {
			oPlayer.alarm[11] = 1;
		}
	}
}
