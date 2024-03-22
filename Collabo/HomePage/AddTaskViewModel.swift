//
//  AddTaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 08.02.24.
//

import Foundation

// MARK: - AsanaManaging Protocol

protocol AddTaskAsanaManaging: TaskManager {}

// MARK: - AddTaskViewModel Class

final class AddTaskViewModel {
    
    // MARK: - Properties
    
    private let asanaManager: AddTaskAsanaManaging
    var errorMessage: String?
    var params: ProjectTasksViewModelParams?
    
    //MARK: - Init
    
    init(asanaManager: AddTaskAsanaManaging = AsanaManager.shared) {
        self.asanaManager = asanaManager
    }
    
    // MARK: - Methods
    
    func addTask(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let projectGID = params?.gid else {
            return
        }
        
        asanaManager.addTaskToAsana(name: name, projectGID: projectGID) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
    }
}

// MARK: - AsanaManager Extension

extension AsanaManager: AddTaskAsanaManaging {}

