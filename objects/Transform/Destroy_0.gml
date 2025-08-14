if !global.gameover {

	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);	
	}

	if y < 576{

		global.p1score += 160;

		if dive = 1{Ship.alarm[4] = global.hold + irandom(global.hold);}

		global.transcount = global.transcount + 1; if global.transcount = 3{instance_create(round(x),round(y),TransPoints);}

		if global.transnum = 1{sound_stop(GBoss2); sound_play(GBoss2)};

		if global.transnum = 2{sound_stop(GButterfly); sound_play(GButterfly)};

		if global.transnum = 3{sound_stop(GBoss1); sound_play(GBoss1)};
	}
}


