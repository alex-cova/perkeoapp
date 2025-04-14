//
//  JokerSelectorView.swift
//  balatroseeds
//
//  Created by Alex on 15/03/25.
//
import SwiftUI

struct JokerSelectorView : View {
    
    @Binding var selections : [ItemEdition]
    @State var showSelected : Bool = false
    @State var search : String = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HStack {
                Text("Joker Selection")
                    .font(.customTitle)
                    .padding()
                    .foregroundStyle(.white)
                
                Text("\(selections.count) of 10")
                    .font(.customCaption)
                    .foregroundStyle(selections.count == 10 ? .red : .white)
            }
            
            HStack {
                TextField("Search", text: $search)
                    .font(.customBody)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    withAnimation(.easeInOut){
                        showSelected.toggle()
                    }
                }, label: {
                    Image(systemName: showSelected ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                }).buttonStyle(.borderedProminent)
            }.padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            ScrollView {
                if showSelected && selections.isEmpty  {
                    Text("Nothing selected")
                        .font(.customBody)
                        .foregroundStyle(.white)
                }else {
                    if showSelected {
                        render(selections, name: "Selections")
                    }else {
                        renderLegendary()
                        render(Voucher.allCases, name: "Vouchers")
                        render(RareJoker.allCases, name: "Rare Jokers")
                        render(UnCommonJoker.allCases, name: "Uncommon")
                        render(CommonJoker.allCases, name: "Common")
                        render(Spectral.allCases.filter {
                            !$0.rawValue.starts(with: "RETRY")
                        }, name: "Spectrals")
                        
                    }
                    
                }
            }
        }.background(Color(hex: "#4d4d4d"))
    }
    
    private func filter(_ items : [any Item]) -> [any Item] {
        if search.isEmpty {
            return items
        }
        
        let prefx = search.lowercased()
        
        return items.filter {
            $0.rawValue.lowercased().hasPrefix(prefx) || $0.rawValue.lowercased().hasSuffix(prefx)
        }
    }
    
    @ViewBuilder
    private func renderLegendary() -> some View{
        VStack {
            Text("Legendary")
                .foregroundStyle(.white)
                .font(.customBody)
            LazyVGrid(columns: columns) {
                ForEach(filter(LegendaryJoker.allCases), id: \.rawValue) { joker in
                    legendarySelectableJoker(joker as! LegendaryJoker)
                        .transition(.push(from: .bottom))
                }
            }.padding()
        }
    }
    
    @ViewBuilder
    private func render(_ items : [Item], name : String) -> some View{
        VStack {
            Text(name)
                .foregroundStyle(.white)
                .font(.customBody)
            LazyVGrid(columns: columns) {
                ForEach(filter(items), id: \.rawValue) { joker in
                    if let i = joker as? ItemEdition, let x = i.item as? LegendaryJoker {
                        legendarySelectableJoker(x)
                            .transition(.push(from: .bottom))
                    }else {
                        selectableJoker(joker)
                            .transition(.push(from: .bottom))
                    }
                }
            }.padding()
        }
    }
    
    @ViewBuilder
    private func selectableJoker(_ joker : Item) -> some View {
        SelectableJokerView(selections: $selections, joker: joker)
    }
    
    @ViewBuilder
    private func legendarySelectableJoker(_ joker : LegendaryJoker) -> some View {
        LegendarySelectableJokerView(selections: $selections, joker: joker)
    }
}

struct LegendarySelectableJokerView : View {
    
    @Binding var selections : [ItemEdition]
    let joker : LegendaryJoker
    
    var selected : Bool {
        get {
            selections.first(where: { $0.item.rawValue == joker.rawValue }) != nil
        }
    }
    
    var body: some View {
        ZStack {
            joker.sprite(color: selected ? .gray : .white)
                .opacity(selected ? 0.3 : 1.0)
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }.onTapGesture {
            if selections.contains(where: { $0.rawValue == joker.rawValue}) {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }else if selections.count < 10 {
                selections.append(ItemEdition(item: joker))
            }
        }
    }
}

struct SelectableJokerView : View {
    
    @Binding var selections : [ItemEdition]
    let joker : Item
    
    var selected : Bool {
        get {
            selections.first(where: { $0.item.rawValue == joker.rawValue }) != nil
        }
    }
    
    var body: some View {
        ZStack {
            joker.sprite(color: selected ? .gray : .white)
                .opacity(selected ? 0.3 : 1.0)
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
                    .font(.title)
                
            }
        }.onTapGesture {
            if selections.contains(where: { $0.rawValue == joker.rawValue}) {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }else if selections.count < 10 {
                selections.append(ItemEdition(item: joker))
            }
        }
    }
}

#Preview {
    @Previewable @State var selections : [ItemEdition] = []
    JokerSelectorView(selections: $selections)
}
