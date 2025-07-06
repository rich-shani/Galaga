loop = 0;

spd = 3;

count = 0;

dive = 0;

if global.transnum = 1{

if global.transside = 1{path_start(Transform1,spd,0,false)}

else{path_start(Transform1Flip,spd,0,false)}

}

if global.transnum = 2{

if instance_number(Transform) = 1{count = 1; alarm[0] = 17; speed = 3; if global.transside = 1{direction = 292}else{direction = 248};}

if instance_number(Transform) = 2{count = 2; alarm[0] = 8; speed = 3; if global.transside = 1{direction = 292} else{direction = 248};}

}

if global.transnum = 3{

if instance_number(Transform) = 1{count = 1;}

if instance_number(Transform) = 2{count = 2;}

if ((global.transside = 1 and (Ship.x - x) > 0) or (global.transside = 0 and (Ship.x - x) < 0)){move_towards_point(x + irandom(64) - 32,480,6)}

    else{move_towards_point(Ship.x + irandom(64) - 32,480,6)}

}


