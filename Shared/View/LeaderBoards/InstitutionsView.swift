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
        reefVM.institutions
    }
    
    var body: some View {
        if let institutions {
            Section("Institutions"){
                ForEach(institutions) {
                    institution in
                    let institutionVM = InstitutionViewModel(institution: institution)
                    NavigationLink(destination: { InstitutionView(institutionVM: institutionVM) }, label: {
                        InstitutionPreview(institutionVM: institutionVM)
                    })
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
