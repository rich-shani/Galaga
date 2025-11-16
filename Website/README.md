# Galaga Wars Website

A retro-themed, Star Wars-inspired arcade website for **Galaga Wars**, a professional game development project demonstrating enterprise-level programming practices.

## Features

### Visual Design
- **Retro Arcade Aesthetic:** 80s arcade cabinet style with neon colors and glowing effects
- **Star Wars Theme:** Imperial forces, X-Wing vs. TIE Fighters
- **CRT Effects:** Scan lines and authentic arcade monitor appearance
- **Responsive Design:** Works on desktop, tablet, and mobile devices
- **Animated Elements:** Glowing text, pulsing buttons, floating images, twinkling stars

### Content Sections

1. **About the Game**
   - Game concept and modern remake explanation
   - Key features (gameplay, performance, mechanics)
   - Visual feature cards with icons

2. **Galaga History**
   - Timeline from 1981 to 2024
   - Evolution of the classic arcade game
   - Impact on gaming industry

3. **Game Mechanics**
   - Enemy types (TIE Fighter, TIE Interceptor, Imperial Shuttle)
   - Game states and flow
   - Scoring system

4. **Technical Excellence**
   - Professional architecture highlights
   - Code statistics
   - Technology stack

5. **Educational Value**
   - Computer science learning outcomes
   - Professional practices demonstrated
   - Career relevance

6. **Call to Action**
   - "Play Now" button (for when game is embedded)
   - Link to source code
   - Game launch placeholder

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Neon Yellow | #FFFF00 | Primary text, glowing effects |
| Neon Cyan | #00FFFF | Secondary text, borders |
| Neon Magenta | #FF00FF | Accents, highlights |
| Neon Green | #00FF00 | Feature boxes, hover states |
| Neon Red | #FF0000 | Warnings, critical elements |
| Dark Background | #0a0e27 | Main background |
| Dark Background 2 | #1a1f3a | Secondary background |

## Typography

- **Primary Font:** "Press Start 2P" (Google Fonts)
- **Style:** Retro arcade/8-bit style
- **Fallback:** Cursive
- **Responsive:** Scales from 0.6em to 3em based on screen size

## Animations

### Implemented Animations
- `twinkle` - Starfield background flicker
- `glow-pulse` - Logo glow effect
- `flicker` - Text flicker effect
- `blink` - Tagline blinking
- `pulse` - Button and timeline animations
- `shimmer` - Border shimmer effect
- `float` - Image floating effect
- `fadeInUp` - Section entrance animation
- `glow-flicker` - Text glow with flicker

## Sections

### Header
- Logo with "GALAGA WARS" in glowing text
- Tagline with star symbols
- Neon glow effects

### Arcade Cabinet
- Special styled section for game launch
- Primary call-to-action button
- Links to source code

### Timeline
- Historical progression from 1981-2024
- Pulse animations on timeline nodes
- Connecting lines between events

### Responsive Grid
- Auto-fitting feature cards
- Hover effects and transitions
- Adaptive columns (250px minimum)

## File Structure

```
Website/
├── index.html          # Main webpage (complete HTML + CSS)
└── README.md           # This file

Note: CSS is embedded in index.html for easy deployment.
      To modify styles, edit the <style> section in index.html.
```

## Browser Compatibility

- Chrome/Edge 88+
- Firefox 85+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Mobile)

**Note:** Requires support for:
- CSS Grid & Flexbox
- CSS Animations
- CSS Backdrop Filter (blur effect)
- CSS Custom Properties (variables)
- Google Fonts API

## Mobile Responsiveness

- Breakpoint: 768px
- Reduced font sizes on mobile
- Single-column grid layout
- Optimized touch targets
- Full-width sections with padding

## Game Embed Instructions

Once the GameMaker HTML5 export is ready:

1. Export the game from GameMaker to HTML5
2. Copy the game files to the `Website/` directory
3. Replace the placeholder in the "Launch Galaga Wars" section
4. Update links to point to the game container
5. Test on multiple browsers

### Expected Export Contents
```
game-files/
├── index.html              (Game runner)
├── assets/                 (Sprites, audio)
├── libs/                   (GameMaker runtime)
└── game.js                 (Compiled game code)
```

## Customization Guide

