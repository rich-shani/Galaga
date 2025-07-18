if global.gameover < 2{

if y < 592 and x > -16 and x < 464 and (y > -16 or global.challcount > 0){

if dive = 1{Ship.alarm[4] = global.hold + irandom(global.hold);} else{global.p1score += 150};

	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);	
	}

if beam = 1{sound_stop(GBeam)};

sound_stop(GBoss2); sound_play(GBoss2);

if dive = 1{

if global.challcount = 0{

    Controller.shotcount += 1; 

    if Controller.shotcount = 8{

        instance_create(round(x),round(y),TransPoints); 

        global.p1score += 400;

    }

    else{instance_create(round(x),round(y),Points400)};

}

else{

if intesc = 0{instance_create(round(x),round(y),Points400)}

if intesc = 1{instance_create(round(x),round(y),Points800)}

if intesc = 2{instance_create(round(x),round(y),Points1600)}

}

}

}

}


