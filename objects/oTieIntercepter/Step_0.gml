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
	
captured_x = x - (CIRCLE_RADIUS * cos(degtorad(-direction)));
captured_y = y - (CIRCLE_RADIUS * sin(degtorad(-direction)));
		
// additional collision detection ... did the oMissile hit the CAPTURED PLAYER?
/// If player is captured by this enemy's beam, render player sprite above enemy
if (oPlayer.captor == id) {
	
	// collision box is for the ENEMY (only), and hence we need to do a custom check
	// rotate around the oMissile instances that are active (should be limited to 2 MAX)
	// check each oMissile against the boundary of where the CAPTURED player is located
	for (var i = 0; i < instance_number(oMissile); i++)
	{
	    var missile = instance_find(oMissile, i);
		
		// check if the missile has 'hit' the CAPTURED PLAYER
		// boundry is a 50x50 area around the center of the CAPTURED PLAYER
		if (abs(missile.x - captured_x) < 25 && (abs(missile.y - captured_y) < 25)) {
			// Oops, we've hit the PLAYER instead of the Enemy
			
			// Destroy the Missile
			instance_destroy(missile);
		}
	}
}