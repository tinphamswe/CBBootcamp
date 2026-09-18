//
//  CBBootcampUITests.swift
//  CBBootcampUITests
//
//  Created by Tin Pham on 17/9/26.
//

import XCTest

@MainActor
final class CBBootcampUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }
}

// MARK: - Launch

extension CBBootcampUITests {
    func testLaunchDisplaysBluetoothScannerScreen() throws {
        // Given
        app.launch()

        // Then
        XCTAssertTrue(app.navigationBars["Bluetooth Scanner"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Bluetooth Status: Unknown"].exists)
        XCTAssertTrue(app.staticTexts["Waiting for Bluetooth..."].exists)
        XCTAssertTrue(app.buttons["Scan for Bluetooth"].exists)
        XCTAssertTrue(app.staticTexts["No Peripherals Found"].exists)
        XCTAssertTrue(app.staticTexts["Tap Scan for Bluetooth to find nearby advertising devices."].exists)
    }
}

// MARK: - scanForBluetooth

extension CBBootcampUITests {
    func testScanForBluetoothButtonCanBeTapped() throws {
        // Given
        app.launch()
        let scanButton = app.buttons["Scan for Bluetooth"]
        XCTAssertTrue(scanButton.waitForExistence(timeout: 5))

        // When
        scanButton.tap()

        // Then
        XCTAssertTrue(scannerStatusExists())
        XCTAssertTrue(app.buttons["Scan for Bluetooth"].exists || app.buttons["Stop Scanning"].exists)
    }
}

// MARK: - Private

private extension CBBootcampUITests {
    func scannerStatusExists() -> Bool {
        let possibleStatuses = [
            "Bluetooth Status: Unknown",
            "Bluetooth Status: Resetting",
            "Bluetooth Status: Unsupported",
            "Bluetooth Status: Unauthorized",
            "Bluetooth Status: Powered Off",
            "Bluetooth Status: Powered On",
            "Bluetooth Status: Unavailable"
        ]

        return possibleStatuses.contains { status in
            app.staticTexts[status].exists
        }
    }
}
