//
//  ReefKeepersViewModel.swift
//  ReefMaster
//
//  Created by Alonso Huerta on 28/03/25.

import SwiftUI

struct ReefKeepersViewModel: View {
    let reefMasterVM: ReefMasterViewModel
    
    var body: some View {
        if let reefKeepers = reefMasterVM.reefKeepers {
            List(reefKeepers){
                reefKeeper in
//                Text(reefKeeper.id)
                Button(action: {
                    Task {
                        do {
                            try await reefMasterVM.registerPoints(reefKeeper: reefKeeper, points: 100)
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    Text(reefKeeper.id)
                })
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
            try await reefMasterVM.fetchReefKeepers()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    ReefKeepersViewModel()
//}
