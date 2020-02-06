//
//  GeneralHelpers.swift
//  Plants
//
//  Created by Alexander Supe on 06.02.20.
//

import Foundation

class DateHelper {
    static func getRelativeDate(_ date: Date) -> String{
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.string(for: date) ?? ""
    }
}
