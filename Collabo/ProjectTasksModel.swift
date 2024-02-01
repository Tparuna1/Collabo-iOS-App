//
//  ProjectTasksModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 23.01.24.
//

import Foundation


public struct AsanaProject: Codable {
    public let gid: String
    public let name: String
}

public struct AsanaProjectsResponse: Codable {
    public let data: [AsanaProject]
}

struct AsanaTask: Codable {
    let gid: String
    let name: String
}

struct AsanaTasksResponse: Codable {
    let data: [AsanaTask]
}

struct TaskAsana: Codable {
    let data: SingleAsanaTask
}

struct SingleAsanaTask: Codable {
    let gid: String
    let name: String
}

struct SingleAsanaTaskResponse: Codable {
    let data: SingleAsanaTask
}


struct AsanaUser: Codable {
    //  let gid: String
    let resourceType: String
    let name: String
}

struct AsanaDependency: Codable {
   // let gid: String
    let resourceType: String
}

struct AsanaExternal: Codable {
   // let gid: String
    let data: String
}

struct AsanaHeart: Codable {
  //  let gid: String
    let user: AsanaUser
}

struct AsanaLike: Codable {
   // let gid: String
    let user: AsanaUser
}

struct AsanaMembership: Codable {
    let project: AsanaProject
    let section: AsanaSection
}

struct AsanaSection: Codable {
   // let gid: String
    let resourceType: String
    let name: String
}

struct AsanaCustomField: Codable {
   // let gid: String
    let resourceType: String
    let name: String
    let resourceSubtype: String
    let type: String
    let enumOptions: [AsanaEnumOption]?
    let enabled: Bool
    let isFormulaField: Bool
    let dateValue: AsanaDateValue?
    let enumValue: AsanaEnumOption?
    let multiEnumValues: [AsanaEnumOption]?
    let numberValue: Double?
    let textValue: String?
    let displayValue: String?
    let description: String?
    let precision: Int?
    let format: String?
    let currencyCode: String?
    let customLabel: String?
    let customLabelPosition: String?
    let isGlobalToWorkspace: Bool
    let hasNotificationsEnabled: Bool
    let asanaCreatedField: String?
    let isValueReadOnly: Bool
    let createdBy: AsanaUser?
    let peopleValue: [AsanaUser]?
}

struct AsanaEnumOption: Codable {
   // let gid: String
    let resourceType: String
    let name: String
    let enabled: Bool
    let color: String?
}

struct AsanaDateValue: Codable {
    let date: String
    let dateTime: String
}

struct AsanaTag: Codable {
  //  let gid: String
    let name: String
}

struct AsanaWorkspace: Codable {
}
