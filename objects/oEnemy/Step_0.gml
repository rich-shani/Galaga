// check if we need to update the sprite animation speed
if (image_speed != global.enemy_animation_speed) image_speed = global.enemy_animation_speed;

if (enemyState == EnemyState.MOVE_INTO_FORMATION) {
	// move enemy into FORMATION
	enemyState = EnemyState.IN_THE_FORMATION;
	
	// assign the path based on the parameter from the oEnemySpawner manager
	switch (spawnPathId) {
		case 1:	
			// assign and start the path
			path_start(Top_LefttoRight,enemySpeed,path_action_stop,true);
			break;
		case 2:
			// assign and start the path
			path_start(Top_RightToLeft,enemySpeed,path_action_stop,true);
			break;
		case 3:
			// assign and start the path
			path_start(BottomLeft_toRight,enemySpeed,path_action_stop,true);
			break;
		case 4:
			// assign and start the path
			path_start(BottomRight_toLeft,enemySpeed,path_action_stop,true);
			break;
	}
}
else if (enemyState == EnemyState.IN_THE_FORMATION) {
	// rotate the angle of the sprite to face the direction of the path movement
	image_angle = direction + 270;
}
else if (enemyState == EnemyState.MOVE_INTO_POSITION) {

	
	if(point_distance(x, y, target_position_x, target_position_y) > 12)
	{
		move_towards_point(target_position_x, target_position_y, 6);
		
		// rotate the angle of the sprite to face the direction of the path movement
		image_angle = direction + 270;
	}
	else {
		x = target_position_x;
		y = target_position_y;
		
		speed = 0;
		
		// shift to in position and update the image angle to face upward
		enemyState = EnemyState.IN_POSITION;
		
	}
}
else if (enemyState == EnemyState.IN_POSITION) {
	// gradually rotate to image angle of zero ... reducing each time towards a threshold 
	if (image_angle > 0.05) image_angle = lerp(0, image_angle, -0.5);
	else if (image_angle != 0) image_angle = 0;
}
