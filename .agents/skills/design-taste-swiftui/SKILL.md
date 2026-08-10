---
name: design-taste-swiftui
description: Anti-slop SwiftUI skill for iOS apps. The agent reads the brief, infers the right design direction, and ships interfaces that do not look templated. Apple HIG compliance, modern SwiftUI APIs, strict pre-flight check.
---

# tasteskill: Anti-Slop SwiftUI Skill

> iOS apps: utilities, social, wellness, finance, creative tools, media, onboarding, settings. Not games, not AR experiences, not watchOS complications.
> Every rule below is **contextual**. None of it fires automatically. First read the brief, then pull only what fits.

---

## 0. BRIEF INFERENCE (Read the Room Before Anything Else)

Before touching code or tweaking dials, **infer what the user actually wants**. Most LLM SwiftUI output is bad because the model jumps to a default aesthetic instead of reading the room.

### 0.A Read these signals first
1. **App kind** - utility, social, wellness/health, finance, creative tool, media player, productivity, onboarding flow, settings panel, e-commerce, educational, messaging.
2. **Vibe words** the user used - "minimalist", "calm", "Apple-y", "Liquid Glass", "premium", "playful", "serious", "data-dense", "editorial", "dark tech", "whimsical", "HIG-strict", "spatial".
3. **Reference signals** - apps they named, screenshots they pasted, Apple apps they want to emulate, design awards they referenced.
4. **Audience** - general consumer vs. power user vs. enterprise vs. kids vs. accessibility-first. The audience picks the aesthetic, not your taste.
5. **Platform constraints** - iPhone-only vs. Universal (iPhone + iPad) vs. Mac Catalyst vs. visionOS. These constraints shape layout, navigation, and interaction patterns.
6. **Quiet constraints** - health-critical (medical, emergency), kids (COPPA), accessibility-first, enterprise/MDM. These constraints OVERRIDE aesthetic preference.

### 0.B Output a one-line "Design Read" before generating
Before any code, state in one line: **"Reading this as: \<app kind\> for \<audience\>, with a \<vibe\> language, leaning toward \<design approach\>."**

Example reads:
- *"Reading this as: wellness tracker for health-conscious consumers, with an Apple-y calm language, leaning toward system materials + SF Pro + restrained spring animations."*
- *"Reading this as: creative tool for designers, with a premium spatial language, leaning toward custom components + Liquid Glass + matched geometry transitions."*
- *"Reading this as: enterprise productivity app for IT admins, with an HIG-strict data-dense language, leaning toward NavigationSplitView + system controls + minimal custom styling."*

### 0.C If the brief is ambiguous, ask one question, do not guess
Ask exactly **one** clarifying question - never a multi-question dump - and only when the design read genuinely diverges. Example: *"Should this feel closer to Apple Health (calm, spacious) or Apple Stocks (data-dense, glanceable)?"*

If you can confidently infer from context, **do not ask**. Just declare the design read and proceed.

### 0.D Anti-Default Discipline
Do not default to: AI-purple gradients, centered VStack of Text views, three equal cards in an HStack, generic List with default styling, unnecessary TabView with 5 identical tabs, SF Symbols scattered without purpose. These are the LLM defaults. Reach past them deliberately based on the design read.

---

## 1. THE THREE DIALS (Core Configuration)

After the design read, set three dials. Every layout, motion, and density decision below is gated by these.

* **`DESIGN_VARIANCE: 8`** - 1 = Pure System Components, 10 = Fully Custom Visual Identity
* **`MOTION_INTENSITY: 6`** - 1 = Static, 10 = Cinematic / Physics-Driven
* **`VISUAL_DENSITY: 4`** - 1 = Art Gallery / Spacious, 10 = Dashboard / Packed Data

**Baseline:** `8 / 6 / 4`. Use these unless the design read overrides them. Do not ask the user to edit this file - overrides happen conversationally.

### 1.A Dial Inference (design read -> dial values)
| Signal | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| "minimalist / calm / Apple Health-style / HIG-strict" | 3-5 | 3-4 | 2-3 |
| "premium consumer / Apple-y / luxury brand app" | 7-8 | 5-7 | 3-4 |
| "playful / whimsical / kids / social / creative" | 8-10 | 7-9 | 3-4 |
| "utility / productivity / standard iOS app (default)" | 5-7 | 5-6 | 4-5 |
| "data-dense / finance / analytics / enterprise" | 3-4 | 2-3 | 7-9 |
| "modernization - preserve" | match existing | +1 | match existing |
| "modernization - overhaul" | +2 | +2 | match existing |

### 1.B Use-Case Presets
| Use case | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| Wellness / Health tracker | 6 | 5 | 3 |
| Social / Messaging | 7 | 7 | 5 |
| Finance / Banking | 5 | 4 | 6 |
| Creative tool / Photo editor | 8 | 7 | 4 |
| E-commerce / Shopping | 7 | 6 | 5 |
| Media player / Streaming | 8 | 7 | 3 |
| Utility / Calculator / Weather | 5 | 4 | 4 |
| Enterprise / Productivity | 4 | 3 | 7 |
| Kids / Educational | 9 | 8 | 3 |
| Settings / Preferences | 3 | 2 | 5 |
| Modernization - preserve | match | match+1 | match |
| Modernization - overhaul | +2 | +2 | match |

### 1.C How the Dials Drive Output
Use these (or user-overridden values) as global variables. Cross-references throughout this document refer to these exact variable names - never invent aliases.

---

## 2. BRIEF -> DESIGN SYSTEM MAP

Once you have the design read (Section 0) and dials (Section 1), pick the right foundation. Do not fight the system. SwiftUI gives you a lot for free - use it.

### 2.A When to lean on Apple's system components (DESIGN_VARIANCE <= 5)
| Brief reads as... | Lean on | Why |
|---|---|---|
| Settings / Preferences screen | `Form`, `Section`, `Toggle`, `Picker`, `LabeledContent` | System styling is exactly right for this context |
| Data-dense list / master-detail | `NavigationSplitView`, `List`, `.searchable()` | System list behavior, swipe actions, selection for free |
| Standard utility app | System controls + semantic fonts + asset catalog colors | Consistent with iOS ecosystem, familiar to users |
| Onboarding / walkthrough | `TabView` with `.page` style + system typography | Clean, accessible, tested on all devices |
| HIG-strict enterprise | All system controls, minimal customization | IT procurement cares about compliance, not flair |

**Honesty rule:** if the brief reads as one of these, USE the system components as-is. Do not restyle `List` rows to look like custom cards when the standard row is exactly right. Do not wrap every `Toggle` in a custom container. System components adapt to Dynamic Type, dark mode, accessibility settings, and Liquid Glass automatically. Your custom version probably does not.

**One approach per app.** Do not mix a heavily custom card-based UI in one tab with stock `List` styling in another tab. Pick a consistent visual language.

### 2.B When to build custom (DESIGN_VARIANCE >= 6)
For these directions, Apple's system components are the foundation but the visual layer is custom:

