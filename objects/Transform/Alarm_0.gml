speed = 0;

if count = 1{

if global.transside = 1{path_start(Transform4,spd,0,false)}

else{path_start(Transform4Flip,spd,0,false)}
 
}

if count = 2{

if global.transside = 1{path_start(Transform3,spd,0,false)}

else{path_start(Transform3Flip,spd,0,false)}
 
}


