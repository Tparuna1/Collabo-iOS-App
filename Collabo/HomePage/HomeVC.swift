//
//  HomeVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Combine


class HomeVC: UIViewController {
    
    var viewModel = HomeViewModel()
    var selectedProjectGID: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter OAuth Token"
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var fetchDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch Data", for: .normal)
        button.addTarget(self, action: #selector(fetchData(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        return tableView
    }()
    
    lazy var addProjectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addProject(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        tableView.register(CustomProjectCell.self, forCellReuseIdentifier: "CustomProjectCell")
        bindViewModel()
    }
    
    func setupUI() {
        let tableViewWrapper = UIView()
        tableViewWrapper.translatesAutoresizingMaskIntoConstraints = false
        tableViewWrapper.backgroundColor = .clear
        
        view.addSubview(codeTextField)
        view.addSubview(fetchDataButton)
        view.addSubview(tableViewWrapper)
        view.addSubview(addProjectButton)
        
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 200),
            
            fetchDataButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableViewWrapper.topAnchor.constraint(equalTo: fetchDataButton.bottomAnchor, constant: 20),
            tableViewWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableViewWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableViewWrapper.bottomAnchor.constraint(equalTo: addProjectButton.topAnchor, constant: -20),
            
            addProjectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addProjectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addProjectButton.widthAnchor.constraint(equalToConstant: 50),
            addProjectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        tableViewWrapper.layer.cornerRadius = 10
        tableViewWrapper.layer.borderWidth = 1.0
        tableViewWrapper.layer.borderColor = UIColor.systemBlue.cgColor
        tableViewWrapper.clipsToBounds = true
        
        tableViewWrapper.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewWrapper.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewWrapper.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewWrapper.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewWrapper.bottomAnchor),
        ])
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear 
    }
    
    func bindViewModel() {
        viewModel.$projects.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.$errorMessage.receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
            if let message = errorMessage {
                print("Error: \(message)")
            }
        }.store(in: &cancellables)
    }
    
    @objc func fetchData(_ sender: UIButton) {
        let authorizationCode = codeTextField.text ?? ""
        viewModel.getAccessToken(authorizationCode: authorizationCode)
    }
    
    @objc func addProject(_ sender: UIButton) {
        print("Add Project button tapped")
        let newProjectVC = NewProjectVC()
        newProjectVC.modalPresentationStyle = .custom
        newProjectVC.transitioningDelegate = self
        present(newProjectVC, animated: true, completion: nil)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomProjectCell", for: indexPath) as! CustomProjectCell
        let project = viewModel.projects[indexPath.row]
        
        cell.setProjectIcon(UIImage(named: "list_alt"))
        cell.setProjectName(project.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width - 30, height: 20))
        headerLabel.text = "Projects"
        headerLabel.textColor = .systemBlue
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProjectGID = viewModel.projects[indexPath.row].gid
        let projectTasksVC = ProjectTasksVC()
        projectTasksVC.projectTasksViewModel.projectGID = selectedProjectGID
        navigationController?.pushViewController(projectTasksVC, animated: true)
    }
}

extension HomeVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


    
