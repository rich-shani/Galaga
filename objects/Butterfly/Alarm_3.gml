if spit = 2{

path_speed = 3*global.scale;

}

else{

    spit = spit + 1;

    instance_create(x,y,Transform);

    if global.transnum < 3{

        path_speed = 0;

        if global.transnum = 1{alarm[3] = 11;}else{if instance_number(Transform)=1{alarm[3] = 9;}else{alarm[3] = 8;}}

    }

    else{

        alarm[3] = 7;

    }

}


