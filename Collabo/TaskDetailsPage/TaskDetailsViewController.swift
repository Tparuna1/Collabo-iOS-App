//
//  TaskDetailsViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//


import UIKit
import Combine

public final class TaskDetailsViewController: UIViewController {
    
    
    // MARK: - Properties
    var viewModel: TaskDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private var subtask = [Subtask]()
    var inputCellModels = [InputCellModel]()
    
    
    // MARK: - UI Elements
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.text = "Completed"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .green
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let dueOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .blue
        return label
    }()
    
    private let assigneeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
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
    
    // MARK: - Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(to: viewModel)
        setupTableView()
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
        case .subtask(let subtask):
            self.subtask = subtask
            tableView.reloadData()
        }
    }
    
    private func didReceive(route: TaskDetailsViewModelRoute) {
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        mainStackView.addArrangedSubview(descriptionLabel)
        
        completedStackView.addArrangedSubview(completedLabel)
        completedStackView.addArrangedSubview(checkmarkImageView)
        
        mainStackView.addArrangedSubview(completedStackView)
        
        mainStackView.addArrangedSubview(dueOnLabel)
        
        mainStackView.addArrangedSubview(assigneeLabel)
        
        mainStackView.addArrangedSubview(UIView())
        
        view.addSubview(mainStackView)
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            wrapperView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
        ])
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "SubtaskCell")
        tableView.dataSource = self
    }
    
    func addInputCell(withPlaceholder placeholder: String) {
            let newInputModel = InputCellModel(placeholder: placeholder)
            inputCellModels.append(newInputModel)

            tableView.reloadData()
    }
    
    // MARK: - Populate Task Details
    private func populateDetails(with task: SingleAsanaTask?) {
        guard let task else { return }
        self.title = task.name
        descriptionLabel.text = task.notes
        
        if let completed = task.completed {
            if completed {
                descriptionLabel.textColor = .gray
                completedLabel.text = "Completed"
                checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            } else {
                descriptionLabel.textColor = .gray
                completedLabel.text = "Not Completed"
                checkmarkImageView.image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            }
        }
        
        if let dueOnString = task.dueOn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let dueOnDate = dateFormatter.date(from: dueOnString) {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let formattedDueOn = dateFormatter.string(from: dueOnDate)
                dueOnLabel.text = "Due On: \(formattedDueOn)"
            } else {
                dueOnLabel.text = "Due On: Invalid Date"
            }
        } else {
            dueOnLabel.text = "Due On: Not Set"
        }
        
        if let assignee = task.assignee {
            let assigneeName = assignee.name ?? "Unknown"
            assigneeLabel.text = "Assignee: \(assigneeName)"
        } else {
            assigneeLabel.text = "Assignee: Not Assigned"
        }
    }
    
}

extension TaskDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtask.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        let subtask = subtask[indexPath.row]
        
        let colors: [UIColor] = [.red, .green, .blue, .orange]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: subtask.name, color: colors[colorIndex]))
        
        return cell
    }
}





