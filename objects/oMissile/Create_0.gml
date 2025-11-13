/// @section Macros for Game Constants

// Off-screen coordinate for shots (-32 ensures shots are not visible/processed).
MISSILE_OFFSCREEN = -32;
// Speed of shots in pixels per step (24 pixels for consistent upward movement).
MISSILE_SPEED = 24;

/// @function poolReset
/// @description Resets missile state when acquired from object pool
/// This is called automatically by ObjectPool.acquire()
function poolReset() {
	// Reset movement state
	speed = 0;
	direction = 0;
	image_index = 0;
	image_speed = 1;

	// Missile moves upward in Step event (no built-in speed/direction needed)
	// Just ensure we're visible and at correct position (handled by pool)
}