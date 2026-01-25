/// @description Explosion2 animation completion handler
/// Returns explosion2 instance to object pool when animation finishes playing.
/// This is an alternate explosion effect (different visual style from oExplosion).
///
/// Animation System:
///   • Explosion2 sprite has multiple animation frames (typically 10 frames)
///   • image_index tracks current frame (0.0 to 9.9+ for 10-frame animation)
///   • When image_index > 9.8, animation is nearly complete (last frame)
///   • Object is returned to pool at this point (before final frame ends)
///
/// Object Pooling:
///   • Uses global.explosion2_pool for efficient memory management
///   • Returns instance to pool for reuse (avoids garbage collection)
///   • Falls back to instance_destroy() if pool system unavailable
///
/// Visual Variety:
///   • Provides alternate explosion visual effect for variety
///   • Used randomly when enemies are destroyed (see oEnemyBase/Destroy_0.gml)
///   • Creates visual diversity in destruction effects
///
/// Performance Benefits:
///   • Reduces memory allocation overhead
///   • Prevents garbage collection stuttering
///   • Faster than creating new instances each time
///
/// @var image_index - Current animation frame (0.0 = first frame, 9.9+ = last frame)
/// @var global.explosion2_pool - Object pool for recycling explosion2 instances
///
/// @related oEnemyBase/Destroy_0.gml - Creates explosions2 randomly when enemies die
/// @related oExplosion/Step_0.gml - Similar logic for primary explosion type
/// @related scripts/ObjectPool/ObjectPool.gml - Pool system implementation

// Return explosion2 to pool when animation completes
// Check if animation has reached near-final frame (9.8+ out of 10 frames)
if (image_index > 9.8) {
	if (global.explosion2_pool != undefined) {
		// Use object pool system - recycle this explosion instance for better performance
		// Pass self (instance) directly, not self.id - HTML5 compatibility fix
		global.explosion2_pool.release(self);
	} else {
		// Fallback: Destroy instance directly if pool system unavailable
		instance_destroy();
	}
}