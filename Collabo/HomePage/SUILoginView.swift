//
//  SUILoginView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI
import Auth0

struct SUILoginView: View {
    
    // MARK: - State Properties
    
    @StateObject private var viewModel = LoginPageViewModel()
    @State private var email = ""
    @State private var password = ""
    
    private var loginButtonColor: (backgroundColor: Color, textColor: Color) {
        if viewModel.isValidEmail(email) && viewModel.isValidPassword(password) {
            return (.white, .blue)
        } else {
            return (.white.opacity(0.8), .blue)
        }
    }
    
    // MARK: - Body View
    
    var body: some View {
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
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        PrimaryButtonComponentView(
                            text: "Log In",
                            backgroundColor: loginButtonColor.backgroundColor,
                            textColor: loginButtonColor.textColor
                        )
                        .onTapGesture {
                            viewModel.login(email: email, password: password)
                        }
                        .disabled(!viewModel.isValidEmail(email) || !viewModel.isValidPassword(password) || viewModel.isLoading)
                        .padding()
                        
                        NavigationLink(destination: SUISignUpView()) {
                            PrimaryButtonComponentView(
                                text: "Sign Up",
                                backgroundColor: .clear,
                                textColor: .white
                            )
                            .padding(.horizontal)
                        }
                        Spacer()
                    }
                }
                .padding()
                
            }
            .onAppear {
                viewModel.onLoginSuccess = {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.switchToMainTabBarController()
                    }
                }
            }
        }
    }
}
