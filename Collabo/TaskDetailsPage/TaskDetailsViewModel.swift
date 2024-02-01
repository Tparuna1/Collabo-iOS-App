//
//  TaskDetailsViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//

import Foundation
import Combine

class TaskDetailsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var singleTask: TaskAsana?
    private var asanaManager = AsanaManager.shared
    var taskGID: String = ""
    @Published var task: TaskAsana?
    @Published var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
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
