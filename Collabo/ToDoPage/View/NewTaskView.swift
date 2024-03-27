//
//  NewTaskView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

struct NewTaskView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle: String = ""
    @State private var taskTime: Date
    @State private var taskColor: Color = .taskColor1
    @Binding var tasks: [Todo]
    private var selectedDate: Date
    
    // MARK: - Initialization
    
    init(tasks: Binding<[Todo]>, selectedDate: Date) {
        self._tasks = tasks
        self.selectedDate = selectedDate
        _taskTime = State(initialValue: selectedDate)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Your Task Here!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, content: {
                    Text("Task Time")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                        .frame(width: 70)
                })
                
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    let colors: [Color] = [.taskColor1, .taskColor2, .taskColor3, .taskColor4, .taskColor5]
                    
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                                .background(content: {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                })
                
            }
            .padding(.top, 5)
            
            Spacer(minLength: 0)
            
            Button(action: {
                createTask()
            }) {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(taskColor, in: .rect(cornerRadius: 10))
            }
            .disabled(taskTitle.isEmpty)
            .opacity(taskTitle.isEmpty ? 0.5 : 1)
        })
        .padding(15)
    }
    
    // MARK: - Methods
    
    func createTask() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: taskTime)
        let minute = calendar.component(.minute, from: taskTime)
        let dateWithSelectedTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDate)!
        
        let newTask = Todo(taskTitle: taskTitle, creationDate: dateWithSelectedTime, isCompleted: false, tint: taskColor)
        tasks.append(newTask)
        
        TodoManager.shared.saveTasks(tasks, for: selectedDate)
        dismiss()
    }
}


