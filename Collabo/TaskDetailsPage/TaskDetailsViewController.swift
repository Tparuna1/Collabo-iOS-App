//
//  TaskDetailsViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//


import UIKit
import Combine

class TaskDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: TaskDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
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
        bind(to: viewModel)
        viewModel.viewDidLoad()
        view.applyCustomBackgroundColor()

    }
    
    // MARK: - View Model Binding
    private func bind(to viewModel: TaskDetailsViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }
    
    private func didReceive(action: TaskDetailsViewModelOutputAction) {
        switch action {
        case .task(let task):
            populateDetails(with: task)
        }
    }
    
    private func didReceive(route: TaskDetailsViewModelRoute) {
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Populate Task Details
    private func populateDetails(with task: SingleAsanaTask?) {
        guard let task else { return }
        self.title = task.name
        descriptionLabel.text = task.notes
    }
}


//"\(dump(task))"
