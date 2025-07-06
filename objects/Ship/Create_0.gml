shot = 2;

shot1x = -32; shot1y = -32; shot1dir = 0; dub1 = 0;

shot2x = -32; shot2y = -32; shot2dir = 0; dub2 = 0;

depth = -150;

dead = 0;

deadanim = 0;

spinanim = 360;

#macro SHIP_MIN_X 16
#macro SHIP_MAX_X 432
#macro SHOT_OFFSCREEN -32
#macro SHOT_SPEED 12
#macro SHIP_SPACE 28

caught = 0;

grav = 0;

beamcheck = 0;

double = 0;

regain = 0;

newshipx = 0;

newshipy = 0;

moving = 0;

secondx = 0;

deadanim2 = 0;

gameover = 0;
 
skip = 0;

space = 11; ///shot collision

space2 = 13; ///enemy collision

block1 = 0;

block2 = 0;


// local ship state conditions 
ship_state = {
    is_alive: dead == 0 || dead == 2,
    is_caught: caught > 0,
    is_double: double == 1,
    is_moving: moving == 1,
    in_game: Controller.gameMode == GameMode.GAME_MODE,
    can_control: Controller.start == 0 || Controller.start == 3
};