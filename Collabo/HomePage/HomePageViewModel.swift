//
//  HomeViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import Foundation
import Combine

public protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

public protocol HomeViewModelInput: AnyObject {
    func viewDidLoad()
    func didSelectRow(at index: Int)
    func fetchProjects(with token: String)
}

public protocol HomeViewModelOutput {
    var action: AnyPublisher<HomeViewModelOutputAction, Never> { get }
    var route: AnyPublisher<HomeViewModelRoute, Never> { get }
}

public enum HomeViewModelOutputAction {
    case projects([AsanaProject])
}

public enum HomeViewModelRoute {
    case detail(ProjectTasksViewModelParams)
}

final class DefaultHomeViewModel {
    private let actionSubject = PassthroughSubject<HomeViewModelOutputAction, Never>()
    private let routeSubject = PassthroughSubject<HomeViewModelRoute, Never>()
    
    // MARK: - Properties
    
    private let asanaManager = AsanaManager.shared
    private var projects: [AsanaProject] = []
    private var errorMessage: String?
    
    
    // MARK: - Private Methods
    
    private func getAccessToken(authorizationCode: String) {
        Task {
            do {
                try await asanaManager.getAccessToken(authorizationCode: authorizationCode)
                fetchProjects()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func fetchProjects() {
        Task {
            do {
                try await asanaManager.refreshAccessToken()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        Task {
            do {
                self.projects = try await asanaManager.fetchProjects()
                await MainActor.run {
                    self.actionSubject.send(.projects(self.projects))
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

extension DefaultHomeViewModel: HomeViewModel {
    var action: AnyPublisher<HomeViewModelOutputAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var route: AnyPublisher<HomeViewModelRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        fetchProjects()
    }
    
    func fetchProjects(with token: String) {
        getAccessToken(authorizationCode: token)
    }
    
    func didSelectRow(at index: Int) {
        let gid = projects[index].gid
        let name = projects[index].name
        
        let params = ProjectTasksViewModelParams(name: name, gid: gid)
        routeSubject.send(.detail(params))
    }
}
