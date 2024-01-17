//
//  SUILoginView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI
import Auth0

enum NavigationPath: Hashable {
    case home
    case signUp
}


struct SUILoginView: View {
    @StateObject private var viewModel = LoginPageViewModel()
    @State private var email = ""
    @State private var password = ""
    
    
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


//#Preview {
//    SUILoginView()
//}
