//
//  ReefKeepersView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import CloudKit

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
                    

                    NavigationLink(destination: { ReefyView(reefKeeper: reefKeeper) }, label: {
                        ReefKeeperPreview(reefKeeper: reefKeeper, user: nil, verbose: false, showReefy: true)
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
