//
//  ReefKeeperPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefKeeperPreview: View {
    let reefKeeperVM: ReefKeeperViewModel
    var verbose: Bool = true
    
    var body: some View {
        if let user = reefKeeperVM.user {
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
                        Text(reefKeeperVM.reefKeeper.id)
                        Text(String(reefKeeperVM.reefKeeper.points))
                    }
                }
            }
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await loadUser()
                    }
                }
        }
    }
    
    func loadUser() async {
        do {
            try await reefKeeperVM.fetchUser()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    ReefKeeperPreview()
//}
