if global.transnum = 1{
if round(direction/15) & 1 = 0{  //odd
draw_sprite_ext(spr_ship,14,x,y,1,1,direction-90,c_white,1);}
else{  //even
draw_sprite_ext(spr_ship,15,x,y,1,1,direction-90,c_white,1);}
}
if global.transnum = 2{
draw_sprite_ext(spr_ship,16,x,y,1,1,direction-90,c_white,1);}
if global.transnum = 3{
draw_sprite_ext(spr_ship,17,x,y,1,1,direction-90,c_white,1);}

