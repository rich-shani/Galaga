/// ========================================================================
/// oPlayer - STEP EVENT END (High Score Display Update)
/// ========================================================================
/// @description Updates the displayed high score if current player score exceeds it.
///              This event runs at the end of each step frame, after all other
///              step events have processed, ensuring accurate score comparisons.
/// 
/// Purpose:
///   • Real-time high score tracking during gameplay
///   • Updates display value to show current best score
///   • Only updates if current score is higher than displayed high score
/// 
/// Note: This is a passive tracking system - it doesn't save scores to disk.
///       High score persistence is handled elsewhere in the game.
/// 
/// @author Galaga Wars Team
/// @event Step End (Event 2) - Runs at end of each frame
/// @related global.Game.Player.score - Current player score
/// @related global.Game.HighScores.display - Displayed high score value
/// ========================================================================

// ========================================================================
// HIGH SCORE UPDATE - Active Gameplay Only
// ========================================================================
// Only update high score during active gameplay mode
// Prevents score updates during menus, transitions, or game over screens
// ========================================================================
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {
	// ========================================================================
	// HIGH SCORE COMPARISON AND UPDATE
	// ========================================================================
	// Compare current player score with displayed high score
	// If current score is higher, update the displayed high score
	// This provides real-time feedback when player achieves a new high score
	// ========================================================================
	if (global.Game.Player.score > global.Game.HighScores.display) {
		global.Game.HighScores.display = global.Game.Player.score;
	}
}