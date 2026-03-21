# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

### Search Strategy
- **Simple/single answer searches** → Use DuckDuckGo (`ddgs` tool or `duckduckgo-search` skill)
- **Complex research needing multiple sources** → Use Perplexity via Chrome debug browser (profile="openclaw")

### Browser Notes
- Chrome debug mode: `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug`
- Perplexity URL: https://perplexity.com
- User logged in as: Ebuddy Cheung

---

Add whatever helps you do your job. This is your cheat sheet.
