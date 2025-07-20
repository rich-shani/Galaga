// In obj_overlay Post-Draw Event
var overlay_w = 1579;
var overlay_h = 888;
var overlay_x = (1579 - overlay_w) / 2;
var overlay_y = (888 - overlay_h) / 2;

draw_sprite_stretched(decal, 0, overlay_x, overlay_y, overlay_w, overlay_h);