if instance_number(Ship) == 1 and Ship.alarm[2] > -1{starsp = -4}else{starsp = starspeed};

if (instance_number(Ship) > 0) script_execute(starscript,starsp);

if alarm[0] < 1{}else{if global.lvl = 1{starspeed = starspeed + (1/60)} else{starspeed = starspeed + (2/360)}};