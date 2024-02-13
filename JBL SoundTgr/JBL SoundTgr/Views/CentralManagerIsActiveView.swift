//
//  CentralManagerIsActiveView.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import SwiftUI

struct CentralManagerIsActiveView: View {
    
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        if bluetoothManager.isConnected {
            SpeakerControllerView(bluetoothManager: bluetoothManager)
        } else {
            ScanningView()
        }
    }
}

#Preview {
    CentralManagerIsActiveView(bluetoothManager: BluetoothManager())
}
