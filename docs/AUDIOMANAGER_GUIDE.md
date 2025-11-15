# AudioManager - Centralized Audio Management Guide

**Version:** 1.0
**Date:** November 14, 2024
**Status:** ✅ Implementation Complete

---

## Overview

The **AudioManager** is a centralized audio management system that consolidates all game audio handling into a single, reusable class. This provides:

- **Unified Interface** - All audio calls go through one consistent API
- **State Tracking** - Knows which sounds are playing and looping
- **Volume Control** - Master volume + individual sound mixing
- **Error Handling** - Graceful fallback for missing assets
- **Extensibility** - Easy to add features like audio fading, ducking, etc.

---

## Quick Start

### Basic Usage

```gml
// Get reference to AudioManager
var audio_mgr = global.Game.Controllers.audioManager;

// Play a one-shot sound
audio_mgr.playSound(GShot);

// Loop a sound (replaces existing loop)
audio_mgr.loopSound(GBreathe);

// Stop a specific sound
audio_mgr.stopSound(GBreathe);

// Stop all sounds
audio_mgr.stopAll();
```

### Using Legacy Wrappers

For backward compatibility, the legacy wrapper functions still work:

```gml
// These all route through AudioManager now
sound_play(GShot);
sound_loop(GBreathe);
sound_stop(GBreathe);
sound_stop_all();
```

---

## API Reference

### Sound Playback Methods

#### `playSound(sound_id, [priority], [fallback_sound])`

Plays a one-shot sound effect.

**Parameters:**
- `sound_id` {Id.Sound} - The sound to play
- `priority` {Number} - Optional priority level (default: 10)
- `fallback_sound` {Id.Sound} - Optional fallback if primary fails

**Returns:** Sound instance ID or -1 if failed

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Simple play
audio_mgr.playSound(GShot);

// With priority
audio_mgr.playSound(GBoss1, 15);

// With fallback
audio_mgr.playSound(GSoundA, 10, GSoundB);
```

---

#### `loopSound(sound_id, [priority])`

Plays a looping sound. **Replaces any existing loop.**

**Parameters:**
- `sound_id` {Id.Sound} - The sound to loop
- `priority` {Number} - Optional priority level (default: 10)

**Returns:** Sound instance ID or -1 if failed

**Important:** Only one looping sound can play at a time. Calling this again will replace the previous loop.

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Start looping background music
audio_mgr.loopSound(GBreathe);

// Later, switch to different loop
audio_mgr.loopSound(GBoss2);  // Automatically stops previous loop
```

---

### Sound Control Methods

#### `stopSound(sound_id)`

Stops a specific sound from playing.

**Parameters:**
- `sound_id` {Id.Sound} - The sound to stop

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

audio_mgr.stopSound(GBreathe);
```

---

#### `stopAll()`

Stops all sounds immediately.

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Stop everything
audio_mgr.stopAll();
```

---

#### `pauseSound(sound_id)`

Pauses a sound (can be resumed later).

**Parameters:**
- `sound_id` {Id.Sound} - The sound to pause

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

audio_mgr.pauseSound(GBreathe);
```

---

#### `resumeSound(sound_id)`

Resumes a paused sound.

**Parameters:**
- `sound_id` {Id.Sound} - The sound to resume

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

audio_mgr.resumeSound(GBreathe);
```

---

### Volume Control Methods

#### `setMasterVolume(volume)`

Sets master volume for all sounds (0.0 - 1.0).

**Parameters:**
- `volume` {Number} - Volume level (0.0 = silent, 1.0 = full)

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// 80% volume
audio_mgr.setMasterVolume(0.8);

// Mute everything
audio_mgr.setMasterVolume(0.0);

// Full volume
audio_mgr.setMasterVolume(1.0);
```

---

#### `setSoundVolume(sound_id, volume)`

Sets volume for a specific sound (0.0 - 1.0).

**Parameters:**
- `sound_id` {Id.Sound} - The sound to adjust
- `volume` {Number} - Volume level (0.0 = silent, 1.0 = full)

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Make a boss sound quieter
audio_mgr.setSoundVolume(GBoss1, 0.5);
```

---

### State Query Methods

#### `isPlaying(sound_id)`

Checks if a specific sound is currently playing.

**Parameters:**
- `sound_id` {Id.Sound} - The sound to check

**Returns:** Boolean (true if playing)

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

