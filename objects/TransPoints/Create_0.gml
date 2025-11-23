alarm[1] = 10;

alarm[0] = 70;

if global.Game.Challenge.countdown > 0{

if global.Game.Enemy.transformNum = 1{global.Game.Player.score += 1000};

if global.Game.Enemy.transformNum = 2{global.Game.Player.score += 2000};

if global.Game.Enemy.transformNum = 3{global.Game.Player.score += 3000};

}

else{

if global.Game.Level.current < 11{global.Game.Player.score += 1000}else{

if global.Game.Level.current < 19{global.Game.Player.score += 1500}else{

if global.Game.Level.current < 27{global.Game.Player.score += 2000}else{

global.Game.Player.score += 3000

}}}

}


