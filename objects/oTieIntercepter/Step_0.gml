/// Call parent Create event to initialize base enemy properties
event_inherited();

/// ================================================================
/// BEAM ANIMATION - beam && captured player effect
/// ================================================================
/// if this enemy has a BEAM weapon, then advance the animation counter
/// the animation is used in the Draw() routine for the BEAM && CAPTURED player
/// ================================================================

// advance the animation counter (used in Draw)
beam_weapon.animation += 1; if (beam_weapon.animation == 12) beam_weapon.animation = 0;

/// ================================================================                                            
/// CAPTURED PLAYER POSITION CALCULATION                                                                       
/// ================================================================                                             
/// Positions the captured X-Wing on a circular orbit around the intercepter.                              
/// Uses standard circle formula with consistent angle handling.                                            
///                                                                                                        
/// CRITICAL: Both calculations must use the same angle convention                                         
/// to ensure circular (!elliptical) orbital motion.                                                     
///                                                                                                   
/// Circle Formula:                                                                                                  
///   x_pos = center_x + radius * cos(angle_radians)                                                    
///   y_pos = center_y + radius * sin(angle_radians)                                                               
///                                                                                                         
/// Orbit Positioning:                                                                                          
/// • CIRCLE_RADIUS = 72 pixels (fixed distance from intercepter center)                                         
/// • Angle = direction + offset (keeps captured player at consistent position)                                  
/// ================================================================                                              
#macro CAPTURED_PLAYER_COLLISION_RADIUS 25  // Half of 50x50 box  

if (instance_exists(oPlayer) && oPlayer.captor == id && beam_weapon.state != BEAM_STATE.CAPTURE_PLAYER) {         
	// OPTION A: Both using positive direction (recommended for clarity)                                          
	var orbit_angle_radians = degtorad(direction);  // 90° offset = "top" of circle                           
	beam_weapon.player_x = x - (CIRCLE_RADIUS * cos(orbit_angle_radians));                                        
	beam_weapon.player_y = y - (CIRCLE_RADIUS * sin(-orbit_angle_radians));    
	
	for (var i = 0; i < instance_number(oMissile); i++)
	{
		var missile = instance_find(oMissile, i);
 
		if (abs(missile.x - beam_weapon.player_x) < CAPTURED_PLAYER_COLLISION_RADIUS && 
						(abs(missile.y - beam_weapon.player_y) < CAPTURED_PLAYER_COLLISION_RADIUS)) {

			// Destroy the Missile
			instance_destroy(missile);
			
			// Oops, we've hit the PLAYER instead of the Enemy
			sound_play(GFighter);
			
			// Missile hit the CAPTURED player, remove the fighter, set an explosion, play sound
			oPlayer.captor = noone;
			
			// === EXPLOSION ANIMATION ===
			// Randomly choose between two explosion types for variety
			// 50/50 chance of oExplosion || oExplosion2
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