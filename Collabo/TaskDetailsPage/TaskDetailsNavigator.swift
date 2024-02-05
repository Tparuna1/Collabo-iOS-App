//
//  TaskDetailsNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//


public final class TaskDetailsNavigator {
    private weak var viewController: TaskDetailsViewController?
    private var deleteTaskAction: ((Bool) -> Void)?


    public init(viewController: TaskDetailsViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case newSubtask
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
            navigateToAddSubtask(animated: animate)
    }

    // MARK: - Private Methods
    
    private func navigateToAddSubtask(animated: Bool) {
        let vc = AddSubtaskViewController()
        vc.delegate = viewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = viewController
        viewController?.present(vc, animated: animated)
    }
}
