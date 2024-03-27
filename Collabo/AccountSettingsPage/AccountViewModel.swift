//
//  AccountViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import Foundation
import Combine
import Auth0


//MARK: - AccountViewModel Class

final class AccountViewModel {
    
    // MARK: - Properties
    var onLogoutComplete: (() -> Void)?
    static let shared = AccountViewModel()
    private var taskCount = 0
    
    // MARK: - Methods
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
    
    func fetchUserInfo(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Task {
            do {
                let userInfo = try await AsanaManager.shared.fetchUserInfo()
                completion(.success(userInfo))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchAndCountUserTasks(completion: @escaping (Result<Int, Error>) -> Void) {
        Task {
            do {
                let userTasks = try await AsanaManager.shared.fetchUserTasks()
                self.taskCount = userTasks.count
                completion(.success(self.taskCount))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

