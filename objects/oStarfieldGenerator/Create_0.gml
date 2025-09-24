
// get the viewport width 
var viewport_width = view_get_wport(view_current);

// particle system
ps = part_system_create();
part_system_depth(ps, depth);

//emitter
pe = part_emitter_create(ps);
part_emitter_region(ps, pe, 0, viewport_width, -16, -128, ps_shape_rectangle, ps_distr_linear);

// particle
pt = part_type_create();
//part_type_sprite(pt, sParticle, false, false, true);
part_type_shape(pt, pt_shape_sphere);
//part_type_alpha1(pt, 0.7);					// 70% alpha mix
part_type_color_rgb(pt,0,255,0,255,0,255);
part_type_direction(pt, 270, 270, 0, 0);	// 270 degree is straight down
part_type_life(pt, 800, 800);				/// 500 frames, less < 10 secs
part_type_speed(pt, 0.4, 3, 0, 0);			// speed range
part_type_size(pt, 0.05, 0.2, 0, 0);			// size variance

part_emitter_stream(ps, pe, pt, -10);		// random effect

