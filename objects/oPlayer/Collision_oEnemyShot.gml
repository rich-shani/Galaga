/// ========================================================================
/// oPlayer - COLLISION EVENT (Enemy Shot Collision Handler)
/// ========================================================================
/// @description Handles collision between player ship and enemy projectiles.
///              Processes hit detection, shot cleanup, and damage application
///              when player is in ACTIVE state and game is in GAME_ACTIVE mode.
/// 
/// Collision Flow:
///   1. Enemy shot collides with player ship (detected by GameMaker collision system)
///   2. Enemy shot is returned to object pool or destroyed
///   3. Check if player and game are in active states
///   4. If valid, trigger hit processing (alarm[11]) which handles damage logic
/// 
/// State Requirements:
///   • Game mode must be GAME_ACTIVE (prevents hits during menus/transitions)
///   • Player shipStatus must be ACTIVE (prevents hits during death/respawn/capture)
/// 
/// Damage Processing:
///   • Actual damage/hit logic is handled in Alarm_11.gml (alarm[11] event)
///   • This event only sets up the alarm trigger (prevents rapid-fire damage)
///   • Alarm[11] handles dual fighter vs single fighter damage differently
/// 
/// Performance:
///   • Uses object pool system (global.shot_pool) for efficient shot cleanup
///   • Falls back to instance_destroy if pool unavailable
/// 
/// @author Galaga Wars Team
/// @event Collision (with oEnemyShot) - Triggered when collision detected
/// @param other - Reference to the oEnemyShot instance that collided
/// @related Alarm_11.gml - Processes the actual hit/damage logic
/// @related Step_0.gml - Defines ACTIVE state requirements
/// ========================================================================

// ========================================================================
// ENEMY SHOT CLEANUP - Return to Pool or Destroy
// ========================================================================
// Return enemy shot to object pool for reuse (performance optimization)
// Falls back to instance_destroy if object pool system is not available
// This removes the projectile from the game world immediately after collision
// ========================================================================
if (global.shot_pool != undefined) {
	// Use object pool system - recycle the shot instance for better performance
	global.shot_pool.release(other.id);
} else {
	// Fallback: Destroy instance directly (slower, but works if pool unavailable)
	instance_destroy(other);
}

// ========================================================================
// HIT VALIDATION - Check Game and Player States
// ========================================================================
// Only process hit if both conditions are met:
//   1. Game is in GAME_ACTIVE mode (prevents hits during menus/transitions)
//   2. Player is in ACTIVE state (prevents hits during death/respawn/capture sequences)
// 
// This prevents edge cases where player could be hit during inappropriate states,
// such as during respawn animation, game over sequence, or capture sequence.
// ========================================================================
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {

	// ========================================================================
	// SHIELD CHECK - Skip Damage if Shield is Active
	// ========================================================================
	// If shield is active, player is invincible - skip all damage processing
	// Shield provides 2 seconds of invincibility when collected
	// Visual feedback: Shield effect is drawn around player in Draw_0.gml
	// ========================================================================
	if (isShieldActive) {
		// Shield is active - player is invincible, no damage taken
		// Just return without processing the hit
		return;
	}

	// ========================================================================
	// TRIGGER HIT PROCESSING - Set Up Damage Alarm
	// ========================================================================
	// Trigger hit processing by setting alarm[11] if it's not already active
	// The alarm[11] event (Alarm_11.gml) handles the actual damage logic:
	//   • Dual fighter: Loses second fighter, reverts to single (no life loss)
	//   • Single fighter: Player dies, triggers death sequence
	// 
	// Check alarm[11] < 0 to prevent rapid-fire damage (invincibility period)
	// Setting to 1 frame gives immediate processing on next frame
	// ========================================================================
	if (alarm[11] < 0) {
		alarm[11] = 1;  // Trigger hit processing on next frame
	}
}