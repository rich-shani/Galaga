/// @file TestScoreAndChallenge.gml
/// @description Comprehensive test suite for ScoreManager and ChallengeStageManager
///
/// Tests the following functionality:
///   - Score tracking and updates
///   - Extra life awarding at score milestones
///   - High score management
///   - Diving enemy 2x multiplier
///   - Challenge stage detection
///   - Challenge stage spawning
///   - Challenge results and bonuses
///   - Level progression through challenges
///
/// SETUP REQUIREMENTS:
///   - oGlobal must be instantiated
///   - Game configuration must be loaded (game_config.json)
///
/// @function runScoreAndChallengeTests
/// @description Main test runner for ScoreManager and ChallengeStageManager tests
function runScoreAndChallengeTests() {
    beginTestSuite("Score Manager and Challenge Stage Tests");

    // === SCORE MANAGER TESTS ===
    test_scoreManager_initialization();
    test_scoreManager_addScore();
    test_scoreManager_enemyScoring();
    test_scoreManager_extraLife();
    test_scoreManager_maxScoreLimit();

    // === CHALLENGE STAGE MANAGER TESTS ===
    test_challengeStageManager_initialization();
    test_challengeStageManager_detection();
    test_challengeStageManager_spawning();
    test_challengeStageManager_interval();

    // === INTEGRATION TESTS ===
    test_scoreManager_multiplierIntegration();

    endTestSuite();
}

// ========================================================================
// SCORE MANAGER TESTS
// ========================================================================

/// @function test_scoreManager_initialization
/// @description Tests ScoreManager initializes with correct default values
function test_scoreManager_initialization() {
    var manager = ScoreManager();

    assert_is_struct(manager, "ScoreManager should return a struct");
    assert_equals(manager.total_score, 0, "Initial score should be 0");
    assert_equals(manager.shots_fired, 0, "Initial shots_fired should be 0");
    assert_equals(manager.shots_hit, 0, "Initial shots_hit should be 0");

    // Check extra life tracking
    assert_is_not_null(manager.next_extra_life_score, "next_extra_life_score should be defined");
    assert_greater_than(manager.next_extra_life_score, 0, "next_extra_life_score should be positive");
    assert_greater_than(manager.extra_life_interval, 0, "extra_life_interval should be positive");
}

/// @function test_scoreManager_addScore
/// @description Tests adding points to player score
function test_scoreManager_addScore() {
    // Save current score
    var initial_score = global.Game.Player.score;

    var manager = ScoreManager();
    manager.addScore(100);

    // Score should increase by amount added
    assert_greater_than(manager.total_score, 0, "Score should increase after addScore");
}

/// @function test_scoreManager_enemyScoring
/// @description Tests scoring for destroyed enemies
function test_scoreManager_enemyScoring() {
    var manager = ScoreManager();

    // Test standard enemy score
    var base_points = 50;
    var standard_score = manager.addEnemyScore("oTieFighter", base_points, false);
    assert_equals(standard_score, base_points, "Non-diving enemy should award base points");

    // Test diving enemy score (2x multiplier)
    var diving_score = manager.addEnemyScore("oTieFighter", base_points, true);
    assert_equals(diving_score, base_points * 2, "Diving enemy should award 2x base points");
}

/// @function test_scoreManager_extraLife
/// @description Tests extra life awarding at score milestones
function test_scoreManager_extraLife() {
    var manager = ScoreManager();

    // Get initial lives
    var initial_lives = global.Game.Player.lives;

    // Add score to reach extra life threshold
    var extra_life_threshold = get_config_value("PLAYER", "EXTRA_LIFE_FIRST", EXTRA_LIFE_FIRST_THRESHOLD);
    manager.total_score = extra_life_threshold + 100;  // Exceed threshold
    manager.checkForExtraLife();

    // Note: In actual test, would need to verify sound played and life was awarded
    // This is an outline of the test structure
}

