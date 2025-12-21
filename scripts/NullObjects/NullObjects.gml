/// @file NullObjects.gml
/// @description Null Object Pattern implementations for game controllers
///              These stub objects provide safe default implementations when real controllers aren't initialized
///              Eliminates defensive null checks throughout the codebase
///
/// PATTERN BENEFITS:
///   - Removes 20+ "if (controller != undefined)" checks
///   - Safe method calls even if controller hasn't been created
///   - Graceful degradation instead of crashes
///   - Cleaner code: controller.method() instead of if (controller) controller.method()
///
/// USAGE:
///   // Instead of:
///   if (global.Game.Controllers.audioManager != undefined) {
///       global.Game.Controllers.audioManager.playSound(id);
///   }
///
///   // Use:
///   global.Game.Controllers.audioManager.playSound(id);  // Safe, even if undefined

// ============================================================================
// NULL WAVE SPAWNER
// ============================================================================

/// @function NullWaveSpawner
/// @description Null object for WaveSpawner (does nothing, prevents null checks)
/// @return {Struct} Null spawner instance
function NullWaveSpawner() constructor {
	/// @function spawnStandardEnemy
	/// @description Stub method (no-op)
	/// @return {Bool} Always false
	static spawnStandardEnemy = function() {
		log_error("WaveSpawner not initialized", "NullWaveSpawner.spawnStandardEnemy", 1);
		return false;
	};

	/// @function spawnChallengeEnemy
	/// @description Stub method (no-op)
	/// @return {Bool} Always false
	static spawnChallengeEnemy = function() {
		log_error("WaveSpawner not initialized", "NullWaveSpawner.spawnChallengeEnemy", 1);
		return false;
	};

	/// @function getSpawnCounter
	/// @description Stub method returning 0
	/// @return {Real} Always 0
	static getSpawnCounter = function() {
		return 0;
	};

	/// @function resetSpawnCounter
	/// @description Stub method (no-op)
	/// @return {undefined}
	static resetSpawnCounter = function() {
		// No-op
	};
}

// ============================================================================
// NULL SCORE MANAGER
// ============================================================================

/// @function NullScoreManager
/// @description Null object for ScoreManager (does nothing, prevents null checks)
/// @return {Struct} Null score manager instance
function NullScoreManager() constructor {
	/// @function checkForExtraLife
	/// @description Stub method (no-op)
	/// @return {undefined}
	static checkForExtraLife = function() {
		log_error("ScoreManager not initialized", "NullScoreManager.checkForExtraLife", 1);
	};

	/// @function addScore
	/// @description Stub method (no-op)
	/// @param {Real} _points Points to add
	/// @return {undefined}
	static addScore = function(_points) {
		log_error("ScoreManager not initialized", "NullScoreManager.addScore", 1);
	};

	/// @function getScore
	/// @description Stub method returning 0
	/// @return {Real} Always 0
	static getScore = function() {
		return 0;
	};
}

// ============================================================================
// NULL CHALLENGE MANAGER
// ============================================================================

/// @function NullChallengeManager
/// @description Null object for ChallengeStageManager (does nothing, prevents null checks)
/// @return {Struct} Null challenge manager instance
function NullChallengeManager() constructor {
	/// @function checkChallengeProgress
	/// @description Stub method (no-op)
	/// @return {Bool} Always false
	static checkChallengeProgress = function() {
		log_error("ChallengeManager not initialized", "NullChallengeManager.checkChallengeProgress", 1);
		return false;
	};

	/// @function resetChallenge
	/// @description Stub method (no-op)
	/// @return {undefined}
	static resetChallenge = function() {
		// No-op
	};
}

// ============================================================================
// NULL VISUAL EFFECTS MANAGER
// ============================================================================

