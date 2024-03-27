//
//  CountDownView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 22.03.24.
//

import SwiftUI
import UserNotifications

//MARK: - CountDownView

struct CountDownView: View {

    @ObservedObject var viewModel = CountDownViewModel()

    init() {
        viewModel.notificationHandler = {
        }
    }

    var body: some View {
        ZStack {
            BackgroundAnimation()
                .edgesIgnoringSafeArea(.all)
                .brightness(viewModel.showPickerSheet ? -0.1 : 0)

            Group {
                Button(action: { withAnimation { viewModel.displayPickerSheet() } }, label: { TimerView(progress: $viewModel.progress, duration: $viewModel.duration) })
                TimerActionView(viewModel: viewModel)
            }
            CountPickerView(viewModel: viewModel)
                .offset(x: 0, y: viewModel.showPickerSheet ? 0 : 1500)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                if success {
                } else if error != nil {
                }
            }

            NotificationCenter.default.addObserver(forName: .timerFinished, object: nil, queue: .main) { _ in
                viewModel.handleTimerFinishedNotification()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView()
    }
}



