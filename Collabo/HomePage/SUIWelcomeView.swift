//
//  SUIWelcomeView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct SUIWelcomeView: View {
    
    
    var body: some View {
        @ObservedObject var viewModel = WelcomeViewModel()
        
        NavigationStack {
            ZStack {
                AnimatedBackgroundView()
                VStack {
                    viewModel.welcomeQuote()
                    viewModel.welcomeImage()
                    viewModel.welcomeText()
                    NavigationLink(destination: SUILoginView()) {
                        PrimaryButtonComponentView(text: "Get Started")
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}



#Preview {
    SUIWelcomeView()
}
