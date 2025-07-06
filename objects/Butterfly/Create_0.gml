uprohib = 0;

escort = 0;

dir = 0;

dive2 = 0;

spd = 3;

trans = 0;

spit = 0;

add = 0;

enter = 1;

dive = 1;
rogue = 0;
goto = 0;
tim = 0;

breathex = 0;
breathey = 0;
targx = 0;
targy = 0;


if Controller.rogueyes = 0{

if global.pattern = 0{

    if global.wave = 0{path_start(Ent1e1Flip,6,0,0)}

    if global.wave = 1{path_start(Ent1e2,6,0,0)}

    if global.wave = 2{path_start(Ent1e2Flip,6,0,0)}

}

if global.pattern = 1{

    if global.wave = 0{path_start(Ent1e1,6,0,0)}

    if global.wave = 1{path_start(Ent2e2In,6,0,0)}

    if global.wave = 2{if Controller.alt = 0{path_start(Ent2e2Flip,6,0,0)} else{path_start(Ent2e2InFlip,6,0,0)}};

}

if global.pattern = 2{

    if global.wave = 0{path_start(Ent1e1Flip,6,0,0)}

    if global.wave = 1{path_start(Ent1e2Flip,6,0,0)}

    if global.wave = 2{if Controller.alt = 0{path_start(Ent1e2,6,0,0)}else{path_start(Ent1e2Flip,6,0,0)}}

}

}

else{

if global.pattern = 0{

    if global.wave = 0{path_start(Rogue1e1Flip,6,0,0)}

    if global.wave = 1{path_start(Rogue1e2,6,0,0)}

    if global.wave = 2{path_start(Rogue1e2Flip,6,0,0)}

}

if global.pattern = 1{

    if global.wave = 0{path_start(Rogue1e1,6,0,0)}

    if global.wave = 1{path_start(Rogue2e2In,6,0,0)}

    if global.wave = 2{if Controller.alt = 0{path_start(Rogue2e2Flip,6,0,0)} else{path_start(Rogue2e2InFlip,6,0,0)}};

}

if global.pattern = 2{

    if global.wave = 0{path_start(Rogue1e1Flip,6,0,0)}

    if global.wave = 1{path_start(Rogue1e2Flip,6,0,0)}

    if global.wave = 2{if Controller.alt = 0{path_start(Rogue1e2,6,0,0)}else{path_start(Rogue1e2Flip,6,0,0)}}

}

}

timey = 90; ///time attempt fix

///

if Controller.rogueyes = 1{rogue = 1; Controller.rogueyes = 0};

if rogue = 0{if global.wave = 1 or global.wave = 2{alarm[5] = 75; if global.fastenter = 1{alarm[5] = 63}} else{alarm[5] = 10};}

        if global.wave = 0{

            if rogue = 0{

            Controller.count2 = Controller.count2 - 1; 

            if Controller.count2 = 3{numb = 2};

            if Controller.count2 = 2{numb = 4};

            if Controller.count2 = 1{numb = 6};

            if Controller.count2 = 0{numb = 8};

            }

            else{

            Controller.rogue2 = Controller.rogue2 - 1

            }

        }

        if global.wave = 1{

            if rogue = 0{

            Controller.count2 = Controller.count2 - 1; 

            if Controller.count2 = 3{numb = 10};

            if Controller.count2 = 2{numb = 12};

            if Controller.count2 = 1{numb = 14};

            if Controller.count2 = 0{numb = 16};

            }

            else{

            Controller.rogue2 = Controller.rogue2 - 1

            }

        }

        if global.wave = 2{

            if Controller.alt = 0{

                if rogue = 0{

                Controller.count1 = Controller.count1 - 1; 

                if Controller.count1 = 3{numb = 17};

                if Controller.count1 = 2{numb = 19};

                if Controller.count1 = 1{numb = 21};

                if Controller.count1 = 0{numb = 23};

                }

                else{

                Controller.rogue1 = Controller.rogue1 - 1

                }

            }

            else{

                if rogue = 0{

                Controller.count2 = Controller.count2 - 1; 

                if Controller.count2 = 3{numb = 18};

                if Controller.count2 = 2{numb = 20};

                if Controller.count2 = 1{numb = 22};

                if Controller.count2 = 0{numb = 24};

                }

                else{

                Controller.rogue2 = Controller.rogue2 - 1

                }

            }

        }

///

if global.fastenter = 1{fasty = 50; timey = 63;};


