//
//  HomePageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import Foundation


class HomeViewModel {
    private var asanaManager = AsanaManager.shared
    @Published var projects: [AsanaProject] = []
    @Published var errorMessage: String?

    func getAccessToken(authorizationCode: String) {
        Task {
            do {
                try await asanaManager.getAccessToken(authorizationCode: authorizationCode)
                fetchProjects()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchProjects() {
        Task {
            do {
                self.projects = try await asanaManager.fetchProjects()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addProjectToAsana(name: String) {
        Task {
            do {
                try await asanaManager.addProjectToAsana(name: name)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
