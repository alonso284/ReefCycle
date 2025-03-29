//
//  ReefKeeperPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

extension Date {
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

struct ReefKeeperPreview: View {
    let reefKeeper: ReefKeeper
    @State var user: User?
    var verbose: Bool = true
    var showReefy: Bool = false
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    
    

    
    var body: some View {
//        if let user = reefKeeper.user {
            HStack {
                ZStack {
                    Circle().foregroundStyle(user?.color ?? Color("ReefBackground"))
                        .frame(width: 80, height: 80)
                    Text(user?.emoji ?? "🪸")
                        .font(.system(size: 50))
                }
                VStack (alignment: .leading){
                    Text(user?.username ?? "Anonymous")
                        .font(.headline)
                    if verbose {
                        if let date = user?.record.creationDate {
                            Text("Member since \(date.shortDateString)")
                                .font(.subheadline)
                        }
                        Text(reefKeeper.id)
                            .font(.subheadline)
                        Text("Points: \(reefKeeper.points) pts")
                            .font(.subheadline)
                    }
                }
                Spacer()
                if showReefy {
                    ReefyView(reefKeeper: reefKeeper, size: 100)
                        .offset(y: -15)
                }
            }
            .onAppear {
                Task {
                    do {
                        guard let userRef = reefKeeper.user else { return }
                        user = try await reefVM.user(from: userRef)
                        print(user)
//                        print("Found user \(reefKeeper.user.recordID)")
                    } catch {
                        print("Couldnt find user \(error)")
                    }
                }
            }
//        } else {
//            ProgressView()
//                .onAppear {
//                    Task {
//                        await loadUser()
//                    }
//                }
//        }
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
