//
//  AddTaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 08.02.24.
//

import Foundation


class AddTaskViewModel {
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    var errorMessage: String?
    
    // MARK: - Methods
    
    func addTaskToAsana(name: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await asanaManager.addTaskToAsana(name: name)
                completion(nil)
            } catch {
                self.errorMessage = error.localizedDescription
                completion(error)
            }
        }
    }
}