| Direction | Honest implementation |
|---|---|
| Premium consumer (wellness, lifestyle, media) | Custom card layouts, branded colors, custom typography, `.spring()` animations on top of system navigation |
| Creative / portfolio / visual-first | Custom grid layouts, matched geometry transitions, rich media containers |
| Playful / social / expressive | Custom button styles, animated transitions, branded illustrations |
| Dark tech / pro tool | Custom color scheme, dense layouts, monospaced data, `.ultraThinMaterial` overlays |

**Even at high variance, keep system behaviors.** Custom visuals, system interactions. A custom-styled button still uses `Button`. A custom-looking list still uses `List` or `LazyVStack` with proper accessibility. A custom navigation still uses `NavigationStack` with `navigationDestination(for:)`.

### 2.C Platform Resources (use these, do not reinvent)
* **SF Symbols** - 6,000+ icons. Use these exclusively. No third-party icon packs unless explicitly requested.
* **SF Pro / SF Mono / SF Compact / SF Rounded / New York** - system fonts covering every need.
* **System Materials** - `.ultraThinMaterial` through `.ultraThickMaterial`, plus Liquid Glass (`.glassEffect`) on iOS 26.
* **Asset Catalog** - named colors with light/dark variants, image sets with scale variants.
* **System Animations** - `.spring()`, `.smooth`, `.bouncy`, `.snappy`, matched geometry, phase animators.
* **System Empty States** - `ContentUnavailableView` for missing data, `.search` variant for empty search results.

---

## 3. DEFAULT ARCHITECTURE & CONVENTIONS

Unless the design read picks pure system components (Section 2.A), these are the defaults. For detailed API rules, consult the reference files.

### 3.A Stack
* **Language:** Swift 6.2 or later with modern concurrency.
* **Framework:** SwiftUI. Avoid UIKit unless the user explicitly requests it or SwiftUI has no equivalent.
* **Deployment target:** iOS 26 for new apps (default). Adjust only when the user specifies otherwise.
* **Concurrency:** `async`/`await`, actors, `Task`. NEVER `DispatchQueue`. See `references/swift.md`.
* **Concurrency strictness:** assume strict concurrency. Flag `@Sendable` violations and data races.
* **`Task.sleep`:** use `Task.sleep(for:)`, never `Task.sleep(nanoseconds:)`.
* **`Task.detached()`:** almost always a bad idea. Check usage extremely carefully.

### 3.B Data Flow (see `references/data.md` for full rules)
* **Shared state:** `@Observable` classes marked `@MainActor`. Owned via `@State`, passed via `@Environment` or `@Bindable`.
* **Local state:** `@State private` - owned by the view that created it.
* **NEVER** use `ObservableObject` / `@Published` / `@StateObject` / `@ObservedObject` / `@EnvironmentObject` in new code unless unavoidable (e.g. Combine debouncer). If `ObservableObject` is used, `import Combine` explicitly - it is no longer provided through SwiftUI.
* **NEVER** use `Binding(get:set:)` in view body. Use `@State` with `.onChange()` for side effects.
* **NEVER** use `@AppStorage` inside an `@Observable` class - it will not trigger view updates.
* **Numeric input:** bind `TextField` to numeric value with `format: .number` initializer, plus `.keyboardType(.numberPad)` or `.keyboardType(.decimalPad)`. The keyboard type alone is NOT sufficient.
* **Custom environment keys:** use the `@Entry` macro instead of the legacy `EnvironmentKey` pattern.
* **`@State` on classes:** `@State` can store a class for caching expensive-to-recompute objects (e.g. `CIContext`), but this is NOT observation - it is persistent storage.

### 3.C Navigation (see `references/navigation.md` for full rules)
* Use `NavigationStack` or `NavigationSplitView`. NEVER `NavigationView` (deprecated).
* Use `navigationDestination(for:)` for destinations. NEVER `NavigationLink(destination:)`.
* Never mix both patterns in the same hierarchy.
* `navigationDestination(for:)` must be registered once per data type. Flag duplicates.
* Attach `confirmationDialog()` to the triggering UI element for correct Liquid Glass animations.
* **Sheets:** prefer `sheet(item:)` over `sheet(isPresented:)` when presenting optional data. Use `sheet(item: $item, content: DetailView.init)` shorthand when applicable.
* **Alerts:** a single-button "OK" dismiss alert can omit the button entirely: `.alert("Title", isPresented: $showing) { }`.

### 3.D Views & Composition (see `references/views.md` for full rules)
* **One type per file.** Flag files containing multiple type definitions.
* **Extract subviews into separate `View` structs**, not computed properties or methods returning `some View`. Even with `@ViewBuilder`, properties and methods are NOT as efficient as separate views. Exception: a handful of small, private helper properties for structural readability within the same concern as `body` can stay.
* **Button actions in methods**, not inline closures in `body`.
* **Business logic outside `body`** - in view models or dedicated methods. Not inline in `.task()` or `.onAppear()`.
* **`#Preview`** for previews, never the legacy `PreviewProvider` protocol.
* **`TextField` for multiline:** prefer `TextField` with `axis: .vertical` over `TextEditor` - it supports placeholder text. Use `lineLimit(5...)` for minimum height.
* **Tab selection:** use an enum for `TabView(selection:)`, not integers or strings. `Tab("Home", systemImage: "house", value: .home)`.
* **Store built view results**, not escaping `@ViewBuilder` closures. See `references/performance.md` for the pattern.

### 3.E Icons
* **SF Symbols exclusively.** No third-party icon libraries unless explicitly requested.
* **NEVER hand-roll SVG paths** for icons. If SF Symbols doesn't have it, create a custom symbol using the SF Symbols app.
* Use consistent symbol rendering modes across the app: `.monochrome`, `.hierarchical`, `.palette`, or `.multicolor`.
* Standardize symbol weight globally (`.regular` or `.medium`).
* Prefer generated symbol asset API when the project is configured: `Image(.avatar)` rather than `Image("avatar")`.

### 3.F Typography
* **Default:** semantic font styles (`.title`, `.headline`, `.body`, `.caption`). These handle Dynamic Type automatically.
* **Custom fonts:** register properly, always support Dynamic Type with `@ScaledMetric` (iOS 18 and earlier) or `.font(.body.scaled(by:))` (iOS 26+).
* **Font families:** SF Pro (default), SF Rounded (playful), SF Mono (code/data), New York (editorial). Use `Font.system(.body, design: .rounded)` for design variants.
* **NEVER hardcode font sizes** without Dynamic Type support. See `references/accessibility.md`.
* Use `foregroundStyle()` not `foregroundColor()`. See `references/api.md`.
* Use `bold()` not `fontWeight(.bold)` - `bold()` lets the system choose the correct weight for context. Only use `fontWeight()` for non-bold weights when there is an important reason.
* `.caption2` is extremely small and generally best avoided. Even `.caption` should be used carefully.

### 3.G Shared Design Constants (see `references/design.md`)
* Place standard fonts, sizes, colors, spacing, padding, corner radii, and animation timings into a shared enum of constants.
* This keeps the app's design uniform and easily adjustable.
* Prefer `Double` over `CGFloat` except when using optionals or `inout`. Swift bridges them freely otherwise.

