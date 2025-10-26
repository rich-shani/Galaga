function challenging() {
	// Load challenge data from JSON and set up path references
	// This maintains backward compatibility with code that references path1, path2, etc.

	oGameManager.list = ds_list_create();

	// Get challenge data for current challenge (global.chall is 1-8)
	var chall_data = challenge_data.CHALLENGES[global.chall - 1];

	// Set path variables by getting asset IDs from path names
	path1 = asset_get_index(chall_data.PATH1);
	path2 = asset_get_index(chall_data.PATH2);
	path1flip = asset_get_index(chall_data.PATH1_FLIP);
	path2flip = asset_get_index(chall_data.PATH2_FLIP);

	// Build the list from wave data (for backward compatibility)
	// Convert DOUBLED boolean to 2 (doubled) or 1 (single)
	for (var i = 0; i < array_length(chall_data.WAVES); i++) {
		var wave = chall_data.WAVES[i];
		if (wave.DOUBLED) {
			ds_list_add(list, 2);
		} else {
			ds_list_add(list, 1);
		}
	}
}
