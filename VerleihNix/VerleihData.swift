//
//  VerleihData.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import Foundation
import UserNotifications

class VerleihData: ObservableObject {
    @Published var items: [VerleihItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    private let userDefaults: UserDefaults
    private let userDefaultsKey: String
    private let notificationScheduler: NotificationScheduler
    
    // Initializer mit Dependency Injection für UserDefaults, Schlüssel und NotificationScheduler
    init(userDefaults: UserDefaults = .standard, userDefaultsKey: String = "VerleihNixItems", notificationScheduler: NotificationScheduler = UNUserNotificationCenter.current()) {
        self.userDefaults = userDefaults
        self.userDefaultsKey = userDefaultsKey
        self.notificationScheduler = notificationScheduler
        loadItems()
    }
    
    func loadItems() {
        if let data = userDefaults.data(forKey: userDefaultsKey) {
            do {
                let decoded = try JSONDecoder().decode([VerleihItem].self, from: data)
                self.items = decoded
            } catch {
                print("Fehler beim Dekodieren der Daten: \(error.localizedDescription)")
                self.items = []
            }
        } else {
            self.items = []
        }
    }
    
    func saveItems() {
        do {
            let encoded = try JSONEncoder().encode(items)
            userDefaults.set(encoded, forKey: userDefaultsKey)
        } catch {
            print("Fehler beim Kodieren der Daten: \(error.localizedDescription)")
        }
    }
    
    // Methode zum Planen einer Benachrichtigung
    func scheduleNotification(for item: VerleihItem) {
        let content = UNMutableNotificationContent()
        content.title = "Erinnerung: \(item.itemName) zurückholen"
        content.body = "Denke daran, \(item.itemName) von \(item.lender) zurückzufordern."
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        notificationScheduler.add(request) { error in
            if let error = error {
                print("Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
            }
        }
    }
    
    // Methode zum Entfernen einer Benachrichtigung
    func removeNotification(for item: VerleihItem) {
        notificationScheduler.removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}
