

if rogue = 1 and (y > (592*global.scale) or x < -16*global.scale or x > 464*global.scale){instance_destroy()};

if instance_number(EnemyShot) < 8{

if alarm[1] = 45+15{instance_create(x,y,EnemyShot);}

if alarm[1] = 30+10{instance_create(x,y,EnemyShot);}

if global.shotnumber > 2 and alarm[1] = 15+5{instance_create(x,y,EnemyShot);}

}

if (global.roomname == "GalagaWars") {
	breathex = xstart + ((global.breathe/120)*(48*((xstart - 448)/368))) + floor(oGameManager.x); // - 16;

	 breathey = ystart + ((global.breathe/120)*(48*((ystart - 128)/288)));
}
else {
	breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + floor(oGameManager.x); // - 16;

	breathey = ystart + ((global.breathe/120)*(48*((ystart - 64)/144)));			
}

if global.fast = 1 and dive2 > 0{spd = 6;}

else{spd = 3;}



if global.transnum > 0{

if dive = 0 and irandom(5) = 0 and global.divecap > 0 and uprohib = 0 and global.prohib = 0 and global.transform = 0 and oPlayer.shipStatus = _ShipState.ACTIVE and oPlayer.regain = 0 ///transforming

and instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) < 21 and instance_number(Bee) = 0 and global.open = 0 and oPlayer.alarm[4] = -1{

    alarm[2] = 50; global.transform = 1; sound_play(GTransform);

}

}



if dive = 0 and enter = 0{ ///convoy

    depth = 100;

    if alarm[0] = -1{direction = 0}

    else{if direction > 90{direction = direction - 6}}

    loop = 0;

    x = breathex;

    y = breathey;

    if global.divecap > 0 and global.open = 0 and oPlayer.alarm[4] = -1{

        if irandom(10) = 0 and global.prohib = 0 and uprohib = 0 and escort = 0 and alarm[2] = -1 and oPlayer.shipStatus == _ShipState.ACTIVE and oPlayer.regain = 0{

            dive = 1; direction = 90; global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; sound_stop(GDive); sound_play(GDive);

            if xstart > 224*global.scale{
				path_start(Butterfly1,spd*global.scale,0,false)}

            else{path_start(_OLD_Butterfly1Flip,spd*global.scale,0,false)}
			 
        }

    }

}



if trans = 0{

if dive = 1 and escort = 0 and enter = 0{ ///charger, no escort

    depth = -102;

    if loop = 0{

        if y > ystart + 64*global.scale and direction = 270{path_end(); speed = spd*global.scale; direction = 270;

        if global.fast = 1 and dive2 = 1{loop = 4} else{loop = 1}

    }}

    if loop = 1{

        if tim = 0{tim = irandom(60/spd) + 60/spd; if x < (48){direc = 0}else{if x > (400*global.scale){direc = 1}else{direc = irandom(1)}}};

        if tim > 0{

        tim = tim - 1;

            if direc = 0{if x < (48){direc = 1};if direction > 225{direction = direction - spd}else{direction = 225}};

            if direc = 1{if x > (400){direc = 0};if direction < 315{direction = direction + spd}else{direction = 315}};

        }

        if y > (596+32+32)*global.scale{
			path_end(); x = breathex; y = -16; direction = 270; loop = 5;}

    }

    if loop = 4{

        if (y > (596+32+32)*global.scale) {
			path_end(); x = breathex; y = -16; direction = 270; loop = 5;}

    }  

    if loop = 5{

        if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -16  or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

            speed = 0;

            if y < breathey{y = y + 3;

            if x < breathex{x = x + 1;}

            if x > breathex{x = x - 1;} 

            }

            else{

                x = breathex; 

                y = breathey; 

                dive = 0; dive2 = 0; uprohib = 1; alarm[0] = 30; trans = 0;

            }

        }

        else{

        alarm[1] = 61; loop = 0; if global.fast = 1{dive2 = dive2 + 1; if dive2 = 3{spd = 3; dive2 = 0;}else{spd = 6;}}else{dive2 = 1;}

            sound_stop(GDive); sound_play(GDive);

            if global.fast = 1 and dive2 = 1{

            if xstart > 224*global.scale{
				path_start(Butterfly2,spd*global.scale,0,false)}

            else{path_start(Butterfly2Flip,spd*global.scale,0,false)}
 
            }

            else{

                if global.fast = 1 and dive2 = 2{

                direction = 270; speed = spd*global.scale; loop = 1;

                }

                else{

                    if xstart > 224*global.scale{path_start(Butterfly1Alt,spd*global.scale,0,false)}

                    else{path_start(_OLD_Butterfly1AltFlip,spd*global.scale,0,false)}
 
                }

            }

			 
        }

    }

}



if dive = 1 and escort = 1 and enter = 0{ ///charger, escort

    depth = -101;

    if loop = 0{

        if (y > (592+32+32+add)*global.scale) {
			path_end(); x = breathex; y = -16+add; direction = 270; loop = 1;
		}

    }  

    if loop = 1{

        if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -16+add or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

            if y < breathey{

            y = y + 3;

            if x < breathex{x = x + 1;}

            if x > breathex{x = x - 1;} 

            }

            else{

                x = breathex; 

                y = breathey; 

                dive = 0; dive2 = 0; uprohib = 1; dir = 0; alarm[0] = 30;

                escort = 0;

            }

        }

        else{

        alarm[1] = 61; loop = 0; dive2 = 1; if global.fast = 1{spd = 6;}

            sound_stop(GDive); sound_play(GDive);

            if dir = 1{path_start(Boss1Alt,spd*global.scale,0,false)};

            if dir = -1{path_start(Boss1AltFlip,spd*global.scale,0,false)};

			 
        }

    }

}

}

