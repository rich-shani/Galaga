/// @description Explosion animation completion handler
/// Returns explosion instance to object pool when animation finishes playing.
/// This optimizes performance by reusing explosion instances instead of
/// creating and destroying them repeatedly.
///
/// Animation System:
///   • Explosion sprite has multiple animation frames (typically 10 frames)
///   • image_index tracks current frame (0.0 to 9.9+ for 10-frame animation)
///   • When image_index > 9.8, animation is nearly complete (last frame)
///   • Object is returned to pool at this point (before final frame ends)
///
/// Object Pooling:
///   • Uses global.explosion_pool for efficient memory management
///   • Returns instance to pool for reuse (avoids garbage collection)
///   • Falls back to instance_destroy() if pool system unavailable
///
/// Performance Benefits:
///   • Reduces memory allocation overhead
///   • Prevents garbage collection stuttering
///   • Faster than creating new instances each time
///
/// @var image_index - Current animation frame (0.0 = first frame, 9.9+ = last frame)
/// @var global.explosion_pool - Object pool for recycling explosion instances
///
/// @related oEnemyBase/Destroy_0.gml - Creates explosions when enemies die
/// @related oPlayer/Alarm_11.gml - Creates explosions when player is hit
/// @related scripts/ObjectPool/ObjectPool.gml - Pool system implementation

// Return explosion to pool when animation completes
// Check if animation has reached near-final frame (9.8+ out of 10 frames)
if (image_index > 9.8) {
	if (global.explosion_pool != undefined) {
		// Use object pool system - recycle this explosion instance for better performance
		global.explosion_pool.release(self.id);
	} else {
		// Fallback: Destroy instance directly if pool system unavailable
		instance_destroy();
	}
}