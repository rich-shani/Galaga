 if (global.isGamePaused) {
	return;
}

if (global.gameMode != GameMode.GAME_PAUSED) {
	
	// check for keyboard left/right input
	xDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
 
	dx = xDirection * movespeed;

	x += dx;
		
	// clamp the x,y coordinates to the screen location
	x = clamp(x, 32, 784);
	//y = clamp(y, 824, 784);
	
	// check if fire has been pressed, if so (and we can) release a missile
	if (keyboard_check_pressed(vk_space)) {
	
		// check if we can spawn a new missile
		if (missileInterval <= 0) {
			// spawn a player missile ...
			instance_create_layer(x,y-48,"GameSprites",oMissile);
		
			// play the firing sound fx
			audio_play_sound(GShot,1,false);
			missileInterval = 0.25*game_get_speed(gamespeed_fps);
		}
	}
	
	// reduce the missileInteval
	missileInterval -= 1;
}