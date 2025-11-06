/// ============================================================================
/// MAIN GAME STATE MACHINE
/// ============================================================================
/// This switch statement coordinates the entire game flow based on current mode.
/// Each case represents a distinct game phase with its own logic.
///
/// Game Flow:
///   INITIALIZE → ATTRACT_MODE → GAME_ACTIVE ↔ PAUSE → RESULTS → ENTER_INITIALS → ATTRACT_MODE
///
/// Key States:
///   • GAME_ACTIVE: Main gameplay loop (enemies spawning, player controls, scoring)
///   • ENTER_INITIALS: High score name entry screen
///   • (Commented out: ATTRACT_MODE and INSTRUCTIONS - may be managed elsewhere)
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode (struct-based access)
///   Legacy global.Game.State.mode is synced automatically via sync functions
/// ============================================================================

/// === PERFORMANCE OPTIMIZATION: Cache Enemy Count ===
/// Cache the total number of enemies once per frame to avoid repeated instance_number() calls.
/// This value is used by multiple systems (dive capacity checks, level completion, final attacks).
/// Caching reduces function calls from dozens to 1 per frame.
global.Game.Enemy.count = nOfEnemies();

switch(global.Game.State.mode) {
	case GameMode.GAME_ACTIVE:
		// Main gameplay - spawn enemies, handle player input, check win conditions
		Game_Loop();
		break;

	case GameMode.ENTER_INITIALS:
		// High score entry - allow player to input 3-character initials
		Enter_Initials();
		break;

	default:
		// Default case: no action needed for other game states
		// (May be handled by Alarm events)
		break;
}