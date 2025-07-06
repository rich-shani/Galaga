if global.challcount = 0 and global.wave = 5{

    results += 1;

    switch results{

    case 1: 

        if shottotal = 40{sound_play(GPerfect)} else{sound_play(GResults)};

        break

    case 5: ///display "SPECIAL BONUS 10000 PTS" or custom multiplied number;

        if shottotal = 40{global.p1score += 10000} else{global.p1score += shottotal * 100};

        break

    }

    if results < 5{alarm[2] = 102}; 

    if results = 5{alarm[10] = 210; results = 6; nextlevel = 1};

}


