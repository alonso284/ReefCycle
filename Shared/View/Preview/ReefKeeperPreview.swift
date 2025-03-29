//
//  ReefKeeperPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefKeeperPreview: View {
    let reefKeeperVM: ReefKeeperViewModel
    
    var body: some View {
        if let user = reefKeeperVM.user {
            HStack {
                ZStack {
                    Circle().foregroundStyle(user.color)
                    Text(user.emoji)
                }
                VStack {
                    Text(user.username)
                    Text(reefKeeperVM.reefKeeper.id)
                    Text(String(reefKeeperVM.reefKeeper.points))
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
