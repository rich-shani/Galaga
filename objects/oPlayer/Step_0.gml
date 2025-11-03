if (global.isGamePaused) return;

if (global.gameMode == GameMode.GAME_ACTIVE) {
	
	switch (shipStatus) {
		case _ShipState.ACTIVE:
		
			var fireIsPressed = false;
			
			// check if we have a gamepad
			if (oGameManager.useGamepad) {
				var _h_input = gamepad_axis_value(0, gp_axislh);
				if (_h_input > 0.1) {
					xDirection = 1;
					shipImage = 3;
				}
				else if (_h_input < -0.1) {
					xDirection = -1;
					shipImage = 1;
				}
				else {
					xDirection = 0;
					shipImage = 2;
				}
				
				// A button on the XBOX Controller
				if (gamepad_button_check_pressed(0,gp_face1)) fireIsPressed = true;
				
				//if (gamepad_button_check(0, gp_padl)) xDirection = -1;
				//else if (gamepad_button_check(0, gp_padr)) xDirection = 1;
				//else if (gamepad_button_check(0, gp_padu)) new_direction = PACMAN_UP;
				//else if (gamepad_button_check(0, gp_padd)) new_direction = PACMAN_DOWN;
				
				//if (gamepad_button_check_pressed(0,gp_face4)) {
				//	turboModeModifier = 2;
				//}
				//else if (gamepad_button_check_released(0,gp_face4)) {
				//	turboModeModifier = 1;
				//}
		
				//// B button on the XBOX Controller
				//if (gamepad_button_check_pressed(0,gp_face2)) {
				//	freezeMode = true;
				//}
				//else if (gamepad_button_check_released(0,gp_face2)) {
				//	freezeMode = false;
			}
			else {
				// check for keyboard left/right input
				xDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
				
				if (xDirection == -1) shipImage = 1;
				else if (xDirection == 1) shipImage = 3;
				else shipImage = 2;
				
				if (keyboard_check_pressed(vk_space)) fireIsPressed = true;
			}
				
			dx = xDirection * movespeed;

			x += dx;
		
			// clamp the x,y coordinates to the screen location
			x = clamp(x, SHIP_MIN_X, SHIP_MAX_X);
	

			// check if fire has been pressed, if so (and we can) release a missile
			if (fireIsPressed) {
	
				// check if we can spawn a new missile,
				// ie we only have two missiles active on screen (and a slight delay between firing) ...
				if (missileInterval <= 0 && instance_number(oMissile) < 2) {
					// spawn a player missile ...
					instance_create_layer(x, y-48, "GameSprites", oMissile);
		
					// play the firing sound fx
					audio_play_sound(GShot, 1, false);
					missileInterval = 0.1*game_get_speed(gamespeed_fps);
					
					// increment the fire counter
					oGameManager.fire += 1;
				}
			}
	
			// reduce the missileInteval
			missileInterval -= 1;
			break;
		case _ShipState.CAPTURED:
		case _ShipState.DEAD:
			/// @section Dead State
			if (alarm[0] > 0) return;
			
			// is Screen shaking?
			if (layer_get_visible("ScreenShake")) {
				// screem shake OFF
				layer_set_visible("ScreenShake", false);	
			}
			
			if (!global.isGameOver) {
				global.p1lives -= 1; // Decrease player lives
       
				if (global.p1lives > 0) {
				    shipStatus = _ShipState.RESPAWN;
					
					alarm[1] = 90; // Set respawn timer
				}
				else {
					// GAME OVER
					global.isGameOver = true;
					// clean up as it's GAME OVER!
					alarm[10] = 120;
				}
			}		
			
			break;
		case _ShipState.RELEASING: break;
		case _ShipState.RESPAWN:
			// if timer has expired, then RESPAWN
			if (alarm[1] ==-1) {
				shipStatus = _ShipState.ACTIVE;
				
				x = 224*global.scale; // Reset position
				y = 528*global.scale;
			}
			
			break;
	}
}