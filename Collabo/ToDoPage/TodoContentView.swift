//
//  ContentView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

struct TodoContentView: View {
    var body: some View {
        TodoView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.BG)
            .preferredColorScheme(.light)
    }
}
