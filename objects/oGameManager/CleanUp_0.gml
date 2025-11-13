/// @description Cleanup controllers and performance systems
/// Called when oGameManager is destroyed (room change, game end)

// Log cleanup statistics before destroying
log_asset_cache_stats();
log_all_pool_stats();

// Cleanup object pools
cleanup_object_pools();

// Cleanup asset cache
cleanup_asset_cache();

show_debug_message("[oGameManager] Cleanup complete - all systems shut down gracefully");
