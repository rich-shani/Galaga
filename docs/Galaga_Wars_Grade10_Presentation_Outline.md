# Galaga Wars: Game Design & Programming
## PowerPoint Outline for Grade 10 High School Class

Use this outline to build slides in PowerPoint, or run `Tools/create_galaga_presentation.py` to auto-generate the .pptx (requires `pip install python-pptx`).

---

## Slide 1: Title
**Title:** Galaga Wars: Game Design & Programming  
**Subtitle:** A Grade 10 Overview of a Real Game Project — How games are built with GameMaker Studio

---

## Slide 2: What is GameMaker Studio?
**Title:** What is GameMaker Studio?

**Bullets:**
- GameMaker Studio is a 2D game engine used by indie and professional developers.
- You design your game using:
  - **Sprites** (images), **Objects** (things in the game), **Rooms** (levels/screens)
  - **Scripts** (code) written in **GML** (GameMaker Language)
  - **Events**: Create, Step, Draw, Collision, etc.
- Games can be exported to: Windows, Mac, HTML5 (browser), consoles.
- Used for games like: Hyper Light Drifter, Undertale, and many mobile games.

---

## Slide 3: Why GameMaker for This Project?
**Title:** Why GameMaker for Galaga Wars?

**Bullets:**
- Perfect for 2D arcade-style games (like the original Galaga from 1981).
- Visual editor + code: design levels and logic without only typing code.
- Built-in features: collisions, sprites, sounds, rooms.
- Export to web (HTML5) so anyone can play in a browser.
- Same concepts (sprites, objects, state machines) appear in bigger engines like Unity.

---

## Slide 4: Galaga Wars – Project Structure
**Title:** Galaga Wars – Project Structure

**Bullets:**
- **sprites/** — All images (ships, explosions, UI). E.g. sImperialShuttle, sTieFighter.
- **objects/** — Things in the game: oPlayer, oTieFighter, oGameManager, oTitleScreen.
- **scripts/** — Reusable code: WaveSpawner, ScoreManager, ObjectPool, GameConstants.
- **rooms/** — Screens: SplashScreen, TitleScreen, GalagaWars (main game).
- **datafiles/Patterns/** — JSON config: wave spawns, formation data, game_config.
- **shaders/** — Visual effects (e.g. CRT scanline effect).
- **sounds/** — Music and sound effects.

---

## Slide 5: Key Elements of Galaga Wars
**Title:** Key Elements of Galaga Wars

**Bullets:**
- **Game flow:** Splash → Title → Play → Results → High Score entry.
- **Enemies:** TIE Fighter, TIE Interceptor, Imperial Shuttle (each with different behaviour).
- **Formation:** 5×8 grid of enemies; they dive, loop, and attack.
- **Challenge stages:** Bonus rounds every 4 levels.
- **Tractor beam:** Imperial Shuttle can capture the player ship.
- **Score & lives:** Extra lives at 20,000 and every 70,000 points.

---

## Slide 6: 2D Sprites That Look Like 3D Rotation
**Title:** 2D Sprites That Look Like 3D Rotation

**Bullets:**
- Games like this are **2D**: everything is flat images on the screen.
- To make a ship look like it’s **rotating**, we don’t use real 3D – we use **many 2D images**.
- Each image is one “angle” of the ship (like a flipbook).
- **Example:** sImperialShuttle is one sprite made of **24 separate images**.
- As the ship moves or turns, the game switches which image (frame) is shown.
- 24 frames = 24 different angles → smooth rotation effect (about 15° per frame).

---

## Slide 7: sImperialShuttle – 24 Frames for One Rotation
**Title:** sImperialShuttle: 24 Frames for One Rotation

**Bullets:**
- **Sprite name:** sImperialShuttle (Imperial Shuttle enemy).
- **Total frames:** 24 images in one sprite (see `sprites/sImperialShuttle/`).
- Each frame = one view of the shuttle (e.g. every 15° around a circle).
- In GameMaker: one “sprite” can have many “sub-images” (frames).
- Code uses **image_index** or **image_speed** to show the right frame.
- Same idea used for: **sTieFighter**, **sTieIntercepter** (multiple frames each).
- **Result:** On screen the ship appears to rotate smoothly, but it’s just 2D art.

---

## Slide 8: How the Game Is Coded – Big Ideas
**Title:** How the Game Is Coded – Big Ideas

**Bullets:**
- **State machines:** Game has “modes” (title, playing, results). Enemies have states (formation, diving, looping).
- **Data-driven design:** Levels and behaviour come from JSON files, not only from code.
- **Object pooling:** Instead of creating/destroying bullets and explosions constantly, we reuse them (better performance).
- **Managers:** One object (e.g. oGameManager) coordinates others (spawning, score, challenges).
- **Events:** Create (when object appears), Step (every frame), Draw (every frame draw), Collision (when two things hit).

---

## Slide 9: Code Structure – Who Does What
**Title:** Code Structure – Who Does What

**Bullets:**
- **oGlobal (Create):** Loads JSON, sets up global.Game, creates managers.
- **oGameManager:** Runs the main loop; switches game state (attract, play, results); calls WaveSpawner, ScoreManager.
- **WaveSpawner:** Reads wave_spawn.json; spawns the right enemies at the right positions.
- **Enemy objects** (e.g. oImperialShuttle): Have a state (formation / dive / loop); change sprite frame for rotation.
- **oPlayer:** Handles input, firing, collisions with enemies and bullets.

---

## Slide 10: What It Takes to Create a Polished Game
**Title:** What It Takes to Create a Polished Game

**Bullets:**
- **Planning:** Design documents, lists of features, and a clear “loop” (what the player does again and again).
- **Art & audio:** Many sprites (e.g. 24 per rotating ship), animations, sounds, music.
- **Code quality:** Organized scripts, clear names, state machines so behaviour is predictable.
- **Data:** Config files (JSON) so designers can change waves/difficulty without touching code.
- **Testing:** Play often; fix bugs; make sure it runs smoothly (e.g. 60 FPS).
- **Polish:** Effects (explosions, screen shake, CRT effect), feedback (sounds, score pop), and clear UI.

---

## Slide 11: Polished Game – Summary
**Title:** Polished Game – Summary

**Bullets:**
- **Consistent quality:** Menus, gameplay, and “game over” all feel part of the same game.
- **Performance:** Object pooling and simple 2D graphics help keep the game smooth.
- **Feedback:** Player always knows what’s happening (score, lives, sounds, visual effects).
- **This project:** 11,000+ lines of code, 40+ scripts, 35+ objects, 100+ assets – all for one arcade-style game.
- **Takeaway:** Even “simple” games need structure, data, and lots of small details to feel polished.

---

## Slide 12: Questions?
**Title:** Questions?

**Subtitle:** Try the game: run from GameMaker (F5) or play the web version. Look at `sprites/sImperialShuttle` to see the 24 rotation frames.

---

## Notes for Teacher
- **sImperialShuttle:** 24 PNG files in `sprites/sImperialShuttle/`; sequence length 24, playback speed 8 (see `sprites/sImperialShuttle/sImperialShuttle.yy`).
- **TIE sprites:** sTieFighter and sTieIntercepter also use multiple frames for rotation.
- **Architecture:** See `docs/ARCHITECTURE.md` and `docs/QUICK_REFERENCE.md` for more detail.
- **Existing slides:** `10TH_GRADE_PRESENTATION_SLIDES.md` has more slides if you want to extend the presentation.
