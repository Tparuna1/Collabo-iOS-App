//
//  MyTaskListNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 05.02.24.
//

import Foundation

public final class UserTaskListNavigator {
    private weak var viewController: UserTaskListViewController?

    public init(viewController: UserTaskListViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case details(TaskDetailsViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .details(let params):
            navigateToDetails(params: params, animated: animate)
        }
    }

    // MARK: - Private Methods
    private func navigateToDetails(params: TaskDetailsViewModelParams, animated: Bool) {
        let vc = TaskDetailsViewController()
        vc.viewModel = DefaultTaskDetailsViewModel(params: params)
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
}
