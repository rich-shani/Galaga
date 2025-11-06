/// Call parent Create event to initialize base enemy properties
event_inherited();

/// ================================================================
/// BEAM ANIMATION - beam and captured player effect
/// ================================================================
/// if this enemy has a BEAM weapon, then advance the animation counter
/// the animation is used in the Draw() routine for the BEAM and CAPTURED player
/// ================================================================

// advance the animation counter (used in Draw)
beam_weapon.animation += 1; if (beam_weapon.animation == 12) beam_weapon.animation = 0;

/// Calculate X-Wing position on circle circumference
/// The X-Wing orbits around the intercepter (x, y) with a fixed radius.
/// It stays positioned at the "top" (270°) relative to the intercepter's direction.
/// Circle formula: x_pos = center_x + radius * cos(angle)
///                 y_pos = center_y + radius * sin(angle)
			
// additional collision detection ... did the oMissile hit the CAPTURED PLAYER?
/// If player is captured by this enemy's beam, render player sprite above enemy
// wait until the BEAM STATE is READY, as it will have to CAPTURE_PLAYER, then FIRE_COMPLETE first

if (instance_exists(oPlayer) && oPlayer.captor == id && beam_weapon.state != BEAM_STATE.CAPTURE_PLAYER) {
	// player CAPTURED, update the beam_weapon.player_x/y to be the captured coordinates
	beam_weapon.player_x = x - (CIRCLE_RADIUS * cos(degtorad(-direction)));
	beam_weapon.player_y = y - (CIRCLE_RADIUS * sin(degtorad(-direction)));
	
	// collision box is for the ENEMY (only), and hence we need to do a custom check
	// rotate around the oMissile instances that are active (should be limited to 2 MAX)
	// check each oMissile against the boundary of where the CAPTURED player is located
	for (var i = 0; i < instance_number(oMissile); i++)
	{
	    var missile = instance_find(oMissile, i);
		
		// check if the missile has 'hit' the CAPTURED PLAYER
		// boundry is a 50x50 area around the center of the CAPTURED PLAYER
		if (abs(missile.x - beam_weapon.player_x) < 25 && (abs(missile.y - beam_weapon.player_y) < 25)) {
			// Destroy the Missile
			instance_destroy(missile);
			
			// Oops, we've hit the PLAYER instead of the Enemy
			sound_play(GFighter);
			
			// Missile hit the CAPTURED player, remove the fighter, set an explosion, play sound
			oPlayer.captor = noone;
			
			// === EXPLOSION ANIMATION ===
			// Randomly choose between two explosion types for variety
			// 50/50 chance of oExplosion or oExplosion2
			// Explosions are spawned at enemy's current position (rounded to nearest pixel)
			if (irandom(1)) {
				instance_create(round(beam_weapon.player_x), round(beam_weapon.player_y), oExplosion);
			}
			else {
				instance_create(round(beam_weapon.player_x), round(beam_weapon.player_y), oExplosion2);
			}	
			
			global.Game.Enemy.capturedPlayer = false;
		}
	}
}