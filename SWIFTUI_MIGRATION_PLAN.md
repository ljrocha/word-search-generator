# SwiftUI Migration Plan — Word Search Generator

## Context

The app today is a UIKit/storyboard iOS app: tab bar with 7 view controllers, JSON persistence via `Other Controllers/DataModel.swift`, UserDefaults + NotificationCenter for settings, all-IBOutlet wiring. The branch `feature/scene-lifecycle-migration` has already migrated to Scene Lifecycle (Xcode 27 / iOS 27 target) but the UI itself is untouched.

**Goal**: Rewrite the app as a pure SwiftUI + SwiftData + CloudKit application using modern Swift 6.2 concurrency, in line with `~/.claude/CLAUDE.md` global rules. Decisions confirmed with the user:

- **Full clean-room rewrite** (delete storyboard + all view controllers; no UIHostingController bridging).
- **SwiftData + CloudKit** so lists sync across the user's devices.
- **One-time JSON → SwiftData seed migration** on first launch of the new version.
- **Localizable.xcstrings** with manual symbol keys for all user-facing strings.

---

## Architecture

```
Views (SwiftUI)  →  Models (@Observable + SwiftData @Model)  →  ModelContainer (CloudKit-backed)
                                ↑
                       SettingsStore (@AppStorage)
```

- **App entry**: `@main struct WordSearchGeneratorApp: App` injects a CloudKit-enabled `ModelContainer` and an `@Observable SettingsStore` via `.environment(_:)`.
- **Navigation**: `TabView` using the new `Tab` API; each tab has its own `NavigationStack` with `navigationDestination(for:)`.
- **State**: SwiftData's `@Model` for `WordList`; `@Observable` for any non-persisted view state; `@AppStorage` for app settings.
- **PDF rendering**: SwiftUI-native via `ImageRenderer` (iOS 16+). Split `WordSearch.swift` into (a) a pure-algorithm core that returns a placed grid + word list as Sendable value types, and (b) a `PuzzlePageView` SwiftUI view that draws the grid with `Canvas` and the title/word list with `Text`. A `PuzzlePDFRenderer` uses `ImageRenderer.render(rasterizationScale:renderer:)` with a `CGContext(consumer:mediaBox:)` PDF context to write the SwiftUI view into PDF pages. No more `UIGraphicsPDFRenderer`.

---

## SwiftData Models (CloudKit-safe)

`WordSearchGenerator/Models/WordList.swift`

```swift
import Foundation
import SwiftData

@Model
final class WordList {
    var title: String = ""
    var words: [String] = []
    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now

    init(title: String = "", words: [String] = []) {
        self.title = title
        self.words = words
    }

    func isOriginal(_ word: String) -> Bool {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        return !words.contains { $0.localizedCaseInsensitiveCompare(trimmed) == .orderedSame }
    }
}
```

**Why `[String]` instead of a relational `Word` entity**: each `WordList` is small, words are always read en-masse by the PDF renderer, and a separate entity would multiply CloudKit records by ~40× per list. SwiftData stores the array as a Codable blob — fully CloudKit-compatible. No `@Attribute(.unique)`, defaults on every property — meets CloudKit constraints.

`WordSearchGenerator/Models/SettingsStore.swift`

```swift
import SwiftUI

@MainActor @Observable
final class SettingsStore {
    @ObservationIgnored @AppStorage("gridSize")          var gridSize: Int = 10
    @ObservationIgnored @AppStorage("difficulty")        var difficulty: Int = 1
    @ObservationIgnored @AppStorage("wordsIncluded")     var wordsIncluded: Bool = true
    @ObservationIgnored @AppStorage("titleIncluded")     var titleIncluded: Bool = true
    @ObservationIgnored @AppStorage("gridLinesIncluded") var gridLinesIncluded: Bool = true
}
```

Settings stay in `@AppStorage`, not SwiftData — five scalars, written rarely, read on every PDF render. SwiftData would add container-open cost to a hot path for no benefit.

---

## File Layout (after migration)

