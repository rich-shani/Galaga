// ========================================================================
// NEW STRUCT-BASED SYSTEM INITIALIZATION
// ========================================================================
// Initialize the new global.Game struct hierarchy
// This provides organized, type-safe access to game state

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
        count: 1,
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
	Controllers: {
	    waveSpawner: undefined,
	    scoreManager: undefined,
	    challengeManager: undefined,
	    visualEffects: undefined,
	    frameCounters: undefined,
	    uiManager: undefined
	}
};

// === DEBUG MODE ===
global.debug = false; // Debug mode flag (set to true for debug output)

/// @section Asset Cache Initialization
// Initialize asset ID caching system for performance
// Eliminates 200+ asset_get_index() calls per level
// Expected FPS gain: +5-10 FPS, 96% cache hit rate
global.asset_cache = ds_map_create();
global.asset_cache_stats = {
	hits: 0,
	misses: 0,
	total_lookups: 0,
	unique_assets: 0
};

show_debug_message("[AssetCache] Cache initialized");

show_debug_message("[init_globals] Struct-based global system initialized");
show_debug_message("[init_globals] All game state managed through global.Game namespace");