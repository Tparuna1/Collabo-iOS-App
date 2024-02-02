//
//  HomeNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 02.02.24.
//


public final class HomeNavigator {
    private weak var viewController: HomeViewController?

    public init(viewController: HomeViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case details(ProjectTasksViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .details(let params):
            navigateToDetails(params: params, animated: animate)
        }
    }

    // MARK: - Private Methods
    private func navigateToDetails(params: ProjectTasksViewModelParams, animated: Bool) {
        let vc = ProjectTasksViewController()
        vc.viewModel = DefaultProjectTasksViewModel(params: params)
        vc.navigator = .init(viewController: vc)
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
}
