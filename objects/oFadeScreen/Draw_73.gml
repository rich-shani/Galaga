// Put the FADE IN/OUT in the GUI End event
// ie post the draw GUI which displays the screen

// FADE
draw_set_alpha(alpha);
draw_set_color(c);

// draw a rectange OVER the splash screen image
// using the ALPHA to fade in/out
draw_rectangle(0, 0, w, h, 0);

// reset
draw_set_alpha(1);
draw_set_color(c_white);