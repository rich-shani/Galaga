if !global.gameover {

if y < 592*global.scale and x > -16 and x < 464*global.scale and (y > -16 or global.challcount > 0) {

	if dive = 1{oPlayer.alarm[4] = global.hold + irandom(global.hold);} else{global.p1score += 150};

		if (irandom(1)) {
			instance_create(round(x), round(y), oExplosion);
		}
		else {
			instance_create(round(x), round(y), oExplosion2);	
		}

	// ensure all sound is stopped
	sound_stop(GBeam); sound_stop(GBoss2); sound_play(GBoss2);

		if dive = 1{

				if global.challcount = 0{

				    global.shotcount += 1; 

				    if global.shotcount = 8{

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


