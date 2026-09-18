//
//  CBBootcampApp.swift
//  CBBootcamp
//
//  Created by Tin Pham on 17/9/26.
//

import SwiftUI

@main
struct CBBootcampApp: App {
    @StateObject private var vm = BluetoothScannerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
