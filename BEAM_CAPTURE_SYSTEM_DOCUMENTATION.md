# Beam Capture System Documentation

## Overview

The Beam Capture System adds player capture mechanics to the beam weapon system. When a player is within the beam's capture zone during the FIRE state, the player is captured and follows the capturing enemy until the beam sequence completes or the enemy is destroyed.

## System Architecture

### State Machine: BEAM_STATE Enum

```gml
enum BEAM_STATE {
    READY,          // Beam available, waiting for dive trigger
    CHARGING,       // Charging up (first frame of activation)
    FIRE,           // Actively firing beam (capture zone active)
    FIRE_COMPLETE,  // Firing complete, beginning escape
    FAILED          // Beam failed to activate (conditions not met)
}
```

### Beam Weapon Structure (oEnemyBase)

```gml
beam_weapon = {
    available : false,      // Can this enemy use beam? (enabled by subclass)
    state : BEAM_STATE.READY,  // Current state of beam sequence
    animation : 0           // Animation frame counter for beam sprite
};
```

### Player Capture Variables (oPlayer)

```gml
captor = noone;                 // Reference to capturing enemy
captured_offset_x = 0;          // X offset from captor position
captured_offset_y = 0;          // Y offset from captor position (28 px below)
capturedanimation = 0;          // Animation counter for captured ship rotation
```

## Capture Zone Mechanics

### Activation Conditions

The capture zone is **only active** when:
1. **Enemy Condition**: `beam_weapon.state == BEAM_STATE.FIRE`
2. **Player Condition**: `oPlayer.shipStatus == _ShipState.ACTIVE`
3. **Position**: Player is within capture radius (48 pixels * global.scale)
4. **Proximity Check**: Uses `distance_to_point()` for circular hit detection

### Capture Zone Detection Code

Located in **oEnemyBase/Step_0.gml** (during IN_DIVE_ATTACK state):

```gml
else if (beam_weapon.state == BEAM_STATE.FIRE) {
    // Calculate distance from beam center to player
    var distance_to_player = distance_to_point(oPlayer.x, oPlayer.y);
    var capture_radius = 48 * global.scale;

    // Check if player is within capture zone and is vulnerable
    if (distance_to_player < capture_radius && oPlayer.shipStatus == _ShipState.ACTIVE) {
        // Player is captured by beam!
        oPlayer.shipStatus = _ShipState.CAPTURED;
        oPlayer.captor = id;
        oPlayer.captured_offset_x = 0;
        oPlayer.captured_offset_y = 28 * global.scale;

        // Play capture sound
        sound_stop(GCaptured);
        sound_play(GCaptured);
    }
}
```

## Captured State Behavior

### Player Movement During Capture

**oPlayer/Step_0.gml** - CAPTURED case:

```gml
case _ShipState.CAPTURED:
    // Check if captor still exists
    if (!instance_exists(captor)) {
        // Captor destroyed, return to active
        shipStatus = _ShipState.ACTIVE;
        captor = noone;
    } else {
        // Follow captor position with offset
        x = captor.x + captured_offset_x;
        y = captor.y + captured_offset_y;

        // Increment animation counter
        capturedanimation += 1;
        if (capturedanimation >= 360) {
            capturedanimation = 0;
        }

        // Check if beam finished
        if (captor.beam_weapon.state != BEAM_STATE.FIRE) {
            // Release player
            shipStatus = _ShipState.ACTIVE;
            captor = noone;
        }
    }
    break;
```

**Player Behavior While Captured:**
- ✓ Follows enemy position exactly
- ✗ Cannot move (input ignored)
- ✗ Cannot fire
- ✓ Updates animation state
- ✓ Checks captor state continuously
- ✓ Auto-releases if captor destroyed
- ✓ Auto-releases when beam exits FIRE state

### Rendering Captured Player

**oPlayer/Draw_0.gml** - CAPTURED state rendering:

