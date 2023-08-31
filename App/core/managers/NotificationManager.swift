//
//  NotificationManager.swift
//  App
//
//  Created by Omar Brugna on 17/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static let shared = NotificationManager()
    
    var settings: UNNotificationSettings?
    
    func request(completion: @escaping  (Bool) -> Void) {
        if !granted() {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                    self.fetchNotificationSettings()
                    completion(granted)
                }
        } else {
            completion(true)
        }
    }
    
    
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func granted() -> Bool {
        fetchNotificationSettings()
        if settings?.authorizationStatus == .authorized {
            return true
        }
        return false
    }
    
    func scheduleNotification(interval: Int, notificationType: NotificationType) {
        
        removeDeliveredNotification(notificationType: notificationType)
        removeScheduledNotification(notificationType: notificationType)
        
        let content = UNMutableNotificationContent()
        content.title = notificationType.title
        content.body = notificationType.body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: notificationType.id,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func removeScheduledNotification(notificationType: NotificationType) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationType.id])
    }
    
    func removeDeliveredNotification(notificationType: NotificationType) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationType.id])
    }
    
    func removeAllScheduledNotification() {
        
        let notifications = NotificationType.getAll()
        
        for notification in notifications {
            removeScheduledNotification(notificationType: notification)
        }
    }
}
