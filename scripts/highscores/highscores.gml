function load_highscores(){
	/// @description Load High Scores
	ini_open("highscores.ini");

	global.galaga1 = ini_read_real("highscores", "galaga1", 0); global.init1 = ini_read_string("highscores", "init1", 0);

	global.galaga2 = ini_read_real("highscores", "galaga2", 0); global.init2 = ini_read_string("highscores", "init2", 0);

	global.galaga3 = ini_read_real("highscores", "galaga3", 0); global.init3 = ini_read_string("highscores", "init3", 0);

	global.galaga4 = ini_read_real("highscores", "galaga4", 0); global.init4 = ini_read_string("highscores", "init4", 0);

	global.galaga5 = ini_read_real("highscores", "galaga5", 0); global.init5 = ini_read_string("highscores", "init5", 0);

	// check if we have any highscores loaded, if not then default
	if (global.galaga1 == 0 or global.galaga2 == 0 or global.galaga3 == 0 or global.galaga4 == 0 or global.galaga5 == 0) {

		global.galaga1 = 20000; global.init1 = "N.N";

		global.galaga2 = 20000; global.init2 = "A.A";

		global.galaga3 = 20000; global.init3 = "M.M";

		global.galaga4 = 20000; global.init4 = "C.C";

		global.galaga5 = 20000; global.init5 = "O.O";
	}

	// set the highscore display to the top score
	global.disp = global.galaga1;
}

function save_highscores(){
	/// @description Save High Scores
	ini_open("highscores.ini");

	// save the highscore table to file
	ini_write_real("highscores","galaga1",global.galaga1);ini_write_string("highscores","init1",global.init1);

	ini_write_real("highscores","galaga2",global.galaga2);ini_write_string("highscores","init2",global.init2);

	ini_write_real("highscores","galaga3",global.galaga3);ini_write_string("highscores","init3",global.init3);

	ini_write_real("highscores","galaga4",global.galaga4);ini_write_string("highscores","init4",global.init4);

	ini_write_real("highscores","galaga5",global.galaga5);ini_write_string("highscores","init5",global.init5);

	ini_close();
}