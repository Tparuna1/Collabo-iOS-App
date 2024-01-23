//
//  ProjectTasksVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import UIKit

class ProjectTasksVC: UIViewController, UITableViewDataSource {

    var viewModel = ProjectTasksViewModel()
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchTasks()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tasksTableView)
        
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tasksTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.tasks.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tasksTableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        if let task = viewModel.tasks.value?[indexPath.row] {
            cell.textLabel?.text = task.name
        }
        return cell
    }
}