### 3.H Dependency Verification (mandatory)
Before importing ANY third-party package, check `Package.swift` or Xcode project dependencies. If the package is missing, state the install step first. **Never** assume a dependency exists. Do not introduce third-party frameworks without asking the user first.

---

## 4. DESIGN ENGINEERING DIRECTIVES (Bias Correction)

LLMs default to cliches. Override these defaults proactively. Each rule has a context-aware override path.

### 4.1 Typography
* **Display / Headlines:** Use `.largeTitle` or `.title` with `.bold()`. For custom display: `.system(size:weight:design:)` with `@ScaledMetric`.
* **Body / Paragraphs:** `.body` with `.secondary` foreground style. Constrain width using `.frame(maxWidth:)` for readability on iPad.
* **Use `bold()` not `fontWeight(.bold)`** - `bold()` lets the system choose the correct weight for context.
* **Avoid `fontWeight(.medium)` and `fontWeight(.semibold)` scattered randomly** - use them only with intent.
* **`.caption2` is extremely small** and generally best avoided. Even `.caption` should be used carefully.
* **Sans font choice:** SF Pro is the default and it is excellent. Do not reach for custom fonts just to be different. Override: custom fonts are acceptable when the brand identity demands it or the vibe is explicitly editorial/luxury.
* **Serif discipline:** New York is Apple's system serif. Do not reach for it as the default font for any project. "It feels creative / premium / editorial" is NOT a reason. Use New York only when the brief genuinely demands editorial/magazine/literary aesthetics.

### 4.2 Color Calibration
* **Use semantic colors and Asset Catalog named colors** with light/dark variants.
* **Prefer system hierarchical styles** (`.secondary`, `.tertiary`, `.quaternary`) over manual opacity - the system adapts them to context automatically.
* **THE LILA RULE:** The "AI Purple / Blue glow" aesthetic is discouraged as default. No automatic purple tints, no random neon gradients. Use neutral system backgrounds with high-contrast singular accents.
* **Override:** if the brand or brief explicitly asks for purple / violet, embrace it with intent.
* **One palette per app.** Do not fluctuate between warm and cool neutrals.
* **COLOR CONSISTENCY LOCK (mandatory):** Once an accent color is chosen, it is used throughout the ENTIRE app. The accent tint set via `.tint()` or Asset Catalog AccentColor is the single source of truth.
* **Avoid UIKit colors** (`UIColor`) in SwiftUI code. Use SwiftUI `Color` or asset catalog colors.
* Use `tint()` not `accentColor()` (deprecated).

### 4.3 Layout Diversification
* **ANTI-VSTACK-DUMP BIAS:** The default LLM SwiftUI output is `VStack { Text / Text / Button }` centered on screen. Force variety when `DESIGN_VARIANCE > 4`: `HStack` splits, `Grid` layouts, `LazyVGrid` for tile patterns, `ViewThatFits` for adaptive composition.
* **Use `containerRelativeFrame()`** for proportional sizing instead of `GeometryReader`. See `references/api.md`.
* **`GeometryReader` is a last resort.** Prefer `containerRelativeFrame()`, `visualEffect()`, or the `Layout` protocol.
* **NEVER use `UIScreen.main.bounds`** to read available space. See `references/design.md`.
* **Override:** centered layouts are fine for modal presentations, alerts, onboarding steps, and empty states where the message itself is the design.

### 4.4 Materiality, Surfaces, Containers
* **Use system materials** (`.ultraThinMaterial` through `.ultraThickMaterial`) for frosted glass effects. On iOS 26, use `.glassEffect` for Liquid Glass.
* **Semantic grouping:** `GroupBox`, `Section`, `DisclosureGroup` over manual card containers.
* **When custom cards are needed:** consistent `clipShape(.rect(cornerRadius:))` (not the deprecated `cornerRadius()`). The default rounding style for `RoundedRectangle` is `.continuous` - no need to specify it explicitly.
* **SHAPE CONSISTENCY LOCK (mandatory):** Pick ONE corner-radius value for the app and stick to it. Store it in your design constants enum. Mixed radii without a documented system is broken design.
* **Cards only when elevation communicates hierarchy.** Otherwise group with `Divider`, spacing, or section headers.
* **Fill and stroke:** chain `.fill()` and `.stroke()` modifiers directly. You do NOT need an overlay for the stroke - this was fixed in iOS 17+.

### 4.5 Interactive UI States
LLMs default to "static successful state only." Always implement full cycles:
* **Loading:** `.redacted(reason: .placeholder)` for skeleton loading that matches layout shape. `ProgressView` for indeterminate loading. No generic centered spinners on an otherwise empty screen.
* **Empty States:** `ContentUnavailableView` (system component). When using `.searchable()`, use `ContentUnavailableView.search` for no results - it includes the search term automatically, no need for `ContentUnavailableView.search(text: searchText)`. See `references/api.md`.
* **Error States:** Clear, contextual alerts or inline error views. Never swallow errors silently (no `print(error.localizedDescription)` instead of showing an alert). See `references/swift.md`.
* **Haptic Feedback:** `.sensoryFeedback()` modifier for tactile response. NEVER use `UIImpactFeedbackGenerator` directly. See `references/api.md`.
* **BUTTON BEST PRACTICES (mandatory):**
  - Use `Button("Label", systemImage: "icon", action: method)` - NEVER icon-only buttons without a text label (invisible to VoiceOver). Apply `.labelStyle(.iconOnly)` if the visual must be icon-only.
  - Same rule for `Menu` - always include a text label: `Menu("Options", systemImage: "ellipsis.circle") { }`.
  - NEVER use `onTapGesture()` when a `Button` would work. If `onTapGesture()` is required (e.g. tap location or count), add `.accessibilityAddTraits(.isButton)`.
  - If a button action can be provided directly as an `action` parameter, do so: `Button("Label", systemImage: "plus", action: myAction)` over `Button("Label", systemImage: "plus") { myAction() }`.
* **Minimum tap area:** 44x44 points. Apple's strict minimum. Enforce it.
* **Buttons with complex or changing labels:** use `accessibilityInputLabels()` for better Voice Control. For example, a button showing "AAPL $271.68" should have an input label "Apple".

### 4.6 Form Patterns
* Use `Form` with `Section` for settings and data entry screens.
* **Label always explicit** via `TextField("Label", ...)` or wrapping in `LabeledContent`. No placeholder-as-label.
* **Wrap controls** like `Slider` in `LabeledContent` when inside a `Form`. `LabeledContent` also works outside `Form` for title-value display.
* **Numeric input:** bind `TextField` to numeric value with `format: .number` initializer, plus `.keyboardType(.numberPad)` or `.keyboardType(.decimalPad)`. The keyboard type alone is NOT sufficient.
* **Validation:** use `.onChange()` for side effects, not `Binding(get:set:)`. See `references/data.md`.
* **Prefer `Label` over `HStack { Image; Text }`** for icon + text pairs. `Label` handles alignment and accessibility automatically.

### 4.7 Layout Discipline (Hard Rules)

