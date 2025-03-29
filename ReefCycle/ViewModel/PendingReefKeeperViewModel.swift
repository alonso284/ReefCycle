//
//  ReefKeeperViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

@Observable
class PendingReefKeeperViewModel {
    private(set) var user: User
    private(set) var reefKeeper: ReefKeeper?
    
    init (user: User) {
        self.user = user
    }
    
    // FIXME: load from institution
    // FIXME: Not query all records (use the ones commented)
    func fetchReefKeeper() async throws {
//        let reference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
//        let records = try await Config.publicDatabase.fetchCustomRecords(ofType: ReefKeeper.recordType, matching: NSPredicate(format: "user.recordName == %@", user.id), inZone: nil)
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        print(records)
        let reefKeepers = records.compactMap { ReefKeeper(record: $0) }
        
        guard let reefKeeper = reefKeepers.first(where: { $0.user.recordID == user.id })  else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(reefKeeper.user)
        self.reefKeeper = reefKeeper
    }
    
    func createReefKeeper(institution: Institution, id: String) async throws {
        let institutionReference = CKRecord.Reference(recordID: institution.id, action: .deleteSelf)
        let userReference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
        
        let reefKeeperRecord = CKRecord(recordType: ReefKeeper.recordType)
        reefKeeperRecord[.reefkeeper_id] = id
        reefKeeperRecord[.reefkeeper_user] = userReference
        reefKeeperRecord[.reefkeeper_institution] = institutionReference
        reefKeeperRecord[.reefkeeper_points] = 0
        
//        let reefKeeper = try await ReefKeeper(record: reefKeeperRecord)
        let reefKeeperRecordCreated = try await Config.publicDatabase.save(reefKeeperRecord)
        reefKeeper = ReefKeeper(record: reefKeeperRecordCreated)
//        user.reefKeeper = reefKeeper
//        print(record.recordID.recordName!)
    }
    
    
}
