if (ScreenShown == TITLE_SCREEN.TITLE) {
	// Countdown timer to slow down or pause gameMode activity temporarily
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
	if sequence > 7 and sequence < 17 {
		
		// (sequence between 8 and 12), shoot when alarm[1] hits 30
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
	if (attshot && attshoty < 336*global.Game.Display.scale+y) {
	    attshot = 0;  // Reset gameMode shot flag
	    hitFlag = 1;     // Trigger sound or visual effect
	} else if (attshot) {
	    attshoty -= 16*global.Game.Display.scale;  // Move the shot upward by 16 pixels
	}
}