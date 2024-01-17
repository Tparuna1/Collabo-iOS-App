//
//  LoginPageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 17.01.24.
//

import SwiftUI
import Auth0



class LoginPageViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var shouldNavigateToHome = false
    var onLoginSuccess: (() -> Void)?
    
    
    func comeBackText() -> some View {
        Text("Let's Get Back to Work!")
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
    
    func LoginImage() -> some View {
        return Image("LogIn")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .padding()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth0
            .authentication()
            .login(usernameOrEmail: email, password: password, realmOrConnection: "Username-Password-Authentication", scope: "openid profile email")
            .start { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let credentials):
                        print("Credentials: \(credentials)")
                        // TODO: Store the credentials securely
                        self?.onLoginSuccess?()
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.errorMessage = "Login failed: \(error.localizedDescription)"
                        // TODO: Show error message to the user
                    }
                }
            }
    }
    
}
