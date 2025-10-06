// Inherit the parent event
event_inherited();

if rogue = 1 and (y > 592*global.scale or x < -16*global.scale or x > 464*global.scale){instance_destroy()};

anim = anim + 1; if anim = 12{anim = 0};



if instance_number(EnemyShot) < 8{

if alarm[1] = 45+15{instance_create(x,y,EnemyShot);}

if alarm[1] = 30+10{instance_create(x,y,EnemyShot);}

if global.shotnumber > 2 and alarm[1] = 15+5{instance_create(x,y,EnemyShot);}

}



if global.fast = 1 and dive2 = 1{spd = 6;}

else{spd = 3;}


if (global.roomname == "GalagaWars") {
	breathex = xstart + ((global.breathe/120)*(48*((xstart - 448)/368))) + floor(oGameManager.x); // - 16;

	 breathey = ystart + ((global.breathe/120)*(48*((ystart - 128)/288)));
}
else {
	breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + floor(oGameManager.x); // - 16;

	breathey = ystart + ((global.breathe/120)*(48*((ystart - 64)/144)));			
}

if dive = 0 and enter = 0{ ///convoy

    depth = 100;

    if alarm[0] = -1{direction = 0}

    else{if direction > 90{direction = direction - 6}}

    loop = 0;

    x = breathex

    y = breathey

    if global.divecap > 0 and global.bosscap > 0 and global.open = 0 and oPlayer.alarm[4] = -1{

        if irandom(1) = 0 and global.prohib = 0 and uprohib = 0 and oPlayer.shipStatus == _ShipState.ACTIVE and oPlayer.regain = 0{

            dive = 1; direction = 90;

            global.bosscount = global.bosscount + 1; 

            if global.bosscount = 2 and global.lvl < 11{global.bosscount = 0};

            if global.bosscount = 3 and global.lvl > 10{global.bosscount = 0};

            with Boss{if beam = 1{global.beamcheck = 1}};

        if global.bosscount = 1 and global.beamcheck = 0 and global.fighterstore = 0 and

            instance_number(Fighter) = 0 and oPlayer.shotMode == _ShotMode.SINGLE{beam = 1; alarm[2] = 23} else{beam = 0}; global.beamcheck = 0;

            global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; sound_stop(GDive); sound_play(GDive);

            if carrying = 1{Fighter.x = x};

            if xstart > 224*global.scale{path_start(Boss1,spd*global.scale,0,false);

                if carrying = 1{with Fighter{

                    dive = 1; direction = 90;

                    global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; add = Boss.breathey - breathey - 32;

                    path_start(Boss1,spd*global.scale,0,false);

                }}
 
            }

            else{path_start(Boss1Flip,spd*global.scale,0,false)

                if carrying = 1{with Fighter{

                    dive = 1; direction = 90;

                    global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; add = Boss.breathey - breathey - 32;

                    path_start(Boss1Flip,spd*global.scale,0,false);

                }}
 
            }

     
	if beam = 0{ 

            check = 0;

                for (i = 0; i<instance_number(Butterfly); i+=1){

                    butts[i] = instance_find(Butterfly,i)

                    if butts[i].ystart = 112*global.scale{

                    if (butts[i].xstart = xstart){check = check + 1} //center

                    if (butts[i].xstart - 32 = xstart){check = check + 3} //left

                    if (butts[i].xstart + 32 = xstart){check = check + 5} //right

                    butts[i] = 0;

                    }

                }

            //center 1 //left 3 //right 5 //center and left 4 //center and right 6 //left and right 8

            if check = 9{

            if irandom(2) = 0{check = 10}//center and left 10

            else{if irandom(1) = 0{check = 11}//center and right 11

            else{check = 12}//left and right 12

            }}

            global.escortcount = 0;

            with Butterfly{if dive = 0 and ystart = 112*global.scale and uprohib = 0 and alarm[2] = -1{

                for (i = 0; i<instance_number(Boss); i+=1){

                    bosses[i] = instance_find(Boss,i)

                    if (bosses[i].xstart = xstart) and (bosses[i].check = 1 or bosses[i].check = 4 or bosses[i].check = 6 or bosses[i].check = 10 or bosses[i].check = 11){escort = 1} ///center

                    if (bosses[i].xstart + 32 = xstart) and (bosses[i].check = 3 or bosses[i].check = 4 or bosses[i].check = 8 or bosses[i].check = 10 or bosses[i].check = 12){escort = 1} ///left

                    if (bosses[i].xstart - 32 = xstart) and (bosses[i].check = 5 or bosses[i].check = 6 or bosses[i].check = 8 or bosses[i].check = 11 or bosses[i].check = 12){escort = 1} ///right

                    if escort = 1{

                        dive = 1; direction = 90; if bosses[i].path_index = Boss1{dir = 1} else{dir = -1}; global.escortcount = global.escortcount + 1

                        global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; add = breathey - Boss.breathey - 32;

                        path_start(bosses[i].path_index,spd*global.scale,0,false) i = 4;
						 

                    }

                    bosses[i] = 0;

                }

            }}

            check = 0;

            if beam = 1{intesc = 0;}

            else{

                intesc = global.escortcount;

                global.escortcount = 0;

            }

        }

        }

    }

}



