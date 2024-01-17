//
//  SecureFieldComponent.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct PasswordSecureField: View {
    //MARK: - Properties
    @Binding var password: String
    
    //MARK: - Body
    var body: some View {
        VStack {
            Text("Password")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack(alignment: .leading) {
                if password.isEmpty {
                    Text("Enter your password")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.6))
                }
                SecureField("", text: $password)
                    .cornerRadius(8)
            }
            .foregroundStyle(.blue)
            .tint(.white)
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(
                Capsule()
                    .fill(Color.white)
                    .frame(height: 48)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.cyan.opacity(0.5), lineWidth: 1.0)
                    )
            )
        }
        .padding(.horizontal, 16)
    }
}

