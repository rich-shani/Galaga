/// @description Enemy shot initialization and pool reset

laserColor = 0;

// Target position (locked when shot is created)
target_x = 0;
target_y = 0;
initialized = false;  // Track if target has been set


/// @function poolReset
/// @description Resets enemy shot state when acquired from object pool
/// This is called automatically by ObjectPool.acquire()
function poolReset() {
	// Reset built-in physics
	speed = 0;
	direction = 0;

	// Reset sprite animation
	image_index = 0;
	image_speed = 1;
	image_angle = 0;
	
	// Reset target lock (will be set in first Step_2 call)
	target_x = 0;
	target_y = 0;
	initialized = false;  // Shot needs to acquire target on next frame
}
