//
//  ReefKeepersView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefKeepersView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    var reefKeepers: [ReefKeeper]? {
        reefVM.reefKeepers?.sorted(by: { $0.points > $1.points })
    }
    
    var body: some View {
        if let reefKeepers {
            Section("reefKeepers"){
                ForEach(reefKeepers) {
                    reefKeeper in
                    @State var reefKeeperVM = ReefKeeperViewModel(reefKeeper: reefKeeper)
                    NavigationLink(destination: { ReefyView(reefKeeper: reefKeeper) }, label: {
                        if let user = reefKeeperVM.user {
                            ReefKeeperPreview(reefKeeper: reefKeeper, user: user, verbose: false)
                        } else {
                            ProgressView()
                            .onAppear {
                                Task {
                                    do {
                                        try await reefKeeperVM.fetchUser()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    })

                }
            }
        } else {
            ProgressView()
                .task {
                   await loadReefKeepers()
               }
        }
    }

func loadReefKeepers() async {
    do {
        try await reefVM.fetchReefKeepers()
    } catch {
        print(error)
    }
}
}
#Preview {
    ReefKeepersView()
}
