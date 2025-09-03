// check if we need to update the sprite animation speed
if (image_speed != global.enemy_animation_speed) image_speed = global.enemy_animation_speed;

switch (enemyState) {
	case EnemyState.IN_THE_FORMATION:
	{
		// rotate the angle of the sprite to face the direction of the path movement
		image_angle = direction + 270;
		
		break;
	}
	case EnemyState.MOVE_INTO_POSITION: 
	{
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
		break;
	}
	case EnemyState.IN_POSITION: 
	{
		// gradually rotate to image angle of zero ... reducing each time towards a threshold 
		if (image_angle > 0.05) image_angle = lerp(0, image_angle, -0.5);
		else if (image_angle != 0) image_angle = 0;
		
		break;
	}
}
