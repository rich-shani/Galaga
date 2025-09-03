/// @description High Score Initials
if global.p1score > global.galaga5{

	global.gameMode = GameMode.ENTER_INITIALS;
	
    results = 2; sound_stop_all(); cyc = 1;

    global.galaga5 = global.p1score;

    global.init5 = "   ";

    sound_loop(G2nd); loop = 0; alarm[7] = 15; scored = 5;

    if global.p1score > global.galaga4{

        global.galaga5 = global.galaga4; global.galaga4 = global.p1score;

        global.init5 = global.init4; global.init4 = "   "; scored = 4;

        if global.p1score > global.galaga3{

            global.galaga4 = global.galaga3; global.galaga3 = global.p1score;

            global.init4 = global.init3; global.init3 = "   "; scored = 3;

            if global.p1score > global.galaga2{

                global.galaga3 = global.galaga2; global.galaga2 = global.p1score;

                global.init3 = global.init2; global.init2 = "   "; scored = 2;

                if global.p1score > global.galaga1{

                    global.galaga2 = global.galaga1; global.galaga1 = global.p1score;

                    global.init2 = global.init1; global.init1 = "   "; scored = 1;

                    sound_stop_all(); sound_play(G1st15); loop = 0; scored = 1;

                }

            }

        }

    }

}

else{room_restart()}


