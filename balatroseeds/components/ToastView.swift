//
//  ToastView.swift
//  balatroseeds
//
//  Created by Alex on 20/04/25.
//

import SwiftUI

// Represents the toast message style and content
struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3 // Default duration
    var width: Double = .infinity // Default width

    enum ToastStyle {
        case error
        case warning
        case success
        case info

        var themeColor: Color {
            switch self {
            case .error: return Color.red
            case .warning: return Color.orange
            case .info: return Color.blue
            case .success: return Color.green
            }
        }

        var iconFileName: String {
            switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            }
        }
    }
}

// The View that displays the toast
struct ToastView: View {
    let style: Toast.ToastStyle
    let message: String
    let width: Double
    let onCancelTapped: (() -> Void) // Action for dismissal

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            Text(message)
                .font(.customCaption)
                .foregroundColor(.white) // Adapts to light/dark mode

            Spacer(minLength: 10)

            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color(hex: "#1e1e1e")) // Adapts to light/dark mode
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style.themeColor, lineWidth: 1) // Subtle border
        )
        .padding(.horizontal, 16) // Prevent edges from touching screen
    }
}


// ViewModifier to easily attach toast functionality to any view
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30) // Adjust vertical position
                        .animation(.spring(), value: toast)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom) // Align to bottom
            )
            .onChange(of: toast) {
                showToast()
            }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer() // Pushes toast to the bottom
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width,
                    onCancelTapped: {
                        dismissToast()
                    }
                )
            }
            .transition(.move(edge: .bottom).combined(with: .opacity)) // Animate from bottom
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        // Haptic feedback for toast appearance
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif

        if toast.duration > 0 {
            workItem?.cancel() // Cancel previous dismissal task

            let task = DispatchWorkItem {
               dismissToast()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

// Extension to make applying the modifier easier
extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
