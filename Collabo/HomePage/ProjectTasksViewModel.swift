//
//  ProjectTasksViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation
import Combine

public protocol ProjectTasksViewModel: ProjectTasksViewModelInput, ProjectTasksViewModelOutput {}

public struct ProjectTasksViewModelParams {
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

public protocol ProjectTasksViewModelInput: AnyObject {
    var params: ProjectTasksViewModelParams? { get set }
    func viewDidLoad()
    func didSelectRow(at index: Int)
    func newTask()
}

public protocol ProjectTasksViewModelOutput {
    var action: AnyPublisher<ProjectTasksViewModelOutputAction, Never> { get }
    var route: AnyPublisher<ProjectTasksViewModelRoute, Never> { get }
}

public enum ProjectTasksViewModelOutputAction {
    case tasks([AsanaTask])
    case title(String)
}

public enum ProjectTasksViewModelRoute {
    case details(TaskDetailsViewModelParams)
    case projectDeleted
    case newTask
}

class DefaultProjectTasksViewModel {
    private let actionSubject = PassthroughSubject<ProjectTasksViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<ProjectTasksViewModelRoute, Never>()
    
    public var params: ProjectTasksViewModelParams?
    
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    private var tasks: [AsanaTask] = []
    private var errorMessage: String?
    
    // MARK: - Init
    
    public init(params: ProjectTasksViewModelParams? = nil) {
        self.params = params
    }
    
    // MARK: - Methods
    
    func fetchTasks() {
        guard let params else {
            return
        }
        Task {
            do {
                tasks = try await AsanaManager.shared.fetchTasks(forProject: params.gid)
                await MainActor.run {
                    self.actionSubject.send(.tasks(self.tasks))
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteProject() {
        guard let projectGID = params?.gid else {
            return
        }
        
        Task {
            do {
                try await AsanaManager.shared.deleteProject(projectGID: projectGID)
                await MainActor.run {
                    self.routeSubject.send(.projectDeleted)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

extension DefaultProjectTasksViewModel: ProjectTasksViewModel {
    var action: AnyPublisher<ProjectTasksViewModelOutputAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var route: AnyPublisher<ProjectTasksViewModelRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        fetchTasks()
        
        guard let params else {
            return
        }
        
        actionSubject.send(.title(params.name))
    }
    
    func didSelectRow(at index: Int) {
        let gid = tasks[index].gid
        let name = tasks[index].name

        routeSubject.send(.details(.init(name: name, gid: gid)))
    }
    
    func newTask() {
        routeSubject.send(.newTask)
    }
}
