/// ========================================================================
/// oPlayer - ALARM EVENT 11 (Player Hit/Damage Processing)
/// ========================================================================
/// @description Processes player hit/damage when colliding with enemy projectiles.
///              Handles dual fighter vs single fighter damage differently, triggers
///              death sequences, and manages audio/visual effects.
/// 
/// Hit Flow:
///   1. Collision detected with enemy shot (Collision_oEnemyShot.gml)
///   2. Collision event sets alarm[11] = 1 (triggers on next frame)
///   3. This alarm event fires immediately (1 frame delay)
///   4. Process damage based on current shot mode (SINGLE vs DOUBLE)
///   5. Apply appropriate effects (sound, explosion, state change)
/// 
/// Damage Logic:
///   • DOUBLE mode: Lose second fighter, revert to SINGLE (no life loss) - "shield" effect
///   • SINGLE mode: Player dies, lose one life, trigger death sequence
/// 
/// Dual Fighter Protection:
///   • In DOUBLE mode, getting hit only loses the dual fighter bonus
///   • This provides a form of "extra hit" protection - like a shield
///   • Encourages players to rescue fighters for defensive benefit
/// 
/// @author Galaga Wars Team
/// @event Alarm 11 - Player hit/damage processing (triggered by collision)
/// @related Collision_oEnemyShot.gml - Sets alarm[11] = 1 on collision
/// @related Step_0.gml - Processes DEAD state after alarm[0] expires
/// ========================================================================

// ========================================================================
// PLAYER HIT AUDIO - Death Sound Effect
// ========================================================================
// Play player explosion/death sound effect
// Stop sound first to prevent overlapping if already playing
// GDie is the sound resource for player death/explosion
// ========================================================================
global.Game.Controllers.audioManager.stopSound(GDie);
global.Game.Controllers.audioManager.playSound(GDie); 

// ========================================================================
// DAMAGE PROCESSING - Dual Fighter vs Single Fighter
// ========================================================================
// Process damage based on current shot mode
// Dual fighter mode provides "extra hit" protection (lose fighter, not life)
// Single fighter mode results in death (lose life)
// ========================================================================

	
// Create main player explosion animation
// Position: Current player position (rounded to nearest pixel)

				
if (shotMode == ShotMode.DOUBLE) {
	// Revert to single fighter mode (lose dual fighter bonus)
	shotMode = ShotMode.SINGLE;
	
	// Create explosion effect for lost fighter
	instance_create(x, y, oExplosion);
		
	// the 1st player position was hit, so 'move' to the second position player
	x += DUAL_FIGHTER_OFFSET_X;
}
else if (shotMode == ShotMode.SINGLE) {
	// Uses oExplosion3 for larger explosion effect (main ship destruction)
	instance_create(round(x), round(y), oExplosion3);

	// ========================================================================
	// SCREEN SHAKE EFFECT - Visual Impact
	// ========================================================================
	// Enable screen shake layer for visual impact when player dies
	// Creates dramatic effect to emphasize player death
	// Will be disabled in Step_0.gml after death animation completes
	// ========================================================================
	if (!layer_get_visible("ScreenShake")) {
		layer_set_visible("ScreenShake", true);
	}

	// ========================================================================
	// STATE TRANSITION - Update to DEAD State
	// ========================================================================
	// Change ship status to DEAD state
	// Step_0.gml will process death logic (life loss, respawn, game over)
	shipStatus = ShipState.DEAD;	

	// ========================================================================
	// DEATH ANIMATION DELAY - Pause Before Processing Death Logic
	// ========================================================================
	// Set alarm[0] to 120 frames (2 seconds at 60 FPS)
	// This creates a delay before processing life loss and respawn logic
	// Allows explosion animation to play fully before game logic proceeds
	// Step_0.gml (DEAD/CAPTURED state) checks alarm[0] > 0 before processing
	// ========================================================================
	alarm[0] = 120;
}