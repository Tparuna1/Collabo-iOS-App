//
//  Task.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

struct Todo: Identifiable, Codable {
    var id: UUID = UUID()
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: Color

    enum CodingKeys: String, CodingKey {
        case id
        case taskTitle
        case creationDate
        case isCompleted
        case tint
    }

    init(taskTitle: String, creationDate: Date, isCompleted: Bool, tint: Color) {
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskTitle = try container.decode(String.self, forKey: .taskTitle)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)

        let tintData = try container.decode(Data.self, forKey: .tint)
        if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: tintData) {
            self.tint = Color(uiColor)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .tint, in: container, debugDescription: "Unable to decode tint color.")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskTitle, forKey: .taskTitle)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(isCompleted, forKey: .isCompleted)

        let uiColor = UIColor(tint)
        let tintData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(tintData, forKey: .tint)
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
