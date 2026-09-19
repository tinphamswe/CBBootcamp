//
//  ScannedPeripheral.swift
//  CBBootcamp
//
//  Created by Tin Pham on 18/9/26.
//

import CoreBluetooth
import Foundation

struct ScannedPeripheral: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int
    var peripheral: CBPeripheral?
}
