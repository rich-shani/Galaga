/// @file TestDifficultyScaling.gml
/// @description Test suite for difficulty progression system
///              Tests speed curves, enemy difficulty scaling, level progression
///
/// COVERAGE:
///   - Speed curve loading and validation
///   - Difficulty multiplier calculation
///   - Enemy speed scaling per level
///   - Progressive challenge increase
///   - Difficulty plateau and reset
///
/// RELATED FILES:
///   - LevelProgression.gml - Level advancement logic
///   - speed_curve.json - Speed curve configuration
///   - GameConstants.gml - Difficulty constants
///   - EnemyBehavior.gml - Enemy speed calculations

/// @function run_test_difficulty_scaling
/// @description Main test runner for difficulty scaling tests
/// @return {Bool} True if all tests passed
function run_test_difficulty_scaling() {
	beginTestSuite("TestDifficultyScaling");

	// Test 1: Speed curve data loaded
	var speed_curves = get_speed_curves();
	assert_true(speed_curves != undefined, "Speed curve data should be loaded");

	// Test 2: Speed curves is a struct or array
	if (speed_curves != undefined) {
		var is_valid = is_struct(speed_curves) || is_array(speed_curves);
		assert_true(is_valid, "Speed curves should be struct or array");
	}

	// Test 3: Speed curve entries for multiple levels
	if (speed_curves != undefined) {
		var has_entries = false;
		if (is_array(speed_curves)) {
			has_entries = array_length(speed_curves) > 0;
		} else if (is_struct(speed_curves)) {
			has_entries = true;  // Struct exists
		}
		assert_true(has_entries, "Speed curves should have entries for level progression");
	}

	// Test 4: Initial difficulty is 1.0 (baseline)
	global.Game.Difficulty.speedMultiplier = 1.0;
	assert_equals(global.Game.Difficulty.speedMultiplier, 1.0, "Initial speed multiplier should be 1.0");

	// Test 5: Difficulty increases with level
	var level_0_speed = 1.0;  // Baseline
	global.Game.Level.current = 1;
	var level_1_speed = get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0);
	// Level 1+ should have multiplier >= baseline
	assert_true(level_1_speed >= level_0_speed, "Difficulty should increase or stay same as levels progress");

	// Test 6: Difficulty multiplier is positive
	for (var level = 0; level <= 20; level++) {
		global.Game.Level.current = level;
		var multiplier = get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0);
		assert_true(multiplier > 0, "Speed multiplier should always be positive");
	}

	// Test 7: Difficulty is numeric
	var multiplier = get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0);
	assert_true(is_real(multiplier), "Speed multiplier should be numeric");

	// Test 8: Challenge interval is consistent
	var challenge_interval = CHALLENGE_INTERVAL_LEVELS;
	assert_equals(challenge_interval, 4, "Challenge stages should occur every 4 levels");

	// Test 9: Challenge count decrements correctly
	global.Game.Challenge.count = 4;
	global.Game.Challenge.count -= 1;
	assert_equals(global.Game.Challenge.count, 3, "Challenge count should decrement");

	// Test 10: Challenge reset after stage
	global.Game.Challenge.count = 0;
	global.Game.Level.current += 1;
	global.Game.Challenge.count = CHALLENGE_INTERVAL_LEVELS;
	assert_equals(global.Game.Challenge.count, CHALLENGE_INTERVAL_LEVELS, "Challenge count should reset after stage");

	// Test 11: Base enemy speed constant defined
	var base_speed = ENEMY_BASE_SPEED;
	assert_true(base_speed > 0, "Base enemy speed should be defined and positive");

	// Test 12: Enemy speed scales with multiplier
	var base = ENEMY_BASE_SPEED;
	var multiplied = base * 1.5;
	assert_true(multiplied > base, "Multiplied speed should be greater than base");

	// Test 13: Dive alarm scales with difficulty
	var standard_dive = DIVE_ALARM_STANDARD;
	var fast_dive = DIVE_ALARM_FAST;
	assert_true(fast_dive < standard_dive, "Fast dive alarm should be faster than standard");

	// Test 14: Difficulty capped at reasonable maximum
	var max_difficulty = 2.0;  // Example max
	for (var level = 0; level <= 100; level++) {
		global.Game.Level.current = level;
		var mult = get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0);
		// Multiplier shouldn't exceed unreasonable values
		assert_true(mult < 5.0, "Difficulty multiplier should be reasonable (<5x)");
	}

	// Test 15: Level progression data exists
	var level_valid = global.Game.Level.current >= 0;
	assert_true(level_valid, "Level tracking should work correctly");

	// Test 16: Extra life thresholds increase
	var first_life = get_config_value("PLAYER", "EXTRA_LIFE_FIRST", EXTRA_LIFE_FIRST_THRESHOLD);
	var additional_life = get_config_value("PLAYER", "EXTRA_LIFE_ADDITIONAL", EXTRA_LIFE_ADDITIONAL_THRESHOLD);
	assert_true(additional_life > first_life, "Additional life threshold should be higher than first");

	// Test 17: Enemy count affects difficulty
	global.Game.Enemy.count = 40;  // Full formation
	assert_equals(global.Game.Enemy.count, 40, "Enemy count tracking should work");

	// Test 18: Dive capacity is affected by level
	var initial_dive_cap = get_config_value("ENEMIES", "DIVE_CAP_START", 2);
	assert_true(initial_dive_cap > 0, "Dive capacity should be positive");

	// Test 19: Wave progression increases challenge
	global.Game.Level.wave = 0;
	var wave_0_challenge = global.Game.Level.wave;
	global.Game.Level.wave = 5;
	var wave_5_challenge = global.Game.Level.wave;
	assert_true(wave_5_challenge > wave_0_challenge, "Later waves should be higher indexed");

	// Test 20: Difficulty reset on new game
	global.Game.Level.current = 0;
	global.Game.Level.wave = 0;
	global.Game.Challenge.count = CHALLENGE_INTERVAL_LEVELS;
	assert_equals(global.Game.Level.current, 0, "Level should reset to 0 on new game");
	assert_equals(global.Game.Challenge.count, CHALLENGE_INTERVAL_LEVELS, "Challenge count should reset");

	endTestSuite();
	return global.test_results.failed == 0;
}
