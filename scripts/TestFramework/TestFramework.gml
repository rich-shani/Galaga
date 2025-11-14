/// @file TestFramework.gml
/// @description Core testing framework for unit and integration tests
///
/// USAGE:
///   1. Create test functions in test suite files (TestHighScoreSystem.gml, etc.)
///   2. Call test functions from runAllTests() or test runner object
///   3. View results in console output or test report
///
/// EXAMPLE:
///   function test_myFunction_returnsExpectedValue() {
///       var result = myFunction(5);
///       assert_equals(result, 10, "myFunction should double input");
///   }

// ========================================================================
// TEST RESULT TRACKING
// ========================================================================

/// @description Global test results struct
global.test_results = {
    total: 0,
    passed: 0,
    failed: 0,
    skipped: 0,
    tests: [],
    current_suite: "",
    start_time: 0,
    end_time: 0
};

/// @function resetTestResults
/// @description Clears all test results and prepares for new test run
function resetTestResults() {
    global.test_results = {
        total: 0,
        passed: 0,
        failed: 0,
        skipped: 0,
        tests: [],
        current_suite: "",
        start_time: get_timer(),
        end_time: 0
    };
}

/// @function beginTestSuite
/// @description Marks the start of a test suite
/// @param {String} suite_name Name of the test suite
function beginTestSuite(suite_name) {
    global.test_results.current_suite = suite_name;
    show_debug_message("");
    show_debug_message("========================================");
    show_debug_message("TEST SUITE: " + suite_name);
    show_debug_message("========================================");
}

/// @function endTestSuite
/// @description Marks the end of a test suite
function endTestSuite() {
    global.test_results.current_suite = "";
    show_debug_message("========================================");
}

// ========================================================================
// ASSERTION FUNCTIONS
// ========================================================================

/// @function assert_equals
/// @description Asserts that two values are equal
/// @param {Any} actual The actual value from code
/// @param {Any} expected The expected value
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_equals(actual, expected, message) {
    global.test_results.total++;

    var passed = (actual == expected);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: expected,
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Expected: " + string(expected));
        show_debug_message("       Actual:   " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: expected,
            actual: actual
        });

        return false;
    }
}

/// @function assert_not_equals
/// @description Asserts that two values are NOT equal
/// @param {Any} actual The actual value from code
/// @param {Any} not_expected The value that should NOT match
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_not_equals(actual, not_expected, message) {
    global.test_results.total++;

    var passed = (actual != not_expected);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: "!= " + string(not_expected),
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Should NOT equal: " + string(not_expected));
        show_debug_message("       But was:          " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: "!= " + string(not_expected),
            actual: actual
        });

        return false;
    }
}

/// @function assert_true
/// @description Asserts that a condition is true
/// @param {Bool} condition The condition to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_true(condition, message) {
    return assert_equals(condition, true, message);
}

/// @function assert_false
/// @description Asserts that a condition is false
/// @param {Bool} condition The condition to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_false(condition, message) {
    return assert_equals(condition, false, message);
}

/// @function assert_greater_than
/// @description Asserts that actual value is greater than expected
/// @param {Real} actual The actual value
/// @param {Real} threshold The minimum value (exclusive)
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_greater_than(actual, threshold, message) {
    global.test_results.total++;

    var passed = (actual > threshold);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: "> " + string(threshold),
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Expected: > " + string(threshold));
        show_debug_message("       Actual:   " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: "> " + string(threshold),
            actual: actual
        });

        return false;
    }
}

/// @function assert_less_than
/// @description Asserts that actual value is less than expected
/// @param {Real} actual The actual value
/// @param {Real} threshold The maximum value (exclusive)
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_less_than(actual, threshold, message) {
    global.test_results.total++;

    var passed = (actual < threshold);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: "< " + string(threshold),
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Expected: < " + string(threshold));
        show_debug_message("       Actual:   " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: "< " + string(threshold),
            actual: actual
        });

        return false;
    }
}

