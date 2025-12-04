/// @file ParticleManager.gml
/// @description Centralized particle system controller for all game effects
/// Manages particle types, emitters, and visual effects

function ParticleManager() constructor {
    // Particle system handle
    particle_system = part_system_create();
    part_system_depth(particle_system, -100); // Draw on top

    // Particle type handles
    particle_types = {
        explosion_spark: -1,
        explosion_debris: -1,
        explosion_smoke: -1,
        hit_flash: -1,
        engine_trail: -1,
        missile_trail: -1,
        warp_particle: -1,
        star_dust: -1
    };
	
    // Emitter pool (reusable emitters)
    emitter_pool = [];
    for (var i = 0; i < 20; i++) {
        array_push(emitter_pool, part_emitter_create(particle_system));
    }
    emitter_index = 0;

    // Configuration loaded from JSON
    config = {
        enabled: true,
        quality: "high", // high, medium, low
        max_particles: 1000
    };
	
	/// @function initialize
    /// @description Initialize all particle types with visual properties
    static initialize = function() {
        _create_explosion_particles();
        _create_trail_particles();
        _create_impact_particles();
        _create_ambient_particles();
    };
	
	/// @function _create_explosion_particles
    /// @description Creates particle types for explosion effects
    static _create_explosion_particles = function() {
        // EXPLOSION SPARKS - Bright, fast-moving particles
        particle_types.explosion_spark = part_type_create();
        part_type_shape(particle_types.explosion_spark, pt_shape_pixel);
        part_type_size(particle_types.explosion_spark, 0.05, 0.15, -0.002, 0);
        part_type_color3(particle_types.explosion_spark, c_white, c_yellow, c_orange);
        part_type_alpha3(particle_types.explosion_spark, 1, 0.8, 0);
        part_type_speed(particle_types.explosion_spark, 2, 6, -0.15, 0);
        part_type_direction(particle_types.explosion_spark, 0, 360, 0, 5);
        part_type_life(particle_types.explosion_spark, 15, 30);
        part_type_blend(particle_types.explosion_spark, true); // Additive blend

        // EXPLOSION DEBRIS - Solid chunks
        particle_types.explosion_debris = part_type_create();
        part_type_shape(particle_types.explosion_debris, pt_shape_square);
        part_type_size(particle_types.explosion_debris, 0.08, 0.20, -0.003, 0);
        part_type_color2(particle_types.explosion_debris, c_gray, c_dkgray);
        part_type_alpha2(particle_types.explosion_debris, 0.9, 0);
        part_type_speed(particle_types.explosion_debris, 1, 4, -0.08, 0);
        part_type_direction(particle_types.explosion_debris, 0, 360, 0, 10);
        part_type_gravity(particle_types.explosion_debris, 0.08, 270);
        part_type_life(particle_types.explosion_debris, 20, 45);

        // EXPLOSION SMOKE - Expanding cloud
        particle_types.explosion_smoke = part_type_create();
        part_type_shape(particle_types.explosion_smoke, pt_shape_cloud);
        part_type_size(particle_types.explosion_smoke, 0.10, 0.25, 0.01, 0);
        part_type_color2(particle_types.explosion_smoke, c_gray, c_dkgray);
        part_type_alpha3(particle_types.explosion_smoke, 0, 0.6, 0);
        part_type_speed(particle_types.explosion_smoke, 0.5, 1.5, -0.02, 0);
        part_type_direction(particle_types.explosion_smoke, 0, 360, 0, 2);
        part_type_life(particle_types.explosion_smoke, 30, 60);
    };
	
	    /// @function _create_trail_particles
    /// @description Creates particle types for motion trails
    static _create_trail_particles = function() {
        // ENGINE TRAIL - Thruster exhaust
        particle_types.engine_trail = part_type_create();
        part_type_shape(particle_types.engine_trail, pt_shape_pixel);
        part_type_size(particle_types.engine_trail, 0.08, 0.12, -0.003, 0);
        part_type_color3(particle_types.engine_trail, c_white, c_aqua, c_blue);
        part_type_alpha3(particle_types.engine_trail, 0.8, 0.4, 0);
        part_type_speed(particle_types.engine_trail, 0.5, 1.5, -0.05, 0);
        part_type_direction(particle_types.engine_trail, 90, 90, 0, 3); // Downward
        part_type_life(particle_types.engine_trail, 10, 25);
        part_type_blend(particle_types.engine_trail, true);

        // MISSILE TRAIL - Vapor trail
        particle_types.missile_trail = part_type_create();
        part_type_shape(particle_types.missile_trail, pt_shape_pixel);
        part_type_size(particle_types.missile_trail, 0.06, 0.10, -0.002, 0);
        part_type_color2(particle_types.missile_trail, c_white, c_ltgray);
        part_type_alpha3(particle_types.missile_trail, 0.7, 0.3, 0);
        part_type_speed(particle_types.missile_trail, 0.2, 0.8, -0.03, 0);
        part_type_direction(particle_types.missile_trail, 90, 90, 0, 2);
        part_type_life(particle_types.missile_trail, 15, 30);
    };
	
    /// @function _create_impact_particles
    /// @description Creates particle types for collision impacts
    static _create_impact_particles = function() {
        // HIT FLASH - Bright impact burst
        particle_types.hit_flash = part_type_create();
        part_type_shape(particle_types.hit_flash, pt_shape_star);
        part_type_size(particle_types.hit_flash, 0.20, 0.35, -0.015, 0);
        part_type_color2(particle_types.hit_flash, c_white, c_yellow);
        part_type_alpha2(particle_types.hit_flash, 1, 0);
        part_type_speed(particle_types.hit_flash, 1, 2, -0.1, 0);
        part_type_direction(particle_types.hit_flash, 0, 360, 0, 0);
        part_type_life(particle_types.hit_flash, 8, 15);
        part_type_blend(particle_types.hit_flash, true);
    };
	
    /// @function _create_ambient_particles
    /// @description Creates ambient particle effects
    static _create_ambient_particles = function() {
        // WARP PARTICLES - Hyperspace effect
        particle_types.warp_particle = part_type_create();
        part_type_shape(particle_types.warp_particle, pt_shape_line);
        part_type_size(particle_types.warp_particle, 0.5, 1.5, 0, 0);
        part_type_color3(particle_types.warp_particle, c_white, c_aqua, c_blue);
        part_type_alpha3(particle_types.warp_particle, 0, 1, 0);
        part_type_speed(particle_types.warp_particle, 8, 15, 0, 0);
        part_type_direction(particle_types.warp_particle, 270, 270, 0, 0);
        part_type_life(particle_types.warp_particle, 20, 40);
        part_type_blend(particle_types.warp_particle, true);
        part_type_orientation(particle_types.warp_particle, 0, 0, 0, 0, false);

        // STAR DUST - Space debris
        particle_types.star_dust = part_type_create();
        part_type_shape(particle_types.star_dust, pt_shape_pixel);
        part_type_size(particle_types.star_dust, 0.03, 0.08, 0, 0);
        part_type_color1(particle_types.star_dust, c_white);
        part_type_alpha3(particle_types.star_dust, 0, 0.8, 0);
        part_type_speed(particle_types.star_dust, 0.5, 2, 0, 0);
        part_type_direction(particle_types.star_dust, 0, 360, 0, 0);
        part_type_life(particle_types.star_dust, 60, 120);
    };	
	
    /// @function get_emitter
    /// @description Gets next available emitter from pool (round-robin)
    /// @return {Id.PartEmitter} Emitter handle
    static get_emitter = function() {
        var emitter = emitter_pool[emitter_index];
        emitter_index = (emitter_index + 1) % array_length(emitter_pool);
        return emitter;
    };
	
    /// @function burst_explosion
    /// @description Creates explosion particle burst at position
    /// @param {Real} _x X position
    /// @param {Real} _y Y position
    /// @param {Real} _intensity Intensity multiplier (0.5 to 2.0)
    static burst_explosion = function(_x, _y, _intensity = 1.0) {
        if (!config.enabled) return;

        var emitter = get_emitter();
        part_emitter_region(particle_system, emitter, _x-2, _x+2, _y-2, _y+2,
            ps_shape_ellipse, ps_distr_gaussian);

        // Scale particle count by intensity and quality
        var quality_multiplier = (config.quality == "high") ? 1.0 :
                                 ((config.quality == "medium") ? 0.6 : 0.3);

        var spark_count = round(20 * _intensity * quality_multiplier);
        var debris_count = round(8 * _intensity * quality_multiplier);
        var smoke_count = round(5 * _intensity * quality_multiplier);

        part_emitter_burst(particle_system, emitter, particle_types.explosion_spark, spark_count);
        part_emitter_burst(particle_system, emitter, particle_types.explosion_debris, debris_count);
        part_emitter_burst(particle_system, emitter, particle_types.explosion_smoke, smoke_count);

        // Clear emitter region
        part_emitter_clear(particle_system, emitter);
    };
	
    /// @function burst_hit_impact
    /// @description Creates hit impact effect at collision point
    /// @param {Real} _x X position
    /// @param {Real} _y Y position
    static burst_hit_impact = function(_x, _y) {
        if (!config.enabled) return;

        var emitter = get_emitter();
        part_emitter_region(particle_system, emitter, _x-1, _x+1, _y-1, _y+1,
            ps_shape_ellipse, ps_distr_gaussian);

        var count = (config.quality == "high") ? 8 : 4;
        part_emitter_burst(particle_system, emitter, particle_types.hit_flash, count);
        part_emitter_clear(particle_system, emitter);
    };
	

    /// @function stream_engine_trail
    /// @description Creates continuous engine trail emission
    /// @param {Real} _x X position
    /// @param {Real} _y Y position
    /// @return {Id.PartEmitter} Emitter handle (store and call stop_stream later)
    static stream_engine_trail = function(_x, _y) {
        if (!config.enabled) return -1;

        var emitter = get_emitter();
        part_emitter_region(particle_system, emitter, _x-2, _x+2, _y-1, _y+1,
            ps_shape_rectangle, ps_distr_linear);

        var rate = (config.quality == "high") ? -4 : -8; // Negative = per-frame emission
        part_emitter_stream(particle_system, emitter, particle_types.engine_trail, rate);

        return emitter;
    };

    /// @function stream_missile_trail
    /// @description Creates continuous missile trail emission
    /// @param {Real} _x X position
    /// @param {Real} _y Y position
    /// @return {Id.PartEmitter} Emitter handle
    static stream_missile_trail = function(_x, _y) {
        if (!config.enabled) return -1;

        var emitter = get_emitter();
        part_emitter_region(particle_system, emitter, _x-1, _x+1, _y, _y+2,
            ps_shape_rectangle, ps_distr_linear);

        var rate = (config.quality == "high") ? -3 : -6;
        part_emitter_stream(particle_system, emitter, particle_types.missile_trail, rate);

        return emitter;
    };

    /// @function stop_stream
    /// @description Stops a streaming emitter
    /// @param {Id.PartEmitter} _emitter Emitter handle
    static stop_stream = function(_emitter) {
        if (_emitter == -1) return;
        part_emitter_stream(particle_system, _emitter, particle_types.engine_trail, 0);
        part_emitter_clear(particle_system, _emitter);
    };
	
    /// @function update_emitter_position
    /// @description Updates streaming emitter position (call every frame)
    /// @param {Id.PartEmitter} _emitter Emitter handle
    /// @param {Real} _x New X position
    /// @param {Real} _y New Y position
    static update_emitter_position = function(_emitter, _x, _y) {
        if (_emitter == -1) return;
        part_emitter_region(particle_system, _emitter, _x-2, _x+2, _y-1, _y+1,
            ps_shape_rectangle, ps_distr_linear);
    };

    /// @function burst_warp_effect
    /// @description Creates warp speed entry/exit effect
    /// @param {Real} _x X position
    /// @param {Real} _y Y position
    static burst_warp_effect = function(_x, _y) {
        if (!config.enabled) return;

        var emitter = get_emitter();
        part_emitter_region(particle_system, emitter, _x-20, _x+20, _y-20, _y+20,
            ps_shape_ellipse, ps_distr_linear);

        var count = (config.quality == "high") ? 40 : 20;
        part_emitter_burst(particle_system, emitter, particle_types.warp_particle, count);
        part_emitter_clear(particle_system, emitter);
    };
	
    /// @function set_quality
    /// @description Changes particle quality level
    /// @param {String} _quality "high", "medium", or "low"
    static set_quality = function(_quality) {
        config.quality = _quality;

        // Adjust max particle count
        if (_quality == "low") {
            part_system_automatic_update(particle_system, false);
            part_system_automatic_draw(particle_system, false);
        } else {
            part_system_automatic_update(particle_system, true);
            part_system_automatic_draw(particle_system, true);
        }
    };

    /// @function cleanup
    /// @description Cleans up particle system
    static cleanup = function() {
        part_system_destroy(particle_system);
    };

    // Initialize on creation
    initialize();
}
	

	