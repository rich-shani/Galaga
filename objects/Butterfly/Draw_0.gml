if (alarm[2] > 0 and alarm[2] < 11)

or (alarm[2] > 20 and alarm[2] < 31)

or (alarm[2] > 40 and alarm[2] < 51){



if global.flip > 29{  //odd

if global.transnum = 1{draw_sprite_ext(spr_ship,8,x,y,1,1,0,c_white,1);}

if global.transnum = 2{draw_sprite_ext(spr_ship,27,x,y,1,1,0,c_white,1);}

if global.transnum = 3{draw_sprite_ext(spr_ship,29,x,y,1,1,0,c_white,1);}

}

else{  //even

if global.transnum = 1{draw_sprite_ext(spr_ship,9,x,y,1,1,0,c_white,1);}

if global.transnum = 2{draw_sprite_ext(spr_ship,28,x,y,1,1,0,c_white,1);}

if global.transnum = 3{draw_sprite_ext(spr_ship,30,x,y,1,1,0,c_white,1);}

}



}

else{



if trans = 1{



if global.transnum = 1{

if round(direction/15) & 1 = 0{  //odd

draw_sprite_ext(spr_ship,14,x,y,1,1,direction-90,c_white,1);}

else{  //even

draw_sprite_ext(spr_ship,15,x,y,1,1,direction-90,c_white,1);}

}

if global.transnum = 2{

draw_sprite_ext(spr_ship,16,x,y,1,1,direction-90,c_white,1);}

if global.transnum = 3{

draw_sprite_ext(spr_ship,17,x,y,1,1,direction-90,c_white,1);}



}

else{



if dive = 0 and (alarm[0] = -1 or (direction > 80 and direction < 100)) {
	
	if (global.roomname == "GalagaWars") {
		draw_sprite_ext(sImperialShuttle,0,x,y,1,1,0,c_white,1);
	}
	else if global.flip > 29 {  //odd

		draw_sprite_ext(spr_ship,6,x,y,1,1,0,c_white,1);
	}
	else {  //even

		draw_sprite_ext(spr_ship,7,x,y,1,1,0,c_white,1);
	}

}

	else{

		if (global.roomname == "GalagaWars") {
			var d = (direction+90)%360;
			var i = round(d/15);
					
			draw_sprite_ext(sImperialShuttle,i,x,y,1,1,0,c_white,1);
		}
		else if round(direction/15) & 1 = 0{  //odd

			draw_sprite_ext(spr_ship,6,x,y,1,1,direction-90,c_white,1);
		}
		else {  //even
			draw_sprite_ext(spr_ship,7,x,y,1,1,direction-90,c_white,1);
		}

	}

}

}


