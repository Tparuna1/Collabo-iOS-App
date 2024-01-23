//
//  SUISIgnUpViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 18.01.24.
//

import SwiftUI
import Auth0

class SUISignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isSignUpEnabled = false
    @Published var isMinLengthMet = false
    @Published var isCapitalLetterMet = false
    @Published var isNumberMet = false
    @Published var isUniqueCharacterMet = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    var onSignUpSuccess: (() -> Void)?


    
    
    func validatePassword(password: String) {
        isMinLengthMet = password.count >= 8
        isCapitalLetterMet = password.contains { $0.isUppercase }
        isNumberMet = password.contains { $0.isNumber }
        isUniqueCharacterMet = password.contains { !$0.isLetter && !$0.isNumber }
        
        isSignUpEnabled = isMinLengthMet && isCapitalLetterMet && isNumberMet && isUniqueCharacterMet
    }

    func signUpUser() {
        isLoading = true
        errorMessage = nil
        
        let userMetadata: [String: Any] = ["full_name": username]
        
        Auth0
            .authentication()
            .signup(
                email: email,
                password: password,
                connection: "Username-Password-Authentication",
                userMetadata: userMetadata
            )
            .start { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let user):
                        print("User signed up: \(user)")
                        self?.onSignUpSuccess?()

                    case .failure(let error):
                        print("Error: \(error)")
                        self?.errorMessage = "Sign up failed: \(error.localizedDescription)"
                        //TODO: Show error message to user
                    }
                }
            }
    }
}
