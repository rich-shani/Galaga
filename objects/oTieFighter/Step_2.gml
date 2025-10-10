// The script manages various aspects of the enemy's logic, including:
//
// Destroying the enemy if it moves out of bounds.
// Handling enemy shooting with limits on the number of shots.
// Calculating "breathing" (oscillation) positions for formation movement.
// Adjusting speed based on game state.
// Managing transformation into other enemy types.
// Coordinating formation and dive attack behaviors.
// Handling special challenge mode entry and formation logic.
// Executing custom rogue behaviors and cleaning up instances when needed.
//
// The code uses alarms, global variables, and pathing functions to create dynamic and varied enemy actions, ensuring challenging and engaging gameplay.

// Destroy the instance if it goes out of bounds and is rogue
if (rogue == 1) && (y > 592 * global.scale || x < -32 * global.scale || x > 464 * global.scale) {
	instance_destroy();
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

// Set speed based on global.fast and dive2 state
if (global.fast == 1 && dive2 == 1) {
	spd = 6;
} else {
	spd = 3;
}

// Transformation logic (enemy transforms into another type)
if (global.transnum > 0) {
	if (
		dive == 0 && irandom(5) == 0 && global.divecap > 0 && uprohib == 0 &&
		global.prohib == 0 && global.transform == 0 &&
		oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0 &&
		instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) < 21 &&
		global.open == 0 && oPlayer.alarm[4] == -1
	) {
		alarm[2] = 50;
		global.transform = 1;
		sound_play(GTransform);
	}
}

// Convoy (formation movement) logic
if (dive == 0 && enter == 0) {
	depth = 100;

	// LOGIC to rotate sprite during ALARM[0] is active
	// USE to align the sprite to face-down in formation 

	if (alarm[0] == -1) {
		// 270 degree is pointing down 
		// as 0 is to the right, 90 is up, 180 left, 270 down
		direction = 270;
	} else if (abs(direction - 270) > 12) {
		direction += 6;
	} else direction = 270;

	loop = 0;

	// Move to breathing position
	x = breathex;
	y = breathey;

	// Random chance to start a dive attack
	if (global.divecap > 0 and global.open == 0 and oPlayer.alarm[4] == -1) {
		if (
			irandom(10) == 0 && global.prohib == 0 && uprohib == 0 &&
			alarm[2] == -1 && oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0
		) {
			dive = 1;
			direction = 90;
			global.prohib = 1;
			oGameManager.alarm[0] = 15;
			alarm[1] = 90;
			sound_stop(GDive);
			sound_play(GDive);

			// Choose path based on starting position
			if (xstart > 224 * global.scale) {
				path_start(Bee1, spd * global.scale, 0, false);
			} else {
				path_start(Bee1Flip, spd * global.scale, 0, false);
			}
		}
	}
}

// Dive attack logic (charger)
if (dive == 1 && enter == 0) {
	depth = -103;

	// Wait until reaching a certain Y position before starting loop
	if (y < ystart + 160 * global.scale && loop == 0) {
		// Do nothing, just wait
	} else {
		if (loop == 0) {
			if (y < 480 * global.scale) {
				path_end();
				// Adjust direction towards 270 (downwards)
				if (direction < 270) {
					direction += 1;
				}
				if (direction > 270) {
					direction -= 1;
				}
				speed = spd * global.scale;
			} else {
				// Start looping path
				loop = 1;
				if (xstart > 224 * global.scale) {
					path_start(BeeLoop, spd * global.scale, 0, false);
					loop = 2;
				}
				else {
					path_start(BeeLoopFlip, spd * global.scale, 0, false);
					loop = 2;
				}
			}
		}

		if (loop == 1) {
			path_end();
			// Return to formation: move up and align X
			y -= 3 * global.scale;

			if (x < breathex) { x += 1; }
			if (x > breathex) { x -= 1; }
			if (direction < 90) { direction += 1; }
			if (direction > 90) { direction -= 1; }

			if (y < breathey) {
				x = breathex;
				y = breathey;
				dive = 0;
				dive2 = 0;
				uprohib = 1;
				alarm[0] = 30;
				trans = 0;
			}
		}
		// Looping path logic
		if (loop == 2) {
			// End loop if too many enemies or player is dead/regaining
			if (
				instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack ||
				(oPlayer.shipStatus == _ShipState.DEAD || oPlayer.regain == 1)
			) {
				if (xstart > 224 * global.scale && direction > 75 && direction < 80) {
					path_end();
					loop = 1;
				}
				if (xstart < 224 * global.scale && direction > 100 && direction < 105) {
					path_end();
					loop = 1;
				}
			}

			// If off the bottom of the screen, reset to top and start alternate path
			if (y > (592 + 32 + 32) * global.scale) {
				x = breathex;
				y = -16;
				loop = 0;
				alarm[1] = 61;
				dive2 = 1;

				if (global.fast == 1) { spd = 6; }
				sound_stop(GDive);
				sound_play(GDive);

				if (xstart > 224 * global.scale) {
					path_start(Bee1Alt, spd * global.scale, 0, false);
				} else {
					path_start(Bee1AltFlip, spd * global.scale, 0, false);
				}
			}
		}
	}
}

