// rotate the title screen, from the character page to the high score
if (ScreenShown == TITLE_SCREEN.TITLE) {
	// switch to high_score screen
	
	ScreenShown = TITLE_SCREEN.HIGH_SCORE;
	
	// set the alarm
	alarm[0] = 4*60;
}
else {
	
	ScreenShown = TITLE_SCREEN.TITLE;
	
	/// @section Timers
	// Alarm 1 set to 60 steps (typically 1 second at 60 FPS).
	sequence = 0; 
	alarm[1] = 60;
}

