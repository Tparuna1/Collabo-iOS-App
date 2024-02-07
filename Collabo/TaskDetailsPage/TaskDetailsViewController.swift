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
    var viewModel: DefaultTaskDetailsViewModel!
    var navigator: TaskDetailsNavigator!
    
    private var subtask = [Subtask]()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showMoreOptions), for: .touchUpInside)
        return button
    }()
    
    private let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.05)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
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
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dueOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dueOnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(calendarImageView)
        stackView.addArrangedSubview(dueOnLabel)
        return stackView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let assigneeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var assigneeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(assigneeLabel)
        return stackView
    }()
    
    private let subtasksHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtasks"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
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
    
    private lazy var addSubtaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Subtask", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addSubtask(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavBar()
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
        case .title(let title):
            self.navBarTitleLabel.text = title
        case .task(let task):
            populateDetails(with: task)
        case .subtask(let subtask):
            self.subtask = subtask
            tableView.reloadData()
        }
    }
    
    private func didReceive(route: TaskDetailsViewModelRoute) {
        switch route {
        case .newSubtask:
            navigator.navigate(to: .newSubtask, animated: true)
        case .taskDeleted:
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Custom Navigation Bar Setup
    private func setupCustomNavBar() {
        view.addSubview(customNavBar)
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(navBarTitleLabel)
        customNavBar.addSubview(moreButton)
        
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            customNavBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 150),
            
            backButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            moreButton.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -10),
            moreButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 44),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            
            navBarTitleLabel.centerXAnchor.constraint(equalTo: customNavBar.centerXAnchor),
            navBarTitleLabel.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -50),
            navBarTitleLabel.leftAnchor.constraint(greaterThanOrEqualTo: customNavBar.leftAnchor, constant: 16),
            navBarTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: customNavBar.rightAnchor, constant: -16)
        ])
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        completedStackView.addArrangedSubview(checkmarkImageView)
        completedStackView.addArrangedSubview(completedLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTaskCompletion))
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainerView.addSubview(scrollView)
        
        checkmarkImageView.isUserInteractionEnabled = true
        checkmarkImageView.addGestureRecognizer(tapGesture)
        
        descriptionContainerView.addSubview(headerLabel)
        descriptionContainerView.addSubview(descriptionLabel)
        
        
        mainStackView.addArrangedSubview(completedStackView)
        mainStackView.addArrangedSubview(dueOnStackView)
        mainStackView.addArrangedSubview(assigneeStackView)
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(descriptionContainerView)
        mainStackView.addArrangedSubview(subtasksHeaderLabel
        )
        mainStackView.addArrangedSubview(UIView())
        
        view.addSubview(mainStackView)
        view.addSubview(wrapperView)
        view.addSubview(addSubtaskButton)
        wrapperView.addSubview(tableView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionContainerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            descriptionContainerView.heightAnchor.constraint(equalToConstant: 100),

            
            scrollView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            wrapperView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            
            addSubtaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addSubtaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addSubtaskButton.widthAnchor.constraint(equalToConstant: 140),
            addSubtaskButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    
    private func setupTableView() {
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "SubtaskCell")
        tableView.dataSource = self
        tableView.rowHeight = 70
    }
    
    @objc func addSubtask(_ sender: UIButton) {
        print("Add Subtask button tapped")
        viewModel.newSubtask()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showMoreOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Task", style: .destructive) { [weak self] _ in
            self?.handleDeleteTask()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.moreButton
            popoverController.sourceRect = self.moreButton.bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleDeleteTask() {
        viewModel.deleteTask()
    }
    
    @objc func toggleTaskCompletion() {
        if var task = viewModel.task {
            if let currentCompletionStatus = task.completed {
                let newCompletionStatus = !currentCompletionStatus
                task.completed = newCompletionStatus
                
                if newCompletionStatus {
                    completedLabel.text = "Completed"
                    checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
                } else {
                    completedLabel.text = "Not Completed"
                    checkmarkImageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                }
                
                viewModel.task = task
                viewModel.updateSingleTask()
            }
        }
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
                checkmarkImageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
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

// MARK: - UITableViewDataSource

extension TaskDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtask.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        let subtask = subtask[indexPath.row]
        
        let colors: [UIColor] = [.systemOrange]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: subtask.name, color: colors[colorIndex]))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskDetailsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension TaskDetailsViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension TaskDetailsViewController: AddSubtaskViewControllerDelegate {
    func dismissed() {
        print("ViewController Dismissed ")
    }
}
