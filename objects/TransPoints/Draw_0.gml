if alarm[1] = -1 {

    if global.Game.Challenge.countdown > 0 {
        if global.Game.Enemy.transformNum = 1 {
            draw_sprite_ext(spr_Galagapoints,3,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        }
		else if global.Game.Enemy.transformNum = 2 {
            draw_sprite_ext(spr_Galagapoints,6,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        }
		else if global.Game.Enemy.transformNum = 3 {
            draw_sprite_ext(spr_Galagapoints,7,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        }
    }
    else {

        if global.Game.Level.current < 11 {
            draw_sprite_ext(spr_Galagapoints,3,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        } 
		else if global.Game.Level.current < 19 {
			draw_sprite_ext(spr_Galagapoints,4,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        } 
		else if global.Game.Level.current < 27 {
			draw_sprite_ext(spr_Galagapoints,6,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
        } 
		else {
			draw_sprite_ext(spr_Galagapoints,7,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		}
	}
}