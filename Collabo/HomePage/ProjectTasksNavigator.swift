//
//  ProjectTasksNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 02.02.24.
//

public final class ProjectTasksNavigator {
    private weak var viewController: ProjectTasksViewController?
    private var deleteTaskAction: ((Bool) -> Void)?

    public init(viewController: ProjectTasksViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case details(TaskDetailsViewModelParams)
        case newTask
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .details(let params):
            navigateToDetails(params: params, animated: animate)
        case .newTask:
            navigateToNewTask(animated: animate)
        }
    }

    // MARK: - Private Methods
    private func navigateToDetails(params: TaskDetailsViewModelParams, animated: Bool) {
        let vc = TaskDetailsViewController()
        vc.viewModel = DefaultTaskDetailsViewModel(params: params)
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    private func navigateToNewTask(animated: Bool) {
        let vc = AddTaskViewController()
        vc.delegate = viewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = viewController
        viewController?.present(vc, animated: animated)
    }
}
