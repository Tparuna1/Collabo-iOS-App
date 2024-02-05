//
//  MytaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//


import Foundation
import Combine

public protocol UserTaskListViewModel: UserTaskListViewModelInput, UserTaskListViewModelOutput {}

public struct UserTaskListViewModelParams {
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

public protocol UserTaskListViewModelInput: AnyObject {
    var params: UserTaskListViewModelParams? { get set }
    func viewDidLoad()
    func didSelectRow(at index: Int)
}

public protocol UserTaskListViewModelOutput {
    var action: AnyPublisher<UserTaskListViewModelOutputAction, Never> { get }
    var route: AnyPublisher<UserTaskListViewModelRoute, Never> { get }
}

public enum UserTaskListViewModelOutputAction {
    case tasks([AsanaTask])
    case title(String)
}

public enum UserTaskListViewModelRoute {
    case details(TaskDetailsViewModelParams)
}

class DefaultUserTaskListViewModel {
    private let actionSubject = PassthroughSubject<UserTaskListViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<UserTaskListViewModelRoute, Never>()
    
    public var params: UserTaskListViewModelParams?
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    private var tasks: [AsanaTask] = []
    private var errorMessage: String?
    
    // MARK: - Init
    
    public init(params: UserTaskListViewModelParams? = nil) {
        self.params = params
    }
    
    // MARK: - Methods
    
    private func fetchUserTasks() {
        Task {
            do {
                let (userTaskLists, _) = try await AsanaManager.shared.fetchUserTasks()
                let userTasks = userTaskLists.map { userTaskList in
                    let gid = userTaskList.gid
                    let name = userTaskList.name 
                    
                    return AsanaTask(gid: gid, name: name)
                }
                
                await MainActor.run {
                    self.actionSubject.send(.tasks(userTasks))
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

}

extension DefaultUserTaskListViewModel: UserTaskListViewModel {
    var action: AnyPublisher<UserTaskListViewModelOutputAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var route: AnyPublisher<UserTaskListViewModelRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        fetchUserTasks()
        
        guard let params else {
            return
        }
        
        actionSubject.send(.title(params.name))
    }
    
    func didSelectRow(at index: Int) {
        let gid = tasks[index].gid
        
        routeSubject.send(.details(.init(gid: gid)))
    }
}

