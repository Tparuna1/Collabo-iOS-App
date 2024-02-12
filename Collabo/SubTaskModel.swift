//
//  SubTaskModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//

import Foundation

// MARK: - SubtaskModel
public struct Subtask: Codable {
    let gid: String
    let name: String
}

// MARK: - SubtaskResponse

public struct SubtaskResponse: Codable {
    let data: [Subtask]
}

