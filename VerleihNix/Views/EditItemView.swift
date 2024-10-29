//
//  EditItemView.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import SwiftUI
import UserNotifications

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var verleihData: VerleihData
    @State private var itemName: String
    @State private var lender: String
    @State private var dateLent: Date
    @State private var dateDue: Date
    @State private var reminderDate: Date
    
    var item: VerleihItem
    
    // Dependency Injection für NotificationScheduler
    var notificationScheduler: NotificationScheduler = UNUserNotificationCenter.current()
    
    init(verleihData: VerleihData, item: VerleihItem, notificationScheduler: NotificationScheduler = UNUserNotificationCenter.current()) {
        self.verleihData = verleihData
        self.item = item
        self.notificationScheduler = notificationScheduler
        _itemName = State(initialValue: item.itemName)
        _lender = State(initialValue: item.lender)
        _dateLent = State(initialValue: item.dateLent)
        _dateDue = State(initialValue: item.dateDue)
        _reminderDate = State(initialValue: item.reminderDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gegenstand")) {
                    TextField("Was verliehen?", text: $itemName)
                        .accessibilityIdentifier("editItemNameField")
                    TextField("An wen?", text: $lender)
                        .accessibilityIdentifier("editLenderField")
                }
                
                Section(header: Text("Daten")) {
                    DatePicker("Ausleihdatum", selection: $dateLent, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("editDateLentPicker")
                    DatePicker("Rückgabedatum", selection: $dateDue, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("editDateDuePicker")
                }
                
                Section(header: Text("Erinnerung")) {
                    DatePicker("Erinnerungsdatum", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("editReminderDatePicker")
                }
            }
            .navigationTitle("Eintrag Bearbeiten")
            .navigationBarItems(trailing: Button("Speichern") {
                if let index = verleihData.items.firstIndex(where: { $0.id == item.id }) {
                    // Entferne vorherige Benachrichtigung
                    verleihData.removeNotification(for: item)
                    
                    // Aktualisiere die Eintragsdaten
                    verleihData.items[index].itemName = itemName
                    verleihData.items[index].lender = lender
                    verleihData.items[index].dateLent = dateLent
                    verleihData.items[index].dateDue = dateDue
                    verleihData.items[index].reminderDate = reminderDate
                    
                    // Plane neue Benachrichtigung
                    verleihData.scheduleNotification(for: verleihData.items[index])
                }
                presentationMode.wrappedValue.dismiss()
            }.disabled(itemName.isEmpty || lender.isEmpty))
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = VerleihItem(itemName: "Buch", lender: "Max", dateLent: Date(), dateDue: Date().addingTimeInterval(86400), reminderDate: Date().addingTimeInterval(43200))
        EditItemView(verleihData: VerleihData(), item: sampleItem)
    }
}
