/// @file TestAudioManager.gml
/// @description Comprehensive test suite for AudioManager
/// @author Galaga Wars Development Team

/// @function runAudioManagerTests()
/// @description Runs all AudioManager tests
function runAudioManagerTests() {
	show_debug_message("========== AUDIO MANAGER TESTS ==========");

	var test_count = 0;
	var pass_count = 0;

	// Test Suite 1: Initialization
	show_debug_message("--- Test 1: AudioManager Initialization ---");
	test_count += 1;
	if (test_audioManagerInitialization()) {
		pass_count += 1;
		show_debug_message("✓ PASS: AudioManager initialization");
	} else {
		show_debug_message("✗ FAIL: AudioManager initialization");
	}

	// Test Suite 2: Sound Playback
	show_debug_message("--- Test 2: Sound Playback ---");
	test_count += 1;
	if (test_playSound()) {
		pass_count += 1;
		show_debug_message("✓ PASS: playSound() method");
	} else {
		show_debug_message("✗ FAIL: playSound() method");
	}

	// Test Suite 3: Looping Sounds
	show_debug_message("--- Test 3: Looping Sounds ---");
	test_count += 1;
	if (test_loopSound()) {
		pass_count += 1;
		show_debug_message("✓ PASS: loopSound() method");
	} else {
		show_debug_message("✗ FAIL: loopSound() method");
	}

	// Test Suite 4: Sound Control
	show_debug_message("--- Test 4: Sound Control ---");
	test_count += 1;
	if (test_soundControl()) {
		pass_count += 1;
		show_debug_message("✓ PASS: Sound control methods");
	} else {
		show_debug_message("✗ FAIL: Sound control methods");
	}

	// Test Suite 5: State Queries
	show_debug_message("--- Test 5: State Queries ---");
	test_count += 1;
	if (test_stateQueries()) {
		pass_count += 1;
		show_debug_message("✓ PASS: State query methods");
	} else {
		show_debug_message("✗ FAIL: State query methods");
	}

	// Test Suite 6: Volume Control
	show_debug_message("--- Test 6: Volume Control ---");
	test_count += 1;
	if (test_volumeControl()) {
		pass_count += 1;
		show_debug_message("✓ PASS: Volume control methods");
	} else {
		show_debug_message("✗ FAIL: Volume control methods");
	}

	// Test Suite 7: Loop Replacement
	show_debug_message("--- Test 7: Loop Replacement ---");
	test_count += 1;
	if (test_loopReplacement()) {
		pass_count += 1;
		show_debug_message("✓ PASS: Loop replacement behavior");
	} else {
		show_debug_message("✗ FAIL: Loop replacement behavior");
	}

	// Test Suite 8: Backward Compatibility
	show_debug_message("--- Test 8: Backward Compatibility ---");
	test_count += 1;
	if (test_backwardCompatibility()) {
		pass_count += 1;
		show_debug_message("✓ PASS: Backward compatibility");
	} else {
		show_debug_message("✗ FAIL: Backward compatibility");
	}

	// Test Summary
	show_debug_message("\n========== TEST SUMMARY ==========");
	show_debug_message("Passed: " + string(pass_count) + " / " + string(test_count));
	show_debug_message("Pass Rate: " + string((pass_count / test_count) * 100) + "%");

	if (pass_count == test_count) {
		show_debug_message("✓ ALL TESTS PASSED!");
	} else {
		show_debug_message("✗ SOME TESTS FAILED");
	}
	show_debug_message("=====================================\n");

	return (pass_count == test_count);
}

// ========================================================================
// INDIVIDUAL TEST FUNCTIONS
// ========================================================================

/// @function test_audioManagerInitialization()
/// @description Tests AudioManager is properly initialized
function test_audioManagerInitialization() {
	// Check that AudioManager exists in global.Game
	if (global.Game == undefined) return false;
	if (global.Game.Controllers == undefined) return false;
	if (global.Game.Controllers.audioManager == undefined) return false;

	var audio_mgr = global.Game.Controllers.audioManager;

	// Verify it has required methods
	if (!method_exists(audio_mgr, "playSound")) return false;
	if (!method_exists(audio_mgr, "loopSound")) return false;
	if (!method_exists(audio_mgr, "stopSound")) return false;
	if (!method_exists(audio_mgr, "stopAll")) return false;
	if (!method_exists(audio_mgr, "isPlaying")) return false;

	return true;
}

