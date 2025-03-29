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
            List(institutions){
                institution in
                VStack {
                    Text(institution.name)
                    if let location = institution.location {
                        Text("\(location.altitude)")
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
