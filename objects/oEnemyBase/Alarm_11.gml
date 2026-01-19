/// @description Enemy-Player Collision Handler
/// Handles collision damage when enemy makes contact with player ship.
/// This event is triggered by the collision detection system when
/// an enemy's bounding box overlaps with the player's bounding box.
///
/// Damage System:
///   • Each collision reduces enemy hitCount by 1
///   • When hitCount reaches 0, enemy is destroyed
///   • Random explosion sprite is created at enemy position
///
/// Safety Checks:
///   • Game must be in GAME_ACTIVE mode
///   • Player must be ACTIVE (not dead, captured, or respawning)
///   • Prevents collisions during invulnerability frames
///
/// Explosion Variety:
///   • Randomly chooses between oExplosion and oExplosion2
///   • Creates visual variety in destruction effects
///
/// @var hitCount - Enemy's remaining health (decremented on collision)
/// @var oExplosion - Primary explosion effect object
/// @var oExplosion2 - Alternate explosion effect object
///
/// @related oEnemyBase/Collision_oPlayer.gml - Collision event trigger
/// @related oPlayer - Player object collision detection

// check PLAYER STATUS - as the player may be RESPAWNING ...
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {
	// check if we're out of HEALTH
	hitCount--;

	if (hitCount == 0) {
		// Enemy destroyed - create random explosion effect
		if (irandom(1)) {
			instance_create(round(x), round(y), oExplosion);
		}
		else {
			instance_create(round(x), round(y), oExplosion2);	
		}
					
		// destroy Enemy
		instance_destroy(self);
	}
}