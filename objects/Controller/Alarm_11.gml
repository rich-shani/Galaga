if global.startMode == StartMode.SHOW_PLAYER1{global.startMode = StartMode.SHOW_STAGE1; alarm[10] = 1; alarm[11] = 90; nextlevel = 1; exit};

if global.startMode == StartMode.SHOW_STAGE1{global.startMode = StartMode.GAME_STARTED; alarm[11] = 90; exit};

if global.startMode == StartMode.GAME_STARTED{global.startMode = StartMode.INITIALIZE; alarm[10] = 1; nextlevel = 2; exit};


