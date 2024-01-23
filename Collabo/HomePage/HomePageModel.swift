//
//  HomePageModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import Foundation

struct Project: Codable {
    let gid: String
    let name: String
}

struct ProjectsResponse: Codable {
    let data: [Project]
}

