//
//  CentralManagerNotActiveView.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import SwiftUI

struct CentralManagerNotActiveView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Something's not right...")
                .font(.title)
                .bold()
            
            Text("Make sure Bluetooth is turned on in your device's settings.")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("If that doesn't help, there may be something wrong with your device.")
            
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

#Preview {
    CentralManagerNotActiveView()
}
