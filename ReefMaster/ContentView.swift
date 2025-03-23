//
//  ContentView.swift
//  ReefMaster
//
//  Created by Alonso Huerta on 22/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    @State var triedLoadingUser: Bool = false

    var body: some View {
        if let user = reefVM.user {
            Text("Here")
        } else {
            if triedLoadingUser {
                EditUserView()
            } else {
                ProgressView()
                    .task {
                        await loadUser()
                    }
            }
        }
    }
    
    func loadUser() async {
        do {
            try await reefVM.fetchUser()
            triedLoadingUser = true
        } catch {
            print(error)
        }
    }

}

//#Preview {
//    @Previewable var reefVM = ReefCycleViewModel()
//
//    ContentView()
//        .environment(reefVM)
//}
