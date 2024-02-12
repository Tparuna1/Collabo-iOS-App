//
//  TaskDetailsNavigator.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//

// MARK: - TaskDetailsNavigator

public final class TaskDetailsNavigator {
    private weak var viewController: TaskDetailsViewController?
    private var deleteTaskAction: ((Bool) -> Void)?


    public init(viewController: TaskDetailsViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case newSubtask
        case close
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .newSubtask:
            navigateToAddSubtask(animated: animate)
        case .close:
            navigateToClose(animated: animate)
        }
    }

    // MARK: - Private Methods
    
    private func navigateToAddSubtask(animated: Bool) {
        let vc = AddSubtaskViewController()
        vc.delegate = viewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = viewController
        viewController?.present(vc, animated: animated)
    }
        
    private func navigateToClose(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
}
