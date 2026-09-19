//
//  BluetoothScannerViewModelTests.swift
//  CBBootcampTests
//
//  Created by Tin Pham on 17/9/26.
//

import CoreBluetooth
import Testing
@testable import CBBootcamp

@MainActor
struct BluetoothScannerViewModelTests {
    fileprivate let centralManager: MockCentralManager
    fileprivate let sut: BluetoothScannerViewModel

    init() {
        centralManager = MockCentralManager(state: .unknown)
        sut = BluetoothScannerViewModel()
        sut.centralManager = centralManager
    }
}

// MARK: - scanForPeripherals

extension BluetoothScannerViewModelTests {
    @Test func scanForPeripheralsStartsScanWhenBluetoothIsPoweredOn() {
        // Given
        centralManager.state = .poweredOn
        sut.scannedPeripherals = [
            ScannedPeripheral(id: UUID(), name: "Old Device", rssi: -60)
        ]

        // When
        sut.scanForPeripherals()

        // Then
        #expect(sut.scannedPeripherals.isEmpty)
        #expect(sut.isScanning)
        #expect(sut.statusMessage == "Scanning for nearby Bluetooth peripherals...")
        #expect(centralManager.scanCallCount == 1)
        #expect(centralManager.scannedServiceUUIDs == nil)
        #expect(centralManager.scannedOptions == nil)
    }

    @Test func scanForPeripheralsDoesNotScanWhenBluetoothIsPoweredOff() {
        // Given
        centralManager.state = .poweredOff

        // When
        sut.scanForPeripherals()

        // Then
        #expect(!sut.isScanning)
        #expect(sut.bluetoothState == "Powered Off")
        #expect(sut.statusMessage == "Bluetooth is powered off.")
        #expect(centralManager.scanCallCount == 0)
    }

    @Test func scanForPeripheralsDoesNotScanWhenBluetoothIsUnauthorized() {
        // Given
        centralManager.state = .unauthorized

        // When
        sut.scanForPeripherals()

        // Then
        #expect(!sut.isScanning)
        #expect(sut.bluetoothState == "Unauthorized")
        #expect(sut.statusMessage == "Bluetooth permission is not authorized for this app.")
        #expect(centralManager.scanCallCount == 0)
    }
}

// MARK: - stopScanning

extension BluetoothScannerViewModelTests {
    @Test func stopScanningStopsCentralManager() {
        // Given
        centralManager.state = .poweredOn
        sut.isScanning = true

        // When
        sut.stopScanning()

        // Then
        #expect(!sut.isScanning)
        #expect(sut.statusMessage == "Scanning stopped.")
        #expect(centralManager.stopScanCallCount == 1)
    }
}

// MARK: - MockCentralManager

private final class MockCentralManager: CBCentralManaging {
    var state: CBManagerState
    private(set) var scanCallCount = 0
    private(set) var stopScanCallCount = 0
    private(set) var scannedServiceUUIDs: [CBUUID]?
    private(set) var scannedOptions: [String: Any]?

    init(state: CBManagerState) {
        self.state = state
    }

    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String: Any]?) {
        scanCallCount += 1
        scannedServiceUUIDs = serviceUUIDs
        scannedOptions = options
    }

    func stopScan() {
        stopScanCallCount += 1
    }

    func connect(_ peripheral: CBPeripheral, options: [String: Any]?) {}
}
