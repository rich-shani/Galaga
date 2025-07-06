dive = 0;

uprohib = 0;

hit = 0;

loop = 0;

dive2 = 0;

spd = 3;

open = 0;

if open = 0{enter = 0; created = 1}else{enter = 1; created = 0}

check = 0;

add = 0;

if global.fighterstore = 0{}else{

    path_start(Ent1e1Flip,6,0,0); direction = 270

    Controller.count1 = Controller.count1 - 1; enter = 1; dive = 1; goto = 0;

timey = 90; ///time attempt fix

if global.fastenter = 1{fasty = 50; timey = 63;};

}




