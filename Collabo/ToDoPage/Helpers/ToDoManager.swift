//
//  ToDoManager.swift
//  Collabo
//
//  Created by tornike <parunashvili on 21.03.24.
//

import SwiftUI
import UserNotifications

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
        scheduleNotifications(for: tasks)
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
    
    private func scheduleNotifications(for tasks: [Todo]) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                for task in tasks {
                    let content = UNMutableNotificationContent()
                    content.title = "Todo: \(task.taskTitle)"
                    content.sound = .default
                    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.creationDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}





