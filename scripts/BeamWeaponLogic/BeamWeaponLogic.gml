/// @file BeamWeaponLogic.gml
/// @description Beam weapon system logic for enemy tractor beam attacks
///
/// FUNCTIONS:
///   - canActivateBeam() - Checks if beam weapon can be activated
///   - activateBeamWeapon() - Initiates beam charging sequence
///   - updateBeamFire() - Handles beam firing and player capture detection
///   - updateCapturedPlayerAnimation() - Animates captured player being pulled to boss
///   - completeBeamAttack() - Finalizes beam attack and resumes dive
///
/// RELATED FILES:
///   - objects/oEnemyBase/Step_0.gml - Calls these functions during IN_DIVE_ATTACK state
///   - scripts/GameConstants.gml - Defines beam weapon constants
///
/// IMPORTANT: These functions must be called from enemy instance context (oEnemyBase or subclass)
///            They access instance variables: beam_weapon, x, y, speed, direction, alarm[]

/// @function canActivateBeam
/// @description Checks if all conditions are met to activate the beam weapon
///              Must be called from enemy instance context
///
/// CONDITIONS:
///   1. Beam weapon is available for this enemy type
///   2. Player exists and is in single-ship mode
///   3. Enemy has reached beam activation position
///   4. Beam hasn't already failed activation
///   5. No player is currently captured
///
/// @return {Bool} True if beam can activate, false otherwise
function canActivateBeam() {
    // === BASIC CHECKS ===
    if (!beam_weapon.available) return false;
    if (!instance_exists(oPlayer)) return false;
    if (oPlayer.shotMode != ShotMode.SINGLE) return false;

    // === POSITION CHECK ===
    if (y <= BEAM_ACTIVATION_Y_POSITION * global.Game.Display.scale) return false;

    // === STATE CHECKS ===
    if (beam_weapon.state != BEAM_STATE.READY) return false;
    if (global.Game.Enemy.capturedPlayer) return false;

    return true;
}

/// @function tryActivateBeam
/// @description Attempts to activate beam with probability check
///              Uses BEAM_ACTIVATION_PROBABILITY for random activation
///              Must be called from enemy instance context
/// @return {undefined}
function tryActivateBeam() {
    // 1-in-3 chance to activate (33.3% probability)
    if (random(1) < BEAM_ACTIVATION_PROBABILITY) {
        beam_weapon.state = BEAM_STATE.CHARGING;
    } else {
        beam_weapon.state = BEAM_STATE.FAILED;
    }
}

/// @function activateBeamWeapon
/// @description Initiates beam weapon charging sequence
///              Stops enemy movement, plays beam sound, sets up firing state
///              Must be called from enemy instance context
/// @return {undefined}
function activateBeamWeapon() {
    // === STOP MOVEMENT ===
    path_end();
    speed = 0;
    direction = TARGET_DIRECTION_DOWN;

    // === SET BEAM DURATION TIMER ===
    alarm[3] = global.Game.Enemy.beamDuration;

    // === TRANSITION TO FIRE STATE ===
    beam_weapon.state = BEAM_STATE.FIRE;

    // === PLAY BEAM SOUND ===
    global.Game.Controllers.audioManager.stopSound(GBeam);
    global.Game.Controllers.audioManager.loopSound(GBeam);
}

/// @function isPlayerInCaptureZone
/// @description Checks if player is within beam capture area
///              Uses rectangular bounds check for performance
///              Must be called from enemy instance context
/// @return {Bool} True if player is in capture zone and vulnerable
function isPlayerInCaptureZone() {
    if (!instance_exists(oPlayer)) return false;

    // === HORIZONTAL BOUNDS CHECK ===
    // Beam capture width defined in GameConstants.gml
    var withinBeamHorizontally = (oPlayer.x > x - BEAM_CAPTURE_WIDTH) &&
                                 (oPlayer.x < x + BEAM_CAPTURE_WIDTH);

    if (!withinBeamHorizontally) return false;

    // === PLAYER VULNERABILITY CHECK ===
    if (oPlayer.shipStatus != ShipState.ACTIVE) return false;

    return true;
}

/// @function isInCaptureTimeWindow
/// @description Checks if current beam timing is within capture window
///              Capture only occurs during middle 1/3 of beam duration (33%-67%)
///              Must be called from enemy instance context
/// @return {Bool} True if within capture time window
function isInCaptureTimeWindow() {
    var capture_start = global.Game.Enemy.beamDuration * BEAM_CAPTURE_WINDOW_END;   // 67% remaining
    var capture_end = global.Game.Enemy.beamDuration * BEAM_CAPTURE_WINDOW_START;    // 33% remaining

    return (alarm[3] < capture_start) && (alarm[3] > capture_end);
}

