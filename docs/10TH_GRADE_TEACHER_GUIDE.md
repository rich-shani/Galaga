# 10th Grade Computer Science Class - Teacher's Guide
## Galaga Wars: Game Design & Programming
### Complete Lesson Plan for 1-Hour Session (Expandable to 2-3 Hours)

---

## Overview

This lesson introduces 10th-grade computer science students to professional game development using the **Galaga Wars** codebase as a real-world example.

### Learning Objectives

After this lesson, students will:

1. **Understand State Machines**
   - Define what a state machine is
   - Draw state diagrams
   - Recognize state machines in everyday life and software

2. **Understand Object-Oriented Programming (Inheritance)**
   - Explain the DRY principle (Don't Repeat Yourself)
   - Understand inheritance hierarchies
   - Recognize when inheritance is useful

3. **Understand Data-Driven Design**
   - Contrast hardcoded values with configuration files
   - Explain benefits of data-driven architecture
   - Understand JSON structure basics

4. **Understand Error Handling**
   - Recognize defensive programming
   - Explain graceful degradation
   - Understand the difference between crashing and continuing

5. **Understand Professional Code Quality**
   - Recognize design patterns in real code
   - Understand importance of testing
   - See how professional code differs from student code

---

## Materials Needed

### Digital Materials

1. **INTRO_CS_CLASS_10TH_GRADE.md** - Full 60-minute lecture script
2. **10TH_GRADE_PRESENTATION_SLIDES.md** - 60 presentation slides
3. **10TH_GRADE_EXERCISES_AND_ACTIVITIES.md** - 12 interactive activities
4. **Galaga Wars Codebase** - Source code available in repository
5. **GameMaker Studio 2** - For live demonstrations (optional)

### Physical Materials

- Whiteboard and markers
- Projector and screen
- Student paper for drawing diagrams
- Pens/pencils

### Optional

- Running instance of Galaga Wars game to show
- GitHub access to view actual code
- Recording device for capture

---

## Pre-Class Preparation (30 minutes)

### 1. Review the Materials

Read through:
- INTRO_CS_CLASS_10TH_GRADE.md (main lecture)
- 10TH_GRADE_PRESENTATION_SLIDES.md (follow along with these)

### 2. Test Technology

- [ ] Projector/screen displays properly
- [ ] Presentation slides render correctly
- [ ] Galaga Wars runs (if doing live demo)
- [ ] GameMaker Studio 2 is available (optional)
- [ ] GitHub link works (if showing code)

### 3. Prepare Whiteboard

- [ ] Clear board and have markers ready
- [ ] Draw state machine example for reference
- [ ] Have inheritance hierarchy sketch ready

### 4. Print Materials (Optional)

- [ ] Print presentation slides (1 per student or 1 per 2 students)
- [ ] Print activity worksheets
- [ ] Print glossary for reference

### 5. Arrange Room

- [ ] Seats configured to see projector
- [ ] If pair/group work, arrange desks accordingly
- [ ] Have whiteboard visible to all
- [ ] Computer access ready (if doing exercises)

---

## 60-Minute Lesson Plan

### Structure: 5 + 5 + 5 + 20 + 15 + 5 + 3 + 2 = 60 minutes

---

## SEGMENT 1: Opening & Game History (5 min)
**Goal:** Grab attention and provide context

### Opening Hook (1 min)
- Show a screenshot or short video clip of Galaga Wars
- Ask: "Who's played Galaga or similar games?"
- State: "This is **11,000+ lines of real production code** that was actually shipped to players"

### Agenda (1 min)
- Display SLIDE 3: Today's Agenda
- Overview of what they'll learn
- Why it matters for their future

### Galaga History (3 min)
- SLIDES 4-5: Galaga history
- Compare 1981 vs. 2024
- Emphasize: "Same game concept, modern execution"
- Show SLIDE 6: By the Numbers (codebase statistics)

### Transition
"Now let's understand the tools used to build this."

---

## SEGMENT 2: What is GameMaker? (5 min)
**Goal:** Establish context for GameMaker and GML

### Game Engines (2 min)
- SLIDE 7: What is a game engine?
- Use analogy: "Building a house vs. building the nails"
- Games built with: GameMaker, Unity, Unreal, Godot

### GameMaker Features (2 min)
- SLIDES 8-9: GameMaker Studio 2 overview
- Highlight: Visual editor + code
- Show: Example GML code snippet

### Transition
"GameMaker is what makes this game possible. Now let's look at how the code is organized."

---

## SEGMENT 3: The Codebase Overview (5 min)
**Goal:** Help students understand project structure

### Project Organization (2 min)
- SLIDES 10-11: Directory structure and breakdown
- Emphasize: "11,000+ lines organized into 50+ modules"
- Show: Code organized by responsibility (clean architecture)

### Code Statistics (2 min)
- Show pie chart or bar chart of code breakdown
- Highlight: 50% game logic, 30% infrastructure, 20% testing
- Key point: Testing is built in!

### Transition
"Great! Now we understand the project structure. Let's learn the KEY CONCEPTS that make this code work."

---

## SEGMENT 4: Key Programming Concepts (20 min)
**Goal:** Teach 5 core concepts, one at a time

### Concept 1: State Machines (5 min)

**Teaching Method:**
1. Show SLIDE 12: "What's a state machine?"
2. Use traffic light analogy (relatable)
3. Show SLIDE 13: Game state machine with 12 states
4. INTERACTIVE: "What's the next state after ATTRACT_MODE?"
   - (Wait for responses)
5. Show SLIDE 14-15: Code implementation
6. ACTIVITY 1.1 (If time): "Draw the state machine"
   - Have students draw on paper or whiteboard

**Key Teaching Points:**
- Only ONE state at a time
- Clear transitions prevent bugs
- Self-documenting code
- Used everywhere (traffic lights, apps, games)

**Check Understanding:**
- "What would happen if we were in GAME_ACTIVE and PAUSED simultaneously?"
- (Answer: Invalid state! State machine prevents this)

---

### Concept 2: Inheritance (5 min)

**Teaching Method:**
1. Show SLIDE 16: The problem (duplicate code)
2. Ask: "How many lines of duplicate code if NO inheritance?"
   - (Let them think... answer: 3× as much)
3. Show SLIDE 17: The solution
4. Show SLIDE 18: Inheritance hierarchy diagram
5. ACTIVITY 2.1 (If time): "Spot the shared code"

**Key Teaching Points:**
- DRY Principle (Don't Repeat Yourself)
- Parent class = shared code
- Child classes = unique code
- One change fixes all enemies

**Real-World Analogy:**
- Vehicle → Car, Truck, Motorcycle
- Animal → Dog, Cat, Bird
- Enemy → TieFighter, Interceptor, Shuttle

**Check Understanding:**
- "Without inheritance, how many places would we fix a bug in 'take damage'?"
- (Answer: 3 places! With inheritance: 1 place)

---

### Concept 3: Data-Driven Design (5 min)

**Teaching Method:**
1. Show SLIDE 20: The problem (hardcoded waves)
2. Ask: "How long to test one change?"
   - (Wait for responses... answer: 30+ seconds)
3. Show SLIDE 21: The solution (JSON)
4. Ask: "How long with JSON?"
   - (Answer: 1 second!)
5. Show SLIDE 22: Benefits table

**Live Demo (If possible):**
- Open wave_spawn.json file
- Change one enemy type
- Reload game without recompiling
- Show instant feedback

**Key Teaching Points:**
- Separation of code and content
- Non-programmers can modify
- Easy to version control
- Supports modding

**Check Understanding:**
- "Why is JSON better than hardcoding?"
- (Answers: Speed, flexibility, collaboration, modding)

---

### Concept 4: Enums (3 min)

**Teaching Method:**
1. Show SLIDE 23: Magic numbers problem
2. Show SLIDE 24: Enums solution
3. Ask: "Why is `GameMode.GAME_ACTIVE` better than `3`?"
   - (Answers: Readable, prevents mistakes, self-documenting)

**Quick Code Example:**
```gml
// BAD: What does 3 mean?
if (global.gameMode == 3) { ... }

// GOOD: Crystal clear!
if (global.gameMode == GameMode.GAME_ACTIVE) { ... }
```

**Key Teaching Points:**
- Names are better than numbers
- IDE autocomplete helps
- Professional standard

---

### Concept 5: Error Handling (2 min)

**Teaching Method:**
1. Show SLIDE 25: Crashes from missing assets
2. Show SLIDE 26: Safe functions solution
3. Emphasize: "Game continues instead of crashing"

**Key Teaching Points:**
- Defensive programming
- Graceful degradation
- Better user experience
- Production-quality code

---

## SEGMENT 5: Design Patterns in Action (15 min)
**Goal:** Show real applications of concepts

### Pattern 1: Object Pooling (4 min)
- SLIDES 28-29: Problem and solution
- **Key Point:** 2,400 objects created/destroyed per second = stuttering
- **Solution:** Reuse 50 objects = smooth 60 FPS
- Real-world impact: Player never notices hiccups

### Pattern 2: Event System (4 min)
- SLIDES 30-31: GameMaker object lifecycle
- Show CREATE → STEP → DRAW → COLLISION → DESTROY
- Explain when each runs
- **Example:** Enemy birth to death

### Pattern 3: State Machines in Objects (4 min)
- SLIDE 32: Enemy states (ENTER_SCREEN, IN_FORMATION, etc.)
- Show state transitions in code
- **Key Point:** Each object manages its own state

### Pattern 4: Formation System (3 min)
- SLIDE 33: 5×8 grid positioning
- Explain grid assignment by INDEX
- Shows organized, choreographed movement

---

## SEGMENT 6: Live Code Walkthrough (5 min)
**Goal:** Show complete enemy lifecycle in code

### Follow SLIDES 34-39: Enemy Creation Flow

**Step-by-step:**
1. Game decides to spawn (SLIDE 34)
2. Read JSON configuration (SLIDE 35)
3. Safely get enemy type (SLIDE 36)
4. Create enemy instance (SLIDE 37)
5. Enemy's Create event runs (SLIDE 38)
6. Every frame: Update and draw
7. If hit: Collision event
8. When destroyed: Cleanup

**Interactive Element:**
- Ask students to predict what happens at each step
- Reveal the actual code
- Celebrate correct predictions

**Key Realization:**
"This entire sequence happens because of good design. Without it, this would be chaos."

---

## SEGMENT 7: Testing & Error Handling (3 min)
**Goal:** Show importance of testing and robustness

### Testing Framework (1.5 min)
- SLIDES 40-42: Why test, what tests exist
- Galaga Wars has 9 test suites with ~2,000 lines
- Tests run in 2 seconds
- Catch bugs immediately

### Error Handling Philosophy (1.5 min)
- SLIDES 43-44: Logging system
- Players prefer game that continues over crashes
- Errors logged to file for debugging post-release

**Key Point:**
"Professional code expects things to go wrong and handles it gracefully."

---

## SEGMENT 8: Closing & Q&A (2 min)
**Goal:** Summarize and answer questions

### Key Takeaways (1 min)
- SLIDE 50: "Good code is like good writing"
- Code should explain itself
- Professional patterns appear everywhere

### Resources for Learning (Optional)
- SLIDE 54: List of books, websites, courses
- GameMaker manual
- Game Programming Patterns book (free online)

### Questions (1 min)
- "Any questions?"
- "What was most interesting?"
- "What would you build?"

---

## Extension Activities (If Time Available)

### Shorter Timeframe (adjust 5-min segments):
- Skip some code examples
- Skip pattern details
- Focus on core 5 concepts

### Longer Format (90 min - 2 hours):
- Include ACTIVITY 1.1: Draw state machine (10 min)
- Include ACTIVITY 2.1: Spot shared code (10 min)
- Include ACTIVITY 3.1: Hardcoding vs. JSON (10 min)
- Include ACTIVITY 8.1: Code tracing (10 min)

### Full Workshop (3+ hours):
- All of the above
- Plus ACTIVITY 10: Creative challenges (20 min)
- Plus ACTIVITY 11: Research project (30 min)

---

## Assessment Methods

### Formative Assessment (During Class)
- Ask questions and observe responses
- "Draw the state machine on the board"
- "What happens if...?" scenario questions
- Pair discussion: "Explain inheritance to your neighbor"

### Quick Check Quiz (5 min)
```
1. What is a state machine?
2. Draw the game state machine
3. Why use inheritance?
4. What's data-driven design?
5. What does error handling do?
```

### Activity-Based Assessment
- Quality of state machine drawings
- Completeness of written responses
- Depth of creative challenge solutions

### Summative Assessment (Post-Class)
- Design document for new game state
- Code analysis of Galaga Wars
- Research project on game architecture
- Reflection journal

---

## Differentiation Strategies

### For Struggling Students
- Pair with stronger students
- Provide more scaffolding (sentence starters)
- Focus on Activities 1-5 only
- Use simpler code examples
- Allow more time for processing

### For Advanced Students
- Challenge them to improve code
- Ask "what if..." questions
- Assign research projects
- Have them explain concepts to peers
- Discuss scalability to 1000+ enemies

### For Different Learning Styles

**Visual Learners:**
- Use plenty of diagrams
- Color-code state machines
- Show code on projector with syntax highlighting
- Videos (optional)

**Auditory Learners:**
- Lecture clearly with good pacing
- Use real-world analogies
- Discuss concepts with peers
- Ask/answer questions verbally

**Kinesthetic Learners:**
- Draw state machines by hand
- Code simple examples
- Build with blocks/Legos (pattern analogy)
- Walk through state machine on floor

---

## Common Misconceptions & Clarifications

### Misconception 1: "Enums are just numbers"
**Clarification:** Enums are symbolic names that the compiler replaces with numbers. They're for human readability.

### Misconception 2: "Inheritance is always good"
**Clarification:** Deep inheritance hierarchies can become confusing. Use inheritance when objects share behavior.

### Misconception 3: "Error handling is for crashes"
**Clarification:** Error handling makes games continue running with reduced functionality. Better UX.

### Misconception 4: "You can't change games once shipped"
**Clarification:** With data-driven design, you can change behavior by changing JSON (no recompiling needed).

### Misconception 5: "Professional code is always perfect"
**Clarification:** Professional code is tested, documented, and refined over time. Never perfect on day one.

---

## Classroom Management Tips

### Engagement
- Ask questions frequently ("What happens if...?")
- Use "think-pair-share" (30 seconds thinking, pair discussion, share)
- Use enthusiasm - you're teaching about games!
- Show the game running (motivates students)

### Pacing
- Stick to timing (don't go too deep on one topic)
- Watch for eyes glazing over - that's a signal to move on
- Use transitions: "Now let's see how this is actually coded"
- Pause after big ideas (let them sink in)

### Participation
- Cold call: "Sarah, what's the next state?"
- Pair work: Quieter students more likely to engage
- Whiteboard: Ask volunteers to draw
- Hands up: "Everyone predict what happens next"

### Questions
- If stuck: "Let's look at the code and see..."
- If off-topic: "Great question! Let's chat after class"
- If no hands: "Talk to neighbor for 30 seconds"
- Celebrate wrong answers: "Good thinking! Here's why it's different..."

---

## Technology Troubleshooting

### If Projector Fails
- Distribute printed slides
- Use whiteboard to draw concepts
- Code examples from memory/notes

### If GameMaker Won't Run
- Prepare screenshots/video in advance
- Draw state machines on board instead
- Use only code examples on slides

### If Students Lack Computer Access
- Pair programming (one computer, two people)
- Print worksheets for paper-based activities
- Use whiteboard for drawing exercises

### If You Get Behind Schedule
- Cut the code walkthrough (Segment 6) to 3 minutes
- Skip some pattern details (Segment 5)
- Focus on core 5 concepts
- Do activities asynchronously (homework)

---

## Post-Class Follow-Up

### Day After Class
- Send reflection survey (what did you learn?)
- Post activity answer key
- Encourage students to download codebase

### One Week Later
- Mini-quiz on state machines
- "Show and tell": Students design state machine for their favorite game
- Discussion: Which concept was hardest?

### Ongoing
- Reference Galaga Wars when teaching OOP later
- Use examples: "Remember the enemy states?"
- Build on concepts in future units

---

## Student Handout: Key Concepts Summary

Consider providing students with this reference:

```markdown
# Galaga Wars: Key Concepts

## 1. State Machines
- One state at a time
- Clear transitions
- Prevents invalid combinations
- Example: Traffic light (Red → Yellow → Green)

## 2. Inheritance
- DRY Principle (Don't Repeat Yourself)
- Parent class = shared code
- Child classes = unique code
- Example: TieFighter inherits from EnemyBase

## 3. Data-Driven Design
- Configuration in JSON files
- Change behavior without recompiling
- Supports modding
- Example: wave_spawn.json defines enemy waves

## 4. Error Handling
- Defensive programming
- Graceful degradation
- Game continues instead of crashing
- Example: safe_get_asset() returns default if asset missing

## 5. Enums
- Names instead of magic numbers
- Self-documenting code
- IDE autocomplete support
- Example: GameMode.GAME_ACTIVE vs. 3

## Resources
- INTRO_CS_CLASS_10TH_GRADE.md
- GameMaker manual: https://manual.yoyogames.com
- Game Programming Patterns (free): https://gameprogrammingpatterns.com
```

---

## Feedback & Iteration

### After Each Class
- Note what worked well
- Note what needs improvement
- Track student understanding
- Adjust timing for next session

### Questions for Reflection
- Did students engage?
- Were there confused faces?
- Did activities take longer than expected?
- Which concept was hardest to explain?
- Which visuals were most helpful?

### Ideas for Improvement
- More examples?
- More hands-on activities?
- Less technical depth?
- More game-playing demos?
- Different order of concepts?

---

## Additional Resources for Teachers

### Learning More About GameMaker
- Official GameMaker Manual: https://manual.yoyogames.com
- GameMaker Community: https://forum.yoyogames.com

### Game Development Concepts
- Game Programming Patterns: https://gameprogrammingpatterns.com (free!)
- Game Development Articles: https://www.gamedev.net

### Teaching Computer Science
- CSTA Standards: https://www.csteachers.org/page/standards
- Computer Science Principles: https://www.cscie.org

### Code Examples
- Galaga Wars Repository: (local directory)
- Other open-source games on GitHub

---

## Standards Alignment

### CSTA (Computer Science Teachers Association) Standards Met

**Algorithm & Programming:**
- 3A-DA-09: Program with functions and parameters
- 3A-AP-13: Create classes in object-oriented language
- 3B-AP-08: Describe how artificial intelligence drives many programs

**Computing Systems:**
- 3A-CS-01: Evaluate whether resources are being used effectively

**Data & Analysis:**
- 3A-DA-11: Create computational models to understand systems

---

## License & Attribution

This lesson plan is based on the **Galaga Wars** codebase, a production game demonstrating professional programming practices.

Feel free to adapt this lesson for your classroom, but please:
- Credit the original Galaga Wars project
- Give students proper citations
- Link to original repository

---

## Support

If you have questions about this lesson plan:
1. Review INTRO_CS_CLASS_10TH_GRADE.md (main lecture script)
2. Check ARCHITECTURE.md in codebase (technical details)
3. Review DEVELOPER_GUIDE.md (code organization)
4. Consult QUICK_REFERENCE.md (quick lookup)

---

**Created: November 16, 2024**
**For: 10th Grade Computer Science**
**Duration: 60 minutes (expandable)**
**Audience: Students new to programming or game development**
**Format: Markdown (for flexibility and distribution)**

---

## Quick Reference: What File to Use When

| Need | File | Duration |
|------|------|----------|
| Teach the lesson | INTRO_CS_CLASS_10TH_GRADE.md | 60 min |
| Show slides | 10TH_GRADE_PRESENTATION_SLIDES.md | (follow along) |
| Give students activities | 10TH_GRADE_EXERCISES_AND_ACTIVITIES.md | 1-2 hours |
| Plan the class | This file (TEACHER_GUIDE.md) | 30 min prep |
| Deep dive on code | ARCHITECTURE.md in codebase | (reference) |
| Understand modules | QUICK_REFERENCE.md in codebase | (lookup) |
| Live demo code | DEVELOPER_GUIDE.md in codebase | (reference) |

---

Good luck with your class! This material is designed to be engaging, educational, and inspiring. Students will see that professional code isn't magic - it's well-organized patterns applied thoughtfully.

The goal: Students leave saying "I could build a game like that!"
