//
//  PendingReefMasterViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

@Observable
class PendingReefMasterViewModel {
    private(set) var user: User
    private(set) var reefMaster: ReefMaster?
    
    init (user: User) {
        self.user = user
    }
    
    // FIXME: load from institution
    // FIXME: Not query all records (use the ones commented)
    func fetchReefMaster() async throws {
//        let reference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
//        let records = try await Config.publicDatabase.fetchCustomRecords(ofType: ReefKeeper.recordType, matching: NSPredicate(format: "user.recordName == %@", user.id), inZone: nil)
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: ReefMaster.recordType, inZone: nil)
        print(records)
        let reefMasters = records.compactMap { ReefMaster(record: $0) }
        
        guard let reefMaster = reefMasters.first(where: { $0.user.recordID == user.id })  else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(reefMaster.user)
        self.reefMaster = reefMaster
    }
    
    func createReefMaster(institution: Institution, id: String) async throws {
        let institutionReference = CKRecord.Reference(recordID: institution.id, action: .deleteSelf)
        let userReference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
        
        let reefMasterRecord = CKRecord(recordType: ReefMaster.recordType)
        reefMasterRecord[.reefmaster_id] = id
        reefMasterRecord[.reefmaster_user] = userReference
        reefMasterRecord[.reefmaster_institution] = institutionReference
        reefMasterRecord[.reefmaster_admin] = 0
        
//        let reefKeeper = try await ReefKeeper(record: reefKeeperRecord)
        let reefMasterRecordCreated = try await Config.publicDatabase.save(reefMasterRecord)
        self.reefMaster = ReefMaster(record: reefMasterRecordCreated)
//        user.reefKeeper = reefKeeper
//        print(record.recordID.recordName!)
    }
    
    
}
