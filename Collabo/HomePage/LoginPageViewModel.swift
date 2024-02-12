//
//  LoginPageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 17.01.24.
//

import SwiftUI
import Auth0

final class LoginPageViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var shouldNavigateToHome = false
    var onLoginSuccess: (() -> Void)?
    
    // MARK: - View Methods
    
    func comeBackText() -> some View {
        Text("Let's Get Back to Work!")
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
    
    func LoginImage() -> some View {
        return Image("LogIN")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .padding()
    }
    
    // MARK: - Authentication Methods
    
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
                        self?.onLoginSuccess?()
                        
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.errorMessage = "Login failed: \(error.localizedDescription)"
                    }
                }
            }
    }
    
    func connectWithAsana() {
        let connectionName = "Asana"
        
        Auth0
            .webAuth()
            .scope("openid profile email")
            .connection(connectionName)
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Connected with Asana: \(credentials)")
                case .failure(let error):
                    print("Failed to connect with Asana: \(error)")
                }
            }
    }
}
