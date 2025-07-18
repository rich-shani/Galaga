
/// @function handle_shot_collision(shot_index, enemy_x, enemy_y, enemy_instance)
/// @description Handles collision between a shot and an enemy, applying hit effects.
function handle_shot_collision(shot_index, enemy_x, enemy_y, enemy_instance) {
    var shot_x = (shot_index == 0 || shot_index == 2) ? shot1x : shot2x;
    var shot_y = (shot_index == 0 || shot_index == 2) ? shot1y : shot2y;
    var dub_check = (shot_index == 0 || shot_index == 2) ? dub1 : dub2;
    var offset = (shot_index == 2 || shot_index == 3) ? 28 : 0;

    if (abs(enemy_x - shot_x - offset) < space && abs(enemy_y - shot_y) < space && (dub_check == 1 || shot_index < 2)) {
        script_execute(shot1for2, shot_index);
        if (shot_index == 0 || shot_index == 2) {
            shot1x = -32;
            shot1y = -32;
        } else {
            shot2x = -32;
            shot2y = -32;
        }
        Controller.hits += 1;
        with (enemy_instance) {
            if (object_index == obj_Boss) {
                if (hit == 0) {
                    hit = 1;
                    sound_stop(GBoss1);
                    sound_play(GBoss1);
                } else if (hit == 1 && carrying == 1 && dive == 1) {
                    sound_loop(GRescue);
                    Ship.regain = 1;
                    Ship.alarm[3] = 90;
                    Ship.newshipy = Fighter.y;
                    Ship.newshipx = Fighter.x;
                    with (Fighter) { instance_destroy(); }
                    instance_destroy();
                }
            } else if (object_index == obj_Fighter) {
                global.fighterstore = 0;
                instance_destroy();
            } else {
                instance_destroy();
            }
        }
    }
}

/// @function handle_player_hit(enemy_x, enemy_y, enemy_instance, is_double, is_right)
/// @description Handles player ship collision with enemies or shots.
/// @param {real} enemy_x X-coordinate of the enemy.
/// @param {real} enemy_y Y-coordinate of the enemy.
/// @param {instance} enemy_instance The enemy instance.
/// @param {bool} is_double Whether the ship is in double mode.
/// @param {bool} is_right Whether to check the right ship in double mode.
function handle_player_hit(enemy_x, enemy_y, enemy_instance, is_double, is_right) {
    var check_x = is_right ? (Ship.x + SHIP_SPACE) : Ship.x;
    if (abs(enemy_x - check_x) < space2 && abs(enemy_y - Ship.y) < space2 && (caught == 0 || (is_double && skip == 0))) {
        if (is_double) {
            skip = 1;
            secondx = is_right ? (Ship.x + SHIP_SPACE) : Ship.x;
            deadanim2 = 0.25;
            if (!is_right) Ship.x += SHIP_SPACE;
            shotMode = ShotMode.SINGLE;
        } else {
            shipStatus = 1;
            alarm[0] = 120;
        }
        sound_stop(GDie);
        sound_play(GDie);
        with (enemy_instance) {
            if (object_index == obj_Boss) {
                if (hit == 0) {
                    hit = 1;
                    sound_stop(GBoss1);
                    sound_play(GBoss1);
                } else if (hit == 1 && carrying == 1 && dive == 1) {
                    sound_loop(GRescue);
                    Ship.regain = 1;
                    Ship.alarm[3] = 90;
                    Ship.newshipy = Fighter.y;
                    Ship.newshipx = Fighter.x;
                    with (Fighter) { instance_destroy(); }
                    instance_destroy();
                }
            } else if (object_index == obj_Fighter) {
                global.fighterstore = 0;
                instance_destroy();
            } else {
                instance_destroy();
            }
        }
    }
}

function scr_handle_shot_collision_enemy(id) {
	scr_handle_shot_collision(id, 0, false, 0);
	scr_handle_shot_collision(id, 1, false, 0);
	
	// SHOTS from second ship (ie when there's two ships joined)
	scr_handle_enemy_collisions(id);
}
	
