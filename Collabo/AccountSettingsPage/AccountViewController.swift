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
    
    private let userInfoHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "User Info"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let statisticsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let supportHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Support"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    private lazy var UserInfoContainer: UIView = {
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
    
    private lazy var tasksCountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.102, green: 0.1765, blue: 0.2588, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var supportInfoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var supportInfoButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "How to use Collabo"
        let attributedTitle = NSMutableAttributedString()
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "info.circle")
        let attachmentString = NSAttributedString(attachment: attachment)
        attributedTitle.append(attachmentString)
        
        attributedTitle.append(NSAttributedString(string: "  "))
        
        let underlineTitle = NSAttributedString(string: title, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        attributedTitle.append(underlineTitle)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(openHowToUseCollabo), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        return button
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
        
        UserInfoContainer.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: UserInfoContainer.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: UserInfoContainer.trailingAnchor, constant: -20),
            infoStackView.topAnchor.constraint(equalTo: UserInfoContainer.topAnchor, constant: 20),
            infoStackView.bottomAnchor.constraint(equalTo: UserInfoContainer.bottomAnchor, constant: -20),
        ])
        
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(userInfoHeaderLabel)
        stackView.addArrangedSubview(UserInfoContainer)
        stackView.addArrangedSubview(supportHeaderLabel)
        stackView.addArrangedSubview(supportInfoContainer)
        stackView.addArrangedSubview(statisticsHeaderLabel)
        stackView.addArrangedSubview(tasksCountContainer)

        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            tasksCountContainer.leadingAnchor.constraint(equalTo: UserInfoContainer.leadingAnchor),
            tasksCountContainer.trailingAnchor.constraint(equalTo: UserInfoContainer.trailingAnchor),
            tasksCountContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            supportInfoContainer.leadingAnchor.constraint(equalTo: UserInfoContainer.leadingAnchor),
            supportInfoContainer.trailingAnchor.constraint(equalTo: UserInfoContainer.trailingAnchor),
            supportInfoContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        supportInfoContainer.addSubview(supportInfoButton)
        supportInfoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            supportInfoButton.leadingAnchor.constraint(equalTo: supportInfoContainer.leadingAnchor, constant: 10),
            supportInfoButton.centerYAnchor.constraint(equalTo: supportInfoContainer.centerYAnchor)
        ])
        
    }
    
    
    private func setupLabels() {
        let personImage = UIImage(systemName: "person.fill")
        let mailboxImage = UIImage(systemName: "envelope.fill")
        
        let personImageView = UIImageView(image: personImage)
        let mailboxImageView = UIImageView(image: mailboxImage)
        
        personImageView.contentMode = .scaleAspectFit
        mailboxImageView.contentMode = .scaleAspectFit
        
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personImageView.widthAnchor.constraint(equalToConstant: 20),
            personImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        mailboxImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mailboxImageView.widthAnchor.constraint(equalToConstant: 20),
            mailboxImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let personStackView = UIStackView(arrangedSubviews: [personImageView, nameLabel])
        personStackView.axis = .horizontal
        personStackView.spacing = 10
        
        let mailboxStackView = UIStackView(arrangedSubviews: [mailboxImageView, emailLabel])
        mailboxStackView.axis = .horizontal
        mailboxStackView.spacing = 10
        
        infoStackView.addArrangedSubview(personStackView)
        infoStackView.addArrangedSubview(mailboxStackView)
        
        nameLabel.text = "Name: Loading..."
        emailLabel.text = "Email: Loading..."
        
        nameLabel.textAlignment = .left
        emailLabel.textAlignment = .left
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        
        nameLabel.numberOfLines = 0
        emailLabel.numberOfLines = 0
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
    
    private func updateTasksCountLabel(_ count: Int) {
        let tasksCountLabel = UILabel()
        tasksCountLabel.textColor = .white
        tasksCountLabel.textAlignment = .left
        tasksCountLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tasksCountLabel.text = "Overall tasks to complete:"
        
        let countLabel = UILabel()
        countLabel.textColor = .white
        countLabel.textAlignment = .right
        countLabel.font = UIFont.boldSystemFont(ofSize: 18)
        countLabel.text = "\(count)"
        
        let stackView = UIStackView(arrangedSubviews: [tasksCountLabel, countLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        tasksCountContainer.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: tasksCountContainer.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: tasksCountContainer.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: tasksCountContainer.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: tasksCountContainer.bottomAnchor, constant: -20),
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
        
        viewModel.fetchAndCountUserTasks { [weak self] result in
            switch result {
            case .success(let count):
                DispatchQueue.main.async {
                    self?.updateTasksCountLabel(count)
                }
            case .failure(let error):
                print("Failed to fetch and count user tasks: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateLabels(with userInfo: UserProfile) {
        if let name = userInfo.data?.name {
            nameLabel.text = "\(name)"
        } else {
            nameLabel.text = "Name: N/A"
        }
        
        if let email = userInfo.data?.email {
            emailLabel.text = "\(email)"
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
    
    @objc private func openHowToUseCollabo() {
        let howToUseCollaboViewController = HowToUseCollaboViewController()
        let sheetPresentationController = SheetPresentationController(presentedViewController: howToUseCollaboViewController, presenting: self)
        howToUseCollaboViewController.modalPresentationStyle = .custom
        howToUseCollaboViewController.transitioningDelegate = sheetPresentationController
        present(howToUseCollaboViewController, animated: true, completion: nil)
    }
    
    
    private func navigateToLoginView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.switchToLoginViewController()
        }
    }
}