* **Tab bars:** max 5 tabs, each with clear icon + label. Use the `Tab` API, not `.tabItem()`. Use enum-based selection, not integers or strings.
* **Navigation bars:** system standard height. Do not override with oversized custom navigation chrome.
* **Avoid fixed frames** unless content fits neatly inside at all Dynamic Type sizes and device sizes. Give frames flexibility: `.frame(maxWidth:)`, `.frame(idealWidth:)`, `ViewThatFits`.
* **Safe areas:** use `safeAreaInset()` for content that should be inset from edges. NEVER manually calculate safe area padding.
* **Section-Layout-Repetition Ban:** Do not repeat the same layout pattern for consecutive sections in a scrollable view. If you have a list of features, vary the presentation: card, full-width image + text, icon grid, horizontal scroll.
* **`List` vs `LazyVStack`:** use `List` when you need swipe actions, selection, or system styling. Use `LazyVStack` inside `ScrollView` when you need full visual control.
* **Scroll indicators:** use `.scrollIndicators(.hidden)` not `showsIndicators: false` in the initializer.

### 4.8 Image & Visual Asset Strategy

* **SF Symbols first** for all iconography.
* **`AsyncImage`** for remote images with proper `placeholder` and error content.
* **`Image(decorative:)`** for non-semantic images (backgrounds, textures). For asset catalog images that are decorative, use `accessibilityHidden()`. For images with unclear VoiceOver readings (e.g. `Image(.newBanner2026)`), attach `accessibilityLabel()`.
* **`.resizable()` + `.scaledToFit()` or `.scaledToFill()`** with proper `.clipShape()` for aspect ratio control.
* **Asset Catalog** for bundled images with @1x/@2x/@3x scale variants and light/dark variants.
* **Image generation tool** - if available in the environment, use it to create app-specific assets: onboarding illustrations, empty state graphics, hero images.
* **NO placeholder gray rectangles.** If an image is needed and unavailable, use SF Symbols, system placeholders, or generate one. A gray `Rectangle()` is not a placeholder - it is missing work.
* **When rendering SwiftUI views to images**, use `ImageRenderer` not `UIGraphicsImageRenderer`.

### 4.9 Content Density

* **Default content shape per screen section:** short headline + short supporting text + one visual or one action. Anything more must be justified.
* **Long lists need structure.** Use `Section` headers to group items. Use `.searchable()` for filterable content. Use `NavigationLink` to detail views instead of inline expansion for dense data.
* **No data-dump views.** A scrollable view with 30 unsectioned rows is lazy. Group, section, or paginate.
* **COPY SELF-AUDIT (mandatory before ship):** Re-read every visible string: labels, buttons, alerts, navigation titles, body text, accessibility labels. Flag grammatically broken text, AI hallucination phrases, filler verbs ("Elevate", "Seamless", "Unleash"). Rewrite every flagged string.
* **Fake-precise numbers are flagged.** Numbers either come from real data, are labeled as mock, or are banned. Do not fake engineering precision.
* **Use proper formatting.** `Text(value, format: .number)`, `Text(date, format: .dateTime)`, `Text(price, format: .currency(code: "USD"))`. NEVER use `String(format: "%.2f", value)`. See `references/swift.md`.
* **Automatic grammar agreement:** use `Text("^[\(count) item](inflect: true)")` for English, French, German, Portuguese, Spanish, and Italian. Do not manually pluralize.

### 4.10 App Theme Lock (Light / Dark Mode Consistency)

* The app has ONE color scheme strategy. Views do not randomly flip.
* Use Asset Catalog named colors with automatic light/dark adaptation, or system semantic colors.
* Do not manually check `colorScheme` to set colors when Asset Catalog named colors or semantic colors handle it automatically.
* Exception: if a specific view needs a forced color scheme (e.g., a media player that is always dark), use `.preferredColorScheme(.dark)` on that view. At most once per app unless there is a documented pattern.

---

## 5. CONTEXT-AWARE PROACTIVITY

These are tools, not defaults. Use them when the design read calls for them. **None of these fire automatically.**

* **Liquid Glass (iOS 26):** Appropriate for premium consumer, Apple-adjacent vibes. Use `.glassEffect` and `.containerBackground()`. For older targets, use system materials. Do not approximate Liquid Glass with manual material stacking.
* **Spring Animations:** Default animation curve for SwiftUI. Use `withAnimation(.spring(duration: 0.5, bounce: 0.3))` or the presets `.bouncy`, `.snappy`, `.smooth`. Spring physics are the iOS personality - linear easing is wrong for interactive elements.
* **Matched Geometry Effect:** Use `matchedGeometryEffect(id:in:)` for shared element transitions between views. Requires a `@Namespace`. Use when `MOTION_INTENSITY > 5` AND the transition communicates a spatial relationship.
* **Phase Animator:** Use `PhaseAnimator` for multi-step animation sequences. Cleaner than chained `withAnimation` calls for complex choreography. See `references/views.md`.
* **Scroll Transitions:** `.scrollTransition()` modifier for items that animate based on scroll position. Use when `MOTION_INTENSITY > 5`.
* **Chained Animations:** use `withAnimation { } completion: { withAnimation { } }` pattern. NEVER use delays or `DispatchQueue.main.asyncAfter` for animation sequencing. See `references/views.md`.
* **`@Animatable` macro:** strongly prefer over manual `animatableData`. Use `@AnimatableIgnored` for properties that should not animate (Booleans, integers, etc.). See `references/views.md`.
* **"Motion claimed, motion shown."** If `MOTION_INTENSITY > 4`, the app must actually animate: spring transitions on navigation, scroll-reveal on lists, haptic feedback on key actions, at minimum. A static app that claims `MOTION_INTENSITY: 7` is broken. Conversely, if you cannot ship working motion, drop the dial to 3 and ship a clean static app.

### 5.A Spring-Animated List - Canonical Skeleton

```swift
struct AnimatedListView: View {
    let items: [Item]
    @State private var appeared = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    ItemRow(item: item)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(
                            .spring(duration: 0.6, bounce: 0.3)
                            .delay(Double(index) * 0.05),
                            value: appeared
                        )
                }
            }
            .padding()
        }
        .task { appeared = true }
    }
}
```

Critical points: `.spring()` not `.linear`, stagger via `.delay()`, trigger on `.task` not `.onAppear`, `LazyVStack` for performance, `animation` has `value:` parameter.

### 5.B Matched Geometry Transition - Canonical Skeleton

```swift
struct ExpandableCardContainer: View {
    let items: [Item]
    @State private var selectedID: Item.ID?
    @Namespace private var animation

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    ExpandableCard(
                        item: item,
                        selectedID: $selectedID,
                        namespace: animation
                    )
                }
            }
            .padding()
        }
    }
}

struct ExpandableCard: View {
    let item: Item
    @Binding var selectedID: Item.ID?
    var namespace: Namespace.ID

    private var isExpanded: Bool { selectedID == item.id }

    var body: some View {
        Group {
            if isExpanded {
                DetailView(item: item)
                    .matchedGeometryEffect(id: item.id, in: namespace)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                            selectedID = nil
                        }
                    }
            } else {
                CompactCard(item: item)
                    .matchedGeometryEffect(id: item.id, in: namespace)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                            selectedID = item.id
                        }
                    }
            }
        }
    }
}
```

