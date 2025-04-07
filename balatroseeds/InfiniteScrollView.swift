//
//  InfiniteScrollView.swift
//  balatroseeds
//
//  Created by Alex on 31/03/25.
//


import SwiftUI

struct InfiniteScrollView<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var spacing: CGFloat = 10
    var collection: Data
    @ViewBuilder var content: (Data.Element) -> Content
    var uiScrollView: (UIScrollView) -> ()
    var onScroll: () -> ()
    /// View Properties
    @State private var contentSize: CGSize = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    /// Original Content
                    HStack(spacing: spacing) {
                        ForEach(collection) { item in
                            content(item)
                        }
                    }
                    .onGeometryChange(for: CGSize.self) {
                        $0.size
                    } action: { newValue in
                        contentSize = .init(width: newValue.width + spacing, height: newValue.height)
                    }
                    
                    /// Repeating Content for creating Infinite(Looping) ScrollView
                    let averageWidth = contentSize.width / CGFloat(collection.count)
                    let repeatingCount = contentSize.width > 0 ? Int((size.width / averageWidth).rounded()) + 1 : 1
                    
                    HStack(spacing: spacing) {
                        ForEach(0..<repeatingCount, id: \.self) { index in
                            let item = Array(collection)[index % collection.count]
                            
                            content(item)
                        }
                    }
                }
                .background(
                    InfiniteScrollHelper(
                        contentSize: $contentSize,
                        declarationRate: .constant(.fast),
                        uiScrollView: uiScrollView,
                        onScroll: onScroll
                    )
                )
            }
        }
    }
}

#Preview {
    ContentView()
}

fileprivate struct InfiniteScrollHelper: UIViewRepresentable {
    @Binding var contentSize: CGSize
    @Binding var declarationRate: UIScrollView.DecelerationRate
    var uiScrollView: (UIScrollView) -> ()
    var onScroll: () -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(declarationRate: declarationRate, contentSize: contentSize, onScroll: onScroll)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let scrollView = view.scrollView {
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.decelerationRate = declarationRate
                scrollView.delegate = context.coordinator
                uiScrollView(scrollView)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.declarationRate = declarationRate
        context.coordinator.contentSize = contentSize
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var declarationRate: UIScrollView.DecelerationRate
        var contentSize: CGSize
        var onScroll: () -> ()
        
        init(declarationRate: UIScrollView.DecelerationRate, contentSize: CGSize, onScroll: @escaping () -> ()) {
            self.declarationRate = declarationRate
            self.contentSize = contentSize
            self.onScroll = onScroll
        }
        
        /// Storing Default SwiftUI Delegate
        weak var defaultDelegate: UIScrollViewDelegate?
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            /// Updating Declaration Rate
            scrollView.decelerationRate = declarationRate
            
            let minX = scrollView.contentOffset.x
            
            if minX > contentSize.width {
                scrollView.contentOffset.x -= contentSize.width
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }
            
            onScroll()
            
            /// Calling Default Delegate once our customization finished
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        /// Calling Other default Callbacks
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            defaultDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            defaultDelegate?.scrollViewWillEndDragging?(
                scrollView,
                withVelocity: velocity,
                targetContentOffset: targetContentOffset
            )
        }
    }
}

extension UIView {
    var scrollView: UIScrollView? {
        if let superview, superview is UIScrollView {
            return superview as? UIScrollView
        }
        
        return superview?.scrollView
    }
}
