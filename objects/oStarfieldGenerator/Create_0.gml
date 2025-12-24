// ========================================================================
// oStarfieldGenerator - Create Event
// ========================================================================
/// @description STARFIELD GENERATOR INITIALIZATION
/// Initializes the particle system that creates the scrolling starfield background effect.
///
/// This object creates a continuous stream of particles (stars) that scroll downward
/// across the screen, providing the classic space-shooter aesthetic. The particle system
/// uses GameMaker's built-in particle system for efficient rendering of many small objects.
///
/// === PARTICLE SYSTEM ARCHITECTURE ===
/// - Particle System (ps): Container for all particles and emitters
/// - Emitter (pe): Defines the spawn region and distribution pattern
/// - Particle Type (pt): Defines the appearance and behavior of individual stars
///
/// === INSTANCE VARIABLES CREATED ===
/// @var {int} ps - Particle system ID (container for all star particles)
/// @var {int} pe - Particle emitter ID (spawn region for new stars)
/// @var {int} pt - Particle type ID (defines star appearance and behavior)
///
/// === VISUAL DESIGN ===
/// - Stars appear as small green spheres (can be toggled to white via C key)
/// - Stars spawn from top of viewport and scroll downward (270 degrees)
/// - Size and speed vary randomly for natural starfield appearance
/// - Stars have a fixed lifetime to ensure they disappear after scrolling off-screen
///
/// @related Alarm_0.gml - Handles pause state synchronization
/// @related Alarm_1.gml - Sets color mode (green stars)
/// @related Alarm_2.gml - Sets black and white mode (white stars)
/// @related Other_4.gml - Pre-generates stars to fill screen immediately
/// @related Other_5.gml - Cleanup (destroys particle system on room exit)
/// @related KeyPress_67.gml - Toggles between color and B&W modes (C key)

// === VIEWPORT DIMENSION CALCULATION ===
// Get the width of the current viewport to size the emitter region
// This ensures stars spawn across the entire visible width of the screen
var viewport_width = view_get_wport(view_current);

// === PARTICLE SYSTEM CREATION ===
// Create the main particle system container
// All particles (stars) will be managed by this system
ps = part_system_create();

// Set the rendering depth to match this object's depth
// Ensures stars render at the correct layer relative to other game objects
part_system_depth(ps, depth);

// === EMITTER CREATION AND CONFIGURATION ===
// Create an emitter that spawns particles continuously
pe = part_emitter_create(ps);

// Configure emitter region:
// - X: 0 to viewport_width (spawns across entire screen width)
// - Y: -16 to -128 (spawns above visible area, allowing stars to scroll in)
// - Shape: Rectangle (linear distribution across width)
// - Distribution: Linear (even distribution across spawn region)
// Negative Y values ensure stars spawn off-screen and scroll into view
part_emitter_region(ps, pe, 0, viewport_width, -16, -128, ps_shape_rectangle, ps_distr_linear);

// === PARTICLE TYPE CREATION AND CONFIGURATION ===
// Create a particle type that defines how individual stars look and behave
pt = part_type_create();

// Set particle shape to sphere (renders as small circular dots)
part_type_shape(pt, pt_shape_sphere);

// === PARTICLE COLOR ===
// Set particle color to green RGB values (0,255,0) with full opacity
// Color range: (min_red, min_green, min_blue, max_red, max_green, max_blue)
// All values are 0,255,0,255,0,255 = solid green with no variation
// Note: Alpha was commented out (would set 70% opacity if enabled)
//part_type_alpha1(pt, 0.7);					// 70% alpha mix (currently disabled)
part_type_color_rgb(pt, 0, 255, 0, 255, 0, 255);

// === PARTICLE DIRECTION ===
// Set movement direction to 270 degrees (straight down)
// Direction range: (min_degrees, max_degrees, min_wiggle, max_wiggle)
// 270 degrees = straight downward movement (classic vertical scrolling)
part_type_direction(pt, 270, 270, 0, 0);	// 270 degrees = straight down

// === PARTICLE LIFETIME ===
// Set particle lifetime to 800 frames
// Lifetime range: (min_life, max_life) in frames
// At 60 FPS: 800 frames ≈ 13.3 seconds
// Ensures stars disappear after scrolling off-screen
part_type_life(pt, 800, 800);				// 800 frames ≈ 13.3 seconds at 60 FPS

// === PARTICLE SPEED ===
// Set speed range for natural variation
// Speed range: (min_speed, max_speed, min_wiggle, max_wiggle)
// Stars move at 0.4 to 3.0 pixels per frame (varies per star)
// Creates parallax-like effect where some stars appear to move faster
part_type_speed(pt, 0.4, 3, 0, 0);			// Speed range: 0.4 to 3.0 pixels/frame

// === PARTICLE SIZE ===
// Set size range for visual variety
// Size range: (min_size, max_size, min_wiggle, max_wiggle)
// Stars range from 0.05 to 0.2 scale (creates near/far appearance)
// Larger stars appear closer, smaller stars appear farther away
part_type_size(pt, 0.05, 0.2, 0, 0);		// Size variance: 0.05 to 0.2 scale

// === EMITTER STREAM ACTIVATION ===
// Start continuously emitting particles from the emitter
// Parameters: (particle_system, emitter, particle_type, emit_count)
// emit_count = -10: Emits 10 particles per second (negative = rate, positive = count)
// Creates a continuous stream of stars scrolling down the screen
part_emitter_stream(ps, pe, pt, -10);		// Emit 10 particles per second