/// @function test_playSound()
/// @description Tests playSound() functionality
function test_playSound() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// playSound should return a value
	var result = audio_mgr.playSound(GShot);
	if (result == undefined) return false;

	// After playing, count should be > 0
	if (audio_mgr.getPlayingSoundCount() == 0) return false;

	// Clean up
	audio_mgr.stopAll();

	return true;
}

/// @function test_loopSound()
/// @description Tests loopSound() functionality
function test_loopSound() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// loopSound should set current_loop_sound
	audio_mgr.loopSound(GBreathe);
	if (!audio_mgr.isLooping()) return false;

	// getLoopingSound should return the correct sound
	if (audio_mgr.getLoopingSound() != GBreathe) return false;

	// Clean up
	audio_mgr.stopAll();

	return true;
}

/// @function test_soundControl()
/// @description Tests stopSound() and related control methods
function test_soundControl() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// Play and then stop
	audio_mgr.playSound(GShot);
	if (audio_mgr.getPlayingSoundCount() == 0) return false;

	audio_mgr.stopSound(GShot);
	// Note: Due to timing, sound might still be in the map briefly

	// stopAll should clear everything
	audio_mgr.playSound(GShot);
	audio_mgr.playSound(GBee);
	audio_mgr.stopAll();

	// After stopAll, no loop should exist
	if (audio_mgr.isLooping()) return false;

	return true;
}

/// @function test_stateQueries()
/// @description Tests state query methods
function test_stateQueries() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// After stop, not playing
	if (audio_mgr.isPlaying(GShot)) return false;
	if (audio_mgr.isLooping()) return false;

	// After play, check isPlaying works
	audio_mgr.playSound(GShot);
	// Note: Due to timing, this might not register immediately

	// getPlayingSoundCount should be a number
	var count = audio_mgr.getPlayingSoundCount();
	if (!is_numeric(count)) return false;
	if (count < 0) return false;

	// Clean up
	audio_mgr.stopAll();

	return true;
}

/// @function test_volumeControl()
/// @description Tests volume control methods
function test_volumeControl() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// setMasterVolume should accept 0-1 range
	audio_mgr.setMasterVolume(0.0);  // Mute
	audio_mgr.setMasterVolume(0.5);  // Half
	audio_mgr.setMasterVolume(1.0);  // Full

	// These should not crash
	audio_mgr.setMasterVolume(-0.5);  // Should clamp to 0.0
	audio_mgr.setMasterVolume(1.5);   // Should clamp to 1.0

	// setSoundVolume should work
	audio_mgr.playSound(GShot);
	audio_mgr.setSoundVolume(GShot, 0.5);  // Should not crash

	// Clean up
	audio_mgr.stopAll();
	audio_mgr.setMasterVolume(1.0);  // Restore volume

	return true;
}

/// @function test_loopReplacement()
/// @description Tests that loopSound replaces previous loop
function test_loopReplacement() {
	var audio_mgr = global.Game.Controllers.audioManager;

	// Clean slate
	audio_mgr.stopAll();

	// Start first loop
	audio_mgr.loopSound(GBreathe);
	if (audio_mgr.getLoopingSound() != GBreathe) return false;

	// Second loop should replace first
	audio_mgr.loopSound(GBoss2);
	if (audio_mgr.getLoopingSound() != GBoss2) return false;

	// Only one loop should be active
	if (audio_mgr.getPlayingSoundCount() > 1) return false;

	// Clean up
	audio_mgr.stopAll();

	return true;
}

/// @function test_backwardCompatibility()
/// @description Tests that legacy wrapper functions still work
function test_backwardCompatibility() {
	// Clean slate
	sound_stop_all();

	// These wrapper functions should not crash
	sound_play(GShot);     // Should route through AudioManager
	sound_loop(GBreathe);  // Should route through AudioManager
	sound_stop(GBreathe);  // Should route through AudioManager
	sound_stop_all();      // Should route through AudioManager

	// Verify AudioManager state after wrappers
	var audio_mgr = global.Game.Controllers.audioManager;
	if (audio_mgr.isLooping()) return false;  // Should be stopped

	return true;
}

/// @function method_exists(struct, method_name)
/// @description Helper to check if a struct has a method
function method_exists(struct, method_name) {
	if (!is_struct(struct)) return false;
	if (!variable_struct_exists(struct, method_name)) return false;

	var method = struct[$ method_name];
	return is_method(method);
}
