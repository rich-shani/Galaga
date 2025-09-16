/// @description Challenge Stage RESULT
if global.challcount = 0 and global.wave = 5 {

    global.results += 1;

    switch global.results {

    case 1: 

        if global.shottotal = 40{sound_play(GPerfect)} else{sound_play(GResults)};

        break

    case 5: ///display "SPECIAL BONUS 10000 PTS" or custom multiplied number;

        if global.shottotal = 40{global.p1score += 10000} else{global.p1score += global.shottotal * 100};

        break

    }

    if global.results < 5{alarm[2] = 102}; 

    if global.results = 5{alarm[10] = 210; global.results = 6; global.nextlevel = 1};

}


