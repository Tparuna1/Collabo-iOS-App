//
//  UserTaskListModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 05.02.24.
//

import Foundation

// MARK: - DataClass
public struct UserTaskList: Codable {
    let gid: String
    let name: String
}

// MARK: - UserTaskList
public struct UserTaskListResponse: Codable {
    let data: [UserTaskList]
}
