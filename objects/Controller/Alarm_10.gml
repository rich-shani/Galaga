if nextlevel = 1{

if Ship.regain = 1{alarm[10] = 1} else{

if instance_number(EnemyShot) > 0 or Ship.dead > 0{alarm[10] = 1} else{

stage = 1; results = 0;

global.lvl = global.lvl + 1;

script_execute(newlevel);



hund = floor((global.lvl + 0)/100);

ten = floor(((global.lvl + 0) - (hund*100))/10);

one = (global.lvl + 0) - ((hund*100) + (ten*10));



onerank = 0

tenrank = 0;

hundrank = 0;



if one = 1 or one = 5{onerank = onerank + 1};

if one = 2 or one = 6{onerank = onerank + 2};

if one = 3 or one = 7{onerank = onerank + 3};

if one = 4 or one = 8{onerank = onerank + 4};

if one = 9{onerank = onerank + 5};



if ten = 1 or ten = 2 or ten = 3 or ten = 5{tenrank = tenrank + 1};

if ten = 4 or ten = 6 or ten = 7 or ten = 8{tenrank = tenrank + 2};

if ten = 9{tenrank = tenrank + 3};



hundrank = (hund * 2);



rank = onerank + tenrank + hundrank;

tile_layer_delete(-10);

alarm[1] = 7;

}}

}

if nextlevel = 2{

stage = 0; alt = 0;

count1 = 0; count2 = 0; count = 0; shotcount = 0; shottotal = 0;

rogue1 = 0; rogue2 = 0;

global.wave = 0; script_execute(waverogue);

rogueyes = 0;

global.flip = 0;

global.breathing = 0;

global.breathe = 0;

exhale = 0;

global.transform = 0;

global.beamcheck = 0;

global.transcount = 0;

global.escortcount = 0;

nextlevel = 0; 

if global.challcount = 0 and start = 0{alarm[2] = 70};

if start = 0{global.open = 1};

if global.chall = 4{

    if path_get_x(path1,0) = 256{path_shift(path1,-64,0); path_shift(path1flip,-64,0)};

}

}


