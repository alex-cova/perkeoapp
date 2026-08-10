//
//  SelectionTray.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//
import SwiftUI

/// A persistent bottom tray showing the current selection, so reviewing or undoing a pick no
/// longer requires switching the grid into a separate "show selected" mode.
///
/// Long-pressing a chip opens an edition menu - this is what makes edition assignment
/// discoverable. It used to only work by tapping a sprite back on `FinderView`, only while the
/// legendary-cache search mode was on, and only cycled forward one edition at a time.
struct SelectionTray: View {
    @Binding var selections: [ItemEdition]
    let limit: Int
    let onRemove: (ItemEdition) -> Void

    private var isAdvisory: Bool {
        selections.count > 6
    }

    var body: some View {
        if !selections.isEmpty {
            VStack(spacing: 8) {
                Divider()

                HStack {
                    Text("^[\(selections.count) item](inflect: true) selected")
                        .font(.customCaption)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Spacer()
                    Text("\(selections.count) / \(limit)")
                        .font(.customCaption)
                        .foregroundStyle(selections.count >= limit ? .red : .secondary)
                }
                .padding(.horizontal)

                if selections.count >= limit {
                    Text("Remove one to add another")
                        .font(.customCaption)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                } else if isAdvisory {
                    Text("Fewer items means more seeds found")
                        .font(.customCaption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(selections, id: \.rawValue) { item in
                            SelectionChip(item: item, onRemove: { onRemove(item) })
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.vertical, 8)
            .background(Color.customRowBackground)
        }
    }
}

/// One removable, edition-editable chip inside the `SelectionTray`.
///
/// Observes the wrapped `ItemEdition` directly (it is `ObservableObject`) so an edition change
/// redraws just this chip - no more removing and re-appending the whole selections array to
/// force SwiftUI to notice a mutation buried inside a class.
private struct SelectionChip: View {
    @ObservedObject var item: ItemEdition
    let onRemove: () -> Void

    var body: some View {
        Button(action: onRemove) {
            item.sprite()
        }
        .buttonStyle(.plain)
        .contextMenu {
            ForEach(Edition.allCases.filter(isSelectable), id: \.self) { edition in
                Button(edition.rawValue) {
                    item.edition = edition
                }
            }
        }
        .accessibilityLabel(item.rawValue)
        .accessibilityHint("Double tap to remove. Long press to change edition.")
    }

    private func isSelectable(_ edition: Edition) -> Bool {
        switch edition {
        case .NoEdition, .Negative, .Foil, .Holographic, .Polychrome: true
        default: false
        }
    }
}
