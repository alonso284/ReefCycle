//
//  MainTabView.swift
//  ReefMaster
//
//  Created by Alonso Huerta on 26/03/25.
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
//                KeeperReefView(reefKeeperVM: reefKeeperVM)
//                    .tabItem {
//                        Label("Reef", systemImage: "fish")
//                    }
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
