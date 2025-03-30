//
//  LeaderBoardsView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct Ranking: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    @State private var isLoading = false
    let reefKeeper: ReefKeeper
    let user: User?
    let institution: Institution
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 20) {
                pieChartSection
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).foregroundStyle(Color(UIColor.secondarySystemBackground).opacity(0.7))
                        VStack(spacing: 6){
                            ReefKeeperPreview(reefKeeper: reefKeeper, user: user)
                            ProfileInstitutionPreview(institution: institution)
                        }
                        .padding()
                    }
                    .padding()
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).foregroundStyle(Color(UIColor.secondarySystemBackground).opacity(0.7))
                        institutionsSection
                            .padding()
                    }
                    .padding()
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Leaderboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await loadLeaderBoards()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                Task {
                    await loadLeaderBoards()
                }
            }
        }
    }
    
    // MARK: - Component Views
    
    private var pieChartSection: some View {
        Group {
            if let stats = reefVM.stats {
                PieChartView(data: stats)
                    .transition(.opacity)
            } else {
                loadingPlaceholder
                    .onAppear {
                        if reefVM.stats == nil {
                            Task {
                                await loadLeaderBoards()
                            }
                        }
                    }
            }
        }
    }
    
    private var institutionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instituciones")
                .font(.title2)
                .fontWeight(.bold)
            Divider()
            
            if let institutions = reefVM.sortedInsitutionsByImpact {
                ForEach(Array(institutions.enumerated()), id: \.element.id) { index, institution in
                    institutionRow(institution: institution, rank: index + 1)
                    Divider()
                }
            } else {
                ForEach(0..<3, id: \.self) { _ in
                    loadingRow
                }
                .redacted(reason: .placeholder)
            }
            Spacer()
        }
    }
    
    private var loadingPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.1))
            .frame(height: 300)
            .overlay(
                ProgressView()
                    .scaleEffect(1.5)
            )
    }
    
    private var loadingRow: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 120, height: 12)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 80, height: 8)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    // MARK: - Helper Functions
    
    private func institutionRow(institution: Institution, rank: Int) -> some View {
        NavigationLink(destination: InstitutionView(institution: institution)) {
            HStack {
                // Rank indicator
                ZStack {
                    Circle()
                        .fill(rankColor(for: rank))
                        .frame(width: 40, height: 40)
                    
                    Text("\(rank)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Institution info
                HStack(spacing: 4) {
                    Text(institution.name)
                        .fontWeight(.semibold)
                    
                    Text("(\(institution.code))")
                    
//                    Text(String(reefVM.impact(institution: institution)))
//                        .font(.caption)
//                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(.systemGray2)
        case 3: return Color(.systemOrange)
        default: return Color(.systemBlue)
        }
    }
    
    // MARK: - Data Loading
    
    func loadLeaderBoards() async {
        isLoading = true
        do {
            try await reefVM.fetchInstitutions()
            try await reefVM.fetchReefKeepers()
            try await reefVM.fetchUsers()
        } catch {
            print(error)
        }
        isLoading = false
    }
}

