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
    private var tasks = [UserTaskList]()
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - UI Components
    
    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 251/255, green: 247/255, blue: 248/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "My Tasks"
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "MyTaskList")
        return imageView
    }()
    
    // MARK: - View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingImageView()
        setupUI()
        setupTableView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        view.applyCustomBackgroundColor()
    }
    
    // MARK: - View Model Binding
    
    private func bind(to viewModel: UserTaskListViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }
    
    private func didReceive(action: UserTaskListViewModelOutputAction) {
        switch action {
        case .tasks(let tasks):
            self.tasks = tasks
            tableView.reloadData()
            
            loadingImageView.isHidden = true
        }
    }
    
    private func didReceive(route: UserTaskListViewModelRoute) {
        switch route {
        case .details(let params):
            navigator.navigate(to: .details(params), animated: true)
        }
    }
    
    // MARK: - UI Setup
    
    private func setupCustomNavBar() {
        view.addSubview(customNavBar)
        customNavBar.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            customNavBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            headerLabel.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupUI() {
        setupCustomNavBar()
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 20),
            wrapperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            wrapperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            wrapperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        ])
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "UserTaskCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLoadingImageView() {
        view.addSubview(loadingImageView)
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 200),
            loadingImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
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
        
        let colors: [UIColor] = [.systemBlue]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: task.name, color: colors[colorIndex]))
        
        return cell
    }
}

// MARK: - Delegate Extensions

extension UserTaskListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}
