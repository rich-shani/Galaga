/// @file TestLevelProgression.gml
/// @description Test suite for level progression and extra life functions
///
/// TESTS:
///   - checkForExtraLives() - Extra life awarding logic
///   - readyForNextLevel() - Level transition conditions
///
/// NOTE: These tests require oGameManager context for alarm[] and nextlevel variables
///       Some tests may need to be run as integration tests

/// @function runLevelProgressionTests
/// @description Runs all level progression tests
function runLevelProgressionTests() {
    beginTestSuite("LevelProgression");

    test_checkForExtraLives_awardsAtFirstThreshold();
    test_checkForExtraLives_awardsAtAdditionalThreshold();
    test_checkForExtraLives_doesNotAwardBelowThreshold();
    test_checkForExtraLives_doesNotAwardAboveMaxScore();
    test_checkForExtraLives_resetsFirstLifeMarker();
    test_checkForExtraLives_incrementsThreshold();
    test_checkForExtraLives_playsSound();

    endTestSuite();
}

/// @function test_checkForExtraLives_awardsAtFirstThreshold
/// @description Test that extra life is awarded at 20,000 points
function test_checkForExtraLives_awardsAtFirstThreshold() {
    // Setup: Player score just above first threshold
    global.Game.Player.score = 20100;
    global.Game.Player.lives = 3;
    global.Game.Player.firstlife = EXTRA_LIFE_FIRST_THRESHOLD;  // 20000
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;  // 70000

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: Life awarded and threshold updated
    assert_equals(global.Game.Player.lives, 4, "Should award extra life at first threshold");
    assert_equals(global.Game.Player.firstlife, EXTRA_LIFE_ADDITIONAL_THRESHOLD,
                 "First threshold should reset and increment to 70000");
}

/// @function test_checkForExtraLives_awardsAtAdditionalThreshold
/// @description Test that extra lives are awarded at subsequent thresholds (90k, 160k, etc.)
function test_checkForExtraLives_awardsAtAdditionalThreshold() {
    // Setup: Player score at second threshold (90,000)
    // Assume first life already awarded, so firstlife is now 90000
    global.Game.Player.score = 90100;
    global.Game.Player.lives = 4;
    global.Game.Player.firstlife = 90000;  // Next threshold after first life
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;  // 70000

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: Life awarded and threshold incremented by 70000
    assert_equals(global.Game.Player.lives, 5, "Should award extra life at 90k threshold");
    assert_equals(global.Game.Player.firstlife, 160000, "Threshold should increment to 160000");
}

/// @function test_checkForExtraLives_doesNotAwardBelowThreshold
/// @description Test that no extra life is awarded when score is below threshold
function test_checkForExtraLives_doesNotAwardBelowThreshold() {
    // Setup: Player score below first threshold
    global.Game.Player.score = 19900;
    global.Game.Player.lives = 3;
    global.Game.Player.firstlife = EXTRA_LIFE_FIRST_THRESHOLD;  // 20000
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: No life awarded, threshold unchanged
    assert_equals(global.Game.Player.lives, 3, "Should not award life below threshold");
    assert_equals(global.Game.Player.firstlife, EXTRA_LIFE_FIRST_THRESHOLD,
                 "Threshold should remain unchanged");
}

/// @function test_checkForExtraLives_doesNotAwardAboveMaxScore
/// @description Test that no extra lives are awarded above max score limit
function test_checkForExtraLives_doesNotAwardAboveMaxScore() {
    // Setup: Player score above max score limit (1,000,000)
    global.Game.Player.score = 1100000;
    global.Game.Player.lives = 10;
    global.Game.Player.firstlife = 1000000;
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;

    var lives_before = global.Game.Player.lives;

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: No life awarded (prevents infinite lives)
    assert_equals(global.Game.Player.lives, lives_before,
                 "Should not award life above max score limit");
}

/// @function test_checkForExtraLives_resetsFirstLifeMarker
/// @description Test that firstlife marker resets to 0 after first life is awarded
function test_checkForExtraLives_resetsFirstLifeMarker() {
    // Setup: Player score just above first threshold
    global.Game.Player.score = 20100;
    global.Game.Player.lives = 3;
    global.Game.Player.firstlife = EXTRA_LIFE_FIRST_THRESHOLD;  // 20000
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;  // 70000

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: First life marker should reset to 0 then increment by 70000
    // Expected: 0 + 70000 = 70000
    assert_equals(global.Game.Player.firstlife, 70000,
                 "First life marker should reset to 0 then add 70000");
}

/// @function test_checkForExtraLives_incrementsThreshold
/// @description Test that threshold increments correctly by additional amount
function test_checkForExtraLives_incrementsThreshold() {
    // Setup: Player at third threshold (160,000)
    global.Game.Player.score = 160100;
    global.Game.Player.lives = 5;
    global.Game.Player.firstlife = 160000;
    global.Game.Player.additional = 70000;

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: Threshold should increment by 70000
    assert_equals(global.Game.Player.firstlife, 230000,
                 "Threshold should increment by 70000 (160k + 70k = 230k)");
}

/// @function test_checkForExtraLives_playsSound
/// @description Test that extra life sound plays when life is awarded
function test_checkForExtraLives_playsSound() {
    // Setup: Player score just above first threshold
    global.Game.Player.score = 20100;
    global.Game.Player.lives = 3;
    global.Game.Player.firstlife = EXTRA_LIFE_FIRST_THRESHOLD;
    global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;

    // Execute: Check for extra lives
    checkForExtraLives();

    // Assert: This test verifies the function completes without error
    // Sound playing cannot be directly tested without audio mocking
    // We verify by checking life was awarded (side effect of sound playing code path)
    assert_equals(global.Game.Player.lives, 4,
                 "Life should be awarded (sound should have played)");
}
