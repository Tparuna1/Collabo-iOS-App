//
//  SUISignUpView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//


import SwiftUI

struct SUISignUpView: View {
    @ObservedObject var viewModel = SUISignUpViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundView()
                VStack {
                    Text("Begin your journey with Collabo")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 32)
                    
                    CustomTextField(text: $viewModel.username, placeholder: "Full Name")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    CustomTextField(text: $viewModel.email, placeholder: "Email Address", keyboardType: .emailAddress)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    PasswordSecureField(password: $viewModel.password)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .onChange(of: viewModel.password) {
                            viewModel.validatePassword(password: viewModel.password)
                        }


                    
                    PasswordStrengthChecklist(
                        isMinLengthMet: viewModel.isMinLengthMet,
                        isCapitalLetterMet: viewModel.isCapitalLetterMet,
                        isNumberMet: viewModel.isNumberMet,
                        isUniqueCharacterMet: viewModel.isUniqueCharacterMet
                    )
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Button(action: {
                        viewModel.signUpUser()
                    }) {
                        PrimaryButtonComponentView(text: viewModel.isLoading ? "Signing Up..." : "Sign Up")
                    }
                    .disabled(!viewModel.isSignUpEnabled || viewModel.isLoading)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    
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


//struct SUISignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SUISignUpView()
//    }
//}



