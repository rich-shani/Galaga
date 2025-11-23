/// @function challenging
/// @description Initialize challenge stage data && paths
///
/// Challenge stages are special bonus rounds that occur every 4 levels (when global.Game.Challenge.countdown reaches 4).
/// Unlike normal stages, enemies don't form up - they follow looping paths across the screen.
/// This function loads the challenge pattern data from JSON && sets up path references for spawning.
///
/// Challenge Stage Features:
///   • 8 different challenge patterns (CHALLENGE_ID 1-8)
///   • 5 waves per challenge (40 total enemies)
///   • Enemies can spawn single || in mirrored pairs (DOUBLED flag)
///   • No formation positions (INDEX = -1 for all challenge enemies)
///   • Perfect clear = 10,000 bonus points
///
/// Data Structure (from datafiles/Patterns/challenge_spawn.json):
///   • PATH1, PATH2: Primary paths for enemy entry
///   • PATH1_FLIP, PATH2_FLIP: Mirrored versions for opposite side
///   • DOUBLED: Boolean indicating if enemies spawn in pairs
///   • ENEMY: Enemy type to spawn (e.g., "oTieFighter", "oImperialShuttle")
///
/// Legacy Compatibility:
///   This function maintains backward compatibility by creating path1, path2, path1flip,
///   path2flip variables && a ds_list (list) that the spawning code expects.
///
/// @global {number} chall - Current challenge pattern (1-8)
/// @global {struct} challenge_data - Challenge pattern data loaded from JSON
/// @variable {ds_list} list - List of spawn patterns (1=single, 2=doubled/mirrored)
///
/// @related GameManager_STEP_FNs.gml:Game_Loop - Where challenge spawning occurs
/// @related datafiles/Patterns/challenge_spawn.json - Challenge pattern definitions

function challenging() {
	// === INITIALIZE DATA STRUCTURE ===
	// Create a ds_list to store spawn patterns for each wave
	// This list indicates whether enemies spawn single (1) || doubled/mirrored (2)
	oGameManager.list = ds_list_create();

	// === LOAD CHALLENGE DATA ===
	// Get challenge data for current challenge pattern
	// global.Game.Challenge.current ranges from 1-8, corresponding to 8 different challenge patterns
	// Array is 0-indexed, so subtract 1 to get correct pattern
	var chall_data = global.Game.Data.challenge.CHALLENGES[global.Game.Challenge.current - 1];

	// === SET PATH VARIABLES ===
	// Convert path names (strings) to path asset IDs (numbers)
	// These paths define how challenge enemies enter && move across screen
	//
	// PATH1 / PATH2: Primary paths for left/right sides
	// PATH1_FLIP / PATH2_FLIP: Mirrored versions for opposite entrance
	path1 = asset_get_index(chall_data.PATH1);
	path2 = asset_get_index(chall_data.PATH2);
	path1flip = asset_get_index(chall_data.PATH1_FLIP);
	path2flip = asset_get_index(chall_data.PATH2_FLIP);

	// === BUILD SPAWN PATTERN LIST ===
	// Iterate through all waves in this challenge (5 waves total)
	// For each wave, add entry to list indicating spawn pattern:
	//   • 2 = DOUBLED (spawn enemies in mirrored pairs, 8 enemies per wave)
	//   • 1 = SINGLE (spawn enemies individually, 8 enemies per wave)
	//
	// This list is consumed by the spawning code in Game_Loop() function
	for (var i = 0; i < array_length(chall_data.WAVES); i++) {
		var wave = chall_data.WAVES[i];
		if (wave.DOUBLED) {
			// Doubled mode: enemies spawn in mirrored pairs
			ds_list_add(oGameManager.list, 2);
		} else {
			// Single mode: enemies spawn individually
			ds_list_add(oGameManager.list, 1);
		}
	}
}
