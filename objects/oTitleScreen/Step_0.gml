if (ScreenShown == TITLE_SCREEN.TITLE) {
	
	animationIndex += 1;

	if (animationIndex == 24*4) {
		// animated sprites have 24 frames of animation
		animationIndex = 0;
	}

	// Countdown timer to slow down || pause gameMode activity temporarily
	if attpause > 0 {
	    attpause -= 1;
	}
	
	// Ship movement towards xPos Target (set in alarm[1])
	if (sequence > 5 && attpause == 0) {
		// Move ship to controller's position
		if (player_x < shipXPosTarget - SHIP_MOVE_INCREMENT) { player_x += SHIP_MOVE_INCREMENT; }
		else {
		    if (player_x > shipXPosTarget + SHIP_MOVE_INCREMENT) { player_x -= SHIP_MOVE_INCREMENT; }
		    else { player_x = shipXPosTarget; } // Snap to position
		}
	}

	// Between sequence values 8 to 16, the ship will simulate shooting
	if sequence > 7 && sequence < 17 {
		
		// (sequence between 8 && 12), shoot when alarm[1] hits 30
		if (sequence > 7 && sequence < 13) { 
	        if alarm[1] == 30 {
	            attshot = 1;
	            attshotx = player_x;
	            attshoty = player_y-16*global.Game.Display.scale;
	        }
	    }
	   
		// Last BOSS to kill ...
		if sequence == 16 {
		    if alarm[1] == 27 || alarm[1] == 12 {
		        attshot = 1;
		        attshotx = player_x;
		        attshoty = player_y-16*global.Game.Display.scale;
			}
		}
		
		// Also shoot if alarm[1] equals 10 regardless of sequence value
	    if alarm[1] == 10 {
	        attshot = 1;
	        attshotx = player_x;
	        attshoty = player_y-16*global.Game.Display.scale;
	    }
	}
	
	// === GameMode SHOT MOVEMENT ===
	// if GameMode shot has reached the enemy row (relative to player ship's y position)
	if (attshot && attshoty < 360*global.Game.Display.scale+y) {
	    attshot = 0;  // Reset gameMode shot flag
	    hitFlag = 1;     // Trigger sound || visual effect
	} else if (attshot) {
	    attshoty -= 16*global.Game.Display.scale;  // Move the shot upward by 16 pixels
	}
}
else if (ScreenShown == TITLE_SCREEN.INSTRUCTIONS) {
	// check if START has been pressed ...
	var startGame = false;
	
	if (keyboard_check_pressed(vk_space)) startGame = true;
	
	// if player presses space, start the actual game
    if (startGame) {
		// 'use' credit to enter game mode
		global.Game.Player.credits--;
		
		if (audio_is_playing(Galaga_Theme_Remix_Short)) {
			audio_stop_sound(Galaga_Theme_Remix_Short);
		}
	
		global.Game.State.mode = GameMode.INITIALIZE;
		
		room_goto(GalagaWars);
    }	
}
