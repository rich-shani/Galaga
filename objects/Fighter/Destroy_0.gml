if global.gameover < 2{

if y < 576 and Ship.regain = 0{

if dive = 1{Ship.alarm[4] = global.hold + irandom(global.hold);}

sound_play(GFighter); if dive = 0{global.p1score += 1000};

	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);	
	}

if dive > 0{instance_create(round(x),round(y),Points1000)};

with Boss{carrying = 0};

}

}


