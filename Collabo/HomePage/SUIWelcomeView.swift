//
//  SUIWelcomeView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 16.01.24.
//

import SwiftUI

struct SUIWelcomeView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel = WelcomeViewModel()
    
    // MARK: - Body
    
    var body: some View {
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
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Preview

#Preview {
    SUIWelcomeView()
}
