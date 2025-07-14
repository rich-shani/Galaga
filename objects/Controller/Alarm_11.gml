if start == StartMode.SHOW_PLAYER1{start = StartMode.SHOW_STAGE1; alarm[10] = 1; alarm[11] = 90; nextlevel = 1; exit};

if start == StartMode.SHOW_STAGE1{start = StartMode.GAME_STARTED; alarm[11] = 90; Stars.alarm[0] = 120; exit};

if start == StartMode.GAME_STARTED{start = StartMode.INITIALIZE; alarm[10] = 1; nextlevel = 2; exit};


