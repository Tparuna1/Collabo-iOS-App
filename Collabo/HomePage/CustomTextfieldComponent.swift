//
//  CustomTextfieldComponent.swift
//  Collabo
//
//  Created by tornike <parunashvili on 17.01.24.
//

import SwiftUI

struct CustomTextField: View {
    
    // MARK: - Properties
    
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(text: Binding<String>, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .foregroundColor(.blue)
                    .tint(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.cyan.opacity(0.5), lineWidth: 1.0)
                            )
                    )
            }
        }
        .padding(.horizontal, 16)
    }
}