// Challenge mode entry logic
if (global.challcount > 0) {
	// Fast entry logic
	if (global.fastenter == 1 && global.open == 1) {
		if (fasty > 0) {
			fasty -= 1;
		} else {
			path_speed = 12 * global.scale;
			speed = 12 * global.scale;
		}
	}

	// Entering formation logic
	if (enter == 1) {
		if (global.pattern == 0 || global.pattern == 1) {
			// Check if reached end of path
			if (y < (272 - 16) * global.scale) {
				if (rogue == 0) {
					if ((global.wave < 4 && direction < 90) || direction < 180 && goto == 0) {
						path_end();

						// Assign formation positions based on pattern and room

						// look-up formation position based on INDEX
						xstart = formation.POSITION[INDEX]._x;
						ystart = formation.POSITION[INDEX]._y;
						
						//// Galaga Wars formation positions
						//if (numb == 1) { xstart = 400; ystart = 176 * global.scale; }
						//if (numb == 3) { xstart = 480; ystart = 176 * global.scale; }
						//if (numb == 5) { xstart = 400; ystart = 216 * global.scale; }
						//if (numb == 7) { xstart = 480; ystart = 216 * global.scale; }
						//if (numb == 25) { xstart = 560; ystart = 176 * global.scale; }
						//if (numb == 26) { xstart = 640; ystart = 176 * global.scale; }
						//if (numb == 27) { xstart = 560; ystart = 216 * global.scale; }
						//if (numb == 28) { xstart = 640; ystart = 216 * global.scale; }
						//if (numb == 29) { xstart = 240; ystart = 176 * global.scale; }
						//if (numb == 30) { xstart = 320; ystart = 176 * global.scale; }
						//if (numb == 31) { xstart = 240; ystart = 216 * global.scale; }
						//if (numb == 32) { xstart = 320; ystart = 216 * global.scale; }
						//if (numb == 33) { xstart = 80; ystart = 176 * global.scale; }
						//if (numb == 34) { xstart = 160; ystart = 176 * global.scale; }
						//if (numb == 35) { xstart = 80; ystart = 216 * global.scale; }
						//if (numb == 36) { xstart = 160; ystart = 216 * global.scale; }
						//if (numb == 37) { xstart = 720; ystart = 176 * global.scale; }
						//if (numb == 38) { xstart = 800; ystart = 176 * global.scale; }
						//if (numb == 39) { xstart = 720; ystart = 216 * global.scale; }
						//if (numb == 40) { xstart = 800; ystart = 216 * global.scale; }

						// Set speed for fast entry or normal
						if (global.fastenter == 1) {
							speed = 12 * global.scale;
						} else {
							speed = 6 * global.scale;
						}

						goto = 1;
						move_towards_point(breathex, breathey, speed);
						exit;
					}
				}
			}

			// Move towards formation position if not there yet
			if (goto == 1) {
				move_towards_point(breathex, breathey, speed);

				// LOGIC to run once enemy has reached formation position
				// Snap to position and reset states
				if (y < breathey) {
					x = breathex;
					y = breathey;
					goto = 0;
					numb = 0;
					enter = 0;
					dive = 0;
					
					// set alarm : to give time for the Draw function to ROTATE the ship to down direction
					alarm[0]=60;
				}
			}
		}
	}

	// Execute rogue turn script (custom behavior)
	script_execute(rogueturn);
} else {
	// If not in challenge mode, destroy if path is finished
	if (path_position == 1) {
		instance_destroy();
	}
}
