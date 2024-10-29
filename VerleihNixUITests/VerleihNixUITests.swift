//
//  VerleihNixUITests.swift
//  VerleihNixUITests
//
//  Created by Michael Milke on 29.10.24.
//

import XCTest

class VerleihNixUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // UI Tests müssen im Vordergrund gestartet werden
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testAddingNewItem() throws {
        let addButton = app.navigationBars["VerleihNix"].buttons["plus"]
        XCTAssertTrue(addButton.exists, "Das Hinzufügen-Button sollte existieren")
        addButton.tap()

        // Fülle das Formular aus
        let itemNameField = app.textFields["Was verliehen?"]
        XCTAssertTrue(itemNameField.exists, "Das Feld 'Was verliehen?' sollte existieren")
        itemNameField.tap()
        itemNameField.typeText("TestItem")

        let lenderField = app.textFields["An wen?"]
        XCTAssertTrue(lenderField.exists, "Das Feld 'An wen?' sollte existieren")
        lenderField.tap()
        lenderField.typeText("TestLender")

        // Datumsauswahl kann komplex sein. Hier wird einfach angenommen, dass der aktuelle Tag ausgewählt ist.
        // Weitere Anpassungen können je nach Bedarf vorgenommen werden.

        let saveButton = app.navigationBars["Neues Verleih"].buttons["Speichern"]
        XCTAssertTrue(saveButton.exists, "Der Speichern-Button sollte existieren")
        saveButton.tap()

        // Überprüfe, ob das neue Item in der Liste angezeigt wird
        let newItem = app.staticTexts["TestItem"]
        XCTAssertTrue(newItem.exists, "Das neue Item sollte in der Liste angezeigt werden")
    }

    func testEditingItem() throws {
        // Zuerst ein Item hinzufügen
        testAddingNewItem()

        // Tippe auf das hinzugefügte Item, um die Bearbeitungsansicht zu öffnen
        let newItem = app.staticTexts["TestItem"]
        XCTAssertTrue(newItem.exists, "Das neue Item sollte in der Liste existieren")
        newItem.tap()

        // Bearbeite das Item
        let itemNameField = app.textFields["Was verliehen?"]
        XCTAssertTrue(itemNameField.exists, "Das Feld 'Was verliehen?' sollte existieren")
        itemNameField.tap()
        itemNameField.clearAndTypeText("EditedItem")

        let lenderField = app.textFields["An wen?"]
        XCTAssertTrue(lenderField.exists, "Das Feld 'An wen?' sollte existieren")
        lenderField.tap()
        lenderField.clearAndTypeText("EditedLender")

        let saveButton = app.navigationBars["Eintrag Bearbeiten"].buttons["Speichern"]
        XCTAssertTrue(saveButton.exists, "Der Speichern-Button sollte existieren")
        saveButton.tap()

        // Überprüfe, ob das bearbeitete Item in der Liste angezeigt wird
        let editedItem = app.staticTexts["EditedItem"]
        XCTAssertTrue(editedItem.exists, "Das bearbeitete Item sollte in der Liste angezeigt werden")
    }

    func testDeletingItem() throws {
        // Zuerst ein Item hinzufügen
        testAddingNewItem()

        // Lösche das hinzugefügte Item mittels Swipe-to-Delete
        let tablesQuery = app.tables
        let deleteButton = tablesQuery.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "Der Delete-Button sollte existieren")
        deleteButton.tap()

        // Überprüfe, ob das Item nicht mehr in der Liste existiert
        let deletedItem = app.staticTexts["TestItem"]
        XCTAssertFalse(deletedItem.exists, "Das gelöschte Item sollte nicht mehr in der Liste vorhanden sein")
    }
}

// Erweiterung, um Textfelder zu löschen und neuen Text einzugeben
extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Cannot clear and type text because the value is not a string")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.tap()
        self.typeText(deleteString)
        self.typeText(text)
    }
}
