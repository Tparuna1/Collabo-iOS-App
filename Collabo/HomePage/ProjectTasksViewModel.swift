//
//  ProjectTasksViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation

import Alamofire

class ProjectTasksViewModel {
    var projectId: String?
    var tasks = Bindable<[Task]>()

    func fetchTasks() {
        guard let projectId = projectId else {
            print("Project ID is nil")
            return
        }

        let apiEndpoint = "https://app.asana.com/api/1.0/projects/\(projectId)/tasks"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDYwMDMyOTgsInNjb3BlIjoiZGVmYXVsdCBpZGVudGl0eSIsInN1YiI6NTM4OTUzNzI2NzQ4MzcwLCJyZWZyZXNoX3Rva2VuIjoxMjA2NDE3NDMwOTk2NjI1LCJ2ZXJzaW9uIjoyLCJhcHAiOjEyMDYzNDQ2NjYzMTA1MDMsImV4cCI6MTcwNjAwNjg5OH0.euHej418Xrk6LQpk9KYkAvg7nhzpNEHNILS8wRprjxM"
        ]

        AF.request(apiEndpoint, method: .get, headers: headers)
            .responseDecodable(of: TasksResponse.self) { [weak self] response in
                switch response.result {
                    case .success(let tasksResponse):
                        self?.tasks.value = tasksResponse.data
                    case .failure(let error):
                        print("Error fetching tasks: \(error.localizedDescription)")
                }
            }
    }
}
