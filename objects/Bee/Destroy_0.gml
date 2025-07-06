if Ship.gameover < 2{

if y < 592 and x > -16 and x < 464 and (y > -16 or global.challcount > 0){

if dive = 1{Ship.alarm[4] = global.hold + irandom(global.hold); if trans = 0{

if global.challcount > 0 or global.chall = 1{global.p1score += 100} else{global.p1score += 160};

}} 

else{global.p1score += 50};

if global.challcount = 0{Controller.shotcount += 1; if Controller.shotcount = 8{instance_create(round(x),round(y),TransPoints)}}

instance_create(round(x),round(y),Explosion);

if trans = 1{global.transcount = global.transcount + 1; global.p1score += 160; if global.transcount = 3{instance_create(round(x),round(y),TransPoints)}

if global.transnum = 1{sound_stop(GBoss2); sound_play(GBoss2)};

if global.transnum = 2{sound_stop(GButterfly); sound_play(GButterfly)};

if global.transnum = 3{sound_stop(GBoss1); sound_play(GBoss1)};

}

else{

    if global.challcount > 0 or global.chall = 1{sound_stop(GBee); sound_play(GBee)};

    if global.challcount = 0{

        if global.chall = 2 or global.chall = 3 or global.chall = 5 or global.chall = 6 or global.chall = 8{sound_stop(GButterfly); sound_play(GButterfly)};

        if global.chall = 4{sound_stop(GBoss2); sound_play(GBoss2)};

        if global.chall = 7{sound_stop(GBoss1); sound_play(GBoss1)}

    }

}

}

}


