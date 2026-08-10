//
//  ConfigView.swift
//  balatroseeds
//
//  Created by Alex on 18/04/25.
//
import SwiftUI

struct ConfigView: View {

    @EnvironmentObject var model: AnalyzerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var startingAnte = 1
    @State private var maxAnte = 8
    @State private var showman = false
    @State private var autoBuyVoucher = true
    @State private var deck: Deck = .RED_DECK
    @State private var stake: Stake = .White_Stake
    @State private var disabledItems: [Item] = []
    @State private var disabledKeys: Set<String> = []
    @State private var baselineFingerprint = ""
    @State private var didCommit = false
    @State private var selectionTick = 0

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible()),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if model.activeTab == .analyzer {
                        Button(action: pasteSeed) {
                            label("Paste Seed", systemImage: "document.on.clipboard")
                        }.font(.customBody)
                    }

                    Button(action: copySeed) {
                        label("Copy Seed", systemImage: "document.on.document")
                    }.font(.customBody)

                    Button(action: saveSeed) {
                        label("Save Seed", systemImage: "square.and.arrow.down")
                    }.font(.customBody)

                    Stepper {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundStyle(.red)
                                Text("starting ante: **\(startingAnte)**")
                                    .foregroundStyle(.white)
                                    .font(.customBody)
                            }
                        }
                    } onIncrement: {
                        startingAnte = min(29, startingAnte + 1)
                        if startingAnte > maxAnte { maxAnte += 1 }
                    } onDecrement: {
                        startingAnte = max(1, startingAnte - 1)
                    }

                    Stepper {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.yellow)
                                Text("max ante: **\(maxAnte)**")
                                    .foregroundStyle(.white)
                                    .font(.customBody)
                            }
                            Text("Deeper ante search is slower!")
                                .foregroundStyle(.white)
                                .font(.customCaption)
                        }
                    } onIncrement: {
                        maxAnte = min(30, maxAnte + 1)
                    } onDecrement: {
                        maxAnte = max(1, maxAnte - 1)
                        if maxAnte < startingAnte {
                            startingAnte = maxAnte
                        }
                    }

                    Toggle(isOn: $showman) {
                        Text("Showman")
                            .font(.customBody)
                    }
                    .foregroundStyle(.white)
                    .tint(.red)

                    Picker("Deck", selection: $deck) {
                        ForEach(Deck.allCases, id: \.rawValue) { deck in
                            HStack(spacing: 10) {
                                Text(deck.rawValue)
                                    .font(.customBody)
                                deck.sprite(animated: false)
                            }
                            .tag(deck)
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.customBody)
                    .tint(.red)

                    Picker("Stake", selection: $stake) {
                        ForEach(Stake.allCases, id: \.rawValue) { stake in
                            HStack {
                                stake.sprite(animated: false)
                                Text(stake.rawValue)
                                    .foregroundStyle(.white)
                                    .font(.customBody)
                            }
                            .tag(stake)
                        }
                    }
                    .font(.customBody)
                    .foregroundStyle(.white)
                    .tint(.red)
                }
                .listRowBackground(Color(hex: "#2d2d2d"))

                Section {
                    Toggle(isOn: $autoBuyVoucher) {
                        Text("Auto buy vouchers")
                            .font(.customBody)
                            .foregroundStyle(.white)
                    }
                    .tint(.red)

                    if !autoBuyVoucher {
                        HStack {
                            Image(systemName: "checkmark.rectangle.portrait.fill")
                                .foregroundStyle(.gray)
                            Text("Select the vouchers you have purchased")
                                .foregroundStyle(.gray)
                                .font(.customBody)
                        }
                        DisclosureGroup("Vouchers") {
                            renderVoucher(Voucher.allCases, columns: columns, selectedKeys: disabledKeys, toggle: toggleDisabled)
                        }
                        .foregroundStyle(.white)
                        .font(.customBody)
                    }
                }
                .listRowBackground(Color(hex: "#2d2d2d"))

                Section {
                    HStack {
                        Image(systemName: "xmark.rectangle.portrait.fill")
                            .foregroundStyle(.gray)
                        Text("Select the jokers you have already purchased")
                            .foregroundStyle(.gray)
                            .font(.customBody)
                    }

                    DisclosureGroup("Legendary Jokers") {
                        renderItems(LegendaryJoker.allCases, columns: columns, selectedKeys: disabledKeys, showman: showman, toggle: toggleDisabled)
                    }
                    .foregroundStyle(.white)
                    .font(.customBody)

                    DisclosureGroup("Rare Jokers") {
                        renderItems(RareJoker.allCases, columns: columns, selectedKeys: disabledKeys, showman: showman, toggle: toggleDisabled)
                    }
                    .foregroundStyle(.white)
                    .font(.customBody)

                    DisclosureGroup("Uncommon Jokers") {
                        renderItems(UnCommonJoker.allCases, columns: columns, selectedKeys: disabledKeys, showman: showman, toggle: toggleDisabled)
                    }
                    .foregroundStyle(.white)
                    .font(.customBody)

                    DisclosureGroup("Common Jokers") {
                        renderItems(CommonJoker.allCases, columns: columns, selectedKeys: disabledKeys, showman: showman, toggle: toggleDisabled)
                    }
                    .foregroundStyle(.white)
                    .font(.customBody)
                }
                .listRowBackground(Color(hex: "#2d2d2d"))
            }
            .background(Color(hex: "#1e1e1e"))
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                doneButton()
            }
            .sensoryFeedback(.selection, trigger: selectionTick)
            .task {
                loadDraft()
            }
            .onDisappear {
                commitIfNeeded(analyze: true)
            }
        }
    }

    @ViewBuilder
    private func doneButton() -> some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: finish) {
                Text("Done")
                    .font(.customBody)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding()
        }
        .background(Color(hex: "#1e1e1e"))
    }

    private func loadDraft() {
        startingAnte = model.startingAnte
        maxAnte = model.maxAnte
        showman = model.showman
        autoBuyVoucher = model.autoBuyVoucher
        deck = model.deck
        stake = model.stake
        disabledItems = model.disabledItems
        disabledKeys = Set(model.disabledItems.map(\.rawValue))
        baselineFingerprint = fingerprint()
        didCommit = false
    }

    private func fingerprint() -> String {
        let keys = disabledKeys.sorted().joined(separator: ",")
        return "\(startingAnte)|\(maxAnte)|\(showman)|\(autoBuyVoucher)|\(deck.rawValue)|\(stake.rawValue)|\(keys)"
    }

    private func toggleDisabled(_ item: Item) {
        if disabledKeys.contains(item.rawValue) {
            disabledKeys.remove(item.rawValue)
            disabledItems.removeAll { $0.rawValue == item.rawValue }
        } else {
            disabledKeys.insert(item.rawValue)
            disabledItems.append(item)
        }
        selectionTick &+= 1
    }

    private func pasteSeed() {
        commitIfNeeded(analyze: false)
        model.paste()
    }

    private func copySeed() {
        commitIfNeeded(analyze: false)
        model.copy()
    }

    private func saveSeed() {
        commitIfNeeded(analyze: false)
        model.store()
    }

    private func finish() {
        commitIfNeeded(analyze: true)
        dismiss()
    }

    private func commitIfNeeded(analyze: Bool) {
        guard !didCommit else { return }
        let changed = fingerprint() != baselineFingerprint
        model.startingAnte = startingAnte
        model.maxAnte = maxAnte
        model.showman = showman
        model.autoBuyVoucher = autoBuyVoucher
        model.deck = deck
        model.stake = stake
        model.disabledItems = disabledItems
        didCommit = true
        if analyze, changed {
            model.analyze()
        }
    }
}

#Preview {
    ConfigView()
        .environmentObject(AnalyzerViewModel(memoryOnly: true))
}
