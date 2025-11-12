/// @file TestHighScoreSystem.gml
/// @description Test suite for high score system functions
///
/// TESTS:
///   - shift_scores_for_new_high_score() - Array manipulation and score insertion
///   - High score boundary conditions
///   - Initial entry validation

/// @function runHighScoreSystemTests
/// @description Runs all high score system tests
function runHighScoreSystemTests() {
    beginTestSuite("HighScoreSystem");

    test_shift_scores_insertsAtPosition1();
    test_shift_scores_insertsAtPosition3();
    test_shift_scores_insertsAtPosition5();
    test_shift_scores_preservesHigherScores();
    test_shift_scores_shiftsInitials();
    test_shift_scores_setsBlankInitials();
    test_shift_scores_updatesDisplay();

    endTestSuite();
}

/// @function test_shift_scores_insertsAtPosition1
/// @description Test inserting new high score at position 1 (top score)
function test_shift_scores_insertsAtPosition1() {
    // Setup: Initial high scores
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];

    // Execute: Insert 15000 at position 1
    shift_scores_for_new_high_score(1, 15000);

    // Assert: New score at top, others shifted down
    assert_equals(global.Game.HighScores.scores[0], 15000, "New score should be at position 1");
    assert_equals(global.Game.HighScores.scores[1], 10000, "Old position 1 should move to position 2");
    assert_equals(global.Game.HighScores.scores[2], 5000, "Old position 2 should move to position 3");
    assert_equals(global.Game.HighScores.scores[3], 2000, "Old position 3 should move to position 4");
    assert_equals(global.Game.HighScores.scores[4], 1000, "Old position 4 should move to position 5");
}

/// @function test_shift_scores_insertsAtPosition3
/// @description Test inserting new high score at middle position
function test_shift_scores_insertsAtPosition3() {
    // Setup
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];

    // Execute: Insert 3500 at position 3
    shift_scores_for_new_high_score(3, 3500);

    // Assert: Scores above position 3 unchanged, scores at/below shifted
    assert_equals(global.Game.HighScores.scores[0], 10000, "Position 1 unchanged");
    assert_equals(global.Game.HighScores.scores[1], 5000, "Position 2 unchanged");
    assert_equals(global.Game.HighScores.scores[2], 3500, "New score at position 3");
    assert_equals(global.Game.HighScores.scores[3], 2000, "Old position 3 moved to position 4");
    assert_equals(global.Game.HighScores.scores[4], 1000, "Old position 4 moved to position 5");
}

/// @function test_shift_scores_insertsAtPosition5
/// @description Test inserting new high score at lowest position
function test_shift_scores_insertsAtPosition5() {
    // Setup
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];

    // Execute: Insert 750 at position 5
    shift_scores_for_new_high_score(5, 750);

    // Assert: Only position 5 changes, all others unchanged
    assert_equals(global.Game.HighScores.scores[0], 10000, "Position 1 unchanged");
    assert_equals(global.Game.HighScores.scores[1], 5000, "Position 2 unchanged");
    assert_equals(global.Game.HighScores.scores[2], 2000, "Position 3 unchanged");
    assert_equals(global.Game.HighScores.scores[3], 1000, "Position 4 unchanged");
    assert_equals(global.Game.HighScores.scores[4], 750, "New score at position 5");
}

/// @function test_shift_scores_preservesHigherScores
/// @description Test that scores higher than insert position are preserved
function test_shift_scores_preservesHigherScores() {
    // Setup
    global.Game.HighScores.scores = [50000, 40000, 30000, 20000, 10000];
    global.Game.HighScores.initials = ["TOP", "SEC", "THR", "FOR", "FIF"];

    // Execute: Insert at position 4
    shift_scores_for_new_high_score(4, 25000);

    // Assert: Positions 1-3 completely unchanged
    assert_equals(global.Game.HighScores.scores[0], 50000, "Top score preserved");
    assert_equals(global.Game.HighScores.scores[1], 40000, "Second score preserved");
    assert_equals(global.Game.HighScores.scores[2], 30000, "Third score preserved");
    assert_equals(global.Game.HighScores.initials[0], "TOP", "Top initials preserved");
    assert_equals(global.Game.HighScores.initials[1], "SEC", "Second initials preserved");
    assert_equals(global.Game.HighScores.initials[2], "THR", "Third initials preserved");
}

/// @function test_shift_scores_shiftsInitials
/// @description Test that initials are shifted correctly with scores
function test_shift_scores_shiftsInitials() {
    // Setup
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];

    // Execute: Insert at position 2
    shift_scores_for_new_high_score(2, 7500);

    // Assert: Initials shifted correctly
    assert_equals(global.Game.HighScores.initials[0], "AAA", "Position 1 initials unchanged");
    assert_equals(global.Game.HighScores.initials[1], "   ", "Position 2 has blank initials for new score");
    assert_equals(global.Game.HighScores.initials[2], "BBB", "Old position 2 initials moved to position 3");
    assert_equals(global.Game.HighScores.initials[3], "CCC", "Old position 3 initials moved to position 4");
    assert_equals(global.Game.HighScores.initials[4], "DDD", "Old position 4 initials moved to position 5");
}

/// @function test_shift_scores_setsBlankInitials
/// @description Test that new score gets blank initials for entry
function test_shift_scores_setsBlankInitials() {
    // Setup
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];

    // Execute: Insert at position 1
    shift_scores_for_new_high_score(1, 15000);

    // Assert: New score has blank initials (3 spaces)
    assert_equals(global.Game.HighScores.initials[0], "   ", "New score should have blank initials");
    assert_equals(string_length(global.Game.HighScores.initials[0]), 3, "Blank initials should be 3 characters");
}

/// @function test_shift_scores_updatesDisplay
/// @description Test that display high score is updated to new top score
function test_shift_scores_updatesDisplay() {
    // Setup
    global.Game.HighScores.scores = [10000, 5000, 2000, 1000, 500];
    global.Game.HighScores.initials = ["AAA", "BBB", "CCC", "DDD", "EEE"];
    global.Game.HighScores.display = 10000;

    // Execute: Insert new top score
    shift_scores_for_new_high_score(1, 25000);

    // Assert: Display updated to new top score
    assert_equals(global.Game.HighScores.display, 25000, "Display should update to new top score");
}
