//
//  InstitutionsView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct InstitutionsView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    var institutions: [Institution]? {
        reefVM.institutions?.sorted(by: { $0.name < $1.name })
    }
    
    var body: some View {
        if let institutions {
            Section("Institutions"){
                ForEach(Array(institutions.enumerated()), id: \.element.id) { index, institution in
                    NavigationLink(destination: InstitutionView(institution: institution)) {
                        NumInstitutionPreview(institution: institution, num: index + 1)
                    }
                }
            }
        } else {
            ProgressView()
                .task {
                   await loadInstitutions()
               }
        }
    }

    func loadInstitutions() async {
        do {
            try await reefVM.fetchInstitutions()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    InstitutionsView()
//}
