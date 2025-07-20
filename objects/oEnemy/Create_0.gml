enum EnemyState {
	INIT,
	MOVE_INTO_FORMATION,
	IN_THE_FORMATION,
	MOVE_INTO_POSITION,
	IN_POSITION,
	ATTACK
}

enemyState = EnemyState.MOVE_INTO_FORMATION;

image_speed = global.enemy_animation_speed;

// default one hit to kill the enemy
hitCount = 1;