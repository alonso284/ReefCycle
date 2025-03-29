//
//  ReefKeeperViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

@Observable
class ReefKeeperViewModel {
    private(set) var reefKeeper: ReefKeeper
    private(set) var user: User?
    private(set) var institution: Institution?
    
    func fetchInstitution() async throws {
        let record = try await Config.publicDatabase.record(for: reefKeeper.institution.recordID)
        guard let institution = Institution(record: record) else {
            print("Cloudnt load Institution")
            return
        }
        print(institution.code)
        self.institution = institution
    }
    
    init(reefKeeper: ReefKeeper) {
        self.reefKeeper = reefKeeper
    }
    
    func fetchUser() async throws {
        let record = try await Config.publicDatabase.record(for: reefKeeper.user.recordID)
        guard let user = User(record: record) else {
            print("Cloudnt load user")
            return
        }
        self.user = user
    }
    
    func load() async throws {
        let reefKeeperRecordCreated = try await Config.publicDatabase.save(reefKeeper.record)
        if let reefKeeper = ReefKeeper(record: reefKeeperRecordCreated)
        {
            self.reefKeeper = reefKeeper
        }
    }
    
}