```
WordSearchGenerator/
  WordSearchGeneratorApp.swift          ← @main
  AppDelegate.swift                      ← simplified to register UserDefaults defaults
  Models/
    WordList.swift                       ← SwiftData @Model
    SettingsStore.swift                  ← @AppStorage wrapper
    PuzzleSnapshot.swift                 ← Sendable input to the algorithm (title, words, settings)
    PlacedPuzzle.swift                   ← Sendable output of the algorithm (grid + placed words)
  Puzzle/
    WordSearchEngine.swift               ← pure algorithm, no UI/PDF dependencies, Sendable
    PuzzlePageView.swift                 ← SwiftUI view of one PDF page (Canvas grid + Text title/words)
    PuzzlePDFRenderer.swift              ← ImageRenderer + CGContext PDF writer
  Views/
    ContentView.swift                    ← TabView with Tab API
    Lists/
      AllListsView.swift                 ← @Query SwiftData, search, swipe-delete
      ListDetailSheet.swift              ← create/rename modal
    Words/
      WordListView.swift                 ← words in a list + Generate button
      WordEntrySheet.swift               ← add/edit word modal
    Puzzle/
      WordSearchView.swift               ← PDF preview + share
      PDFKitView.swift                   ← UIViewRepresentable wrapper around PDFView
    Settings/
      SettingsView.swift                 ← Form bound to SettingsStore
    Components/
      WSButtonStyle.swift                ← ButtonStyle (replaces WSButton)
      WSTextFieldStyle.swift             ← TextFieldStyle (replaces WSTextField)
  Utilities/
    LegacyJSONImporter.swift             ← one-time seed migration
  Resources/
    Localizable.xcstrings                ← string catalog, symbol keys, manual extraction
    Assets.xcassets                      ← unchanged
  Constants.swift                        ← keep UserDefaults keys + character limits;
                                           remove NotificationCenter key
WordSearchGeneratorTests/                ← rewritten with Swift Testing
```

---

## Legacy JSON → SwiftData Seed Migration

`Utilities/LegacyJSONImporter.swift`. Called once from `WordSearchGeneratorApp.init()` after the container is created.

Rules:

