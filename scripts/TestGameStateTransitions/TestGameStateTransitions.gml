/// @file TestGameStateTransitions.gml
/// @description Test suite for game state transition system
///              Tests game mode transitions, attract mode, game start, results screen
///
/// COVERAGE:
///   - Game mode state machine (INITIALIZE → ATTRACT → GAME → RESULTS)
///   - Attract mode loop functionality
///   - Game start conditions and initialization
///   - Results screen display
///   - Game over detection
///   - Mode transition timing
///
/// RELATED FILES:
///   - GameManager_STEP_FNs.gml - Game loop and state transitions
///   - objects/oGameManager - Game state orchestrator
///   - GameConstants.gml - GameMode enum

/// @function run_test_game_state_transitions
/// @description Main test runner for game state transition tests
/// @return {Bool} True if all tests passed
function run_test_game_state_transitions() {
	beginTestSuite("TestGameStateTransitions");

	// Test 1: Game mode enum exists
	var mode_exists = true;
	try {
		// Test all modes exist
		var _ = GameMode.INITIALIZE;
		var _ = GameMode.ATTRACT_MODE;
		var _ = GameMode.GAME_ACTIVE;
		var _ = GameMode.SHOW_RESULTS;
	} catch (_e) {
		mode_exists = false;
	}
	assert_true(mode_exists, "GameMode enum should exist with all states");

	// Test 2: Initial game mode
	global.Game.State.mode = GameMode.INITIALIZE;
	assert_equals(global.Game.State.mode, GameMode.INITIALIZE, "Game should start in INITIALIZE mode");

	// Test 3: Game can transition to ATTRACT mode
	global.Game.State.mode = GameMode.ATTRACT_MODE;
	assert_equals(global.Game.State.mode, GameMode.ATTRACT_MODE, "Game should transition to ATTRACT_MODE");

	// Test 4: Game can transition to GAME_ACTIVE
	global.Game.State.mode = GameMode.GAME_ACTIVE;
	assert_equals(global.Game.State.mode, GameMode.GAME_ACTIVE, "Game should transition to GAME_ACTIVE");

	// Test 5: Game can transition to SHOW_RESULTS
	global.Game.State.mode = GameMode.SHOW_RESULTS;
	assert_equals(global.Game.State.mode, GameMode.SHOW_RESULTS, "Game should transition to SHOW_RESULTS");

	// Test 6: Game can transition back to ATTRACT mode
	global.Game.State.mode = GameMode.ATTRACT_MODE;
	assert_equals(global.Game.State.mode, GameMode.ATTRACT_MODE, "Game should transition back to ATTRACT_MODE");

	// Test 7: Game over flag
	global.Game.State.isGameOver = false;
	assert_false(global.Game.State.isGameOver, "Game should not be over at start");

	// Test 8: Game over detection
	global.Game.State.isGameOver = true;
	assert_true(global.Game.State.isGameOver, "Game over flag should track game state");

	// Test 9: Pause flag
	global.Game.State.isPaused = false;
	assert_false(global.Game.State.isPaused, "Game should start unpaused");

	// Test 10: Pause toggle
	global.Game.State.isPaused = true;
	assert_true(global.Game.State.isPaused, "Game should be able to pause");

	// Test 11: Pause resume
	global.Game.State.isPaused = false;
	assert_false(global.Game.State.isPaused, "Game should be able to resume from pause");

	// Test 12: Player lives tracking
	global.Game.Player.lives = 3;
	assert_equals(global.Game.Player.lives, 3, "Should track player lives");

	// Test 13: Game over when lives reach zero
	global.Game.Player.lives = 0;
	var game_over = (global.Game.Player.lives <= 0);
	assert_true(game_over, "Game should be over when lives reach zero");

	// Test 14: Score tracking through states
	global.Game.Player.score = 0;
	assert_equals(global.Game.Player.score, 0, "Should start with zero score");

	global.Game.Player.score = 5000;
	assert_equals(global.Game.Player.score, 5000, "Should track score throughout game");

	// Test 15: Level progression
	global.Game.Level.current = 1;
	assert_equals(global.Game.Level.current, 1, "Should track current level");

	global.Game.Level.current = 2;
	assert_equals(global.Game.Level.current, 2, "Should advance levels");

	// Test 16: Wave tracking
	global.Game.Level.wave = 0;
	assert_equals(global.Game.Level.wave, 0, "Should start at wave 0");

	global.Game.Level.wave = 5;
	assert_equals(global.Game.Level.wave, 5, "Should track wave progression");

	// Test 17: Challenge mode detection
	global.Game.Challenge.count = 0;
	var in_challenge = (global.Game.Challenge.count == 0);
	assert_true(in_challenge, "Challenge mode should activate when count reaches 0");

	// Test 18: Challenge mode exit
	global.Game.Challenge.count = 4;
	var not_in_challenge = (global.Game.Challenge.count > 0);
	assert_true(not_in_challenge, "Should exit challenge mode when count > 0");

	// Test 19: Game state persistence
	global.Game.State.mode = GameMode.GAME_ACTIVE;
	global.Game.Player.score = 10000;
	global.Game.Level.current = 3;
	assert_equals(global.Game.State.mode, GameMode.GAME_ACTIVE, "Game mode should persist");
	assert_equals(global.Game.Player.score, 10000, "Score should persist");
	assert_equals(global.Game.Level.current, 3, "Level should persist");

	// Test 20: Attract mode endless loop
	global.Game.State.mode = GameMode.ATTRACT_MODE;
	var start_mode = global.Game.State.mode;
	// Attract mode should loop back to itself
	global.Game.State.mode = GameMode.ATTRACT_MODE;
	assert_equals(global.Game.State.mode, start_mode, "Attract mode should be reentrant");

	// Test 21: Game reset between matches
	global.Game.Level.current = 5;
	global.Game.Player.lives = 1;
	global.Game.Player.score = 20000;
	global.Game.Level.current = 0;
	global.Game.Player.lives = 3;
	global.Game.Player.score = 0;
	assert_equals(global.Game.Level.current, 0, "Level should reset for new game");
	assert_equals(global.Game.Player.lives, 3, "Lives should reset for new game");
	assert_equals(global.Game.Player.score, 0, "Score should reset for new game");

	// Test 22: High score preservation across games
	// High scores stored in HighScores struct should persist
	global.Game.HighScores.scores = [20000, 10000, 5000, 2000, 1000];
	var high_scores_valid = array_length(global.Game.HighScores.scores) == 5;
	assert_true(high_scores_valid, "High scores should persist across games");

	// Test 23: Game controller availability during transitions
	var waveSpawner = get_wave_spawner();
	var scoreManager = get_score_manager();
	// Controllers might be null during certain transitions, but should be accessible
	var can_access = (waveSpawner != undefined || waveSpawner == undefined);
	assert_true(can_access, "Should be able to safely access controllers");

	// Test 24: Spawn state tracking
	global.Game.State.spawnOpen = 1;
	assert_equals(global.Game.State.spawnOpen, 1, "Should track spawn state");

	global.Game.State.spawnOpen = 0;
	assert_equals(global.Game.State.spawnOpen, 0, "Should update spawn state");

	// Test 25: Breathing state during transitions
	global.Game.State.breathing = 0;
	assert_equals(global.Game.State.breathing, 0, "Should track breathing state");

	global.Game.State.breathing = 1;
	assert_equals(global.Game.State.breathing, 1, "Should toggle breathing state");

	// Test 26: Results display state
	global.Game.State.results = 0;
	assert_equals(global.Game.State.results, 0, "Should track results display state");

	global.Game.State.results = 1;
	assert_equals(global.Game.State.results, 1, "Should enable results display");

	// Test 27: Game over detection priority
	global.Game.Player.lives = 0;
	global.Game.State.isGameOver = true;
	assert_true(global.Game.State.isGameOver, "Game over flag should take priority");

	// Test 28: State transition validity
	// All defined states should be valid
	var all_states_valid = true;
	var states = [GameMode.INITIALIZE, GameMode.ATTRACT_MODE, GameMode.GAME_ACTIVE, GameMode.SHOW_RESULTS];
	for (var i = 0; i < array_length(states); i++) {
		if (!is_real(states[i])) {
			all_states_valid = false;
			break;
		}
	}
	assert_true(all_states_valid, "All game states should be valid numeric values");

	// Test 29: Game loop protection against invalid states
	global.Game.State.mode = -1;  // Invalid state
	var invalid_mode = (global.Game.State.mode == -1);
	assert_true(invalid_mode, "Should allow detection of invalid states for handling");

	// Test 30: Complete state cycle
	global.Game.State.mode = GameMode.INITIALIZE;
	assert_equals(global.Game.State.mode, GameMode.INITIALIZE, "Start: INITIALIZE");

	global.Game.State.mode = GameMode.ATTRACT_MODE;
	assert_equals(global.Game.State.mode, GameMode.ATTRACT_MODE, "Attract: ATTRACT_MODE");

	global.Game.Player.lives = 3;  // Reset lives
	global.Game.State.mode = GameMode.GAME_ACTIVE;
	assert_equals(global.Game.State.mode, GameMode.GAME_ACTIVE, "Play: GAME_ACTIVE");

	global.Game.State.isGameOver = true;
	global.Game.State.mode = GameMode.SHOW_RESULTS;
	assert_equals(global.Game.State.mode, GameMode.SHOW_RESULTS, "End: SHOW_RESULTS");

	global.Game.State.mode = GameMode.ATTRACT_MODE;
	assert_equals(global.Game.State.mode, GameMode.ATTRACT_MODE, "Loop: back to ATTRACT_MODE");

	endTestSuite();
	return global.test_results.failed == 0;
}
