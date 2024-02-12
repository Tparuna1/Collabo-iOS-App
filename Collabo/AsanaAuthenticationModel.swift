//
//  AsanaAuthenticationModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 02.02.24.
//

import Foundation

//MARK: - AsanaAuthenticationModel

public struct AsanaAuthenticationModel: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
