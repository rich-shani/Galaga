/// @description High Score Initials

// This code manages the process of updating a high score table when a player achieves a new high score in a game. 
// It checks if the player's score (global.p1score) is higher than the lowest score on the high score list (global.galaga5). 
// If so, it initiates the process for the player to enter their initials by setting the game mode to ENTER_INITIALS 
// and prepares various variables for the high score entry sequence, such as stopping all sounds, starting a new sound loop, and setting alarms.

// Check if the player's score is higher than the lowest high score
if (global.p1score > global.galaga5) {

    // Set the game mode to allow the player to enter their initials
    global.gameMode = GameMode.ENTER_INITIALS;

    // Set results flag, stop all sounds, and initialize cycle variable
    results = 2;
    sound_stop_all();
    cyc = 1;

    // Place the player's score in the 5th (lowest) high score slot
    global.galaga5 = global.p1score;

    // Prepare the initials slot for the new score (blank for now)
    global.init5 = "   ";

    // Start the secondary sound loop, reset loop variable, set alarm for next step, and mark scored position
    sound_loop(G2nd);
    loop = 0;
    alarm[7] = 15;
    scored = 5;

    // Check if the player's score is higher than the 4th high score
    if (global.p1score > global.galaga4) {

        // Move the 4th score down to 5th, and place the new score in 4th
        global.galaga5 = global.galaga4;
        global.galaga4 = global.p1score;

        // Shift initials accordingly
        global.init5 = global.init4;
        global.init4 = "   ";
        scored = 4;

        // Check if the player's score is higher than the 3rd high score
        if (global.p1score > global.galaga3) {

            // Move the 3rd score down to 4th, and place the new score in 3rd
            global.galaga4 = global.galaga3;
            global.galaga3 = global.p1score;

            // Shift initials accordingly
            global.init4 = global.init3;
            global.init3 = "   ";
            scored = 3;

            // Check if the player's score is higher than the 2nd high score
            if (global.p1score > global.galaga2) {

                // Move the 2nd score down to 3rd, and place the new score in 2nd
                global.galaga3 = global.galaga2;
                global.galaga2 = global.p1score;

                // Shift initials accordingly
                global.init3 = global.init2;
                global.init2 = "   ";
                scored = 2;

                // Check if the player's score is higher than the top high score
                if (global.p1score > global.galaga1) {

                    // Move the top score down to 2nd, and place the new score at the top
                    global.galaga2 = global.galaga1;
                    global.galaga1 = global.p1score;

                    // Shift initials accordingly
                    global.init2 = global.init1;
                    global.init1 = "   ";
                    scored = 1;

                    // Play special sound for new top score, reset loop, and mark scored position
                    sound_stop_all();
                    sound_play(G1st15);
                    loop = 0;
                    scored = 1;
                }
            }
        }
    }
}
// If the player's score is not high enough, restart the room (game)
else {
    //room_restart();
	game_restart();
}


