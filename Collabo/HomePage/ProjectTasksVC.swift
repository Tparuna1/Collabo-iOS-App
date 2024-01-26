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
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        viewModel.fetchTasks()
        tasksTableView.register(CustomProjectCell.self, forCellReuseIdentifier: "CustomTaskCell")
    }

    func setupUI() {
        view.addSubview(tasksTableView)

        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .clear
        wrapperView.layer.cornerRadius = 10
        wrapperView.layer.borderWidth = 1.0
        wrapperView.layer.borderColor = UIColor.systemBlue.cgColor
        wrapperView.clipsToBounds = true

        view.addSubview(wrapperView)

        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tasksTableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -100),

            wrapperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wrapperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            wrapperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 800),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTaskCell", for: indexPath) as! CustomProjectCell
        let task = viewModel.tasks[indexPath.row]

        cell.setProjectIcon(UIImage(named: "task_icon"))

        cell.textLabel?.text = task.name
        return cell
    }

}
