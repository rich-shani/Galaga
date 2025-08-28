// Inherit the parent event
event_inherited();

if rogue = 1 and (y > 592*global.scale or x < -16*global.scale or x > 464*global.scale){instance_destroy()};

if instance_number(EnemyShot) < 8{

if alarm[1] = 45+15{instance_create(x,y,EnemyShot);}

if alarm[1] = 30+10{instance_create(x,y,EnemyShot);}

if global.shotnumber > 2 and alarm[1] = 15+5{instance_create(x,y,EnemyShot);}

}



breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + Controller.x - 16;

breathey = ystart + ((global.breathe/120)*(48*((ystart - 64)/144)));



if global.fast = 1 and dive2 = 1{spd = 6;}

else{spd = 3;}



if global.transnum > 0{

if dive = 0 and irandom(5) = 0 and global.divecap > 0 and uprohib = 0 and global.prohib = 0 and global.transform = 0 and Ship.shipStatus == ShipState.ACTIVE and Ship.regain = 0 ///transforming

and instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) < 21 and global.open = 0 and Ship.alarm[4] = -1{

    alarm[2] = 50; global.transform = 1; sound_play(GTransform);

}

}



if dive = 0 and enter = 0{ ///convoy

    depth = 100;

    if alarm[0] = -1{direction = 0}

    else{if direction > 90{direction = direction - 6}}

    loop = 0;

    x = breathex

    y = breathey

    if global.divecap > 0 and global.open = 0 and Ship.alarm[4] = -1{

        if irandom(10) = 0 and global.prohib = 0 and uprohib = 0 and alarm[2] = -1 and Ship.shipStatus == ShipState.ACTIVE and Ship.regain = 0{

            dive = 1; direction = 90; global.prohib = 1; Controller.alarm[0] = 15; alarm[1] = 90; sound_stop(GDive); sound_play(GDive);

            if xstart > 224{path_start(Bee1,spd,0,false)}

            else{path_start(Bee1Flip,spd,0,false)};

        }

		 
    }

}



if dive = 1 and enter = 0{ ///charger

    depth = -103;

    if y < ystart + 160 and loop = 0{}

    else{

        if loop = 0{

            if y < 480*global.scale{path_end(); if direction < 270{direction = direction + 1}; if direction > 270{direction = direction - 1}; speed = spd}

            else{loop = 1;

            ///if instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack  or (Ship.shipStatus = 1 or Ship.regain = 1){

             ///   if xstart > 224{path_start(Bee2,spd,0,false)}

              ///  else{path_start(Bee2Flip,spd,0,false)}

            ///}

            ///else{

                if xstart > 224{path_start(BeeLoop,spd,0,false); loop = 2}

                else{path_start(BeeLoopFlip,spd,0,false); loop = 2}

            ///}

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

            if instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack  or (Ship.shipStatus == ShipState.DEAD or Ship.regain = 1){

                if xstart > 224 and direction > 75 and direction < 80{path_end(); loop = 1;}

                if xstart < 224 and direction > 100 and direction < 105{path_end(); loop = 1;}

            }

            if y > 592+32+32{

                x = breathex; y = -16; loop = 0;

                alarm[1] = 61; dive2 = 1; if global.fast = 1{spd = 6;} sound_stop(GDive); sound_play(GDive);

                if xstart > 224{path_start(Bee1Alt,spd,0,false)}

                else{path_start(Bee1AltFlip,spd,0,false)};

            }

        }

		 
   }

}


if global.challcount > 0{

if global.fastenter = 1 and global.open = 1{if fasty > 0{fasty = fasty - 1}else{path_speed = 12; speed = 12}};

if enter = 1{

    if global.pattern = 0 or 1{

		// have we reached the end of the path?
        if (y < (272-16)*global.scale) {
			if rogue == 0 {

            if ((global.wave < 4 and direction < 90) or direction < 180) and goto = 0{

                path_end();

                if numb = 1{xstart = 208*global.scale; ystart = 176*global.scale;}

                if numb = 3{xstart = 240*global.scale; ystart = 176*global.scale;}

                if numb = 5{xstart = 208*global.scale; ystart = 208*global.scale;}

                if numb = 7{xstart = 240*global.scale; ystart = 208*global.scale;}

                

                if numb = 25{xstart = 272*global.scale; ystart = 176*global.scale;}

                if numb = 26{xstart = (272+32)*global.scale; ystart = 176*global.scale;}

                if numb = 27{xstart = 272*global.scale; ystart = 208*global.scale;}

                if numb = 28{xstart = (272+32)*global.scale; ystart = 208*global.scale;}

                if numb = 29{xstart = 144*global.scale; ystart = 176*global.scale;}

                if numb = 30{xstart = (144+32)*global.scale; ystart = 176*global.scale;}

                if numb = 31{xstart = 144*global.scale; ystart = 208*global.scale;}

                if numb = 32{xstart = (144+32)*global.scale; ystart = 208*global.scale;}

                

                if numb = 33{xstart = 80*global.scale; ystart = 176*global.scale;}

                if numb = 34{xstart = (80+32)*global.scale; ystart = 176*global.scale;}

                if numb = 35{xstart = 80*global.scale; ystart = 208*global.scale;}

                if numb = 36{xstart = 80+32; ystart = 208*global.scale;}

                if numb = 37{xstart = 336*global.scale; ystart = 176*global.scale;}

                if numb = 38{xstart = (336+32)*global.scale; ystart = 176*global.scale;}

                if numb = 39{xstart = 336*global.scale; ystart = 208*global.scale;}

                if numb = 40{xstart = (336+32)*global.scale; ystart = 208*global.scale;}

                

                breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + Controller.x - 16;

                breathey = ystart + ((global.breathe/120)*(48*((ystart - 64)/144)));

                

                if global.fastenter = 1{speed = 12}else{speed = 6};

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