/// @function capturePlayer
/// @description Captures the player with beam weapon
///              Sets up all capture state, sounds, and player positioning
///              Must be called from enemy instance context
/// @return {undefined}
function capturePlayer() {
    // === UPDATE BEAM STATE ===
    beam_weapon.state = BEAM_STATE.CAPTURE_PLAYER;

    // === CAPTURE PLAYER ===
    oPlayer.shipStatus = ShipState.CAPTURED;
    oPlayer.captor = id;
    global.Game.Enemy.capturedPlayer = true;

    // === SETUP CAPTURE ANIMATION ===
    // Player starts off-screen and gets pulled toward boss
    beam_weapon.player_x = oPlayer.x;
    beam_weapon.player_y = BEAM_PLAYER_START_Y;

    // === SET ALARMS ===
    oPlayer.alarm[5] = BEAM_FIGHTER_CAPTURED_MESSAGE_DELAY;  // "FIGHTER CAPTURED" message
    oPlayer.alarm[0] = BEAM_PLAYER_RESPAWN_DELAY;             // Respawn delay

    // === PLAY CAPTURE SOUND ===
    global.Game.Controllers.audioManager.stopSound(GBeam);
    global.Game.Controllers.audioManager.loopSound(GCaptured);
}

/// @function updateBeamFire
/// @description Handles beam firing state and player capture detection
///              Checks if player is in capture zone during valid time window
///              Must be called from enemy instance context
/// @return {undefined}
function updateBeamFire() {
    if (!instance_exists(oPlayer)) return;

    // === CHECK CAPTURE CONDITIONS ===
    if (isPlayerInCaptureZone() && isInCaptureTimeWindow()) {
        capturePlayer();
    }
}

/// @function updateCapturedPlayerAnimation
/// @description Animates captured player being pulled toward boss
///              Moves player vertically and centers horizontally
///              Must be called from enemy instance context
/// @return {undefined}
function updateCapturedPlayerAnimation() {
    // === VERTICAL MOVEMENT ===
    // Interpolate player Y position based on remaining beam time
    // Player moves from BEAM_PLAYER_START_Y (1024) to BEAM_BOSS_Y_POSITION (736)
    var progress = alarm[3] / global.Game.Enemy.beamDuration;
    beam_weapon.player_y = BEAM_BOSS_Y_POSITION + floor(progress * BEAM_PULL_DISTANCE);

    // === HORIZONTAL CENTERING ===
    // Gradually align player X with boss X at BEAM_HORIZONTAL_ALIGN_SPEED pixels/frame
    if (beam_weapon.player_x < x) {
        beam_weapon.player_x += BEAM_HORIZONTAL_ALIGN_SPEED;
    } else if (beam_weapon.player_x > x) {
        beam_weapon.player_x -= BEAM_HORIZONTAL_ALIGN_SPEED;
    }
}

/// @function completeBeamAttack
/// @description Finalizes beam attack and resumes enemy dive movement
///              Called when beam duration expires
///              Must be called from enemy instance context
/// @return {undefined}
function completeBeamAttack() {
    // === RESUME MOVEMENT ===
    speed = entranceSpeed;

    // === UPDATE STATE ===
    beam_weapon.state = BEAM_STATE.FIRE_COMPLETE;
}

/// @function handleBeamWeaponLogic
/// @description Main beam weapon state machine handler
///              Coordinates all beam weapon states and transitions
///              Must be called from enemy instance context during IN_DIVE_ATTACK state
/// @return {undefined}
function handleBeamWeaponLogic() {
    // === EARLY EXITS ===
    if (!beam_weapon.available) return;
    if (!instance_exists(oPlayer)) return;
    if (oPlayer.shotMode != ShotMode.SINGLE) return;
    if (y <= BEAM_ACTIVATION_Y_POSITION * global.Game.Display.scale) return;
    if (beam_weapon.state == BEAM_STATE.FAILED) return;

    // === BEAM STATE MACHINE ===
    switch (beam_weapon.state) {
        case BEAM_STATE.READY:
            // Try to activate beam with probability check
            tryActivateBeam();
            break;

        case BEAM_STATE.CHARGING:
            // Begin beam firing sequence
            activateBeamWeapon();
            break;

        case BEAM_STATE.FIRE:
            // Check for player capture during beam fire
            updateBeamFire();
            break;

        case BEAM_STATE.CAPTURE_PLAYER:
            // Animate captured player being pulled to boss
            updateCapturedPlayerAnimation();
            break;
    }

    // === BEAM COMPLETION CHECK ===
    // When alarm expires, complete beam attack
    if (alarm[3] == -1 && beam_weapon.state == BEAM_STATE.FIRE) {
        completeBeamAttack();
    }
}