### Change Colors
Edit the `:root` CSS variables in the `<style>` section:
```css
:root {
    --neon-yellow: #FFFF00;   /* Change primary color */
    --neon-cyan: #00FFFF;     /* Change secondary color */
    --neon-magenta: #FF00FF;  /* Change accent color */
    --dark-bg: #0a0e27;       /* Change background */
}
```

### Modify Animations
Edit animation keyframes:
```css
@keyframes twinkle {
    0%, 100% { opacity: 0.5; }  /* Adjust opacity */
    50% { opacity: 1; }
}
```

### Update Content
Edit HTML content between tags:
```html
<h1>GALAGA WARS</h1>  <!-- Change heading -->
<p>Game description...</p>  <!-- Change text -->
```

### Change Fonts
Replace the Google Fonts import:
```css
@import url('https://fonts.googleapis.com/css2?family=YOUR_FONT:wght@400&display=swap');
```

## Performance Optimization

### Optimized For
- Fast page load (minimal external dependencies)
- Smooth animations (60 FPS)
- Low CPU usage (CSS animations, no JavaScript)
- Mobile battery efficiency

### Techniques Used
- CSS Grid and Flexbox (no JavaScript layout)
- Hardware-accelerated transforms
- GPU-optimized animations
- Minimal DOM manipulation
- Responsive images (CSS background)

## Accessibility Features

- Semantic HTML structure
- Color contrast compliant
- Readable font sizes
- Mobile-friendly touch targets
- Keyboard navigable
- Screen reader friendly content

## SEO Considerations

Current page includes:
- Descriptive title
- Meta description ready (add to header)
- Heading hierarchy (H1, H2)
- Semantic HTML
- Open Graph ready (add to header)
- Schema.org ready (add to body)

### To Improve SEO
1. Add meta description to header
2. Add Open Graph tags
3. Add schema.org structured data
4. Create sitemap.xml
5. Add robots.txt
6. Optimize image alt text (when images added)

## Links & CTA

### External Links
- GitHub Source Code: `https://github.com` (update with real repo)
- GameMaker Documentation: https://manual.yoyogames.com

### Internal Links
- Play Now Button → `#launch-game` (anchor scroll)
- View Code Button → GitHub repository

## Future Enhancements

### When Game is Ready
- [ ] Embed GameMaker HTML5 export
- [ ] Add actual gameplay screenshots
- [ ] Add video demo
- [ ] Add play time counter
- [ ] Add online leaderboards
- [ ] Add social sharing buttons

### Additional Features
- [ ] Dark/Light theme toggle
- [ ] Sound toggle
- [ ] Language selector
- [ ] Difficulty selector
- [ ] Settings/controls menu
- [ ] Achievement display

### Content Additions
- [ ] Developer blog
- [ ] Behind-the-scenes
- [ ] Tutorial videos
- [ ] Community section
- [ ] Downloads page
- [ ] Contact form

## Deployment

### Options
1. **Static Hosting:** GitHub Pages, Netlify, Vercel
2. **Web Server:** Apache, Nginx
3. **Local Testing:** Open index.html in browser

### Steps
1. Copy Website folder to hosting
2. Ensure index.html is in root
3. Add game files when ready
4. Update links as needed
5. Test on multiple browsers

## Browser Testing Checklist

- [ ] Chrome desktop
- [ ] Firefox desktop
- [ ] Safari desktop
- [ ] Edge desktop
- [ ] Chrome mobile
- [ ] Safari iOS
- [ ] Firefox mobile
- [ ] Responsiveness at 1920px, 1366px, 768px, 375px

## Credits

- **Original Galaga:** Namco (1981)
- **Galaga Wars:** Modern remake with professional game architecture
- **Font:** "Press Start 2P" by Cody "CodeMan38" Boisclair
- **Design:** Retro arcade aesthetic with Star Wars theme
- **Technology:** HTML5, CSS3, Responsive Design

## License

This website and associated game are open-source educational projects.

## Support & Questions

For questions about:
- **Game mechanics:** See INTRO_CS_CLASS_10TH_GRADE.md
- **Code architecture:** See ARCHITECTURE.md
- **Technical details:** See DEVELOPER_GUIDE.md
- **Game balance:** See datafiles/game_config.json

## Version History

### v1.0.0 (2024-11-16)
- Initial release
- Complete website with retro arcade theme
- All content sections
- Responsive design
- Animation effects
- Placeholder for game embed

---

**Status:** Ready for game embed
**Last Updated:** November 16, 2024
**Maintenance:** Minor updates as game develops

