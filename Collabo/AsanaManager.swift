//
//  AsanaManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 24.01.24.
//

import Foundation


public class AsanaManager {
    var token: String
    let clientId = "1206344666310503"
    let clientSecret = "385e60c477ccf676ef2759b209126404"
    let workspaceGID = "1206421146222686"
    let projectGID = ""
    
    static let shared = AsanaManager()
    
    private init() {
        token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }
    
    public func getAccessToken(authorizationCode: String) async throws {
        let tokenEndpoint = "https://app.asana.com/-/oauth_token"
        
        let parameters: [String: Any] = [
            "grant_type": "authorization_code",
            "code": authorizationCode,
            "client_id": clientId,
            "client_secret": clientSecret,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
        ]
        
        guard let url = URL(string: tokenEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let accessToken = json?["access_token"] as? String {
                token = accessToken
                UserDefaultsManager.shared.saveAccessToken(accessToken)
                try await fetchProjects()
            } else {
                throw NetworkError.invalidResponse
            }
        } catch {
            throw error
        }
    }
    
    func refreshAccessToken() async throws {
        let tokenEndpoint = "https://app.asana.com/-/oauth_revoke"
        
        guard let url = URL(string: tokenEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=refresh_token&client_id=\(clientId)&client_secret=\(clientSecret)&token=\(token)"
        request.httpBody = body.data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let accessToken = json?["access_token"] as? String else {
                throw NetworkError.decodingError
            }
            
            UserDefaultsManager.shared.saveAccessToken(accessToken)
        } catch {
            throw error
        }
    }
    
    public func fetchProjects() async throws -> [AsanaProject] {
        let baseApiEndpoint = "https://app.asana.com/api/1.0"
        let apiEndpoint = "\(baseApiEndpoint)/workspaces/\(workspaceGID)/projects"
        
        let tokenValue = token != "" ? token : UserDefaultsManager.shared.retrieveAsanaAccessToken()
        guard let token = tokenValue else {
            throw NetworkError.missingToken
        }
        
        guard let url = URL(string: apiEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let projects = try decoder.decode(AsanaProjectsResponse.self, from: data)
            print("Parsed Data: \(projects.data)")
            return projects.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addProjectToAsana(name: String) async throws {
        let url = URL(string: "https://app.asana.com/api/1.0/projects")!
        let parameters: [String: Any] = [
            "data": [
                "name": name,
                "workspace": "\(workspaceGID)"
            ]
        ]
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        request.allHTTPHeaderFields = headers
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            print("Request URL: \(url)")
            print("Request Headers: \(headers)")
            print("Request Body: \(parameters)")
        } catch {
            print("JSON Encoding Error: \(error)")
            throw NetworkError.jsonEncodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            let responseBody = String(data: data, encoding: .utf8) ?? "Could not decode response"
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Body: \(responseBody)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Server returned an error: \(responseBody)")
                throw NetworkError.invalidResponse
            }
        } catch {
            print("Network Request Error: \(error)")
            throw error
        }
        
    }
    
    func fetchTasks(forProject projectGID: String) async throws -> [AsanaTask] {
        let url = URL(string: "https://app.asana.com/api/1.0/projects/\(projectGID)/tasks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let tasksResponse = try decoder.decode(AsanaTasksResponse.self, from: data)
            return tasksResponse.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case missingToken
        case jsonEncodingError
    }
}
