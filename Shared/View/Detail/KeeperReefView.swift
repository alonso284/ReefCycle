
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
                           Image("ReefBackgroundWideMod")
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                       )
                       .clipped()
                       .ignoresSafeArea()

            VStack {
                ZStack {
                    background
                    //modify this hstack to have the reefstyler functionality and delete from main tab view
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
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 3, y: 3)
                Spacer()
            }
        }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 20).foregroundStyle(Color(UIColor.secondarySystemBackground).opacity(0.7))
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
