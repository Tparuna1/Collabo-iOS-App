//
//  SUISignUpView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI


struct SUISignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        @ObservedObject var viewModel = LoginPageViewModel()
        
        NavigationStack {
            ZStack {
                AnimatedBackgroundView()
                VStack {
                    
                    Text("Begin your journey with Collabo")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 32)
                    
                    CustomTextField(text: $fullName, placeholder: "Full Name")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    CustomTextField(text: $email, placeholder: "Email Address", keyboardType: .emailAddress)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    
                    PasswordSecureField(password: $password)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    
                    
                    Button(action: {
                        // TODO: Add action for your Sign-Up button here
                    }) {
                        PrimaryButtonComponentView(text: "Sign Up")
                    }
                    .padding(.horizontal)
                    .padding(.top ,32)

                    
                    NavigationLink(destination: SUILoginView()) {
                        Text("Already have an account? Log in")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct SUISignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SUISignUpView()
    }
}


#Preview {
    SUISignUpView()
}
