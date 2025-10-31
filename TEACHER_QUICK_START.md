# Galaga Wars Presentation: Teacher Quick Start Guide
## Get Started in 5 Minutes

---

## TL;DR (Too Long; Didn't Read)

**You have 4 files:**
1. **AP_CS_PRESENTATION.md** ← Read this for lecture material
2. **PRESENTATION_SLIDES.md** ← Convert to Powerpoint/Google Slides
3. **STUDENT_EXERCISES.md** ← Assign as homework
4. **PRESENTATION_README.md** ← Full documentation

**To teach in 50 minutes:**
1. Use slides 1-10 (15 min lecture)
2. Show code example 1 (10 min walkthrough)
3. Do exercise 1.1 as group activity (20 min)
4. Assign exercise 1.2 as homework

---

## File Purposes at a Glance

| File | Use For | Time |
|------|---------|------|
| AP_CS_PRESENTATION.md | Reading/detailed teaching material | 20-30 min read |
| PRESENTATION_SLIDES.md | Creating your presentation | 45-60 min teach |
| STUDENT_EXERCISES.md | Homework and assessment | Varies by exercise |
| PRESENTATION_README.md | Full context and planning | Reference |
| **THIS FILE** | **Getting started quickly** | 5 min read |

---

## One-Page Teaching Summary

### What This Unit Teaches
**Big Question:** How do professional programmers write 2500+ lines of game code that runs smoothly, is easy to modify, and handles errors gracefully?

**Answer:** Using proven design patterns and best practices.

### Key Concepts (5 topics)
1. **State Machines** - Clear, logical flow through game states
2. **Inheritance** - Reusing code across similar objects
3. **Data-Driven Design** - Separate code from content
4. **Error Handling** - Graceful failure and recovery
5. **Game Loops** - Coordinating everything each frame

### Why Students Care
- **Game developers:** This is how real games are built
- **Web developers:** React and Angular use similar patterns
- **All programmers:** These skills apply to any large project

---

## 30-Second Elevator Pitch to Your Class

"Today we're studying **real production code** from an actual game shipped to players. We'll learn **design patterns** used by professional game studios, and you'll see how **2500 lines of code** can be organized so cleanly that adding a new feature takes minutes instead of hours. By the end of this unit, you'll be able to **design and build your own game.**"

---

## Quickest Start (Single 50-Minute Class)

### Prep (10 minutes)
1. Copy Slide 1-10 into Google Slides/Powerpoint
2. Read Example 1 (State Machines) from main presentation
3. Print Exercise 1.1 (Draw state diagram)

### Teach (50 minutes)
- **00-02 min:** Show Slide 1 (title), engage interest
- **02-12 min:** Slides 2-4 (what is Galaga Wars, why study it)
- **12-22 min:** Slides 6-7 (state machines) + short code walkthrough
- **22-42 min:** Exercise 1.1 (students draw state diagram) + share results
- **42-50 min:** Preview next lesson, assign Exercise 1.2 as homework

### Success Criteria
- ✓ Students can draw a state machine diagram
- ✓ Students understand why it's better than flags
- ✓ Students are curious about game development

---

## One-Week Unit Plan (5 Days)

### Day 1: Introduction & State Machines
**Materials:** Slides 1-9, Example 1, Exercises 1.1-1.2
**Activities:** Lecture, diagram drawing, discussion

### Day 2: Object-Oriented Programming
**Materials:** Slides 10-12, Example 2, Exercises 2.1-2.2
**Activities:** Code walkthrough, group design activity

### Day 3: Data-Driven Design
**Materials:** Slides 16-18, Example 3, Exercises 3.1-3.2
**Activities:** JSON writing, level design challenge

### Day 4: Error Handling & Code Quality
**Materials:** Slides 21-24, Examples 4-5, Exercises 4.1-4.2
**Activities:** Bug identification, safe function writing

### Day 5: Synthesis & Assessment
**Materials:** Exercise Set 6 (Design Your Game), Discussion Questions
**Activities:** Game design presentations, peer feedback, quiz

---

## Customization Checklist

