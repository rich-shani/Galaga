if (global.gameMode == GameMode.GAME_ACTIVE) {

	if enter = 0{

	if instance_number(EnemyShot) < 8{

	if alarm[1] = 45+15{instance_create(x,y,EnemyShot);}

	if alarm[1] = 30+10{instance_create(x,y,EnemyShot);}

	if global.shotnumber > 2 and alarm[1] = 15+5{instance_create(x,y,EnemyShot);}

	}



	if global.fast = 1 and dive2 = 1{spd = 6;}

	else{spd = 3;}



	breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + oGameManager.x - 16;

	breathey = ystart;



	if created = 1{

	    y = y - 2; 

	    if x < breathex{x = x + 1}

	    if x > breathex{x = x - 1}

	    if y < breathey{created = 0; x = breathex; y = breathey; sound_stop(GFighterCaptured)};

	}



	else{

	if dive = 0{ ///convoy

	    depth = 100;

	    if alarm[0] = -1{direction = 0}

	    else{if direction > 90{direction = direction - 6}}

	    loop = 0;

	    x = breathex

	    y = breathey

	    if irandom(10) = 0 and global.prohib = 0 and uprohib = 0 and Ship.shipStatus = ShipState.ACTIVE and global.divecap > 0 and global.open = 0 and Ship.alarm[4] = -1{

	    if instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack{}else{

	        check = 0;

	        with Boss{if carrying = 1{Fighter.check = 1};}

	        if check = 0{

	            dive = 1; direction = 90;

	            global.prohib = 1; oGameManager.alarm[0] = 15; alarm[1] = 90; sound_stop(GDive); sound_play(GDive);

	            if xstart > 224{path_start(Boss1,spd,0,false)}

	            else{path_start(Boss1Flip,spd,0,false)}
 
	        }

	    }}

	}



	if dive = 1{ ///charger

	    depth = -100;

	    if loop < 1{

	        check = 0;

	        with Boss{if carrying = 1{Fighter.check = 1};}

	        if y > 592 - add{

	            if check = 1{path_end(); x = breathex; y = -48 - 32 - add; direction = 270; hspeed = 0; vspeed = 0; loop = 1;}

	            else{

	                if xstart = 176{global.fighterstore = 1};

	                if xstart = 176+32{global.fighterstore = 2};

	                if xstart = 176+64{global.fighterstore = 3};

	                if xstart = 176+96{global.fighterstore = 4};

	                instance_destroy();

	            }

	        }

	    }  

	    if loop = 1{

	        if instance_number(Bee) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -48 - 32 - add or Ship.shipStatus == ShipState.DEAD{

	            if y < breathey{y = y + 3;

	            if x < breathex{x = x + 1;}

	            if x > breathex{x = x - 1;} 

	            }

	            else{

	                x = breathex; 

	                y = breathey; 

	                dive = 0; dive2 = 0; alarm[0] = 30;

	            }

	        }

	        else{

	            alarm[1] = 61; loop = 0; dive2 = 1; if global.fast = 1{spd = 6;}

	            if xstart > 224{path_start(Boss1Alt,spd,0,false)}

	            else{path_start(Boss1AltFlip,spd,0,false)}
 
	        }

	    }

	}

	}

	}


	if global.fastenter = 1 and global.open = 1{if fasty > 0{fasty = fasty - 1}else{path_speed = 12; speed = 12}};

	if enter = 1{

	        if y < 272-16 and direction < 180 and goto = 0{

	                path_end(); if global.fastenter = 1{speed = 12} else{speed = 6}

	                if global.fighterstore = 1{xstart = 176; ystart = 48;}

	                if global.fighterstore = 2{xstart = 176+32; ystart = 48;}

	                if global.fighterstore = 3{xstart = 176+64; ystart = 48;}

	                if global.fighterstore = 4{xstart = 176+96; ystart = 48;}

                

	                breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + oGameManager.x - 16;

	                breathey = ystart;



	                goto = 1; move_towards_point(breathex,breathey,speed); exit

	        }

	        if goto = 1{

	            breathex = xstart + ((global.breathe/120)*(48*((xstart - 224)/144))) + oGameManager.x - 16;

	            breathey = ystart;

	            move_towards_point(breathex,breathey,speed);

	            if y < breathey + speed{x = breathex; y = breathey; goto = 0; numb = 0; enter = 0; dive = 0; 

	            global.fighterstore = 0;  

	            } 

	        }

	    }
}

