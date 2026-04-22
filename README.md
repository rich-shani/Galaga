# Galaga Wars

A Star Wars themed remake of the classic Galaga arcade game, built in GameMaker Studio 2. Pilot an X-Wing against waves of TIE Fighters, TIE Interceptors, and Imperial Shuttles in a formation-based shooter with faithful arcade mechanics and modern visual polish.

---

## Features

- **Wave-based combat** — 40 enemies per wave arranged in a 5×8 formation grid
- **Three enemy types** — TIE Fighter, TIE Interceptor, and Imperial Shuttle, each with unique stats and attack paths
- **Enemy AI** — Dive attacks, loop returns, rogue enemies that bypass formation, and final attack mode when few enemies remain
- **Challenge Stages** — Bonus rounds every 4 levels with unique enemy patterns and perfect-clear bonuses
- **Capture Mechanics** — Enemies can capture the player with a tractor beam; rescue your captured ship for a dual fighter
- **Power Pickups & Shield** — Shield health bar and power pickup items
- **Visual Effects** — CRT shader presets, scrolling nebula, bloom, particle explosions, and breathing formation animation
- **Scoring System** — Points double for diving enemies, extra lives at milestones, persistent high score table with initial entry
- **HTML5 Support** — Playable in browser via HTML5 export
- **Gamepad Support** — Left stick to move, A button to fire

---

## Getting Started

### Requirements

- [GameMaker Studio 2](https://gms.yoyogames.com/) v2024.13.1.193 or later (free version works)
- [Git](https://git-scm.com/)

### Setup

```bash
git clone https://github.com/rich-shani/Galaga.git
cd Galaga
```

Open `Galaga.yyp` in GameMaker Studio 2 and wait for indexing (~1–2 minutes).

### Run

Press **F5** or click **Run**. The game opens in a new window.

```
Splash Screen → Title / Attract Mode → Gameplay
```

Press **ESC** in-game to pause. Press **ESC** in GameMaker to stop.

---

## Controls

| Action | Keyboard | Gamepad |
|--------|----------|---------|
| Move left/right | A / D | Left stick |
| Fire | Space | A button |
| Pause | ESC | — |

---

## Gameplay

**Standard Waves:** 40 enemies enter in formation groups. Enemies leave formation to dive-attack, then loop back. Score doubles for enemies destroyed mid-dive.

**Challenge Stages:** Triggered every 4 levels. Unique flight patterns, 5 waves of 8 enemies. Earn bonus points for a perfect clear (no enemies escape).

**Capture & Rescue:** An enemy using its tractor beam can capture your ship. Destroy the captor during a subsequent wave to free it — fly both ships simultaneously for double firepower.

**Extra Lives:** First extra life at 20,000 points; additional lives every 70,000 points after that.

---

## Architecture

The project uses a **modular controller pattern** to avoid god-object complexity, with **data-driven configuration** in JSON files so wave patterns, difficulty, and enemy stats can be tuned without recompiling.

| Controller | Responsibility |
|------------|---------------|
| `oGameManager` | Central orchestrator — game state, spawning, UI |
| `WaveSpawner` | Enemy wave and challenge stage spawning |
| `ScoreManager` | Score tracking, extra life milestones |
| `ChallengeStageManager` | Challenge stage detection and execution |
| `AssetCache` | Caches `asset_get_index()` calls (+5–10 FPS) |
| `ObjectPool` | Reuses missiles, enemy shots, explosions (eliminates GC stutters) |

**Design patterns:** State machine (game, enemy, player), object pooling, asset caching, event-driven collision, struct-based global state.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full system breakdown, state machine diagrams, and GML code examples.

---

## Project Structure

```
Galaga/
├── objects/            # Game objects (oGameManager, oPlayer, oEnemyBase, ...)
├── scripts/            # Reusable functions (WaveSpawner, ScoreManager, ...)
├── rooms/              # Game levels (SplashScreen, GalagaWars, TitleScreen)
├── sprites/            # Visual assets (320+)
├── paths/              # Movement paths (100+)
├── sounds/             # Audio assets (20+)
├── shaders/            # CRT and bloom shader effects
├── datafiles/
│   └── Patterns/       # JSON configuration files
│       ├── wave_spawn.json
│       ├── challenge_spawn.json
│       ├── formation_coordinates.json
│       ├── game_config.json
│       ├── oTieFighter.json
│       └── ...
├── Galaga.yyp          # GameMaker project file
├── ARCHITECTURE.md     # Full technical reference
├── DEVELOPER_GUIDE.md  # Contributor quick-start
└── QUICK_REFERENCE.md  # Cheat sheet for common tasks
```

---

## Configuration

All gameplay parameters live in `datafiles/Patterns/` — no recompile needed.

| File | Controls |
|------|----------|
| `game_config.json` | Lives, extra life thresholds, dive cap, challenge interval, difficulty multiplier |
| `wave_spawn.json` | Enemy types and paths for each wave |
| `challenge_spawn.json` | Challenge stage patterns and enemy assignments |
| `oTieFighter.json` / `oTieIntercepter.json` / `oImperialShuttle.json` | Per-enemy health, points, attack paths |

---

## Testing

The project includes a GML test framework with 9 test suites covering wave spawning, collision, enemy state machine, scoring, challenge stages, beam logic, high scores, and level progression.

To run tests, add `oGlobal` and `oTestRunner` to a debug room and press **F5**. Results print to the GameMaker output console:

```
[PASS] WaveSpawner should return a struct
[FAIL] spawn_counter should equal 0
       Expected: 0  Actual: 1
...
Total: 45  Passed: 43 (95%)
```

---

## Development

- **Add a new enemy type** — Create the object inheriting `oEnemyBase`, add a sprite, create a JSON config in `datafiles/Patterns/`, add spawn entries to `wave_spawn.json`, and update `nOfEnemies()` in `GameManager_STEP_FNs.gml`.
- **Modify wave patterns** — Edit `wave_spawn.json` directly; no code changes required.
- **Change difficulty** — Adjust `SPEED_MULTIPLIER_BASE` in `game_config.json`.

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for full workflows, debugging tips, and the code review checklist.

---

## Performance

| Target | Goal |
|--------|------|
| Framerate | 60 FPS |
| Memory | < 100 MB |
| Load time | < 5 seconds |

Key optimizations: `AssetCache` (>95% hit rate after warmup), `ObjectPool` for projectiles and explosions, cached `instance_number()` calls.

---

## Technical Assessment

Reviewed November 2025 — **85/100**. Production-ready with strong architecture, comprehensive error handling, and full test coverage. See [TECHNICAL_REVIEW.md](TECHNICAL_REVIEW.md) for the detailed assessment and optimization roadmap.

---

## License

[Your License Here]
