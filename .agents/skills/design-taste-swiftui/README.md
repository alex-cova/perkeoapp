# design-taste-swiftui

Anti-slop SwiftUI skill. The agent reads the brief, infers the right design direction, and ships interfaces that do not look templated. Apple HIG compliance, modern SwiftUI APIs, strict pre-flight check.

This skill is a merge of [swiftui-agent-skill](https://github.com/twostraws/swiftui-agent-skill) and [taste-skill](https://github.com/Leonxlnx/taste-skill).

## Install

```
npx skills add https://github.com/alex-cova/design-taste-swiftui --skill design-taste-swiftui
```

## What it does

Most LLM-generated SwiftUI is visually identical: a centered `VStack` of `Text` views, three cards in an `HStack`, deprecated APIs, hardcoded fonts, no accessibility, no dark mode. This skill fixes that.

Before writing any code, the agent:

1. **Reads the brief** - infers the app kind, audience, vibe, and platform constraints
2. **Sets three dials** - `DESIGN_VARIANCE`, `MOTION_INTENSITY`, `VISUAL_DENSITY` - that gate every decision
3. **Picks a design approach** - system-leaning (Settings, utility) vs. custom (premium, creative, social)
4. **Writes code** following 60+ enforced rules covering modern APIs, data flow, animation, accessibility, and layout
5. **Runs a pre-flight checklist** before delivering - if any box fails, the output is not done

## What it catches

### Deprecated APIs (25+ patterns)
`foregroundColor()` -> `foregroundStyle()`, `NavigationView` -> `NavigationStack`, `cornerRadius()` -> `clipShape(.rect(cornerRadius:))`, `onAppear` for async -> `.task()`, `@StateObject` -> `@Observable` + `@State`, and many more.

### Design anti-patterns
- VStack dumps (centered text stacks on every screen)
- Three equal cards in an HStack
- Gray `Rectangle()` placeholders
- Hardcoded font sizes without Dynamic Type
- `Color.black` / `Color.white` backgrounds
- Emoji in labels instead of SF Symbols

### Content tells
- Em-dashes (completely banned - the #1 LLM text tell)
- Filler verbs ("Elevate", "Seamless", "Unleash")
- Generic names ("John Doe"), fake-perfect numbers
- AI hallucination phrases

## Skill structure

```
design-taste-swiftui/
├── SKILL.md                      # Main skill (878 lines)
└── references/                   # Technical reference files
    ├── accessibility.md          # Dynamic Type, VoiceOver, Reduce Motion
    ├── api.md                    # Modern API, deprecated patterns
    ├── data.md                   # @Observable, data flow, property wrappers
    ├── design.md                 # HIG compliance, accessible design
    ├── hygiene.md                # Code cleanliness, secrets, testing
    ├── navigation.md             # NavigationStack, sheets, alerts
    ├── performance.md            # LazyVStack, AnyView, view efficiency
    ├── swift.md                  # Modern Swift, concurrency, formatting
    └── views.md                  # View composition, animation, previews
```

## Sections

| # | Section | What it controls |
|---|---|---|
| 0 | **Brief Inference** | Read the brief before writing code. Output a one-line design read. |
| 1 | **Three Dials** | `DESIGN_VARIANCE` / `MOTION_INTENSITY` / `VISUAL_DENSITY` - baseline `8/6/4` |
| 2 | **Design System Map** | System components (variance <= 5) vs. custom visual layer (variance >= 6) |
| 3 | **Architecture & Conventions** | Swift 6.2, `@Observable`, `NavigationStack`, SF Symbols, typography, file organization |
| 4 | **Design Directives** | Typography, color calibration, layout, materiality, buttons, forms, images, content density |
| 5 | **Context-Aware Proactivity** | Liquid Glass, spring animations, matched geometry, phase animators, scroll transitions |
| 6 | **Performance & Accessibility** | LazyVStack, Dynamic Type, VoiceOver, reduced motion, dark mode, contrast |
| 7 | **Dial Definitions** | Technical mapping of each dial level to SwiftUI APIs and spacing values |
| 8 | **Dark Mode Protocol** | Asset Catalog colors, semantic tokens, test both modes |
| 9 | **AI Tells** | 25+ deprecated API bans, visual tells, content tells, em-dash ban |
| 10 | **Reference Vocabulary** | Named patterns: tab-based, sidebar split, bento grid, matched geometry hero, etc. |
| 11 | **Modernization Protocol** | Audit-first UIKit/legacy SwiftUI migration with preservation rules |
| 12 | **Block Library** | Schema for reusable SwiftUI view blocks (iteratively populated) |
| 13 | **Out of Scope** | Games, AR, watchOS, widgets, server-side Swift |
| 14 | **Pre-Flight Check** | 60+ mandatory checkboxes across API, data, views, perf, a11y, design, Swift, content |

## Canonical code skeletons

The skill includes three ready-to-use animation patterns:

- **5.A** Spring-animated list with staggered entry
- **5.B** Matched geometry transition (expand/collapse cards)
- **5.C** Scroll transition (items animate on scroll)

## Credits

- **taste-skill** by [@Leonxlnx](https://github.com/Leonxlnx) - the original anti-slop frontend skill providing the philosophy, three-dial system, and pre-flight checklist structure
- **swiftui-agent-skill** by [Paul Hudson](https://github.com/twostraws) - the SwiftUI best practices reference files (`references/`) covering modern APIs, data flow, navigation, performance, accessibility, design, and Swift conventions

## License

MIT
