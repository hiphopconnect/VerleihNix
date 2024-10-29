//
//  ContentView.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var verleihData: VerleihData
    @State private var showingAddItem = false
    @State private var selectedItem: VerleihItem?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(verleihData.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.itemName)
                            .font(.headline)
                        Text("An: \(item.lender)")
                        Text("Ausgeliehen am: \(item.dateLent.formatted())")
                        Text("Rückgabe bis: \(item.dateDue.formatted())")
                    }
                    .contentShape(Rectangle()) // Erlaubt das Tippen auf die gesamte Zelle
                    .onTapGesture {
                        self.selectedItem = item
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("VerleihNix")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                            .accessibilityIdentifier("addButton")
                    }
                }
                // Der EditButton wurde entfernt
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView(verleihData: verleihData)
            }
            .sheet(item: $selectedItem) { item in
                EditItemView(verleihData: verleihData, item: item)
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = verleihData.items[index]
            // Entferne geplante Benachrichtigungen
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
        }
        verleihData.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(VerleihData())
    }
}
