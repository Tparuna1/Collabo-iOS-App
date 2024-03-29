//
//  ProjectTasksNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 02.02.24.
//

// MARK: - ProjectTasksNavigator

public final class ProjectTasksNavigator {
    private weak var viewController: ProjectTasksViewController?
    private var deleteTaskAction: ((Bool) -> Void)?

    public init(viewController: ProjectTasksViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case details(TaskDetailsViewModelParams)
        case newTask
        case close
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .details(let params):
            navigateToDetails(params: params, animated: animate)
        case .newTask:
            navigateToNewTask(animated: animate)
        case .close:
            navigateToClose(animated: animate)
        }
    }

    // MARK: - Private Methods
    
    private func navigateToDetails(params: TaskDetailsViewModelParams, animated: Bool) {
        let vc = TaskDetailsViewController()
        vc.viewModel = DefaultTaskDetailsViewModel(params: params)
        vc.navigator = .init(viewController: vc)
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    private func navigateToNewTask(animated: Bool) {
        guard let viewController = viewController else {
            return
        }
        
        let addTaskViewModel = AddTaskViewModel()
        addTaskViewModel.params = ProjectTasksViewModelParams(name: viewController.viewModel.params?.name ?? "", gid: viewController.viewModel.params?.gid ?? "")
        
        let vc = AddTaskViewController()
        vc.viewModel = addTaskViewModel
        vc.delegate = viewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = viewController
        viewController.present(vc, animated: animated)
    }
    private func navigateToClose(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
}