/// @function NullVisualEffectsManager
/// @description Null object for VisualEffectsManager (does nothing, prevents null checks)
/// @return {Struct} Null visual effects manager instance
function NullVisualEffectsManager() constructor {
	/// @function spawnExplosion
	/// @description Stub method (no-op)
	/// @param {Real} _x Position X
	/// @param {Real} _y Position Y
	/// @param {Real} _scale Scale factor (default 1)
	/// @return {undefined}
	static spawnExplosion = function(_x, _y, _scale = 1) {
		log_error("VisualEffectsManager not initialized", "NullVisualEffectsManager.spawnExplosion", 1);
	};

	/// @function spawnParticles
	/// @description Stub method (no-op)
	/// @param {Real} _x Position X
	/// @param {Real} _y Position Y
	/// @param {Real} _count Particle count
	/// @return {undefined}
	static spawnParticles = function(_x, _y, _count = 10) {
		log_error("VisualEffectsManager not initialized", "NullVisualEffectsManager.spawnParticles", 1);
	};
}

// ============================================================================
// NULL UI MANAGER
// ============================================================================

/// @function NullUIManager
/// @description Null object for UIManager (does nothing, prevents null checks)
/// @return {Struct} Null UI manager instance
function NullUIManager() constructor {
	/// @function updateScore
	/// @description Stub method (no-op)
	/// @param {Real} _score New score value
	/// @return {undefined}
	static updateScore = function(_score) {
		log_error("UIManager not initialized", "NullUIManager.updateScore", 1);
	};

	/// @function updateLives
	/// @description Stub method (no-op)
	/// @param {Real} _lives Remaining lives
	/// @return {undefined}
	static updateLives = function(_lives) {
		log_error("UIManager not initialized", "NullUIManager.updateLives", 1);
	};

	/// @function updateLevel
	/// @description Stub method (no-op)
	/// @param {Real} _level Current level
	/// @return {undefined}
	static updateLevel = function(_level) {
		log_error("UIManager not initialized", "NullUIManager.updateLevel", 1);
	};
}

// ============================================================================
// NULL AUDIO MANAGER
// ============================================================================

/// @function NullAudioManager
/// @description Null object for AudioManager (does nothing, prevents null checks)
/// @return {Struct} Null audio manager instance
function NullAudioManager() constructor {
	/// @function playSound
	/// @description Stub method (no-op)
	/// @param {Asset.GMSound} _sound Sound to play
	/// @param {Real} _priority Priority (optional)
	/// @return {Id.Sound} noone (sound not played)
	static playSound = function(_sound, _priority = 0) {
		log_error("AudioManager not initialized", "NullAudioManager.playSound", 1);
		return noone;
	};

	/// @function loopSound
	/// @description Stub method (no-op)
	/// @param {Asset.GMSound} _sound Sound to loop
	/// @param {Real} _priority Priority (optional)
	/// @return {Id.Sound} noone (sound not played)
	static loopSound = function(_sound, _priority = 0) {
		log_error("AudioManager not initialized", "NullAudioManager.loopSound", 1);
		return noone;
	};

	/// @function stopSound
	/// @description Stub method (no-op)
	/// @param {Asset.GMSound} _sound Sound to stop
	/// @return {undefined}
	static stopSound = function(_sound) {
		log_error("AudioManager not initialized", "NullAudioManager.stopSound", 1);
	};

	/// @function setVolume
	/// @description Stub method (no-op)
	/// @param {Asset.GMSound} _sound Sound to adjust
	/// @param {Real} _volume Volume level (0-1)
	/// @return {undefined}
	static setVolume = function(_sound, _volume) {
		log_error("AudioManager not initialized", "NullAudioManager.setVolume", 1);
	};
}

// ============================================================================
// INITIALIZATION HELPER
// ============================================================================

/// @function ensure_controllers_initialized()
/// @description Ensures all controllers have valid instances (real or null objects)
///              Call this during game initialization to guarantee safe access
///              Can be called multiple times safely
/// @return {undefined}
function ensure_controllers_initialized() {
	// Ensure all controllers exist (use null objects as fallback)
	global.Game.Controllers.waveSpawner ??= new NullWaveSpawner();
	global.Game.Controllers.scoreManager ??= new NullScoreManager();
//	global.Game.Controllers.challengeManager ??= new NullChallengeManager();
	global.Game.Controllers.visualEffects ??= new NullVisualEffectsManager();
	global.Game.Controllers.uiManager ??= new NullUIManager();
	global.Game.Controllers.audioManager ??= new NullAudioManager();

	show_debug_message("[NullObjects] All controllers initialized (or null objects created)");
}
