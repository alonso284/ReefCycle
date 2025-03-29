//
//  ReefView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct KeeperReefView: View {
    let reefKeeper: ReefKeeper
    let user: User? = nil
    let institution: Institution? = nil
    
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
                
                ReefyView(reefKeeper: reefKeeper)
                    .navigationTitle("Reef")
            }
//            .refreshable {
//                do {
//                    try await reefKeeperVM.load()
//                } catch {
//                    print(error)
//                }
//            }
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 20).foregroundStyle(.gray)
    }
    
    var institutionView : some View {
        ZStack {
            background
            if let institution {
                let institutionVM = InstitutionViewModel(institution: institution)
                InstitutionPreview(institutionVM: institutionVM)
            }
        }
    }
    
    var reefKeeperView: some View {
        ZStack {
            background
            if let user {
                ReefKeeperPreview(reefKeeper: reefKeeper, user: user)
            }
        }
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
//    ReefView()
//}
