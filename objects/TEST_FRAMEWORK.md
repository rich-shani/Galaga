# Test Framework Documentation

**Date:** 2025-11-11
**Version:** 1.0
**Status:** ✅ COMPLETE

---

## 📊 Overview

The Galaga Wars Test Framework provides a comprehensive unit testing system for GameMaker Studio 2 projects. Built specifically for game logic testing, it includes assertion functions, test suite organization, and detailed reporting.

### **Key Features**

- **9 Assertion Functions** - Comprehensive validation options
- **Test Suite Organization** - Group related tests logically
- **Detailed Reporting** - Pass/fail counts, timing, and failure details
- **Easy Integration** - Simple object-based test execution
- **Console Output** - Debug-friendly test results

---

## 🚀 Quick Start

### **Running Tests**

1. **Open GameMaker Studio 2** and load the Galaga project
2. **Create a test room** (or use existing room)
3. **Place `oTestRunner` object** in the room
4. **Run the game** (F5)
5. **View results** in the Output window

That's it! All tests will run automatically and display results in the console.

---

## 📁 Framework Structure

```
scripts/
├── TestFramework/
│   ├── TestFramework.gml          # Core framework (assertion functions)
│   └── TestFramework.yy
├── TestHighScoreSystem/
│   ├── TestHighScoreSystem.gml    # High score tests (7 tests)
│   └── TestHighScoreSystem.yy
├── TestLevelProgression/
│   ├── TestLevelProgression.gml   # Level progression tests (7 tests)
│   └── TestLevelProgression.yy
├── TestEnemyManagement/
│   ├── TestEnemyManagement.gml    # Enemy management tests (13 tests)
│   └── TestEnemyManagement.yy
└── TestBeamWeaponLogic/
    ├── TestBeamWeaponLogic.gml    # Beam weapon tests (13 tests)
    └── TestBeamWeaponLogic.yy

objects/
└── oTestRunner/
    ├── Create_0.gml               # Test execution
    ├── Alarm_0.gml                # Cleanup
    └── oTestRunner.yy
```

**Total:** 40 tests across 4 test suites

---

## ✅ Assertion Functions Reference

### **Equality Assertions**

#### `assert_equals(actual, expected, message)`
Asserts that two values are equal using `==` comparison.

```gml
assert_equals(global.Game.Player.lives, 3, "Player should start with 3 lives");
assert_equals(enemy.health, 2, "TIE Interceptor should have 2 health");
```

#### `assert_not_equals(actual, not_expected, message)`
Asserts that two values are NOT equal.

```gml
assert_not_equals(player.x, 0, "Player should not be at x=0");
```

---

### **Boolean Assertions**

#### `assert_true(condition, message)`
Asserts that a condition is true.

```gml
assert_true(instance_exists(oPlayer), "Player should exist");
assert_true(global.Game.State.mode == GameMode.GAME_ACTIVE, "Game should be active");
```

#### `assert_false(condition, message)`
Asserts that a condition is false.

```gml
assert_false(global.Game.Enemy.capturedPlayer, "No player should be captured");
```

---

### **Numeric Comparisons**

#### `assert_greater_than(actual, threshold, message)`
Asserts that actual value is greater than threshold (exclusive).

```gml
assert_greater_than(global.Game.Player.score, 0, "Score should be positive");
```

#### `assert_less_than(actual, threshold, message)`
Asserts that actual value is less than threshold (exclusive).

```gml
assert_less_than(global.Game.Enemy.diveCapacity, 10, "Dive capacity should be capped");
```

#### `assert_in_range(actual, min, max, message)`
Asserts that value is within specified range (inclusive).

```gml
assert_in_range(enemy.x, 0, room_width, "Enemy should be within room bounds");
```

---

### **Instance Assertions**

#### `assert_instance_exists(object_type, message)`
Asserts that an instance of given object exists.

```gml
assert_instance_exists(oGameManager, "Game manager should exist");
```

#### `assert_instance_not_exists(object_type, message)`
Asserts that no instance of given object exists.

```gml
assert_instance_not_exists(oMissile, "No missiles should be active");
```

