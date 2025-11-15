/// @function sound_loop(sound_id, [priority])
/// @description Loops a sound effect through the AudioManager
/// @param {Id.Sound} sound_id - The sound to loop
/// @param {Number} [priority] - Priority level (default: 10)
/// @return {Id.SoundInstance} Sound instance ID or -1 if failed
///
/// LEGACY WRAPPER - Use AudioManager directly for new code:
///   global.Game.Controllers.audioManager.loopSound(sound_id);
///
function sound_loop(argument0, argument1) {
	// Get priority parameter (default 10)
	var priority = argument_count > 1 ? argument1 : 10;

	// Use AudioManager if available
	if (global.Game != undefined && global.Game.Controllers != undefined && global.Game.Controllers.audioManager != undefined) {
		return global.Game.Controllers.audioManager.loopSound(argument0, priority);
	}

	// Fallback to direct audio call if AudioManager not initialized
	return audio_play_sound(argument0, priority, true);
}
