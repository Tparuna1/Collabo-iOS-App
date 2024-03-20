//
//  OffsetKey.swift
//  Collabo
//
//  Created by tornike <parunashvili on 19.03.24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
