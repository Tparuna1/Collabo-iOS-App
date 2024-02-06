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
    private var moreButton: UIBarButtonItem!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
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
            self.title = title
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -100),
            
            wrapperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func setupMoreButton() {
        moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showMoreOptions))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    @objc func showMoreOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Task", style: .destructive) { [weak self] _ in
            self?.handleDeleteProject()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleDeleteProject() {
        viewModel.deleteProject()
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

