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
    private var cancellables = Set<AnyCancellable>()
    
    
    
    lazy var someTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter OAuth Token"
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Project Title"
        textField.textAlignment = .center
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
    }
    
    func setupUI() {
        view.addSubview(someTextLabel)
        view.addSubview(codeTextField)
        view.addSubview(taskTextField)
        
        NSLayoutConstraint.activate([
            someTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            someTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.topAnchor.constraint(equalTo: someTextLabel.bottomAnchor, constant: 20.0),
            codeTextField.widthAnchor.constraint(equalToConstant: 200.0),
            
            taskTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTextField.topAnchor.constraint(equalTo: codeTextField.topAnchor, constant: -100.0),
            taskTextField.widthAnchor.constraint(equalToConstant: 200.0),
        ])
        
        let fetchDataButton = UIButton(type: .system)
        fetchDataButton.translatesAutoresizingMaskIntoConstraints = false
        fetchDataButton.setTitle("Fetch Data", for: .normal)
        fetchDataButton.addTarget(self, action: #selector(fetchData(_:)), for: .touchUpInside)
        view.addSubview(fetchDataButton)
        
        NSLayoutConstraint.activate([
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchDataButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20.0),
        ])
        
        let addTaskButton = UIButton(type: .system)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setTitle("Add Project", for: .normal)
        addTaskButton.addTarget(self, action: #selector(addProject(_:)), for: .touchUpInside)
        view.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.topAnchor.constraint(equalTo: someTextLabel.topAnchor, constant: -30.0),
        ])
    }
    
    func bindViewModel() {
        viewModel.$projects.receive(on: DispatchQueue.main).sink { [weak self] projects in
            self?.someTextLabel.text = projects.first?.name
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
        let taskName = taskTextField.text ?? ""
        viewModel.addProjectToAsana(name: taskName)
    }
}




