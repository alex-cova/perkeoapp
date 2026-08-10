//
//  SelectableItemCell.swift
//  balatroseeds
//
//  Created by Alex on 09/08/26.
//
import SwiftUI

/// A single tappable sprite in the item picker grid.
///
/// Replaces the old `LegendarySelectableJokerView`/`SelectableJokerView` pair - `Item.sprite()`
/// already special-cases `LegendaryJoker` internally, so one cell covers every category.
///
/// Selection and "blocked by the selection cap" are kept visually distinct: selection is shown
/// with a border and a checkmark badge (not opacity), while blocked is the only state that dims
/// the sprite. Dimming previously meant both, which made a chosen item look unavailable.
struct SelectableItemCell: View {
    let item: any Item
    let isSelected: Bool
    let isBlocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 2)
                    .opacity(isSelected ? 1.0 : 0.0)
                    .padding(2)

                item.sprite(color: .white, animated: false)
                    .opacity(isBlocked ? 0.35 : 1.0)

                if isSelected {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                                .background(Circle().fill(.white))
                                .accessibilityHidden(true)
                        }
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isBlocked)
        .accessibilityLabel(item.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
