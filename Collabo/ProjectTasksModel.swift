//
//  ProjectTasksModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation



// MARK: - AsanaTask

public struct AsanaTask: Codable {
    let gid: String
    let name: String
    let completed: Bool
}

// MARK: - AsanaTaskResponse

struct AsanaTasksResponse: Codable {
    let data: [AsanaTask]
}

