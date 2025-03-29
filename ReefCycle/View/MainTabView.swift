//
//  MainTabView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct MainTabView: View {
    @Binding var pendingReefKeeperVM: PendingReefKeeperViewModel
    @State var triedLoadingKeeper: Bool = false
    @State var editing: Bool = false
    var ownedReefKeeperVM : PendingReefKeeperViewModel.OwnedReefKeeperViewModel? {
        pendingReefKeeperVM.ownedReefKeeperViewModel
    }
    
    var body: some View {
        if let ownedReefKeeperVM {
            TabView {
                Group {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        NavigationStack {
                            KeeperReefView(reefKeeper: ownedReefKeeperVM.reefKeeper)
                                .sheet(isPresented: $editing, content: {
                                    ReefyStyler(pendingReefKeeperVM: $pendingReefKeeperVM)
                                })
//                                .toolbar {
//                                    Button("Edit", action: {
//                                        editing = true
//                                    })
//                                }
                        }
                    } else {
                        NavigationSplitView(sidebar: {
                            ReefyStyler(pendingReefKeeperVM: $pendingReefKeeperVM)
                        }, detail: {
                            KeeperReefView(reefKeeper: ownedReefKeeperVM.reefKeeper)
                        })
                    }
                }
                .tabItem {
                    Label("Reef", systemImage: "fish")
                }
//                StoreView(reefKeeperVM: $ownedReefKeeperVM)
//                    .tabItem {
//                        Label("Store", systemImage: "storefront")
//                    }
                Ranking()
                    .tabItem {
                        Label("Ranking", systemImage: "star")
                    }
                PlasticClassifierView()
                    .tabItem {
                        Label("Classifier", systemImage: "camera")
                    }
            }
        } else {
            if triedLoadingKeeper {
                EditKeeperView(pendingReefKeeperVM: $pendingReefKeeperVM)
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
            if let reefKeeper = pendingReefKeeperVM.reefKeeper {
                self.ownedReefKeeperVM = .init(reefKeeper: reefKeeper)
            }
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