---

## 📝 Writing Tests

### **Test Function Template**

```gml
/// @function test_functionName_behaviorDescription
/// @description Brief explanation of what this test validates
function test_functionName_behaviorDescription() {
    // === SETUP ===
    // Arrange test preconditions
    var saved_value = global.Game.Player.score;
    global.Game.Player.score = 20100;

    // === EXECUTE ===
    // Call the function being tested
    checkForExtraLives();

    // === ASSERT ===
    // Verify expected behavior
    assert_equals(global.Game.Player.lives, 4, "Should award extra life at 20k");

    // === CLEANUP ===
    // Restore original state
    global.Game.Player.score = saved_value;
}
```

---

### **Test Suite Template**

```gml
/// @file TestMyFeature.gml
/// @description Test suite for my feature functions

/// @function runMyFeatureTests
/// @description Runs all my feature tests
function runMyFeatureTests() {
    beginTestSuite("MyFeature");

    test_myFunction_returnsExpectedValue();
    test_myFunction_handlesEdgeCase();
    test_myFunction_throwsErrorOnInvalidInput();

    endTestSuite();
}

// Individual test functions follow...
```

---

## 🎯 Test Suite Organization

### **Test Naming Convention**

Use descriptive names following this pattern:

```
test_[functionName]_[behavior]_[condition]
```

**Examples:**
- `test_checkForExtraLives_awardsAtFirstThreshold()`
- `test_canTransform_returnsFalseWhenNoPlayer()`
- `test_shift_scores_insertsAtPosition1()`

---

### **Test Categories**

1. **Unit Tests** - Test single function in isolation
2. **Integration Tests** - Test multiple components together
3. **State Tests** - Verify state transitions work correctly
4. **Edge Case Tests** - Test boundary conditions

---

## 🔧 Test Suite Management

### **Core Functions**

#### `resetTestResults()`
Clears all test results and prepares for new test run. Called automatically by `oTestRunner`.

#### `beginTestSuite(suite_name)`
Marks the start of a test suite. Groups tests logically.

```gml
beginTestSuite("HighScoreSystem");
```

#### `endTestSuite()`
Marks the end of a test suite. Prints separator line.

#### `reportTestResults()`
Prints comprehensive test results to console. Called automatically by `oTestRunner`.

#### `getTestPassRate()`
Returns test pass rate as percentage (0-100).

```gml
var pass_rate = getTestPassRate();
if (pass_rate < 80) {
    show_debug_message("WARNING: Pass rate below 80%!");
}
```

#### `didAllTestsPass()`
Returns true if all tests passed, false otherwise.

```gml
if (didAllTestsPass()) {
    show_debug_message("✓ ALL TESTS PASSED!");
}
```

---

## 📊 Test Results Output

### **Example Output**

```
╔════════════════════════════════════════════════════════════════╗
║                    GALAGA WARS TEST SUITE                      ║
╚════════════════════════════════════════════════════════════════╝

========================================
TEST SUITE: HighScoreSystem
========================================
[PASS] New score should be at position 1
[PASS] Old position 1 should move to position 2
[PASS] Position 1 unchanged
[FAIL] Display should update to new top score
       Expected: 25000
       Actual:   10000
========================================

########################################
# TEST RESULTS SUMMARY
########################################

Total Tests:  40
Passed:       38 (95%)
Failed:       2
Skipped:      0
Duration:     127 ms

FAILED TESTS:
----------------------------------------
 - HighScoreSystem::Display should update to new top score
   Expected: 25000
   Actual:   10000
 - BeamWeaponLogic::Capture window should be active
   Expected: true
   Actual:   false

✗ 2 TEST(S) FAILED
########################################
```

---

## 🏗️ Adding New Tests

### **Step 1: Create Test Suite File**

Create `scripts/TestMyFeature/TestMyFeature.gml`:

