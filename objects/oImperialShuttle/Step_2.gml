//// Destroy the instance if it goes out of bounds and is rogue
////if (rogue == 1) && (y > 592 * global.scale || x < -32 * global.scale || x > 464 * global.scale) {
////	instance_destroy();
////}

//// Enemy shooting logic: limit number of shots on screen
//if (instance_number(EnemyShot) < 8) {
//	// Fire at specific alarm[1] values
//	if (alarm[1] == 60) { // 45 + 15
//		instance_create(x, y, EnemyShot);
//	}
//	if (alarm[1] == 40) { // 30 + 10
//		instance_create(x, y, EnemyShot);
//	}
//	if (global.shotnumber > 2 && alarm[1] == 20) { // 15 + 5
//		instance_create(x, y, EnemyShot);
//	}
//}

//// Calculate breathing (formation oscillation) positions
//breathex = xstart + ((global.breathe / 120) * (48 * ((xstart - 448) / 368))) + floor(oGameManager.x);
//breathey = ystart + ((global.breathe / 120) * (48 * ((ystart - 128) / 288)));

//// Set speed based on global.fast and dive2 state
//if (global.fast == 1 && dive2 == 1) {
//	spd = 6;
//} else {
//	spd = 3;
//}

//if (global.fastenter == 1 && global.open == 1) {
//	if (fasty > 0) {
//		fasty -= 1;
//	} else {
//		path_speed = 12 * global.scale;
//		speed = 12 * global.scale;
//	}
//}

//// Transformation logic (enemy transforms into another type)
//if (global.transnum > 0) {
//	if (
//		dive == 0 && irandom(5) == 0 && global.divecap > 0 && uprohib == 0 &&
//		global.prohib == 0 && global.transform == 0 &&
//		oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0 &&
//		instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) < 21 &&
//		global.open == 0 && oPlayer.alarm[4] == -1
//	) {
//		alarm[2] = 50;
//		global.transform = 1;
//		sound_play(GTransform);
//	}
//}

/////=======================

//if (enemyState == EnemyState.ENTER_SCREEN) {
////		if (global.pattern == 0 || global.pattern == 1) {
//	// Check if reached end of path
//	if (y < (272 - 16) * global.scale) {
//		if (rogue == 0) { 

//			if (direction < 180) {
//				path_end();

//				// look-up formation position based on INDEX
//				xstart = formation.POSITION[INDEX]._x;
//				ystart = formation.POSITION[INDEX]._y;

//				// Set speed for fast entry or normal
//				if (global.fastenter == 1) {
//					speed = 12 * global.scale;
//				} else {
//					speed = 6 * global.scale;
//				}

//				enemyState = EnemyState.MOVE_INTO_POSITION;
//			}
//		}
//	}
//}
//else if (enemyState != EnemyState.ENTER_SCREEN) {
	
//	if (enemyState == EnemyState.MOVE_INTO_POSITION) {
//		move_towards_point(breathex, breathey, speed);

//		// LOGIC to run once enemy has reached formation position
//		// Snap to position and reset states
//		if (y < breathey) {
//			x = breathex;
//			y = breathey;
//			goto = 0;
//			numb = 0;
//			enter = 0;
//			enemyState = EnemyState.IN_FORMATION;

//			dive = 0;
					
//			// set alarm : to give time for the Draw function to ROTATE the ship to down direction
//			alarm[0]=60;
//		}
//	}
	
//	// Convoy (formation movement) logic
//	else if (enemyState != EnemyState.IN_DIVE_ATTACK) {
//	//	depth = 100;

//		// LOGIC to rotate sprite during ALARM[0] is active
//		// USE to align the sprite to face-down in formation 
//		if (enemyState == EnemyState.IN_FORMATION) {
//			// 270 degree is pointing down 
//			// as 0 is to the right, 90 is up, 180 left, 270 down
//			if ((alarm[0] == -1) && direction != 270) {
		
//				direction = 270;
//			} else if (abs(direction - 270) > 6) {
//				direction += 6;
//			}
//		}

//		// Move to breathing position
//		x = breathex;
//		y = breathey;

//		// Random chance to start a dive attack when ENTERING SCREEN
//		if (global.divecap > 0 and global.open == 0 and oPlayer.alarm[4] == -1) {
//			if (
//				irandom(10) == 0 && global.prohib == 0 && uprohib == 0 &&
//				alarm[2] == -1 && oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0
//			) {
//				dive = 1;
//			//	direction = 90;
//				global.prohib = 1;
//				oGameManager.alarm[0] = 15;
//				alarm[1] = 90;
//				sound_stop(GDive);
//				sound_play(GDive);

//				// Choose path based on starting position
//				if (xstart > 224 * global.scale) {
//					path_start(Butterfly1, spd * global.scale, 0, false);
//				} else {
//					path_start(Butterfly1Flip, spd * global.scale, 0, false);
//				}
				
//				enemyState = EnemyState.IN_DIVE_ATTACK;
//			}
//		}
//	}
//}


//if trans = 0{

//if dive = 1 and escort = 0 and enter = 0{ ///charger, no escort

//    depth = -102;

//    if loop = 0{

//        if y > ystart + 64*global.scale and direction = 270{path_end(); speed = spd*global.scale; direction = 270;

//        if global.fast = 1 and dive2 = 1{loop = 4} else{loop = 1}

//    }}

//    if loop = 1{

//        if tim = 0{tim = irandom(60/spd) + 60/spd; if x < (48){direc = 0}else{if x > (400*global.scale){direc = 1}else{direc = irandom(1)}}};

//        if tim > 0{

//        tim = tim - 1;

//            if direc = 0{if x < (48){direc = 1};if direction > 225{direction = direction - spd}else{direction = 225}};

