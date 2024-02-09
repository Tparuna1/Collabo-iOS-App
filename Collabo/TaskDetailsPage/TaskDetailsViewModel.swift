//
//  TaskDetailsViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//

import Foundation
import Combine

public protocol TaskDetailsViewModel: TaskDetailsViewModelInput, TaskDetailsViewModelOutput {}

public struct TaskDetailsViewModelParams {
    public let name: String
    public let gid: String
    
    public init(
        name: String,
        gid: String
    ) {
        self.name = name
        self.gid = gid
    }
}

public protocol TaskDetailsViewModelInput: AnyObject {
    var params: TaskDetailsViewModelParams? { get set }
    func viewDidLoad()
    func newSubtask()
    func deleteTask()
    func updateSingleTask()
}

public protocol TaskDetailsViewModelOutput {
    var action: AnyPublisher<TaskDetailsViewModelOutputAction, Never> { get }
    var route: AnyPublisher<TaskDetailsViewModelRoute, Never> { get }
}

public enum TaskDetailsViewModelOutputAction {
    case task(SingleAsanaTask?)
    case subtask([Subtask])
    case title(String)
}

public enum TaskDetailsViewModelRoute {
    case newSubtask
    case taskDeleted
}

class DefaultTaskDetailsViewModel: ObservableObject {
    private let actionSubject = PassthroughSubject<TaskDetailsViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<TaskDetailsViewModelRoute, Never>()
    
    public var params: TaskDetailsViewModelParams?
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    var task: SingleAsanaTask?
    private var subTasks: [Subtask] = []
    private var errorMessage: String?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    public init(params: TaskDetailsViewModelParams? = nil) {
        self.params = params
    }
    
    // MARK: - Private Methods
    
    private func fetchSingleTask() {
        guard let params else {
            return
        }
        Task {
            do {
                self.task = try await AsanaManager.shared.fetchSingleTask(forTask: params.gid).data
                await MainActor.run {
                    self.actionSubject.send(.task(self.task))
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func fetchSubtask() {
        guard let params = params else {
            return
        }
        Task {
            do {
                let subtaskResponse = try await AsanaManager.shared.fetchSubtasks(forSubtask: params.gid)
                
                
                self.subTasks = subtaskResponse
                await MainActor.run {
                    self.actionSubject.send(.subtask(self.subTasks))
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteTask() {
        guard let taskGID = params?.gid else {
            return
        }
        
        Task {
            do {
                let deletedTask = try await AsanaManager.shared.deleteSingleTask(forTask: taskGID)
                
                await MainActor.run {
                    self.routeSubject.send(.taskDeleted)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateSingleTask() {
        guard let taskGID = params?.gid, let task = task else {
            return
        }
        
        let newCompletionStatus = !(task.completed ?? false)
        
        Task {
            do {
                let _ = try await AsanaManager.shared.updateSingleTask(forTask: taskGID, completed: newCompletionStatus)
                
                await MainActor.run {
                    self.task?.completed = newCompletionStatus
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

extension DefaultTaskDetailsViewModel: TaskDetailsViewModel {
    var action: AnyPublisher<TaskDetailsViewModelOutputAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var route: AnyPublisher<TaskDetailsViewModelRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
        
    func viewDidLoad() {
        fetchSingleTask()
        fetchSubtask()
        
        guard let params else {
            return
        }
        
        actionSubject.send(.title(params.name))
    }
    
    func newSubtask() {
        routeSubject.send(.newSubtask)
    }
}

