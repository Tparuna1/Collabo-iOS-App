//
//  TaskRowView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

//MARK: - TaskRowView
struct TaskRowView: View {
    
    // MARK: - Properties
    @Binding var task: Todo
    @Binding var toDos: [Todo]
    @State private var offset: CGFloat = 0
    var currentDate: Date
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // MARK: - Task Completion Indicator
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .blue.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                                updateStorage()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 100 {
                            offset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if value.translation.width > 50 {
                            deleteTask(for: currentDate)
                        } else {
                            withAnimation {
                                offset = 50
                            }
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
            .transition(.move(edge: .leading))
        }
    }
    
    // MARK: - Indicator Color Logic
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
    
    // MARK: - Delete Task Function
    private func deleteTask(for date: Date) {
        if let index = toDos.firstIndex(where: { $0.id == task.id }) {
            toDos.remove(at: index)
            TodoManager.shared.saveTasks(toDos, for: date)
        }
    }
    
    // MARK: - Update Storage Function
    private func updateStorage() {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(toDos) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        } else {
            print("Failed to encode tasks.")
        }
    }
}


