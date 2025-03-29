//
//  ReefCycleViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit
import UIKit


@Observable class ReefCycleViewModel {
    
    private(set) var user: User?
    private(set) var institutions: [Institution]?
    private(set) var reefKeepers: [ReefKeeper]?
    
    func fetchInstitutions() async throws {
        let record = try await Config.publicDatabase.fetchAllRecords(ofType: Institution.recordType, inZone: nil)
        institutions = record.compactMap { Institution(record: $0) }
    }
    
    func fetchReefKeepers() async throws {
        let record = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        reefKeepers = record.compactMap { ReefKeeper(record: $0) }
        print(record)
    }
    
    func fetchUser() async throws {
        let userRecordID = try await Config.container.userRecordID()
        print(userRecordID.recordName)
        let record = try await Config.publicDatabase.record(for: userRecordID)
        
        guard let user = User(record: record) else { return }
        print(user.username)
        self.user = user
    }
    
    func saveUser(username: String) async throws {
        let record: CKRecord

        if let existingRecord = user?.record {
            record = existingRecord
        } else {
            let userRecordID = try await Config.container.userRecordID()
            print("Fetched userRecordID: \(userRecordID.recordName)")
            record = try await Config.publicDatabase.record(for: userRecordID)
        }

        record[.user_username] = username

        try await Config.publicDatabase.save(record)
        try await fetchUser()
    }
}
