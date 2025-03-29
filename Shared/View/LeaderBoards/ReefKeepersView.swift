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
        reefVM.reefKeepers
    }
    
    var body: some View {
        if let reefKeepers {
            Section("reefKeepers"){
                ForEach(reefKeepers) {
                    reefKeeper in
                    let reefKeeperVM = ReefKeeperViewModel(reefKeeper: reefKeeper)
                    NavigationLink(destination: { ReefyView(reefKeeperVM: reefKeeperVM) }, label: {
                        ReefKeeperPreview(reefKeeperVM: reefKeeperVM)
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