function scr_handle_shot_collision_boss(id) {
	scr_handle_shot_collision(id, 0, true, hit);
	scr_handle_shot_collision(id, 1, true, hit);
	
	scr_handle_boss_collisions(object_index);
}
	
function scr_handle_shot_collision(obj, shot_index, is_boss, boss_hit_state) {
// scr_handle_shot_collision(obj, shot_index, is_boss, boss_hit_state)

// Handles collision detection and response for enemy objects hit by player shots
// Arguments:

//   obj: The enemy object instance
//   shot_index: 0 for shot1, 1 for shot2
//   is_boss: Boolean indicating if the object is a boss
//   boss_hit_state: Current hit state for boss (0 or 1), ignored if not a boss

//var obj = argument0;
//var shot_index = argument1;
//var is_boss = argument2;
//var boss_hit_state = argument3;

	with (obj) {
	    // Check if enemy is on-screen (y > -17) or is Transform (no y-check needed)
	    if (object_index != Transform && y <= -17) return false;
    
	    // Determine which shot to check
	    var shot_x = (shot_index == 0) ? Ship.shot1x : Ship.shot2x;
	    var shot_y = (shot_index == 0) ? Ship.shot1y : Ship.shot2y;
    
	    // Check collision
	    if (abs(x - shot_x) < Ship.space && abs(y - shot_y) < Ship.space) {
	        script_execute(shot1for2, shot_index); // Execute hit effect
	        if (shot_index == 0) {
	            Ship.shot1x = SHOT_OFFSCREEN;
	            Ship.shot1y = SHOT_OFFSCREEN;
	        } else {
	            Ship.shot2x = SHOT_OFFSCREEN;
	            Ship.shot2y = SHOT_OFFSCREEN;
	        }
	        Controller.hits += 1; // Increment hit counter
        
	        if (is_boss) {
	            if (boss_hit_state == 0) {
	                hit = 1; // Mark boss as hit
	                sound_stop(GBoss1);
	                sound_play(GBoss1);
	                return true; // Boss survives first hit
	            } else if (boss_hit_state == 1) {
	                if (carrying == 1 && dive == 1) {
	                    sound_loop(GRescue);
	                    Ship.regain = 1;
	                    Ship.alarm[3] = 90;
	                    Ship.newshipx = Fighter.x;
	                    Ship.newshipy = Fighter.y;
	                    with (Fighter) instance_destroy();
	                }
	                instance_destroy(); // Destroy boss on second hit
	            }
	        } else {
	            // Handle non-boss specific logic
	            if (object_index == Fighter) {
	                global.fighterstore = 0; // Reset fighter store
	            }
	            instance_destroy(); // Destroy non-boss enemy
	        }
	        return true;
	    }
	    return false;
	}
}

function scr_move_ship_bullets() {
	if (Ship.shot1y > -31 && Ship.shot1x > -31 && Ship.shot1y < room_height + 31 && Ship.shot1x < room_width + 31) {
        Ship.shot1y -= (SHOT_SPEED * cos(degtorad(Ship.shot1dir))); // Move shot vertically
        Ship.shot1x -= (SHOT_SPEED * sin(degtorad(Ship.shot1dir))); // Move shot horizontally
    } else {
        Ship.shot1x = SHOT_OFFSCREEN; // Move shot off-screen
        Ship.shot1y = SHOT_OFFSCREEN;
    }
    
    //// Update position of second shot if it's within room bounds
    if (Ship.shot2y > -31 && Ship.shot2x > -31 && Ship.shot2y < room_height + 31 && Ship.shot2x < room_width + 31) {
        Ship.shot2y -= (SHOT_SPEED * cos(degtorad(Ship.shot2dir))); // Move shot vertically
        Ship.shot2x -= (SHOT_SPEED * sin(degtorad(Ship.shot2dir))); // Move shot horizontally
    } else { 
        Ship.shot2x = SHOT_OFFSCREEN; // Move shot off-screen
        Ship.shot2y = SHOT_OFFSCREEN;
    }
}

