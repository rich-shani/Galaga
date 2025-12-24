// ========================================================================
// NEW STRUCT-BASED SYSTEM INITIALIZATION
// ========================================================================
// Initialize the new global.Game struct hierarchy
// This provides organized, type-safe access to game state

// Central game configuration (lives, extra life thresholds, difficulty settings)
global.game_config = load_game_config();
show_debug_message("[GameConfig] Configuration loaded");

global.Game = {
	Input: {
		gamePad: false,
		fullScreen: false,
		characterCycle: "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."
	},
	Timing: {
	    frameCounter: 0,
	    lifeCounter: 0,
	    loopCounter: 0,
	    cycleCounter: 0,
	    alternateCounter: 0,
	    nextLevelFlag: 0
	},
    Player: {
        score: 0,
        lives: get_config_value("PLAYER", "STARTING_LIVES", 3),
		firstlife: get_config_value("PLAYER", "EXTRA_LIFE_FIRST", EXTRA_LIFE_FIRST_THRESHOLD),
        additional: get_config_value("PLAYER", "EXTRA_LIFE_ADDITIONAL", EXTRA_LIFE_ADDITIONAL_THRESHOLD),
        credits: 0,
        hits: 0,
        shotsFired: 0,
        shotCount: 0,
        shotTotal: 0,
        extraLifeThreshold: EXTRA_LIFE_FIRST_THRESHOLD
    },
    State: {
        mode: GameMode.INITIALIZE,
        isGameOver: false,
        isPaused: false,
        prohibitDive: 0,
        spawnOpen: 0,
        breathing: 1,
        results: 0,
        fast: 0,
        fastEnter: 0,
        enterShot: 0,
        hold: 15,
        lastAttack: 4
    },
    Level: {
        current: 0,
        wave: 0,
        stage: 0,
        pattern: 0
    },
    Challenge: {
        isActive: false,
        current: 0,
        countdown: 1,
        intervalsToNext: get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", CHALLENGE_INTERVAL_LEVELS)
    },
    Spawn: {
        counter: 0
    },
    Enemy: {
        diveCapacity: get_config_value("ENEMIES", "MAX_DIVE_CAP", 2),
        diveCapacityStart: get_config_value("ENEMIES", "DIVE_CAP_START", 2),
        breathePhase: 0,
		breathePhase_normalized: 0,
        transformActive: 0,
        transformTokens: 0,
        transformCount: 0,
        transformNum: 0,
        transformSide: 0,
        beamDuration: BEAM_TIME_DEFAULT,
        beamCheck: 0,
        capturedPlayer: false,
        count: 0,  // Cached enemy count (updated each frame in oGameManager Step)
        shotNumber: 2,
		shotCount: 0,
        animationSpeed: 0,
        escortCount: 0,
        fighterStore: 0,
        bossCount: 1,
        bossCap: get_config_value("ENEMIES", "MAX_BOSS_DIVE_CAP", 2)
    },
    Rogue: {
        level: 0,
        checkPerWave: false
    },
    Display: {
        scale: 2,
        screenWidth: view_get_wport(view_current),
        screenHeight: view_get_hport(view_current),
        animationIndex: 0,
		flip: 0,
		uiState: {
	        blinkCounter: 1,
	        scoreDigits: { hundreds: 0, tens: 0, ones: 0 },
	        rankDigits: { hundreds: 0, tens: 0, ones: 0 },
	        rankDisplaySprites: []
		}
    },
	HighScores: {
		scores: [20000, 10000, 5000, 2000, 1000],	// [score1, score2, score3, score4, score5]
		initials: ["AA", "BB", "CC", "DD", "EE"],	// [init1, init2, init3, init4, init5]
		initials_idx: 0,							// track which character is being added (Enter_initials())
		display: 0,									// Currently displayed high score
		position: -1								// position player (1-5 || -1 if none)
	},
    Difficulty: {
		speedMultiplier: get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0),
        gameSpeed: 60
    },
	Data: {
		spawn: undefined,
		challenge: undefined,
		rogue: undefined,
		speedCurves: undefined,
		formation: undefined,        // Formation grid coordinates (40 positions in 5x8 grid)
		enemyAttributes: {
			oTieFighter: undefined,
			oTieIntercepter: undefined,
			oImperialShuttle: undefined
		},
//		config: undefined            // Central game configuration (lives, difficulty, etc.)
	},
	Cache: {
		assetCache: undefined,       // Asset ID caching system for performance
		assetStats: {
			hits: 0,
			misses: 0,
			totalLookups: 0,
			uniqueAssets: 0
		}
	},
	Controllers: {
	    waveSpawner: undefined,
	    scoreManager: undefined,
	    challengeManager: undefined,
	    visualEffects: undefined,
	    uiManager: undefined,
	    audioManager: undefined,
		particleManager: undefined
	}
};

// === DEBUG MODE ===
global.debug = false; // Debug mode flag (set to true for debug output)

/// @section Asset Cache Initialization
// Initialize asset ID caching system for performance
// Eliminates 200+ asset_get_index() calls per level
// Expected FPS gain: +5-10 FPS, 96% cache hit rate
global.Game.Cache.assetCache = ds_map_create();

// Formation grid coordinates (40 positions in 5x8 grid)
// Loaded once && shared globally to avoid per-enemy loading overhead
global.Game.Data.formation = load_json_datafile("Patterns/formation_coordinates.json");