```gml
/// @file TestMyFeature.gml
/// @description Test suite for my feature functions

function runMyFeatureTests() {
    beginTestSuite("MyFeature");

    test_myFunction_basicBehavior();
    test_myFunction_edgeCases();

    endTestSuite();
}

function test_myFunction_basicBehavior() {
    // Setup
    var input = 5;

    // Execute
    var result = myFunction(input);

    // Assert
    assert_equals(result, 10, "myFunction should double input");
}

function test_myFunction_edgeCases() {
    var result = myFunction(0);
    assert_equals(result, 0, "myFunction should handle zero");
}
```

---

### **Step 2: Create Resource File**

Create `scripts/TestMyFeature/TestMyFeature.yy`:

```json
{
  "$GMScript":"v1",
  "%Name":"TestMyFeature",
  "isCompatibility":false,
  "isDnD":false,
  "name":"TestMyFeature",
  "parent":{
    "name":"Scripts",
    "path":"folders/Scripts.yy",
  },
  "resourceType":"GMScript",
  "resourceVersion":"2.0",
}
```

---

### **Step 3: Add to Project**

Add to `Galaga.yyp` in alphabetical order:

```json
{"id":{"name":"TestMyFeature","path":"scripts/TestMyFeature/TestMyFeature.yy",},},
```

---

### **Step 4: Add to Test Runner**

Update `objects/oTestRunner/Create_0.gml`:

```gml
// Add after existing test suites
runMyFeatureTests();
```

---

## 🎮 Integration Testing

Some functions require game instances (enemies, player, etc.) to test properly. For these, use integration tests:

### **Example: Testing with Enemy Instances**

```gml
function test_nOfEnemies_countsSingleEnemyType() {
    // NOTE: This test requires actual game room context
    // Should be run in test room with layer "GameSprites"

    // Setup: Create test enemies
    var enemy1 = instance_create_layer(100, 100, "GameSprites", oTieFighter);
    var enemy2 = instance_create_layer(200, 100, "GameSprites", oTieFighter);

    // Execute: Count enemies
    var count = nOfEnemies();

    // Assert: Count should match created instances
    assert_equals(count, 2, "Should count both TieFighter instances");

    // Cleanup: Destroy test instances
    instance_destroy(enemy1);
    instance_destroy(enemy2);
}
```

### **Integration Test Guidelines**

1. **Create Instances** - Use `instance_create_layer()`
2. **Setup State** - Configure instance variables as needed
3. **Execute Function** - Call function from appropriate context
4. **Assert Results** - Verify behavior
5. **Cleanup** - Always destroy created instances

---

## 🐛 Troubleshooting

### **Tests Not Running**

**Problem:** No output in console
**Solution:** Ensure `oTestRunner` is placed in the room and the game is running

### **Function Not Found Errors**

**Problem:** `Variable not set before reading it` or `Unknown function`
**Solution:**
- Verify test suite script is added to `Galaga.yyp`
- Check that test runner calls `runYourTestSuite()`
- Ensure GameMaker has recompiled scripts (Clean and Build)

### **Global Variable Not Initialized**

**Problem:** `Variable not set before reading it` for globals
**Solution:** Ensure `oGlobalVars` or `oGameManager` initializes before tests run

### **Instance Context Errors**

**Problem:** `Unable to find instance for variable` errors
**Solution:** Some tests require instance context:

```gml
// ❌ WRONG (tries to access instance variable without context)
var result = canTransform();

// ✅ CORRECT (called from instance context)
with (oTieFighter) {
    var result = canTransform();
}
```

### **Test Pollution**

**Problem:** Tests pass when run individually but fail when run together
**Solution:** Ensure proper cleanup - restore global state after each test

```gml
function test_myFunction() {
    // Save state
    var saved_value = global.Game.Player.score;

    // Test logic...

    // Restore state
    global.Game.Player.score = saved_value;
}
```

---

## 📈 Test Coverage

### **Current Coverage**

| Module | Functions Tested | Test Count | Coverage |
|--------|-----------------|------------|----------|
| HighScoreSystem | 1 / 2 | 7 | ~50% |
| LevelProgression | 1 / 2 | 7 | ~50% |
| EnemyManagement | 3 / 4 | 13 | ~75% |
| BeamWeaponLogic | 10 / 10 | 13 | 100% |

