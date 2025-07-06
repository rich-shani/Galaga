ini_open("highscores.ini");

global.galaga1 = ini_read_real("highscores", "galaga1", 0); global.init1 = ini_read_string("highscores", "init1", 0);

global.galaga2 = ini_read_real("highscores", "galaga2", 0); global.init2 = ini_read_string("highscores", "init2", 0);

global.galaga3 = ini_read_real("highscores", "galaga3", 0); global.init3 = ini_read_string("highscores", "init3", 0);

global.galaga4 = ini_read_real("highscores", "galaga4", 0); global.init4 = ini_read_string("highscores", "init4", 0);

global.galaga5 = ini_read_real("highscores", "galaga5", 0); global.init5 = ini_read_string("highscores", "init5", 0);



if (global.galaga1 == 0 or global.galaga2 == 0 or global.galaga3 == 0 or global.galaga4 == 0 or global.galaga5 == 0) {

global.galaga1 = 20000

global.init1 = "N.N"

global.galaga2 = 20000

global.init2 = "A.A"

global.galaga3 = 20000

global.init3 = "M.M"

global.galaga4 = 20000

global.init4 = "C.C"

global.galaga5 = 20000

global.init5 = "O.O"

}



global.disp = global.galaga1