if (audio_mgr.isPlaying(GBreathe)) {
    // The breathing sound is currently playing
}
```

---

#### `isLooping()`

Checks if any sound is currently looping.

**Returns:** Boolean (true if a loop is active)

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

if (audio_mgr.isLooping()) {
    // A loop is currently active
}
```

---

#### `getLoopingSound()`

Gets the ID of the currently looping sound.

**Returns:** Sound ID or undefined if no loop

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

var current_loop = audio_mgr.getLoopingSound();
if (current_loop == GBreathe) {
    show_debug_message("Breathing sound is looping");
}
```

---

#### `getPlayingSoundCount()`

Gets count of all currently playing sounds.

**Returns:** Number (count of active sound instances)

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

var count = audio_mgr.getPlayingSoundCount();
show_debug_message("Playing " + string(count) + " sounds");
```

---

### Helper Methods

#### `switchLoop(old_sound_id, new_sound_id)`

Smoothly transitions from one looping sound to another.

**Parameters:**
- `old_sound_id` {Id.Sound} - Currently looping sound to stop
- `new_sound_id` {Id.Sound} - New sound to loop

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Transition from breathing to boss music
audio_mgr.switchLoop(GBreathe, GBoss2);
```

---

#### `playAndLoop(one_shot_id, loop_id)`

Plays a one-shot sound, then starts a loop after.

**Parameters:**
- `one_shot_id` {Id.Sound} - One-shot sound to play first
- `loop_id` {Id.Sound} - Sound to loop after one-shot completes

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Play alert, then switch to boss music
audio_mgr.playAndLoop(GAlert, GBoss1);
```

---

### Lifecycle Methods

#### `destroy()`

Cleans up AudioManager resources. Call this when destroying the manager or on game cleanup.

**Example:**
```gml
var audio_mgr = global.Game.Controllers.audioManager;

audio_mgr.destroy();
```

---

## Common Usage Patterns

### Pattern 1: Background Music Loop

```gml
// In level start:
var audio_mgr = global.Game.Controllers.audioManager;
audio_mgr.loopSound(GBreathe);  // Start breathing loop

// In level end:
audio_mgr.stopSound(GBreathe);  // Stop when level ends
```

---

### Pattern 2: Sound Effects During Action

```gml
// When enemy dies:
var audio_mgr = global.Game.Controllers.audioManager;
audio_mgr.playSound(GEnemyDeath);

// When boss appears:
audio_mgr.playSound(GAlert);
audio_mgr.loopSound(GBoss2);  // Switch to boss music
```

---

### Pattern 3: Check Before Playing

```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Only play music if not already looping
if (!audio_mgr.isLooping()) {
    audio_mgr.loopSound(GBreathe);
}
```

---

### Pattern 4: Dynamic Volume Control

```gml
// In pause:
global.Game.Controllers.audioManager.setMasterVolume(0.3);

// In resume:
global.Game.Controllers.audioManager.setMasterVolume(1.0);
```

---

## Sound Asset Reference

### Available Game Sounds

| Sound Asset | Usage | Loopable |
|------------|-------|----------|
| GShot | Player shooting | No |
| GBreathe | Background breathing loop | Yes |
| GChallenging | Challenge stage trigger | No |
| GBee | Enemy destruction (challenge) | No |
| GButterfly | Enemy destruction (challenge) | No |
| GBoss1 | Boss music | Yes |
| GBoss2 | Boss variant music | Yes |
| GRescue | Fighter rescue sequence | Yes |
| GResults | Challenge results screen | No |
| GPerfect | Perfect clear bonus | No |
| GAlert | Alert/transition sound | No |

---

## Implementation Notes

### Backward Compatibility

The legacy wrapper functions (`sound_play()`, `sound_loop()`, `sound_stop()`, `sound_stop_all()`) still work exactly as before, but they now route through AudioManager. This means existing code doesn't need to change immediately, but new code should use AudioManager directly.

**Old way (still works):**
```gml
sound_play(GShot);
sound_loop(GBreathe);
sound_stop(GBreathe);
```

**New way (preferred):**
```gml
var audio_mgr = global.Game.Controllers.audioManager;
audio_mgr.playSound(GShot);
audio_mgr.loopSound(GBreathe);
audio_mgr.stopSound(GBreathe);
```

---

### Error Handling

