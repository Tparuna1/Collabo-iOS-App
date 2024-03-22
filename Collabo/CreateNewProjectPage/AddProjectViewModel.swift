//
//  AddProjectViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import Foundation

// MARK: - AsanaManaging Protocol

protocol AddProjectAsanaManaging: ProjectManager {}

// MARK: - AddprojectViewModel Class

final class AddProjectViewModel {
    
    // MARK: - Properties
    
    private let asanaManager: AddProjectAsanaManaging
    var errorMessage: String?

    
    //MARK: - Init
    
    init(asanaManager: AddProjectAsanaManaging = AsanaManager.shared) {
        self.asanaManager = asanaManager
    }   

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

// MARK: - AsanaManager Extension

extension AsanaManager: AddProjectAsanaManaging {}
