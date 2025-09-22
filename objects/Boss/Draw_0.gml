if loop = -1{

if alarm[3] > ((2*global.beamtime)/3) - 1{draw_sprite_ext(spr_beam,floor(anim/2),round(x),round(y),((abs(global.beamtime-alarm[3]))/(global.beamtime/3)),((abs(global.beamtime-alarm[3]))/(global.beamtime/3)),0,c_white,((abs(global.beamtime-alarm[3]))/(global.beamtime/3)))}

if alarm[3] < ((2*global.beamtime)/3) and alarm[3] > global.beamtime/3{draw_sprite_ext(spr_beam,floor(anim/2),round(x),round(y),1,1,0,c_white,1)}

if alarm[3] < (global.beamtime/3) + 1{draw_sprite_ext(spr_beam,floor(anim/2),round(x),round(y),((alarm[3])/(global.beamtime/3)),((alarm[3])/(global.beamtime/3)),0,c_white,((alarm[3])/(global.beamtime/3)))}

}



if hit = 0{



if dive = 0 and (alarm[0] = -1 or (direction > 80 and direction < 100)) {

	if (global.roomname == "GalagaWars") {
		draw_sprite_ext(sTieIntercepter,0,x,y,1,1,0,c_white,1);
	}
	else if global.flip > 29 {  //odd

		draw_sprite_ext(spr_ship,2,x,y,1,1,0,c_white,1);
	}
	else {  //even

		draw_sprite_ext(spr_ship,3,x,y,1,1,0,c_white,1);
	}

}
else {
	if (global.roomname == "GalagaWars") {
			var d = (direction+90)%360;
			var i = round(d/15);
					
			draw_sprite_ext(sTieIntercepter,i,x,y,1,1,0,c_white,1);
	}
	else if round(direction/15) & 1 = 0 {  //odd

		draw_sprite_ext(spr_ship,2,x,y,1,1,direction-90,c_white,1);
	}
	else {  //even

		draw_sprite_ext(spr_ship,3,x,y,1,1,direction-90,c_white,1);
	}
}



}

else{



if dive = 0 and (alarm[0] = -1 or (direction > 80 and direction < 100)){

if global.flip > 29{  //odd

draw_sprite_ext(spr_ship,4,x,y,1,1,0,c_white,1);}

else{  //even

draw_sprite_ext(spr_ship,5,x,y,1,1,0,c_white,1);}

}

else{

if round(direction/15) & 1 = 0{  //odd

draw_sprite_ext(spr_ship,4,x,y,1,1,direction-90,c_white,1);}

else{  //even

draw_sprite_ext(spr_ship,5,x,y,1,1,direction-90,c_white,1);}

}



}



if Ship.shipStatus == ShipState.CAPTURED and Ship.alarm[2] = -1 and Ship.spinanim = 0 and beam = 1{draw_sprite(spr_ship,1,x,y+28)}


