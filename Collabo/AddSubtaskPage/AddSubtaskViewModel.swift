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
    var params: TaskDetailsViewModelParams?

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