// Enemy attributes (health, points, paths) by enemy type
// Loaded once && cached globally for performance optimization
global.Game.Data.enemyAttributes.oTieFighter = load_json_datafile("Patterns/oTieFighter.json");
global.Game.Data.enemyAttributes.oTieIntercepter = load_json_datafile("Patterns/oTieIntercepter.json");
global.Game.Data.enemyAttributes.oImperialShuttle = load_json_datafile("Patterns/oImperialShuttle.json");

// Wave spawn patterns - defines enemy entry sequences && formation positions (40 enemies per wave)
global.Game.Data.spawn = load_json_datafile("Patterns/wave_spawn.json");

// Challenge stage patterns - bonus levels every 4 stages (8 enemies per wave, 5 waves)
global.Game.Data.challenge = load_json_datafile("Patterns/challenge_spawn.json");

// Rogue enemy spawn counts - special enemies that don't join formation
global.Game.Data.rogue = load_json_datafile("Patterns/rogue_spawn.json");

// Difficulty scaling curves - speed multipliers per level
global.Game.Data.speedCurves = load_json_datafile("Patterns/speed_curve.json");

/// @section JSON Schema Validation
// Validate all loaded JSON data to catch configuration errors early
// If validation fails, game will show error but continue with loaded data

if (global.Game.Data.spawn != undefined && !validate_wave_spawn_json(global.Game.Data.spawn)) {
	log_error("Wave spawn data failed validation - check wave_spawn.json structure", "oGlobal Create", 3);
}

if (global.Game.Data.challenge != undefined && !validate_challenge_spawn_json(global.Game.Data.challenge)) {
	log_error("Challenge spawn data failed validation - check challenge_spawn.json structure", "oGlobal Create", 3);
}

if (global.Game.Data.formation != undefined && !validate_formation_coordinates_json(global.Game.Data.formation)) {
	log_error("Formation coordinates failed validation - check formation_coordinates.json structure", "oGlobal Create", 3);
}

if (global.Game.Data.enemyAttributes.oTieFighter != undefined && !validate_enemy_attributes_json(global.Game.Data.enemyAttributes.oTieFighter, "oTieFighter")) {
	log_error("TIE Fighter attributes failed validation", "oGlobal Create", 3);
}

if (global.Game.Data.enemyAttributes.oTieIntercepter != undefined && !validate_enemy_attributes_json(global.Game.Data.enemyAttributes.oTieIntercepter, "oTieIntercepter")) {
	log_error("TIE Interceptor attributes failed validation", "oGlobal Create", 3);
}

if (global.Game.Data.enemyAttributes.oImperialShuttle != undefined && !validate_enemy_attributes_json(global.Game.Data.enemyAttributes.oImperialShuttle, "oImperialShuttle")) {
	log_error("Imperial Shuttle attributes failed validation", "oGlobal Create", 3);
}

if (global.game_config != undefined && !validate_game_config_json(global.game_config)) {
	log_error("Game configuration failed validation - check game_config.json structure", "oGlobal Create", 3);
}

// TODO: GMScoreboard integration is currently disabled
// To re-enable cloud-based high scores:
//   1. Uncomment the setup code below
//   2. Configure GAME_TAG in game_config.json
//   3. Test with valid GMScoreboard credentials
//
// var game_tag = get_config_value("HIGH_SCORES", "GAME_TAG", "your_game_tag_here");
// setup_gmscoreboard(game_tag);
// get_scores(5);
// var refresh_seconds = get_config_value("HIGH_SCORES", "REFRESH_INTERVAL_SECONDS", 300);
// alarm[AlarmIndex.HIGH_SCORE_REFRESH] = refresh_seconds * 60;


// Setup the GM Scoreboard using the unique game tag (loaded from config)
var game_tag = get_config_value("HIGH_SCORES", "GAME_TAG", "fd0828983a329a0be9e26c34d892769b");
// setup the GM Scoreboard using the unique game tag
setup_gmscoreboard(game_tag);

// get the current set of high-scores
get_scores(5);

// setup an alarm to refresh the high score table every 5 minutes
alarm[0]=5*60*60;

// ========================================================================
// AUDIO MANAGER INITIALIZATION
// ========================================================================
// Initialize the centralized audio management system
global.Game.Controllers.audioManager = new AudioManager();
show_debug_message("[AudioManager] Audio management system initialized");

/// @section Controller Initialization
// Initialize specialized controllers to reduce god object complexity
// Reduces oGameManager from 594 lines to <200 lines (70% reduction)

global.Game.Controllers.visualEffects = new VisualEffectsManager();
global.Game.Controllers.uiManager = new UIManager();

// Wave spawner - handles all enemy spawning logic
global.Game.Controllers.waveSpawner = new WaveSpawner(global.Game.Data.spawn, global.Game.Data.challenge, global.Game.Data.rogue);

// Score manager - handles scoring, extra lives, high scores
global.Game.Controllers.scoreManager = new ScoreManager();

// Challenge stage manager - handles challenge stages with path lookup table
global.Game.Controllers.challengeManager = new ChallengeStageManager(global.Game.Data.challenge);

// Initialize ParticleManager in global.Game.Controllers
global.Game.Controllers.particleManager = new ParticleManager();

ensure_controllers_initialized();

show_debug_message("[oGameManager] All controllers initialized - ready for gameplay");

show_debug_message("[init_globals] Struct-based global system initialized");
show_debug_message("[init_globals] All game state managed through global.Game namespace");