//
//  HowToUseCollaboViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 28.03.24.
//

import UIKit

//MARK: - HowToUseCollaboViewController

final class HowToUseCollaboViewController: UIViewController {
    
    // MARK: - Properties
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        return textView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyCustomBackgroundColor()
        setupDismissButton()
        setupTextView()
        addConstraints()
        setupTextViewContent()
    }
    
    // MARK: - Setup UI
    
    private func setupDismissButton() {
        let dismissButton = UIButton(type: .custom)
        dismissButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        dismissButton.tintColor = .red
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            dismissButton.widthAnchor.constraint(equalToConstant: 48),
            dismissButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup TextView
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Setup TextView Content
    
    private func setupTextViewContent() {
        let attributedText = NSMutableAttributedString()
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black]
        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]
        
        attributedText.append(NSAttributedString(string: "Welcome to Collabo!\n", attributes: titleAttributes))
        attributedText.append(NSAttributedString(string: "Here's a quick guide on how to use Collabo:\n\n", attributes: bodyAttributes))
        
        let steps: [(title: String, description: String)] = [
            ("Authentication", "Upon launching the app, authenticate using your email and password."),
            ("Navigation", "Use the tab bar at the bottom to switch between sections like Projects, Tasks, Todo Lists, and Timer."),
            ("Managing Projects and Tasks", "View and manage your Asana projects and tasks seamlessly."),
            ("Personal Todo Lists", "Create and manage your own Todo lists within the app."),
            ("Timer Feature", "Track time spent on tasks and projects with Collabo's Timer feature.")
        ]
        
        for (index, step) in steps.enumerated() {
            attributedText.append(NSAttributedString(string: "\(index + 1). \(step.title)\n", attributes: titleAttributes))
            attributedText.append(NSAttributedString(string: "\(step.description)\n\n", attributes: bodyAttributes))
        }
        
        textView.attributedText = attributedText
    }
    
    // MARK: - Layout Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}

