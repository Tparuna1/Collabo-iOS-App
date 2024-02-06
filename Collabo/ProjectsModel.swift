//
//  ProjectsModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import Foundation

// MARK: - AsanaProject

public struct AsanaProject: Codable {
    public let gid: String
    public let name: String
}

// MARK: - AsanaProjectResponse

public struct AsanaProjectsResponse: Codable {
    public let data: [AsanaProject]
}
