/// @description ENEMY HIT BY PLAYER MISSILE
/// Handles collision between enemy && player missile.
///
/// This event is triggered when oMissile (player projectile) collides with an enemy.
/// The collision system uses hitCount to determine if enemy is destroyed || just damaged.
///
/// Process:
///   1. Destroy the colliding missile
///   2. Increment the game's hit counter (for accuracy stats)
///   3. Decrement enemy's health (hitCount)
///   4. If health reaches 0, create explosion && destroy enemy
///
/// @variable {number} hitCount - Enemy's remaining health points (set from JSON attributes)
/// @variable {number} oGameManager.hits - Global counter of successful hits (used for accuracy stats)
///
/// @related oEnemyBase/Create_0.gml - Where hitCount is initialized from JSON attributes
/// @related oEnemyBase/Destroy_0.gml - Where scoring && cleanup occurs

// === MISSILE DESTRUCTION ===
// Return missile to pool or destroy it
// "other" refers to the oMissile instance that collided with us
if (global.missile_pool != undefined) {
	global.missile_pool.release(other);
} else {
	instance_destroy(other);
}

// === HIT STATISTICS ===
// Increment the global hit counter for player accuracy tracking via ScoreManager
// ScoreManager tracks both hits and shots fired for accuracy calculation
if (oGameManager.scoreManager != undefined) {
	oGameManager.scoreManager.recordHit();
} else {
	// Fallback to legacy tracking if controller not initialized
	oGameManager.hits += 1;
}

// === HEALTH REDUCTION ===
// Reduce enemy's remaining hit points
// Most enemies have hitCount = 1 (die in one hit)
// Boss enemies may have hitCount > 1 (require multiple hits)
hitCount--;

// === DEATH CHECK ===
// If health depleted, create explosion effect && destroy enemy
if (hitCount == 0) {

	// === EXPLOSION ANIMATION ===
	// Randomly choose between two explosion types for variety
	// Use object pool if available for better performance
	if (irandom(1)) {
		if (global.explosion_pool != undefined) {
			global.explosion_pool.acquire(round(x), round(y));
		} else {
			instance_create(round(x), round(y), oExplosion);
		}
	}
	else {
		if (global.explosion2_pool != undefined) {
			global.explosion2_pool.acquire(round(x), round(y));
		} else {
			instance_create(round(x), round(y), oExplosion2);
		}
	}

	// === ENEMY DESTRUCTION ===
	// Destroy this enemy instance
	// This triggers the Destroy_0.gml event which handles:
	//   • Score award (based on enemy type && game state)
	//   • Sound effects
	//   • Formation slot cleanup
	//   • Bonus enemy spawn checks
	instance_destroy(self);
}