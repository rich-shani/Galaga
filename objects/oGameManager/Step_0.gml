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
/// ============================================================================

switch(global.gameMode) {
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