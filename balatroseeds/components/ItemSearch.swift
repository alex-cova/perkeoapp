//
//  ItemSearch.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//
import Foundation

/// The categories shown in `JokerSelectorView`, in display order.
///
/// Every case's `items` conforms to `Stored` (see `Enums.swift`), which `JokerFile.search(_:)`
/// (`Perkeo.swift`) requires to map a selection onto the compressed seed database. If a future
/// category is added whose items do NOT conform to `Stored`, `JokerFile.search` will silently
/// drop it from cached/instant search results.
enum ItemCategory: String, CaseIterable, Identifiable {
    case legendary
    case rare
    case uncommon
    case common
    case vouchers
    case spectrals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .legendary: "Legendary"
        case .rare: "Rare Jokers"
        case .uncommon: "Uncommon"
        case .common: "Common"
        case .vouchers: "Vouchers"
        case .spectrals: "Spectrals"
        }
    }

    var items: [any Item] {
        switch self {
        case .legendary: LegendaryJoker.allCases
        case .rare: RareJoker.allCases
        case .uncommon: UnCommonJoker.allCases
        case .common: CommonJoker.allCases
        case .vouchers: Voucher.allCases
        case .spectrals: Spectral.allCases.filter { !$0.isRetry() }
        }
    }
}

/// One rendered section of the picker grid: a category plus the items that survived filtering,
/// already ranked best-match-first.
struct ItemSection: Identifiable {
    let category: ItemCategory
    let items: [any Item]

    var id: String { category.id }
}

/// Filtering and ranking logic for the item picker, kept free of SwiftUI so it can run once per
/// query change (not once per section per render) and be unit tested directly.
enum ItemSearch {

    /// Builds ranked, non-empty sections for the given categories and query.
    ///
    /// Ranking tiers (best first): whole-name prefix, word prefix, substring, initials, then a
    /// fuzzy (Levenshtein) fallback compared per-word when nothing else matched.
    static func sections(query: String, categories: [ItemCategory]) -> [ItemSection] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        return categories.compactMap { category in
            let items = rank(category.items, query: trimmed)
            return items.isEmpty ? nil : ItemSection(category: category, items: items)
        }
    }

    private static func rank(_ items: [any Item], query: String) -> [any Item] {
        guard !query.isEmpty else { return items }
        let needle = query.lowercased()

        var tiered: [Int: [any Item]] = [:]
        for item in items {
            guard let tier = tier(for: item.rawValue, needle: needle) else { continue }
            tiered[tier, default: []].append(item)
        }

        for tier in 0...3 {
            if let matches = tiered[tier] {
                return matches
            }
        }

        // Fuzzy fallback only when nothing else matched, compared per-word so a query like
        // "clown" can still find "Chaos the Clown" instead of scoring against the full name.
        guard needle.count >= 2, needle.count <= 12 else { return [] }
        return items.filter { item in
            item.rawValue.lowercased().split(separator: " ").contains { word in
                levenshtein(String(word), needle) < 2
            }
        }
    }

    private static func tier(for name: String, needle: String) -> Int? {
        let lowered = name.lowercased()
        let words = lowered.split(separator: " ").map(String.init)

        if lowered.hasPrefix(needle) { return 0 }
        if words.contains(where: { $0.hasPrefix(needle) }) { return 1 }
        if lowered.localizedStandardContains(needle) { return 2 }
        if initials(words) == needle { return 3 }
        return nil
    }

    private static func initials(_ words: [String]) -> String {
        words.compactMap(\.first).map(String.init).joined().lowercased()
    }

    static func levenshtein(_ aStr: String, _ bStr: String) -> Int {
        let a = Array(aStr)
        let b = Array(bStr)

        let empty = [Int](repeating: 0, count: b.count + 1)
        var last = [Int](0...b.count)

        for (i, aChar) in a.enumerated() {
            var current = [i + 1] + empty
            for (j, bChar) in b.enumerated() {
                current[j + 1] = aChar == bChar
                    ? last[j]
                    : min(last[j], last[j + 1], current[j]) + 1
            }
            last = current
        }

        return last[b.count]
    }
}
