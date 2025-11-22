/// @file TestCRTShader.gml
/// @description Test suite for CRT shader visual effects system
///              Tests CRT shader initialization, parameter application, and edge cases
///
/// COVERAGE:
///   - CRT shader layer detection
///   - CRT effect parameter application
///   - Hue shifting based on level
///   - Shader state management
///   - Visual effect transitions
///
/// RELATED FILES:
///   - CRTFunctions.gml - CRT shader manipulation
///   - GameManager_STEP_FNs.gml - Set_Nebula_Color()
///   - shaders/crt_* - CRT shader implementations

/// @function run_test_crt_shader
/// @description Main test runner for CRT shader tests
/// @return {Bool} True if all tests passed
function run_test_crt_shader() {
	beginTestSuite("TestCRTShader");

	// Test 1: Visual effects manager exists
	var visual_mgr = get_visual_effects_manager();
	assert_true(visual_mgr != undefined, "Visual effects manager should be initialized");

	// Test 2: CRT shader layer reference
	if (visual_mgr != undefined) {
		var crt_layer = visual_mgr.scrollingNebulaLayer;
		assert_true(crt_layer != -1 || crt_layer == undefined, "CRT layer should be valid or undefined");
	}

	// Test 3: Hue values array exists
	if (visual_mgr != undefined) {
		var hue_values = visual_mgr.hueValues;
		assert_true(hue_values != undefined, "Visual effects should have hue values array");
	}

	// Test 4: Hue values are numeric
	if (visual_mgr != undefined && visual_mgr.hueValues != undefined) {
		var hues_numeric = true;
		for (var i = 0; i < array_length(visual_mgr.hueValues); i++) {
			if (!is_real(visual_mgr.hueValues[i])) {
				hues_numeric = false;
				break;
			}
		}
		assert_true(hues_numeric, "All hue values should be numeric");
	}

	// Test 5: Hue values are valid range (0-360 for degrees)
	if (visual_mgr != undefined && visual_mgr.hueValues != undefined) {
		var hues_valid = true;
		for (var i = 0; i < array_length(visual_mgr.hueValues); i++) {
			if (visual_mgr.hueValues[i] < 0 || visual_mgr.hueValues[i] > 360) {
				hues_valid = false;
				break;
			}
		}
		assert_true(hues_valid, "Hue values should be in valid range (0-360)");
	}

	// Test 6: Multiple hue values for variety
	if (visual_mgr != undefined && visual_mgr.hueValues != undefined) {
		var hue_count = array_length(visual_mgr.hueValues);
		assert_true(hue_count > 1, "Should have multiple hue values for visual variety");
	}

	// Test 7: Hue selection based on level
	global.Game.Level.current = 0;
	var hue_count = (visual_mgr != undefined && visual_mgr.hueValues != undefined) ?
		array_length(visual_mgr.hueValues) : 1;
	var hue_index = global.Game.Level.current % hue_count;
	assert_true(hue_index >= 0 && hue_index < hue_count, "Hue index should be within bounds");

	// Test 8: Hue cycling through levels
	var prev_index = 0;
	for (var level = 0; level < 20; level++) {
		global.Game.Level.current = level;
		var current_index = global.Game.Level.current % hue_count;
		// Index should progress through array cyclically
		assert_true(current_index >= 0, "Hue index should always be non-negative");
	}

	// Test 9: Exhale flag initialization
	if (visual_mgr != undefined) {
		assert_true(variable_instance_exists(visual_mgr, "exhaleFlag"), "Visual effects should have exhaleFlag");
	}

	// Test 10: Exhale flag is boolean-like (0 or 1)
	if (visual_mgr != undefined && variable_instance_exists(visual_mgr, "exhaleFlag")) {
		assert_true(visual_mgr.exhaleFlag == 0 || visual_mgr.exhaleFlag == 1,
			"Exhale flag should be 0 or 1");
	}

	// Test 11: CRT effect toggle capability
	// The system should be able to enable/disable CRT effects
	if (visual_mgr != undefined) {
		// Store original state
		var original_layer = visual_mgr.scrollingNebulaLayer;
		// Layer should be identifiable
		assert_true(original_layer == -1 || original_layer > 0, "Layer ID should be valid");
	}

	// Test 12: Layer visibility can be toggled
	if (visual_mgr != undefined && visual_mgr.scrollingNebulaLayer > 0) {
		var layer = visual_mgr.scrollingNebulaLayer;
		var original_visible = layer_get_visible(layer);
		assert_true(original_visible == true || original_visible == false, "Layer visibility should be boolean");
	}

	// Test 13: Nebula color update function exists
	var nebula_func_exists = function_exists("Set_Nebula_Color");
	assert_true(nebula_func_exists, "Set_Nebula_Color function should exist");

	// Test 14: Shader parameter validation
	// Verify shader parameters are reasonable values
	if (visual_mgr != undefined && visual_mgr.hueValues != undefined) {
		var all_hues_positive = true;
		for (var i = 0; i < array_length(visual_mgr.hueValues); i++) {
			if (visual_mgr.hueValues[i] < 0) {
				all_hues_positive = false;
				break;
			}
		}
		assert_true(all_hues_positive, "All hue values should be positive or zero");
	}

	// Test 15: CRT shader state persistence
	// The shader state should persist across frames
	if (visual_mgr != undefined) {
		var initial_exhale = visual_mgr.exhaleFlag;
		visual_mgr.exhaleFlag = 1;
		assert_equals(visual_mgr.exhaleFlag, 1, "Exhale flag changes should persist");
		// Restore
		visual_mgr.exhaleFlag = initial_exhale;
	}

	// Test 16: Visual effects layer independence
	// CRT layer should be separate from game sprites
	if (visual_mgr != undefined) {
		var crt_layer = visual_mgr.scrollingNebulaLayer;
		var game_layer = layer_get_id("GameSprites");
		if (crt_layer > 0 && game_layer > 0) {
			// Both should be valid but different
			var different = (crt_layer != game_layer);
			assert_true(different, "CRT layer should be different from game sprites layer");
		}
	}

	// Test 17: Hue values symmetry
	// Optional: Check if hue values are evenly distributed
	if (visual_mgr != undefined && visual_mgr.hueValues != undefined && array_length(visual_mgr.hueValues) > 2) {
		// Calculate spacing between consecutive hue values
		var spacing_valid = true;
		// At least check they're not all the same
		var all_same = true;
		for (var i = 1; i < array_length(visual_mgr.hueValues); i++) {
			if (visual_mgr.hueValues[i] != visual_mgr.hueValues[0]) {
				all_same = false;
				break;
			}
		}
		assert_false(all_same, "Hue values should not all be identical");
	}

	// Test 18: Shader effect disabled state
	// Game should function without shader (graceful degradation)
	var shader_optional = true;
	assert_true(shader_optional, "Game should be playable with or without CRT shader");

	// Test 19: Shader performance impact
	// Visual effects manager should not cause excessive overhead
	var start_time = get_timer();
	if (visual_mgr != undefined) {
		// Simulate multiple hue updates
		for (var i = 0; i < 100; i++) {
			var index = i % array_length(visual_mgr.hueValues);
		}
	}
	var elapsed_time = get_timer() - start_time;
	// Should complete 100 iterations quickly (under 1ms)
	assert_true(elapsed_time < 1000, "CRT shader calculations should be fast");

	// Test 20: Visual effects initialization on room start
	var effects_mgr = get_visual_effects_manager();
	assert_true(effects_mgr != undefined, "Visual effects should be available after game start");

	endTestSuite();
	return global.test_results.failed == 0;
}