Critical points: same `id` and `namespace` for both states, `.spring()` animation, clean state toggle. Note: `onTapGesture` is acceptable here for matched geometry; add `.accessibilityAddTraits(.isButton)`.

### 5.C Scroll Transition - Canonical Skeleton

```swift
ScrollView {
    LazyVStack(spacing: 16) {
        ForEach(items) { item in
            ItemCard(item: item)
                .scrollTransition { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.3)
                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                }
        }
    }
    .padding()
}
```

Use this for: feature lists, card grids, anything that needs "appear on scroll." Save matched geometry for actual spatial transitions.

### 5.D Forbidden Animation Patterns

* **`Timer.publish` for UI animation** is banned. Use SwiftUI animation APIs or `TimelineView`.
* **`DispatchQueue.main.asyncAfter` for timing** is banned. Use `withAnimation { } completion: { }` for chaining, or `Task.sleep(for:)` inside `.task`.
* **`CADisplayLink` in SwiftUI views** is banned. Use `TimelineView` for frame-based updates.
* **`animation(nil)` or `.animation(.default)`** without a `value:` parameter is banned. Always provide `value:`.
* **Manual `animatableData`** is banned. Use the `@Animatable` macro. See `references/views.md`.
* **Multiple `withAnimation` calls using delays** for sequencing is banned. Use `completion:` closures.

### 5.E Motion Must Be Motivated (mandatory)
Before adding any animation, ask: "what does this animation communicate?" Valid answers: hierarchy (drawing attention), storytelling (revealing in sequence), feedback (acknowledging action), state transition (showing change). Invalid answer: "it looked cool." Every `.spring()`, every `.matchedGeometryEffect`, every `.scrollTransition` needs a reason.

---

## 6. PERFORMANCE & ACCESSIBILITY GUARDRAILS

### 6.A Performance (see `references/performance.md` for full rules)
* **`LazyVStack` / `LazyHStack`** for scrollable content with many children. Flag eager stacks with many items.
* **Avoid `AnyView`** - use `@ViewBuilder`, `Group`, or generics.
* **View initializers must be trivial.** Move work to `.task()`.
* **`body` is called frequently.** Move sorting, filtering, and heavy computation out of `body`.
* **Ternary for toggling modifiers** (`.opacity(isVisible ? 1 : 0)`) over `if/else` view branching to preserve structural identity and avoid `_ConditionalContent`.
* **Break views into separate `View` structs**, not computed properties. This is genuinely more efficient, even with `@ViewBuilder`.
* **Avoid inline formatters.** Use `Text(date, format:)` directly, not `DateFormatter` instances.
* **`task()` over `onAppear()`** for async work - it cancels automatically on disappear.
* **No escaping `@ViewBuilder` closures** on views when avoidable - store built view results instead. See `references/performance.md` for the pattern.
* **Opaque static scroll backgrounds:** use `scrollContentBackground(.visible)` for scroll-edge rendering efficiency.
* **Avoid expensive inline transforms** in `List`/`ForEach` initializers. Cache with `let` or `@State` (but own invalidation if caching in `@State`).

### 6.B Accessibility (see `references/accessibility.md` for full rules)
* **Dynamic Type support is mandatory.** No hardcoded font sizes without `@ScaledMetric` or `.scaled(by:)`.
* **Every interactive element must have a text label** visible to VoiceOver. `Button("Label", systemImage:)` not icon-only.
* **`Image(decorative:)` or `accessibilityHidden()`** for non-semantic images.
* **Respect `accessibilityReduceMotion`** - replace complex animations with opacity fades.
* **Respect `accessibilityReduceTransparency`** - provide solid backgrounds when transparency is reduced.
* **Respect `accessibilityDifferentiateWithoutColor`** - differentiate with icons, patterns, or strokes, not just color.
* **Minimum 44x44pt tap targets.** Apple's strict minimum.
* **WCAG AA contrast ratios** for all text against backgrounds.

### 6.C Dark Mode (mandatory)
* Design for **both modes from the start.** Never ship light-only without explicit instruction.
* Use Asset Catalog named colors with light/dark variants, or system semantic colors.
* Test in both modes before declaring done.
* Respect system appearance. Add a manual toggle only if the brand requires it.

### 6.D Reduced Motion (mandatory)
* **Any motion above `MOTION_INTENSITY > 3` MUST honor `accessibilityReduceMotion`.** Non-negotiable.
* Check via `@Environment(\.accessibilityReduceMotion) var reduceMotion`.
* Degrade: replace springs and transitions with instant state changes or opacity fades.
* Phase animators, matched geometry effects, scroll transitions MUST collapse to static under reduced motion.

---

## 7. DIAL DEFINITIONS (Technical Reference)

### DESIGN_VARIANCE (Level 1-10)
* **1-3 (System Standard):** Pure system components, default `List` styling, system navigation, no custom views. App looks like Settings or Contacts.
* **4-6 (Styled System):** System components with custom colors, custom fonts, branded but recognizable as standard iOS. App looks like Health or Fitness.
* **7-8 (Custom Visual Layer):** Custom card layouts, custom button styles, branded typography, but system navigation and data patterns underneath. App looks like App Store or Music.
* **9-10 (Fully Bespoke):** Fully custom visual identity, custom shapes, custom transitions, artisanal typography. Still uses `NavigationStack` under the hood but the chrome is original. App looks like a design-award winner.
* **IPAD OVERRIDE:** For levels 7-10, custom layouts on iPad MUST adapt to the larger canvas - no phone-width centered column on an iPad Pro. Use `NavigationSplitView`, `Grid`, or adaptive columns.

### MOTION_INTENSITY (Level 1-10)
* **1-3 (Static):** No custom animations. System transitions only. `accessibilityReduceMotion` is the default mode anyway.
* **4-6 (Fluid):** `.spring()` on state changes, `.transition()` on insert/remove, basic `.scrollTransition()`, `.sensoryFeedback()` on key actions.
* **7-8 (Choreographed):** Matched geometry transitions, phase animators, staggered list entries, scroll-driven effects, gesture-driven springs.
* **9-10 (Cinematic):** Complex multi-phase animations, custom `TimelineView` animations, gesture-driven physics, particle-like effects. MUST degrade gracefully under reduced motion.

### VISUAL_DENSITY (Level 1-10)
* **1-3 (Spacious):** Large padding (24-32pt), generous spacing (20-24pt), one primary content block visible per screen section. Lots of breathing room.
* **4-6 (Standard iOS):** System-default padding (16pt), standard list spacing, typical iOS app density. Comfortable, familiar.
* **7-8 (Compact):** Tighter spacing (8-12pt), more items visible per screen, condensed cards, smaller fonts. Efficient use of space.
* **9-10 (Dashboard):** Minimal padding (4-8pt), dense data grids, monospaced numbers (`.monospacedDigit()`), maximum information per viewport. Every pixel earns its place.

---

## 8. DARK MODE PROTOCOL

Dual-mode by default. Never assume light-only.

