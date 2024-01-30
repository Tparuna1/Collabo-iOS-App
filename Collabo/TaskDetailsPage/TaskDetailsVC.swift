//
//  TaskDetailsVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//

import UIKit

class TaskDetailsVC: UIViewController {

    // MARK: - Properties
    var taskDetailsViewModel = TaskDetailsViewModel()
    var selectedTaskGID: String = ""

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        bindViewModel()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(notesLabel)
        view.addSubview(createdAtLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            notesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            createdAtLabel.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 10),
            createdAtLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createdAtLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func bindViewModel() {
        taskDetailsViewModel.$task
            .receive(on: DispatchQueue.main)
            .sink { [weak self] task in
                guard let task = task else {
                    print("Task is nil")
                    return
                }
                self?.populateTaskDetails(task)
            }
            .store(in: &taskDetailsViewModel.cancellables)

        if !taskDetailsViewModel.taskGID.isEmpty {
            taskDetailsViewModel.fetchSingleTask()
        }
    }


    // MARK: - Fetch Task Details
    private func fetchTaskDetails() {
        taskDetailsViewModel.taskGID = selectedTaskGID

        taskDetailsViewModel.fetchSingleTask()
        taskDetailsViewModel.$task
            .sink { [weak self] task in
                if let task = task {
                    self?.populateTaskDetails(task)
                }
            }
            .store(in: &taskDetailsViewModel.cancellables)
    }

    // MARK: - Populate Task Details
    private func populateTaskDetails(_ task: SingleAsanaTask) {
        titleLabel.text = task.name
        notesLabel.text = task.notes
        createdAtLabel.text = "Created at: \(task.createdAt)"
    }
}
