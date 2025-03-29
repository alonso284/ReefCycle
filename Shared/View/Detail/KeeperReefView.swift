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

        NavigationSplitView(sidebar: {
            Text("Custom")
        }, detail: {
            VStack {
                HStack {
                    ReefKeeperPreview(reefKeeperVM: reefKeeperVM)
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
                ReefyView(reefKeeperVM: reefKeeperVM)
                    .navigationTitle("Reef")
            }
        })
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
