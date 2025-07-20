blip = 0;

// gameMode mode ... 30 steps, one per second, unless we're at step 15
if global.gameMode == GameMode.ATTRACT_MODE{

att += 1; if att = 15{alarm[3] = 10} else{alarm[3] = 60};

if att == 6{attpos = 368};

if att == 9{attpos = 272; attpause = 30; instance_create(384+x-16,336+y-16,oExplosion); instance_create(384+x-16,336+y-16,Points1600);};

if att == 12{attpos = 176; instance_create(288+x-16,336+y-16,oExplosion); instance_create(288+x-16,336+y-16,Points800);};

if att == 15{attpos = 80; instance_create(192+x-16,336+y-16,oExplosion); instance_create(192+x-16,336+y-16,Points400);};

if att == 17{instance_create(96,336,oExplosion); instance_create(96,336,Points150); alarm[3] = 70};

if att == 8 or att = 11{x=xstart; y=ystart; path_start(global.gameMode,3,0,0)};

if att == 14{path_end(); x=xstart; y=ystart; path_start(AttractFlip,3,0,0)};

if att == 16{path_end(); x=xstart; y=ystart};

}

// end of gameMode mode (step 30)
if att == 30{

    Ship.x = Ship.xstart; Ship.y = Ship.ystart

    att = 0; blip = 0; attpause = 0; attshot = 0; attshotx = 0; attshoty = 0;

}


