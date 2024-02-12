//
//  AddProjectViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import Foundation

final class AddProjectViewModel {
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    var errorMessage: String?

    // MARK: - Methods
    
    func addProjectToAsana(name: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await asanaManager.addProjectToAsana(name: name)
                completion(nil)
            } catch {
                self.errorMessage = error.localizedDescription
                completion(error)
            }
        }
    }
}
