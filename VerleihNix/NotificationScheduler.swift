//
//  NotificationScheduler.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import Foundation
import UserNotifications

protocol NotificationScheduler {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

extension UNUserNotificationCenter: NotificationScheduler {}
