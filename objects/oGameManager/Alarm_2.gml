/// @description Challenge Stage RESULT
/// Handles the results and scoring for the challenge stage in wave 5.
/// Plays sounds and awards bonus points based on player performance.

if (global.challcount == 0 && global.wave == 5) {

    global.results += 1; // Increment the results step

    switch (global.results) {

        case 1:
            // Play perfect or regular results sound based on shots fired
            if (global.shottotal == 40) {
                sound_play(GPerfect);
            } else {
                sound_play(GResults);
            }
            break;

        case 5:
            // Award special bonus or multiplied score
            if (global.shottotal == 40) {
                global.p1score += 10000; // Perfect bonus
            } else {
                global.p1score += global.shottotal * 100; // Score based on shots
            }
            break;
    }

    // Set up next alarm or proceed to next level
    if (global.results < 5) {
        alarm[2] = 102; // Continue results sequence
    }

    if (global.results == 5) {
        global.results = 6;
        nextlevel = 1;
		
		alarm[10] = 210; // Prepare for next level
		
		alarm[11] = 300; 
    }
}