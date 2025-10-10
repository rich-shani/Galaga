// oEnemyBase 

/*
 * Initializes enemy object variables and assigns movement paths based on current wave, pattern, and rogue status.
 * Handles both standard and rogue enemy behaviors, including path selection, dive timing, and formation counters.
 * Also manages challenge stage logic with special path assignments and counter updates.
 */

function assign_enemy_path(_datafile, _pattern, _wave, _alt_path) {

	var _data = "";
	var _json = "";

	// Check if the file exists to avoid errors
	if (file_exists(_datafile)) {
	    // Open the file for reading
	    var _fileid = file_text_open_read(_datafile);
    
	    // Read the entire file line by line
	    while (!file_text_eof(_fileid)) {
	        _data += file_text_readln(_fileid);
	    }
    
	    // Close the file
	    file_text_close(_fileid);
	
		_json = json_parse(_data);
		var path_name = "";
		
		if (_alt_path) {
			path_name = _json.PATTERN[_pattern].WAVE[_wave].ALT_PATH;
		}
		else {
			path_name = _json.PATTERN[_pattern].WAVE[_wave].PATH;
		}
		
		// assign path
		var path_id = asset_get_index(path_name);
		if (path_id != -1) path_start(path_id, 6*global.scale, 0, 0);
	}

}


///// Rogue Behavior Activation
//function activate_rogue() {
//	rogue = 1;
//	oGameManager.rogueyes = 0;
//}

///// Dive Alarm Setup
//function setup_dive_alarm(_rogue, _wave, _fastenter) {
//	if (_rogue == 0) {
//		if (_wave == 1 || _wave == 2) {
//			alarm[5] = _fastenter == 1 ? 63 : 75;
//		} else {
//			alarm[5] = 10;
//		}
//	}
//}

///// Wave-Specific Counter Updates
//function update_wave_counters(_wave, _rogue, _alt) {
//	if (_wave == 0) {
//		if (_rogue == 0) {
//			oGameManager.count1 -= 1;
//			switch (oGameManager.count1) {
//				case 3: numb = 1; break;
//				case 2: numb = 3; break;
//				case 1: numb = 5; break;
//				case 0: numb = 7; break;
//			}
//		} else {
//			oGameManager.rogue1 -= 1;
//		}
//	}
//	else if (_wave == 3) {
//		if (_alt == 0) {
//			if (_rogue == 0) {
//				oGameManager.count1 -= 1;
//				switch (oGameManager.count1) {
//					case 3: numb = 25; break;
//					case 2: numb = 27; break;
//					case 1: numb = 29; break;
//					case 0: numb = 31; break;
//				}
//			} else {
//				oGameManager.rogue1 -= 1;
//			}
//		} else {
//			if (_rogue == 0) {
//				oGameManager.count2 -= 1;
//				switch (oGameManager.count2) {
//					case 3: numb = 26; break;
//					case 2: numb = 28; break;
//					case 1: numb = 30; break;
//					case 0: numb = 32; break;
//				}
//			} else {
//				oGameManager.rogue2 -= 1;
//			}
//		}
//	}
//	else if (_wave == 4) {
//		if (_alt == 0) {
//			if (_rogue == 0) {
//				oGameManager.count1 -= 1;
//				switch (oGameManager.count1) {
//					case 3: numb = 33; break;
//					case 2: numb = 35; break;
//					case 1: numb = 37; break;
//					case 0: numb = 39; break;
//				}
//			} else {
//				oGameManager.rogue1 -= 1;
//			}
//		} else {
//			if (_rogue == 0) {
//				oGameManager.count2 -= 1;
//				switch (oGameManager.count2) {
//					case 3: numb = 34; break;
//					case 2: numb = 36; break;
//					case 1: numb = 38; break;
//					case 0: numb = 40; break;
//				}
//			} else {
//				oGameManager.rogue2 -= 1;
//			}
//		}
//	}
//}

///// Fast Entry Adjustment
//function adjust_fast_entry(_fastenter) {
//	if (_fastenter == 1) fasty = 50;
//}

///// Challenge Stage Logic
//function challenge_stage_logic(_x, _y, _scale) {
//	oGameManager.count += 1;
//	if (_x == path_get_x(oGameManager.path1,0) && _y == path_get_y(oGameManager.path1,0)) {
//		path_start(oGameManager.path1, 6*_scale, 0, 0);
//	}
//	else if (_x == path_get_x(oGameManager.path1flip,0) && _y == path_get_y(oGameManager.path1flip,0)) {
//		path_start(oGameManager.path1flip, 6*_scale, 0, 0);
//	}
//	else if (_x == path_get_x(oGameManager.path2,0) && _y == path_get_y(oGameManager.path2,0)) {
//		path_start(oGameManager.path2, 6*_scale, 0, 0);
//	}
//	else if (_x == path_get_x(oGameManager.path2flip,0) && _y == path_get_y(oGameManager.path2flip,0)) {
//		path_start(oGameManager.path2flip, 6*_scale, 0, 0);
//	}
//	if (global.chall == 3) {
//		switch (oGameManager.count) {
//			case 2: case 4: case 6: case 8:
//				if (global.wave == 4) {
//					path_end();
//					path_start(oGameManager.path1, 6*_scale, 0, 0);
//				}
//				if (global.wave == 0 || global.wave == 3) {
//					path_end();
//					path_start(oGameManager.path1flip, 6*_scale, 0, 0);
//				}
//				break;
//		}
//	}
//}

//// Main logic for oEnemyBase
//if (global.challcount > 0) {
//	assign_enemy_path(oGameManager.rogueyes, global.pattern, global.wave, oGameManager.alt, global.scale);

//	if (oGameManager.rogueyes == 1) activate_rogue();

//	setup_dive_alarm(rogue, global.wave, global.fastenter);

//	update_wave_counters(global.wave, rogue, oGameManager.alt);

//	adjust_fast_entry(global.fastenter);
//} else {
//	challenge_stage_logic(x, y, global.scale);
//}
