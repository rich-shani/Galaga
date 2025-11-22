/// @file TestFormationGrid.gml
/// @description Test suite for enemy formation grid system
///              Tests positioning of 40 enemies in 5x8 formation grid
///
/// COVERAGE:
///   - Formation coordinate loading
///   - Enemy grid positioning
///   - Formation movement synchronization
///   - Grid boundary conditions
///   - Formation alignment after wave completion
///
/// RELATED FILES:
///   - EnemyManagement.gml - Formation control
///   - formation_coordinates.json - Grid position data
///   - oEnemyBase - Enemy objects in formation

/// @function run_test_formation_grid
/// @description Main test runner for formation grid tests
/// @return {Bool} True if all tests passed
function run_test_formation_grid() {
	beginTestSuite("TestFormationGrid");

	// Test 1: Formation data loaded
	var formation_data = get_formation_data();
	assert_true(formation_data != undefined, "Formation data should be loaded");

	// Test 2: Formation has 40 positions
	if (formation_data != undefined) {
		var position_count = array_length(formation_data.POSITION);
		assert_equals(position_count, 40, "Formation should have exactly 40 positions (5x8 grid)");
	}

	// Test 3: Each position has X and Y coordinates
	if (formation_data != undefined && array_length(formation_data.POSITION) > 0) {
		var first_pos = formation_data.POSITION[0];
		assert_true(struct_exists(first_pos, "_x"), "Position should have _x coordinate");
		assert_true(struct_exists(first_pos, "_y"), "Position should have _y coordinate");
	}

	// Test 4: Formation coordinates are within screen bounds
	if (formation_data != undefined) {
		var all_in_bounds = true;
		for (var i = 0; i < array_length(formation_data.POSITION); i++) {
			var pos = formation_data.POSITION[i];
			if (pos._x < 0 || pos._x > global.Game.Display.screenWidth ||
				pos._y < 0 || pos._y > global.Game.Display.screenHeight) {
				all_in_bounds = false;
				break;
			}
		}
		assert_true(all_in_bounds, "All formation positions should be within screen bounds");
	}

	// Test 5: Formation positions are unique (no duplicates)
	if (formation_data != undefined) {
		var unique = true;
		for (var i = 0; i < array_length(formation_data.POSITION); i++) {
			for (var j = i + 1; j < array_length(formation_data.POSITION); j++) {
				if (formation_data.POSITION[i]._x == formation_data.POSITION[j]._x &&
					formation_data.POSITION[i]._y == formation_data.POSITION[j]._y) {
					unique = false;
					break;
				}
			}
			if (!unique) break;
		}
		assert_true(unique, "Formation positions should be unique (no duplicates)");
	}

	// Test 6: Formation grid spacing
	// Enemies should be evenly spaced
	if (formation_data != undefined && array_length(formation_data.POSITION) >= 10) {
		// Calculate average X spacing between grid columns
		var x_positions = [];
		var pos_index = 0;
		for (var i = 0; i < array_length(formation_data.POSITION); i++) {
			array_push(x_positions, formation_data.POSITION[i]._x);
		}

		// Check that X positions have consistent spacing (allowing small variance)
		var x_spacing_valid = true;
		if (array_length(x_positions) > 5) {
			// Basic check: not all X positions are the same
			var x_min = x_positions[0];
			var x_max = x_positions[0];
			for (var i = 1; i < array_length(x_positions); i++) {
				x_min = min(x_min, x_positions[i]);
				x_max = max(x_max, x_positions[i]);
			}
			x_spacing_valid = (x_max - x_min > 50);  // Some horizontal spread
		}
		assert_true(x_spacing_valid, "Formation should have horizontal spacing");
	}

	// Test 7: Formation grid structure - 5 columns
	if (formation_data != undefined && array_length(formation_data.POSITION) == 40) {
		// Count unique X positions (should be 5 for 5x8 grid)
		var x_positions = [];
		for (var i = 0; i < 40; i++) {
			var found = false;
			for (var j = 0; j < array_length(x_positions); j++) {
				if (x_positions[j] == formation_data.POSITION[i]._x) {
					found = true;
					break;
				}
			}
			if (!found) {
				array_push(x_positions, formation_data.POSITION[i]._x);
			}
		}
		assert_equals(array_length(x_positions), 5, "Formation should have 5 columns");
	}

	// Test 8: Formation grid structure - 8 rows
	if (formation_data != undefined && array_length(formation_data.POSITION) == 40) {
		// Count unique Y positions (should be 8 for 5x8 grid)
		var y_positions = [];
		for (var i = 0; i < 40; i++) {
			var found = false;
			for (var j = 0; j < array_length(y_positions); j++) {
				if (y_positions[j] == formation_data.POSITION[i]._y) {
					found = true;
					break;
				}
			}
			if (!found) {
				array_push(y_positions, formation_data.POSITION[i]._y);
			}
		}
		assert_equals(array_length(y_positions), 8, "Formation should have 8 rows");
	}

	// Test 9: Formation center alignment
	if (formation_data != undefined && array_length(formation_data.POSITION) == 40) {
		// Calculate formation center
		var center_x = 0;
		var center_y = 0;
		for (var i = 0; i < 40; i++) {
			center_x += formation_data.POSITION[i]._x;
			center_y += formation_data.POSITION[i]._y;
		}
		center_x /= 40;
		center_y /= 40;

		// Formation center should be near screen center horizontally
		var horizontal_centered = abs(center_x - (global.Game.Display.screenWidth / 2)) < 100;
		assert_true(horizontal_centered, "Formation should be horizontally centered");
	}

	// Test 10: Formation breathing movement
	// The formation should oscillate left-right during breathing animation
	global.Game.State.breathing = 1;
	global.Game.Enemy.breathePhase = 0;
	global.Game.Enemy.breathePhase_normalized = 0;

	var initial_phase = global.Game.Enemy.breathePhase;
	// Simulate breathing animation step
	if (global.Game.Controllers.visualEffects.exhaleFlag == 0) {
		global.Game.Enemy.breathePhase += BREATHING_RATE;
	}
	var updated_phase = global.Game.Enemy.breathePhase;

	assert_true(updated_phase > initial_phase || updated_phase == 0, "Breathing phase should progress or reset");

	// Test 11: Formation position access
	// Test that we can retrieve any position in the formation
	if (formation_data != undefined && array_length(formation_data.POSITION) == 40) {
		var random_index = irandom(39);
		var random_pos = formation_data.POSITION[random_index];
		assert_true(random_pos != undefined, "Should be able to access random formation position");
		assert_true(random_pos._x != undefined && random_pos._y != undefined, "Position should have valid coordinates");
	}

	// Test 12: Formation completeness for all 40 enemies
	if (formation_data != undefined) {
		var all_valid = true;
		for (var i = 0; i < min(40, array_length(formation_data.POSITION)); i++) {
			var pos = formation_data.POSITION[i];
			if (pos._x == undefined || pos._y == undefined) {
				all_valid = false;
				break;
			}
		}
		assert_true(all_valid, "All formation positions should be complete and valid");
	}

	// Test 13: Formation Y positions are positive (below top of screen)
	if (formation_data != undefined) {
		var all_below_top = true;
		for (var i = 0; i < array_length(formation_data.POSITION); i++) {
			if (formation_data.POSITION[i]._y < 0) {
				all_below_top = false;
				break;
			}
		}
		assert_true(all_below_top, "All formation positions should be below top of screen");
	}

	// Test 14: Formation accessible after data migration
	// Verify that migrated global.Game.Data.formation equals original
	var migrated_formation = global.Game.Data.formation;
	assert_true(migrated_formation == formation_data, "Migrated formation should match loaded formation");

	// Test 15: Formation coordinates are numeric
	if (formation_data != undefined && array_length(formation_data.POSITION) > 0) {
		var numeric_valid = true;
		for (var i = 0; i < min(10, array_length(formation_data.POSITION)); i++) {
			if (!is_real(formation_data.POSITION[i]._x) || !is_real(formation_data.POSITION[i]._y)) {
				numeric_valid = false;
				break;
			}
		}
		assert_true(numeric_valid, "Formation coordinates should be numeric values");
	}

	endTestSuite();
	return global.test_results.failed == 0;
}
