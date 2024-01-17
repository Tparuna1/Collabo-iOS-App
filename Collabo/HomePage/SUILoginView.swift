//
//  SUILoginView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct SUILoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        @ObservedObject var viewModel = LoginPageViewModel()

        NavigationStack {
            ZStack {
                AnimatedBackgroundView()
                VStack {
                    Spacer()
                    viewModel.LoginImage()
                    viewModel.comeBackText()
                    EmailTextField(email: $email)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    PasswordSecureField(password: $password)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        //TODO: Add action for your Log In button here
                    }) {
                        PrimaryButtonComponentView(text: "Log In")
                    }
                    .padding(.horizontal)

                    
                    NavigationLink(destination: SUISignUpView()) {
                        Text("Don't have an account? Sign up")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}



#Preview {
    SUILoginView()
}