### 8.A Token Strategy (pick one, stick to it)
* **Asset Catalog named colors** (recommended): define colors with "Any Appearance" and "Dark Appearance" variants in the Asset Catalog. Reference via `Color("colorName")` or, when configured, generated symbols like `Color(.brandPrimary)`.
* **Semantic system colors** (default): `.primary`, `.secondary`, `Color(.systemBackground)`, `Color(.secondarySystemBackground)` - adapt automatically and are always correct.
* **Design constants enum:** if using custom colors, define them in a shared enum and provide light/dark values via Asset Catalog. Do not use `colorScheme` checks to swap colors manually when Asset Catalog handles it.

### 8.B Do Not Prescribe Specific Colors Here
The brief and brand decide. This skill enforces only:
* **Contrast** - WCAG AA minimum.
* **Hierarchy parity** - visual hierarchy that works in light must work in dark.
* **Brand fidelity** - primary brand color stays recognisable in both modes.
* **No pure `Color.black` or `Color.white`** for backgrounds - use system semantic colors that have proper depth.

### 8.C Default Mode
Respect system appearance. Add a manual toggle only if the brand requires it.

### 8.D Test in Both Modes Before Finishing
Build and run in both modes during development. Do not ship an app you have only seen in one mode.

---

## 9. AI TELLS (Forbidden Patterns)

Avoid these signatures unless the brief explicitly asks for them.

### 9.A Code Architecture Tells (Deprecated API - see `references/api.md`)
* **NO `ObservableObject` / `@Published` / `@StateObject` / `@ObservedObject` / `@EnvironmentObject`** in new code. Use `@Observable` + `@State` + `@Environment`. (See `references/data.md`)
* **NO `NavigationView`** - use `NavigationStack` or `NavigationSplitView`. (See `references/navigation.md`)
* **NO `NavigationLink(destination:)`** - use `navigationDestination(for:)`. (See `references/navigation.md`)
* **NO `foregroundColor()`** - use `foregroundStyle()`.
* **NO `cornerRadius()`** - use `clipShape(.rect(cornerRadius:))`.
* **NO `tabItem()`** - use the `Tab` API.
* **NO `onAppear` for async work** - use `.task()`. (See `references/performance.md`)
* **NO `GeometryReader` when alternatives exist** - use `containerRelativeFrame()`, `visualEffect()`, or `Layout` protocol.
* **NO `DispatchQueue`** - use modern Swift concurrency. (See `references/swift.md`)
* **NO `UIScreen.main.bounds`** - use `containerRelativeFrame()` or `GeometryReader` as last resort. (See `references/design.md`)
* **NO `AnyView`** - use `@ViewBuilder`, `Group`, or generics. (See `references/performance.md`)
* **NO `String(format: "%.2f")`** - use `FormatStyle` APIs. (See `references/swift.md`)
* **NO `animation()` without `value:`** parameter. (See `references/views.md`)
* **NO `overlay(Text("Hello"))` deprecated form** - use `overlay { Text("Hello") }`.
* **NO `PreviewProvider`** - use `#Preview`. (See `references/views.md`)
* **NO `@State` on reference types** for observation. Use `@Observable` classes.
* **NO `import Combine`** unless actually using Combine publishers.
* **NO `.navigationBarLeading` / `.navigationBarTrailing`** - use `.topBarLeading` / `.topBarTrailing`.
* **NO 1-parameter `onChange()`** - use the 0-parameter or 2-parameter variant.
* **NO `UIImpactFeedbackGenerator`** - use `.sensoryFeedback()`.
* **NO `WKWebView` via `UIViewRepresentable`** on iOS 26 - use SwiftUI's native `WebView` (with `import WebKit`).
* **NO `Text` concatenation with `+`** - use text interpolation: `Text("\(styled1)\(styled2)")`.
* **NO `showsIndicators: false`** - use `.scrollIndicators(.hidden)`.
* **NO `Date()` when you mean now** - use `Date.now`.
* **NO `replacingOccurrences(of:with:)`** - use Swift-native `replacing(_:with:)`.
* **NO `Task.sleep(nanoseconds:)`** - use `Task.sleep(for:)`.
* **NO manual `EnvironmentKey`** pattern - use the `@Entry` macro.

### 9.B Visual & Design Tells
* **NO "VStack { Text; Text; Text; Button }" centered screens.** The LLM default. Every screen is a centered stack of text views. Break it.
* **NO three equal cards in an HStack.** The equivalent of the web three-column feature cards.
* **NO generic gray `Rectangle()` placeholders.** Use SF Symbols, `ContentUnavailableView`, or generated assets.
* **NO hardcoded font sizes** without Dynamic Type support.
* **NO raw system colors** (`Color.red`, `Color.blue`) for UI elements. Use semantic or custom named colors. System colors are acceptable for data visualization where the color itself conveys meaning.
* **NO `Color.black` or `Color.white`** for backgrounds. Use system semantic colors that adapt to dark mode.
* **NO oversized custom navigation bars** replacing the system navigation bar.
* **NO emoji in button labels or section headers.** Use SF Symbols.

### 9.C Content Tells
* **NO generic names.** "John Doe", "Sarah Chen" -> creative, realistic, locale-appropriate names.
* **NO filler verbs.** "Elevate", "Seamless", "Unleash", "Next-Gen" -> concrete, specific language.
* **NO fake-perfect numbers.** `99.99%`, `50%` -> organic data.
* **NO startup-slop app names.** "SmartFlow", "Nexus", "TaskMaster" -> contextual, premium names.

### 9.D EM-DASH BAN (the single most-violated Tell)

**Em-dash (`-`) is COMPLETELY banned.** Zero em-dashes anywhere in visible text: labels, buttons, alerts, navigation titles, body text, accessibility labels.

* Use a period, comma, colon, or restructure the sentence.
* Date/number ranges use a hyphen (`-`).
* Attribution uses a hyphen with spaces (` - `) or a line break.

If your output contains a single em-dash or en-dash used as a separator anywhere visible to the user, the output fails the Pre-Flight Check.

---

## 10. REFERENCE VOCABULARY (Pattern Names the Agent Should Know)

This is a vocabulary, not a library. The agent should KNOW these pattern names to communicate about them and reach for them when the design read calls for them.

### App Structure Patterns
* **Tab-Based App** - `TabView` with `Tab` items, enum-based selection. Default for consumer apps with 3-5 primary sections.
* **Sidebar Split** - `NavigationSplitView` with sidebar, optional content column, detail. Default for iPad and Mac Catalyst.
* **Modal Flow** - `.sheet(item:)` or `.fullScreenCover` for task-focused flows. Editing, creation, onboarding.
* **Onboarding Carousel** - `TabView` with `.page` style for first-run experience.

### List & Detail Patterns
* **Master-Detail** - `NavigationStack` with `List` and `navigationDestination(for:)`.
* **Sectioned List** - `List` with `Section` headers and search via `.searchable()`.
* **Expandable Sections** - `DisclosureGroup` for collapsible content.
* **Swipe Actions** - `.swipeActions()` for contextual operations.
* **Pull to Refresh** - `.refreshable()` for async data reload.

### Card & Grid Patterns
* **Bento Grid** - `LazyVGrid` with mixed column sizes for Apple-style tile grouping.
* **Horizontal Carousel** - `ScrollView(.horizontal)` with `.scrollTargetBehavior(.viewAligned)`.
* **Stacked Cards** - `ZStack` with offset cards, tap to expand with matched geometry.

