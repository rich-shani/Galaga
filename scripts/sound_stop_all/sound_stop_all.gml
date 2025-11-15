/// @function sound_stop_all()
/// @description Stops all sounds immediately through the AudioManager
///
/// LEGACY WRAPPER - Use AudioManager directly for new code:
///   global.Game.Controllers.audioManager.stopAll();
///
function sound_stop_all() {
	// Use AudioManager if available
	if (global.Game != undefined && global.Game.Controllers != undefined && global.Game.Controllers.audioManager != undefined) {
		return global.Game.Controllers.audioManager.stopAll();
	}

	// Fallback to direct audio call if AudioManager not initialized
	return audio_stop_all();
}
