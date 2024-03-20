//
//  AddSubtaskViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//

import UIKit

// MARK: Protocols

protocol AddSubtaskViewControllerDelegate: AnyObject {
    func dismissed()
}

final class AddSubtaskViewController: UIViewController {
    
    // MARK: - Properties
    
    private var initialSheetYPosition: CGFloat = 0
    private var viewModel = AddSubtaskViewModel()
    var taskGID: String?
    
    public weak var delegate: AddSubtaskViewControllerDelegate?


    // MARK: - UI Components
    
    private let titleLabel = CustomLabelForSheetPresentationController(text: "Add Subtask", font: UIFont.boldSystemFont(ofSize: 20), textColor: .systemCyan, alignment: .center)
    
    private let subtaskNameTextField = CustomTextFieldForSheetPresentationController(placeholder: "Subtask Name")
    
    private let createButton = CustomButtonFOrSheetPresentationController(title: "Create", backgroundColor: .systemCyan, cornerRadius: 5)
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        initialSheetYPosition = view.frame.origin.y
        
        view.backgroundColor = .gray
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtaskNameTextField)
        view.addSubview(createButton)
        
        titleLabel.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: 40)
        subtaskNameTextField.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40)
        createButton.frame = CGRect(x: 20, y: 140, width: view.frame.width - 40, height: 40)
        
        createButton.addTarget(self, action: #selector(addSubtask), for: .touchUpInside)
    }
    
    // MARK: - Gesture Handling
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .began:
            initialSheetYPosition = view.frame.origin.y
        case .changed:
            let newY = initialSheetYPosition + translation.y
            
            if newY >= initialSheetYPosition {
                view.frame.origin.y = newY
                recognizer.setTranslation(.zero, in: view)
            }
        case .ended:
            let velocityY = recognizer.velocity(in: view).y
            
            let shouldDismiss = view.frame.origin.y > view.bounds.height * 0.5 || velocityY > 500
            
            if shouldDismiss {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = self.view.bounds.height
                }) { _ in
                    self.dismiss(animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = self.initialSheetYPosition
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Button Actions
    
    @objc func addSubtask() {
        print("button tapped")
        guard let SubtaskName = subtaskNameTextField.text, !SubtaskName.isEmpty else {
            print("Task name is empty")
            return
        }
        
        viewModel.addSubtask(name: SubtaskName) { result in
            switch result {
            case .success:
                print("Task added successfully")
                DispatchQueue.main.async {
                    self.dismiss(animated: true) { [weak self] in
                        self?.delegate?.dismissed()
                    }
                }
            case .failure(let error):
                print("Error creating task: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Keyboard Handling
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let newY = view.frame.origin.y - keyboardHeight

        if newY >= initialSheetYPosition {
            view.frame.origin.y = newY
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = initialSheetYPosition
    }
}
