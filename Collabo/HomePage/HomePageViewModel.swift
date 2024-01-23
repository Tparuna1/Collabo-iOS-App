//
//  HomePageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import Foundation
import Alamofire
import OAuthSwift

class HomeViewModel {
    
    var projects = Bindable<[Project]>()
    
    func fetchData(oauthToken: String) {
        if let token = retrieveAccessTokenFromUserDefaults() {
            fetchProjects(token: token)
        } else {
            exchangeAuthorizationCodeForToken(authorizationCode: oauthToken)
        }
    }
    
    private func retrieveAccessTokenFromUserDefaults() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private func exchangeAuthorizationCodeForToken(authorizationCode: String) {
        let tokenEndpoint = "https://app.asana.com/-/oauth_token"
        let clientID = "1206344666310503"
        let clientSecret = "385e60c477ccf676ef2759b209126404"
        
        let parameters: [String: Any] = [
            "grant_type": "authorization_code",
            "code": authorizationCode,
            "client_id": clientID,
            "client_secret": clientSecret,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob"
        ]
        
        AF.request(tokenEndpoint, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let value):
                    if let accessToken = (value as? [String: Any])?["access_token"] as? String {
                        self.saveAccessTokenToUserDefaults(token: accessToken)
                        self.fetchProjects(token: accessToken)
                    } else {
                        print("Failed to extract access token from the response.")
                    }
                case .failure(let error):
                    print("Token Exchange Error: \(error.localizedDescription)")
                }
            }
    }
    
    private func saveAccessTokenToUserDefaults(token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    func fetchProjects(token: String) {
        let apiEndpoint = "https://app.asana.com/api/1.0/projects"
        let oauthToken = token
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(oauthToken)"
        ]
        
        let parameters: [String: Any] = ["project": 538986955234806]
        
        AF.request(apiEndpoint, method: .get, headers: headers)
            .responseDecodable(of: ProjectsResponse.self) { [weak self] response in
                switch response.result {
                case .success(let projectsResponse):
                    self?.projects.value = projectsResponse.data
                case .failure(let error):
                    print("Error fetching projects: \(error.localizedDescription)")
                }
            }
    }
}

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    private var observer: ((T?) -> Void)?
    
    func bind(observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}
