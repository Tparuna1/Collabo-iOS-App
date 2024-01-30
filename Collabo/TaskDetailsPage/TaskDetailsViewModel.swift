//
//  TaskDetailsViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//

import Foundation
import Combine

class TaskDetailsViewModel: ObservableObject {
    
    @Published var singleTask: AsanaTask?
    private var asanaManager = AsanaManager.shared
    var taskGID: String = ""
    @Published var task: SingleAsanaTask?
    @Published var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    
    func fetchSingleTask() {
        Task {
            do {
                let task = try await AsanaManager.shared.fetchSingleTask(forTask: taskGID)
                DispatchQueue.main.async {
                    self.task = task
                }
            } catch {
                print("Error fetching single task: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
