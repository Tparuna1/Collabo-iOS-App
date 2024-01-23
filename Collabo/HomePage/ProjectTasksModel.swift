//
//  ProjectTasksModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation

struct Task: Codable {
    let gid: String
    let name: String
}


struct TasksResponse: Codable {
    let data: [Task]
}
