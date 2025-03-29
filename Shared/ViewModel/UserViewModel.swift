//
//  ReefUserViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation

@Observable
class UserViewModel {
    private(set) var user: User
    
    init(user: User) {
        self.user = user
    }
}
