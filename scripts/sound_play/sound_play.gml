/// @function sound_play(sound_id, [priority])
/// @description Plays a one-shot sound effect through the AudioManager
/// @param {Id.Sound} sound_id - The sound to play
/// @param {Number} [priority] - Priority level (default: 10)
/// @return {Id.SoundInstance} Sound instance ID or -1 if failed
///
/// LEGACY WRAPPER - Use AudioManager directly for new code:
///   global.Game.Controllers.audioManager.playSound(sound_id);
///
function sound_play(argument0, argument1) {
	// Get priority parameter (default 10)
	var priority = argument_count > 1 ? argument1 : 10;

	// Use AudioManager if available
	if (global.Game != undefined && global.Game.Controllers != undefined && global.Game.Controllers.audioManager != undefined) {
		return global.Game.Controllers.audioManager.playSound(argument0, priority);
	}

	// Fallback to direct audio call if AudioManager not initialized
	return audio_play_sound(argument0, priority, false);
}