/// @function assert_in_range
/// @description Asserts that value is within specified range (inclusive)
/// @param {Real} actual The actual value
/// @param {Real} min Minimum value (inclusive)
/// @param {Real} max Maximum value (inclusive)
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_in_range(actual, min, max, message) {
    global.test_results.total++;

    var passed = (actual >= min && actual <= max);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: string(min) + " to " + string(max),
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Expected range: " + string(min) + " to " + string(max));
        show_debug_message("       Actual:         " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: string(min) + " to " + string(max),
            actual: actual
        });

        return false;
    }
}

/// @function assert_instance_exists
/// @description Asserts that an instance of given object exists
/// @param {Asset.GMObject} object_type The object type to check
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_instance_exists(object_type, message) {
    return assert_true(instance_exists(object_type), message);
}

/// @function assert_instance_not_exists
/// @description Asserts that no instance of given object exists
/// @param {Asset.GMObject} object_type The object type to check
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_instance_not_exists(object_type, message) {
    return assert_false(instance_exists(object_type), message);
}

// ========================================================================
// TEST REPORTING
// ========================================================================

/// @function reportTestResults
/// @description Prints comprehensive test results to console
function reportTestResults() {
    global.test_results.end_time = get_timer();
    var duration_ms = (global.test_results.end_time - global.test_results.start_time) / 1000;

    show_debug_message("");
    show_debug_message("########################################");
    show_debug_message("# TEST RESULTS SUMMARY");
    show_debug_message("########################################");
    show_debug_message("");
    show_debug_message("Total Tests:  " + string(global.test_results.total));
    show_debug_message("Passed:       " + string(global.test_results.passed) + " (" + string(round((global.test_results.passed / max(global.test_results.total, 1)) * 100)) + "%)");
    show_debug_message("Failed:       " + string(global.test_results.failed));
    show_debug_message("Skipped:      " + string(global.test_results.skipped));
    show_debug_message("Duration:     " + string(duration_ms) + " ms");
    show_debug_message("");

    if (global.test_results.failed > 0) {
        show_debug_message("FAILED TESTS:");
        show_debug_message("----------------------------------------");

        for (var i = 0; i < array_length(global.test_results.tests); i++) {
            var test = global.test_results.tests[i];
            if (test.status == "FAIL") {
                show_debug_message(" - " + test.suite + "::" + test.name);
                show_debug_message("   Expected: " + string(test.expected));
                show_debug_message("   Actual:   " + string(test.actual));
            }
        }
        show_debug_message("");
    }

    if (global.test_results.failed == 0) {
        show_debug_message("✓ ALL TESTS PASSED!");
    } else {
        show_debug_message("✗ " + string(global.test_results.failed) + " TEST(S) FAILED");
    }

    show_debug_message("########################################");
    show_debug_message("");
}

/// @function getTestPassRate
/// @description Returns test pass rate as percentage
/// @return {Real} Pass rate (0-100)
function getTestPassRate() {
    if (global.test_results.total == 0) return 0;
    return (global.test_results.passed / global.test_results.total) * 100;
}

/// @function didAllTestsPass
/// @description Checks if all tests passed
/// @return {Bool} True if all tests passed, false otherwise
function didAllTestsPass() {
    return (global.test_results.failed == 0 && global.test_results.total > 0);
}

// ========================================================================
// ADDITIONAL ASSERTION FUNCTIONS
// ========================================================================

/// @function assert_is_true
/// @description Alias for assert_true for consistency
/// @param {Bool} condition The condition to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_true(condition, message) {
    return assert_true(condition, message);
}

/// @function assert_is_false
/// @description Alias for assert_false for consistency
/// @param {Bool} condition The condition to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_false(condition, message) {
    return assert_false(condition, message);
}

