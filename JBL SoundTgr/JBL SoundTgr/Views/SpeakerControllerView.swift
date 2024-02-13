//
//  SpeakerControllerView.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import SwiftUI

struct SpeakerControllerView: View {
    
    var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack(spacing: 40) {
            Text("I think I found a match!")
                .font(.title)
                .bold()
            
            Button("Play Sound\n(Send 0xAA31)") {
                bluetoothManager.playSound()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.green)
        }
        .padding()
    }
}

#Preview {
    SpeakerControllerView(bluetoothManager: BluetoothManager())
}
