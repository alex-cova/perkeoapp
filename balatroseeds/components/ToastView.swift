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
                .foregroundStyle(style.themeColor)
            Text(message)
                .font(.customCaption)
                .foregroundStyle(.white) // Adapts to light/dark mode

            Spacer(minLength: 10)

            Button("Dismiss", systemImage: "xmark", action: onCancelTapped)
                .labelStyle(.iconOnly)
                .foregroundStyle(style.themeColor)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color(hex: "#1e1e1e")) // Adapts to light/dark mode
        .clipShape(.rect(cornerRadius: 8))
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
    @State private var dismissTask: Task<Void, Never>?

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
            .sensoryFeedback(.impact(weight: .light), trigger: toast) { _, newValue in
                newValue != nil
            }
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

        if toast.duration > 0 {
            dismissTask?.cancel() // Cancel previous dismissal task

            dismissTask = Task {
                try? await Task.sleep(for: .seconds(toast.duration))
                if !Task.isCancelled {
                    dismissToast()
                }
            }
        }
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        dismissTask?.cancel()
        dismissTask = nil
    }
}

// Extension to make applying the modifier easier
extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
