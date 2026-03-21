# The Catch — Design System v1.0

## Aesthetic Direction
Dark and technical. Data terminal. Obsidian blacks.
Reference: F1 timing screens, live telemetry dashboards.
Every element should feel like it belongs on a race-day data feed.

## Color Palette — CSS Custom Properties (goes in globals.css later)

:root {
  --color-bg-base:       #080B0F;
  --color-bg-surface:    #0F1318;
  --color-bg-elevated:   #161B22;
  --color-bg-subtle:     #1A2030;
  --color-border:        #1E2530;
  --color-border-strong: #2A3442;
  --color-accent:        #00AAFF;
  --color-accent-dim:    rgba(0, 170, 255, 0.12);
  --color-accent-hover:  #33BBFF;
  --color-text-primary:  #E8EDF2;
  --color-text-secondary:#7A8A99;
  --color-text-muted:    #4A5568;
  --color-success:       #22C55E;
  --color-warning:       #F59E0B;
  --color-danger:        #EF4444;
  --color-gold:          #FFB800;
  --color-silver:        #A0ADB8;
  --color-bronze:        #CD7F4B;
}

## Typography
- Display font: Barlow Condensed, weight 700. Used for page titles, event names, large stat numbers.
- Body/Data font: Inter, weights 400/500/600. Used for tables, labels, navigation.

--font-display: 'Barlow Condensed', sans-serif;
--font-body:    'Inter', sans-serif;
--text-xs:   0.75rem;
--text-sm:   0.875rem;
--text-base: 1rem;
--text-lg:   1.125rem;
--text-xl:   1.25rem;
--text-2xl:  1.5rem;
--text-3xl:  2rem;
--text-4xl:  2.5rem;

## Spacing — 8px base grid
--space-1: 4px;   --space-2: 8px;   --space-3: 12px;
--space-4: 16px;  --space-5: 20px;  --space-6: 24px;
--space-8: 32px;  --space-10: 40px; --space-12: 48px;
--radius-sm: 4px; --radius-md: 8px; --radius-lg: 12px;

## Navigation
- Mobile under 768px: Fixed bottom tab bar. 5 tabs: Home, Regattas, Teams, Compare, Hub.
- Desktop 768px and above: Top navbar. Bottom tab bar hidden.

## Data Tables to Mobile Cards
On screens under 768px, the .results-table CSS class transforms tables into stacked cards.
Each card shows: school name and placement (large, top row), time and lane (secondary row), crew members (expandable).

## Component Patterns
- Stat Card: dark surface background, 1px border, 3px accent-colored top border strip. Large value number in Barlow Condensed, label in Inter secondary color.
- Badge: pill shape. Variants: accent (blue fill), success (green), warning (amber), muted (surface fill).
- Filter Bar: horizontal scrollable row of pill buttons. Active state uses accent border and accent-dim background.
- Table row hover: background transitions to --color-bg-subtle.

## Motion
Only two animations permitted:
1. Page transitions: 150ms fade opacity
2. Notification badge: subtle pulse on new notification
