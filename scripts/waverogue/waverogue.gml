function waverogue() {
	count1 = 4; count2 = 4; alt = 0;
	if global.rogue = 1{
	    if global.wave = 0 or global.wave = 3 or global.wave = 4{rogue1 = 1; rogue2 = 1} else{rogue1 = 0; rogue2 = 0};
	}
	if global.rogue = 2{
	    rogue1 = 1; rogue2 = 1;
	}
	if global.rogue = 3{
	    if global.wave = 0 or global.wave = 3 or global.wave = 4{rogue1 = 2; rogue2 = 2} else{rogue1 = 1; rogue2 = 1}
	}
	if global.rogue = 4{
	    rogue1 = 2; rogue2 = 2;
	}



}
