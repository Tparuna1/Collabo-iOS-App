//
//  MytaskViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//


import Foundation
import Combine

public protocol UserTaskListViewModel: UserTaskListViewModelInput, UserTaskListViewModelOutput {}


public protocol UserTaskListViewModelInput: AnyObject {
    func viewDidLoad()
    func didSelectRow(at index: Int)
}

public protocol UserTaskListViewModelOutput {
    var action: AnyPublisher<UserTaskListViewModelOutputAction, Never> { get }
    var route: AnyPublisher<UserTaskListViewModelRoute, Never> { get }
}

public enum UserTaskListViewModelOutputAction {
    case tasks([UserTaskList])
}

public enum UserTaskListViewModelRoute {
    case details(TaskDetailsViewModelParams)
}

class DefaultUserTaskListViewModel {
    private let actionSubject = PassthroughSubject<UserTaskListViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<UserTaskListViewModelRoute, Never>()
        
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    private var tasks: [UserTaskList] = []
    private var errorMessage: String?
    
    // MARK: - Methods
    
    private func fetchUserTasks() {
        Task {
            do {
                self.tasks = try await asanaManager.fetchUserTasks()
                await MainActor.run {
                    self.actionSubject.send(.tasks(self.tasks))
                }
            } catch {
                print("Error fetching user tasks: \(error.localizedDescription)")
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
    }

    
    func didSelectRow(at index: Int) {
        let gid = tasks[index].gid
        let name = tasks[index].name
        
        routeSubject.send(.details(.init(name: name, gid: gid)))
    }
}

