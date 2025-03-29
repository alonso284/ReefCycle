//
//  MainTabView.swift
//  ReefMaster
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

import SwiftUI

struct MainTabView: View {
    let pendingReefMasterVM: PendingReefMasterViewModel
    @State var triedLoadingMaster: Bool = false
    
    var body: some View {
        if let reefMaster = pendingReefMasterVM.reefMaster {
        
            
                QRCodeScannerExampleView(viewModel: ReefMasterViewModel(reefKeeper: reefMaster))
         
        } else {
            if triedLoadingMaster {
                EditMasterView(pendingReefKeeperVM: pendingReefMasterVM)
            } else {
                ProgressView()
                    .task {
                        await loadReefMaster()
                    }
            }
        }
    }
    
    func loadReefMaster() async {
        do {
            try await pendingReefMasterVM.fetchReefMaster()
            triedLoadingMaster = true
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    MainTabView()
//}
