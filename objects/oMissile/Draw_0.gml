draw_sprite_ext(sBlueLazer, 0, x, y, 1, 1, 90, c_white, 1);

// draw collision mask
draw_set_alpha(0.5);
draw_rectangle_colour(bbox_left,bbox_top,bbox_right,bbox_bottom,c_red,c_red,c_red,c_red,false);
draw_set_alpha(1);