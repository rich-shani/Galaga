/// @function sound_stop(sound_id)
/// @description Stops a specific sound through the AudioManager
/// @param {Id.Sound} sound_id - The sound to stop
///
/// LEGACY WRAPPER - Use AudioManager directly for new code:
///   global.Game.Controllers.audioManager.stopSound(sound_id);
///
function sound_stop(argument0) {
	// Use AudioManager if available
	if (global.Game != undefined && global.Game.Controllers != undefined && global.Game.Controllers.audioManager != undefined) {
		return global.Game.Controllers.audioManager.stopSound(argument0);
	}

	// Fallback to direct audio call if AudioManager not initialized
	return audio_stop_sound(argument0);
}