//            if direc = 1{if x > (400){direc = 0};if direction < 315{direction = direction + spd}else{direction = 315}};

//        }

//        if y > (596+32+32)*global.scale{
//			path_end(); x = breathex; y = -16; direction = 270; loop = 5;}

//    }

//    if loop = 4{

//        if (y > (596+32+32)*global.scale) {
//			path_end(); x = breathex; y = -16; direction = 270; loop = 5;}

//    }  

//    if loop = 5{

//        if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -16  or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

//            speed = 0;

//            if y < breathey{y = y + 3;

//            if x < breathex{x = x + 1;}

//            if x > breathex{x = x - 1;} 

//            }

//            else{

//                x = breathex; 

//                y = breathey; 

//                dive = 0; dive2 = 0; uprohib = 1; 				
//				enemyState = EnemyState.IN_POSITION;alarm[0] = 30; trans = 0;

//            }

//        }

//        else{

//        alarm[1] = 61; loop = 0; if global.fast = 1{dive2 = dive2 + 1; if dive2 = 3{spd = 3; dive2 = 0;}else{spd = 6;}}else{dive2 = 1;}

//            sound_stop(GDive); sound_play(GDive);

//            if global.fast = 1 and dive2 = 1{

//            if xstart > 224*global.scale{
//				path_start(Butterfly2,spd*global.scale,0,false)}

//            else{path_start(Butterfly2Flip,spd*global.scale,0,false)}
 
//            }

//            else{

//                if global.fast = 1 and dive2 = 2{

//                direction = 270; speed = spd*global.scale; loop = 1;

//                }

//                else{

//                    if xstart > 224*global.scale{path_start(Butterfly1Alt,spd*global.scale,0,false)}

//                    else{path_start(Butterfly1AltFlip,spd*global.scale,0,false)}
 
//                }

//            }

			 
//        }

//    }

//}



//if dive = 1 and escort = 1 and enter = 0{ ///charger, escort

//    depth = -101;

//    if loop = 0{

//        if (y > (592+32+32+add)*global.scale) {
//			path_end(); x = breathex; y = -16+add; direction = 270; loop = 1;
//		}

//    }  

//    if loop = 1{

//        if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack or y > -16+add or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

//            if y < breathey{

//            y = y + 3;

//            if x < breathex{x = x + 1;}

//            if x > breathex{x = x - 1;} 

//            }

//            else{

//                x = breathex; 

//                y = breathey; 

//                dive = 0; dive2 = 0; uprohib = 1; dir = 0; alarm[0] = 30;

//                escort = 0;

//            }

//        }

//        else{

//        alarm[1] = 61; loop = 0; dive2 = 1; if global.fast = 1{spd = 6;}

//            sound_stop(GDive); sound_play(GDive);

//            if dir = 1{path_start(Boss1Alt,spd*global.scale,0,false)};

//            if dir = -1{path_start(Boss1AltFlip,spd*global.scale,0,false)};

			 
//        }

//    }

//}

//}

//if trans = 1{

//if dive = 1 and enter = 0{ ///charger

//    depth = -103;

//    if y < ystart + 160*global.scale and loop = 0{}

//    else{

//        if loop = 0{

//            if y < 480*global.scale {
//				path_end(); if direction < 270{direction = direction + 1}; if direction > 270{direction = direction - 1}; speed = spd*global.scale}

//            else {
//				loop = 1;

//                if (xstart > 224*global.scale) {
//					path_start(BeeLoop,spd*global.scale,0,false); loop = 2}

//                else{path_start(BeeLoopFlip,spd*global.scale,0,false); loop = 2}
//            }

//        }

//        if loop = 1{

//            ///if y < 480{

//                path_end();

//                y = y - 3;

//                if x < breathex{x = x + 1;}

//                if x > breathex{x = x - 1;} 

//                if direction < 90{direction = direction + 1}; if direction > 90{direction = direction - 1};

//                if y < breathey{

//                    x = breathex; 

//                    y = breathey;

//                    dive = 0; dive2 = 0; uprohib = 1; alarm[0] = 30; trans = 0;

//                }

//            ///}

//        }

//        if loop = 2{

//            if instance_number(Bee) + instance_number(oTieFighter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack  or (oPlayer.shipStatus == _ShipState.DEAD or oPlayer.regain = 1){

//                if (xstart > 224*global.scale and direction > 75 and direction < 80) {
//					path_end(); loop = 1;}

//                if (xstart < 224*global.scale and direction > 100 and direction < 105) {
//					path_end(); loop = 1;}

//            }

//            if (y > (592+32+32)*global.scale) {

//                x = breathex; y = -16; loop = 0;

//                alarm[1] = 61; dive2 = 1; if global.fast = 1{spd = 6;} sound_stop(GDive); sound_play(GDive);

//                if (xstart > 224*global.scale) {
//					path_start(Bee1Alt,spd*global.scale,0,false)}

//                else{path_start(Bee1AltFlip,spd*global.scale,0,false)}
 
//            }

//        }

//    }

//}

//}


//if global.fastenter = 1 and global.open = 1{if fasty > 0{fasty = fasty - 1}else{path_speed = 12*global.scale; speed = 12*global.scale}}

//if timey > 0{timey = timey - 1}; ///time attempt fix ///

	

//        if (enemyState == EnemyState.MOVE_INTO_POSITION){

//            move_towards_point(breathex,breathey,speed);

//            if y < breathey{
//				x = breathex; y = breathey; goto = 0; 
//				numb = 0; enter = 0; enemyState = EnemyState.IN_POSITION; dive = 0; 					
//				// set alarm : to give time for the Draw function to ROTATE the ship to down direction
//				alarm[0]=60;};

//		}   
//    }

//}

//script_execute(rogueturn)


