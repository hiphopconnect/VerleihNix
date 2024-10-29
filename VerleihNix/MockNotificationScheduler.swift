//
//  MockNotificationScheduler.swift
//  VerleihNixTests
//
//  Created by Michael Milke on 29.10.24.
//

import Foundation
import UserNotifications
@testable import VerleihNix

class MockNotificationScheduler: NotificationScheduler {
    var addedRequests: [UNNotificationRequest] = []
    var removedIdentifiers: [String] = []
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(true, nil)
    }
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        addedRequests.append(request)
        completionHandler?(nil)
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removedIdentifiers.append(contentsOf: identifiers)
    }
}
