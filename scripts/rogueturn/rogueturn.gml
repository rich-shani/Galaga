function rogueturn() {
	if rogue = 1{
	if y > 496{speed = 6}
	else{
	    if targx = 0 && targy = 0{
	        if path_position = 1{
	            path_end(); speed = 6;
	            shipx=oPlayer.x;
	            if global.Game.Level.wave = 1 || global.Game.Level.wave = 2{if x<224{targx = 448}else{targx = 0};targy = y}
	            else{
	            targx = 224; targy = 528
	            };
	        }
	    }
	    else{
	        if targy < 528{targy = targy + 6}; //y-position of target moving down
	        if targx < shipx - 3{targx = targx + 6}
	        if targx > shipx + 3{targx = targx - 6};
	        move_towards_point(targx,targy,6);
	    }
	}}



}
