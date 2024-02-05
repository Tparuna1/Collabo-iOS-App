//
//  AccountVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Auth0
import Combine

class AccountViewController: UIViewController {
    private let viewModel = AccountViewModel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let profileImageView = UIImageView()
    private let logoutButton = UIButton(type: .system)
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyCustomBackgroundColor()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        setupProfileImageView()
        setupLabels()
        setupLogoutButton()
    }

    private func setupLabels() {
        nameLabel.text = "Name: Loading..."
        emailLabel.text = "Email: Loading..."
        
        nameLabel.textAlignment = .center
        emailLabel.textAlignment = .left
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        
        nameLabel.numberOfLines = 0
        emailLabel.numberOfLines = 0
        
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
        ])
    }

    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        
        view.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
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
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func bindViewModel() {
        viewModel.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    self?.updateLabels(with: userInfo)
                }
            case .failure(let error):
                print("Failed to fetch user info: \(error)")
            }
        }
    }

    private func updateLabels(with userInfo: UserProfile) {
        if let name = userInfo.data?.name {
            nameLabel.text = "Name: \(name)"
        } else {
            nameLabel.text = "Name: N/A"
        }
        
        if let email = userInfo.data?.email {
            emailLabel.text = "Email: \(email)"
        } else {
            emailLabel.text = "Email: N/A"
        }
        
        if let imageUrl = userInfo.data?.photo?.image128X128 {
            if let url = URL(string: imageUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        } else {
            profileImageView.image = UIImage(named: "DefaultProfileImage")
        }
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