```gml
else if (shipStatus == _ShipState.CAPTURED) {
    // Calculate rotation based on captured animation
    var captured_rotation = (capturedanimation / 360) * 360;

    if (global.roomname == "GalagaWars") {
        // Use X-Wing sprite with spin effect
        draw_sprite_ext(xwing_sprite_sheet, 2, x, y, 0.8, 0.8, captured_rotation, c_white, 1);
    }
    else {
        // Use ship sprite with spin effect
        draw_sprite_ext(spr_ship, 0, x, y, 1, 1, captured_rotation, c_white, 1);
    }

    // Pulsing glow effect
    var glow_alpha = (sin(capturedanimation * 0.02) + 1) / 2;
    draw_set_alpha(glow_alpha * 0.5);
    draw_circle_colour(x, y, 32, c_yellow, c_red, false);
    draw_set_alpha(1);
}
```

**Visual Effects:**
- Ship rotates continuously (360° rotation over 360 frames)
- Pulsing yellow-to-red glow around ship
- Semi-transparent glow (50% alpha)
- Different sprites for GalagaWars vs original rooms

### Rendering Captured Player in Enemy Draw

**oTieIntercepter/Draw_0.gml** - After beam sprite rendering:

```gml
if (oPlayer.shipStatus == _ShipState.CAPTURED && oPlayer.captor == id && beam_weapon.state == BEAM_STATE.FIRE) {
    // Player is being carried by this enemy's beam

    var player_rotation = (oPlayer.capturedanimation / 360) * 360;

    if (global.roomname == "GalagaWars") {
        draw_sprite_ext(xwing_sprite_sheet, 2, oPlayer.x, oPlayer.y, 0.8, 0.8, player_rotation, c_white, 1);
    }
    else {
        draw_sprite_ext(spr_ship, 0, oPlayer.x, oPlayer.y, 1, 1, player_rotation, c_white, 1);
    }

    var glow_alpha = (sin(oPlayer.capturedanimation * 0.02) + 1) / 2;
    draw_set_alpha(glow_alpha * 0.5);
    draw_circle_colour(oPlayer.x, oPlayer.y, 32, c_yellow, c_red, false);
    draw_set_alpha(1);
}
```

## Beam Sequence Timeline

```
BEAM_STATE.READY
    ↓
[Player in single-ship mode + random(3) == 0?]
    ↓
BEAM_STATE.CHARGING (1 frame)
    ↓
BEAM_STATE.FIRE (for global.beamtime frames)
    │
    ├─ alarm[3] decrements each frame
    ├─ CAPTURE ZONE ACTIVE (48px radius)
    ├─ Player can be captured
    └─ Captured player spins with glow effect
    ↓
[alarm[3] == -1]
    ↓
BEAM_STATE.FIRE_COMPLETE
    ↓
[Enemy escapes]
    ↓
BEAM_STATE.READY (next dive cycle)
```

## Release Conditions

The player is released from capture when:

1. **Beam Exits FIRE State**: `captor.beam_weapon.state != BEAM_STATE.FIRE`
   - Automatically checked each frame in oPlayer CAPTURED step
   - Most common release condition

2. **Captor Destroyed**: `!instance_exists(captor)`
   - Checks each frame if captor still exists
   - If not, immediate release to ACTIVE state

3. **Manual Release**: (Could be added via rescue mechanic)
   - Not yet implemented
   - Would require Boss or allied ship interaction

## Files Modified

### 1. **objects/oEnemyBase/Step_0.gml** (+30 lines)
   - Added capture zone collision detection
   - Added in IN_DIVE_ATTACK state, FIRE phase
   - Calculates distance_to_point()
   - Sets oPlayer capture variables
   - Plays GCaptured sound

### 2. **objects/oEnemyBase/Create_0.gml** (Already updated)
   - Contains BEAM_STATE enum
   - Contains beam_weapon struct definition
   - beam_weapon.available defaults to false

### 3. **objects/oPlayer/Create_0.gml** (+28 lines)
   - Added capture variable initialization
   - captor, captured_offset_x/y, capturedanimation