- [ ] Read main presentation (20-30 min)
- [ ] Choose which topics to teach (state machines + inheritance minimum)
- [ ] Convert slides to Powerpoint/Google Slides (30 min)
- [ ] Select relevant exercises for your class level
- [ ] Create quiz questions from discussion questions
- [ ] Decide on final project (Exercise 6.1 and 6.2)
- [ ] Plan office hours for extra help

---

## If You Only Have 20 Minutes

**Show:**
- Slide 1-3 (title, what is Galaga)
- Slides 6-7 (state machine concept)
- Quick code example (5 min)

**Activities:**
- "Draw the state machine!" (individual, 5 min)
- Share student work (2 min)
- "Can you see this pattern in other games?" (discussion, 3 min)

**Homework:**
- Read pages 1-5 of main presentation
- Complete Exercise 1.1

---

## If You Have 2 Weeks

**See "2-Week Unit Plan" in PRESENTATION_README.md for detailed breakdown**

Quick version:
- **Week 1:** 3 topics (State Machines, Inheritance, Data-Driven)
- **Week 2:** 2 topics (Error Handling, Integration), then game design project

---

## If You Have a Full Semester

**Integrate throughout the year:**
- Sept/Oct: State Machines & Game Flow
- Nov/Dec: OOP & Inheritance
- Jan/Feb: Data Structures (connect to JSON)
- Mar/Apr: Error Handling & Defensive Programming
- May/Jun: Capstone project (design your own game)

---

## Assessment Ideas (Pick One)

### Quick Quiz (10 minutes)
```
1. What are game states? Give 3 examples.
2. Why use a state machine instead of flags?
3. What does inheritance solve?
4. Why use JSON for game content?
5. What happens if error handling is missing?
```

### Design Challenge (30 minutes)
"Design a state machine for [parking meter / ATM / vending machine / your choice]"

### Code Analysis (20 minutes)
Review provided code snippet and identify design patterns used.

### Game Design Document (1 week project)
Students write 2-3 page design doc for their own game (Exercise 6.1)

### Implementation (2-3 week project)
Students code a simple game prototype (Exercise 6.2)

---

## Common Student Questions & Answers

**Q: "Why is this relevant? I don't want to make games."**
A: "These design patterns show up in web apps, mobile apps, robotics, and everywhere. Understanding how to structure 2500 lines of code makes you a better programmer period."

**Q: "Can we make the game easier/harder?"**
A: "Yes! That's exactly what Exercise 3 is about. The JSON controls difficulty without changing code."

**Q: "How long would this game take to make?"**
A: "Galaga Wars took several weeks by experienced developers. You'll understand the architectural decisions they made."

**Q: "Can I add my own features?"**
A: "After learning the patterns, absolutely! The architecture is designed for modification."

---

## Troubleshooting

### Problem: "Students don't get state machines"
**Solution:** Use real-world analog (traffic light, elevator, video game console)
- Draw the states
- Draw the transitions
- Ask: "Can the light be red AND green at the same time?"

### Problem: "Code examples are hard to understand"
**Solution:** Walk through line by line
- What does this line do?
- Why does it need to be here?
- What would break if we removed it?

### Problem: "Students finish at different paces"
**Solution:** Have extensions ready
- Additional exercises from Exercise Set 5+
- Challenge problems
- Early access to Project exercises

### Problem: "I don't know GML well enough"
**Solution:** Focus on concepts, not syntax
- Pseudocode instead of actual GML
- Emphasize patterns, not language features
- Direct students to manual for specific syntax

### Problem: "No time for full unit"
**Solution:** Reduce scope
- Pick 2 topics instead of 5
- Do 1-2 exercises per student instead of all
- Use presentation as asynchronous learning

---

## Required Materials

### Absolutely Need:
- This presentation package (you have it!)
- Projector/monitor to display slides
- Paper for students to draw diagrams
- Google Slides or Powerpoint

### Nice to Have:
- Copy of Galaga Wars game (to show running)
- GameMaker Studio 2 (free version available)
- Video examples of state machines in other games
- Guest speaker (game developer)

### Optional:
- Virtual field trip to game studio
- Online classroom for homework submission
- Discussion board for peer help

---

## Day-of-Teaching Checklist

**Before Class (5 minutes before)**
- [ ] Projector works and is focused
- [ ] Slides are loaded and ready
- [ ] You've read the main presentation
- [ ] Exercises are printed or ready to share
- [ ] You have the code examples available

