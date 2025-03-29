//
//  MainTabView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct MainTabView: View {
    let pendingReefKeeperVM: PendingReefKeeperViewModel
    @State var triedLoadingKeeper: Bool = false
    
    var body: some View {
        if let reefKeeper = pendingReefKeeperVM.reefKeeper {
            let reefKeeperVM = ReefKeeperViewModel(reefKeeper: reefKeeper)
            TabView {
                KeeperReefView(reefKeeperVM: reefKeeperVM)
                    .tabItem {
                        Label("Reef", systemImage: "fish")
                    }
                StoreView(reefKeeperVM: reefKeeperVM)
                    .tabItem {
                        Label("Store", systemImage: "storefront")
                    }
                KeeperProfileView(reefKeeperVM: reefKeeperVM)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                InstitutionsView()
                    .tabItem {
                        Label("Institutions", systemImage: "house.lodge")
                    }
            }
        } else {
            if triedLoadingKeeper {
                EditKeeperView(pendingReefKeeperVM: pendingReefKeeperVM)
            } else {
                ProgressView()
                    .task {
                        await loadReefKeeper()
                    }
            }
        }
    }
    
    func loadReefKeeper() async {
        do {
            try await pendingReefKeeperVM.fetchReefKeeper()
            triedLoadingKeeper = true
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    @Previewable var reefKeeperVM = ReefKeeperViewModel()
//    MainTabView(reefKeeperVM: reefKeeperVM)
//}
