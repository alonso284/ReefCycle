//
//  MainTabView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct MainTabView: View {
    @State var pendingReefKeeperVM: PendingReefKeeperViewModel
    var reefKeeper: ReefKeeper? {
        pendingReefKeeperVM.reefKeeper
    }
    var institution: Institution? {
        pendingReefKeeperVM.institution
    }
    @State var triedLoadingKeeper: Bool = false
    
    @State var editing: Bool = false
    
    var body: some View {
        if let reefKeeper, let institution {
//            let reefKeeperVM = ReefKeeperViewModel(reefKeeper: reefKeeper)
//            let ownedReefKeeperVM = OwnedReefKeeperViewModel(reefKeeper: reefKeeper)
            
            TabView {
                Group {
//                    if UIDevice.current.userInterfaceIdiom == .phone {
                        NavigationStack {
                            KeeperReefView(reefKeeper: reefKeeper, user: pendingReefKeeperVM.user, institution: institution)
                                .sheet(isPresented: $editing, content: {
                                    ReefyStyler(reefKeeperVM: $pendingReefKeeperVM)
                                        .onDisappear {
                                            Task {
                                                await loadReefKeeper()
                                            }
                                        }
                                })
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            editing = true
                                        }) {
                                            Image(systemName: "backpack")
                                                .foregroundColor(.white) // Customize your color here
                                        }
                                    }
                                }

                        }
//                    } else {
//                        NavigationSplitView(sidebar: {
//                            ReefyStyler(reefKeeperVM: $pendingReefKeeperVM)
//                        }, detail: {
//                            KeeperReefView(reefKeeper: reefKeeper, user: pendingReefKeeperVM.user, institution: institution)
//                                .refreshable {
//                                    Task {
//                                        await loadReefKeeper()
//                                    }
//                                }
//                        })
//                    }
                }
                .tabItem {
                    Label("Mi Reefy", systemImage: "fish")
                }
                StoreView(reefKeeperVM: $pendingReefKeeperVM)
                    .tabItem {
                        Label("Tienda", systemImage: "storefront")
                    }
                Ranking(reefKeeper: reefKeeper, user: pendingReefKeeperVM.user, institution: institution)
                    .tabItem {
                        Label("Leaderboard", systemImage: "star")
                    }
                
                NavigationStack {
                    PlasticClassifierView()
                }
                .tabItem {
                    Label("Recicla", systemImage: "camera")
                }
                
                
            }
        } else {
            if triedLoadingKeeper {
                EditKeeperView(pendingReefKeeperVM: pendingReefKeeperVM)
            } else {
                ProgressView()
                    .task {
                        await load()
                    }
            }
        }
    }
    
    func load() async {
        do {
            try await pendingReefKeeperVM.fetchReefKeeper()
            try await pendingReefKeeperVM.fetchInstitution()
            triedLoadingKeeper = true
        } catch {
            print(error)
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
