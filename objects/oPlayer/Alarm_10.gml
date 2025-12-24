/// ========================================================================
/// oPlayer - ALARM EVENT 10 (Player Hit/Damage Processing)
/// ========================================================================
/// @description Processes DOUBLE SHOT player hit/damage when colliding with enemy projectiles.
///              This is only where we are dual fighter, and the 2nd fighter is hit
///				 See Alarm 11 for when the 1st fighter is hit, as there is special logic 
/// 
/// 
/// Damage Logic:
///   • DOUBLE mode: Lose second fighter, revert to SINGLE (no life loss) - "shield" effect
/// 
/// Dual Fighter Protection:
///   • In DOUBLE mode, getting hit only loses the dual fighter
///   • This provides a form of "extra hit" protection - like a shield
///   • Encourages players to rescue fighters for defensive benefit
/// 
/// @author Galaga Wars Team
/// @event Alarm 10 - Player hit/damage processing (triggered by collision)
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
if (shotMode == ShotMode.DOUBLE) {
	// ========================================================================
	// DUAL FIGHTER MODE - Lose Second Fighter (No Life Loss)
	// ========================================================================
	// Player has dual fighters - getting hit only loses the second fighter
	// This provides defensive benefit (acts like an extra life/shield)
	// Player reverts to single fighter mode but doesn't lose a life
	
	// Revert to single fighter mode (lose dual fighter bonus)
	shotMode = ShotMode.SINGLE;
	
	// Create explosion effect for lost fighter
	// Position: Offset 96 pixels to the right (approximate second fighter position)
	// Uses oExplosion for smaller explosion effect (second fighter destruction)
	instance_create(x + DUAL_FIGHTER_OFFSET_X, y, oExplosion);

	// No life deduction - player continues with single fighter
	// This is the key defensive benefit of dual fighter mode
}

// this alarm should ONLY be triggered when we're in DOUBLE SHOT mode and the 2nd player was hit (not the primary player)