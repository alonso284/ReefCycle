//
//  ReefMasterViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 26/03/25.
//

import Foundation

@Observable
class ReefMasterViewModel {
    private(set) var reefMaster: ReefMaster
    
    init(reefKeeper: ReefMaster) {
        self.reefMaster = reefKeeper
    }
    
    func getInstitution() async throws -> Institution? {
        let record = try await Config.publicDatabase.record(for: reefMaster.institution.recordID)
        guard let institution = Institution(record: record) else {
            print("Cloudnt load Institution")
            return nil
        }
        print(institution.code)
        return institution
    }
    
    func getUser() async throws -> User? {
        let record = try await Config.publicDatabase.record(for: reefMaster.user.recordID)
        guard let user = User(record: record) else {
            print("Cloudnt load user")
            return nil
        }
        print(user.username)
        return user
    }
}
