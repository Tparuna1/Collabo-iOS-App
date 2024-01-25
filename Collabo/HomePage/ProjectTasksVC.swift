//
//  ProjectTasksVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import UIKit
import Combine


class ProjectTasksVC: UIViewController, UITableViewDataSource {

    var viewModel = ProjectTasksViewModel()
    var cancellables = Set<AnyCancellable>()

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

    func bindViewModel() {
        viewModel.$tasks.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tasksTableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$errorMessage.receive(on: DispatchQueue.main).sink { [weak self] (errorMessage: String?) in
            if let message = errorMessage {
                print("Error: \(message)")
            }
        }.store(in: &cancellables)
    }


    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
}
