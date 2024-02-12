//
//  AccountVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Auth0
import Combine

final class AccountViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AccountViewModel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let profileImageView = UIImageView()
    private let logoutButton = UIButton(type: .system)
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    private lazy var infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyCustomBackgroundColor()
        setupUI()
        bindViewModel()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupProfileImageView()
        setupLabels()
        setupLogoutButton()
        
        infoContainer.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -20),
            infoStackView.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 20),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -20),
        ])
        
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(infoContainer)
        setupLogoutButton()
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
        ])
    }

    private func setupLabels() {
        nameLabel.text = "Name: Loading..."
        emailLabel.text = "Email: Loading..."
        
        nameLabel.textAlignment = .left
        emailLabel.textAlignment = .left
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        
        nameLabel.numberOfLines = 0
        emailLabel.numberOfLines = 0
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(emailLabel)
    }

    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - View Model Binding

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

    // MARK: - Private Methods
    
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


