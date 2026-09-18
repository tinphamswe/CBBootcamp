//
//  CBCentralManagerProtocol.swift
//  CBBootcamp
//
//  Created by Tin Pham on 18/9/26.
//

import Foundation
import CoreBluetooth

protocol CBCentralManaging {
    var state: CBManagerState { get }
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String: Any]?)
    func stopScan()
    func connect(_ peripheral: CBPeripheral, options: [String: Any]?)
}

extension CBCentralManager: CBCentralManaging {}
