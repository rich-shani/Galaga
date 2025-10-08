

uprohib = 0;

dive2 = 0;

spd = 3;

trans = 0;

sprit = 0;
spit = 0;
add = 0;
satx = 0;
saty = 0;
rogue = 0;
goto = 0;

enter = 1;

dive = 1;

targx = 0;
targy = 0;

if global.challcount > 0{

if oGameManager.rogueyes = 0{

if global.pattern = 0{

    if global.wave < 4{path_start(Ent1e1,6*global.scale,0,0)} else{path_start(Ent1e1Flip,6*global.scale,0,0)}};

if global.pattern = 1{

    if global.wave = 0{path_start(Ent1e1Flip,6*global.scale,0,0)}; 

    if global.wave = 3{if oGameManager.alt = 0{path_start(Ent1e1,6*global.scale,0,0)} else{path_start(Ent2e1,6*global.scale,0,0)}}

    if global.wave = 4{if oGameManager.alt = 0{path_start(Ent1e1Flip,6*global.scale,0,0)} else{path_start(Ent2e1Flip,6*global.scale,0,0)}}

}

if global.pattern = 2{

    if global.wave = 0{path_start(Ent1e1,6*global.scale,0,0)} else{

    if oGameManager.alt = 0{path_start(Ent1e1,6*global.scale,0,0)}else{path_start(Ent1e1Flip,6*global.scale,0,0)}}

}

}

else{

if global.pattern = 0{

    if global.wave < 4{path_start(Rogue1e1,6*global.scale,0,0)} else{path_start(Rogue1e1Flip,6*global.scale,0,0)}};

if global.pattern = 1{

    if global.wave = 0{path_start(Rogue1e1Flip,6*global.scale,0,0)}; 

    if global.wave = 3{if oGameManager.alt = 0{path_start(Rogue1e1,6*global.scale,0,0)} else{path_start(Rogue2e1,6*global.scale,0,0)}}

    if global.wave = 4{if oGameManager.alt = 0{path_start(Rogue1e1Flip,6*global.scale,0,0)} else{path_start(Rogue2e1Flip,6*global.scale,0,0)}}

}

if global.pattern = 2{

    if global.wave = 0{path_start(Rogue1e1,6*global.scale,0,0)}else{

    if oGameManager.alt = 0{path_start(Rogue1e1,6*global.scale,0,0)}else{path_start(Rogue1e1Flip,6*global.scale,0,0)}}

}

}

///

if oGameManager.rogueyes = 1{rogue = 1; oGameManager.rogueyes = 0};

if rogue = 0{if global.wave = 1 or global.wave = 2{alarm[5] = 75; if global.fastenter = 1{alarm[5] = 63}} else{alarm[5] = 10};}

        if global.wave = 0{

            if rogue = 0{

            oGameManager.count1 = oGameManager.count1 - 1;

            if oGameManager.count1 = 3{numb = 1};

            if oGameManager.count1 = 2{numb = 3};

            if oGameManager.count1 = 1{numb = 5};

            if oGameManager.count1 = 0{numb = 7};

            }

            else{

            oGameManager.rogue1 = oGameManager.rogue1 - 1

            }

        }

        if global.wave = 3{

            if oGameManager.alt = 0{

                if rogue = 0{

                oGameManager.count1 = oGameManager.count1 - 1; 

                if oGameManager.count1 = 3{numb = 25};

                if oGameManager.count1 = 2{numb = 27};

                if oGameManager.count1 = 1{numb = 29};

                if oGameManager.count1 = 0{numb = 31};

                }

                else{

                oGameManager.rogue1 = oGameManager.rogue1 - 1

                }

            }

            else{

                if rogue = 0{

                oGameManager.count2 = oGameManager.count2 - 1; 

                if oGameManager.count2 = 3{numb = 26};

                if oGameManager.count2 = 2{numb = 28};

                if oGameManager.count2 = 1{numb = 30};

                if oGameManager.count2 = 0{numb = 32};

                }

                else{

                oGameManager.rogue2 = oGameManager.rogue2 - 1

                }

            }

        }

        if global.wave = 4{

            if oGameManager.alt = 0{

                if rogue = 0{

                oGameManager.count1 = oGameManager.count1 - 1; 

                if oGameManager.count1 = 3{numb = 33};

                if oGameManager.count1 = 2{numb = 35};

                if oGameManager.count1 = 1{numb = 37};

                if oGameManager.count1 = 0{numb = 39};

                }

                else{

                oGameManager.rogue1 = oGameManager.rogue1 - 1

                }

            }

            else{

                if rogue = 0{

                oGameManager.count2 = oGameManager.count2 - 1; 

                if oGameManager.count2 = 3{numb = 34};

                if oGameManager.count2 = 2{numb = 36};

                if oGameManager.count2 = 1{numb = 38};

                if oGameManager.count2 = 0{numb = 40};

                }

                else{

                oGameManager.rogue2 = oGameManager.rogue2 - 1

                }

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

    if global.chall = 3{

        switch oGameManager.count{

        case 2:case 4:case 6:case 8:

        if global.wave = 4{path_end(); path_start(oGameManager.path1,6*global.scale,0,0)};

        if global.wave = 0 or global.wave = 3{path_end(); path_start(oGameManager.path1flip,6*global.scale,0,0)}; break;

        }   

    }

}

 
