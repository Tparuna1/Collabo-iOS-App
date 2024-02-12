//
//  PasswordStrengthChecklist.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.01.24.
//

import SwiftUI

struct PasswordStrengthChecklist: View {
    
    // MARK: - Properties
    
    var isMinLengthMet: Bool
    var isCapitalLetterMet: Bool
    var isNumberMet: Bool
    var isUniqueCharacterMet: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your password should have:")
                .foregroundColor(.white)
            
            ChecklistItem(title: "At least 8 characters", isMet: isMinLengthMet)
            ChecklistItem(title: "At least one capital letter", isMet: isCapitalLetterMet)
            ChecklistItem(title: "At least one number", isMet: isNumberMet)
            ChecklistItem(title: "At least one unique character", isMet: isUniqueCharacterMet)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}
