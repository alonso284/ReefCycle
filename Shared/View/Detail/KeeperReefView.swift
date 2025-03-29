//
//  ReefView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct KeeperReefView: View {
    let reefKeeperVM: ReefKeeperViewModel
    
    var body: some View {
            ScrollView {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    HStack {
                        reefKeeperView
                        institutionView
                    }
                } else {
                    VStack {
                        reefKeeperView
                        institutionView
                    }
                }
                
                ReefyView(reefKeeperVM: reefKeeperVM)
                    .navigationTitle("Reef")
            }
            .refreshable {
                do {
                    try await reefKeeperVM.load()
                } catch {
                    print(error)
                }
            }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 20).foregroundStyle(.gray)
    }
    
    var institutionView : some View {
        ZStack {
            background
            Group {
                if let institution = reefKeeperVM.institution {
                    let institutionVM = InstitutionViewModel(institution: institution)
                    InstitutionPreview(institutionVM: institutionVM)
                } else {
                    Spacer()
                        .onAppear {
                            Task {
                                await loadInstitution()
                                
                            }
                        }
                }
            }
        }
    }
    
    var reefKeeperView: some View {
        ZStack {
            background
            ReefKeeperPreview(reefKeeperVM: reefKeeperVM)
        }
    }
    
    func loadInstitution() async {
        do {
            try await reefKeeperVM.fetchInstitution()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    ReefView()
//}
