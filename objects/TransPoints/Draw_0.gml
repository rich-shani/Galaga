if alarm[1] = -1{

if global.challcount > 0{

if global.transnum = 1{draw_sprite(spr_Galagapoints,3,x,y)}

if global.transnum = 2{draw_sprite(spr_Galagapoints,6,x,y)}

if global.transnum = 3{draw_sprite(spr_Galagapoints,7,x,y)}

}

else{

if global.lvl < 11{draw_sprite(spr_Galagapoints,3,x,y)}else{
if global.lvl < 19{draw_sprite(spr_Galagapoints,4,x,y)}else{
if global.lvl < 27{draw_sprite(spr_Galagapoints,6,x,y)}else{

draw_sprite(spr_Galagapoints,7,x,y)

}}}

}

}


