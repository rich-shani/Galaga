/// @description Explosion type 2 initialization and pool reset

/// @function poolReset
/// @description Resets explosion state when acquired from object pool
/// This is called automatically by ObjectPool.acquire()
function poolReset() {
	// Reset animation to start
	image_index = 0;
	image_speed = 1;

	// Reset physics (explosions shouldn't move)
	speed = 0;
	direction = 0;
	image_angle = 0;

	// Explosion animates through frames and auto-releases when complete
}
