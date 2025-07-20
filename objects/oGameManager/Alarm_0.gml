// check that the game state is INTRO
if (global.gamestate == GameState.INTRO_GAME) {
	
	// change over to SPAWN_ENEMIES
	global.gamestate = GameState.SPAWN_ENEMY_WAVES;
	
	// spawn the enemies, assign the path 
	instance_create_layer(0, 0, "GameSprites", oEnemySpawner);
}