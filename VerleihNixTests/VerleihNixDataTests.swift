//
//  VerleihDataTests.swift
//  VerleihNixTests
//
//  Created by Michael Milke on 29.10.24.
//

import XCTest
@testable import VerleihNix

class VerleihDataTests: XCTestCase {

    var verleihData: VerleihData!
    let testUserDefaultsKey = "TestVerleihNixItems"
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Verwende ein separates UserDefaults-Suite für Tests, um die echten Daten nicht zu beeinflussen
        userDefaults = UserDefaults(suiteName: "TestVerleihNix")!
        userDefaults.removePersistentDomain(forName: "TestVerleihNix")

        // Initialisiere VerleihData mit dem Test-UserDefaults
        verleihData = VerleihData(userDefaults: userDefaults, userDefaultsKey: testUserDefaultsKey)
    }

    override func tearDownWithError() throws {
        verleihData = nil
        userDefaults.removePersistentDomain(forName: "TestVerleihNix")
        userDefaults = nil
        try super.tearDownWithError()
    }

    func testAddingItem() throws {
        let initialCount = verleihData.items.count
        let newItem = VerleihItem(itemName: "TestItem", lender: "TestLender", dateLent: Date(), dateDue: Date().addingTimeInterval(86400), reminderDate: Date().addingTimeInterval(43200))

        verleihData.items.append(newItem)

        XCTAssertEqual(verleihData.items.count, initialCount + 1, "Item sollte zur Liste hinzugefügt werden")
        XCTAssertTrue(verleihData.items.contains(where: { $0.id == newItem.id }), "Hinzugefügtes Item sollte in der Liste vorhanden sein")
    }

    func testEditingItem() throws {
        let originalItem = VerleihItem(itemName: "OriginalItem", lender: "OriginalLender", dateLent: Date(), dateDue: Date().addingTimeInterval(86400), reminderDate: Date().addingTimeInterval(43200))
        verleihData.items.append(originalItem)

        // Bearbeite das Item
        if let index = verleihData.items.firstIndex(where: { $0.id == originalItem.id }) {
            verleihData.items[index].itemName = "EditedItem"
            verleihData.items[index].lender = "EditedLender"
        }

        // Überprüfe die Änderungen
        let editedItem = verleihData.items.first(where: { $0.id == originalItem.id })
        XCTAssertNotNil(editedItem, "Bearbeitetes Item sollte existieren")
        XCTAssertEqual(editedItem?.itemName, "EditedItem", "Item-Name sollte aktualisiert sein")
        XCTAssertEqual(editedItem?.lender, "EditedLender", "Lender sollte aktualisiert sein")
    }

    func testDeletingItem() throws {
        let itemToDelete = VerleihItem(itemName: "DeleteItem", lender: "DeleteLender", dateLent: Date(), dateDue: Date().addingTimeInterval(86400), reminderDate: Date().addingTimeInterval(43200))
        verleihData.items.append(itemToDelete)

        let initialCount = verleihData.items.count

        if let index = verleihData.items.firstIndex(where: { $0.id == itemToDelete.id }) {
            verleihData.items.remove(at: index)
        }

        XCTAssertEqual(verleihData.items.count, initialCount - 1, "Item sollte aus der Liste gelöscht werden")
        XCTAssertFalse(verleihData.items.contains(where: { $0.id == itemToDelete.id }), "Gelöschtes Item sollte nicht mehr in der Liste vorhanden sein")
    }

    func testDataPersistence() throws {
        let newItem = VerleihItem(itemName: "PersistItem", lender: "PersistLender", dateLent: Date(), dateDue: Date().addingTimeInterval(86400), reminderDate: Date().addingTimeInterval(43200))
        verleihData.items.append(newItem)

        // Simuliere einen Reload der Daten
        verleihData.loadItems()

        XCTAssertTrue(verleihData.items.contains(where: { $0.id == newItem.id }), "Persistiertes Item sollte korrekt geladen werden")
    }

    func testDateFormatting() throws {
        let date = Date(timeIntervalSince1970: 0) // 01.01.1970, 00:00
        let formatted = date.formatted()
        XCTAssertEqual(formatted, "1.1.70, 1:00", "Datum sollte korrekt formatiert sein")
    }
}
