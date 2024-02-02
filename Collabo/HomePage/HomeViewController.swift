//
//  HomeViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Combine

public final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel!
    var navigator: HomeNavigator!
    
    private var projects = [AsanaProject]()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    
    private lazy var asanaLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "asanaLogo")
        return imageView
    }()
    
    private lazy var fetchDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fetch data from Asana"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var fetchDataContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter OAuth Token"
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.textColor = .systemBlue
        return textField
    }()
    
    private lazy var fetchDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch Data", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(fetchData(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var addProjectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ Add Project", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addProject(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        bind(to: viewModel)
        view.applyCustomBackgroundColor()
        viewModel.viewDidLoad()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Home"
        view.addSubview(fetchDataContainerView)
        
        let fetchDataTitleLabel = UILabel()
        fetchDataTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fetchDataTitleLabel.text = "Fetch data"
        fetchDataTitleLabel.textAlignment = .left
        fetchDataTitleLabel.textColor = .black
        fetchDataTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(fetchDataTitleLabel)
        
        let headerStackView = UIStackView(arrangedSubviews: [asanaLogoImageView, fetchDataLabel])
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fillProportionally
        headerStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [headerStackView, codeTextField, fetchDataButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        fetchDataContainerView.addSubview(stackView)
        
        let tableViewWrapper = UIView()
        tableViewWrapper.translatesAutoresizingMaskIntoConstraints = false
        tableViewWrapper.backgroundColor = .clear
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Projects"
        headerLabel.textAlignment = .left
        headerLabel.textColor = .black
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        view.addSubview(headerLabel)
        view.addSubview(tableViewWrapper)
        view.addSubview(addProjectButton)
        
        NSLayoutConstraint.activate([
            
            fetchDataTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fetchDataTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fetchDataTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: fetchDataContainerView.trailingAnchor, constant: -20), 

            
            fetchDataContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            fetchDataContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fetchDataContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fetchDataContainerView.heightAnchor.constraint(equalToConstant: 180),
            
            stackView.topAnchor.constraint(equalTo: fetchDataContainerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: fetchDataContainerView.leadingAnchor, constant: 20),
            
            asanaLogoImageView.widthAnchor.constraint(equalToConstant: 24),
            asanaLogoImageView.heightAnchor.constraint(equalToConstant: 24),
            
            headerStackView.heightAnchor.constraint(equalToConstant: 40),
            
            codeTextField.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20),
            codeTextField.leadingAnchor.constraint(equalTo: fetchDataContainerView.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: fetchDataContainerView.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            fetchDataButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            fetchDataButton.leadingAnchor.constraint(equalTo: codeTextField.leadingAnchor),
            fetchDataButton.trailingAnchor.constraint(equalTo: codeTextField.trailingAnchor),
            fetchDataButton.heightAnchor.constraint(equalToConstant: 40),
            
            headerLabel.topAnchor.constraint(equalTo: fetchDataContainerView.bottomAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: fetchDataContainerView.leadingAnchor, constant: 20),


            tableViewWrapper.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            tableViewWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableViewWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableViewWrapper.bottomAnchor.constraint(equalTo: addProjectButton.topAnchor, constant: -20),
            
            addProjectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addProjectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addProjectButton.widthAnchor.constraint(equalToConstant: 140),
            addProjectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        tableViewWrapper.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewWrapper.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewWrapper.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewWrapper.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewWrapper.bottomAnchor),
        ])
    }
    
    
    // MARK: - View Model Binding
    private func bind(to viewModel: HomeViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }
    
    private func didReceive(action: HomeViewModelOutputAction) {
        switch action {
        case .projects(let projects):
            self.projects = projects
            tableView.reloadData()
        }
    }
    
    private func didReceive(route: HomeViewModelRoute) {
        switch route {
        case .detail(let params):
            navigator.navigate(to: .details(params), animated: true)
        case .newProject:
            navigator.navigate(to: .newProject, animated: true)
        }
    }
    
    // MARK: - Button Actions
    
    @objc func fetchData(_ sender: UIButton) {
        let authorizationCode = codeTextField.text ?? ""
        viewModel.fetchProjects(with: authorizationCode)
    }
    
    @objc func addProject(_ sender: UIButton) {
        viewModel.newProject()
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        
        let project = projects[indexPath.row]
        
        let colors: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemOrange]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: project.name, color: colors[colorIndex]))
        
        return cell
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeViewController: NewProjectViewControllerDelegate {
    func dismissed() {
        viewModel.fetchProjects(with: "")
    }
}