function scr_handle_enemy_collisions(id) {
	// Handles collision detection and response for Bee, Butterfly, Transform, and Fighter objects
	// Checks both shots with SHIP_SPACE offset and dub1/dub2 conditions

    // Skip if off-screen (y <= -17) for Bee, Butterfly, and Fighter, but not Transform
    if (id != Transform && y <= -17) return;
        
    // Check collision for shot1
    if (abs(x - Ship.shot1x - SHIP_SPACE) < Ship.space && abs(y - Ship.shot1y) < Ship.space && Ship.dub1 == 1) {
        script_execute(shot1for2, 2); // Execute hit effect for shot1
        Ship.shot1x = SHOT_OFFSCREEN; // Move shot1 off-screen
        Ship.shot1y = SHOT_OFFSCREEN;
        Controller.hits += 1; // Increment hit counter
        if (id == Fighter) {
            global.fighterstore = 0; // Reset fighter store for Fighter
        }
        instance_destroy(); // Destroy enemy instance
    }
        
    // Check collision for shot2
    if (abs(x - Ship.shot2x - SHIP_SPACE) < Ship.space && abs(y - Ship.shot2y) < Ship.space && Ship.dub2 == 1) {
        script_execute(shot1for2, 3); // Execute hit effect for shot2
        Ship.shot2x = SHOT_OFFSCREEN; // Move shot2 off-screen
        Ship.shot2y = SHOT_OFFSCREEN;
        Controller.hits += 1; // Increment hit counter
        if (id == Fighter) {
            global.fighterstore = 0; // Reset fighter store for Fighter
        }
        instance_destroy(); // Destroy enemy instance
    }
}	

function scr_handle_boss_collisions(id) {
 
	// Handles collision detection and response for Boss objects
	// Manages two-hit system, SHIP_SPACE offset, dub1/dub2 conditions, and rescue logic

    // Skip if off-screen (y <= -17)
    if (y <= -17) return;
    
    // Check collision for shot1
    if (abs(x - Ship.shot1x - SHIP_SPACE) < Ship.space && abs(y - Ship.shot1y) < Ship.space && Ship.dub1 == 1) {
        script_execute(shot1for2, 2); // Execute hit effect for shot1
        Ship.shot1x = SHOT_OFFSCREEN; // Move shot1 off-screen
        Ship.shot1y = SHOT_OFFSCREEN;
        Controller.hits += 1; // Increment hit counter
        
        if (hit == 0) {
            hit = 1; // Mark boss as hit
            sound_stop(GBoss1);
            sound_play(GBoss1);
        } else if (hit == 1) {
            if (carrying == 1 && dive == 1) {
                Ship.regain = 1;
                Ship.alarm[3] = 90;
                Ship.newshipx = Fighter.x;
                Ship.newshipy = Fighter.y;
                with (Fighter) instance_destroy();
            }
            instance_destroy(); // Destroy boss on second hit
        }
    }
    
    // Check collision for shot2
    if (abs(x - Ship.shot2x - SHIP_SPACE) < Ship.space && abs(y - Ship.shot2y) < Ship.space && Ship.dub2 == 1) {
        script_execute(shot1for2, 3); // Execute hit effect for shot2
        Ship.shot2x = SHOT_OFFSCREEN; // Move shot2 off-screen
        Ship.shot2y = SHOT_OFFSCREEN;
        Controller.hits += 1; // Increment hit counter
        
        if (hit == 0) {
            hit = 1; // Mark boss as hit
            sound_stop(GBoss1);
            sound_play(GBoss1);
        } else if (hit == 1) {
            if (carrying == 1 && dive == 1) {
                Ship.regain = 1;
                Ship.alarm[3] = 90;
                Ship.newshipx = Fighter.x;
                Ship.newshipy = Fighter.y;
                with (Fighter) instance_destroy();
            }
            instance_destroy(); // Destroy boss on second hit
        }
    }
}