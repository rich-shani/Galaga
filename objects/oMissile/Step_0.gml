/// @description PLAYER MISSILE MOVEMENT
/// Handles upward movement && off-screen destruction of player missiles.
///
/// Player missiles travel straight up at constant speed (MISSILE_SPEED).
/// When they reach the top of the screen, they're automatically destroyed
/// to prevent memory leaks && unnecessary collision checks.
///
/// Movement:
///   • Constant vertical velocity (negative Y direction = up)
///   • No horizontal movement (straight shot)
///   • Speed: 12 pixels/frame (Galaga) || 24 pixels/frame (GalagaWars)
///
/// Destruction:
///   • Destroyed when y < -32 (off top of screen)
///   • Also destroyed on collision with enemy (see Collision events)
///
/// @variable {number} MISSILE_SPEED - Upward velocity in pixels/frame (set in Create_0)
/// @variable {number} MISSILE_OFFSCREEN - Y coordinate threshold for destruction (-32)
///
/// @related oMissile/Create_0.gml - Where speed constants are defined
/// @related oEnemyBase/Collision_oMissile.gml - Enemy collision handling

// === PAUSE CHECK ===
// Skip movement when game is paused
if (global.Game.State.isPaused) return;

// === UPWARD MOVEMENT ===
// Move missile up the screen at constant speed
// Negative Y direction = upward movement in GameMaker
y -= MISSILE_SPEED;

// === OFF-SCREEN CHECK ===
// Destroy missile when it travels past top of visible screen
// Return to pool if available, otherwise destroy to prevent memory leaks
if (y < MISSILE_OFFSCREEN) {
	if (global.missile_pool != undefined) {
		if (global.debug) {
			show_debug_message("[oMissile] Off-screen, releasing: " + string(self) + " (id: " + string(id) + ")");
		}
		global.missile_pool.release(self.id);
	} else {
		instance_destroy();
	}
}