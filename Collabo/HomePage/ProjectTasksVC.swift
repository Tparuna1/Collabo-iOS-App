//
//  ProjectTasksVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import UIKit
import Combine

class ProjectTasksVC: UIViewController {
    
    // MARK: - Properties
    
    var projectTasksViewModel = ProjectTasksViewModel()
    var cancellables = Set<AnyCancellable>()
    var selectedTaskGID: String = ""
    var selectedProjectName: String?
    
    // MARK: - UI Components
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        projectTasksViewModel.fetchTasks()
        tasksTableView.register(CustomProjectCell.self, forCellReuseIdentifier: "CustomTaskCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        view.applyCustomBackgroundColor()

    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .clear
        wrapperView.layer.cornerRadius = 10
        wrapperView.clipsToBounds = true
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(tasksTableView)
        
        let projectNameLabel = UILabel()
        projectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectNameLabel.text = selectedProjectName
        projectNameLabel.textColor = .systemBlue
        projectNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        wrapperView.addSubview(projectNameLabel)
        
        NSLayoutConstraint.activate([
            projectNameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 20),
            projectNameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 20),
            projectNameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -20),
            
            tasksTableView.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 20),
            tasksTableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -100),
            
            wrapperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wrapperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            wrapperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 800),
        ])
        
        tasksTableView.separatorStyle = .none
        tasksTableView.backgroundColor = .clear
    }
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        projectTasksViewModel.$tasks.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tasksTableView.reloadData()
        }.store(in: &cancellables)
        
        projectTasksViewModel.$errorMessage.receive(on: DispatchQueue.main).sink { [weak self] (errorMessage: String?) in
            if let message = errorMessage {
                print("Error: \(message)")
            }
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate

extension ProjectTasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let selectedTaskGID = projectTasksViewModel.tasks[indexPath.row].gid
        let taskDetailsVC = TaskDetailsVC()
        taskDetailsVC.taskGID = selectedTaskGID
        navigationController?.pushViewController(taskDetailsVC, animated: true)
        
    }
}

// MARK: - UITableViewDataSource

extension ProjectTasksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectTasksViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTaskCell", for: indexPath) as! CustomProjectCell
        let task = projectTasksViewModel.tasks[indexPath.row]
        
        let colors: [UIColor] = [.red, .green, .blue, .orange]
        let colorIndex = indexPath.row % colors.count
        
        cell.setColor(colors[colorIndex])
        cell.textLabel?.text = task.name
        return cell
    }
}


