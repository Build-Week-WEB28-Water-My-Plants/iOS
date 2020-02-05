//
//  NotificationHelper.swift
//  Plants
//
//  Created by Alexander Supe on 05.02.20.
//

import Foundation
import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()
    
    func scheduleNotification(for name: String, in days: Double) {
        let content = UNMutableNotificationContent()
        content.title = "A plant needs water"
        content.body = "Your plant \(name) needs to be watered."
        
        let interval = days * 86400
        let nextDate = Date().advanced(by: TimeInterval(interval))
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = Calendar.current.component(.year, from: nextDate)
        dateComponents.month = Calendar.current.component(.month, from: nextDate)
        dateComponents.day = Calendar.current.component(.day, from: nextDate)
        dateComponents.hour = Calendar.current.component(.hour, from: nextDate)
        dateComponents.minute = Calendar.current.component(.minute, from: nextDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil { print("Error scheduling notifications") }
        }
        
    }
}
