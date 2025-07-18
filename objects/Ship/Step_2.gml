 /// @description Controls the player ship's behavior, including movement, shooting, collision detection, and state management in a space shooter game.

// Check if the game is in the main gameplay mode
if (Controller.gameMode == GameMode.GAME_ACTIVE) {
 
   if (Controller.start == StartMode.INITIALIZE && !in_formation) {
	   // check what state the ship is ...
	   if (shipStatus == ShipState.ALIVE || shipStatus == ShipState.RESPAWN) {
			/// @section Movement
	        if (keyboard_check(vk_left) && x > SHIP_MIN_X) {
	            x -= 3; // Move ship left by 3 pixels
	        } else {
	            // Check for right arrow key press and ensure ship stays within right boundary
	            if (keyboard_check(vk_right) && x < SHIP_MAX_X - (shotMode * SHIP_SPACE)) {
	                x += 3; // Move ship right by 3 pixels
	            }
	        }
		
			/// @section Shooting
		    // Check for spacebar press to fire shots
		    if (keyboard_check_pressed(vk_space)) {
		        // First shot handling
		        if (shot1y > -31 && shot1x > -31 && shot1y < room_height + 31 && shot1x < room_width + 31) {
		            // Shot 1 is still active, do nothing
		        } else {
		            // Set shot direction based on ship state
		            shot1dir = (shipStatus == 1) ? spinanim : 360;
                
		            // Calculate initial shot position based on ship position and direction
		            shot1x = x - (SHIP_MIN_X * sin(degtorad(shot1dir)));
		            shot1y = y - (SHIP_MIN_X* cos(degtorad(shot1dir)));
                
		            // Set double shot flag for first shot
		            dub1 = (shotMode == ShotMode.DOUBLE) ? 1 : 0;
                
		            // Play shooting sound
		            sound_stop(GShot);
		            sound_play(GShot);
                
		            Controller.fire += 1; // Increment fire counter
		            Ship.skip = 1; // Set skip flag to manage double shot timing
		        }
            
		        // Second shot handling if first shot is not skipped
		        if (Ship.skip == 0) {
		            if (shot2y > -31 && shot2x > -31 && shot2y < room_height + 31 && shot2x < room_width + 31) {
		                // Shot 2 is still active, do nothing
		            } else {
		                // Set shot direction based on ship state
		                shot2dir = (shipStatus == 1) ? spinanim : 360;
                    
		                // Calculate initial shot position
		                shot2x = x - (SHIP_MIN_X* sin(degtorad(shot2dir)));
		                shot2y = y - (SHIP_MIN_X* cos(degtorad(shot2dir)));
                    
		                // Set double shot flag for second shot
		                dub2 = (shotMode == ShotMode.DOUBLE) ? 1 : 0;
                    
		                // Play shooting sound
		                sound_stop(GShot);
		                sound_play(GShot);
                    
		                Controller.fire += 1; // Increment fire counter
		            }
		        }
            
		        Ship.skip = 0; // Reset skip flag
		    }
		}
	}

    /// @section Shot Movement (Single/Left Ship)
    // Update position of ship bullets ...
	scr_move_ship_bullets();

	// check collisions for non-Boss enemies
	var enemies = [Bee, Butterfly, Transform, Fighter];
	for (var i = 0; i < array_length(enemies); i++) {
	    with (enemies[i]) {
			scr_handle_shot_collision_enemy(id);
		}
	}

	// Check collisions for Boss
	with (Boss) {
		scr_handle_shot_collision_boss(id);
	}
	
    /// @section Getting Hit (Single Ship)
    // Handle collisions when ship is alive or caught and not in formation
    if ((shipStatus == ShipState.ALIVE || (caught == 1 && alarm[2] > -1)) && !in_formation) {
        if (shotMode == ShotMode.SINGLE) {
            with (Bee) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                    Ship.shipStatus = ShipState.DEAD; // Mark ship as shipStatus
                    Ship.alarm[0] = 120; // Set death timer
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Butterfly) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                    if (escort == 0) {} // Placeholder for escort logic
                    Ship.shipStatus = ShipState.DEAD; // Mark ship as shipStatus
                    Ship.alarm[0] = 120; // Set death timer
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Transform) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                    Ship.shipStatus = ShipState.DEAD; // Mark ship as shipStatus
                    Ship.alarm[0] = 120; // Set death timer
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Fighter) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    Ship.shipStatus = ShipState.DEAD; // Mark ship as shipStatus
                    Ship.alarm[0] = 120; // Set death timer
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                    global.fighterstore = 0; // Reset fighter store
                }
            }
            
            with (EnemyShot) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                    Ship.shipStatus = ShipState.DEAD; // Mark ship as dead
                    Ship.alarm[0] = 120; // Set death timer
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy shot
                }
            }
            
            with (Boss) {
                if (hit == 1) {
                    if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                        Ship.shipStatus = ShipState.DEAD; // Mark ship as dead
                        Ship.alarm[0] = 120; // Set death timer
                        if (carrying == 1 && dive == 1) {
                            sound_loop(GRescue); // Play rescue sound
                            Ship.regain = 1; // Set regain flag
                            Ship.alarm[3] = 90; // Set regain timer
                            Ship.newshipy = Fighter.y; // Store fighter position
                            Ship.newshipx = Fighter.x;
                            with (Fighter) { instance_destroy(); } // Destroy fighter
                        }
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        instance_destroy(); // Destroy boss
                    }
                }
                
                if (hit == 0) {
                    if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.caught == 0) {
                        Ship.shipStatus = ShipState.DEAD; // Mark ship as dead
                        Ship.alarm[0] = 120; // Set death timer
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        hit = 1; // Mark boss as hit
                        sound_stop(GBoss1); // Stop boss hit sound
                        sound_play(GBoss1); // Play boss hit sound
                    }
                }
            }
        }
        
        if (shotMode == ShotMode.DOUBLE) {
            /// @section Getting Hit (Double Ship - Left)
            with (Bee) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                    Ship.skip = 1; // Set skip flag
                    Ship.secondx = Ship.x; // Store current position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Butterfly) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                    if (escort == 0) {} // Placeholder for escort logic
                    Ship.skip = 1; // Set skip flag
                    Ship.secondx = Ship.x; // Store current position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Transform) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                    Ship.skip = 1; // Set skip flag
                    Ship.secondx = Ship.x; // Store current position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Fighter) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                    Ship.skip = 1; // Set skip flag
                    Ship.secondx = Ship.x; // Store current position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (EnemyShot) {
                if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                    Ship.skip = 1; // Set skip flag
                    Ship.secondx = Ship.x; // Store current position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy shot
                }
            }
            
            with (Boss) {
                if (hit == 1) {
                    if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                        Ship.skip = 1; // Set skip flag
                        Ship.secondx = Ship.x; // Store current position
                        Ship.deadanim2 = 0.25; // Start second death animation
                        Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                        Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                        if (carrying == 1 && dive == 1) {
                            sound_loop(GRescue); // Play rescue sound
                            Ship.regain = 1; // Set regain flag
                            Ship.alarm[3] = 120; // Set regain timer
                            Ship.newshipy = Fighter.y; // Store fighter position
                            Ship.newshipx = Fighter.x;
                            with (Fighter) { instance_destroy(); } // Destroy fighter
                        }
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        instance_destroy(); // Destroy boss
                    }
                }
                
                if (hit == 0) {
                    if (abs(x - Ship.x) < Ship.space2 && abs(y - Ship.y) < Ship.space2 && Ship.skip == 0) {
                        Ship.skip = 1; // Set skip flag
                        Ship.secondx = Ship.x; // Store current position
                        Ship.deadanim2 = 0.25; // Start second death animation
                        Ship.x = (Ship.x + SHIP_SPACE); // Move to right ship position
                        Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        hit = 1; // Mark boss as hit
                        sound_stop(GBoss1); // Stop boss hit sound
                        sound_play(GBoss1); // Play boss hit sound
                    }
                }
            }
            
            /// @section Getting Hit (Double Ship - Right)
            with (Bee) {
                if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Butterfly) {
                if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    if (escort == 0) {} // Placeholder for escort logic
                    Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Transform) {
                if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (Fighter) {
                if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy
                }
            }
            
            with (EnemyShot) {
                if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                    Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                    Ship.deadanim2 = 0.25; // Start second death animation
                    Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                    sound_stop(GDie); // Stop death sound
                    sound_play(GDie); // Play death sound
                    instance_destroy(); // Destroy enemy shot
                }
            }
            
            with (Boss) {
                if (hit == 1) {
                    if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                        Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                        Ship.deadanim2 = 0.25; // Start second death animation
                        Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        instance_destroy(); // Destroy boss
                    }
                }
                
                if (hit == 0) {
                    if (abs(x - (Ship.x + SHIP_SPACE)) < Ship.space2 && abs(y - Ship.y) < Ship.space2) {
                        Ship.secondx = Ship.x + SHIP_SPACE; // Store right ship position
                        Ship.deadanim2 = 0.25; // Start second death animation
                        Ship.shotMode = ShotMode.SINGLE; // Disable double ship mode
                        sound_stop(GDie); // Stop death sound
                        sound_play(GDie); // Play death sound
                        hit = 1; // Mark boss as hit
                        sound_stop(GBoss1); // Stop boss hit sound
                        sound_play(GBoss1); // Play boss hit sound
                    }
                }
            }
            
            Ship.skip = 0; // Reset skip flag
        }
    }
    
    /// @section Dead State
    // Handle ship death animation and respawn logic
    if (shipStatus == ShipState.DEAD && caught == 0) {
        if (deadanim < 4) {
            deadanim += 0.1; // Increment death animation counter
        }
        
        // Check conditions for respawning
        if (regain == 0 && ((global.divecap == global.divecapstart) || (instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) == 0)) && (instance_number(Fighter) == 0 || Fighter.dive == 0) && alarm[0] == -1) {
            global.p1lives -= 1; // Decrease player lives
            
            if (global.p1lives > 0) {
                Ship.shipStatus = ShipState.RESPAWN; // Set to respawn state
                Ship.x = 224; // Reset position
                Ship.y = 528;
                Ship.alarm[1] = 90; // Set respawn timer
				
				deadamin = 0;
            }
			else {
				// GAME OVER
				global.gameover = 1; // Set game over state
				alarm[10] = 120; // Set game over timer
			}
        }
    }
    
    /// @section Getting Caught
    // Handle ship being caught by boss beam
    with (Boss) {
        if (alarm[3] < ((2 * global.beamtime) / 3) && alarm[3] > global.beamtime / 3 && Ship.x > x - 48 && Ship.x < x + 48 && Ship.shipStatus == ShipState.ALIVE) {
            Ship.caught = 1; // Mark ship as caught
            Ship.shipStatus = ShipState.DEAD; // Mark ship as shipStatus
            Ship.alarm[2] = 90; // Set caught timer
            Ship.grav = x; // Set gravity point to boss position
            sound_stop(GBeam); // Stop beam sound
            sound_loop(GCaptured); // Play captured sound
        }
        
        if (alarm[3] > 0 && Ship.alarm[2] > 0) {
            alarm[3] = ((global.beamtime / 3) / (90 / Ship.alarm[2])) + 20; // Adjust boss beam timer
        }
    }
    
    // Handle caught state movement and animation
    if (caught == 1) {
        y = 396 + ((alarm[2] * 136) / 90); // Move ship vertically towards boss
        
        if (grav > 0) {
            if (grav < x) { x -= 3; } // Move towards gravity point
            if (grav > x) { x += 3; }
            if (x > grav - 1 && x < grav + 1) { x = grav; } // Snap to gravity point
        }
        
        if (alarm[2] > -1) {
            spinanim -= 22.5; // Rotate ship
            if (spinanim == 0) { spinanim = 360; } // Reset rotation
        }
        
        if (alarm[2] == -1) {
            grav = 0; // Reset gravity
            if (spinanim > 0) { spinanim -= 22.5; } // Continue rotation
        }
        
        bosscheck = 0; // Reset boss check flag
        
        with (Boss) {
            if (beam == 1) { Ship.bosscheck = 1; } // Check if boss is beaming
        }
        
        if (bosscheck == 0) {
            caught = 2; // Set to freeing state
            bosscheck = 0;
            alarm[2] = -1; // Reset timers
            alarm[0] = -1;
        }
        
        bosscheck = 0; // Reset boss check flag
    }
    
    // Handle freeing state after being caught
    if (caught == 2) {
        if (y < 528) {
            y += 6; // Move ship downwards
            spinanim -= 22.5; // Continue rotation
            if (spinanim == 0) { spinanim = 360; } // Reset rotation
        } else {
            y = 528; // Snap to bottom of screen
            shipStatus = 0; // Reset shipStatus state 
            caught = 0; // Reset caught state
            grav = 0; // Reset gravity
            spinanim = 360; // Reset rotation
            sound_stop(GCaptured); // Stop captured sound
        }
    }
    
    /// @section Regaining Ship
    // Handle regaining a ship after rescue
    if (regain == 1) {
        if (shipStatus == ShipState.ALIVE) {
            if (alarm[3] == -1 && global.divecap == global.divecapstart && instance_number(EnemyShot) == 0) {
                x = (round(x / 2) * 2); // Round position
                newshipx = (round(newshipx / 2) * 2);
                newshipy = (round(newshipy / 2) * 2);
                in_formation = true; // Set moving state
                
                spinanim = 360; // Reset rotation
                
                // Move ships to formation positions
                if (x < 210) { x += 2; }
                if (x > 210) { x -= 2; }
                
                if (newshipx < 238) { newshipx += 2; }
                if (newshipx > 238) { newshipx -= 2; }
                
                if (newshipx == 238) {
                    if (newshipy < 528) { newshipy += 2; }
                    else { newshipy = 528; }
                }
                
                // Complete formation
                if (x == 210 && newshipx == 238 && newshipy == 528) {
                    newshipx = 0; // Reset new ship position
                    newshipy = 0;
                    shotMode = ShotMode.DOUBLE; // Enable double ship mode
                    regain = 0; // Reset regain state
                    in_formation = false; // Reset moving state
                    sound_stop(GRescue); // Stop rescue sound
                }
            } else {
                spinanim -= 22.5; // Continue rotation
                if (spinanim == 0) { spinanim = 360; } // Reset rotation
            }
        } else {
            if (alarm[3] == -1 && global.divecap == global.divecapstart) {
                x = (round(x / 2) * 2); // Round position
                newshipx = (round(newshipx / 2) * 2);
                newshipy = (round(newshipy / 2) * 2);
                in_formation = true; // Set moving state
                
                spinanim = 360; // Reset rotation
                
                // Move new ship to center
                if (newshipx < 224) { newshipx += 2; }
                if (newshipx > 224) { newshipx -= 2; }
                
                if (newshipx == 224) {
                    if (newshipy < 528) { newshipy += 2; }
                    else { newshipy = 528; }
                }
                
                // Complete respawn
                if (newshipx == 224 && newshipy == 528) {
                    newshipx = 0; // Reset new ship position
                    newshipy = 0;
                    x = 224; // Set ship position
                    y = 528;
                    shipStatus = 0; // Reset shipStatus state
                    shotMode = ShotMode.SINGLE; // Disable double ship mode
                    regain = 0; // Reset regain state
                    in_formation = false; // Reset moving state
                    sound_stop(GRescue); // Stop rescue sound
                }
            } else {
                spinanim -= 22.5; // Continue rotation
                if (spinanim == 0) { spinanim = 360; } // Reset rotation
            }
        }
    }
    
    /// @section Second Explosion Animation
    // Handle second death animation
    if (deadanim2 > 0 && deadanim2 < 4) {
        deadanim2 += 0.1; // Increment second death animation counter
    }
    
    /// @section Game Over
    // Trigger game over state
    //if (shipStatus == ShipState.DEAD && caught == 0 && regain == 0 && global.p1lives == 1 && global.gameover == 0) {
    //    global.gameover = 1; // Set game over state
    //    alarm[10] = 120; // Set game over timer
    //}
    
    /// @section Highscore
    // Update highscore if current score is higher
    if (global.p1score > global.disp) {
        global.disp = global.p1score;
    }
}

/// @section Attract Mode
// Handle attract mode movement (demo mode)
if (Controller.att > 5 && Controller.attpause == 0) {
    if (Controller.att == 8 || Controller.att == 11 || Controller.att == 14) {
        // Move ship to controller's position
        if (Ship.x < Controller.x + Controller.attpos - 3) { x += 3; }
        else {
            if (Ship.x > Controller.x + Controller.attpos + 3) { x -= 3; }
            else { Ship.x = Controller.x + Controller.attpos; } // Snap to position
        }
    } else {
        // Move ship to attract mode position
        if (Ship.x < Controller.attpos - 3 + 16) { x += 3; }
        else {
            if (Ship.x > Controller.attpos + 3 + 16) { x -= 3; }
            else { Ship.x = Controller.attpos + 16; } // Snap to position
        }
    }
}