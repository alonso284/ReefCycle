//
//  LeaderBoardsView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct Ranking: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if let stats = reefVM.stats {
                    PieChartView(data: stats).frame(width: 400, height: 400)
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                await loadLeaderBoards()
                            }
                        }
                }
                InstitutionsView()
//                ReefKeepersView()
//                Text(String(reefVM.users?.count ?? -1))
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
            try await reefVM.fetchUsers()
        } catch {
            print(error)
        }
    }
}

#Preview {
    Ranking()
}
