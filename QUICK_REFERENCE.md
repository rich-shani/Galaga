# Galaga Wars - Developer Quick Reference Card

**Print this page or bookmark for quick access while coding**

---

## File Locations

| What | Where |
|------|-------|
| Game Objects | `objects/` |
| Scripts & Functions | `scripts/` |
| Game Levels | `rooms/` |
| Images/Sprites | `sprites/` |
| Movement Paths | `paths/` |
| Configuration | `datafiles/Patterns/` |
| Audio Files | `sounds/` |
| Effects | `shaders/` |
| Documentation | Root directory (`*.md` files) |

---

## Key Game Objects

| Object | Purpose | Location |
|--------|---------|----------|
| oGameManager | Central game controller | `objects/oGameManager/` |
| oPlayer | Player X-Wing | `objects/oPlayer/` |
| oEnemyBase | Enemy base class | `objects/oEnemyBase/` |
| oTieFighter | TIE Fighter enemy | `objects/oTieFighter/` |
| oTieIntercepter | TIE Interceptor enemy | `objects/oTieIntercepter/` |
| oImperialShuttle | Imperial Shuttle enemy | `objects/oImperialShuttle/` |
| oMissile | Player missile | `objects/oMissile/` |
| oEnemyShot | Enemy projectile | `objects/oEnemyShot/` |

---

## Key Scripts & Controllers

| Script | Purpose | Location |
|--------|---------|----------|
| WaveSpawner | Enemy wave spawning | `scripts/WaveSpawner/` |
| ScoreManager | Score tracking | `scripts/ScoreManager/` |
| ChallengeStageManager | Challenge stages | `scripts/ChallengeStageManager/` |
| AssetCache | Performance optimization | `scripts/AssetCache/` |
| ObjectPool | Instance pooling | `scripts/ObjectPool/` |
| ErrorHandling | Error logging | `scripts/ErrorHandling/` |
| GameConstants | Constants & enums | `scripts/GameConstants/` |

---

## Configuration Files

| File | Purpose | Format |
|------|---------|--------|
| wave_spawn.json | Standard wave patterns | JSON |
| challenge_spawn.json | Challenge stage patterns | JSON |
| formation_coordinates.json | Formation grid positions | JSON |
| game_config.json | Global game settings | JSON |
| oTieFighter.json | TIE Fighter attributes | JSON |
| oTieIntercepter.json | TIE Interceptor attributes | JSON |
| oImperialShuttle.json | Imperial Shuttle attributes | JSON |

**Location:** `datafiles/Patterns/`

---

## Game States

```
INITIALIZE → ATTRACT_MODE ↔ GAME_ACTIVE ↔ PAUSE
                             ↓
                         SHOW_RESULTS
                             ↓
                       ENTER_INITIALS
                             ↓
                       ATTRACT_MODE
```

**Enum:** `GameMode` (in GameConstants.gml)

---

## Enemy States

```
ENTER_SCREEN → MOVE_INTO_FORMATION → IN_FORMATION
                                     ├→ IN_DIVE_ATTACK → IN_LOOP_ATTACK → MOVE_INTO_FORMATION
                                     └→ IN_FINAL_ATTACK → IN_DIVE_ATTACK (continuous)
```

**Enum:** `EnemyState` (in GameConstants.gml)

---

## Player Ship States

| State | Meaning | Transitions |
|-------|---------|-------------|
| ACTIVE | Normal control | → CAPTURED or DEAD |
| CAPTURED | Held by tractor beam | → RELEASING or DEAD |
| RELEASING | Being freed from capture | → ACTIVE |
| RESPAWN | Respawn animation | → ACTIVE |
| DEAD | Destroyed, waiting | → RESPAWN |

**Enum:** `ShipState` (in GameConstants.gml)

---

## Common Constants

| Constant | Value | Usage |
|----------|-------|-------|
| GAME_WIDTH | 512 | Screen width (pixels) |
| GAME_HEIGHT | 480 | Screen height (pixels) |
| BASE_ENEMY_SPEED | 6 | Enemy movement speed |
| MISSILE_SPEED | 8 | Missile movement speed |
| FORMATION_ROWS | 5 | Enemy grid rows |
| FORMATION_COLS | 8 | Enemy grid columns |
| FINAL_ATTACK_ENEMY_COUNT | 3 | Enemies to trigger final attack |
| MAX_ENEMY_SHOTS | 12 | Max enemy projectiles |
| EXTRA_LIFE_FIRST_THRESHOLD | 20000 | First extra life score |
| EXTRA_LIFE_ADDITIONAL_THRESHOLD | 70000 | Subsequent extra life intervals |

**Location:** `scripts/GameConstants/GameConstants.gml`

---

## Test Framework Assertions

```gml
// Equality
assert_equals(actual, expected, "message")
assert_not_equals(actual, not_expected, "message")

// Boolean
assert_true(condition, "message")
assert_false(condition, "message")

// Null checking
assert_is_null(value, "message")
assert_is_not_null(value, "message")

// Type checking
assert_is_array(value, "message")
assert_is_struct(value, "message")

// Comparisons
assert_greater_than(value, min, "message")
assert_less_than(value, max, "message")
assert_in_range(value, min, max, "message")

// Collections
assert_array_length(arr, length, "message")
assert_struct_has_property(struct, property, "message")

// Instances
assert_instance_exists(object, "message")
assert_instance_not_exists(object, "message")
```

