// The script manages various aspects of the enemy's logic, including:
//
// Destroying the enemy if it moves out of bounds.
// Handling enemy shooting with limits on the number of shots.
// Calculating "breathing" (oscillation) positions for formation movement.
// Adjusting speed based on game state.
// Adjusting speed based on game state.
// Managing transformation into other enemy types.
// Coordinating formation and dive attack behaviors.
// Handling special challenge mode entry and formation logic.
// Executing custom rogue behaviors and cleaning up instances when needed.
//
// The code uses alarms, global variables, and pathing functions to create dynamic and varied enemy actions, ensuring challenging and engaging gameplay.

// Destroy the instance if it goes out of bounds and is rogue
//if (rogue == 1) && (y > 592 * global.scale || x < -32 * global.scale || x > 464 * global.scale) {
//	instance_destroy();
//}

// ROGUE enemy are killed if they leave the screen
if (enemyMode == EnemyMode.ROGUE) {
	if (y > 592*global.scale or x < -32*global.scale or x > 464*global.scale) {
		instance_destroy();
	}
	
	return;
}

// Enemy shooting logic: limit number of shots on screen
if (instance_number(EnemyShot) < 8) {
	// Fire at specific alarm[1] values
	if (alarm[1] == 60) { // 45 + 15
		instance_create(x, y, EnemyShot);
	}
	if (alarm[1] == 40) { // 30 + 10
		instance_create(x, y, EnemyShot);
	}
	if (global.shotnumber > 2 && alarm[1] == 20) { // 15 + 5
		instance_create(x, y, EnemyShot);
	}
}

// Calculate breathing (formation oscillation) positions
breathex = xstart + ((global.breathe / 120) * (48 * ((xstart - 448) / 368))) + floor(oGameManager.x);
breathey = ystart + ((global.breathe / 120) * (48 * ((ystart - 128) / 288)));

// Set speed based on global.fast
if (global.fast == 1) {
	spd = 6;
} else {
	spd = 3;
}

if (global.fastenter == 1 && global.open == 1) {
	if (fasty > 0) {
		fasty -= 1;
	} else {
		path_speed = 12 * global.scale;
		speed = 12 * global.scale;
	}
}
	
// Transformation logic (enemy transforms into another type)
if (global.transnum > 0) {
	if (
		enemyState == EnemyState.IN_FORMATION && irandom(5) == 0 && global.divecap > 0 &&
		global.prohib == 0 && global.transform == 0 &&
		oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0 &&
		instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) < 21 &&
		global.open == 0 && oPlayer.alarm[4] == -1
	) {
		alarm[2] = 50;
		global.transform = 1;
		sound_play(GTransform);
	}
}

///=======================

