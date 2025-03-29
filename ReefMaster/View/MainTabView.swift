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
            let reefMasterVM = ReefMasterViewModel(reefKeeper: reefMaster)
            TabView {
                ReefKeepersViewModel(reefMasterVM: reefMasterVM)
                    .tabItem {
                        Label("ReefKeepers", systemImage: "person.2")
                    }
//                StoreView(reefKeeperVM: reefKeeperVM)
//                    .tabItem {
//                        Label("Store", systemImage: "storefront")
//                    }
//                KeeperProfileView(reefKeeperVM: reefKeeperVM)
//                    .tabItem {
//                        Label("Profile", systemImage: "person")
//                    }
                InstitutionsView()
                    .tabItem {
                        Label("Institutions", systemImage: "house.lodge")
                    }
                QRCodeScannerExampleView(viewModel: ReefMasterViewModel(reefKeeper: reefMaster)).tabItem{Label( "Barcode Scanner", systemImage: "barcode")}
            }
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
