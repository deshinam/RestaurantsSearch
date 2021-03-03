import XCTest

class JustEatTestTaskUITests: XCTestCase {

    func testRestaurantLabelDisplay() throws {
        let app = XCUIApplication()
        app.launch()

        // Enter postcode "EC4M" in the search field
        let searchTextField = app.textFields["Search by postcode"]
        searchTextField.tap()
        searchTextField.typeText("EC4M")

        // Tap the "Search" button
        app.buttons["Search"].tap()

        // Check that we see restaurant name "Fatty Fingers"
        XCTAssert(app.staticTexts["Fatty Fingers"].waitForExistence(timeout: 5))
    }

    func testRestaurantLogoDisplay() throws {
        let app = XCUIApplication()
        app.launch()

        // Enter postcode "EC4M" in the search field
        let searchTextField = app.textFields["Search by postcode"]
        searchTextField.tap()
        searchTextField.typeText("EC4M")

        // Tap the "Search" button
        app.buttons["Search"].tap()

        // Check that we see restaurant name "Fatty Fingers"
        XCTAssert(app.cells.element(boundBy: 0).images["Restaurant logo"].waitForExistence(timeout: 5))
    }
}
