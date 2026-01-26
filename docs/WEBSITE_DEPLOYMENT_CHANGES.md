# Website Deployment Changes

**Date:** 2024  
**Purpose:** Document all changes made to deploy Galaga Wars as a playable web version

---

## Overview

This document outlines all modifications made to the codebase to successfully deploy Galaga Wars as a web-based game. The changes include HTML/CSS updates, JavaScript fixes, GameMaker HTML5 compatibility fixes, and browser-specific workarounds.

---

## Table of Contents

## Game Page Fixes

### 6. GameMaker Initialization Error Fix
**File:** `Website/gamedata/index.html`

**Problem:** `Uncaught ReferenceError: GameMaker_Init is not defined`

**Solution:** Added defensive initialization code that:
- Checks if `GameMaker_Init` exists before calling
- Waits for script to load if not immediately available
- Includes timeout handling (10 seconds)
- Wraps initialization in try-catch for graceful error handling

**Code Added:**
```javascript
window.onload = function() {
    if (typeof GameMaker_Init !== 'undefined') {
        GameMaker_Init();
    } else {
        // Wait for script to load with interval checking
        const checkInit = setInterval(function() {
            if (typeof GameMaker_Init !== 'undefined') {
                GameMaker_Init();
                clearInterval(checkInit);
            }
        }, 100);
        // Timeout after 10 seconds
        setTimeout(function() {
            clearInterval(checkInit);
            if (typeof GameMaker_Init === 'undefined') {
                console.error('GameMaker_Init function not found...');
            }
        }, 10000);
    }
};
```

---

### 7. Deprecated Meta Tag Fix
**File:** `Website/gamedata/index.html`

**Problem:** `<meta name="apple-mobile-web-app-capable" content="yes">` is deprecated

**Solution:** Replaced with modern standard:
```html
<meta name="mobile-web-app-capable" content="yes" />
```

---

### 8. CSS Background Color Fix
**File:** `Website/gamedata/index.html`

**Problem:** Invalid CSS `background: #0;` (should be `#000` or `#000000`)

**Solution:** Changed to valid hex color:
```css
background: #000;
```

---

### 9. Canvas Scaling for Responsive Display
**File:** `Website/gamedata/index.html`

**Problem:** Game canvas (896x1152) didn't scale to fit different screen sizes.

**Solution:** Added JavaScript scaling function that:
- Maintains 896:1152 aspect ratio
- Scales to fit viewport (width or height, whichever is more restrictive)
- Updates on window resize and orientation change
- Centers canvas on page

**Key Features:**
- Responsive scaling for desktop, tablet, and mobile
- Maintains game's original aspect ratio
- Smooth resizing on window/orientation changes

---

## GameMaker JavaScript Fixes

### 10. JavaScript Syntax Error Fix
**File:** `Website/gamedata/html5game/Galaga.js`

**Problem:** `Uncaught SyntaxError: Unexpected token '{'` at line 3423

**Error Location:**
```javascript
function _Z33{}function __33(){
```

**Solution:** Fixed missing parentheses in function definition:
```javascript
function _Z33(){}function __33(){
```

**Note:** This is a generated file. If the game is re-exported from GameMaker, this fix may need to be reapplied.

---

### 11. Audio Initialization Error Handling
**File:** `Website/gamedata/index.html`

**Problem:** `Uncaught { message : "unable to convert undefined to a number" }` in audio system

**Solution:** Added multiple layers of error handling:
1. Global error handler for GameMaker runtime errors
2. Unhandled promise rejection handler
3. Try-catch blocks around game initialization
4. Fixed JavaScript function `_Z9` to check for undefined before conversion

**Additional Fix:** Modified `_Z9` function in `Galaga.js` to check if `_y9._0a` is undefined before calling `__9()`.

## Browser Audio Policy Handling

### 13. Audio Unlock Overlay
**File:** `Website/gamedata/index.html`

**Problem:** Modern browsers block autoplay audio until user interaction. Game audio wouldn't work on first load.

**Solution:** Added comprehensive audio unlock system:

1. **Visual Overlay:**
   - Full-screen overlay with "Click to Enable Audio" message
   - Styled with retro green text and black background
   - Appears on page load

2. **Audio Context Unlocking:**
   - Creates and resumes AudioContext on user interaction
   - Plays silent buffer to unlock audio
   - Attempts to unlock GameMaker's Web Audio context if available

3. **Multiple Unlock Triggers:**
   - Primary: "Enable Audio & Start Game" button
   - Fallback: Any click, touch, or keypress on the page
   - Canvas interaction handlers

4. **Game Initialization:**
   - Game initializes after user interaction
   - Ensures audio context is ready before game starts

**Code Features:**
```javascript
function unlockAudio() {
    // Create AudioContext and resume if suspended
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
        const audioContext = new AudioContext();
        if (audioContext.state === 'suspended') {
            audioContext.resume();
        }
        // Play silent buffer to unlock
        const buffer = audioContext.createBuffer(1, 1, 22050);
        const source = audioContext.createBufferSource();
        source.buffer = buffer;
        source.connect(audioContext.destination);
        source.start(0);
    }
}
```

**Impact:** Audio now works correctly on all modern browsers after user interaction.

---

## Summary of All Changes

### Files Modified

**Website Files:**
- `Website/gamedata/index.html` - Game page fixes, scaling, audio unlock
- `Website/gamedata/html5game/Galaga.js` - JavaScript syntax fix

## Notes for Future Exports

### Generated Files
The following files are generated by GameMaker and may need fixes reapplied after re-export:

1. **`Website/gamedata/html5game/Galaga.js`**
   - Check line ~3423 for `function _Z9()` syntax
   - May need to reapply syntax fix if error reappears

2. **`Website/gamedata/index.html`**
   - GameMaker may overwrite customizations
   - May need to reapply:
     - GameMaker_Init error handling
     - Canvas scaling code
     - Audio unlock overlay

---