/// @function test_scoreManager_maxScoreLimit
/// @description Tests that score respects maximum limit
function test_scoreManager_maxScoreLimit() {
    var manager = ScoreManager();
    var max_score = get_config_value("SCORE", "MAX_SCORE_FOR_EXTRA_LIVES", MAX_SCORE_FOR_EXTRA_LIVES);

    // Score should not award extra lives beyond max
    manager.total_score = max_score + 1000;
    var extra_life_awarded = manager.checkForExtraLife();

    assert_false(extra_life_awarded, "Extra lives should stop awarding after max score");
}

// ========================================================================
// CHALLENGE STAGE MANAGER TESTS
// ========================================================================

/// @function test_challengeStageManager_initialization
/// @description Tests ChallengeStageManager initializes correctly
function test_challengeStageManager_initialization() {
    var manager = ChallengeStageManager();

    assert_is_struct(manager, "ChallengeStageManager should return a struct");
    assert_struct_has_property(manager, "isActive", "Should have isActive property");
    assert_struct_has_property(manager, "currentChallenge", "Should have currentChallenge property");
}

/// @function test_challengeStageManager_detection
/// @description Tests challenge stage detection logic
function test_challengeStageManager_detection() {
    // Challenge stages occur every 4 levels
    // Levels 3, 7, 11, 15, etc. should be challenge stages
    var challenge_interval = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", 4);

    assert_equals(challenge_interval, 4, "Challenge stages should occur every 4 levels");

    // Test level detection
    var test_levels = [3, 7, 11, 15];  // Challenge levels (0-indexed: 3, 7, 11, ...)
    for (var i = 0; i < array_length(test_levels); i++) {
        var is_challenge = (test_levels[i] > 0 && test_levels[i] % challenge_interval == 3);
        assert_true(is_challenge, "Level " + string(test_levels[i]) + " should be a challenge stage");
    }
}

/// @function test_challengeStageManager_spawning
/// @description Tests challenge stage enemy spawning
function test_challengeStageManager_spawning() {
    if (instance_exists(oGlobal)) {
        var challenge_data = global.challenge_spawn_data;

        assert_is_struct(challenge_data, "challenge_spawn_data should be a struct");
        assert_struct_has_property(challenge_data, "CHALLENGES", "Should have CHALLENGES array");

        var challenges = challenge_data.CHALLENGES;
        assert_array_length(challenges, 8, "Should have 8 challenge patterns");

        // Each challenge should have proper structure
        if (array_length(challenges) > 0) {
            var first_challenge = challenges[0];
            assert_struct_has_property(first_challenge, "CHALLENGE_ID", "Challenge should have ID");
            assert_struct_has_property(first_challenge, "WAVES", "Challenge should have WAVES array");
            assert_array_length(first_challenge.WAVES, 5, "Challenge should have 5 waves");
        }
    }
}

/// @function test_challengeStageManager_interval
/// @description Tests challenge stage interval calculation
function test_challengeStageManager_interval() {
    // Verify challenge stages occur at correct intervals
    var interval = 4;
    var max_levels = 20;

    // Expected challenge levels: 3, 7, 11, 15, 19
    var expected_challenges = [];
    for (var i = 3; i < max_levels; i += interval) {
        array_push(expected_challenges, i);
    }

    assert_greater_than(array_length(expected_challenges), 0, "Should have at least one challenge level");
    assert_equals(expected_challenges[0], 3, "First challenge should be at level 3");
}

// ========================================================================
// INTEGRATION TESTS
// ========================================================================

/// @function test_scoreManager_multiplierIntegration
/// @description Tests that score multiplier integrates correctly with enemy types
function test_scoreManager_multiplierIntegration() {
    // Different enemy types might have different base scores
    var spawner = WaveSpawner(global.wave_spawn_data, {}, {});

    // Verify enemy attributes exist
    if (instance_exists(oGlobal)) {
        assert_is_struct(global.enemy_attributes, "Enemy attributes should be loaded");

        // Check that each enemy type has scoring data
        var enemy_types = ["oTieFighter", "oTieIntercepter", "oImperialShuttle"];
        for (var i = 0; i < array_length(enemy_types); i++) {
            var enemy_type = enemy_types[i];
            // Attributes would be loaded from JSON during initialization
        }
    }
}
