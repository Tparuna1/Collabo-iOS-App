//
//  WelcomePageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

class WelcomeViewModel: ObservableObject {
    
    // MARK: - View Methods
    
    func welcomeQuote() -> some View {
        Text("Stay on Top of your Work")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
    }
    
    func welcomeImage() -> some View {
        return Image("CompletedTasksGrey")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .padding()
    }
    
    func welcomeText() -> some View {
        return Text("Start collaborating with Collabo")
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
}
