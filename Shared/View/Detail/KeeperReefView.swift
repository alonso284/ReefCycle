//
//  ReefView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import CloudKit

struct KeeperReefView: View {
    let reefKeeper: ReefKeeper
    let user: User?
    let institution: Institution
    
    var body: some View {
        ZStack {
            Color.clear
                       .overlay (
                           Image("ReefBackground")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
//                               .border(.blue, width: 2)
                       )
                       .clipped()
                       .ignoresSafeArea()

            VStack {
                ZStack {
                    background
                    HStack {
                        ReefKeeperPreview(reefKeeper: reefKeeper, user: user)
                            .padding()
                        Divider()
                            .padding()
                        InstitutionPreview(institution: institution)
                            .padding()
                    }
                    .padding()
                }
                .fixedSize()
                Spacer()
                ReefyView(reefKeeper: reefKeeper)
                    .offset(y: -30)
                Spacer()
            }
            
//            .navigationTitle("Reef")
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 20).foregroundStyle(.gray.opacity(0.6))
    }
    
//    func loadInstitution() async {
//        do {
//            try await reefKeeperVM.fetchInstitution()
//        } catch {
//            print(error)
//        }
//    }
}

//#Preview {
//    let record = CKRecord(recordType: RecordType.ReefKeeper.rawValue)
//    record[.reefkeeper_hat] = "ITESM"
//    record[.reefkeeper_username] = "ITESM"
    
//    record[.institution_logo] = "
//    record[.institution_name] = "Tecnologico de Monterrey"
//    record[.institution_location]
//    if let institution = Institution(record: record) {
//        return KeeperReefView(institution: institution)
//    } else {
//        return EmptyView()
//    }
//}
