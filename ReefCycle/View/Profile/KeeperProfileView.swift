//
//  ProfileView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct KeeperProfileView: View {
    let reefKeeperVM: OwnedReefKeeperViewModel
    @State var institution: Institution?
    @State var user: User?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(reefKeeperVM.reefKeeper.id)
                Text(String(reefKeeperVM.reefKeeper.points))
                
                if let institution {
                    let instituionVM = InstitutionViewModel(institution: institution)
                    InstitutionView(institutionVM: instituionVM)
                } else {
                    ProgressView()
                        .task {
                            await loadInstitution()
                        }
                }
                
                if let user {
                    let userVM = UserViewModel(user: user)
                    UserView(userVM: userVM)
                    if let date = user.record.creationDate {
                        Text("Member since \(date.description)")
                    }
                }else {
                    ProgressView()
                        .task {
                            await loadUser()
                        }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                NavigationLink("Edit", destination: {
                    EditUserView()
                })
            }
        }
    }
    
    func loadInstitution() async {
        do {
            institution = try await reefKeeperVM.getInstitution()
        } catch {
            print(error)
        }
    }
    
    func loadUser() async {
        do {
            user = try await reefKeeperVM.getUser()
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    ProfileView()
//}
