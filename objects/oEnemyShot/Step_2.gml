/// @description ENEMY SHOT MOVEMENT - FIRE AND FORGET SYSTEM
/// Sets up enemy projectile movement toward player's position AT SPAWN TIME.
///
/// Enemy shots use a TRUE "fire and forget" system:
///   1. On first frame after activation, lock onto player's current position
///   2. Set velocity toward that fixed target point
///   3. Continue traveling in that direction (no tracking updates)
///
/// Targeting System:
///   • Locks onto player's X position (with offset for dual shot mode)
///   • Locks onto player's Y position
///   • Speed: 5 pixels/frame * global.Game.Display.scale
///   • Target is FIXED after initialization - player can move away safely
///
/// Shot Mode Offset:
///   When player has dual fighters (shotMode != 0), shots aim with slight
///   offset (32 pixels * shotMode value) to account for dual positioning.
///
/// @variable {number} target_x - Fixed target X (set once on initialization)
/// @variable {number} target_y - Fixed target Y (set once on initialization)
/// @variable {bool} initialized - True after target has been locked
///
/// @related oEnemyBase/Step_0.gml:69-81 - Where enemy shots are created
/// @related oEnemyBase/Alarm_1.gml - Additional shot creation logic

// === LOCK ONTO TARGET (ONCE) ===
// Only set target on first frame after activation from pool
if (!initialized) {
	// Calculate fixed target position based on player's CURRENT location
	if (instance_exists(oPlayer)) {
		target_x = oPlayer.x + (32 * oPlayer.shotMode);
		target_y = oPlayer.y;
	} else {
		// Player doesn't exist, aim downward toward center bottom
		target_x = global.Game.Display.screenWidth / 2;
		target_y = global.Game.Display.screenHeight;
	}

	// Set velocity toward fixed target point (speed and direction are set)
	move_towards_point(target_x, target_y, 5 * global.Game.Display.scale);

	// Mark as initialized - this will NOT be called again until poolReset()
	initialized = true;
}

// After initialization, shot continues moving with the speed/direction
// that was set by move_towards_point() - no further updates needed!

/// @description ENEMY SHOT OFF-SCREEN CHECK
/// Destroys enemy shots that travel past bottom of screen.
///
/// Enemy shots are destroyed when they pass the player's zone && leave
/// the visible playfield. This prevents shots from existing indefinitely
/// && consuming resources/collision checks.
///
/// Destruction Threshold:
///   • Y > 576 * global.Game.Display.scale (bottom of screen + buffer)
///   • Also destroyed on collision with player (see Collision events)
///
/// This is checked in End Step (Step_2) to ensure it runs after all
/// movement && collision checks have completed for this frame.
///
/// @related EnemyShot/Create_0.gml - Where shot movement is initialized
/// @related oPlayer/Collision_EnemyShot.gml - Player hit detection

if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale) {
	if (global.shot_pool != undefined) {
		global.shot_pool.release(self.id);
	} else {
		instance_destroy();
	}
}