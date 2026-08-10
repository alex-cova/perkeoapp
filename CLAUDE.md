# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Perkeo (Xcode project `balatroseeds`) is an iOS app for the game *Balatro*. It reimplements Balatro's Lua-based RNG and item-generation logic natively in Swift so that, given an 8-character seed, it can deterministically predict shop items, packs, jokers, vouchers, tags, and bosses for every ante *without playing the game*. On top of that prediction engine it offers seed analysis, a seed "Finder" (search for seeds matching desired joker/card combinations), saved seeds, a Home Screen widget, and App Intents/Shortcuts.

TestFlight: https://testflight.apple.com/join/hrM1hDDX

## Build, test, run

This is a standard Xcode project — there is no SwiftPM/CocoaPods/Carthage dependency management.

```bash
# List schemes/targets
xcodebuild -list -project balatroseeds.xcodeproj

# Build the app for the simulator
xcodebuild -project balatroseeds.xcodeproj -scheme balatroseeds \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run all tests (Swift Testing framework, not XCTest)
xcodebuild -project balatroseeds.xcodeproj -scheme balatroseeds \
  -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test
xcodebuild -project balatroseeds.xcodeproj -scheme balatroseeds \
  -destination 'platform=iOS Simulator,name=iPhone 16' test \
  -only-testing:balatroseedsTests/balatroseedsTests/analyze
```

There are two schemes: `balatroseeds` (main app + `balatroseedsTests` + `balatroseedsUITests`) and `PerkeoWidgetExtension` (the widget target, `PerkeoWidget/`). Normally use Xcode itself (open `balatroseeds.xcodeproj`) for iterative development; `xcodebuild` is for scripted/CI-style runs.

Tests use Swift's modern **Testing** framework (`import Testing`, `@Test` functions), not XCTest — see `balatroseedsTests/balatroseedsTests.swift`. Many existing tests are exploratory (they `print()` intermediate RNG values against hardcoded expected sequences to eyeball correctness) rather than strict `#expect` assertions — follow that style when adding RNG/generation verification tests, since these are the only reference points for whether the seed-generation port stays byte-for-byte compatible with the real game.

## Architecture

### The seed-generation engine (`balatroseeds/perkeo/`)

This is the core of the app: a from-scratch Swift port of Balatro's Lua PRNG and item-selection algorithms, ported so precisely that comments in the source still contain the original Java/Lua reference implementation for cross-checking.

