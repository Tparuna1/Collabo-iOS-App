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
    let followers: [Follower]
    let memberships: [Membership]
    // Add more properties as needed

    enum CodingKeys: String, CodingKey {
        case gid
        case name
        case notes
        case createdAt = "created_at"
        case completed
        case followers
        case memberships = "tasks" // Adjust if the key differs
        // Add more keys as needed
    }
}

struct Follower: Codable {
    let gid: String
    let name: String
    let resourceType: String

    enum CodingKeys: String, CodingKey {
        case gid
        case name
        case resourceType = "resource_type"
    }
}

struct Membership: Codable {
    let project: Project
    let section: Section

    enum CodingKeys: String, CodingKey {
        case project
        case section
    }
}

struct Project: Codable {
    let gid: String
    let name: String
    let resourceType: String

    enum CodingKeys: String, CodingKey {
        case gid
        case name
        case resourceType = "resource_type"
    }
}

struct Section: Codable {
    let gid: String
    let name: String
    let resourceType: String

    enum CodingKeys: String, CodingKey {
        case gid
        case name
        case resourceType = "resource_type"
    }
}

struct SingleAsanaTaskResponse: Codable {
    let data: SingleAsanaTask
}
