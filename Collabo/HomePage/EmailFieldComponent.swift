//
//  EmailFieldComponent.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct EmailTextField: View {
    //MARK: - Properties
    @Binding var email: String
    
    //MARK: - Body
    var body: some View {
        VStack {
            Text("Email")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack(alignment: .leading) {
                if email.isEmpty {
                    Text("Enter your email address")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.6))
                }
                TextField("", text: $email)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .foregroundColor(.blue)
                    .tint(.white)
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
        }
        .padding(.horizontal, 16)
    }
}






