//
//  ProjectTasksViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import UIKit
import Combine

public final class ProjectTasksViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: DefaultProjectTasksViewModel!
    var navigator: ProjectTasksNavigator!
    var taskDetailsNavigator: TaskDetailsNavigator!
    
    private var tasks = [AsanaTask]()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showMoreOptions), for: .touchUpInside)
        return button
    }()

    private let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let wrapperView: UIView = {
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .clear
        wrapperView.layer.cornerRadius = 10
        wrapperView.clipsToBounds = true
        return wrapperView
    }()
    
    // MARK: - View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        setupCustomNavBar()
        setupUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        setupTableView()
        view.applyCustomBackgroundColor()
    }
    
    // MARK: - View Model Binding
    private func bind(to viewModel: ProjectTasksViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }
    
    private func didReceive(action: ProjectTasksViewModelOutputAction) {
        switch action {
        case .title(let title):
            self.navBarTitleLabel.text = title
        case .tasks(let tasks):
            self.tasks = tasks
            tableView.reloadData()
        }
    }
    
    private func didReceive(route: ProjectTasksViewModelRoute) {
        switch route {
        case .details(let params):
            navigator.navigate(to: .details(params), animated: true)
        case .projectDeleted:
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupCustomNavBar() {
        view.addSubview(customNavBar)
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(navBarTitleLabel)
        customNavBar.addSubview(moreButton)
        
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            customNavBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            backButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            moreButton.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -10),
            moreButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 44),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            
            navBarTitleLabel.centerXAnchor.constraint(equalTo: customNavBar.centerXAnchor),
            navBarTitleLabel.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -50),
            navBarTitleLabel.leftAnchor.constraint(greaterThanOrEqualTo: customNavBar.leftAnchor, constant: 16),
            navBarTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: customNavBar.rightAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -100),
            
            wrapperView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 20),
            wrapperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            wrapperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 800),
        ])
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showMoreOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Project", style: .destructive) { [weak self] _ in
            self?.handleDeleteProject()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.moreButton
            popoverController.sourceRect = self.moreButton.bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }

    
    func handleDeleteProject() {
        viewModel.deleteProject()
    }
}

// MARK: - UITableViewDataSource

extension ProjectTasksViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        let task = tasks[indexPath.row]
        
        let colors: [UIColor] = [.systemBlue]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: task.name, color: colors[colorIndex]))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProjectTasksViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}
