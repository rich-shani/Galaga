alarm[1] = 10;

alarm[0] = 70;

if global.challcount > 0{

if global.transnum = 1{global.p1score += 1000};

if global.transnum = 2{global.p1score += 2000};

if global.transnum = 3{global.p1score += 3000};

}

else{

if global.lvl < 11{global.p1score += 1000}else{

if global.lvl < 19{global.p1score += 1500}else{

if global.lvl < 27{global.p1score += 2000}else{

global.p1score += 3000

}}}

}


