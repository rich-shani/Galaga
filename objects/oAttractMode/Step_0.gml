if (global.Game.State.mode == GameMode.ATTRACT_MODE) {
	// Countdown timer to slow down or pause gameMode activity temporarily
    if attpause > 0 {
        attpause -= 1;
    }
	
	// Ship movement towards xPos Target (set in Alarm[3])
	if (sequence > 5 && attpause == 0 && instance_exists(oPlayer)) {
	    // Move ship to controller's position
	    if (oPlayer.x < shipXPosTarget - oPlayer.SHIP_MOVE_INCREMENT) { oPlayer.x += oPlayer.SHIP_MOVE_INCREMENT; }
	    else {
	        if (oPlayer.x > shipXPosTarget + oPlayer.SHIP_MOVE_INCREMENT) { oPlayer.x -= oPlayer.SHIP_MOVE_INCREMENT; }
	        else { oPlayer.x = shipXPosTarget; } // Snap to position
	    }
	}

    // Between sequence values 8 to 16, the ship will simulate shooting
    if (sequence > 7 and sequence < 17 && instance_exists(oPlayer)) {

		// (sequence between 8 and 12), shoot when alarm[3] hits primary timing
		if (sequence > 7 && sequence < 13) {
            if alarm[3] == ATTRACT_SHOT_TIMING_PRIMARY {
                attshot = 1;
                attshotx = oPlayer.x;
                attshoty = oPlayer.y-16*global.Game.Display.scale;
            }
        }

		// Last BOSS to kill ...
		if sequence == 16 {
	        if alarm[3] == ATTRACT_SHOT_TIMING_BOSS_FIRST || alarm[3] == ATTRACT_SHOT_TIMING_BOSS_SECOND {
	            attshot = 1;
	            attshotx = oPlayer.x;
	            attshoty = oPlayer.y-16*global.Game.Display.scale;
			}
	    }

		// Also shoot if alarm[3] equals alternate timing regardless of sequence value
        if alarm[3] == ATTRACT_SHOT_TIMING_ALTERNATE {
            attshot = 1;
            attshotx = oPlayer.x;
            attshoty = oPlayer.y-16*global.Game.Display.scale;
        }
	}
	
    // === GameMode SHOT MOVEMENT ===
    // if GameMode shot has reached the enemy row (relative to player ship's y position)
    if (attshot && attshoty < ATTRACT_TARGET_Y*global.Game.Display.scale+y) {
        attshot = 0;  // Reset gameMode shot flag
        hitFlag = 1;     // Trigger sound or visual effect
    } else if (attshot) {
        attshoty -= ATTRACT_SHOT_MOVE_INCREMENT*global.Game.Display.scale;  // Move the shot upward
    }
}