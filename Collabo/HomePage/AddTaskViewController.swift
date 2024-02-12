//
//  AddTaskViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 08.02.24.
//

import UIKit

// MARK: - Protocols

protocol AddTaskViewControllerDelegate: AnyObject {
    func dismissed()
}

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    
    private var initialSheetYPosition: CGFloat = 0
    var viewModel = AddTaskViewModel()
    
    public weak var delegate: AddTaskViewControllerDelegate?
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a New Task"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .systemCyan
        return label
    }()
    
    let taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        initialSheetYPosition = view.frame.origin.y
        
        view.backgroundColor = .white
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configure(with viewModel: AddTaskViewModel) {
            self.viewModel = viewModel
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(taskNameTextField)
        view.addSubview(createButton)
        
        titleLabel.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: 40)
        taskNameTextField.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 40)
        createButton.frame = CGRect(x: 20, y: 140, width: view.frame.width - 40, height: 40)
        
        createButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
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
    
    @objc func addTask() {
        print("button tapped")
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            return
        }
        
        viewModel.addTask(name: taskName) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: true) { [weak self] in
                        self?.delegate?.dismissed()
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
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
