//
//  Components.swift
//  balatroseeds
//
//  Created by Alex on 13/03/25.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case analyzer = "Analyzer"
    case finder = "Finder"
    case community = "Community"
    case saved = "Saved"
    
    var symbolImage: String {
        switch self {
        case .analyzer: "sparkle.magnifyingglass"
        case .finder: "mail.and.text.magnifyingglass"
        case .community: "person.3.fill"
        case .saved: "externaldrive"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

/// Interactive Tab Bar
struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    /// View Properties
    @Namespace private var animation
    /// Storing the locations of the Tab buttons so that they can be used to identify the currently dragged tab
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    /// By using this, we can animate the changes in the tab bar without animating the actual tab view. When the gesture is released, the changes are pushed to the tab view
    @State private var activeDraggingTab: TabItem?
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
                .fill(Color(hex: "#1e1e1e").shadow(.drop(color: Color(hex: "#1e1e1e").opacity(0.2), radius: 5)))
                .ignoresSafeArea()
                .padding(.top, 20)
        }
        .coordinateSpace(.named("TABBAR"))
    }
    
    /// Each Individual Tab Button View
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.red.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                /// This gives us the elevation we needed to push the active tab
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : Color(uiColor:  UIColor.systemGray))
            
            Text(tab.rawValue)
                .font(.customCaption)
                .foregroundStyle(isActive ? .red : Color(uiColor:  UIColor.systemGray))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .contentShape(.rect)
        .padding(.top, isActive ? 0 : 20)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    /// Checking if the location falls within any stored locations; if so, switching to the appropriate index
                    if let index = tabButtonLocations.firstIndex(where: { $0.contains(location) }) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }.onEnded { _ in
                    /// Pushing changes to the actual tab view
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    
                    activeDraggingTab = nil
                },
            ///  This will immediately become false once the tab is moved, so change this to check the actual tab value instead of the dragged value
            isEnabled: activeTab == tab
        )
    }
}


extension View {
    @ViewBuilder
    public func legendaryJokerImage(x: Int, y : Int) -> some View {
        let frame = CGRect(x: x * 71, y: y * 95, width: 71, height: 95)
        let frame2 = CGRect(x: x * 71, y: (y + 1 ) * 95, width: 71, height: 95)
        if let cgImage = Images.jokers.cgImage?.cropping(to: frame) {
            ZStack {
                Image(decorative: cgImage, scale: Images.jokers.scale, orientation: .up)
                    .resizable()
                    .frame(width: frame.width, height: frame.height)
                
                if let cgImage2 = Images.jokers.cgImage?.cropping(to: frame2) {
                    Image(decorative: cgImage2, scale: Images.jokers.scale, orientation: .up)
                        .resizable()
                        .frame(width: frame.width, height: frame.height)
                }
            }
        }else{
            Text("fuck")
        }
    }
    
    @ViewBuilder
    public func seedNavigation(_ seed: String) -> some View {
        ZStack {
            Color(hex: "#1e1e1e").ignoresSafeArea()
            PlayView()
                .clipped()
                .navigationTitle(seed)
        }
    }
}

struct PerkeoView : View {
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        legendaryJokerImage(x: 7, y: 8)
            .padding()
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}


struct TribouleteView : View {
    
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    var body: some View {
        Image("triboulete")
            .padding()
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}

struct AnimatedTitle : View {
    
    private let text : String
    @State private var isAnimating = false
    private var animationDuration: Double = 1.5
    private var bounceHeight: CGFloat = 20.0
    
    public init(text: String){
        self.text = text
    }
    
    
    var body: some View {
        Text(text)
            .font(.customTitle)
            .foregroundStyle(.white)
            .scaleEffect(.random(in:  1.2...1.4 ))
            .rotationEffect( isAnimating ? .degrees(2) : .degrees(-2))
                .onAppear {
                    // Start the animation when the view appears
                    isAnimating = true
                }
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}
