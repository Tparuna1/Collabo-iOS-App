//
//  ProjectTasksModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation


struct AsanaTask: Codable {
    let gid: String
    let name: String
}

struct AsanaTasksResponse: Codable {
    let data: [AsanaTask] 
}

struct SingleAsanaTask: Codable {
    let gid: String
    let name: String
    let notes: String?
    let createdAt: String
    let completed: Bool
    let subtasks: [SingleAsanaTask]
    enum CodingKeys: String, CodingKey {
        case gid
        case name
        case notes
        case createdAt = "created_at"
        case completed
        case subtasks = "tasks"
    }
}
