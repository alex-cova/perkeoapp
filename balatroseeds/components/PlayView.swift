//
//  PlayView.swift
//  balatroseeds
//
//  Created by Alex on 28/01/25.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct PlayView : View {
    @EnvironmentObject var model : AnalyzerViewModel
    
    init(){
        
    }
    
    var body: some View {
        LoadingView(isShowing: $model.isLoading) {
            mainView()
        }
    }

    @ViewBuilder
    private func mainView() -> some View {
        if let run = model.run {
            ScrollView {
                if run.antes.count >= 8 {
                    Text("Seed score: \(run.score)")
                        .foregroundStyle(.white)
                        .font(.customCaption)
                }
                ForEach(run.antes) { a in
                    anteView(ante: a, run: run)
                        .padding(.bottom)
                }
            }.background(Color.customBackground)
        } else {
            Text("Loading...")
                .font(.customBody)
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func anteView(ante: Ante, run : Run) -> some View {
        VStack(alignment: .leading) {
            Text("Ante \(ante.ante)")
                .bold()
                .font(.customTitle)
                .foregroundStyle(.white)
            separator()
            options(ante: ante, run: run)
            Text("Shop queue")
                .font(.customBody)
                .foregroundStyle(.white)
                .padding(.top)
            separator()
            ScrollView(.horizontal) {
                shopView(ante: ante)
            }
            packsView(ante: ante)
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func separator() -> some View {
        Rectangle()
            .foregroundStyle(Color.customRowBackground)
            .frame(height: 1)
            .padding(.bottom, 4)
    }
    

    @ViewBuilder
    func options(ante: Ante, run : Run) -> some View {
        HStack {
            ante.voucher.sprite()
                .padding(.horizontal)
            
                HStack {
                    ante.boss.sprite()
                    if !ante.tags.isEmpty {
                        ante.tags[0].sprite()
                        ante.tags[1].sprite()
                    }
                }
            
            
        }.padding(.horizontal)
    }
    
    private func astList(set : Set<Tag>) -> [Tag] {
        var list : [Tag] = []
        list.append(contentsOf: set)
        return list
    }
    
    @ViewBuilder
    func packsView(ante : Ante) -> some View {
        ForEach(ante.packs) { pack in
            VStack {
                HStack(spacing: 10) {
                    Text("\(pack.type.rawValue)")
                        .font(.customBody)
                        .foregroundStyle(.white)
                    Text(choiceText(pack.choices))
                        .font(.customCaption)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(.blue)
                                .frame(minWidth: 55)
                                
                        }
                }
                separator()
                if(pack.options.count > 4){
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(pack.options) { option in
                                optionView(option: option, ante: ante)
                            }
                        }
                    }
                } else {
                    HStack {
                        ForEach(pack.options) { option in
                            optionView(option: option, ante: ante)
                        }
                    }
                }
            }.padding(.top)
        }
    }
    
    private func choiceText(_ options : Int) -> String {
        if options == 1 {
            return "Choose 1"
        }
        
        return "\(options) choices"
    }
    
    @ViewBuilder
    private func optionView(option: EditionItem, ante : Ante) -> some View {
        option.item.sprite(edition: option.edition)
    }
    
    @ViewBuilder
    func shopView(ante : Ante) -> some View {
        HStack {
            ForEach(ante.shopQueue) { item in
                VStack {
                    item.item.sprite(edition: item.edition ?? .NoEdition)
                }
            }
        }
    }
}

struct EditionView: ViewModifier {
    var edition: Edition
    
    @ViewBuilder
    private func getImage(_ index: Int) -> some View {
        let frame = CGRect(x: index * 71, y: 0, width: 71, height: 95)
        if let cgImage = Images.editions.cgImage?.cropping(to: frame) {
            Image(decorative: cgImage, scale: Images.editions.scale, orientation: .up)
                .resizable()
                .frame(width: frame.width, height: frame.height)
        }else{
            Text("fuck")
        }
    }
    
    func body(content: Content) -> some View {
        if(edition == .Foil) {
            ZStack {
                content
                getImage(1)
            }
        }else if(edition == .Holographic){
            ZStack {
                content
                getImage(2)
            }
        }else if(edition == .Polychrome){
            ZStack {
                content
                getImage(3)
            }
        }else if(edition == .Negative){
            content.colorInvert()
        }else {
            content
        }
    }
}

#Preview {
    NavigationStack {
        PlayView()
            .environmentObject(AnalyzerViewModel(memoryOnly: true)
                .test())
    }
}
