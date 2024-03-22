//
//  CountDownView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 22.03.24.
//

import SwiftUI

struct CountDownView: View {
    
    @ObservedObject var viewModel = CountDownViewModel()
    
    var body: some View {
        ZStack {
            Color.customBackgroundColor.edgesIgnoringSafeArea(.all)
                .brightness(viewModel.showPickerSheet ? -0.1 : 0)
            Group {
                Button(action: { withAnimation { viewModel.displayPickerSheet() } }, label: { TimerView(progress: $viewModel.progress, duration: $viewModel.duration) })
                TimerActionView(viewModel: viewModel)
            }
            CountPickerView(viewModel: viewModel)
                .offset(x: 0, y: viewModel.showPickerSheet ? 0 : 1500)
            
        }
    }
}

struct BubbleView: View {
    let size: CGFloat, x: CGFloat, y: CGFloat
    var body: some View {
        ZStack {
            Circle().foregroundColor(Color.taskColor2)
                .frame(width: size, height: size).offset(x: x, y: y)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView()
    }
}


