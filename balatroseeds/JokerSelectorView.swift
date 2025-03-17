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
                    .foregroundStyle(.white)
            }
            
            HStack {
                TextField("Search", text: $search)
                    .font(.customBody)
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
                LazyVGrid(columns: columns) {
                    if showSelected {
                        render(selections)
                    }else {
                        ForEach(filter(LegendaryJoker.allCases), id: \.rawValue) { joker in
                            legendarySelectableJoker(joker as! LegendaryJoker)
                                .transition(.push(from: .bottom))
                        }
                        render(RareJoker.allCases)
                        render(UnCommonJoker.allCases)
                        render(CommonJoker.allCases)
                        render(Spectral.allCases)
                    }
                }.padding()
            }
        }.background(Color(hex: "#4d4d4d"))
    }
    
    private func filter(_ items : [any Item]) -> [any Item] {
        if search.isEmpty {
            return items
        }
        
        return items.filter {
            $0.rawValue.hasPrefix(search)
        }
    }
    
    @ViewBuilder
    private func render(_ items : [Item]) -> some View{
        ForEach(filter(items), id: \.rawValue) { joker in
            selectableJoker(joker)
                .transition(.push(from: .bottom))
        }
    }
    
    @ViewBuilder
    private func selectableJoker(_ joker : Item) -> some View {
        let selected = selections.first(where: { $0.rawValue == joker.rawValue }) != nil
        
        SelectableJokerView(selected: selected, joker: joker, onSelect: { j in
            if selections.count == 10 {
                return
            }
            
            if(j){
                if !selections.contains(where: { $0.rawValue == joker.rawValue}){
                    selections.append(ItemEdition(item: joker))
                }
            } else {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }
        })
    }
    
    @ViewBuilder
    private func legendarySelectableJoker(_ joker : LegendaryJoker) -> some View {
        let selected = selections.first(where: { $0.rawValue == joker.rawValue }) != nil
        
        LegendarySelectableJokerView(selected: selected, joker: joker, onSelect: { j in
            if selections.count == 10 {
                return
            }
            
            if(j){
                if !selections.contains(where: { $0.rawValue == joker.rawValue}){
                    selections.append(ItemEdition(item: joker))
                }
            } else {
                selections.removeAll(where: {
                    $0.rawValue == joker.rawValue
                })
            }
        })
    }
}

struct LegendarySelectableJokerView : View {
    
    @State var selected = false
    let joker : LegendaryJoker
    let onSelect : (Bool) -> Void
    
    init(selected: Bool = false, joker: LegendaryJoker, onSelect: @escaping (Bool) -> Void) {
        self._selected = State(initialValue: selected)
        self.joker = joker
        self.onSelect = onSelect
    }
    
    var body: some View {
        ZStack {
            joker.sprite(color: selected ? .white : .gray)
                .opacity(selected ? 0.3 : 1.0)
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }.onTapGesture {
            selected.toggle()
            onSelect(selected)
        }
    }
}

struct SelectableJokerView : View {
    
    @State var selected = false
    let joker : Item
    let onSelect : (Bool) -> Void
    
    init(selected: Bool = false, joker: Item, onSelect: @escaping (Bool) -> Void) {
        self._selected = State(initialValue: selected)
        self.joker = joker
        self.onSelect = onSelect
    }
    
    var body: some View {
        ZStack {
            joker.sprite(color: selected ? .white : .gray)
                .opacity(selected ? 0.3 : 1.0)
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
                    .font(.title)
                
            }
        }.onTapGesture {
            selected.toggle()
            onSelect(selected)
        }
    }
}

#Preview {
    @Previewable @State var selections : [ItemEdition] = []
    JokerSelectorView(selections: $selections)
}
