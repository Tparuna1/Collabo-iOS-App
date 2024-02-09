//
//  AddTaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 08.02.24.
//

import Foundation

class AddTaskViewModel {
    
    // MARK: - Properties
    
    private let asanaManager = AsanaManager.shared
    var errorMessage: String?
    var params: ProjectTasksViewModelParams?
    
    // MARK: - Methods
    
    func addTask(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let projectGID = params?.gid else {
            print("failure")
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

