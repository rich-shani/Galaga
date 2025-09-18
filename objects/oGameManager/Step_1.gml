/// @description FRAME TIMER & DEBUG

// === FRAME CONTROL ===
if (!global.isGamePaused) {
	// Increment the global 'flip' variable, used for animation timing or cyclic events
	global.flip = global.flip + 1;
	global.animationIndex += 1;

	// Reset 'flip' after 60 frames (i.e., once per second if the game runs at 60 FPS)
	if global.flip = 60 {
	    global.flip = 0;
	}
	
	if (global.animationIndex == 24*4) {
		// animated sprites have 24 frames of animation
		global.animationIndex = 0;
	}
}

// === DEBUG INPUT HANDLING ===

// If the F10 key is pressed, toggle game speed between 60 FPS and 10 FPS for debugging
if keyboard_check_pressed(vk_f10) == true {
    if game_get_speed(gamespeed_fps) == 60 {
        // Switch to slow motion
        game_set_speed(10, gamespeed_fps);
    } else {
        // Switch back to normal speed
        game_set_speed(60, gamespeed_fps);
    }
}

// If the F12 key is pressed, restart the game (useful for quick resetting during testing)
if keyboard_check_pressed(vk_f12) == true {
    game_restart();
}