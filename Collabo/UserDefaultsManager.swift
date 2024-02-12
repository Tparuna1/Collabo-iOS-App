//
//  UserDefaultsManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 24.01.24.
//

import Foundation

// MARK: - User Defaults Manager

public class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    public func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    public func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "refreshToken")
    }
    
    public func retrieveAsanaAccessToken() -> String? {
        UserDefaults.standard.string(forKey: "accessToken")
    }
    
    public func saveUserGID(_ userGID: String) {
        UserDefaults.standard.set(userGID, forKey: "userGID")
    }
}
