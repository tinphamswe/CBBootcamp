# CBBootcamp

A SwiftUI iOS app for discovering nearby Bluetooth Low Energy peripherals and connecting to one of them.

## Current features

- Displays the current Bluetooth state and a helpful status message.
- Scans for nearby advertising peripherals.
- Shows each peripheral's name, identifier, and RSSI signal strength.
- Connects to a selected peripheral and reports connection changes.
- Includes unit and UI test targets.

## Requirements

- Xcode 16 or later
- An iPhone or iPad with Bluetooth Low Energy support

Bluetooth scanning must be tested on a physical device; the iOS Simulator cannot scan for nearby BLE peripherals.

## Run locally

1. Open `CBBootcamp.xcodeproj` in Xcode.
2. Choose a connected physical iPhone or iPad as the run destination.
3. Build and run the `CBBootcamp` scheme.
4. Allow Bluetooth access when prompted, then tap **Scan for Bluetooth**.

## Next steps

This is an active bootcamp project. More Bluetooth features and refinements are planned.
