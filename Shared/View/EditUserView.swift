//
//  EditUserView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct EditUserView: View {
    @Environment(ReefCycleViewModel.self) var reefVM: ReefCycleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var username: String = ""
    @State var emoji: String = ""
    @State var color: Color = .accentColor
    
    var body: some View {
        Form {
            TextField("username", text: $username)
            Button("Save", action: {
                Task {
                    await saveUser()
                }
            })
        }
        .onAppear {
            username = reefVM.user?.username ?? ""
            emoji = reefVM.user?.emoji ?? ""
            color = reefVM.user?.color ?? .accentColor
        }
    }
    
    func saveUser() async {
        do {
            try await reefVM.saveUser(username: username)
            dismiss()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    EditUserView()
//}
