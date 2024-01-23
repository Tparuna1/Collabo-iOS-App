//
//  AccountViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//


import Foundation
import Auth0

class AccountViewModel {
    static let shared = AccountViewModel()
    var onLogoutComplete: (() -> Void)?


    func logout() {
        Auth0
            .webAuth()
            .clearSession(federated: false) { result in
                switch result {
                case .success:
                    print("Logged out successfully")
                    self.onLogoutComplete?()

                case .failure(let error):
                    print("Failed to log out: \(error)")
                }
            }
    }
}

