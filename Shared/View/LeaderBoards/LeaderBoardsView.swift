//
//  LeaderBoardsView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct LeaderBoardsView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    
    var body: some View {
        NavigationStack {
            List {
                InstitutionsView()
                ReefKeepersView()
            }
            .refreshable {
                await loadLeaderBoards()
            }
            .navigationTitle("Leader Boards")
        }
    }
    
    func loadLeaderBoards() async {
        do {
            try await reefVM.fetchInstitutions()
            try await reefVM.fetchReefKeepers()
        } catch {
            print(error)
        }
    }
}

#Preview {
    LeaderBoardsView()
}
