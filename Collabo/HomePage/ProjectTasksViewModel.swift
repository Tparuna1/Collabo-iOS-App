//
//  ProjectTasksViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation
import Combine

class ProjectTasksViewModel {
    
    private var asanaManager = AsanaManager.shared
    var projectGID: String = ""
    @Published var tasks: [AsanaTask] = []
    @Published var errorMessage: String?

    func fetchTasks() {
        Task {
            do {
                let fetchedTasks = try await AsanaManager.shared.fetchTasks(forProject: projectGID)
                DispatchQueue.main.async {
                    self.tasks = fetchedTasks
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}




