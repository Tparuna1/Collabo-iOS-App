//
//  ToDoManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 21.03.24.
//

import SwiftUI

//MARK: - TodoManager Class

final class TodoManager {
    static let shared = TodoManager()
    
    private var tasksByDate: [Date: [Todo]] = [:]
    
    init() {
        loadFromUserDefaults()
    }
    
    func loadSavedTasks(for date: Date) -> [Todo] {
        return tasksByDate[date] ?? []
    }
    
    func saveTasks(_ tasks: [Todo], for date: Date) {
        tasksByDate[date] = tasks
        updateUserDefaults()
    }
    
    private func updateUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(tasksByDate) {
            UserDefaults.standard.set(encodedData, forKey: "tasksByDate")
        } else {
            print("Failed to encode tasksByDate.")
        }
    }
    
    private func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "tasksByDate") {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([Date: [Todo]].self, from: savedData) {
                tasksByDate = decodedData
            }
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




