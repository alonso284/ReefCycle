//
//  EditKeeperView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct EditKeeperView: View {
    @Environment(ReefCycleViewModel.self) private var reefVM: ReefCycleViewModel
    @Binding var pendingReefKeeperVM: PendingReefKeeperViewModel
    @State private var institution: Institution?
    @State private var id: String = ""
    
    var body: some View {

        if let institutions = reefVM.institutions {
            Form {
                Picker("Institutions", selection: $institution, content: {
                    Text("None").tag(Optional<Institution>.none)
                    ForEach(institutions){
                        institution in
                        HStack {
                            AsyncImage(url: institution.logo.fileURL){ image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            Text(institution.name)
                        }
                        .tag(institution)
                        
                    }
                })
                TextField("ID", text: $id)
                if let institution, !id.isEmpty {
                    Button("Save", action: {
                        Task {
                            do {
                                try await pendingReefKeeperVM.createReefKeeper(institution: institution, id: id)
                            } catch {
                                print(error)
                            }
                        }
                    })
                }
            }
            .refreshable {
                do {
                    try await pendingReefKeeperVM.fetchReefKeeper()
                } catch {
                    print(error)
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
//    EditKeeperView()
//}