**Location:** `scripts/TestFramework/TestFramework.gml`

---

## Data Access Patterns

### Loading JSON Configuration
```gml
var wave_data = global.wave_spawn_data;
var challenge_data = global.challenge_spawn_data;
var formation_data = global.formation_data;
var enemy_attributes = global.enemy_attributes;
```

### Getting Configuration Values
```gml
var lives = get_config_value("PLAYER", "STARTING_LIVES", 3);
var interval = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", 4);
```

### Safe Asset Lookup
```gml
var asset_id = get_cached_asset("AssetName");
if (asset_id == -1) {
    log_error("Asset not found", "MyFunction", 2);
    return;
}
```

### Adding Score
```gml
var points = score_manager.addEnemyScore(
    enemy_type,
    base_points,
    is_diving
);
```

---

## Debugging Tips

| Task | Command |
|------|---------|
| Print to console | `show_debug_message("text")` |
| Log error | `log_error("message", "context", severity)` |
| Get current time | `get_timer()` |
| Check if instance exists | `instance_exists(object)` |
| Count instances | `instance_number(object)` |
| Add breakpoint | Click line number in code |

---

## Common Mistakes to Avoid

❌ **DON'T:**
```gml
// Hardcoding values
enemy.speed = 6;
missile_speed = 8;

// Not checking for undefined
var result = global.Game.Player;  // Might be undefined

// Direct asset lookup without caching
var path = asset_get_index("PathName");

// Creating instances without pooling
instance_create(x, y, oExplosion);

// Not documenting complex logic
if (condition) { /* what does this do? */ }
```

✅ **DO:**
```gml
// Use constants
enemy.speed = BASE_ENEMY_SPEED;
missile_speed = MISSILE_SPEED;

// Check before accessing
if (global.Game != undefined && global.Game.Player != undefined) {
    var result = global.Game.Player;
}

// Use asset cache
var path = get_cached_asset("PathName");

// Use object pool for performance
global.explosion_pool.acquire(x, y);

// Document non-obvious logic
// Activate dive attack only when spawning is complete
if (global.Game.State.spawnOpen == 0) { ... }
```

---

## Naming Conventions

| Type | Prefix | Example |
|------|--------|---------|
| Objects | `o` | `oGameManager`, `oPlayer` |
| Sprites | `s` | `sTieFighter`, `sExplosion` |
| Sounds | `G` | `GDie`, `GBeam`, `GBoss1` |
| Paths | Various | `Ent_Top_L2R`, `TF_Dive1`, `Chall1_Path1` |
| Functions | snake_case | `spawnStandardEnemy()`, `addScore()` |
| Enums | CamelCase | `GameMode`, `EnemyState` |
| Constants | UPPERCASE | `BASE_ENEMY_SPEED`, `GAME_WIDTH` |

---

## Code Review Checklist

Before committing changes:

- [ ] Code follows naming conventions
- [ ] Complex logic has comments
- [ ] Invalid inputs are handled
- [ ] No hardcoded values (use constants)
- [ ] Tests pass (`F5` to run)
- [ ] No performance regressions
- [ ] Documentation updated if needed
- [ ] Commit message is clear

---

## Getting Help

| Need | Resource |
|------|----------|
| Architecture overview | `ARCHITECTURE.md` |
| Developer setup | `DEVELOPER_GUIDE.md` |
| Testing examples | `scripts/Test*.gml` files |
| Constant definitions | `scripts/GameConstants/GameConstants.gml` |
| Known bugs | `BUGS.md` |
| API reference | GameMaker docs: `https://docs.yoyogames.com/` |

---

## Keyboard Shortcuts (GameMaker)

| Action | Shortcut |
|--------|----------|
| Run game | F5 |
| Run with debug | F6 |
| Stop | Shift+F5 |
| Step frame (debugging) | F10 |
| Step into (debugging) | F11 |
| Add breakpoint | Click line number |
| Open file search | Ctrl+T |
| Find in code | Ctrl+H |
| Find and replace | Ctrl+Shift+H |

---

## Performance Targets

- **Framerate:** 60 FPS (16.67 ms/frame)
- **Memory:** <100 MB
- **Load time:** <5 seconds
- **Debug output:** <1000 lines per minute

---

## Useful Resources

- **GameMaker Docs:** https://docs.yoyogames.com/
- **GML Reference:** https://docs.yoyogames.com/source/dadiospice/002_reference/gml_overview/gml_overview.html
- **Galaga Wikipedia:** https://en.wikipedia.org/wiki/Galaga
- **Game Architecture:** https://gameprogrammingpatterns.com/

---

## Quick Command Reference

```bash
# Version control
git status                  # Check status
git add .                   # Stage all changes
git commit -m "message"     # Commit changes
git push                    # Push to remote
git pull                    # Pull updates

# Check git log
git log --oneline           # Recent commits
```

---

**Last Updated:** November 2024
**Version:** 1.0

**Questions?** See ARCHITECTURE.md or DEVELOPER_GUIDE.md
