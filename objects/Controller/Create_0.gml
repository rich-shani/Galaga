global.galaga1 = 0;
global.galaga2 = 0;
global.galaga3 = 0;
global.galaga4 = 0;
global.galaga5 = 0;
global.flip = 0;
global.p1lives = 3;
global.p1score = 0;
global.disp = 0;

global.init1 = "AA";
global.init2 = "BB";
global.init3 = "CC";
global.init4 = "DD";
global.init5 = "EE";
global.wave = 0;

enum GameMode {
	ATTRACT_MODE,
	INSTRUCTIONS,
	GAME_MODE
}

list = ds_list_create();

count = 0;
lifecount = 0;
loop = 0;

cyc = 0;
blip = 0;

attpause = 0;
attshot = 0;
attshoty = 0;
attshotx = 0;

// start in gameMode-mode
gameMode = GameMode.ATTRACT_MODE;

att = 0;

start = 0;
stage = 0;

blink = 0;

results = 0;
nextlevel = 0;

alarm[3] = 60;

direction = 90;

exhale = 0;
skip = 0;

sound_stop_all();

fire = 0; hits = 0;

firstlife = 20000;

additional = 70000;

cycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."



depth = -500;

global.open = 0;



alt = 0;

count1 = 0; count2 = 0;

rogue1 = 0; rogue2 = 0;

rogueyes = 0;



hund = 0;

ten = 0;

one = 0;

onerank = 0;

tenrank = 0;

hundrank = 0;


