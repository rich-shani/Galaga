
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
            double = 0;
        } else {
            dead = 1;
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