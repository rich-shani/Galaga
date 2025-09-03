function Attract_Mode() {

    // === ADVANCE TO gameMode MODE SCREEN 2 ===
	if (global.credits == 1) {

        sound_play(GCredit);     // Play credit sound
        global.gameMode = GameMode.INSTRUCTIONS;             // Move to gameMode screen 2 (instructions or title)

        path_end();              // Stop any path-following movement
        x = xstart;              // Reset object to original x
        y = ystart;              // Reset object to original y

        // Reset player ship position
        Ship.x = Ship.xstart;
        Ship.y = Ship.ystart;
    }
}
