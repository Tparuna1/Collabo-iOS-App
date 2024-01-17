//
//  PrimaryButtonComponent.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct PrimaryButtonComponentView: View {
    // MARK: - Properties
    var text: String
    var backgroundColor: Color
    var textColor: Color
    @GestureState private var isPressed = false
    
    
    init(text: String, backgroundColor: Color = .white, textColor: Color = .blue) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    // MARK: - Body
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(textColor)
            .font(.system(size: 16))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundColor)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .scaleEffect(isPressed ? 0.96 : 1.0)
    }
}