1. Gate on `UserDefaults.standard.bool(forKey: "didMigrateLegacyJSON")` — set true after a successful import. Idempotent.
2. Read `URL.documentsDirectory.appending(path: "WordLists.json")`. If absent, set the flag and exit (fresh install, or CloudKit-only second device).
3. Decode the legacy `[WordList]` JSON structure (a snapshot of the existing `Wordlist.swift` Codable shape lives inside the importer — do not depend on the new `@Model`'s Codable).
4. Insert all lists in a single `ModelContext.save()` so partial state never syncs to CloudKit.
5. After successful save: delete the JSON file, set the flag.
6. **Do not** dedupe against existing SwiftData rows — CloudKit may be mid-sync and showing in-flight duplicates that aren't really duplicates.

Run the import on a `ModelActor` (not the main actor) to keep cold-launch responsive.

---

## Implementation Order

1. **Project config**: bump Swift version to 6.2, enable strict concurrency, add iCloud + CloudKit capabilities, create CloudKit container `iCloud.<bundle-id>`.
2. **Models**: `WordList` (SwiftData), `SettingsStore` (@AppStorage), `PuzzleSnapshot` (Sendable input), `PlacedPuzzle` (Sendable algorithm output — 2D `[[Character]]` grid + placed-word coordinates).
3. **Split `WordSearch.swift`** into three pieces:
   - `Puzzle/WordSearchEngine.swift` — pure algorithm. Takes a `PuzzleSnapshot`, returns a `PlacedPuzzle`. No UIKit, no SwiftUI, no PDF. `Sendable`. Easily unit-testable with deterministic seeded RNG.
   - `Puzzle/PuzzlePageView.swift` — SwiftUI `View` representing one PDF page. Uses `Canvas` to draw the letter grid + optional gridlines; `Text` (Dynamic Type) for the title and word-list footer. Reads `SettingsStore` flags (`titleIncluded`, `wordsIncluded`, `gridLinesIncluded`) to decide what to include. Has a `#Preview` showing a sample puzzle.
   - `Puzzle/PuzzlePDFRenderer.swift` — given a `PuzzleSnapshot` and a `PlacedPuzzle`, builds a `PuzzlePageView`, instantiates `ImageRenderer(content:)`, creates a US-Letter `CGContext` via `CGContext(consumer:mediaBox:_:)` against a `CGDataConsumer` wrapping a `CFMutableData`, then calls `renderer.render { _, render in pdfContext.beginPDFPage(...); render(pdfContext); pdfContext.endPDFPage() }` for each page. Returns the `Data`.
4. **App entry + container**: `WordSearchGeneratorApp` with CloudKit-backed `ModelContainer`, `.environment(settings)`, `.modelContainer(container)`.
5. **Settings tab** first (smallest surface — Form + SettingsStore bindings; help alert; privacy link).
6. **All Lists tab**: `@Query(sort: \.title)`, swipe-delete, `.searchable`, create-list sheet.
7. **Word List screen**: list of words with `onDelete`, add/edit sheet, "Generate Word Search" `Button` styled with `WSButtonStyle`, disabled when empty.
8. **Word Search screen**: `PDFKitView` wrapping `PDFView`, share via `ShareLink`, refresh button, badge when settings changed since last render.
9. **Components**: `WSButtonStyle`, `WSTextFieldStyle` — replace UIKit subclasses, used by `.buttonStyle(.wsPrimary)` / `.textFieldStyle(.ws)` static extensions.
10. **Legacy JSON importer**, wired into App init.
11. **Localizable.xcstrings**: replace every hard-coded `Text("…")`, button label, alert title, navigation title with `Text(.symbolKey)` — `extractionState: "manual"`. English-only initially; offer to translate after wiring is complete.
12. **Delete UIKit layer**: `Main.storyboard`, `SceneDelegate.swift`, all 7 files under `View Controllers/`, `Views/WSButton.swift`, `Views/WSTextField.swift`, `Other Controllers/DataModel.swift`, `Model/Wordlist.swift`, `Extensions/UIViewController+Alert.swift`, `Extensions/UIApplication+AppVersion.swift`. Strip storyboard reference from Info.plist; remove the scene's `UISceneStoryboardFile`. AppDelegate keeps only `registerDefaults`.
13. **Tests** (Swift Testing — `@Test`, `#expect`):
    - `WordList.isOriginal(_:)` and word-count description logic.
    - `WordSearchEngine` against a known `PuzzleSnapshot` with a seeded RNG — assert every word is placed and all letters fit the grid. Pure value-type input/output makes this trivial.
    - `LegacyJSONImporter` with fixture JSON + an in-memory `ModelContainer(for:configurations: ModelConfiguration(isStoredInMemoryOnly: true))`.
    - `PuzzlePDFRenderer` smoke test: render a small puzzle, parse with `PDFKit.PDFDocument(data:)`, assert page count and that the puzzle title `String` appears in the page's `attributedString`.
    - Delete all 7 view-controller test files.

---

## Apple-Guidelines Checklist (applies throughout)

Per `~/.claude/CLAUDE.md`:

- `foregroundStyle(_:)` not `foregroundColor`; `clipShape(.rect(cornerRadius:))` not `cornerRadius`.
- `Tab(...) { ... }` not `.tabItem`.
- `NavigationStack` + `navigationDestination(for:)`.
- Two-parameter `onChange(of:_:)`, never the 1-arg form.
- `Task.sleep(for:)`, never `nanoseconds:`.
- Buttons with icons: `Button("Add", systemImage: "plus") { … }`.
- `localizedStandardContains` for `.searchable` filtering.
- `FormatStyle` everywhere (no `DateFormatter`, no `String(format:)`).
- Modern Foundation: `URL.documentsDirectory`, `.appending(path:)`.
- No `GeometryReader` where `containerRelativeFrame` / `visualEffect` works.
- No `ObservableObject`/`@Published`/`@StateObject` — use `@Observable` + `@State`/`@Bindable`/`@Environment`.
- Dynamic Type respected; never force font sizes.

---

## Verification

**Build** (Xcode MCP if available, else):

```bash
xcodebuild -project WordSearchGenerator.xcodeproj \
  -scheme WordSearchGenerator \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=27.0' build
```

**Test**:

```bash
xcodebuild test -project WordSearchGenerator.xcodeproj \
  -scheme WordSearchGeneratorTests \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=27.0'
```

**Manual checklist** (run on the simulator and at least one real device for CloudKit):

1. **Fresh install on device A** with the old build's `WordLists.json` present → first launch imports JSON, deletes file, sets flag; lists appear.
2. **All Lists**: create, rename, search (`.searchable` filter uses `localizedStandardContains`), swipe-delete.
3. **Word List**: add/edit/delete words; duplicate words rejected via `isOriginal(_:)`; non-letter input rejected; Generate button disabled on empty list.
4. **Word Search**: PDF previews; refresh produces a different valid puzzle; `ShareLink` exports the PDF; badge appears when settings change.
5. **Settings**: grid size stepper (4–20), difficulty segmented picker, three toggles persist.
6. **CloudKit**: install on device B with same iCloud account → existing lists sync down within seconds; create a list on B → appears on A.
7. **Dark Mode** + **Dynamic Type at AX5** across every screen.
8. **Localization sanity**: with the device language set to a non-English locale that has no translations yet, every string still falls back to English (no missing-key crashes).

---

## Out of Scope

- New features (clue-based puzzles, multi-language word lists, iPad-optimized layout).
- App Store assets, screenshots, marketing.
- Translating Localizable.xcstrings into non-English languages (set up now; translate as a separate task).
