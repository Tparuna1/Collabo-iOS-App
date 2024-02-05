//
//  AddSubtaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//



import Foundation

class AddSubtaskViewModel {
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    var errorMessage: String?

    // MARK: - Methods
    
    func addSubtask(name: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await asanaManager.addSubtask(name: name)
                completion(nil)
            } catch {
                self.errorMessage = error.localizedDescription
                completion(error)
            }
        }
    }
}
