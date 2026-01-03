/// @description Enemy-Player Collision
/// Only process collision if player is in ACTIVE state and game is in GAME_ACTIVE mode.
/// This prevents hits during CAPTURED, DEAD, RESPAWN, or other non-playable states.

// Check if player is in valid state to be hit
// Must be ACTIVE (not CAPTURED, DEAD, RESPAWN, RELEASING)
// and game must be in GAME_ACTIVE mode (not menu, attract mode, etc.)
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {
	// process the collision, using Alarm 11 (as we can also call the hit from the player (DOUBLE SHOT mode)
	alarm[11] = 1;

	// ========================================================================
	// SHIELD CHECK - Skip Damage if Player's shield is Active
	// ========================================================================
	if (!oPlayer.isShieldActive) {
		// Notify the PLAYER that it was HIT
		if (oPlayer.alarm[11] < 0) {
			oPlayer.alarm[11] = 1;
		}
	}
}