/// @function assert_is_null
/// @description Asserts that a value is undefined or -1 (null representation)
/// @param {Any} value The value to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_null(value, message) {
    var is_null = (value == undefined || value == -1);
    return assert_true(is_null, message);
}

/// @function assert_is_not_null
/// @description Asserts that a value is NOT undefined or -1 (null representation)
/// @param {Any} value The value to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_not_null(value, message) {
    var is_not_null = (value != undefined && value != -1);
    return assert_true(is_not_null, message);
}

/// @function assert_is_array
/// @description Asserts that a value is an array
/// @param {Any} value The value to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_array(value, message) {
    var is_arr = is_array(value);
    return assert_true(is_arr, message);
}

/// @function assert_is_struct
/// @description Asserts that a value is a struct
/// @param {Any} value The value to test
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_is_struct(value, message) {
    var is_str = is_struct(value);
    return assert_true(is_str, message);
}

/// @function assert_array_length
/// @description Asserts that an array has expected length
/// @param {Array} arr The array to test
/// @param {Real} expected_length Expected array length
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_array_length(arr, expected_length, message) {
    if (!is_array(arr)) {
        show_debug_message("[ERROR] assert_array_length: First argument is not an array");
        return false;
    }
    var actual_length = array_length(arr);
    return assert_equals(actual_length, expected_length, message);
}

/// @function assert_struct_has_property
/// @description Asserts that a struct contains a specific property
/// @param {Struct} str The struct to test
/// @param {String} property_name The property name to check
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_struct_has_property(str, property_name, message) {
    if (!is_struct(str)) {
        show_debug_message("[ERROR] assert_struct_has_property: First argument is not a struct");
        return false;
    }
    var has_prop = variable_struct_exists(str, property_name);
    return assert_true(has_prop, message + " (property: " + property_name + ")");
}

/// @function assert_between
/// @description Asserts that actual value is between min and max (exclusive of boundaries)
/// @param {Real} actual The actual value
/// @param {Real} min Minimum value (exclusive)
/// @param {Real} max Maximum value (exclusive)
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_between(actual, min, max, message) {
    global.test_results.total++;

    var passed = (actual > min && actual < max);

    if (passed) {
        global.test_results.passed++;
        show_debug_message("[PASS] " + message);

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "PASS",
            expected: string(min) + " < x < " + string(max),
            actual: actual
        });

        return true;
    } else {
        global.test_results.failed++;
        show_debug_message("[FAIL] " + message);
        show_debug_message("       Expected range: " + string(min) + " < x < " + string(max));
        show_debug_message("       Actual:         " + string(actual));

        array_push(global.test_results.tests, {
            name: message,
            suite: global.test_results.current_suite,
            status: "FAIL",
            expected: string(min) + " < x < " + string(max),
            actual: actual
        });

        return false;
    }
}

/// @function assert_string_contains
/// @description Asserts that a string contains a substring
/// @param {String} str The string to search in
/// @param {String} substring The substring to find
/// @param {String} message Description of what's being tested
/// @return {Bool} True if assertion passed, false if failed
function assert_string_contains(str, substring, message) {
    var contains = (string_pos(substring, str) > 0);
    return assert_true(contains, message);
}

// ========================================================================
// TEST SETUP AND TEARDOWN HELPERS
// ========================================================================

/// @function setupTestEnvironment
/// @description Initializes test environment with clean state
/// @description Should be called before running test suites
function setupTestEnvironment() {
    resetTestResults();

    // Initialize any global test state here
    show_debug_message("");
    show_debug_message("========================================");
    show_debug_message("INITIALIZING TEST ENVIRONMENT");
    show_debug_message("========================================");
}

/// @function teardownTestEnvironment
/// @description Cleans up test environment after test suites complete
/// @description Should be called after all tests finish
function teardownTestEnvironment() {
    reportTestResults();
    show_debug_message("");
    show_debug_message("========================================");
    show_debug_message("TEST ENVIRONMENT CLEANED UP");
    show_debug_message("========================================");
}
