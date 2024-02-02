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
    public let gid: String
    
    public init(gid: String) {
        self.gid = gid
    }
}

public protocol TaskDetailsViewModelInput: AnyObject {
    var params: TaskDetailsViewModelParams? { get set }
    func viewDidLoad()
}

public protocol TaskDetailsViewModelOutput {
    var action: AnyPublisher<TaskDetailsViewModelOutputAction, Never> { get }
    var route: AnyPublisher<TaskDetailsViewModelRoute, Never> { get }
}

public enum TaskDetailsViewModelOutputAction {
    case task(SingleAsanaTask?)
}

public enum TaskDetailsViewModelRoute {
    case close
}

class DefaultTaskDetailsViewModel: ObservableObject {
    private let actionSubject = PassthroughSubject<TaskDetailsViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<TaskDetailsViewModelRoute, Never>()
    
    public var params: TaskDetailsViewModelParams?
    
    // MARK: - Properties
    
    private var asanaManager = AsanaManager.shared
    private var task: SingleAsanaTask?
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
    }
}
