/// @file ObjectPool.gml
/// @description Object pooling system for frequently created/destroyed objects
///              Eliminates garbage collection stutters from projectile creation
///
/// PERFORMANCE IMPACT:
///   - Eliminates frame stutters from GC spikes
///   - Reduces memory allocation overhead
///   - Faster object creation (reuse instead of construct)
///   - Expected improvement: Smoother frame times, 60 FPS lock
///
/// USAGE:
///   // Instead of:
///   instance_create_layer(x, y, "Projectiles", oEnemyShot);
///
///   // Use:
///   var shot = global.shot_pool.acquire(x, y);
///
/// Projectiles automatically return to pool when destroyed

/// @function ObjectPool
/// @description Constructor for generic object pool
/// @param {Asset.GMObject} _object_type Object type to pool
/// @param {String} _layer_name Layer to create objects on
/// @param {Real} _initial_size Initial pool size
/// @param {Real} _max_size Maximum pool size (prevents memory leaks)
/// @return {Struct} ObjectPool instance
function ObjectPool(_object_type, _layer_name, _initial_size, _max_size) constructor {
	object_type = _object_type;
	layer_name = _layer_name;
	max_size = _max_size;

	// Pool storage (ds_list of inactive instances)
	inactive_pool = ds_list_create();
	active_instances = ds_list_create();

	// Statistics
	stats = {
		total_created: 0,
		total_acquired: 0,
		total_released: 0,
		peak_active: 0,
		current_active: 0,
		current_pooled: 0
	};

	// Pre-create initial pool
	for (var i = 0; i < _initial_size; i++) {
		var instance = instance_create_layer(-1000, -1000, layer_name, object_type);
		instance.visible = false;
		instance.active = false;

		// Deactivate instance to prevent Step events from running
		instance_deactivate_object(instance);

		ds_list_add(inactive_pool, instance);
		stats.total_created++;
	}
	stats.current_pooled = _initial_size;

	show_debug_message("[ObjectPool] Initialized " + object_get_name(object_type) +
		" pool with " + string(_initial_size) + " objects");

	/// @function acquire
	/// @description Gets an object from the pool (or creates new if pool empty)
	/// @param {Real} _x X position
	/// @param {Real} _y Y position
	/// @return {Id.Instance} Instance ID
	static acquire = function(_x, _y) {
		var instance = noone;

		// Try to reuse from pool
		if (ds_list_size(inactive_pool) > 0) {
			instance = ds_list_find_value(inactive_pool, 0);
			ds_list_delete(inactive_pool, 0);
			stats.current_pooled--;
		}
		// Pool empty - create new (up to max size limit)
		else if (stats.total_created < max_size) {
			instance = instance_create_layer(_x, _y, layer_name, object_type);
			stats.total_created++;
		}
		// Pool exhausted - reuse oldest active (FIFO)
		else {
			log_error("Object pool exhausted for " + object_get_name(object_type),
				"ObjectPool.acquire", 1);
			instance = ds_list_find_value(active_instances, 0);
			ds_list_delete(active_instances, 0);
		}

		// Activate and position instance
	//	if (instance_exists(instance)) {
		if (instance != noone) {
			// CRITICAL: Reactivate BEFORE positioning to update collision mask properly
			instance_activate_object(instance);

			// Reset instance state first (call virtual reset method if exists)
			if (variable_instance_exists(instance, "poolReset")) {
				instance.poolReset();
			}

			// Now position and make visible
			instance.x = _x;
			instance.y = _y;
			instance.visible = true;
			instance.active = true;

			// Track as active
			ds_list_add(active_instances, instance);
			stats.total_acquired++;
			stats.current_active = ds_list_size(active_instances);
			if (stats.current_active > stats.peak_active) {
				stats.peak_active = stats.current_active;
			}
		}

		return instance;
	};

	/// @function release
	/// @description Returns an object to the pool
	/// @param {Id.Instance} _instance Instance to release
	/// @return {Bool} True if successfully released
	static release = function(_instance) {
		if (!instance_exists(_instance)) {
			return false;
		}

		// Remove from active list
		var index = ds_list_find_index(active_instances, _instance);
		if (index != -1) {
			ds_list_delete(active_instances, index);
		}

		// Reset physics/movement BEFORE deactivating
		if (variable_instance_exists(_instance, "speed")) {
			_instance.speed = 0;
		}
		if (variable_instance_exists(_instance, "direction")) {
			_instance.direction = 0;
		}
		if (variable_instance_exists(_instance, "image_index")) {
			_instance.image_index = 0;
		}

		// Move offscreen
		_instance.x = -1000;
		_instance.y = -1000;
		_instance.visible = false;
		_instance.active = false;

		// Deactivate instance (disables Step events) - MUST BE LAST
		instance_deactivate_object(_instance);

		// Return to pool
		ds_list_add(inactive_pool, _instance);
		stats.total_released++;
		stats.current_active = ds_list_size(active_instances);
		stats.current_pooled = ds_list_size(inactive_pool);

		return true;
	};

	/// @function clear
	/// @description Clears all pooled instances (call when changing rooms)
	/// @return {undefined}
	static clear = function() {
		// Destroy all inactive instances
		for (var i = 0; i < ds_list_size(inactive_pool); i++) {
			var instance = ds_list_find_value(inactive_pool, i);
			if (instance_exists(instance)) {
				// Reactivate before destroying (can't destroy deactivated instances)
				instance_activate_object(instance);
				instance_destroy(instance);
			}
		}
		ds_list_clear(inactive_pool);

		// Active instances will be destroyed by room change
		ds_list_clear(active_instances);

		// Reset stats
		stats.current_active = 0;
		stats.current_pooled = 0;

		show_debug_message("[ObjectPool] Cleared " + object_get_name(object_type) + " pool");
	};

	/// @function destroy
	/// @description Destroys the pool and all instances (call in game end)
	/// @return {undefined}
	static destroy = function() {
		clear();

		if (ds_exists(inactive_pool, ds_type_list)) {
			ds_list_destroy(inactive_pool);
		}
		if (ds_exists(active_instances, ds_type_list)) {
			ds_list_destroy(active_instances);
		}

		show_debug_message("[ObjectPool] Destroyed " + object_get_name(object_type) + " pool");
	};

	/// @function getStats
	/// @description Returns pool statistics
	/// @return {Struct} Statistics struct
	static getStats = function() {
		return stats;
	};

	/// @function logStats
	/// @description Logs pool statistics to console
	/// @return {undefined}
	static logStats = function() {
		show_debug_message("=== Object Pool Stats: " + object_get_name(object_type) + " ===");
		show_debug_message("Total Created: " + string(stats.total_created));
		show_debug_message("Total Acquired: " + string(stats.total_acquired));
		show_debug_message("Total Released: " + string(stats.total_released));
		show_debug_message("Peak Active: " + string(stats.peak_active));
		show_debug_message("Current Active: " + string(stats.current_active));
		show_debug_message("Current Pooled: " + string(stats.current_pooled));
		show_debug_message("Pool Utilization: " +
			string((stats.current_active / max_size) * 100) + "%");
		show_debug_message("========================================");
	};
}

