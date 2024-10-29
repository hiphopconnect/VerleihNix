//
//  AddItemView.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import SwiftUI
import UserNotifications

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var verleihData: VerleihData
    
    @State private var itemName = ""
    @State private var lender = ""
    @State private var dateLent = Date()
    @State private var dateDue = Date()
    @State private var reminderDate = Date()
    
    // Dependency Injection für NotificationScheduler
    var notificationScheduler: NotificationScheduler = UNUserNotificationCenter.current()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gegenstand")) {
                    TextField("Was verliehen?", text: $itemName)
                        .accessibilityIdentifier("itemNameField")
                    TextField("An wen?", text: $lender)
                        .accessibilityIdentifier("lenderField")
                }
                
                Section(header: Text("Daten")) {
                    DatePicker("Ausleihdatum", selection: $dateLent, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("dateLentPicker")
                    DatePicker("Rückgabedatum", selection: $dateDue, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("dateDuePicker")
                }
                
                Section(header: Text("Erinnerung")) {
                    DatePicker("Erinnerungsdatum", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .accessibilityIdentifier("reminderDatePicker")
                }
            }
            .navigationTitle("Neues Verleih")
            .navigationBarItems(trailing: Button("Speichern") {
                let newItem = VerleihItem(itemName: itemName, lender: lender, dateLent: dateLent, dateDue: dateDue, reminderDate: reminderDate)
                verleihData.items.append(newItem)
                verleihData.scheduleNotification(for: newItem)
                presentationMode.wrappedValue.dismiss()
            }.disabled(itemName.isEmpty || lender.isEmpty))
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(verleihData: VerleihData())
    }
}
