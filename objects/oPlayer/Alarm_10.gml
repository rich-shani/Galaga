/// ========================================================================
/// oPlayer - ALARM EVENT 10 (Game Over Cleanup and Transition)
/// ========================================================================
/// @description Handles cleanup and transition to results screen after game over.
///              Triggered when player runs out of lives and game over sequence completes.
/// 
/// Game Over Flow:
///   1. Player dies with 0 lives remaining (Step_0.gml)
///   2. Step_0.gml sets alarm[10] = 120 frames (2 seconds)
///   3. Timer counts down (gives brief pause after death)
///   4. This alarm event fires when timer expires
///   5. Clean up all enemies, transition to results screen
/// 
/// Cleanup Actions:
///   • Destroy all remaining enemy instances (clean slate for next game)
///   • Transition game mode to SHOW_RESULTS
///   • Trigger high score entry if applicable (oGameManager alarm[9])
///   • Reset game over flag
/// 
/// Timer Duration:
///   • 120 frames = 2 seconds at 60 FPS
///   • Provides brief pause after final death before cleanup
///   • Allows death animation to complete
/// 
/// @author Galaga Wars Team
/// @event Alarm 10 - Game over cleanup timer
/// @related Step_0.gml - Sets alarm[10] when player dies with 0 lives
/// @related oGameManager - Handles results screen and high score entry
/// ========================================================================

// ========================================================================
// GAME OVER CHECK - Verify Game Over State
// ========================================================================
// Only proceed with cleanup if game over flag is set
// This prevents cleanup from running inappropriately if alarm fires incorrectly
// ========================================================================
if (global.Game.State.isGameOver) {

	// ========================================================================
	// ENEMY CLEANUP - Remove All Remaining Enemies
	// ========================================================================
	// Destroy all enemy instances that are still alive in the game world
	// This ensures a clean state for the results screen and prevents enemies
	// from interfering with the transition
	// 
	// Enemy Types Cleaned:
	//   • oTieFighter - Standard enemy fighters
	//   • oTieIntercepter - Interceptor enemies (may have capture beams)
	//   • oImperialShuttle - Shuttle enemies
	// ========================================================================
	with oTieFighter { instance_destroy(); }
	with oTieIntercepter { instance_destroy(); }
	with oImperialShuttle { instance_destroy(); }

	// ========================================================================
	// TRANSITION TO RESULTS SCREEN - Game Manager Coordination
	// ========================================================================
	// Signal the game manager to show the results screen
	// Sets up the high score entry sequence if player's score qualifies
	// ========================================================================
	with oGameManager {
		// Change game mode to results screen
		global.Game.State.mode = GameMode.SHOW_RESULTS;
		global.Game.State.results = 1;  // Enable results display
		
		// Trigger game manager's alarm[9] to handle high score entry
		// 450 frames = 7.5 seconds delay before entering initials (if score is top 5)
		// This gives time to display results before prompting for initials
		alarm[9] = 450;
	}

	// ========================================================================
	// RESET GAME OVER FLAG - Cleanup Complete
	// ========================================================================
	// Reset the game over flag after cleanup is complete
	// This prevents re-triggering cleanup if alarm fires again
	// Flag will be set again on next game over event
	// ========================================================================
	global.Game.State.isGameOver = false;

	// Note: Player object is NOT destroyed here - it remains for potential reuse
	//       in attract mode or next game session
	// instance_destroy();  // Commented out - player object persists
}