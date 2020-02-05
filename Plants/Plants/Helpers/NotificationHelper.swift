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
//        
//        var dateComponents = DateComponents()
//        dateComponents
//        let trigger = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
        
    }
}