if (enemyState == EnemyState.ENTER_SCREEN) {

	// Check if reached end of path
	//if (y < (272 - 16) * global.scale) {
	//	if (rogue == 0) { 

		// check if path has ended ... move to formation
		if (path_position >= 1) {

				// look-up formation position based on INDEX
				xstart = formation.POSITION[INDEX]._x;
				ystart = formation.POSITION[INDEX]._y;

				// Set speed for fast entry or normal
				if (global.fastenter == 1) {
					speed = 12 * global.scale;
				} else {
					speed = 6 * global.scale;
				}

				enemyState = EnemyState.MOVE_INTO_FORMATION;
			}
		//}
	//}
}
else if (enemyState == EnemyState.MOVE_INTO_FORMATION) {
	// Have we reached the formation position?
	// enemy can come in from bottom or top of screen, so use ABS()
	if (abs (y - breathey) < 6) {
		x = breathex;
		y = breathey;

		enemyState = EnemyState.IN_FORMATION;
					
		// set alarm : to give time for the Draw function to ROTATE the ship to down direction
		alarm[0]=60;
	}
	else { 
		// continue to move towards the formation position
		move_towards_point(breathex, breathey, speed); 
	}
}
else if (enemyState == EnemyState.IN_FORMATION) {
	// LOGIC to rotate sprite during ALARM[0] is active
	// To align the sprite to face-down in formation 

	// 270 degree is pointing down 
	// ... 0 is to the right, 90 is up, 180 left, 270 down
	if ((alarm[0] == -1) && direction != 270) {
		
		direction = 270;
	} 
	else if (abs(direction - 270) > 6) {
		direction += 6;
	}
	
	// Move to breathing position
	x = breathex;
	y = breathey;
	
	// Random chance to start a dive attack
	if (global.divecap > 0 and global.open == 0 and oPlayer.alarm[4] == -1) {
		if (
			irandom(10) == 0 && global.prohib == 0 &&
			alarm[2] == -1 && oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0
		) {
			global.prohib = 1;
			oGameManager.alarm[0] = 15;
			alarm[1] = 90;
			sound_stop(GDive);
			sound_play(GDive);

			// Choose path based on starting position
			if (xstart > 224 * global.scale) {
				if (attributes.STANDARD.DIVE_PATH1 != noone) {
					var path_id = asset_get_index(attributes.STANDARD.DIVE_PATH1);
					if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
				}
			//	path_start(attributes.DIVE_PATH1, spd * global.scale, 0, false);
			} else {
				if (attributes.STANDARD.DIVE_ALT_PATH1 != noone) {
					var path_id = asset_get_index(attributes.STANDARD.DIVE_ALT_PATH1);
					if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
				}				
				//path_start(Bee1Flip, spd * global.scale, 0, false);
			}
				
			enemyState = EnemyState.IN_DIVE_ATTACK;
		}
	}
		
}
else if (enemyState == EnemyState.IN_DIVE_ATTACK) {
	
	// follow DIVE path until a certain Y location ...
	if (y < 480 * global.scale) {
		// do nothing ... execute DIVE PATH	
	}
	else if ((y > 480 * global.scale)) {
		
		// check if we're the last two enemies left ...
		if (nOfEnemies() < 3) {
			
			enemyState = EnemyState.IN_FINAL_ATTACK;	
		}
		else if (attributes.CAN_LOOP) {
	
			path_end();
			
			if (xstart > 224 * global.scale) {				
				if (attributes.LOOP_PATH != noone) {
					var path_id = asset_get_index(attributes.LOOP_PATH);
					if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
				}
			}
			else {
				if (attributes.LOOP_ALT_PATH != noone) {
					var path_id = asset_get_index(attributes.LOOP_ALT_PATH);
					if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
				}
			}
					
			enemyState = EnemyState.IN_LOOP_ATTACK;				
		}
		else if (y < 592 * global.scale) {
			// Adjust direction towards 270 (downwards)
			if (direction < 270) {
				direction += 1;
			}
			if (direction > 270) {
				direction -= 1;
			}		
		}
		else {
			// reset to the top of screen and move into formation
			path_end();
			speed = 3 * global.scale;
		
			x = breathex;
			y = -16;

			enemyState = EnemyState.MOVE_INTO_FORMATION;
		}
	}
}
else if (enemyState == EnemyState.IN_LOOP_ATTACK) {

	// check if path has ended ... return to formation
	if (path_position >= 1) {
		// return to FORMATION
		speed = 3 * global.scale;

		enemyState = EnemyState.MOVE_INTO_FORMATION;		
	}
}
else if (enemyState == EnemyState.IN_FINAL_ATTACK) {
	if (y > 592 * global.scale) {
		// reset to the top of screen and move into formation
		path_end();
		
		// randomize the x location of where the enemy will drop in ...
		x = irandom(global.screen_width);
		y = -16;
		
		// spawn enemy bullets ...
		alarm[1] = 90;
		
		// dive sound ...
		sound_stop(GDive);
		sound_play(GDive);

		// Choose path based on starting position
		if (x > 224 * global.scale) {
			if (attributes.STANDARD.DIVE_PATH2 != noone) {
				var path_id = asset_get_index(attributes.STANDARD.DIVE_PATH2);
				if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
			}
		} else {
			if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
				var path_id = asset_get_index(attributes.STANDARD.DIVE_ALT_PATH2);
				if (path_id != -1) path_start(path_id, spd*global.scale, 0, 0);
			}				
		}
	}
}
// Execute rogue turn script (custom behavior)
// script_execute(rogueturn);
