//
//  ReefView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct KeeperReefView: View {
    let reefKeeperVM: ReefKeeperViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ReefyView(reefKeeper: reefKeeperVM.reefKeeper)
            }
            .navigationTitle("Reef")
        }
    }
}

//#Preview {
//    ReefView()
//}