if trans = 1{

if dive = 1 and enter = 0{ ///charger

    depth = -103;

    if y < ystart + 160*global.scale and loop = 0{}

    else{

        if loop = 0{

            if y < 480*global.scale {
				path_end(); if direction < 270{direction = direction + 1}; if direction > 270{direction = direction - 1}; speed = spd*global.scale}

            else {
				loop = 1;

                if (xstart > 224*global.scale) {
					path_start(BeeLoopFlip,spd*global.scale,0,false); loop = 2}

                else{path_start(BeeLoopFlip,spd*global.scale,0,false); loop = 2}
            }

        }

        if loop = 1{

            ///if y < 480{

                path_end();

                y = y - 3;

                if x < breathex{x = x + 1;}

                if x > breathex{x = x - 1;} 

                if direction < 90{direction = direction + 1}; if direction > 90{direction = direction - 1};

                if y < breathey{

                    x = breathex; 

                    y = breathey;

                    dive = 0; dive2 = 0; uprohib = 1; alarm[0] = 30; trans = 0;

                }

            ///}

        }

        if loop = 2{

            if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack  or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

                if (xstart > 224*global.scale and direction > 75 and direction < 80) {
					path_end(); loop = 1;}

                if (xstart < 224*global.scale and direction > 100 and direction < 105) {
					path_end(); loop = 1;}

            }

            if (y > (592+32+32)*global.scale) {

                x = breathex; y = -16; loop = 0;

                alarm[1] = 61; dive2 = 1; if global.fast = 1{spd = 6;} sound_stop(GDive); sound_play(GDive);

                if (xstart > 224*global.scale) {
					path_start(Bee1Alt,spd*global.scale,0,false)}

                else{path_start(Bee1AltFlip,spd*global.scale,0,false)}
 
            }

        }

    }

}

}


if global.fastenter = 1 and global.open = 1{if fasty > 0{fasty = fasty - 1}else{path_speed = 12*global.scale; speed = 12*global.scale}}

if timey > 0{timey = timey - 1}; ///time attempt fix ///

if enter = 1{

    if global.pattern = 0 or 1{

        if y < (272-16)*global.scale {
			
			if rogue = 0 {

	            if ((global.wave = 0 and direction < 180) or (global.wave > 0 and direction = 90)) and (global.pattern = 0 or global.pattern = 2 or (global.wave = 0 or timey = 0)) and goto = 0{

	                path_end(); 

					if (global.roomname == "GalagaWars") {
		                if numb = 2{xstart = 400; ystart = 220;}

		                if numb = 4{xstart = 490; ystart = 220;}

		                if numb = 6{xstart = 490; ystart = 280;}

		                if numb = 8{xstart = 400; ystart = 280;}

		                if numb = 10{xstart = 310; ystart = 220;}

		                if numb = 12{xstart = 580; ystart = 220;}

		                if numb = 14{xstart = 310; ystart = 280;}

		                if numb = 16{xstart = 580; ystart = 280;}

                

		                if numb = 17{xstart = 670; ystart = 220;}

		                if numb = 18{xstart = 760; ystart = 220;}

		                if numb = 19{xstart = 670; ystart = 280;}

		                if numb = 20{xstart = 760; ystart = 280;}

		                if numb = 21{xstart = 130; ystart = 220;}

		                if numb = 22{xstart = 220; ystart = 220;}

		                if numb = 23{xstart = 130; ystart = 280;}

		                if numb = 24{xstart = 220; ystart = 280;}					
					}
					else {
		                if numb = 2{xstart = 208*global.scale; ystart = (176-64)*global.scale;}

		                if numb = 4{xstart = 240*global.scale; ystart = (176-64)*global.scale;}

		                if numb = 6{xstart = 208*global.scale; ystart = (208-64)*global.scale;}

		                if numb = 8{xstart = 240*global.scale; ystart = (208-64)*global.scale;}

		                if numb = 10{xstart = 176*global.scale; ystart = 112*global.scale;}

		                if numb = 12{xstart = 272*global.scale; ystart = 112*global.scale;}

		                if numb = 14{xstart = 176*global.scale; ystart = (112+32)*global.scale;}

		                if numb = 16{xstart = 272*global.scale; ystart = (112+32)*global.scale;}

                

		                if numb = 17{xstart = 304*global.scale; ystart = 112*global.scale;}

		                if numb = 18{xstart = (304+32)*global.scale; ystart = 112*global.scale;}

		                if numb = 19{xstart = 304*global.scale; ystart = (112+32)*global.scale;}

		                if numb = 20{xstart = (304+32)*global.scale; ystart = (112+32)*global.scale;}

		                if numb = 21{xstart = 112*global.scale; ystart = 112*global.scale;}

		                if numb = 22{xstart = (112+32)*global.scale; ystart = 112*global.scale;}

		                if numb = 23{xstart = 112*global.scale; ystart = (112+32)*global.scale;}

		                if numb = 24{xstart = (112+32)*global.scale; ystart = (112+32)*global.scale;}
					}

	                if global.fastenter = 1{speed = 12*global.scale}else{speed = 6*global.scale};

	                goto = 1; move_towards_point(breathex,breathey,speed); exit;
	            }
			}

		}

        if goto = 1{

            move_towards_point(breathex,breathey,speed);

            if y < breathey{x = breathex; y = breathey; goto = 0; numb = 0; enter = 0; dive = 0};

		}   
    }

}

script_execute(rogueturn)


