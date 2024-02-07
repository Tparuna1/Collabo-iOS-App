//
//  SUILoginView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI
import Auth0

// MARK: - NavigationPath Enum

//enum NavigationPath: Hashable {
//    case home
//    case signUp
//    case login
//}

struct SUILoginView: View {
    
    // MARK: - State Properties
    
    @StateObject private var viewModel = LoginPageViewModel()
    @State private var email = ""
    @State private var password = ""
    
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
                            backgroundColor: .white,
                            textColor: .blue
                        )
                        .onTapGesture {
                            viewModel.login(email: email, password: password)
                        }
                        .disabled(viewModel.isLoading)
                        .padding()
                        
                        NavigationLink(destination: SUISignUpView()) {
                            PrimaryButtonComponentView(
                                text: "Sign Up",
                                backgroundColor: .white,
                                textColor: .blue
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
