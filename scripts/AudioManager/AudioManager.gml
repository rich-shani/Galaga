/// @file AudioManager.gml
/// @description Centralized audio management system for Galaga Wars
/// @author Galaga Wars Development Team
///
/// AudioManager provides a unified interface for all game audio operations:
/// • Sound playback (one-shot and looping)
/// • Sound stopping and volume control
/// • Audio priority and layer management
/// • Sound state tracking
/// • Graceful fallback for missing assets
///
/// Usage:
///   Create instance: audio_mgr = AudioManager.create()
///   Play sound: audio_mgr.playSound(GShot)
///   Loop sound: audio_mgr.loopSound(GBreathe)
///   Stop sound: audio_mgr.stopSound(GBreathe)
///   Stop all: audio_mgr.stopAll()
///
/// All sound calls go through this manager, providing centralized control
/// and making it easy to add features like volume mixing, audio fading, etc.

/// @constructor Creates a new AudioManager instance
/// @return {Struct} AudioManager instance with all audio control methods
function AudioManager() constructor {

	// ========================================================================
	// INTERNAL STATE
	// ========================================================================
	/// Track all currently playing sounds for volume/priority management
	playing_sounds = ds_map_create();

	/// Audio priority level (higher = louder relative to other channels)
	priority = 10;

	/// Master volume multiplier (0.0 - 1.0)
	master_volume = 1.0;

	/// Currently looping sound (only one looping sound at a time)
	current_loop_sound = undefined;

	// ========================================================================
	// PUBLIC METHODS - Sound Playback
	// ========================================================================

	/// @function playSound(sound_id, [priority], [fallback_sound])
	/// @description Plays a one-shot sound effect
	/// @param {Id.Sound} sound_id - The sound to play
	/// @param {Number} [priority] - Priority level (default: 10)
	/// @param {Id.Sound} [fallback_sound] - Sound to play if primary fails
	/// @return {Id.SoundInstance} Sound instance ID or -1 if failed
	/// @example
	///   audio_mgr.playSound(GShot);
	///   audio_mgr.playSound(GBoss1, 15);
	static playSound = function(sound_id, priority_override, fallback_sound) {
		// Default parameters
		var _priority = priority_override ?? priority;
		var _fallback = fallback_sound ?? undefined;

		// Validate sound ID
		if (!audio_exists(sound_id)) {
			if (_fallback != undefined && audio_exists(_fallback)) {
				show_debug_message("[AudioManager] Sound not found, using fallback: " + string(_fallback));
				sound_id = _fallback;
			} else {
				show_debug_message("[AudioManager] ERROR: Sound ID not found - " + string(sound_id));
				return -1;
			}
		}

		// Play the sound
		var sound_instance = audio_play_sound(sound_id, _priority, false);

		// Track the sound
		if (sound_instance != -1) {
			playing_sounds[? sound_id] = sound_instance;
		}

		return sound_instance;
	};

	/// @function loopSound(sound_id, [priority])
	/// @description Plays a looping sound (replaces any existing loop)
	/// @param {Id.Sound} sound_id - The sound to loop
	/// @param {Number} [priority] - Priority level (default: 10)
	/// @return {Id.SoundInstance} Sound instance ID or -1 if failed
	/// @example
	///   audio_mgr.loopSound(GBreathe);
	/// @note Only one looping sound can play at a time
	static loopSound = function(sound_id, priority_override) {
		// Stop any existing loop
		if (current_loop_sound != undefined) {
			audio_stop_sound(current_loop_sound);
		}

		// Default parameters
		var _priority = priority_override ?? priority;

		// Validate sound ID
		if (!audio_exists(sound_id)) {
			show_debug_message("[AudioManager] ERROR: Loop sound not found - " + string(sound_id));
			return -1;
		}

		// Play the loop
		current_loop_sound = audio_play_sound(sound_id, _priority, true);
		playing_sounds[? sound_id] = current_loop_sound;

		return current_loop_sound;
	};

	// ========================================================================
	// PUBLIC METHODS - Sound Control
	// ========================================================================

	/// @function stopSound(sound_id)
	/// @description Stops a specific sound from playing
	/// @param {Id.Sound} sound_id - The sound to stop
	/// @example
	///   audio_mgr.stopSound(GBreathe);
	static stopSound = function(sound_id) {
		// Stop if it's the looping sound
		if (sound_id == current_loop_sound) {
			current_loop_sound = undefined;
		}

		// Stop all instances of this sound
		audio_stop_sound(sound_id);

		// Remove from tracking
		ds_map_delete(playing_sounds, sound_id);
	};

	/// @function stopAll()
	/// @description Stops all sounds immediately
	/// @example
	///   audio_mgr.stopAll();
	static stopAll = function() {
		audio_stop_all();

		// Clear all tracking
		ds_map_clear(playing_sounds);
		current_loop_sound = undefined;
	};

	/// @function pauseSound(sound_id)
	/// @description Pauses a sound (can be resumed)
	/// @param {Id.Sound} sound_id - The sound to pause
	/// @example
	///   audio_mgr.pauseSound(GBreathe);
	static pauseSound = function(sound_id) {
		if (audio_exists(sound_id)) {
			audio_pause_sound(sound_id);
		}
	};

	/// @function resumeSound(sound_id)
	/// @description Resumes a paused sound
	/// @param {Id.Sound} sound_id - The sound to resume
	/// @example
	///   audio_mgr.resumeSound(GBreathe);
	static resumeSound = function(sound_id) {
		if (audio_exists(sound_id)) {
			audio_resume_sound(sound_id);
		}
	};

	// ========================================================================
	// PUBLIC METHODS - Volume Control
	// ========================================================================

	/// @function setMasterVolume(volume)
	/// @description Sets master volume for all sounds (0.0 - 1.0)
	/// @param {Number} volume - Volume level (0.0 = silent, 1.0 = full)
	/// @example
	///   audio_mgr.setMasterVolume(0.8);
	static setMasterVolume = function(volume) {
		master_volume = clamp(volume, 0.0, 1.0);

		// Apply to all currently playing sounds
		var sound_id = ds_map_find_first(playing_sounds);
		while (sound_id != undefined) {
			var instance_id = playing_sounds[? sound_id];
			if (instance_id != -1) {
				audio_sound_set_volume(instance_id, master_volume);
			}
			sound_id = ds_map_find_next(playing_sounds, sound_id);
		}
	};

	/// @function setSoundVolume(sound_id, volume)
	/// @description Sets volume for a specific sound (0.0 - 1.0)
	/// @param {Id.Sound} sound_id - The sound to adjust
	/// @param {Number} volume - Volume level (0.0 = silent, 1.0 = full)
	/// @example
	///   audio_mgr.setSoundVolume(GBoss1, 0.5);
	static setSoundVolume = function(sound_id, volume) {
		if (playing_sounds[? sound_id] != undefined) {
			var instance_id = playing_sounds[? sound_id];
			audio_sound_set_volume(instance_id, volume * master_volume);
		}
	};

	// ========================================================================
	// PUBLIC METHODS - State Query
	// ========================================================================

	/// @function isPlaying(sound_id)
	/// @description Checks if a specific sound is currently playing
	/// @param {Id.Sound} sound_id - The sound to check
	/// @return {Bool} True if sound is playing
	/// @example
	///   if (audio_mgr.isPlaying(GBreathe)) { /* sound is active */ }
	static isPlaying = function(sound_id) {
		if (playing_sounds[? sound_id] == undefined) return false;

		var instance_id = playing_sounds[? sound_id];
		if (instance_id == -1) return false;

		// Check if instance is still valid
		return audio_is_playing(instance_id);
	};

	/// @function isLooping()
	/// @description Checks if any sound is currently looping
	/// @return {Bool} True if a loop is active
	/// @example
	///   if (audio_mgr.isLooping()) { /* stop the loop */ }
	static isLooping = function() {
		return (current_loop_sound != undefined && audio_is_playing(current_loop_sound));
	};

	/// @function getLoopingSound()
	/// @description Gets the ID of the currently looping sound
	/// @return {Id.Sound} Sound ID or undefined if no loop
	/// @example
	///   var loop_id = audio_mgr.getLoopingSound();
	static getLoopingSound = function() {
		return current_loop_sound;
	};

	/// @function getPlayingSoundCount()
	/// @description Gets count of all currently playing sounds
	/// @return {Number} Number of active sound instances
	/// @example
	///   show_debug_message("Playing " + string(audio_mgr.getPlayingSoundCount()) + " sounds");
	static getPlayingSoundCount = function() {
		return ds_map_size(playing_sounds);
	};

	// ========================================================================
	// PUBLIC METHODS - Cleanup & Lifecycle
	// ========================================================================

	/// @function destroy()
	/// @description Cleans up AudioManager resources
	/// @note Call this when destroying the manager or on game cleanup
	/// @example
	///   audio_mgr.destroy();
	static destroy = function() {
		stopAll();
		ds_map_destroy(playing_sounds);
	};

	// ========================================================================
	// HELPER METHODS - Common Sound Combinations
	// ========================================================================

	/// @function switchLoop(old_sound_id, new_sound_id)
	/// @description Smoothly transitions from one looping sound to another
	/// @param {Id.Sound} old_sound_id - Currently looping sound to stop
	/// @param {Id.Sound} new_sound_id - New sound to loop
	/// @example
	///   audio_mgr.switchLoop(GBreathe, GBoss2);
	static switchLoop = function(old_sound_id, new_sound_id) {
		stopSound(old_sound_id);
		loopSound(new_sound_id);
	};

	/// @function playAndLoop(one_shot_id, loop_id)
	/// @description Plays a one-shot sound, then starts a loop after
	/// @param {Id.Sound} one_shot_id - One-shot sound to play first
	/// @param {Id.Sound} loop_id - Sound to loop after one-shot completes
	/// @example
	///   audio_mgr.playAndLoop(GAlert, GBreathe);
	static playAndLoop = function(one_shot_id, loop_id) {
		playSound(one_shot_id);
		// Note: In a real implementation, you might delay loop start
		// to wait for one-shot to finish
		loopSound(loop_id);
	};

	// ========================================================================
	// INTERNAL HELPER METHODS
	// ========================================================================

	/// @function _validateSoundId(sound_id)
	/// @description Internal validation for sound IDs
	/// @private
	static _validateSoundId = function(sound_id) {
		return audio_exists(sound_id);
	};

	// Return the struct as the AudioManager instance
	return self;
}

/// @function AudioManager_create()
/// @description Creates and initializes a new AudioManager instance
/// @return {Struct} Configured AudioManager ready for use
function AudioManager_create() {
	return AudioManager();
}
