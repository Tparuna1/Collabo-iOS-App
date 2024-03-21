//
//  TaskDetailsViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 30.01.24.
//


import UIKit
import Combine

//MARK: - Protocols

public protocol TaskDetailsDelegate: AnyObject {
    func deleted()
}

public final class TaskDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: DefaultTaskDetailsViewModel!
    var navigator: TaskDetailsNavigator!
    
    weak var delegate: TaskDetailsDelegate?
    
    private var subtask = [Subtask]()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    private let navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMoreOptions))
        return button
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
        label.textColor = .black
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
    
    private lazy var dueOnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(calendarImageView)
        stackView.addArrangedSubview(dueOnLabel)
        return stackView
    }()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dueOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
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
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 6
        button.addTarget(self, action: #selector(addSubtask(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupNavigationBarItems()
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
            delegate?.deleted()
            navigator.navigate(to: .close, animated: true)
        }
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupStackview()
        setupTableView()
        setupAddSubtaskButton()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupStackview() {
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
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
        ])
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "SubtaskCell")
        tableView.dataSource = self
        tableView.rowHeight = 70
    }
    
    private func setupAddSubtaskButton() {
        view.addSubview(addSubtaskButton)

        NSLayoutConstraint.activate([
            addSubtaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addSubtaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addSubtaskButton.widthAnchor.constraint(equalToConstant: 140),
            addSubtaskButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupNavigationBarItems() {
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    //MARK: - Button Actions
    
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
            popoverController.barButtonItem = moreBarButtonItem
        }
        
        present(alertController, animated: true, completion: nil)
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
                    checkmarkImageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                }
                
                viewModel.task = task
                viewModel.updateSingleTask()
            }
        }
    }
    
    @objc func addSubtask(_ sender: UIButton) {
        print("Add Subtask button tapped")
        viewModel.newSubtask()
    }
    
    func handleDeleteTask() {
        viewModel.deleteTask()
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
                checkmarkImageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
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
        
        let colors: [UIColor] = [.taskColor4]
        let colorIndex = indexPath.row % colors.count
        
        cell.setup(with: .init(title: subtask.name, color: colors[colorIndex]))
        
        return cell
    }
}

// MARK: - Delegate Extensions

extension TaskDetailsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension TaskDetailsViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension TaskDetailsViewController: AddSubtaskViewControllerDelegate {
    func dismissed() {
    }
}

