trans = 1;

dive = 1; global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 75;

if xstart > 224{path_start(Bee1,spd*global.scale,0,false); global.transside = 1}

else{path_start(Bee1Flip,spd*global.scale,0,false); global.transside = 0};

if global.transnum = 1{alarm[3] = 44;}

if global.transnum = 2{alarm[3] = 25;}

if global.transnum = 3{alarm[3] = 66;}
