if (global.gameMode == GameMode.ATTRACT_MODE) {
	// Countdown timer to slow down or pause gameMode activity temporarily
    if attpause > 0 {
        attpause -= 1;
    }
	
	// Ship movement towards xPos Target (set in Alarm[3])
	if (sequence > 5 && attpause == 0) {
	    // Move ship to controller's position
	    if (oPlayer.x < shipXPosTarget - oPlayer.SHIP_MOVE_INCREMENT) { oPlayer.x += oPlayer.SHIP_MOVE_INCREMENT; }
	    else {
	        if (oPlayer.x > shipXPosTarget + oPlayer.SHIP_MOVE_INCREMENT) { oPlayer.x -= oPlayer.SHIP_MOVE_INCREMENT; }
	        else { oPlayer.x = shipXPosTarget; } // Snap to position
	    }
	}

    // Between sequence values 8 to 16, the ship will simulate shooting
    if sequence > 7 and sequence < 17 {
		
		// (sequence between 8 and 12), shoot when alarm[3] hits 30
		if (sequence > 7 && sequence < 13) { 
            if alarm[3] == 30 {
                attshot = 1;
                attshotx = oPlayer.x;
                attshoty = oPlayer.y-16*global.scale;
            }
        }
	   
		// Last BOSS to kill ...
		if sequence == 16 {
	        if alarm[3] == 27 || alarm[3] == 12 {
	            attshot = 1;
	            attshotx = oPlayer.x;
	            attshoty = oPlayer.y-16*global.scale;
			}
	    }
		
		// Also shoot if alarm[3] equals 10 regardless of sequence value
        if alarm[3] == 10 {
            attshot = 1;
            attshotx = oPlayer.x;
            attshoty = oPlayer.y-16*global.scale;
        }
	}
	
    // === GameMode SHOT MOVEMENT ===
    // if GameMode shot has reached the enemy row (relative to player ship's y position)
    if (attshot && attshoty < 336*global.scale+y) {
        attshot = 0;  // Reset gameMode shot flag
        hitFlag = 1;     // Trigger sound or visual effect
    } else if (attshot) {
        attshoty -= 16*global.scale;  // Move the shot upward by 16 pixels
    }
}