**Total:** 40 tests covering core game logic functions

---

## 🎯 Best Practices

### **1. Test One Thing Per Function**

```gml
// ✅ GOOD - Tests specific behavior
function test_checkForExtraLives_awardsAtFirstThreshold() {
    // Test only first threshold (20k)
}

// ❌ BAD - Tests too many behaviors
function test_checkForExtraLives() {
    // Tests first threshold, additional threshold, max score, etc.
}
```

---

### **2. Use Descriptive Test Names**

```gml
// ✅ GOOD - Clear what's being tested
function test_canTransform_returnsFalseWhenPlayerNotActive()

// ❌ BAD - Unclear what's being tested
function test_canTransform2()
```

---

### **3. Always Clean Up**

```gml
function test_myFunction() {
    // Save original state
    var saved_lives = global.Game.Player.lives;

    // Test logic...
    global.Game.Player.lives = 5;
    checkForExtraLives();

    // Restore original state
    global.Game.Player.lives = saved_lives;
}
```

---

### **4. Test Edge Cases**

```gml
function test_shift_scores_insertsAtPosition5() {
    // Test lowest position (edge case)
}

function test_checkForExtraLives_doesNotAwardAboveMaxScore() {
    // Test upper boundary (edge case)
}
```

---

### **5. Use Meaningful Assertion Messages**

```gml
// ✅ GOOD - Explains expected behavior
assert_equals(lives, 4, "Should award extra life at 20k threshold");

// ❌ BAD - Generic message
assert_equals(lives, 4, "Failed");
```

---

## 🚧 Limitations

### **Current Limitations**

1. **No Mocking Framework** - Cannot mock instance_exists(), random(), etc.
2. **No Spy Functions** - Cannot verify sound_play() was called
3. **Instance Context Required** - Many functions need enemy/player instances
4. **No Async Testing** - Cannot test alarm callbacks directly
5. **No Visual Testing** - Cannot verify sprite rendering

### **Workarounds**

- Use integration tests for instance-dependent functions
- Document sound/visual behavior in test comments
- Test alarm logic by setting alarm values and checking state

---

## 🔮 Future Enhancements

### **Phase 1: Enhanced Assertions**

- `assert_approximately_equals(actual, expected, tolerance)` - For float comparisons
- `assert_array_equals(array1, array2)` - Deep array comparison
- `assert_struct_equals(struct1, struct2)` - Deep struct comparison

### **Phase 2: Test Utilities**

- `createMockPlayer()` - Create test player instance
- `createMockEnemy(type)` - Create test enemy instance
- `setupTestRoom()` - Initialize test environment
- `cleanupTestRoom()` - Destroy all test instances

### **Phase 3: Advanced Features**

- Test fixture management (setup/teardown)
- Parameterized tests (run same test with different inputs)
- Test timing measurements per test
- HTML test report generation

---

## 📚 References

### **Related Files**

- `scripts/TestFramework/TestFramework.gml` - Core framework implementation
- `scripts/HighScoreSystem/HighScoreSystem.gml` - Functions being tested
- `scripts/LevelProgression/LevelProgression.gml` - Level progression logic
- `scripts/EnemyManagement/EnemyManagement.gml` - Enemy management functions
- `scripts/BeamWeaponLogic/BeamWeaponLogic.gml` - Beam weapon logic

### **Key Concepts**

- **Assertion** - Statement that verifies expected behavior
- **Test Suite** - Collection of related test functions
- **Test Runner** - Object that executes all tests
- **Test Fixture** - Setup/teardown code for tests
- **Test Coverage** - Percentage of code tested by test suite

---

## ✅ Verification Checklist

- [x] Test framework created with 9 assertion functions
- [x] Test result tracking and reporting system
- [x] 4 test suites created (40 total tests)
- [x] Test runner object created
- [x] All test files added to project
- [x] Documentation complete
- [x] Integration test guidelines provided
- [x] Troubleshooting guide included

---

**Framework Created:** 2025-11-11
**Author:** Claude (AI Assistant)
**Framework Version:** 1.0
**License:** MIT (same as project)
