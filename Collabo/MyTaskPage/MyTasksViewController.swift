//
//  MyTasksVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Combine

public final class UserTaskListViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: UserTaskListViewModel!
    var navigator: UserTaskListNavigator!
    
    var cancellables = Set<AnyCancellable>()
    
    private var tasks = [UserTaskList]()
    
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
    private func bind(to viewModel: UserTaskListViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }
    
    private func didReceive(action: UserTaskListViewModelOutputAction) {
        switch action {
        case .title(let title):
            self.title = title
        case .tasks(let tasks):
            self.tasks = tasks
            tableView.reloadData()
        }
    }
    
    private func didReceive(route: UserTaskListViewModelRoute) {
        switch route {
        case .details(let params):
            navigator.navigate(to: .details(params), animated: true)
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
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
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "UserTaskCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension UserTaskListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension UserTaskListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTaskCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        let task = tasks[indexPath.row]
        
        let colors: [UIColor] = [.red, .green, .blue, .orange]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: task.name, color: colors[colorIndex]))
        
        return cell
    }
}

