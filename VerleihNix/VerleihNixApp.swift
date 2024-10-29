//
//  VerleihNixApp.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import SwiftUI
import UserNotifications

@main
struct VerleihNixApp: App {
    @StateObject var verleihData = VerleihData()
    
    init() {
        // Anfrage für Benachrichtigungsberechtigungen
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Benachrichtigungsberechtigung erteilt.")
            } else if let error = error {
                print("Fehler bei der Benachrichtigungsberechtigung: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(verleihData)
        }
    }
}
