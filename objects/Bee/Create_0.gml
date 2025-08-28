// Inherit the parent event
event_inherited();

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

if Controller.rogueyes = 0{

if global.pattern = 0{

    if global.wave < 4{path_start(Ent1e1,6,0,0)} else{path_start(Ent1e1Flip,6,0,0)}};

if global.pattern = 1{

    if global.wave = 0{path_start(Ent1e1Flip,6,0,0)}; 

    if global.wave = 3{if Controller.alt = 0{path_start(Ent1e1,6,0,0)} else{path_start(Ent2e1,6,0,0)}}

    if global.wave = 4{if Controller.alt = 0{path_start(Ent1e1Flip,6,0,0)} else{path_start(Ent2e1Flip,6,0,0)}}

}

if global.pattern = 2{

    if global.wave = 0{path_start(Ent1e1,6,0,0)} else{

    if Controller.alt = 0{path_start(Ent1e1,6,0,0)}else{path_start(Ent1e1Flip,6,0,0)}}

}

}

else{

if global.pattern = 0{

    if global.wave < 4{path_start(Rogue1e1,6,0,0)} else{path_start(Rogue1e1Flip,6,0,0)}};

if global.pattern = 1{

    if global.wave = 0{path_start(Rogue1e1Flip,6,0,0)}; 

    if global.wave = 3{if Controller.alt = 0{path_start(Rogue1e1,6,0,0)} else{path_start(Rogue2e1,6,0,0)}}

    if global.wave = 4{if Controller.alt = 0{path_start(Rogue1e1Flip,6,0,0)} else{path_start(Rogue2e1Flip,6,0,0)}}

}

if global.pattern = 2{

    if global.wave = 0{path_start(Rogue1e1,6,0,0)}else{

    if Controller.alt = 0{path_start(Rogue1e1,6,0,0)}else{path_start(Rogue1e1Flip,6,0,0)}}

}

}

///

if Controller.rogueyes = 1{rogue = 1; Controller.rogueyes = 0};

if rogue = 0{if global.wave = 1 or global.wave = 2{alarm[5] = 75; if global.fastenter = 1{alarm[5] = 63}} else{alarm[5] = 10};}

        if global.wave = 0{

            if rogue = 0{

            Controller.count1 = Controller.count1 - 1;

            if Controller.count1 = 3{numb = 1};

            if Controller.count1 = 2{numb = 3};

            if Controller.count1 = 1{numb = 5};

            if Controller.count1 = 0{numb = 7};

            }

            else{

            Controller.rogue1 = Controller.rogue1 - 1

            }

        }

        if global.wave = 3{

            if Controller.alt = 0{

                if rogue = 0{

                Controller.count1 = Controller.count1 - 1; 

                if Controller.count1 = 3{numb = 25};

                if Controller.count1 = 2{numb = 27};

                if Controller.count1 = 1{numb = 29};

                if Controller.count1 = 0{numb = 31};

                }

                else{

                Controller.rogue1 = Controller.rogue1 - 1

                }

            }

            else{

                if rogue = 0{

                Controller.count2 = Controller.count2 - 1; 

                if Controller.count2 = 3{numb = 26};

                if Controller.count2 = 2{numb = 28};

                if Controller.count2 = 1{numb = 30};

                if Controller.count2 = 0{numb = 32};

                }

                else{

                Controller.rogue2 = Controller.rogue2 - 1

                }

            }

        }

        if global.wave = 4{

            if Controller.alt = 0{

                if rogue = 0{

                Controller.count1 = Controller.count1 - 1; 

                if Controller.count1 = 3{numb = 33};

                if Controller.count1 = 2{numb = 35};

                if Controller.count1 = 1{numb = 37};

                if Controller.count1 = 0{numb = 39};

                }

                else{

                Controller.rogue1 = Controller.rogue1 - 1

                }

            }

            else{

                if rogue = 0{

                Controller.count2 = Controller.count2 - 1; 

                if Controller.count2 = 3{numb = 34};

                if Controller.count2 = 2{numb = 36};

                if Controller.count2 = 1{numb = 38};

                if Controller.count2 = 0{numb = 40};

                }

                else{

                Controller.rogue2 = Controller.rogue2 - 1

                }

            }

        }

///

if global.fastenter = 1{fasty = 50};

}

else{

    Controller.count += 1

    if x = path_get_x(Controller.path1,0) and y = path_get_y(Controller.path1,0){path_start(Controller.path1,6,0,0)}

    if x = path_get_x(Controller.path1flip,0) and y = path_get_y(Controller.path1flip,0){path_start(Controller.path1flip,6,0,0)}

    if x = path_get_x(Controller.path2,0) and y = path_get_y(Controller.path2,0){path_start(Controller.path2,6,0,0)}

    if x = path_get_x(Controller.path2flip,0) and y = path_get_y(Controller.path2flip,0){path_start(Controller.path2flip,6,0,0)}

    if global.chall = 3{

        switch Controller.count{

        case 2:case 4:case 6:case 8:

        if global.wave = 4{path_end(); path_start(Controller.path1,6,0,0)};

        if global.wave = 0 or global.wave = 3{path_end(); path_start(Controller.path1flip,6,0,0)}; break;

        }   

    }

}

 
