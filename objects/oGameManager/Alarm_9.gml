/// @description High Score Entry Initialization
///
/// Triggered when level ends. Checks if player's score qualifies for high score table.
/// If so, initiates Enter_Initials mode and shifts scores as needed.

// Get high score status
var high_score_result = is_new_high_score(global.Game.Player.score);

if (high_score_result.is_high_score) {
    // === PLAYER ACHIEVED A HIGH SCORE ===

    // Set game mode to enter initials
    global.Game.State.mode = GameMode.ENTER_INITIALS;
    global.Game.State.results = 2;  // Start at character position 2 (0-indexed is 1)

    // Stop all sounds and prepare audio
    sound_stop_all();
	
    cyc = 1;
    loop = 0; // Reset loop counter
    scored = high_score_result.position;  // Store which position they scored in (1-5)

    // === SHIFT SCORES DOWN THE TABLE ===
    // Shift all scores below the new score down by one position
    shift_scores_for_new_high_score(high_score_result.position, global.Game.Player.score);

    // === START AUDIO SEQUENCE ===
    if (high_score_result.position == 1) {
        // New #1 score - special fanfare
        sound_play(G1st15);
    } else {
        // Top 5 but not #1
        sound_loop(G2nd);
    }

    alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 15;  // Timer for next phase

} else {
    // === NO HIGH SCORE ===
    // Return to title/attract mode

    room_goto(TitleScreen);
}

