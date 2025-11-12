/// @file HighScoreSystem.gml
/// @description High score management functions including score entry && initial input
///
/// FUNCTIONS:
///   - shift_scores_for_new_high_score() - Shifts existing scores when new high score achieved
///   - Enter_Initials() - Handles player input for entering 3-character initials
///
/// RELATED FILES:
///   - scripts/highscores.gml - High score table loading/saving
///   - scripts/set_score.gml - Persists score to GMScoreboard
///   - objects/oGameManager - Uses these functions during ENTER_INITIALS game mode

/// @function shift_scores_for_new_high_score
/// @description Shifts existing high scores down when a new score qualifies
///              Updates both scores && initials arrays
/// @param {number} position - Where new score ranks (1-5)
/// @param {number} new_score - The new score value
/// @return {undefined}
function shift_scores_for_new_high_score(position, new_score) {
    var idx = position - 1;  // Convert 1-based to 0-based

    // === SHIFT SCORES DOWN ===
    // Move positions (idx+1) through 4 down by one
    for (var i = 4; i > idx; i--) {
        global.Game.HighScores.scores[i] = global.Game.HighScores.scores[i - 1];
        global.Game.HighScores.initials[i] = global.Game.HighScores.initials[i - 1];
    }

    // === INSERT NEW SCORE ===
    global.Game.HighScores.scores[idx] = new_score;
    global.Game.HighScores.initials[idx] = "   ";  // Blank for entry

    // === SYNC DISPLAY ===
    global.Game.HighScores.display = global.Game.HighScores.scores[0];
}

/// @function Enter_Initials
/// @description Handles player input for entering initials on the high score screen
///              Allows navigation through character cycle && selection of characters
///              for high score name entry (3 characters per initial slot)
/// @return {undefined}
function Enter_Initials() {

    // === NAVIGATE LEFT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_left) && alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc -= 1;  // Move to previous character
        if cyc <= 0 {
            cyc = string_length(cycle); // Wrap to last character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === NAVIGATE RIGHT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_right) && alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc += 1; // Move to next character
        if cyc > string_length(cycle) {
            cyc = 1; // Wrap to first character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === SELECT CHARACTER (SPACE KEY) ===
    if (keyboard_check_pressed(vk_space) && loop > 0 && global.Game.State.results < 5) {

        // Get new character from cycle string
        var _new_char = string_char_at(cycle, cyc);

        // Get the array index (scored is 1-based position, convert to 0-based)
        var pos_idx = scored - 1;

        // Get current initials string for this position
        var current_initials = global.Game.HighScores.initials[pos_idx];

        // Update character at current position (global.Game.HighScores.initials_idx tracks which of 3 characters we're editing)
        global.Game.HighScores.initials_idx = global.Game.State.results - 2;  // 0-based index (0, 1, || 2)
        current_initials = string_delete(current_initials, global.Game.HighScores.initials_idx + 1, 1);
        current_initials = string_insert(_new_char, current_initials, global.Game.HighScores.initials_idx + 1);

        // === UPDATE STRUCT ARRAY ===
        global.Game.HighScores.initials[pos_idx] = current_initials;

        // === MOVE TO NEXT CHARACTER OR FINALIZE ===
        global.Game.State.results += 1;
        cyc = 1;  // Reset character cycle

        if global.Game.State.results == 5 {
            // === ALL 3 CHARACTERS ENTERED ===

            // Get finalized initials && score for this position
            var final_initials = global.Game.HighScores.initials[pos_idx];
            var final_score = global.Game.HighScores.scores[pos_idx];

            // === SAVE TO GMSCOREBOARD ===
            // This persists the score to GMScoreboard backend
            set_score(final_initials, final_score);

            // === ADJUST TIMING ===
            // Speed up transitions if multiple players entered scores
            if loop == 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 2;
            }
            if loop == 2 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 1;
            }

            loop = 3; // Mark as post-entry phase

            // Longer delay before returning if multiple scorers
            if scored > 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 120;
            }
        }
    }
}