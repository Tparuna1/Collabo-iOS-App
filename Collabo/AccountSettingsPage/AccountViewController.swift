//
//  AccountVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import SwiftUI

class AccountViewController: UIViewController {
    
    private let viewModel = AccountViewModel()
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyCustomBackgroundColor()

        setupLogoutButton()
        viewModel.onLogoutComplete = { [weak self] in
            self?.navigateToLoginView()
        }
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logout()
    }
    
    private func navigateToLoginView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.switchToLoginViewController()
        }
    }
}

