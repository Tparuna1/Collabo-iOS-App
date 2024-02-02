//
//  TaskDetailsVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//


import UIKit
import Combine

class TaskDetailsVC: UIViewController {
    
    // MARK: - Properties
    var taskDetailsViewModel = TaskDetailsViewModel()
    var taskGID: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        taskDetailsViewModel.taskGID = taskGID
        taskDetailsViewModel.fetchSingleTask()
        view.applyCustomBackgroundColor()

    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func bindViewModel() {
        taskDetailsViewModel.$task
            .receive(on: DispatchQueue.main)
            .sink { [weak self] task in
                guard let task = task else {
                    return
                }
                self?.populateTaskDetails(task)
            }
            .store(in: &cancellables)
        
        taskDetailsViewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Populate Task Details
    private func populateTaskDetails(_ task: TaskAsana) {
        titleLabel.text = task.data.name
        descriptionLabel.text = task.data.description
    }
}