### 4. **objects/oPlayer/Step_0.gml** (+40 lines)
   - Added CAPTURED case to shipStatus switch
   - Implements position following logic
   - Checks captor existence and state
   - Auto-release conditions
   - Animation counter increment

### 5. **objects/oPlayer/Draw_0.gml** (+60 lines)
   - Enhanced with CAPTURED state rendering
   - Implements spinning animation
   - Renders pulsing glow effect
   - Different rendering per room type

### 6. **objects/oTieIntercepter/Draw_0.gml** (+30 lines)
   - Added captured player rendering
   - Renders player above enemy when captured
   - Uses same glow effect as player draw
   - Only renders when conditions met

## Integration with Beam System

### Beam Activation Flow

1. **Enemy dives** → In formation
2. **Dive attack triggers** → IN_DIVE_ATTACK state
3. **Enemy reaches y > 368** → Beam position reached
4. **beam_weapon.available == true** → Activates
5. **BEAM_STATE.CHARGING** (1 frame)
6. **BEAM_STATE.FIRE** (global.beamtime frames)
   - **CAPTURE ZONE ACTIVE** ← Player can be captured here
7. **alarm[3] expires** → BEAM_STATE.FIRE_COMPLETE
8. **Enemy escapes** → Back to formation

### Capture Zone Dimensions

- **Shape**: Circle
- **Radius**: 48 * global.scale pixels
- **Center**: Enemy position (x, y)
- **Detection Method**: `distance_to_point()`

### Offset Positioning

When captured, player position is set to:
```gml
oPlayer.x = captor.x + captured_offset_x;      // Usually 0 (centered)
oPlayer.y = captor.y + captured_offset_y;      // Usually 28 pixels below
```

## Sound Effects

- **GCaptured**: Plays when player is first captured
- **GBeam**: Plays during beam firing (looping)
- Both use `sound_stop()` before `sound_play()` to prevent overlaps

## Performance Considerations

- **Capture Detection**: Only active during BEAM_STATE.FIRE
- **Distance Calculation**: Single distance_to_point() per frame when firing
- **Position Update**: Linear position assignment (no lerp)
- **Animation**: Simple counter increment (no heavy calculations)
- **Rendering**: Only renders when shipStatus == CAPTURED

## Testing Checklist

- [ ] TIE Intercepter enters dive attack
- [ ] Beam activates at y > 368 * global.scale
- [ ] BEAM_STATE transitions: READY → CHARGING → FIRE
- [ ] Capture zone detected (48px radius)
- [ ] Player captured when in zone during FIRE state
- [ ] Player positioned below enemy (28px offset)
- [ ] Player spins while captured (360° rotation)
- [ ] Glow effect pulsates around player
- [ ] GCaptured sound plays on capture
- [ ] Player follows enemy movement
- [ ] Player released when beam exits FIRE state
- [ ] Player released when captor destroyed
- [ ] Captured rendering shows in both room types
- [ ] Player cannot move while captured
- [ ] Player cannot fire while captured

## Future Enhancements

1. **Rescue Mechanic**: Allied ship can destroy beam to rescue player
2. **Capture Damage**: Player takes damage if captured too long
3. **Escape Sequence**: Player can mash button to break free
4. **Multiple Captors**: Handle if multiple beams try to capture
5. **Capture Animation**: More sophisticated spinning effect
6. **Tractor Beam Visual**: Add stream effect from enemy to player
7. **Shake Effect**: Screen shake when player is captured
8. **Capture Indicator**: HUD element showing capture status
9. **Beam Resistance**: Some enemy types harder to capture with

## Summary Statistics

- **Total Lines Added**: ~128
- **Files Modified**: 6
- **New Functions**: 0 (integrated into existing state machines)
- **New Variables**: 4 (on oPlayer)
- **New Structs**: 0 (extended existing beam_weapon)
- **Backward Compatibility**: Fully maintained
- **Performance Impact**: Minimal (conditional checks only active during FIRE state)
