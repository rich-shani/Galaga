if dive = 0 and (alarm[0] = -1 or (direction > 80 and direction < 100)){

draw_sprite_ext(spr_ship,1,x,y,1,1,0,c_white,1);

}

else{

draw_sprite_ext(spr_ship,1,x,y,1,1,direction-90,c_white,1);

}


