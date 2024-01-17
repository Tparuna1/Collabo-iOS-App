//
//  AnimatedBackgroundView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

//MARK: - Onboarding Background
struct AnimatedBackgroundView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.blue
            
            ForEach(0..<5) { _ in
                Circle()
                    .fill(isAnimating ? Color.blue.opacity(0.8) : Color.cyan.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .offset(x: randomOffset(), y: randomOffset())
                    .animation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func randomOffset() -> CGFloat {
        return CGFloat.random(in: -300...300)
    }
}