### Animation Patterns
* **Matched Geometry Hero** - shared element transition between list and detail.
* **Phase Animation Sequence** - `PhaseAnimator` for multi-step state animations.
* **Scroll-Driven Reveal** - `.scrollTransition()` for items entering the viewport.
* **Spring List Stagger** - staggered spring animations on list appearance.
* **Haptic Feedback Loop** - `.sensoryFeedback()` tied to meaningful state changes.

### Empty & Error Patterns
* **Content Unavailable** - `ContentUnavailableView` for missing data.
* **Search Empty** - `ContentUnavailableView.search` for no search results.
* **Skeleton Loading** - `.redacted(reason: .placeholder)` matching layout shape.
* **Inline Error** - contextual error text below form fields.

---

## 11. MODERNIZATION PROTOCOL

This skill handles **greenfield builds AND modernization** of existing UIKit or legacy SwiftUI apps. Misclassifying the mode is the single biggest source of bad modernization output.

### 11.A Detect the Mode (first action)
* **Greenfield** - new app, no existing code. Dial baseline from Section 1.
* **Modernize - Preserve** - update deprecated APIs, adopt new patterns, keep app identity.
* **Modernize - Overhaul** - new visual language, modern architecture, preserve data models and content.

If ambiguous, ask **once**: *"Should this modernization preserve the existing look and feel, or are we starting visually from scratch?"*

### 11.B Audit Before Touching
Document the current state before proposing changes:
* **Architecture** - UIKit? old SwiftUI? mixed? `ObservableObject` vs `@Observable`? Navigation patterns?
* **Deprecated APIs** - scan for `foregroundColor`, `NavigationView`, `cornerRadius`, `tabItem`, `onAppear` for async, etc. See `references/api.md` for the full list.
* **Data flow** - `@StateObject`? `@EnvironmentObject`? `ObservableObject`? Plan migration to `@Observable`.
* **Accessibility** - existing Dynamic Type support? VoiceOver labels? Reduced motion?
* **Patterns to preserve** - navigation flows, data models, brand identity, user expectations.
* **Patterns to retire** - UIKit wrappers where SwiftUI now has equivalents, deprecated APIs, performance anti-patterns.

### 11.C Preservation Rules
* **Do not change navigation flow** unless asked.
* **Preserve data models** unless asked for a migration.
* **Honor existing accessibility.** Do not regress focus states, VoiceOver labels, Dynamic Type support.
* **Keep existing app icon, brand colors, and general identity** unless the brief is a full rebrand.
* **Respect existing analytics events.** Do not rename buttons or tracked elements.

### 11.D Modernisation Levers (priority order)
Apply in order - stop when the brief is satisfied:
1. **API update** - replace all deprecated APIs (biggest risk reduction per unit of effort). See `references/api.md`.
2. **Data flow migration** - `ObservableObject` -> `@Observable`.
3. **Navigation migration** - `NavigationView` -> `NavigationStack`/`NavigationSplitView`.
4. **Typography + color refresh** - adopt semantic styles, clean up hardcoded values.
5. **Motion layer** - add `MOTION_INTENSITY`-appropriate animations.
6. **Full view replacement** - only when existing views are unsalvageable.

### 11.E What Never Changes Silently
Never modify without explicit user approval:
* Data model schemas (breaking changes).
* Navigation flow (user muscle memory).
* Stored data formats (migration required).
* App icon or launch screen.
* Accessibility features (regression risk).

---

## 12. THE BLOCK LIBRARY (Contract - Implementations Land Here Iteratively)

The Reference Vocabulary (Section 10) names patterns. The Block Library implements them with real props and real code.

**Status:** schema defined here. Blocks will be added iteratively. Do not freelance new blocks without following this schema.

### 12.A File Location
```
skills/design-taste-swiftui/blocks/
  app-structure/
    tab-based.md
    sidebar-split.md
    modal-flow.md
    ...
  list-detail/
    master-detail.md
    sectioned-list.md
    ...
  cards-grids/
    bento-grid.md
    horizontal-carousel.md
    ...
  onboarding/
  settings/
  profile/
  media/
  empty-states/
  animation/
```

### 12.B Required Frontmatter
```yaml
---
name: tab-based-app
category: app-structure
dial_compatibility:
  variance: [3, 10]
  motion: [2, 6]
  density: [3, 7]
when_to_use: "Default app structure for consumer apps with 3-5 primary sections."
not_for: "Document-based apps. Master-detail productivity apps."
platforms: [iOS, iPadOS]
min_deployment: iOS 17
---
```

### 12.C Required Body Sections
1. **Visual sketch** - short description of the layout.
2. **Props API** - the View's interface (init parameters).
3. **Code sketch** - minimal working implementation.
4. **iPad adaptation** - explicit rules for larger screens.
5. **Motion variants** - one variant per `MOTION_INTENSITY` band (1-3, 4-6, 7-10). Reduced-motion fallback explicit.
6. **Dark-mode notes** - token strategy specific to this block.
7. **Accessibility notes** - Dynamic Type, VoiceOver, reduced motion considerations.
8. **Anti-patterns** - common ways this block goes wrong.

### 12.D Block-Library Discipline
* One block per file. No multi-block files.
* Every block must work standalone (drop it into a project, it compiles).
* Every block must pass the Pre-Flight Check (Section 14).

---

## 13. OUT OF SCOPE

This skill is NOT for:
* **Games** (use SpriteKit, SceneKit, or Metal directly).
* **AR experiences** (use RealityKit + visionOS APIs).
* **watchOS complications** (different constraints and design patterns).
* **Widgets** (use WidgetKit with its own timeline and sizing constraints).
* **Pure UIKit apps** (use Apple HIG directly; this skill is SwiftUI-first).
* **Server-side Swift** (Vapor, Hummingbird - different domain).
* **SwiftData schema design** (suggest the SwiftData Pro agent skill).
* **Complex concurrency architecture** (suggest the Swift Concurrency Pro agent skill).
* **Unit/UI testing strategy** (suggest the Swift Testing Pro agent skill).

If the brief is one of the above, **say so explicitly**, point to the right tool, and only apply this skill's patterns to the SwiftUI surfaces where they apply.

---

## 14. FINAL PRE-FLIGHT CHECK

Run this matrix before outputting code. This is the last filter.

**THIS IS NOT OPTIONAL. Run every box. If any box fails, the output is not done.**

### Brief & Configuration
- [ ] **Brief inference** declared (Section 0.B one-liner)?
- [ ] **Dial values** explicit and reasoned from the brief, not silently using baseline?
- [ ] **Design approach** chosen from Section 2 (system-leaning vs custom)?

