// only spwan enemies when we're in the spawn-enemy game state
if (global.gamestate == GameState.SPAWN_ENEMY_WAVES) {


	switch (waveSpawnCounter) {
		
		case 0: {
			dx = butterfly_XPositions[nButterfliesSpawned];
			dy = butterfly_YPositions[nButterfliesSpawned];
			
			//var dx = 180+(separationX) + (nEnemiesSpawned*separationX);
			//var dy = 120+(separationY);
			instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyButterfly,
							{ target_position_x : dx, target_position_y : dy, spawnPathId : 1 });
				
			nButterfliesSpawned++;
			
			// 1st wave, bees from the top/left, butterflies from the top/right
			dx = bee_XPositions[nBeesSpawned];
			dy = bee_YPositions[nBeesSpawned];
			
//			dx = 180 + (nEnemiesSpawned*separationX);
//			dy = 120+(3*separationY);		
			instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyBee,
							{ target_position_x : dx, target_position_y : dy, spawnPathId : 2 });
		
			nBeesSpawned++;
			break;
		}
		
		case 1: {		
			// alternative the Guardian, Butterfly in formation
			if (pattern) {
				dx = butterfly_XPositions[nButterfliesSpawned];
				dy = butterfly_YPositions[nButterfliesSpawned];
				
				instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyButterfly,
								{ target_position_x : dx, target_position_y : dy, spawnPathId : 3 });
				
				nButterfliesSpawned++;
			}
			else {
				dx = guardian_XPositions[nGuardiansSpawned];
				dy = guardian_YPositions[nGuardiansSpawned];

				instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyGuardian,
								{ target_position_x : dx, target_position_y : dy, spawnPathId : 3 });	
								
				nGuardiansSpawned++;
			}
			
			pattern = !pattern;
			
			break;
		}
		
		case 2: {
			// 1st wave, bees from the top/left, butterflies from the top/right
			dx = butterfly_XPositions[nButterfliesSpawned];
			dy = butterfly_YPositions[nButterfliesSpawned];
			instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyButterfly,
							{ target_position_x : dx, target_position_y : dy, spawnPathId : 4 });
			
			nButterfliesSpawned++;
			break;
		}
				
		case 3: {				
			// 1st wave, bees from the top/left, butterflies from the top/right
			dx = bee_XPositions[nBeesSpawned];
			dy = bee_YPositions[nBeesSpawned];
			
	//		var dx = 180+(4*separationX) + (nEnemiesSpawned*separationX);
	//		var dy = 120+(3*separationY);
			instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyBee,
							{ target_position_x : dx, target_position_y : dy, spawnPathId : 1 });						
		
			nBeesSpawned++;
			break;
		}
		
		case 4: {						
			// 1st wave, bees from the top/left, butterflies from the top/right
			dx = bee_XPositions[nBeesSpawned];
			dy = bee_YPositions[nBeesSpawned];
			//var dx = 180 + (nEnemiesSpawned*separationX);
		//	var dy = 120+(4*separationY);	
			instance_create_layer(start_spawnX, start_spawnY, "GameSprites", oEnemyBee,
							{ target_position_x : dx, target_position_y : dy, spawnPathId : 2 });
							
		
			nBeesSpawned++;
			break;
		}
	}
							
		nEnemiesSpawned++;
		if (nEnemiesSpawned == nEnemiesToSpawn[waveSpawnCounter]) {
			
			// spawn wave complete - increment the wave spawn counter
			waveSpawnCounter++
			
			if (waveSpawnCounter == nWavesToSpawn) {
				
				// switch game mode
				global.gamestate = GameState.PLAY_GAME;
				
				// wait 4 seconds until we close out the enemy spawner
				alarm[1]=4*60;

			}
						
			// reset enemies spawned, as we're moving to a new wave
			nEnemiesSpawned = 0;
			
			// 1 second between waves
			alarm[0]=waveSpawnInterval*55;

		}
		else {

			// 5ms per interval between each enemy of the same wave pattern
			alarm[0]=enemySpawnInterval*5;
		}
}