- **`LuaRandom.swift`** — bit-exact reimplementation of Lua's `math.randomseed`/`math.random` (xoshiro-style PRNG operating on `UInt64` state derived from a `Double` seed). Everything downstream depends on this being exact.
- **`Util.swift`** — `pseudohash` (Balatro's string→double seed hashing) and `round13` (13-decimal rounding), the primitives Balatro uses to turn a seed string + a per-call ID into a PRNG input.
- **`Functions.swift`** (the workhorse, extends `Lock`) — one instance is created per `(seed, ante)`. It caches hashed PRNG "nodes" per unique ID string (`getNode`) and exposes `randint`/`random`/`randchoice`/`randweightedchoice`/`resample`, mirroring Balatro's own RNG call patterns exactly (same ID strings, same call order) so the sequence of pseudo-random draws lines up with the real game. Higher-level methods (`nextShopItem`, `nextPack`, `nextBuffoonPack`, `nextVoucher`, `nextTag`, `nextBoss`, etc.) replicate the game's actual generation algorithms including resampling/rarity/weighting rules.
- **`Lock.swift`** — tracks which jokers/items are "locked" (not yet unlocked in-game) vs unlocked, since locked items are excluded from `randchoice` pools exactly as in-game.
- **`Balatro.swift`** — top-level orchestrator. `Balatro().performAnalysis(seed:)` drives `Functions` ante-by-ante to build a full `Run` (shop queue, packs, vouchers, tags, boss) for as many antes as configured. `analyze*` flags let a run skip categories entirely; `configureForSpeed(selections:)` auto-disables analysis for everything not needed to answer a specific yes/no search question (used heavily by the Finder for fast bulk seed scanning).
- **`Play.swift` / `Structs.swift` / `Enums.swift`** — the data model: `Run` → `[Ante]` → shop queue / packs / voucher / tags / boss. `Enums.swift` is the large (1000+ line) catalog of every game enum (`Joker`, `Tarot`, `Planet`, `Spectral`, `Voucher`, `Tag`, `Boss`, `Cards`, `Edition`, `Deck`, `Stake`, `PackType`, …), each conforming to the `Item` protocol (`rawValue`/`ordinal`/`y` — `y`/`ordinal` map to sprite-sheet coordinates).
- **`RunScorer.swift`** — heuristic scoring of a completed `Run` (e.g. bonus points for legendary-joker synergy combos like Perkeo+Observatory+Blueprint) used to rank/sort candidate seeds in the Finder and pre-generated seed data.
- **`Seed32bit.swift`** — encode/decode between the 8-char alphanumeric seed string and a compact 32-bit representation, used by the compressed seed-data format.
- **`Cache.swift`** — simple per-`Functions`-instance node cache.
- **`Perkeo.swift`** — `JokerFile`: reads pre-generated seed databases bundled with the app (binary `.jkr` files — `perkeo.jkr` and the bit-packed `canio.jkr`) and does fast in-memory filtering (`search(_:)`) against a user's selected items, used by the Finder's "cached"/"instant" search modes as an alternative to brute-force live analysis.

When touching anything in `perkeo/`, correctness means matching the real game's output for a given seed exactly — there's no separate spec beyond the game itself and the commented-out reference code, so be conservative about "fixing" RNG-adjacent code without a concrete mismatch to correct.

### App layer (`balatroseeds/`)

- **`balatroseedsApp.swift`** — app entry point; owns the single `AnalyzerViewModel` and `JokerFile` as `@EnvironmentObject`s, and the SwiftData `ModelContainer`.
- **`AnalyzerViewModel.swift`** — the main app view model (`ObservableObject`). Holds the current seed/config (deck, stake, ante range, showman, disabled/excluded items) and runs `Balatro().performAnalysis` on a background queue (`DispatchQueue.global`) when the seed or config changes, publishing the resulting `Run` back on the main queue. Also handles seed normalization/validation, clipboard copy/paste, "seed of the day" (delegates to `Date.generateDailyCode()`, shared with the widget), and persisting seeds via SwiftData (`SeedModel`).
- **`SeedModel.swift`** — SwiftData `@Model` for user-saved seeds (title, level/rarity, score, timestamp).
- **`views/`** — top-level screens: `AnalyzerView` (main seed breakdown), `FinderView` (seed search UI — brute-force live search vs. cached/compressed `.jkr`-backed instant search), `SavedSeedsView`, `CommunityView`, `ResumeView` (run summary sheet).
- **`components/`** — reusable UI: `ConfigView` (deck/stake/ante/analysis-flags sheet), `JokerSelectorView`, `SeedInput`, `SaveSeedView`, `SpriteView`/`Sprite.swift` (renders game sprites from the bundled sprite sheets in `Images`, using `y`/`ordinal` from `Item`), `InfiniteScrollView`, `ToastView`, `LoaderView`.
- **`Intents.swift`** — App Intents/Shortcuts integration (e.g. "Copy random seed in Perkeo").
- **`LookAndFeel.swift`** — global UI styling setup, invoked once from `ContentView.init()`.
- **`*.json` (bosses, jokers, tags, tarots, vouchers)** — static game metadata bundled with the app.
- **`canio.jkr` / `perkeo/perkeo.jkr`** — pre-generated binary seed databases (see `Perkeo.swift` above for the format) consumed by the Finder.

### Widget (`PerkeoWidget/`)

Separate WidgetKit extension target. `PerkeoWidget.swift` shows the deterministic "seed of the day" (`Date.generateDailyCode()`, a SHA256-based daily code — note this is a *different, independent* code generator from the game-accurate seed engine in `perkeo/`, used only for a shareable daily-challenge-style code). Duplicates some `Font`/`Color` styling from the main app since it's a separate target/bundle.

## Working conventions

- iOS-version branching is common (e.g. `if #available(iOS 18, *)` in `ContentView.swift` for the newer `Tab`-based `TabView` API vs. a fallback for iOS 17). Preserve both branches when editing tab/navigation UI.
- `Item` (in `Enums.swift`) is the base abstraction nearly everything in the generation engine and UI sprite rendering is built on — new game content categories should conform to it rather than introducing a parallel type.
