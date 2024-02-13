//
//  ContentView.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        if !bluetoothManager.isActive {
            CentralManagerNotActiveView()
        } else {
            CentralManagerIsActiveView(bluetoothManager: bluetoothManager)
        }
    }
}

#Preview {
    ContentView()
}
