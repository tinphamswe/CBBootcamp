//
//  ContentView.swift
//  CBBootcamp
//
//  Created by Tin Pham on 17/9/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: BluetoothScannerViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif

        NavigationStack {
            VStack(spacing: 16) {
                statusView

                Button {
                    vm.isScanning ? vm.stopScanning() : vm.scanForPeripherals()
                } label: {
                    Label(
                        vm.isScanning ? "Stop Scanning" : "Scan for Bluetooth",
                        systemImage: vm.isScanning ? "stop.circle.fill" : "dot.radiowaves.left.and.right"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                List(vm.scannedPeripherals) { scannedPeripheral in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(scannedPeripheral.name)
                                .font(.headline)

                            Text(scannedPeripheral.id.uuidString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .textSelection(.enabled)

                            Text("RSSI: \(scannedPeripheral.rssi)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if let peripheral = scannedPeripheral.peripheral {
                            Button {
                                vm.connect(peripheral)
                            } label: {
                                Text(connectButtonTitle(for: scannedPeripheral))
                            }
                            .buttonStyle(.bordered)
                            .disabled(!canConnect(to: scannedPeripheral))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .scrollContentBackground(.hidden)
                .background(.white)
                .overlay {
                    if vm.scannedPeripherals.isEmpty {
                        ContentUnavailableView(
                            "No Peripherals Found",
                            systemImage: "antenna.radiowaves.left.and.right",
                            description: Text("Tap Scan for Bluetooth to find nearby advertising devices.")
                        )
                    }
                }
            }
            .padding()
            .navigationTitle("Bluetooth Scanner")
        }
    }
}

// MARK: - Private

extension ContentView {
    private func connectButtonTitle(for scannedPeripheral: ScannedPeripheral) -> String {
        if vm.connectedPeripheralID == scannedPeripheral.id {
            return "Connected"
        }

        if vm.connectingPeripheralID == scannedPeripheral.id {
            return "Connecting"
        }

        return "Connect"
    }

    private func canConnect(to scannedPeripheral: ScannedPeripheral) -> Bool {
        scannedPeripheral.peripheral != nil
            && vm.connectingPeripheralID == nil
            && vm.connectedPeripheralID != scannedPeripheral.id
    }

    private var statusView: some View {
        HStack(spacing: 12) {
            Image(systemName: vm.isScanning ? "wave.3.right.circle.fill" : "info.circle")
                .font(.title2)
                .foregroundStyle(vm.isScanning ? .blue : .secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Bluetooth Status: \(vm.bluetoothState)")
                    .font(.headline)

                Text(vm.statusMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview

#Preview("Waiting") {
    ContentView(vm: .preview(statusMessage: "Waiting for Bluetooth..."))
}

#Preview("Powered On") {
    ContentView(vm: .preview(
        bluetoothState: "Powered On",
        statusMessage: "Bluetooth is ready."
    ))
}

#Preview("Scanning") {
    ContentView(vm: .preview(
        isScanning: true,
        bluetoothState: "Powered On",
        statusMessage: "Scanning for nearby Bluetooth peripherals..."
    ))
}

#Preview("Peripherals Found") {
    ContentView(vm: .preview(
        bluetoothState: "Powered On",
        statusMessage: "Bluetooth is ready.",
        scannedPeripherals: [
            ScannedPeripheral(id: UUID(), name: "Heart Rate Monitor", rssi: -42),
            ScannedPeripheral(id: UUID(), name: "Keyboard", rssi: -67),
            ScannedPeripheral(id: UUID(), name: "Unnamed Peripheral", rssi: -88)
        ]
    ))
}

#Preview("Powered Off") {
    ContentView(vm: .preview(
        bluetoothState: "Powered Off",
        statusMessage: "Bluetooth is powered off."
    ))
}

#Preview("Unauthorized") {
    ContentView(vm: .preview(
        bluetoothState: "Unauthorized",
        statusMessage: "Bluetooth permission is not authorized for this app."
    ))
}

#Preview("Unsupported") {
    ContentView(vm: .preview(
        bluetoothState: "Unsupported",
        statusMessage: "This device does not support Bluetooth Low Energy."
    ))
}

@MainActor
private extension BluetoothScannerViewModel {
    static func preview(
        isScanning: Bool = false,
        bluetoothState: String = "Unknown",
        statusMessage: String,
        scannedPeripherals: [ScannedPeripheral] = []
    ) -> BluetoothScannerViewModel {
        let vm = BluetoothScannerViewModel()
        vm.isScanning = isScanning
        vm.bluetoothState = bluetoothState
        vm.statusMessage = statusMessage
        vm.scannedPeripherals = scannedPeripherals
        return vm
    }
}
