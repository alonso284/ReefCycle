//
//  ReefKeeperViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import Foundation

@Observable
class PendingReefKeeperViewModel {
    private(set) var user: User
    private(set) var reefKeeper: ReefKeeper?
    
    init (user: User) {
        self.user = user
    }
    
    // FIXME: Look if it has one that is reference
    // Look for one with the same ID
    // Create one with id
    func fetchReefKeeper() async throws {
        print("HERE")
        let record = try await Config.publicDatabase.record(for: user.reefKeeper!.recordID)
        guard let reefKeeper = ReefKeeper(record: record) else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(reefKeeper.id)
        self.reefKeeper = reefKeeper
    }
    
//    func createReefKeeper() async throws {
//        print("HERE")
//        let reefKeeper = ReefKeeper(id: UUID().uuidString, userID: user.record.recordID.recordName!)
//        let record = try await Config.publicDatabase.save(reefKeeper)
//        user.reefKeeper = reefKeeper
//        print(record.recordID.recordName!)
//    }
    
    
}
