enum EnemyState {
	IN_THE_FORMATION,
	MOVE_INTO_POSITION,
	IN_POSITION,
	ATTACK
}

// spawn new enemy in the ENTRY FORMATION
enemyState = EnemyState.IN_THE_FORMATION;
	
// assign the path based on the supplied-parameter (spawnPathId) from the oEnemySpawner manager
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

image_speed = global.enemy_animation_speed;

// default one hit to kill the enemy
hitCount = 1;