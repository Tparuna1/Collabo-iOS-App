//
//  AddProjectViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import Foundation


class AddProjectViewModel {
    private var asanaManager = AsanaManager.shared
    var errorMessage: String?

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


