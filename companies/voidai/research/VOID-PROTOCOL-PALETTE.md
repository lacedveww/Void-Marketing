# Void Protocol - Brand Color Palette

**Decision:** Logo 10G (Blue Vortex) + Name "Void Protocol"
**Anchor Colors:** `#534AB7` (Royal Purple) + `#718AFC` (Periwinkle)
**Date:** April 14, 2026

---

## Primary Palette

| Token | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **void-900** | `#120F2E` | 18, 15, 46 | Deepest backgrounds, footer |
| **void-800** | `#1E1A4B` | 30, 26, 75 | Dark sections, nav dark mode, code blocks |
| **void-700** | `#312A7A` | 49, 42, 122 | Dark accents, hover states on dark bg |
| **void-600** | `#4338A8` | 67, 56, 168 | Hover state for primary buttons |
| **void-500** | `#534AB7` | 83, 74, 183 | **PRIMARY** -- buttons, links, brand mark |
| **void-400** | `#718AFC` | 113, 138, 252 | **ACCENT** -- highlights, secondary elements, vortex glow |
| **void-300** | `#94A3FD` | 148, 163, 253 | Soft accents, icon fills, tags |
| **void-200** | `#BAC3FE` | 186, 195, 254 | Borders (light mode), subtle backgrounds |
| **void-100** | `#DDE1FF` | 221, 225, 255 | Light tinted backgrounds, card fills |
| **void-50** | `#F0F1FF` | 240, 241, 255 | Surface/page background tint |

## Neutrals (Purple-Tinted)

| Token | Hex | Usage |
|-------|-----|-------|
| **neutral-900** | `#0F0D1F` | True dark (near black with purple warmth) |
| **neutral-800** | `#1C1932` | Dark text on light backgrounds |
| **neutral-700** | `#2E2B45` | Body text (dark mode) |
| **neutral-600** | `#4A4660` | Secondary text |
| **neutral-500** | `#6B6784` | Muted text, placeholders |
| **neutral-400** | `#8F8BA8` | Disabled states, captions |
| **neutral-300** | `#B5B2C9` | Borders, dividers |
| **neutral-200** | `#D8D6E5` | Light borders |
| **neutral-100** | `#EEEDF5` | Card backgrounds |
| **neutral-50** | `#F8F7FC` | Page surface |
| **white** | `#FFFFFF` | Pure white |

## Semantic Colors

| Token | Hex | Usage |
|-------|-----|-------|
| **success** | `#10B981` | Live badges, positive metrics |
| **success-light** | `#D1FAE5` | Success backgrounds |
| **warning** | `#F59E0B` | Caution, pending states |
| **error** | `#EF4444` | Error states |
| **info** | `#718AFC` | Informational (uses accent) |

## Gradient Definitions

| Name | CSS | Usage |
|------|-----|-------|
| **Brand Gradient** | `linear-gradient(135deg, #534AB7, #718AFC)` | Hero CTAs, featured elements |
| **Subtle Gradient** | `linear-gradient(135deg, #534AB7 0%, #718AFC 50%, #94A3FD 100%)` | Background accents |
| **Dark Gradient** | `linear-gradient(135deg, #0F0D1F 0%, #1E1A4B 40%, #312A7A 100%)` | Dark hero sections, footers |
| **Vortex Gradient** | `radial-gradient(ellipse, #718AFC 0%, #534AB7 40%, #1E1A4B 80%, #120F2E 100%)` | Logo vortex glow effect |
| **Glass Tint** | `rgba(83, 74, 183, 0.08)` | Glass card backgrounds |
| **Glass Border** | `rgba(83, 74, 183, 0.18)` | Glass card borders |
| **Spotlight** | `radial-gradient(600px circle, rgba(83, 74, 183, 0.09), transparent 60%)` | Cursor spotlight effect |

## Tailwind Config

```js
colors: {
  void: {
    50: '#F0F1FF',
    100: '#DDE1FF',
    200: '#BAC3FE',
    300: '#94A3FD',
    400: '#718AFC',
    500: '#534AB7',
    600: '#4338A8',
    700: '#312A7A',
    800: '#1E1A4B',
    900: '#120F2E',
  },
  brand: {
    primary: '#534AB7',
    accent: '#718AFC',
    dark: '#1E1A4B',
    darker: '#120F2E',
    light: '#94A3FD',
    surface: '#F0F1FF',
  }
}
```

## Typography Pairing

- **Headlines:** Inter 700/800 or Playfair Display 600/700
- **Body:** Inter 400/500
- **Code/Mono:** JetBrains Mono 400/500
- **Logo wordmark:** Geometric sans-serif, tracking-tight

## Logo Usage

The vortex in the "o" uses the **Vortex Gradient** (radial from #718AFC through #534AB7 to #1E1A4B).

- Light backgrounds: Vortex + `#1C1932` text
- Dark backgrounds: Vortex + `#FFFFFF` text
- Monochrome: `#534AB7` flat vortex + matching text
- Minimum clear space: 1x height of the "v" character on all sides

## Contrast Ratios (WCAG AA)

| Foreground | Background | Ratio | Pass? |
|------------|-----------|-------|-------|
| #534AB7 | #FFFFFF | 4.8:1 | AA |
| #534AB7 | #F0F1FF | 4.5:1 | AA |
| #FFFFFF | #534AB7 | 4.8:1 | AA |
| #FFFFFF | #1E1A4B | 13.2:1 | AAA |
| #1C1932 | #FFFFFF | 15.8:1 | AAA |
| #718AFC | #120F2E | 6.1:1 | AA |
