//
//  AsanaManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 24.01.24.
//

import Foundation


public class AsanaManager {
    var token: String
    var refreshToken: String
    let clientId = "1206344666310503"
    let clientSecret = "385e60c477ccf676ef2759b209126404"
    let workspaceGID = "1206421146222686"
    var userTaskListGID = "1206421171234526"
    let projectGID = ""
    let taskGID = ""
    var userGID = ""
    
    static let shared = AsanaManager()
    
    
    private init() {
        token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
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
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data = try decoder.decode(AsanaAuthenticationModel.self, from: data)
                token = data.accessToken
                refreshToken = data.refreshToken
                UserDefaultsManager.shared.saveAccessToken(data.accessToken)
                UserDefaultsManager.shared.saveRefreshToken(data.refreshToken)
                
                userGID = try await getUserID()
                UserDefaultsManager.shared.saveUserGID(userGID)
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            switch error {
            case SpecificNetworkError.invalidURL:
                print("Invalid URL")
            case let SpecificNetworkError.invalidResponse(statusCode):
                print("Invalid Response (\(statusCode))")
            case SpecificNetworkError.decodingError:
                print("Decoding Error")
            case SpecificNetworkError.missingToken:
                print("Token is missing")
            case SpecificNetworkError.jsonEncodingError:
                print("JSON Encoding Error")
            case let SpecificNetworkError.otherError(message):
                print("Other Error: \(message)")
            default:
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func refreshAccessToken() async throws {
        let tokenEndpoint = "https://app.asana.com/-/oauth_revoke"
        
        let parameters: [String: Any] = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "token": refreshToken
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
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data = try decoder.decode(AsanaAuthenticationModel.self, from: data)
                UserDefaultsManager.shared.saveAccessToken(data.accessToken)
                UserDefaultsManager.shared.saveRefreshToken(data.refreshToken)
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw error
        }
    }
    
    public func getUserID() async throws -> String {
        let url = URL(string: "https://app.asana.com/api/1.0/users/me")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let responseBody = String(data: data, encoding: .utf8) ?? "Could not decode response"
            print("Raw Response:\n\(responseBody)")
            
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserProfile.self, from: data)
            
            if let userGID = user.data?.gid {
                return userGID
            } else {
                throw NetworkError.decodingError
            }
        } catch {
            throw error
        }
    }
    
    public func fetchProjects() async throws -> [AsanaProject] {
        do {
            return try await performFetchProjects()
        } catch NetworkError.invalidResponse {
            try await refreshAccessToken()
            return try await performFetchProjects()
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
    
    
    func deleteProject(projectGID: String) async throws {
        let url = URL(string: "https://app.asana.com/api/1.0/projects/\(projectGID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
    
    func fetchUserTasks() async throws -> [UserTaskList] {
        let url = URL(string: "https://app.asana.com/api/1.0/user_task_lists/\(userTaskListGID)/tasks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                if let httpResponse = response as? HTTPURLResponse {
                    throw SpecificNetworkError.invalidResponse(httpResponse.statusCode)
                } else {
                    throw SpecificNetworkError.invalidResponse(0)
                }
            }
            
            let responseBody = String(data: data, encoding: .utf8) ?? "Could not decode response"
            print("Raw Response:\n\(responseBody)")
            
            let decoder = JSONDecoder()
            let userTaskListsResponse = try decoder.decode(UserTaskListResponse.self, from: data)
            return userTaskListsResponse.data
        } catch let error as SpecificNetworkError {
            throw error
        } catch {
            let errorMessage = "An unknown error occurred: \(error.localizedDescription)"
            throw SpecificNetworkError.otherError(message: errorMessage)
        }
    }
    
    
    
    func fetchSingleTask(forTask taskGID: String) async throws -> TaskAsana {
        let url = URL(string: "https://app.asana.com/api/1.0/tasks/\(taskGID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let task = try decoder.decode(TaskAsana.self, from: data)
            print("Task fetched successfully")
            return task
        } catch {
            print("Networking error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func updateSingleTask(forTask taskGID: String, completed: Bool) async throws -> TaskAsana {
        let url = URL(string: "https://app.asana.com/api/1.0/tasks/\(taskGID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let updatedTaskData: [String: Any] = ["completed": completed]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: updatedTaskData, options: [])
            
            request.httpBody = requestData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let task = try decoder.decode(TaskAsana.self, from: data)
            print("Task updated successfully")
            return task
        } catch {
            print("Networking error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    
    func deleteSingleTask(forTask taskGID: String) async throws -> TaskAsana {
        let url = URL(string: "https://app.asana.com/api/1.0/tasks/\(taskGID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let task = try decoder.decode(TaskAsana.self, from: data)
            print("Task fetched successfully")
            return task
        } catch {
            print("Networking error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    
    func fetchSubtasks(forSubtask taskGID: String) async throws -> [Subtask] {
        let url = URL(string: "https://app.asana.com/api/1.0/tasks/\(taskGID)/subtasks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response:")
                print(jsonString)
            }
            
            let decoder = JSONDecoder()
            let tasksResponse = try decoder.decode(SubtaskResponse.self, from: data)
            return tasksResponse.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addSubtask(name: String) async throws {
        let url = URL(string: "https://app.asana.com/api/1.0/tasks/\(taskGID)/subtasks")!
        let parameters: [String: Any] = [
            "data": [
                "name": name,
                "gid": "\(taskGID)"
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
    
    func fetchUserInfo() async throws -> UserProfile {
        let url = URL(string: "https://app.asana.com/api/1.0/users/\(userGID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let userProfile = try decoder.decode(UserProfile.self, from: data)
            return userProfile
        } catch {
            throw error
        }
    }
    
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case missingToken
        case jsonEncodingError
        
    }
    
    enum SpecificNetworkError: Error {
        case invalidURL
        case invalidResponse(Int)
        case decodingError
        case missingToken
        case jsonEncodingError
        case otherError(message: String)
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse(let statusCode):
                return "Invalid Response (\(statusCode))"
            case .decodingError:
                return "Decoding Error"
            case .missingToken:
                return "Token is missing"
            case .jsonEncodingError:
                return "JSON Encoding Error"
            case .otherError(let message):
                return "Other Error: \(message)"
            }
        }
    }
    // MARK: - Private Methods
    
    private func performFetchProjects() async throws -> [AsanaProject] {
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
}
