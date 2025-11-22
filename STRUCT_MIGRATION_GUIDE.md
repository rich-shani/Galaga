# Global Struct Migration Guide

**Status:** In Progress - Phase 1 Complete

This document outlines the migration from legacy global variables to the structured `global.Game` namespace.

---

## Phase 1: Struct Hierarchy Improvements ✓ COMPLETE

Updated `oGlobal/Create_0.gml` to consolidate all legacy globals into the Game struct:

### Changes Made

#### 1. Asset Caching Migration
```gml
// OLD:
global.asset_cache = ds_map_create();
global.asset_cache_stats = { ... };

// NEW:
global.Game.Cache.assetCache = ds_map_create();
global.Game.Cache.assetStats = { ... };
```

#### 2. Data Files Migration
```gml
// OLD:
global.formation_data = load_json_datafile(...);
global.enemy_attributes = { ... };
global.game_config = load_game_config();

// NEW:
global.Game.Data.formation = load_json_datafile(...);
global.Game.Data.enemyAttributes = { ... };
global.Game.Data.config = load_game_config();
```

#### 3. Struct Declaration
Added new properties to `global.Game`:

```gml
Data: {
    // ... existing properties
    formation: undefined,        // Formation grid coordinates
    enemyAttributes: {
        oTieFighter: undefined,
        oTieIntercepter: undefined,
        oImperialShuttle: undefined
    },
    config: undefined            // Central game configuration
},
Cache: {
    assetCache: undefined,       // Asset ID caching system
    assetStats: {
        hits: 0,
        misses: 0,
        totalLookups: 0,
        uniqueAssets: 0
    }
}
```

---

## Phase 2: Code Reference Updates (Next)

### Files to Update

These files reference legacy global variables and need updating:

#### High Priority (Used Frequently)
1. **AssetCache.gml** (50+ lines)
   - Replace `global.asset_cache` → `global.Game.Cache.assetCache`
   - Replace `global.asset_cache_stats` → `global.Game.Cache.assetStats`

2. **EnemyBehavior.gml**
   - Replace `global.enemy_attributes` → `global.Game.Data.enemyAttributes`

3. **Enemy Objects** (oTieFighter, oTieIntercepter, oImperialShuttle)
   - Replace all enemy attribute lookups

#### Medium Priority (Used in Multiple Places)
1. **ChallengeStageManager.gml**
   - Replace `global.challenge_wave_path_map` → move to `global.Game.Controllers.challengeManager`

2. **ObjectPool.gml**
   - Already using new pool system, no changes needed

3. **TestFramework.gml**
   - Update to use new global paths

### Migration Strategy

#### Step 1: Create Wrapper Functions (Safe Approach)

Instead of updating all references at once, create wrapper functions:

```gml
/// @function get_game_asset_cache()
/// @description Get the asset cache (wrapper for backward compatibility)
/// @return {Id.DsMap} Asset cache ds_map
function get_game_asset_cache() {
    return global.Game.Cache.assetCache;
}

/// @function get_formation_data()
/// @description Get formation coordinates
/// @return {Struct} Formation data
function get_formation_data() {
    return global.Game.Data.formation;
}

/// @function get_enemy_attributes(_enemy_name)
/// @description Get attributes for enemy type
/// @param {String} _enemy_name Enemy object name
/// @return {Struct} Enemy attributes
function get_enemy_attributes(_enemy_name) {
    return global.Game.Data.enemyAttributes[$ _enemy_name];
}

/// @function get_game_config()
/// @description Get game configuration
/// @return {Struct} Game config
function get_game_config() {
    return global.Game.Data.config;
}
```

#### Step 2: Update References Incrementally

Update files in order of dependency:

1. Update AssetCache.gml
2. Update EnemyBehavior.gml
3. Update enemy objects
4. Update ChallengeStageManager.gml
5. Update remaining test files

#### Step 3: Remove Legacy Globals

Once all references are updated, remove legacy declarations.

---

## Migration Map

### Asset Cache References

| File | Old Reference | New Reference |
|------|---------------|---------------|
| AssetCache.gml | `global.asset_cache` | `global.Game.Cache.assetCache` |
| AssetCache.gml | `global.asset_cache_stats` | `global.Game.Cache.assetStats` |
| Multiple | `global.asset_cache_stats.hits` | `global.Game.Cache.assetStats.hits` |
| Multiple | `global.asset_cache_stats.misses` | `global.Game.Cache.assetStats.misses` |

### Data References

| File | Old Reference | New Reference |
|------|---------------|---------------|
| EnemyBehavior.gml | `global.enemy_attributes` | `global.Game.Data.enemyAttributes` |
| EnemyBehavior.gml | `global.formation_data` | `global.Game.Data.formation` |
| Enemy Objects | `global.game_config` | `global.Game.Data.config` |
| ChallengeStageManager.gml | `global.challenge_wave_path_map` | `global.Game.Controllers.challengeManager` |

---

## Backward Compatibility (Optional)

If you want to maintain backward compatibility during transition, add legacy global aliases:

```gml
// In oGlobal/Create_0.gml, after struct initialization:

// === LEGACY COMPATIBILITY ALIASES ===
// These redirect old global references to new struct locations
// Can be removed once all code is migrated

#macro global.asset_cache global.Game.Cache.assetCache
#macro global.asset_cache_stats global.Game.Cache.assetStats
#macro global.formation_data global.Game.Data.formation
#macro global.enemy_attributes global.Game.Data.enemyAttributes
#macro global.game_config global.Game.Data.config
```

**Note:** Macros are compile-time, not runtime, so this approach is safe and efficient.

---

## Testing Checklist

After completing migration:

- [ ] All test suites pass without errors
- [ ] Game initializes without errors
- [ ] Wave spawning works correctly
- [ ] Enemy attributes load properly
- [ ] Formation positioning works
- [ ] Asset cache hits/misses tracked correctly
- [ ] No "undefined variable" errors in debug console
- [ ] Frame rate remains consistent (60 FPS)

---

## Benefits of Migration

✓ **Centralized State Management** - All game data in one `global.Game` struct
✓ **Reduced Cognitive Load** - Developers don't need to remember multiple global variables
✓ **Better Organization** - Data grouped by category (Data, Cache, Controllers, etc.)
✓ **Easier Refactoring** - Can change internal structure without updating scattered references
✓ **Type Safety** - Clearer what data is available where
✓ **Documentation** - Struct hierarchy is self-documenting

---

## Implementation Timeline

**Estimated Time:** 2-3 hours

- Phase 1 (Complete): Struct hierarchy updates ✓
- Phase 2 (Next): AssetCache.gml migration (30 min)
- Phase 3: EnemyBehavior.gml + Enemy objects (45 min)
- Phase 4: ChallengeStageManager.gml (20 min)
- Phase 5: Testing and validation (30 min)

---

## Current Status

**Phase 1 Complete:** Struct hierarchy improvements done.
**Next Step:** Create wrapper functions in separate script file.
**Then:** Update AssetCache.gml references.

---
