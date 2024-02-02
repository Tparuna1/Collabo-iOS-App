//
//  TaskAsanaMode.swift
//  Collabo
//
//  Created by tornike <parunashvili on 02.02.24.
//



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
public struct TaskAsana: Codable {
    let data: SingleAsanaTask?
}

// MARK: - DataClass
public struct SingleAsanaTask: Codable {
    let gid: String?
    let name: String?
    let createdBy: CreatedBy?
    let assigneeStatus: String?
    let completed: Bool?
    let completedAt: String?
    let completedBy: Assignee?
    let createdAt: String?
    let dueAt, dueOn: String?
    let notes: String?
    let startAt, startOn: String?
    let actualTimeMinutes: Int?
    let assignee, assigneeSection: Assignee?
    let customFields: [CustomField]?
    let followers: [Assignee]?
    let parent: Parent?
    let projects: [Assignee]?
    let tags: [Tag]?
    let workspace: Assignee?
    let permalinkURL: String?
}

// MARK: - Assignee
struct Assignee: Codable {
    let gid: String?
    let resourceType: ResourceType?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name
    }
}

enum ResourceType: String, Codable {
    case task = "task"
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let gid, resourceType: String?

    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
    }
}

// MARK: - CustomField
struct CustomField: Codable {
    let gid: String?
    let resourceType: ResourceType?
    let name, resourceSubtype, type: String?
    let enumOptions: [EnumValue]?
    let enabled, isFormulaField: Bool?
    let dateValue: DateValue?
    let enumValue: EnumValue?
    let multiEnumValues: [EnumValue]?
    let numberValue: Double?
    let textValue, displayValue, description: String?
    let precision: Int?
    let format, currencyCode, customLabel, customLabelPosition: String?
    let isGlobalToWorkspace, hasNotificationsEnabled: Bool?
    let asanaCreatedField: String?
    let isValueReadOnly: Bool?
    let createdBy: Assignee?
    let peopleValue: [Assignee]?

    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name
        case resourceSubtype = "resource_subtype"
        case type
        case enumOptions = "enum_options"
        case enabled
        case isFormulaField = "is_formula_field"
        case dateValue = "date_value"
        case enumValue = "enum_value"
        case multiEnumValues = "multi_enum_values"
        case numberValue = "number_value"
        case textValue = "text_value"
        case displayValue = "display_value"
        case description, precision, format
        case currencyCode = "currency_code"
        case customLabel = "custom_label"
        case customLabelPosition = "custom_label_position"
        case isGlobalToWorkspace = "is_global_to_workspace"
        case hasNotificationsEnabled = "has_notifications_enabled"
        case asanaCreatedField = "asana_created_field"
        case isValueReadOnly = "is_value_read_only"
        case createdBy = "created_by"
        case peopleValue = "people_value"
    }
}

// MARK: - DateValue
struct DateValue: Codable {
    let date, dateTime: String?

    enum CodingKeys: String, CodingKey {
        case date
        case dateTime = "date_time"
    }
}

// MARK: - EnumValue
struct EnumValue: Codable {
    let gid: String?
    let resourceType: ResourceType?
    let name: String?
    let enabled: Bool?
    let color: String?

    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name, enabled, color
    }
}

// MARK: - External
struct External: Codable {
    let gid, data: String?
}

// MARK: - Heart
struct Heart: Codable {
    let gid: String?
    let user: Assignee?
}

// MARK: - Membership
struct Membership: Codable {
    let project, section: Assignee?
}

// MARK: - Parent
struct Parent: Codable {
    let gid: String?
    let resourceType: ResourceType?
    let name, resourceSubtype: String?
    let createdBy: CreatedBy?

    enum CodingKeys: String, CodingKey {
        case gid
        case resourceType = "resource_type"
        case name
        case resourceSubtype = "resource_subtype"
        case createdBy = "created_by"
    }
}

// MARK: - Tag
struct Tag: Codable {
    let gid, name: String?
}
