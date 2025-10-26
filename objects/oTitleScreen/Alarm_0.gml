// rotate the title screen, from the character page to the high score
if (ScreenShown == TITLE_SCREEN.TITLE) {
	// switch to high_score screen
	
	ScreenShown = TITLE_SCREEN.HIGH_SCORE;
}
else {
	
	ScreenShown = TITLE_SCREEN.TITLE;
}

// reset the alarm
alarm[0] = 4*60;