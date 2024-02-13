//
//  ScanningView.swift
//  JBL SoundTgr
//
//  Created by Karson Eskind on 2/13/24.
//

import SwiftUI

struct ScanningView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Discovering product...")
                .font(.title)
                .bold()
            
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        }
        .padding()
    }
}

#Preview {
    ScanningView()
}
