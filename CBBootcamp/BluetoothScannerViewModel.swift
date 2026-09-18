//
//  BluetoothScannerViewModel.swift
//  CBBootcamp
//
//  Created by Tin Pham on 18/9/26.
//

import Combine
import CoreBluetooth
import Foundation

@MainActor
final class BluetoothScannerViewModel: NSObject, ObservableObject {
    @Published var scannedPeripherals: [ScannedPeripheral] = []
    @Published var isScanning = false
    @Published var bluetoothState = "Unknown"
    @Published var statusMessage = "Waiting for Bluetooth..."
    @Published var connectingPeripheralID: UUID?
    @Published var connectedPeripheralID: UUID?

    lazy var centralManager: CBCentralManaging = CBCentralManager(delegate: self, queue: .main)

    func scanForPeripherals() {
        scannedPeripherals.removeAll()

        guard centralManager.state == .poweredOn else {
            bluetoothState = title(for: centralManager.state)
            statusMessage = message(for: centralManager.state)
            return
        }

        isScanning = true
        statusMessage = "Scanning for nearby Bluetooth peripherals..."
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        isScanning = false
        statusMessage = "Scanning stopped."
        centralManager.stopScan()
    }

    func connect(_ peripheral: CBPeripheral, options: [String: Any]? = nil) {
        connect(peripheralID: peripheral.identifier, peripheralName: peripheral.name) {
            centralManager.connect(peripheral, options: options)
        }
    }

    func connect(peripheralID: UUID, peripheralName: String?, connectAction: () -> Void) {
        connectingPeripheralID = peripheralID
        statusMessage = "Connecting to \(peripheralName ?? "Unnamed Peripheral")..."
        connectAction()
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothScannerViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = title(for: central.state)
        statusMessage = message(for: central.state)

        if central.state != .poweredOn {
            isScanning = false
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        let scannedPeripheral = ScannedPeripheral(
            id: peripheral.identifier,
            name: peripheral.name ?? "Unnamed Peripheral",
            rssi: RSSI.intValue,
            peripheral: peripheral
        )

        if let index = scannedPeripherals.firstIndex(where: { $0.id == scannedPeripheral.id }) {
            scannedPeripherals[index] = scannedPeripheral
        } else {
            scannedPeripherals.append(scannedPeripheral)
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        connectingPeripheralID = nil
        connectedPeripheralID = peripheral.identifier
        statusMessage = "Connected to \(peripheral.name ?? "Unnamed Peripheral")."
    }

    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        connectingPeripheralID = nil
        statusMessage = "Failed to connect to \(peripheral.name ?? "Unnamed Peripheral")."
    }

    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        if connectedPeripheralID == peripheral.identifier {
            connectedPeripheralID = nil
        }
        statusMessage = "Disconnected from \(peripheral.name ?? "Unnamed Peripheral")."
    }
}

// MARK: - Private

extension BluetoothScannerViewModel {
    private func title(for state: CBManagerState) -> String {
        switch state {
        case .unknown:
            return "Unknown"
        case .resetting:
            return "Resetting"
        case .unsupported:
            return "Unsupported"
        case .unauthorized:
            return "Unauthorized"
        case .poweredOff:
            return "Powered Off"
        case .poweredOn:
            return "Powered On"
        @unknown default:
            return "Unavailable"
        }
    }

    private func message(for state: CBManagerState) -> String {
        switch state {
        case .unknown:
            return "Bluetooth state is unknown."
        case .resetting:
            return "Bluetooth is resetting."
        case .unsupported:
            return "This device does not support Bluetooth Low Energy."
        case .unauthorized:
            return "Bluetooth permission is not authorized for this app."
        case .poweredOff:
            return "Bluetooth is powered off."
        case .poweredOn:
            return "Bluetooth is ready."
        @unknown default:
            return "Bluetooth is unavailable."
        }
    }
}
