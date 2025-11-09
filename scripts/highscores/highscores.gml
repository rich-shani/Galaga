/// @function get_high_score_at_position
/// @description Retrieves a specific high score by position
/// @param {number} position - Position 1-5 (1 = highest score)
/// @return {number} Score value at position, or 0 if invalid position
function get_high_score_at_position(position) {
    if (position < 1 || position > 5) return 0;
    return global.Game.HighScores.scores[position - 1];  // Convert 1-based to 0-based
}

/// @function get_high_score_initials_at_position
/// @description Retrieves initials for a specific high score position
/// @param {number} position - Position 1-5 (1 = highest score)
/// @return {string} Initials at position, or "???" if invalid
function get_high_score_initials_at_position(position) {
    if (position < 1 || position > 5) return "???";
    return global.Game.HighScores.initials[position - 1];  // Convert 1-based to 0-based
}

/// @function is_new_high_score
/// @description Checks if current player score qualifies for high score table
/// @param {number} player_score - Score to check
/// @return {object} { is_high_score: bool, position: 1-5 or -1 }
function is_new_high_score(player_score) {
    var result = {
        is_high_score: false,
        position: -1
    };

    // Check against each position (from highest to lowest)
    for (var i = 0; i < 5; i++) {  // i: 4,3,2,1,0 (positions 5,4,3,2,1)
        if (player_score > global.Game.HighScores.scores[i]) {
            result.is_high_score = true;
            result.position = i + 1;  // Convert 0-based to 1-based (1-5)
			
            break;
        }
    }

    return result;
}

function load_highscores() {
	
	// === INITIALIZE DEFAULT SCORES IF LIST IS EMPTY ===
    if (ds_list_empty(global.gmscoreboard_scores)) {
        // Set default high scores
        global.Game.HighScores.scores = [20000, 10000, 5000, 2000, 1000];
        global.Game.HighScores.initials = ["N.N", "A.A", "M.M", "C.C", "O.O"];
        global.Game.HighScores.display = 20000;
		
        return;
    }

    // === LOAD FROM GMSCOREBOARD DS_LIST ===
    var num_scores = ds_list_size(global.gmscoreboard_scores);
    var scores_to_load = min(num_scores, 5);  // Load max 5 scores

    // Clear arrays
    global.Game.HighScores.scores = [];
    global.Game.HighScores.initials = [];

    // === ITERATE THROUGH DS_LIST AND POPULATE STRUCT ARRAYS ===
    for (var i = 0; i < scores_to_load; i++) {
        var item = ds_list_find_value(global.gmscoreboard_scores, i);

        if (item != undefined) {
            var player_name = item[? "player"];
            var player_score = item[? "score"];

            // Add to arrays (auto-extends array)
            global.Game.HighScores.scores[i] = player_score;
            global.Game.HighScores.initials[i] = player_name;
        }
    }

    // === SET DISPLAY SCORE (TOP SCORE) ===
    global.Game.HighScores.display = global.Game.HighScores.scores[0];	
}

function save_highscores(){
	/// @description Save High Scores
	//ini_open("highscores.ini");

	//// save the highscore table to file
	//ini_write_real("highscores","galaga1",global.galaga1);ini_write_string("highscores","init1",global.init1);

	//ini_write_real("highscores","galaga2",global.galaga2);ini_write_string("highscores","init2",global.init2);

	//ini_write_real("highscores","galaga3",global.galaga3);ini_write_string("highscores","init3",global.init3);

	//ini_write_real("highscores","galaga4",global.galaga4);ini_write_string("highscores","init4",global.init4);

	//ini_write_real("highscores","galaga5",global.galaga5);ini_write_string("highscores","init5",global.init5);

	
	//ini_close();
}