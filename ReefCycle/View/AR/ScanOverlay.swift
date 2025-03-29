//
//  ScanOverlay.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import SwiftUI

struct ScanningOverlay: View {
    @ObservedObject var viewModel: TrashcanPlacementViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "arkit")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("Buscando superficies planas...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Scanning progress indicator
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 4)
                        .opacity(0.3)
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width * 0.7 * viewModel.scanningProgress, height: 4)
                        .foregroundColor(.blue)
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
                
                Text("Mueve el dispositivo lentamente")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    ScanningOverlay(viewModel: TrashcanPlacementViewModel())
}
