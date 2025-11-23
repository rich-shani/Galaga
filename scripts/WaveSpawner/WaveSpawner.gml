/// @file WaveSpawner.gml
/// @description Specialized controller for wave spawning and enemy management
///              Extracted from oGameManager to reduce god object complexity
///
/// RESPONSIBILITIES:
///   - Standard wave spawning (40 enemies per wave)
///   - Challenge stage spawning (8 enemies per wave, 5 waves)
///   - Rogue enemy spawning
///   - Spawn timing and delays
///
/// RELATED FILES:
///   - datafiles/Patterns/wave_spawn.json - Standard wave patterns
///   - datafiles/Patterns/challenge_spawn.json - Challenge stage patterns
///   - datafiles/Patterns/rogue_spawn.json - Rogue enemy configuration

/// @function WaveSpawner
/// @description Constructor for WaveSpawner controller
/// @param {Struct} _spawn_data Wave spawn data from wave_spawn.json
/// @param {Struct} _challenge_data Challenge spawn data from challenge_spawn.json
/// @param {Struct} _rogue_config Rogue spawn configuration
/// @return {Struct} WaveSpawner instance
function WaveSpawner(_spawn_data, _challenge_data, _rogue_config) constructor {
	// Store data references
	spawn_data = _spawn_data;
	challenge_data = _challenge_data;
	rogue_config = _rogue_config;

	// Spawn state
	spawn_counter = 0;
	spawn_alarm = 0;
	
	// Enemies to spawn for this WAVE
	enemy_wave_info = [];
	group_spawn_count = 1;
	
	/// @function computeEnemiesForWave
	/// @description compute the list of enemies to spawn for this pattern, wave
	///              This may add ROGUE enemies (at random positions)
	/// @return {null}
	static computeEnemiesForWave = function() {
		
		var pattern = global.Game.Level.pattern;
		var wave = global.Game.Level.wave;		
		
		// Bounds checking
		if (pattern >= array_length(spawn_data.PATTERN)) {
			log_error("Pattern index out of bounds: " + string(pattern), "WaveSpawner.spawnStandardEnemy", 2);
			return false;
		}

		var pattern_data = spawn_data.PATTERN[pattern];
		if (wave >= array_length(pattern_data.WAVE)) {
			log_error("Wave index out of bounds: " + string(wave), "WaveSpawner.spawnStandardEnemy", 2);
			return false;
		}
		
		var wave_data = pattern_data.WAVE[wave];
		group_spawn_count = wave_data.GROUP_SPAWN_COUNT;
		
		var src = wave_data.SPAWN;
		var srcCount = array_length(src);		
		var rogueCount = getRogueCount() * group_spawn_count;
		
		// start with the standard Enemy WAVE from the JSON config
		// array_copy will extend the enemy_wave_info array as part of the copy
		array_copy(enemy_wave_info, 0, src, 0, srcCount);
				
		// do we need to insert (random index) ROGUE enemies for this WAVE?
		for (i = 0; i < rogueCount; i++) {
			// clone rogue details from the first Element in the array
			var rogueElement = variable_clone(enemy_wave_info[i]);
			// update the PATH
			rogueElement.PATH = "ROGUE_" + enemy_wave_info[i].PATH;
			// update the INDEX
			rogueElement.INDEX = -1; // if INDEX == -1, then MODE: EnemyMode.ROGUE
		
			// choose an index (at random) to insert the ROGUE enemy
			array_insert(enemy_wave_info, irandom(array_length(enemy_wave_info)-1), rogueElement);
		}
		
		
		return;
	}
	
	static spawnEnemyGroup = function() {
		spawnStandardEnemy(group_spawn_count);
		
		return;
	}
	
	/// @function spawnStandardEnemy
	/// @description Spawns a standard enemy using data from wave_spawn.json
	///              Automatically handles combination spawns (paired enemies)
	/// @return {Bool} True if spawn successful, false if no more enemies to spawn
	static spawnStandardEnemy = function(_group_count) {
		// Get current spawn configuration
		//var pattern = global.Game.Level.pattern;
		//var wave = global.Game.Level.wave;

		//// Bounds checking
		//if (pattern >= array_length(spawn_data.PATTERN)) {
		//	log_error("Pattern index out of bounds: " + string(pattern), "WaveSpawner.spawnStandardEnemy", 2);
		//	return false;
		//}

		//var pattern_data = spawn_data.PATTERN[pattern];
		//if (wave >= array_length(pattern_data.WAVE)) {
		//	log_error("Wave index out of bounds: " + string(wave), "WaveSpawner.spawnStandardEnemy", 2);
		//	return false;
		//}

		//var wave_data = pattern_data.WAVE[wave];
		//if (spawn_counter >= array_length(wave_data.SPAWN)) {
		//	return false; // No more enemies to spawn
		//}

		// Get enemy configuration
//		var enemy_data = wave_data.SPAWN[spawn_counter];
		var enemy_data = enemy_wave_info[spawn_counter];
		var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);

		if (enemy_id == -1) {
			log_error("Invalid enemy asset: " + enemy_data.ENEMY, "WaveSpawner.spawnStandardEnemy", 2);
			spawn_counter++;
			return false;
		}

		// Get or cache path ID
		var path_id = get_cached_asset(enemy_data.PATH);
		if (path_id == -1) {
			log_error("Invalid path: " + enemy_data.PATH, "WaveSpawner.spawnStandardEnemy", 1);
		}

		// Create enemy instance		
		var enemy = instance_create_layer(
			enemy_data.SPAWN_XPOS,
			enemy_data.SPAWN_YPOS,
			"GameSprites",
			enemy_id,
			{
				ENEMY_NAME: enemy_data.ENEMY,
				INDEX: enemy_data.INDEX,
				PATH_NAME: enemy_data.PATH,
				MODE: (enemy_data.INDEX == -1) ? EnemyMode.ROGUE : EnemyMode.STANDARD
			}
		);

		// Increment spawn counter
		spawn_counter++;

		// Handle combination spawns (paired enemies)

		// decrement the group counter and check if we need to SPAWN more enemies in this grouping
		_group_count--;
		
		if (_group_count > 0) {
			spawnStandardEnemy(_group_count-1); // Recursive call for enemy grouping
		}

		return true;
	}

	/// @function spawnChallengeEnemy
	/// @description Spawns challenge stage enemies
	/// @return {Bool} True if spawn successful
	static spawnChallengeEnemy = function() {
		var challenge_id = global.Game.Challenge.current;
		var wave = global.Game.Level.wave;

		// Bounds checking
		if (challenge_id >= array_length(challenge_data.CHALLENGES)) {
			log_error("Challenge ID out of bounds: " + string(challenge_id), "WaveSpawner.spawnChallengeEnemy", 2);
			return false;
		}

		var challenge = challenge_data.CHALLENGES[challenge_id];
		if (wave >= array_length(challenge.WAVES)) {
			log_error("Challenge wave out of bounds: " + string(wave), "WaveSpawner.spawnChallengeEnemy", 2);
			return false;
		}

		var wave_data = challenge.WAVES[wave];
		var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

		if (enemy_id == -1) {
			log_error("Invalid challenge enemy: " + wave_data.ENEMY, "WaveSpawner.spawnChallengeEnemy", 2);
			return false;
		}

		// Select path based on wave number
		var path_name = selectChallengePath(challenge, wave);
		var path_id = get_cached_asset(path_name);

		// Determine spawn position
		var spawn_x = path_get_x(path_id, 0);
//		var spawn_x = (wave_data.DOUBLED) ? getDoubledSpawnX() : getCenterSpawnX();
//		var spawn_y = SPAWN_TOP_Y;
		var spawn_y = path_get_y(path_id, 0);
		
		// Create enemy
		var enemy = instance_create_layer(
			spawn_x,
			spawn_y,
			"GameSprites",
			enemy_id,
			{
				ENEMY_NAME: wave_data.ENEMY,
				INDEX: -1, // Challenge enemies don't have formation positions
				PATH_NAME: path_name,
				MODE: EnemyMode.CHALLENGE
			}
		);

		return true;
	};

	/// @function selectChallengePath
	/// @description Selects appropriate path for challenge stage based on wave
	/// @param {Struct} _challenge Challenge data
	/// @param {Real} _wave Wave number (0-4)
	/// @return {String} Path name
	static selectChallengePath = function(_challenge, _wave) {
		// Waves 0, 3, 4 use PATH1/PATH1_FLIP
		// Waves 1, 2 use PATH2/PATH2_FLIP
		var use_path1 = (_wave == 0 || _wave == 3 || _wave == 4);
		var base_path = use_path1 ? _challenge.PATH1 : _challenge.PATH2;
		var flip_path = use_path1 ? _challenge.PATH1_FLIP : _challenge.PATH2_FLIP;

		// Alternate between normal and flipped
		var use_flip = (spawn_counter % 2 == 1);
		return use_flip ? flip_path : base_path;
	};

	/// @function spawnRogueEnemy
	/// @description Spawns a rogue enemy (doesn't join formation)
	/// @param {Real} _depth Recursion depth guard
	/// @return {Bool} True if spawn successful
	static spawnRogueEnemy = function(_depth = 0) {
		// Recursion guard
		if (_depth > 16) {
			log_error("Max rogue spawn depth exceeded", "WaveSpawner.spawnRogueEnemy", 2);
			return false;
		}

		// Random enemy selection
		var enemy_types = [oTieFighter, oTieIntercepter, oImperialShuttle];
		var enemy_id = enemy_types[irandom(2)];
		var enemy_name = object_get_name(enemy_id);

		// Random path selection with "ROGUE_" prefix
		var path_num = irandom(7) + 1; // 1-8
		var path_name = "ROGUE_" + string(path_num);
		var path_id = get_cached_asset(path_name);

		if (path_id == -1) {
			log_error("Rogue path not found: " + path_name, "WaveSpawner.spawnRogueEnemy", 1);
			return spawnRogueEnemy(_depth + 1); // Retry with different path
		}

		// Random spawn position
		var spawn_x = irandom_range(
			SPAWN_EDGE_BUFFER * global.Game.Display.scale,
			(global.Game.Display.screenWidth - SPAWN_EDGE_BUFFER) * global.Game.Display.scale
		);
		var spawn_y = SPAWN_TOP_Y * global.Game.Display.scale;

		// Create rogue enemy
		var enemy = instance_create_layer(
			spawn_x,
			spawn_y,
			"GameSprites",
			enemy_id,
			{
				ENEMY_NAME: enemy_name,
				INDEX: -1,
				PATH_NAME: path_name,
				MODE: EnemyMode.ROGUE
			}
		);

		return true;
	};

	/// @function getRogueCount
	/// @description Gets number of rogue enemies to spawn for current level
	/// @return {Real} Number of rogues to spawn
	static getRogueCount = function() {
		var rogue_level = global.Game.Rogue.level;

		// Bounds checking
		if (rogue_level < 0 || rogue_level >= array_length(rogue_config.ROGUE_LEVELS)) {
			return 0;
		}

		var level_data = rogue_config.ROGUE_LEVELS[rogue_level];
		var wave = global.Game.Level.wave;

		if (wave < 0 || wave >= array_length(level_data.SPAWN_COUNT)) {
			return 0;
		}

		return level_data.SPAWN_COUNT[wave];
	};

	/// @function getSpawnCounter
	/// @description Resets spawn counter for new wave
	static getSpawnCounter = function() {
		return spawn_counter;
	};
	
	/// @function resetSpawnCounter
	/// @description Resets spawn counter for new wave
	static resetSpawnCounter = function() {
		spawn_counter = 0;
		enemy_wave_info = [];
	};

	static isWaveComplete = function() {
		return (spawn_counter == array_length(enemy_wave_info));
	}
	
	/// @function getSpawnDelay
	/// @description Returns appropriate spawn delay based on game mode
	/// @return {Real} Frames to wait between spawns
	static getSpawnDelay = function() {
		return global.Game.Challenge.isActive ? CHALLENGE_SPAWN_DELAY : WAVE_SPAWN_DELAY;
	};

	/// @function getCenterSpawnX
	/// @description Gets center spawn X position
	/// @return {Real} X coordinate
	static getCenterSpawnX = function() {
		return SCREEN_CENTER_X * global.Game.Display.scale;
	};

	/// @function getDoubledSpawnX
	/// @description Gets alternating spawn X for doubled enemies
	/// @return {Real} X coordinate
	static getDoubledSpawnX = function() {
		var offset = 64 * global.Game.Display.scale;
		var center = SCREEN_CENTER_X * global.Game.Display.scale;
		return (spawn_counter % 2 == 0) ? (center - offset) : (center + offset);
	};
}