**Start of Class**
- [ ] Arrive 10 minutes early
- [ ] Greet students as they arrive
- [ ] Take attendance
- [ ] Quick icebreaker ("What's your favorite game?")

**During Lesson**
- [ ] Stick to time allocation
- [ ] Pause for questions
- [ ] Have students do group discussion
- [ ] Move around the room
- [ ] Collect feedback (quick poll at end)

**End of Class**
- [ ] Summarize key points (2 min)
- [ ] Assign homework clearly
- [ ] Answer lingering questions
- [ ] Preview next lesson

---

## Sample Homework Assignments

### After Lesson 1 (State Machines)
- Complete Exercise 1.2 (code traffic light)
- Read "State Machine Pattern" section from main presentation
- Bring 3 examples of state machines from your life

### After Lesson 2 (Inheritance)
- Complete Exercise 2.2 (design new enemy type)
- Answer: "Why is inheritance better than copying code?"
- Draw inheritance diagram for 3 objects

### After Lesson 3 (Data-Driven)
- Complete Exercise 3.1 (design a wave)
- Explain: "Why change JSON instead of code?"
- Design 3 different difficulty levels

### Major Project
- Exercise 6.1: Game Design Document (5-7 pages, 1 week)
- Exercise 6.2: Simple game implementation (2-3 weeks)
- Present to class (10-15 min per student)

---

## Grading Rubric (Simple Version)

### Understanding (25%)
- Can explain state machines
- Can identify design patterns
- Can describe why each pattern matters

### Application (25%)
- Can draw diagrams correctly
- Can write basic code
- Can complete exercises

### Analysis (25%)
- Can compare approaches
- Can identify design decisions
- Can explain tradeoffs

### Creation (25%)
- Can design new systems
- Can write original code
- Can present ideas clearly

---

## After the Unit: What's Next?

### For Interested Students
- Explore full GameMaker manual
- Start own game project
- Join game jam (48-hour competition)
- Learn Unity or Unreal Engine
- Study computer science in college

### Extension Paths
- **Game Developer:** GameMaker, Unity, Unreal
- **Web Developer:** React/Angular use similar patterns
- **Systems Programmer:** Video game industry
- **Software Engineer:** Any company (all large projects use these patterns)

---

## Student Feedback to Gather

At end of unit, ask:

**Quick Survey (2 minutes):**
1. How clear was the material? (1-5)
2. Which topic was most interesting?
3. What was most confusing?
4. Would you take more CS classes?
5. Would you try game development?

**Open Feedback:**
"What was one thing you learned? What's one thing you'd like to learn more about?"

---

## Resources You'll Use Most

1. **AP_CS_PRESENTATION.md** - For lecture prep
2. **PRESENTATION_SLIDES.md** - For teaching
3. **STUDENT_EXERCISES.md** - For homework/assessment
4. **PRESENTATION_README.md** - For reference/planning
5. **GameMaker Manual** - For GML syntax questions

---

## Quick Links

| Resource | Where |
|----------|-------|
| Main Presentation | AP_CS_PRESENTATION.md |
| Slides | PRESENTATION_SLIDES.md |
| Exercises | STUDENT_EXERCISES.md |
| Full Docs | PRESENTATION_README.md |
| GameMaker | https://gamemaker.io |
| Design Patterns | https://gameprogrammingpatterns.com |
| This Guide | TEACHER_QUICK_START.md |

---

## Final Tips

1. **Start simple** - Don't try to teach everything in one day
2. **Use examples** - Real code is clearer than abstract explanations
3. **Engage students** - Ask questions, get them drawing/coding
4. **Show the "why"** - Not just "how" but "why design it this way"
5. **Let them build** - Exercise 6 is where magic happens
6. **Celebrate effort** - First version won't be perfect, and that's great
7. **Show real applications** - "This matters because..."

---

## You've Got This! 🚀

**Remember:** You're teaching students about **professional software architecture** using a **real shipped game** as the example. They're going to find this super cool.

The hardest part is preparation (which you're doing now).
The teaching part will be natural because the material is genuinely interesting.

**Good luck, and enjoy!**

---

## Questions?

See PRESENTATION_README.md for full documentation and resources.

**Start with Lesson 1. You'll do great.**

