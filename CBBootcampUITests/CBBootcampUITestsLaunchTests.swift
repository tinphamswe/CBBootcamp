//
//  CBBootcampUITestsLaunchTests.swift
//  CBBootcampUITests
//
//  Created by Tin Pham on 17/9/26.
//

import XCTest

@MainActor
final class CBBootcampUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        // Given
        let app = XCUIApplication()

        // When
        app.launch()

        // Then
        XCTAssertTrue(app.navigationBars["Bluetooth Scanner"].waitForExistence(timeout: 5))
    }
}
