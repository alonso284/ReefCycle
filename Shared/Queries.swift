//
//  Queries.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

extension CKDatabase {
    /// Generic fetch function for CloudKit records
    private func fetchRecords (
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        inZone zoneID: CKRecordZone.ID?
    ) async throws -> [CKRecord] {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let result = try await self.records(
            matching: query,
            inZoneWith: zoneID,
            resultsLimit: CKQueryOperation.maximumResults
        )
        return result.matchResults.compactMap { try? $0.1.get() }
    }
    
    /// Fetches all records of a given type (default predicate = `true`)
    func fetchAllRecords(ofType recordType: CKRecord.RecordType, inZone zoneID: CKRecordZone.ID?) async throws -> [CKRecord] {
        try await fetchRecords(recordType: recordType, predicate: NSPredicate(value: true), inZone: zoneID)
    }
    
    /// Fetches records of a given type with a custom predicate
    func fetchCustomRecords(ofType recordType: CKRecord.RecordType, matching predicate: NSPredicate, inZone zoneID: CKRecordZone.ID?) async throws -> [CKRecord] {
        try await fetchRecords(recordType: recordType, predicate: predicate, inZone: zoneID)
    }
}
