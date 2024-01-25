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
