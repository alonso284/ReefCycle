//
//  UserView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct UserView: View {
    let user: User
    
    var body: some View {
        Text(user.username)
    }
}

//#Preview {
//    UserView()
//}
