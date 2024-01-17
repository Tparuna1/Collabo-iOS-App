//
//  LoginPageViewModel.swift
//  Collabo
//
//  Created by tornike <parunashvili on 17.01.24.
//

import SwiftUI

class LoginPageViewModel: ObservableObject {
    
    func comeBackText() -> some View {
        Text("Let's Get Back to Work!")
            .font(.title)
            .foregroundColor(.white)
            .padding()
    }
    
    func LoginImage() -> some View {
        return Image("LogIn")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .padding()
    }
    
}
