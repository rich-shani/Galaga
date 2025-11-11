function waverogue() {
	count1 = 4; count2 = 4; alt = 0;
	if global.Game.Rogue.level = 1{
	    if global.Game.Level.wave = 0 || global.Game.Level.wave = 3 || global.Game.Level.wave = 4{rogue1 = 1; rogue2 = 1} else{rogue1 = 0; rogue2 = 0};
	}
	if global.Game.Rogue.level = 2{
	    rogue1 = 1; rogue2 = 1;
	}
	if global.Game.Rogue.level = 3{
	    if global.Game.Level.wave = 0 || global.Game.Level.wave = 3 || global.Game.Level.wave = 4{rogue1 = 2; rogue2 = 2} else{rogue1 = 1; rogue2 = 1}
	}
	if global.Game.Rogue.level = 4{
	    rogue1 = 2; rogue2 = 2;
	}



}
