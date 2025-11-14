function rogueturn() {
	if rogue = 1{
	if y > ROGUE_TRANSITION_Y {speed = 6}
	else{
	    if targx = 0 && targy = 0{
	        if path_position = 1{
	            path_end(); speed = 6;
	            shipx=oPlayer.x;
	            if global.Game.Level.wave = 1 || global.Game.Level.wave = 2{if x<SCREEN_CENTER_X{targx = SCREEN_CENTER_X * 2}else{targx = 0};targy = y}
	            else{
	            targx = SCREEN_CENTER_X; targy = PLAYER_SPAWN_Y
	            };
	        }
	    }
	    else{
	        if targy < PLAYER_SPAWN_Y{targy = targy + 6}; //y-position of target moving down
	        if targx < shipx - 3{targx = targx + 6}
	        if targx > shipx + 3{targx = targx - 6};
	        move_towards_point(targx,targy,6);
	    }
	}}



}
