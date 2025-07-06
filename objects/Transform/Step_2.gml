/// @description charger
if global.transnum < 3{
    depth = -101;
    if y < 176 + 160{}
    else{
        if y < 480{}
            else{if loop = 0{
                loop = 1;
                if global.transside = 1{path_start(Transform2,spd,0,false)}
                else{path_start(Transform2Flip,spd,0,false)}
            }
        }
    } 
}
if y > 592+32+32{
    instance_destroy();
}