if dive = 1 and ret = 0 and enter = 0{ ///charger

    if beam = 1{

        if y > 368*global.scale {

			// At BEAM activation position, STOP here, ie speed == 0
	        if loop = 0{speed = 0; direction = 270; alarm[3] = global.beamtime; loop = -1; sound_stop(GBeam); sound_loop(GBeam);}

			// BEAM complete, dive away
	        if loop < 0 and alarm[3] = -1{y = y + 4*global.scale; loop = -2;}

		}

    }

    depth = -100;

    if loop < 1{

        if (y > (592 + 32)*global.scale) { 
			path_end(); 
			x = breathex; 
			y = -48*global.scale; 
			direction = 270; 
			hspeed = 0; vspeed = 0; 
			loop = 1; beam = 0; beamsignal = 0;
		}

    }  

    if loop = 1{

        if instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -48 or 
							(oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

            if y < breathey{y = y + 3;

            if x < breathex{x = x + 1;}

            if x > breathex{x = x - 1;} 

            }

            else{

                x = breathex; 

                y = breathey; 

                dive = 0; dive2 = 0; uprohib = 1; alarm[0] = 30; intesc = 0;

            }

        }

        else{

            alarm[1] = 61; loop = 0; dive2 = 1; if global.fast = 1{spd = 6;}

            sound_stop(GDive); sound_play(GDive);

            if xstart > 224*global.scale{path_start(Boss1Alt,spd*global.scale,0,false)}

            else{path_start(Boss1AltFlip,spd*global.scale,0,false)}
			
			 

        }

    }

}

if dive = 1 and ret = 1 and enter = 0{ ///return

    if loop = 0 and y < 368*global.scale {

        path_end(); speed = 3*global.scale; follow = 1; loop = 1;

    }

    if loop = 1 and y < breathey + 32{

        speed = 0; direction = 90;

        y = y - 3;

        if x < breathex{x = x + 1;}

        if x > breathex{x = x - 1;} 

    }

    if loop = 1 and y < breathey{

            x = breathex; 

            y = breathey; 

            loop = 0; beam = 0; beamsignal = 0; ret = 0;

            dive = 0; dive2 = 0; intesc = 0; oPlayer.shipStatus = _ShipState.DEAD; oPlayer.alarm[0] = 120;

            carrying = 1;

            instance_create(x,y+28,Fighter); Fighter.xstart = xstart; Fighter.ystart = ystart - 32; 

    }

}

if follow = 1{

move_towards_point(breathex,breathey+32,3);

follow = 0;

}


if global.challcount > 0{

if global.fastenter = 1 and global.open = 1{if fasty > 0{fasty = fasty - 1}else{path_speed = 12*global.scale; speed = 12*global.scale}};

if enter = 1{

    if global.pattern = 0 or 1{

        if y < (272-16)*global.scale and direction = 90{if rogue = 0{

            if goto = 0{

                path_end(); 

				if (global.roomname == "GalagaWars") {
					if numb = 9{xstart = 320; ystart = 160; if global.fighterstore = 1{carrying = 1}}

					if numb = 11{xstart = (320+80); ystart = 160; if global.fighterstore = 2{carrying = 1}}

					if numb = 13{xstart = (320+160); ystart = 160; if global.fighterstore = 3{carrying = 1}}

					if numb = 15{xstart = (320+240); ystart = 160; if global.fighterstore = 4{carrying = 1}}	
				}
				else {
					if numb = 9{xstart = 176*global.scale; ystart = 80*global.scale; if global.fighterstore = 1{carrying = 1}}

					if numb = 11{xstart = (176+32)*global.scale; ystart = 80*global.scale; if global.fighterstore = 2{carrying = 1}}

					if numb = 13{xstart = (176+64)*global.scale; ystart = 80*global.scale; if global.fighterstore = 3{carrying = 1}}

					if numb = 15{xstart = (176+96)*global.scale; ystart = 80*global.scale; if global.fighterstore = 4{carrying = 1}}

					//        breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + oGameManager.x - 16;

					//        breathey = ystart + ((global.breathe/120)*(48*((ystart - 64)/144)));
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

}

else{

    if path_position = 1{instance_destroy()};

}


