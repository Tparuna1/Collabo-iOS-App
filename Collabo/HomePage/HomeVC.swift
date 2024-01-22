//
//  HomeVC.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import UIKit
import Alamofire
import OAuthSwift

class HomeVC: UIViewController, UITableViewDataSource {
    
    var viewModel = HomeViewModel()
    
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter OAuth Token"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var fetchDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch Data", for: .normal)
        button.addTarget(self, action: #selector(fetchData(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var projectsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(codeTextField)
        view.addSubview(fetchDataButton)
        view.addSubview(projectsTableView)
        
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 200.0),
            
            fetchDataButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            projectsTableView.topAnchor.constraint(equalTo: fetchDataButton.bottomAnchor, constant: 20),
            projectsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            projectsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.projects.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.projectsTableView.reloadData()
            }
        }
    }
    
    @objc func fetchData(_ sender: UIButton) {
        guard let oauthToken = codeTextField.text, !oauthToken.isEmpty else {
            return
        }
        viewModel.fetchData(oauthToken: oauthToken)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projects.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        if let project = viewModel.projects.value?[indexPath.row] {
            cell.textLabel?.text = project.name
        }
        return cell
    }
}





