//
//  Task.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

import SwiftUI

struct Todo: Identifiable, Encodable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
    
    enum CodingKeys: String, CodingKey {
        case id
        case taskTitle
        case creationDate
        case isCompleted
        case tint
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskTitle, forKey: .taskTitle)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        let tintData = try NSKeyedArchiver.archivedData(withRootObject: tint, requiringSecureCoding: false)
        try container.encode(tintData, forKey: .tint)
    }
}

var sampleTasks: [Todo] = [
    .init(taskTitle: "Record Video", creationDate: .updateHour(-1), isCompleted: true, tint: .taskColor1),
    .init(taskTitle: "Redesign Website", creationDate: .updateHour(9), tint: .taskColor2),
    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(10), tint: .taskColor3),
    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), tint: .taskColor4),
    .init(taskTitle: "Publish Video", creationDate: .updateHour(2), tint: .taskColor1),
    .init(taskTitle: "Tweet about new Video!", creationDate: .updateHour(12), tint: .taskColor5),
]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
