//
//  ReefKeepViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import Foundation

@Observable
class ReefKeeperViewModel {
    private(set) var reefKeeper: ReefKeeper
    
    init(reefKeeper: ReefKeeper) {
        self.reefKeeper = reefKeeper
    }
    
    func getInstitution() async throws -> Institution? {
        let record = try await Config.publicDatabase.record(for: reefKeeper.institution.recordID)
        guard let institution = Institution(record: record) else {
            print("Cloudnt load Institution")
            return nil
        }
        print(institution.code)
        return institution
    }
    
    func getUser() async throws -> User? {
        let record = try await Config.publicDatabase.record(for: reefKeeper.user.recordID)
        guard let user = User(record: record) else {
            print("Cloudnt load user")
            return nil
        }
        print(user.username)
        return user
    }
}
