//
//  JokerSelectorView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//
import SwiftUI

/// The Finder's item picker: search, filter by category, and pick up to `selectionLimit` items
/// (jokers, vouchers, spectrals) to constrain a seed search.
struct JokerSelectorView: View {

    @Binding var selections: [ItemEdition]
    @Environment(\.dismiss) private var dismiss
    @FocusState private var searchFocused: Bool

    @State private var query = ""
    @State private var debouncedQuery = ""
    @State private var activeFilter: PickerFilter = .all
    @State private var sections: [ItemSection] = []
    @State private var selectionTick = 0
    @State private var blockedTick = 0

    private let selectionLimit = 20
    private let columns = [GridItem(.adaptive(minimum: 79), spacing: 8)]

    private enum PickerFilter: Hashable {
        case all
        case selected
        case category(ItemCategory)
    }

    private var selectedKeys: Set<String> {
        Set(selections.map(\.rawValue))
    }

    private var atLimit: Bool {
        selections.count >= selectionLimit
    }

    private var categoriesToShow: [ItemCategory] {
        if case .category(let category) = activeFilter {
            return [category]
        }
        return ItemCategory.allCases
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                    if activeFilter == .selected {
                        selectedSection()
                    } else if sections.isEmpty {
                        ContentUnavailableView.search(text: debouncedQuery)
                            .foregroundStyle(.white)
                            .padding(.top, 40)
                    } else {
                        ForEach(sections) { section in
                            categorySection(section)
                        }
                    }
                }
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.customBackground)
            .safeAreaInset(edge: .top, spacing: 0) {
                topControls()
                    .background(Color.customBackground)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                SelectionTray(selections: $selections, limit: selectionLimit, onRemove: remove)
            }
            .navigationTitle("Select Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear", action: clearAll)
                        .font(.customBody)
                        .tint(.red)
                        .disabled(selections.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction)
                        .font(.customBody)
                        .tint(.red)
                }
            }
            .sensoryFeedback(.selection, trigger: selectionTick)
            .sensoryFeedback(.warning, trigger: blockedTick)
            .task(id: query) {
                try? await Task.sleep(for: .milliseconds(150))
                guard !Task.isCancelled else { return }
                debouncedQuery = query
            }
            .task(id: debouncedQuery) {
                recomputeSections()
            }
            .task(id: activeFilter) {
                recomputeSections()
            }
        }
    }

    private func recomputeSections() {
        sections = ItemSearch.sections(query: debouncedQuery, categories: categoriesToShow)
    }

    @ViewBuilder
    private func topControls() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Select Items")
                    .font(.customTitle)
                    .foregroundStyle(.white)
                Spacer(minLength: 8)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .accessibilityHidden(true) // redundant with the navigation title, kept for the pixel-art header look

            searchField()
                .padding(.horizontal)

            filterChips()

            Divider()
        }
    }

    @ViewBuilder
    private func searchField() -> some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
            TextField("Search", text: $query)
                .font(.customBody)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .focused($searchFocused)
                .foregroundStyle(.white)

            if !query.isEmpty {
                Button("Clear search", systemImage: "xmark.circle.fill", action: clearQuery)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(Color.gray)
        .clipShape(.rect(cornerRadius: 8))
    }

    @ViewBuilder
    private func filterChips() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                filterChip("All", filter: .all)
                filterChip("Selected (\(selections.count))", filter: .selected)
                ForEach(ItemCategory.allCases) { category in
                    filterChip(category.title, filter: .category(category))
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private func filterChip(_ title: String, filter: PickerFilter) -> some View {
        let isActive = activeFilter == filter
        Button(title) {
            activeFilter = filter
        }
        .font(.customCaption)
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .frame(minHeight: 44)
        .background(isActive ? Color.red : Color.customRowBackground)
        .clipShape(.rect(cornerRadius: 8))
    }

    @ViewBuilder
    private func selectedSection() -> some View {
        if selections.isEmpty {
            ContentUnavailableView(
                "Nothing selected",
                systemImage: "rectangle.stack.badge.minus",
                description: Text("Pick up to \(selectionLimit) jokers, vouchers, or spectrals.")
            )
            .foregroundStyle(.white)
            .padding(.top, 40)
        } else {
            grid(selections.map(\.item))
        }
    }

    @ViewBuilder
    private func categorySection(_ section: ItemSection) -> some View {
        Section {
            grid(section.items)
        } header: {
            Text(section.category.title)
                .font(.customBody)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color.customBackground)
        }
    }

    @ViewBuilder
    private func grid(_ items: [any Item]) -> some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items, id: \.rawValue) { item in
                let selected = selectedKeys.contains(item.rawValue)
                SelectableItemCell(
                    item: item,
                    isSelected: selected,
                    isBlocked: !selected && atLimit,
                    onTap: { toggle(item) }
                )
            }
        }
        .padding(.horizontal)
    }

    private func toggle(_ item: any Item) {
        if selectedKeys.contains(item.rawValue) {
            selections.removeAll { $0.rawValue == item.rawValue }
            selectionTick &+= 1
        } else if !atLimit {
            selections.append(ItemEdition(item: item))
            selectionTick &+= 1
        } else {
            blockedTick &+= 1
        }
    }

    private func remove(_ item: ItemEdition) {
        selections.removeAll { $0.rawValue == item.rawValue }
        selectionTick &+= 1
    }

    private func clearAll() {
        selections.removeAll()
        selectionTick &+= 1
    }

    private func clearQuery() {
        query = ""
        searchFocused = false
    }
}

#Preview {
    @Previewable @State var selections: [ItemEdition] = []
    JokerSelectorView(selections: $selections)
}
