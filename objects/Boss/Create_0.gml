
dive = 0;

uprohib = 0;

hit = 0;

beam = 0;

beamsignal = 0;

loop = 0;

anim = 0;

dive2 = 0;

spd = 3;

intesc = 0;

ret = 0;

follow = 0;

carrying = 0;

enter = 1;

dive = 1;
rogue = 0;
goto = 0;
check = 0;
open = 0;

dive = 1;

targx = 0;
targy = 0;

if global.challcount > 0{

if oGameManager.rogueyes = 0{

if global.pattern = 0{

    path_start(Ent1e2,6*global.scale,0,0);

}

if global.pattern = 1{

    path_start(Ent2e2,6*global.scale,0,0);

}

if global.pattern = 2{

    path_start(Ent1e2,6*global.scale,0,0);

}

}

else{

if global.pattern = 0{

    path_start(Rogue1e2,6*global.scale,0,0);

}

if global.pattern = 1{

    path_start(Rogue2e2,6*global.scale,0,0);

}

if global.pattern = 2{

    path_start(Rogue1e2,6*global.scale,0,0);

}

}
 
///

if oGameManager.rogueyes = 1{rogue = 1; oGameManager.rogueyes = 0};

if rogue = 0{if global.wave = 1 or global.wave = 2{alarm[5] = 75; if global.fastenter = 1{alarm[5] = 63}} else{alarm[5] = 10};}

        if global.wave = 1{

            if rogue = 0{

            oGameManager.count1 = oGameManager.count1 - 1; 

            if oGameManager.count1 = 3{numb = 9};

            if oGameManager.count1 = 2{numb = 11};

            if oGameManager.count1 = 1{numb = 13};

            if oGameManager.count1 = 0{numb = 15};

            }

            else{

            oGameManager.rogue1 = oGameManager.rogue1 - 1

            }

        }

///

if global.fastenter = 1{fasty = 50};

}

else{

    oGameManager.count += 1

    if x = path_get_x(oGameManager.path1,0) and y = path_get_y(oGameManager.path1,0){path_start(oGameManager.path1,6*global.scale,0,0)}

    if x = path_get_x(oGameManager.path1flip,0) and y = path_get_y(oGameManager.path1flip,0){path_start(oGameManager.path1flip,6*global.scale,0,0)}

    if x = path_get_x(oGameManager.path2,0) and y = path_get_y(oGameManager.path2,0){path_start(oGameManager.path2,6*global.scale,0,0)}

    if x = path_get_x(oGameManager.path2flip,0) and y = path_get_y(oGameManager.path2flip,0){path_start(oGameManager.path2flip,6*global.scale,0,0)}

}


