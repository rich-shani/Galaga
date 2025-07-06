if start = 1{start = 2; alarm[10] = 1; alarm[11] = 90; nextlevel = 1; exit};
if start = 2{start = 3; alarm[11] = 90; Stars.alarm[0] = 120; exit};
if start = 3{start = 0; open = 1; nextlevel = 2; alarm[10] = 1};