/// Global object pools
global.shot_pool = undefined;       // Enemy shots (EnemyShot)
global.missile_pool = undefined;    // Player missiles (oMissile)
global.explosion_pool = undefined;  // Explosions (oExplosion)
global.explosion2_pool = undefined; // Explosions type 2 (oExplosion2)

/// @function init_object_pools
/// @description Initializes all object pools (call in oGameManager Create)
/// @return {undefined}
function init_object_pools() {
	show_debug_message("[ObjectPool] Initializing object pools...");

	// Enemy shot pool (max 8 on screen)
	global.shot_pool = new ObjectPool(oEnemyShot, "GameSprites", 8, 16);

	// Player missile pool (max 2-4 on screen)
	global.missile_pool = new ObjectPool(oMissile, "GameSprites", 4, 8);

	// Explosion pools (short-lived, higher turnover)
	global.explosion_pool = new ObjectPool(oExplosion, "GameSprites", 10, 20);
	global.explosion2_pool = new ObjectPool(oExplosion2, "GameSprites", 10, 20);

	show_debug_message("[ObjectPool] All pools initialized");
}

/// @function cleanup_object_pools
/// @description Destroys all object pools (call in game end)
/// @return {undefined}
function cleanup_object_pools() {
	if (global.shot_pool != undefined) {
		global.shot_pool.destroy();
	}
	if (global.missile_pool != undefined) {
		global.missile_pool.destroy();
	}
	if (global.explosion_pool != undefined) {
		global.explosion_pool.destroy();
	}
	if (global.explosion2_pool != undefined) {
		global.explosion2_pool.destroy();
	}

	show_debug_message("[ObjectPool] All pools destroyed");
}

/// @function log_all_pool_stats
/// @description Logs statistics for all pools
/// @return {undefined}
function log_all_pool_stats() {
	if (global.shot_pool != undefined) {
		global.shot_pool.logStats();
	}
	if (global.missile_pool != undefined) {
		global.missile_pool.logStats();
	}
	if (global.explosion_pool != undefined) {
		global.explosion_pool.logStats();
	}
	if (global.explosion2_pool != undefined) {
		global.explosion2_pool.logStats();
	}
}