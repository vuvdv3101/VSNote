//
//  FloatButtonView.swift
//  VSNotes
//
//  Created by Admin on 7/2/26.
//

import SwiftUI

struct FloatButtonView: View {
    @State private var isPressed = false
    private let animationDuration: Double = 0.1
    
    var onPress: () -> Void
    
    @ViewBuilder
    var body: some View {
        Circle()
            .frame(width: 45, height: 45)
            .padding()
            .overlay {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
            .scaleEffect(isPressed ? 0.8 : 1.0)
            .onTapGesture {
                action()
            }
    }
    
    private func action() {
        onPress()
        withAnimation(.easeIn(duration: animationDuration)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            withAnimation(.easeOut(duration: 0.2)) {
                isPressed = false
            }
        }
    }
}
