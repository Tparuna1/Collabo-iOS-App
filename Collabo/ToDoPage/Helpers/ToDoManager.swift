//
//  ToDoManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 21.03.24.
//

import SwiftUI

class TodoManager {
    static let shared = TodoManager()
    
    func loadSavedTasks() -> [Todo] {
        var savedTasks: [Todo] = []
        if let savedTasksData = UserDefaults.standard.data(forKey: "tasks") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode([Todo].self, from: savedTasksData) {
                savedTasks = decodedTasks
            }
        }
        return savedTasks
    }
    
    func saveTasks(_ tasks: [Todo]) {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        } else {
            print("Failed to encode tasks.")
        }
    }
    
    func initializeWeekSlider() -> [[Date.WeekDay]] {
        var weekSlider: [[Date.WeekDay]] = []
        
        let currentWeek = Date().fetchWeek()
        
        if let firstDate = currentWeek.first?.date {
            weekSlider.append(firstDate.createPreviousWeek())
        }
        
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
            weekSlider.append(lastDate.createNextWeek())
        }
        
        return weekSlider
    }
}




