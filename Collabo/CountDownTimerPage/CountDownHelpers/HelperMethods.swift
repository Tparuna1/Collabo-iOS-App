//
//  HelperMethods.swift
//  Collabo
//
//  Created by tornike <parunashvili on 22.03.24.
//

import Foundation

/// Convert seconds into hours, mins and seconds (90 -> 1m 30s)
func getSecondsToDuration(_ duration: Int) -> String {
    let seconds = duration % 60
    let minutes = (duration / 60) % 60
    let hours = duration / 3600
    return "\(hours > 0 ? "\(hours)h " : "")\(minutes > 0 ? "\(minutes)m " : "")\(seconds > 0 ? "\(seconds)s" : "")"
}
