enemyState = EnemyState.MOVE_INTO_FORMATION;
			
if (x > 224*global.scale) {
	path_start(TI_RETURN, entranceSpeed, 0, false);
}
else{
	path_start(TI_RETURN_FLIP, entranceSpeed, 0, false);
}
