/// @description ENEMY HIT BY PLAYER MISSILE
/// Handles collision between enemy and player missile.
///
/// This event is triggered when oMissile (player projectile) collides with an enemy.
/// The collision system uses hitCount to determine if enemy is destroyed or just damaged.
///
/// Process:
///   1. Destroy the colliding missile
///   2. Increment the game's hit counter (for accuracy stats)
///   3. Decrement enemy's health (hitCount)
///   4. If health reaches 0, create explosion and destroy enemy
///
/// @variable {number} hitCount - Enemy's remaining health points (set from JSON attributes)
/// @variable {number} oGameManager.hits - Global counter of successful hits (used for accuracy stats)
///
/// @related oEnemyBase/Create_0.gml - Where hitCount is initialized from JSON attributes
/// @related oEnemyBase/Destroy_0.gml - Where scoring and cleanup occurs

// === MISSILE DESTRUCTION ===
// Destroy the missile that hit this enemy
// "other" refers to the oMissile instance that collided with us
instance_destroy(other);

// === HIT STATISTICS ===
// Increment the global hit counter for player accuracy tracking
// Used to calculate hit/miss ratio at end of stage
oGameManager.hits += 1;

// === HEALTH REDUCTION ===
// Reduce enemy's remaining hit points
// Most enemies have hitCount = 1 (die in one hit)
// Boss enemies may have hitCount > 1 (require multiple hits)
hitCount--;

// === DEATH CHECK ===
// If health depleted, create explosion effect and destroy enemy
if (hitCount == 0) {

	// === EXPLOSION ANIMATION ===
	// Randomly choose between two explosion types for variety
	// 50/50 chance of oExplosion or oExplosion2
	// Explosions are spawned at enemy's current position (rounded to nearest pixel)
	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);
	}

	// === ENEMY DESTRUCTION ===
	// Destroy this enemy instance
	// This triggers the Destroy_0.gml event which handles:
	//   • Score award (based on enemy type and game state)
	//   • Sound effects
	//   • Formation slot cleanup
	//   • Bonus enemy spawn checks
	instance_destroy(self);
}