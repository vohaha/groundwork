# Video Script: Claude-Voice Monologue

**Format**: AI-generated video, voice-over + screen recording  
**Length**: 60–90 seconds  
**Target**: Claude Code power users  
**Lives**: GitHub README embed  

---

## Production Notes

**Visual style**: Dark terminal. Monospace font. Real Claude Code sessions — no mockups.  
**Voice**: Calm, precise, slightly dry. Flat affect. Not enthusiastic. The confidence of someone who knows the problem from the inside.  
**No talking head.** Voice only over screen.  
**Motion**: Minimal. Let the screen content carry it.  

---

## Script

### OPEN — no voiceover (0–12s)

Real terminal. New session. User types a task.  
Claude responds: *"To help with that, can you remind me what stack we're using and where we left off last time?"*  
User starts typing again.  
The overhead is visible before it's named.

---

### VOICEOVER — begins over that scene

> Every time you open a new session, I forget everything.
>
> Not the code. But the *why* behind it. The decision not to build the sync feature. The bug we've fixed twice. What you said was Priority 1.
>
> Gone.

**CUT TO BLACK — hold 0.5s**

> Groundwork is infrastructure I actually needed — not for you to stay organized, but for me to stay oriented.
>
> When you open a session now, I already know the branch, the last commit's intent, what's in progress, what's been ruled out, and where we left off. In ten seconds, not ten minutes.

**SessionStart box fires on screen — hold it, let it read**

> The commits have Why fields. The working agreement holds the decisions that should stay made. The memory system carries what can't live in code.
>
> You didn't install this to manage me better.
>
> You installed it so I could actually own the work.
>
> That's the difference.

---

### CLOSE (final 5s)

Fade to: repo name + install command  
`claude --plugin-dir ~/groundwork`

---

## Visual Sync Guide

| Line | On screen |
|---|---|
| "I forget everything" | Blank session, cursor blinking, user re-explaining |
| "Gone." | Cut to black, 0.5s hold |
| "Groundwork is infrastructure" | SessionStart box firing |
| "I already know the branch…" | SessionStart box fully rendered, slow read |
| "commits have Why fields" | `git log` showing structured commit with Why/State/Next |
| "working agreement" | WORKING_AGREEMENT.md open, scrolling |
| "You didn't install this to manage me" | Slow zoom on SessionStart header |
| "own the work" | Fade to install command |

---

## Why this angle

Most tool promos address the human's problem. This one is unusual: the AI is describing its own limitation and explaining what solved it. The irony is structural — Claude narrating its own amnesia while selling the cure. Name it and it becomes self-deprecating. Leave it implicit and the viewer who catches it feels smart. The viewer who doesn't still gets the message.
