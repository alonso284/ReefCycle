//
//  ReefKeeperPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefKeeperPreview: View {
    let reefKeeper: ReefKeeper
    let user: User
    var verbose: Bool = true
    
    var body: some View {
        HStack {
            ZStack {
                Circle().foregroundStyle(user.color)
                    .frame(width: 50, height: 50)
                Text(user.emoji)
            }
            VStack {
                Text(user.username)
                if verbose {
                    if let date = user.record.creationDate {
                        Text("Member since \(date.description)")
                    }
                    Text(reefKeeper.id)
                    Text(String(reefKeeper.points))
                }
            }
        }
    }
    
//    func loadUser() async {
//        do {
//            try await reefKeeperVM.fetchUser()
//        } catch {
//            print(error)
//        }
//    }
}

//#Preview {
//    ReefKeeperPreview()
//}
