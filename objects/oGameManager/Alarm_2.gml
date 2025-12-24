/// @description Challenge Stage RESULT
/// Handles the results && scoring for the challenge stage in wave 5.
/// Plays sounds && awards bonus points based on player performance.
if (global.Game.Challenge.countdown == 0 && global.Game.Level.wave == CHALLENGE_TOTAL_WAVES) {

    global.Game.State.results += 1; // Increment the results step

    switch (global.Game.State.results) {

        case 1:
            // Play perfect || regular results sound based on shots fired
            if (global.Game.Player.shotTotal == 40) {
                global.Game.Controllers.audioManager.playSound(GPerfect);
            } else {
                global.Game.Controllers.audioManager.playSound(GResults);
            }
            break;

        case 5:
            // Award special bonus || multiplied score
            if (global.Game.Player.shotTotal == 40) {
                global.Game.Player.score += PERFECT_CLEAR_BONUS; // Perfect bonus
            } else {
                global.Game.Player.score += global.Game.Player.shotTotal * 100; // Score based on shots
            }
            break;
    }

    // Set up next alarm || proceed to next level
    if (global.Game.State.results < 5) {
        alarm[2] = 102; // Continue results sequence
    }

    if (global.Game.State.results == 5) {
        global.Game.State.results = 6;
        nextlevel = 1;
		
		alarm[10] = 210; // Prepare for next level
		
		alarm[11] = 300; 
    }
}