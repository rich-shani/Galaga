if (alarm[2] > 0 and alarm[2] < 11)

or (alarm[2] > 20 and alarm[2] < 31)

or (alarm[2] > 40 and alarm[2] < 51){





if global.flip > 29{  //odd

if global.transnum = 1{draw_sprite_ext(spr_ship,12,x,y,1,1,0,c_white,1);}

if global.transnum = 2{draw_sprite_ext(spr_ship,23,x,y,1,1,0,c_white,1);}

if global.transnum = 3{draw_sprite_ext(spr_ship,25,x,y,1,1,0,c_white,1);}

}

else{  //even

if global.transnum = 1{draw_sprite_ext(spr_ship,13,x,y,1,1,0,c_white,1);}

if global.transnum = 2{draw_sprite_ext(spr_ship,24,x,y,1,1,0,c_white,1);}

if global.transnum = 3{draw_sprite_ext(spr_ship,26,x,y,1,1,0,c_white,1);}

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

if global.challcount > 0 or global.chall = 1{sprit = 10; add = 1};

if global.challcount = 0{

    if global.chall = 2{sprit = 6; add = 1};

    if global.chall = 3{sprit = 18; add = 0};

    if global.chall = 4{sprit = 14; add = 1};

    if global.chall = 5{sprit = 19; add = 1}; ///crazy one

    if global.chall = 6{sprit = 16; add = 0};

    if global.chall = 7{sprit = 17; add = 0};

    if global.chall = 8{sprit = 22; add = 0};

}

// DRAW in FORMATION ....
if dive = 0 and (alarm[0] = -1 or (direction > 80 and direction < 100)) {

	// draw Sprite
	
	if (global.roomname == "GalagaWars") {
		draw_sprite_ext(sTieFighter,0,x,y,1,1,0,c_white,1);
	}
	else if global.flip > 29{  //odd

		draw_sprite_ext(spr_ship,sprit,x,y,1,1,0,c_white,1);
	}
	else {  //even

		draw_sprite_ext(spr_ship,sprit+add,x,y,1,1,0,c_white,1);
	}
}
else {

    if global.chall = 5 and global.challcount = 0{ //satellite sprite

        switch floor(direction/90){ 

            case 0: satx = -1; saty = 1; break

            case 1: satx = 1; saty = 1; break

            case 2: satx = 1; saty = -1; break

            case 3: satx = -1; saty = -1; break

        }

        if round(direction/15) mod 3 = 0{  //30, 75 degrees

        draw_sprite_ext(spr_ship,sprit+(add*2),x,y,satx,saty,0,c_white,1);}

        else{

            if round(direction/15) mod 2 = 0{  //15, 60 degrees

            draw_sprite_ext(spr_ship,sprit+add,x,y,satx,saty,0,c_white,1);}

            else{ //0, 45, 90 degrees

            draw_sprite_ext(spr_ship,sprit,x,y,satx,saty,0,c_white,1);}

        }

    }

    else { // DRAW as it moves into FORMATION

		
        satx = 0; saty = 0;
		if (global.roomname == "GalagaWars") {
			var d = (direction+90)%360;
			var i = round(d/15);
					
			draw_sprite_ext(sTieFighter,i,x,y,1,1,0,c_white,1);
		}
		else if round(direction/15) & 1 = 0{  //odd

			draw_sprite_ext(spr_ship,sprit,x,y,1,1,direction-90,c_white,1);
		}
        else {  //even

			draw_sprite_ext(spr_ship,sprit+add,x,y,1,1,direction-90,c_white,1);
		}
    }

}

}

}


