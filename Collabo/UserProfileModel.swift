//
//  UserProfileModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 05.02.24.
//

import Foundation


// MARK: - UserProfile
struct UserProfile: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let gid: String?
    let resourceType: String?
    let name: String?
    let email: String?
    let photo: Photo?
    let workspaces: [Workspace]?
    
    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name, email, photo, workspaces
    }
}

// MARK: - Photo
struct Photo: Codable {
    let image36X36: String?
    let image60X60: String?
    let image128X128: String?
}

// MARK: - Workspace
struct Workspace: Codable {
    let gid, resourceType, name: String?
    
    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name
    }
}
