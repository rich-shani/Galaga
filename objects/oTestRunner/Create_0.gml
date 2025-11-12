/// @file oTestRunner Create Event
/// @description Initialize test runner and execute all test suites
///
/// USAGE:
///   Place this object in a test room to run all unit tests
///   Tests will run on object creation and report results to console
///   Object destroys itself after tests complete

// === INITIALIZE TEST FRAMEWORK ===
resetTestResults();

// === RUN ALL TEST SUITES ===
show_debug_message("");
show_debug_message("╔════════════════════════════════════════════════════════════════╗");
show_debug_message("║                    GALAGA WARS TEST SUITE                      ║");
show_debug_message("╚════════════════════════════════════════════════════════════════╝");
show_debug_message("");

// Run High Score System tests
runHighScoreSystemTests();

// Run Level Progression tests
runLevelProgressionTests();

// Run Enemy Management tests
runEnemyManagementTests();

// Run Beam Weapon Logic tests
runBeamWeaponLogicTests();

// === REPORT FINAL RESULTS ===
reportTestResults();

// === CLEANUP ===
// Set alarm to destroy test runner after 1 frame
// This gives debug output time to flush
alarm[0] = 1;
