/// ========================================================================
/// oShieldPickup - STEP EVENT (Movement and Lifetime)
/// ========================================================================
/// @description Handles shield pickup movement (falling down) and lifetime.
///              Destroys itself if it goes off-screen or lifetime expires.
/// ========================================================================

// === MOVEMENT ===
// Fall downward
y += fallSpeed;

// Rotate for visual effect
rotation += rotationSpeed;
if (rotation >= 360) rotation -= 360;

// === LIFETIME COUNTDOWN ===
lifetime--;
if (lifetime <= 0) {
	instance_destroy();
}

// === BOUNDARY CHECK ===
// Destroy if it goes off the bottom of the screen
if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale + 64) {
	instance_destroy();
}

