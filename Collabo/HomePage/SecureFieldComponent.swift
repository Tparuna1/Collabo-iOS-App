//
//  SecureFieldComponent.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct PasswordSecureField: View {
    
    // MARK: - Properties
    
    @Binding var password: String
    var onCommit: () -> Void = {}
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                SecureField("Enter your password", text: $password, onCommit: onCommit)
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


