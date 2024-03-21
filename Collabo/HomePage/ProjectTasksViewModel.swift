//
//  ProjectTasksViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation
import Combine

// MARK: - AsanaManaging Protocol

protocol ProjectAsanaManaging: TaskManager, ProjectManager {}

// MARK: - ProjectTasksViewModel Protocol

public protocol ProjectTasksViewModel: ProjectTasksViewModelInput, ProjectTasksViewModelOutput {}

//MARK: - Params

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

// MARK: - ProjectTasksViewModel Input & Output  Protocols

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

// MARK: - ProjectTasksViewModel Enumerations

public enum ProjectTasksViewModelOutputAction {
    case tasks([AsanaTask])
    case title(String)
}

public enum ProjectTasksViewModelRoute {
    case details(TaskDetailsViewModelParams)
    case projectDeleted
    case newTask
}



// MARK: - DefaultProjectTasksViewModel Class

final class DefaultProjectTasksViewModel {
    private let actionSubject = PassthroughSubject<ProjectTasksViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<ProjectTasksViewModelRoute, Never>()
    private let additionalLabelSubject = PassthroughSubject<String, Never>()

    public var params: ProjectTasksViewModelParams?
    
    // MARK: - Properties
    
    private var asanaManager: ProjectAsanaManaging
    
    init(asanaManager: ProjectAsanaManaging = AsanaManager.shared, params: ProjectTasksViewModelParams? = nil) {
        self.asanaManager = asanaManager
        self.params = params
    }
    
    private var tasks: [AsanaTask] = []
    private var errorMessage: String?
    
    // MARK: - Methods
    
    func fetchTasks() {
        guard let params = params else {
            return
        }
        Task {
            do {
                tasks = try await asanaManager.fetchTasks(forProject: params.gid)
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
                try await asanaManager.deleteProject(projectGID: projectGID)
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
    
    func updateProgress() -> String {
        let progress = calculateProgress()
        let progressPercentage = Int(progress * 100)
        
        switch progressPercentage {
        case 0..<25:
            return "Time to start! Progress needed"
        case 25..<50:
            return "Making good progress. Stay focused!"
        case 50..<75:
            return "Doing great! Keep up the momentum!"
        case 75..<100:
            return "Almost there! Keep pushing forward!"
        case 100:
            return "Congratulations! Project successfully completed!"
        default:
            return ""
        }
    }
    
    func calculateProgress() -> Float {
        guard !tasks.isEmpty else { return 0.0 }
        
        let completedTasksCount = tasks.filter { $0.completed }.count
        return Float(completedTasksCount) / Float(tasks.count)
    }
}

// MARK: - ProjectTasksViewModel Extension

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
        
        guard let params = params else {
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

// MARK: - AsanaManager Extension

extension AsanaManager: ProjectAsanaManaging {}
