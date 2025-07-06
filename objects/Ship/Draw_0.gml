if Controller.attshot = 1{draw_sprite_ext(spr_shot,0,Controller.attshotx,Controller.attshoty,1,1,shot1dir,c_white,1)};

if Controller.gameMode == GameMode.GAME_MODE or (Controller.att > 5 and Controller.att < 18){

if Controller.start = 0 or Controller.start = 3{

draw_sprite_ext(spr_shot,0,shot1x,shot1y,1,1,shot1dir,c_white,1);

draw_sprite_ext(spr_shot,0,shot2x,shot2y,1,1,shot2dir,c_white,1);

if dub1 = 1{draw_sprite_ext(spr_shot,0,shot1x+28,shot1y,1,1,shot1dir,c_white,1)};

if dub2 = 1{draw_sprite_ext(spr_shot,0,shot2x+28,shot2y,1,1,shot2dir,c_white,1)};

if deadanim2 > 0 and deadanim2 < 4{draw_sprite(spr_explode,floor(deadanim2 + 5),secondx,528);}

if dead = 0 or dead = 2{draw_sprite(spr_ship,0,x,y); if double = 1{draw_sprite(spr_ship,0,x+28,y);}}

if dead = 1 and caught = 0 and y = 528{if deadanim < 4{draw_sprite(spr_explode,floor(deadanim + 5),x,y);}}

if dead = 1 and caught = 1 or caught = 2{

    if alarm[2] = -1 and spinanim = 0{}

    else{draw_sprite_ext(spr_ship,0,x,y,1,1,spinanim,c_white,1)}

}

if regain = 1{draw_sprite_ext(spr_ship,0,newshipx,newshipy,1,1,spinanim,c_white,1)}

}

}


