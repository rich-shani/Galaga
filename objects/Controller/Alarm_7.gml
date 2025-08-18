if loop = 0{loop = 1; if scored = 1{sound_loop(G1stEnd633)}; alarm[7] = 633; exit}

else {
	loop += 1; 
	if loop = 4 {
		room_restart();
	} 
	else {
		alarm[7] = 633;
	}
	
	exit;
}


