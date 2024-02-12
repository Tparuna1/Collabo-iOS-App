//
//  PasswordChecklList.swift
//  Collabo
//
//  Created by tornike <parunashvili on 18.01.24.
//

import SwiftUI

struct ChecklistItem: View {
    // MARK: - Properties
    var title: String
    var isMet: Bool
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : Color.white.opacity(0.7))
            Text(title)
                .foregroundColor(Color.white.opacity(0.7))
                .font(.system(size: 12))
        }
    }
}



