// === FRAME CONTROL ===

if (!global.isGamePaused) {
	// Increment the global 'flip' variable, used for animation timing or cyclic events
	global.flip = global.flip + 1;

	// Reset 'flip' after 60 frames (i.e., once per second if the game runs at 60 FPS)
	if global.flip = 60 {
	    global.flip = 0;
	}
}

// === MAIN GAME LOOP ===

switch(global.gameMode) {
	case GameMode.ATTRACT_MODE:
		Attract_Mode();
		break;
	case GameMode.INSTRUCTIONS:
		Show_Instructions();
		break;
	case GameMode.GAME_ACTIVE:
		Game_Loop();
		break;
	case GameMode.ENTER_INITIALS:
		Enter_Initials();
		break;
	default:
		// 
		break;
}