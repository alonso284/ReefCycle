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
    
        @State var editing: Bool = false
    
    var body: some View {
        if let reefKeeper = pendingReefKeeperVM.reefKeeper {
            let reefKeeperVM = ReefKeeperViewModel(reefKeeper: reefKeeper)
            let ownedReefKeeperVM = OwnedReefKeeperViewModel(reefKeeper: reefKeeper)
            
            TabView {
                Group {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        NavigationStack {
                            KeeperReefView(reefKeeperVM: reefKeeperVM)
                                .sheet(isPresented: $editing, content: {
                                    ReefyStyler(reefKeeperVM: ownedReefKeeperVM)
                                        .onDisappear {
                                            Task {
                                                await loadReefKeeper()
                                            }
                                        }
                                })
                                .toolbar {
                                    Button("Edit", action: {
                                        editing = true
                                    })
                                }
                        }
                    } else {
                        NavigationSplitView(sidebar: {
                            ReefyStyler(reefKeeperVM: ownedReefKeeperVM)
                        }, detail: {
                            KeeperReefView(reefKeeperVM: reefKeeperVM)
                        })
                    }
                }
                .tabItem {
                    Label("Reef", systemImage: "fish")
                }
                StoreView(reefKeeperVM: ownedReefKeeperVM)
                    .tabItem {
                        Label("Store", systemImage: "storefront")
                    }
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