AudioManager gracefully handles missing or invalid sound IDs:

```gml
// If GInvalidSound doesn't exist, AudioManager will:
// 1. Log an error message
// 2. Return -1
// 3. NOT crash the game

audio_mgr.playSound(GInvalidSound);  // Safely fails
```

---

### Performance Considerations

- **State Tracking:** AudioManager maintains a ds_map of playing sounds for quick lookups
- **Memory:** Minimal overhead (single struct + one ds_map)
- **CPU:** Negligible impact on frame time
- **When to Cleanup:** Call `destroy()` on game shutdown or room change if not using persistent instances

---

## Troubleshooting

### Q: Sound not playing?

**Check:**
1. Is AudioManager initialized? Check for "[AudioManager] Audio management system initialized" in debug output
2. Is the sound asset valid? Verify it exists in the audio resource list
3. Is game paused? Paused games may suppress audio

---

### Q: Multiple loops playing at once?

**Remember:** `loopSound()` automatically stops the previous loop. Only one looping sound plays at a time.

```gml
// This automatically stops the previous loop:
audio_mgr.loopSound(GBreathe);
audio_mgr.loopSound(GBoss2);  // GBreathe stops, GBoss2 starts
```

---

### Q: How to debug which sounds are playing?

```gml
var audio_mgr = global.Game.Controllers.audioManager;

// Check current loop
show_debug_message("Looping: " + string(audio_mgr.getLoopingSound()));

// Check total count
show_debug_message("Total sounds: " + string(audio_mgr.getPlayingSoundCount()));

// Check specific sound
show_debug_message("GShot playing: " + string(audio_mgr.isPlaying(GShot)));
```

---

## Future Enhancements

Potential features for future versions:

1. **Audio Fading** - Fade in/out over N frames
2. **Ducking** - Reduce volume of background during important sounds
3. **Sound Groups** - Group sounds for category-level volume control
4. **Playback Tracking** - Callback when sound finishes
5. **Streaming** - Support for larger audio files
6. **3D Audio** - Positional audio for spatial effects

---

## Migration Guide

To migrate existing code from direct audio calls to AudioManager:

### Before:
```gml
// In Step event:
if (keyboard_check_pressed(vk_space)) {
    audio_play_sound(GShot, 10, false);
}

if (current_level == 1) {
    audio_play_sound(GBreathe, 10, true);
}

if (enemy_health <= 0) {
    audio_stop_sound(GBreathe);
    audio_play_sound(GBoss2, 10, true);
}
```

### After:
```gml
// In Step event:
if (keyboard_check_pressed(vk_space)) {
    global.Game.Controllers.audioManager.playSound(GShot);
}

if (current_level == 1) {
    global.Game.Controllers.audioManager.loopSound(GBreathe);
}

if (enemy_health <= 0) {
    global.Game.Controllers.audioManager.switchLoop(GBreathe, GBoss2);
}
```

---

## Best Practices

1. **Cache the reference:** Avoid repeatedly accessing `global.Game.Controllers.audioManager`
   ```gml
   var audio_mgr = global.Game.Controllers.audioManager;
   audio_mgr.playSound(GShot);
   audio_mgr.playSound(GHit);
   ```

2. **Use helper methods:** For common patterns like switching loops
   ```gml
   // Instead of:
   audio_mgr.stopSound(oldSound);
   audio_mgr.loopSound(newSound);

   // Do this:
   audio_mgr.switchLoop(oldSound, newSound);
   ```

3. **Check state when needed:** Before playing important sounds
   ```gml
   if (!audio_mgr.isPlaying(GBoss1)) {
       audio_mgr.playSound(GBoss1);
   }
   ```

4. **Control volume centrally:** Use master volume for pause/mute
   ```gml
   // On pause:
   global.Game.Controllers.audioManager.setMasterVolume(0.3);
   ```

---

## Testing

See `TestAudioManager.gml` for comprehensive test suite covering:
- Sound playback
- Looping behavior
- Volume control
- State queries
- Error handling
- Edge cases

Run tests with: `runAudioManagerTests()`

---

## Support

For issues or questions about AudioManager:
1. Check the debug output for error messages
2. Review the API Reference section above
3. See Common Usage Patterns for examples
4. Check the test suite for additional examples

---

**Last Updated:** November 14, 2024
**Version:** 1.0
**Status:** Production Ready

