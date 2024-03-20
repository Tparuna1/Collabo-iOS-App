//
//  ProjectTasksViewController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import UIKit
import Combine

public protocol ProjecTasksDelegate: AnyObject {
    func deleted()
}

public final class ProjectTasksViewController: UIViewController {

    // MARK: - Properties

    var viewModel: DefaultProjectTasksViewModel!
    var navigator: ProjectTasksNavigator!
    var taskDetailsNavigator: TaskDetailsNavigator!
    
    weak var delegate: ProjecTasksDelegate?
    
    private var tasks = [AsanaTask]()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - UI Elements
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMoreOptions))
        return button
    }()
    
    private lazy var progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.102, green: 0.1765, blue: 0.2588, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circularProgressView: CircularProgressView = {
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 70, height: 70), lineWidth: 10, rounded: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressColor = .green
        progressView.trackColor = .white
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Project Progress"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "Additional Text"
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

    private lazy var addTask: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ Add Task", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 6
        button.addTarget(self, action: #selector(addTask(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupNavigationBarItems()
        setupUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        view.applyCustomBackgroundColor()
    }

    // MARK: - View Model Binding

    private func bind(to viewModel: ProjectTasksViewModel) {
        viewModel.action.sink { [weak self] action in self?.didReceive(action: action) }.store(in: &cancellables)
        viewModel.route.sink { [weak self] route in self?.didReceive(route: route) }.store(in: &cancellables)
    }

    private func didReceive(action: ProjectTasksViewModelOutputAction) {
        switch action {
        case .title(let title):
            self.navigationItem.title = title
        case .tasks(let tasks):
            self.tasks = tasks
            tableView.reloadData()
            let additionalLabelText = viewModel.updateProgress()
            self.additionalLabel.text = additionalLabelText
            let progress = viewModel.calculateProgress()
            self.circularProgressView.setProgress(duration: 0.5, to: progress)
        }
    }

    private func didReceive(route: ProjectTasksViewModelRoute) {
        switch route {
        case .details(let params):
            navigator.navigate(to: .details(params), animated: true)
        case .projectDeleted:
            delegate?.deleted()
            navigator.navigate(to: .close, animated: true)
        case .newTask:
            navigator.navigate(to: .newTask, animated: true)
        }
    }

    // MARK: - UI Setup
    
    func setupUI() {
        setupProgressView()
        setupAddTaskButton()
        setupTableView()
        self.view.bringSubviewToFront(addTask)
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupProgressView() {
        view.addSubview(progressContainer)
        progressContainer.addSubview(circularProgressView)
        progressContainer.addSubview(progressLabel)
        progressContainer.addSubview(additionalLabel)

        NSLayoutConstraint.activate([
            progressContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressContainer.heightAnchor.constraint(equalToConstant: 120),
            
            progressLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 15),
            progressLabel.topAnchor.constraint(equalTo: progressContainer.topAnchor, constant: 20),
            
            additionalLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
            additionalLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 15),
            additionalLabel.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -200),

            circularProgressView.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -90),
            circularProgressView.topAnchor.constraint(equalTo: progressContainer.topAnchor, constant: 25)
        ])
    }

    private func setupTableView() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),

            wrapperView.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 20),
            wrapperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            wrapperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupAddTaskButton() {
        view.addSubview(addTask)
        
        NSLayoutConstraint.activate([
            addTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addTask.widthAnchor.constraint(equalToConstant: 140),
            addTask.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupNavigationBarItems() {
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func showMoreOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete Project", style: .destructive) { [weak self] _ in
            self?.handleDeleteProject()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = moreBarButtonItem
        }


        present(alertController, animated: true, completion: nil)
    }

    func handleDeleteProject() {
        viewModel.deleteProject()
    }

    @objc func addTask(_ sender: UIButton) {
        viewModel.newTask()
    }
}

// MARK: - UITableViewDataSource

extension ProjectTasksViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else {
            return .init()
        }
        let task = tasks[indexPath.row]

        let colors: [UIColor] = [.taskColor2]
        let colorIndex = indexPath.row % colors.count

        cell.setup(with: .init(title: task.name, color: colors[colorIndex]))

        return cell
    }
}

// MARK: - Delegate Extensions

extension ProjectTasksViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}

extension ProjectTasksViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ProjectTasksViewController: AddTaskViewControllerDelegate {
    func dismissed() {
        viewModel.fetchTasks()
    }
}

extension ProjectTasksViewController: TaskDetailsDelegate {
    public func deleted() {
        viewModel.fetchTasks()
    }
}