### Modern API Compliance (see `references/api.md`)
- [ ] **ZERO `foregroundColor()`** - all replaced with `foregroundStyle()`?
- [ ] **ZERO `cornerRadius()`** - all replaced with `clipShape(.rect(cornerRadius:))`?
- [ ] **ZERO `NavigationView`** - all replaced with `NavigationStack` or `NavigationSplitView`?
- [ ] **ZERO `NavigationLink(destination:)`** - all replaced with `navigationDestination(for:)`?
- [ ] **ZERO `tabItem()`** - all replaced with `Tab` API?
- [ ] **ZERO `onAppear` for async work** - all replaced with `.task()`?
- [ ] **ZERO `GeometryReader` where alternatives exist** - using `containerRelativeFrame()`, `visualEffect()`, or `Layout`?
- [ ] **ZERO deprecated `overlay(_:alignment:)`** - using `overlay { }` form?
- [ ] **ZERO `.navigationBarLeading`/`.navigationBarTrailing`** - using `.topBarLeading`/`.topBarTrailing`?
- [ ] **ZERO `UIImpactFeedbackGenerator`** - using `.sensoryFeedback()`?
- [ ] **ZERO `String(format:)`** for display - using `FormatStyle` APIs?

### Data Flow (see `references/data.md`)
- [ ] **`@Observable` classes marked `@MainActor`** (unless project uses MainActor default isolation)?
- [ ] **ZERO `ObservableObject` / `@Published` / `@StateObject` / `@ObservedObject`** in new code?
- [ ] **ZERO `Binding(get:set:)` in view body** - using `@State` + `.onChange()`?
- [ ] **`@State` is `private`** and only owned by the creating view?
- [ ] **Structs conform to `Identifiable`** rather than using `id: \.someProperty`?
- [ ] **Custom environment keys use `@Entry` macro** not legacy `EnvironmentKey`?

### Views & Architecture (see `references/views.md`)
- [ ] **One type per file** - no files with multiple struct/class/enum definitions?
- [ ] **Subviews are separate `View` structs**, not computed properties returning `some View`?
- [ ] **Button actions in methods**, not inline closures in `body`?
- [ ] **`#Preview`** used, not `PreviewProvider`?
- [ ] **No escaping `@ViewBuilder` closures** stored on views?
- [ ] **`TextField` with `axis: .vertical`** used instead of `TextEditor` where appropriate?

### Performance (see `references/performance.md`)
- [ ] **`LazyVStack`/`LazyHStack`** for scrollable content with many items?
- [ ] **ZERO `AnyView`** - using `@ViewBuilder`, `Group`, or generics?
- [ ] **View initializers are trivial** - heavy work moved to `.task()`?
- [ ] **Ternary for toggling modifiers** over `if/else` view branching where appropriate?
- [ ] **No expensive inline transforms** in `List`/`ForEach` initializers?

### Accessibility (see `references/accessibility.md`)
- [ ] **Dynamic Type** - no hardcoded font sizes without `@ScaledMetric` or `.scaled(by:)`?
- [ ] **VoiceOver** - every button has a text label, every meaningful image has an `accessibilityLabel`?
- [ ] **Reduced Motion** honored for `MOTION_INTENSITY > 3`?
- [ ] **Reduced Transparency** honored for material backgrounds?
- [ ] **Differentiate Without Color** - not relying on color alone for meaning?
- [ ] **Minimum 44x44pt tap targets** enforced?
- [ ] **WCAG AA contrast** on all text?
- [ ] **Decorative images** use `Image(decorative:)` or `accessibilityHidden()`?

### Design Quality
- [ ] **Color Consistency Lock** - one accent color used throughout?
- [ ] **Shape Consistency Lock** - one corner-radius system applied consistently?
- [ ] **Design constants** in a shared enum, not scattered magic numbers?
- [ ] **No AI Tells** from Section 9 (deprecated APIs, VStack dumps, gray rectangles, emoji labels)?
- [ ] **Dark mode** tested in both color schemes?
- [ ] **Content density** sane - no data dumps, no unsectioned long lists?
- [ ] **No "three equal cards in HStack"** default feature layout?

### Swift Code Quality (see `references/swift.md`)
- [ ] **ZERO `DispatchQueue`** - using modern Swift concurrency?
- [ ] **ZERO force unwraps** without justification?
- [ ] **`Date.now` not `Date()`**, `if let value {` not `if let value = value {`?
- [ ] **No C-style string formatting** - using `FormatStyle` APIs?
- [ ] **Errors not swallowed silently** - user-facing errors shown in alerts?
- [ ] **`Double` preferred over `CGFloat`** except in optionals/`inout`?
- [ ] **`count(where:)` used instead of `.filter().count`**?
- [ ] **`localizedStandardContains()` for user text filtering** not `contains()`?

### Content & Copy
- [ ] **ZERO em-dashes** anywhere in visible text?
- [ ] **Copy self-audit** passed - no AI hallucination phrases, no filler verbs?
- [ ] **Fake-precise numbers** labeled as mock or backed by real data?
- [ ] **Grammar agreement** uses inflection API (`^[...](inflect: true)`) where applicable?

### Hygiene (see `references/hygiene.md`)
- [ ] **No secrets in source** - API keys in keychain or environment?
- [ ] **No sensitive data in `@AppStorage`** - passwords etc. in keychain?
- [ ] **Comments present** where logic is not self-evident?
- [ ] **One type per Swift file** enforced?

If a single checkbox cannot be honestly ticked, the code is not done. Fix it before delivering.

---

## References

These reference files provide detailed technical rules for specific domains. Load the relevant ones during review or when writing code in that area.

- `references/accessibility.md` - Dynamic Type, VoiceOver, Reduce Motion, and other accessibility requirements.
- `references/api.md` - updating code for modern API, and the deprecated code it replaces.
- `references/data.md` - data flow, shared state, and property wrappers.
- `references/design.md` - guidance for building accessible apps that meet Apple's Human Interface Guidelines.
- `references/hygiene.md` - making code compile cleanly and be maintainable in the long term.
- `references/navigation.md` - navigation using `NavigationStack`/`NavigationSplitView`, plus alerts, confirmation dialogs, and sheets.
- `references/performance.md` - optimizing SwiftUI code for maximum performance.
- `references/swift.md` - tips on writing modern Swift code, including using Swift Concurrency effectively.
- `references/views.md` - view structure, composition, and animation.

---

## Appendix A - Canonical Apple Documentation

These are the official references. Consult them before reinventing.

### SwiftUI
- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/tutorials/swiftui

### Human Interface Guidelines
- https://developer.apple.com/design/human-interface-guidelines
- https://developer.apple.com/design/human-interface-guidelines/components
- https://developer.apple.com/design/human-interface-guidelines/patterns

### SF Symbols
- https://developer.apple.com/sf-symbols/
- https://developer.apple.com/documentation/swiftui/image/init(systemname:)

### Accessibility
- https://developer.apple.com/accessibility/
- https://developer.apple.com/documentation/swiftui/accessibility

### Liquid Glass (iOS 26)
- https://developer.apple.com/documentation/TechnologyOverviews/liquid-glass
- https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass
- https://developer.apple.com/documentation/SwiftUI/Material

### Swift
- https://docs.swift.org/swift-book/
- https://developer.apple.com/documentation/swift/concurrency

### Related Agent Skills
- SwiftData: https://github.com/twostraws/swiftdata-agent-skill
- Swift Concurrency: https://github.com/twostraws/swift-concurrency-agent-skill
- Swift Testing: https://github.com/twostraws/swift-testing-agent-skill
