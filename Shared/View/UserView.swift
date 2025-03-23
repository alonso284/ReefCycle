//
//  UserView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import SwiftUI

struct UserView: View {
    let userVM: UserViewModel
    
    var body: some View {
        Text(userVM.user.username)
    }
}

//#Preview {
//    UserView()
//}
