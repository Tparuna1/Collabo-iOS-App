//
//  AddSubtaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//

import Foundation

// MARK: - AsanaManaging Protocol

protocol AddSubtaskAsanaManaging: SubtaskManager {}

// MARK: - AddSubtaskViewModel Class

final class AddSubtaskViewModel {
    
    // MARK: - Properties
    
    private let asanaManager: AddSubtaskAsanaManaging
    var errorMessage: String?
    var params: TaskDetailsViewModelParams?
    
    //MARK: - Init
    
    init(asanaManager: AddSubtaskAsanaManaging = AsanaManager.shared) {
        self.asanaManager = asanaManager
    }

    // MARK: - Methods
    
    func addSubtask(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let taskGID = params?.gid else {
            print("failure")
            return
        }
        
        asanaManager.addSubtask(name: name, taskGID: taskGID) { result in
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

extension AsanaManager: AddSubtaskAsanaManaging {}
