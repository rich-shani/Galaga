/// @description Challenge Stage RESULT
/// Handles the results and scoring for the challenge stage in wave 5.
/// Plays sounds and awards bonus points based on player performance.

if (global.Game.Challenge.count == 0 && global.Game.Level.wave == 5) {

    global.Game.State.results += 1; // Increment the results step

    switch (global.Game.State.results) {

        case 1:
            // Play perfect or regular results sound based on shots fired
            if (global.Game.Player.shotTotal == 40) {
                sound_play(GPerfect);
            } else {
                sound_play(GResults);
            }
            break;

        case 5:
            // Award special bonus or multiplied score
            if (global.Game.Player.shotTotal == 40) {
                global.Game.Player.score += 10000; // Perfect bonus
            } else {
                global.Game.Player.score += global.Game.Player.shotTotal * 100; // Score based on shots
            }
            break;
    }

    // Set up next alarm or proceed to next level
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