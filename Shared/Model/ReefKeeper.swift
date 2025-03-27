//
//  ReefKeeper.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import Foundation
import CloudKit

struct ReefKeeper {
    let record:                 CKRecord
    private(set) var id:                String
    private(set) var points:            Int
    private(set) var institution:       CKRecord.Reference
    private(set) var user:              CKRecord.Reference
}

extension ReefKeeper: Identifiable, Comparable, Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id &&
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.id.localizedCompare(rhs.id) == .orderedAscending
    }
}

extension ReefKeeper {
    
    /// The record type to use when saving a contact.
    static let recordType: CKRecord.RecordType = RecordType.ReefKeeper.rawValue

    /// Populates a record with the data for this contact.
    init?(record: CKRecord) {
        guard let id = record[.reefkeeper_id] as? String,
              let points = record[.reefkeeper_points] as? Int,
              let institution = record[.reefkeeper_institution] as? CKRecord.Reference,
              let user = record[.reefkeeper_user] as? CKRecord.Reference
        else {
            return nil
        }
        
        self.init(record: record, id: id, points: points, institution: institution, user: user)
    }
}

extension CKRecord.FieldKey {
    static let reefkeeper_id        = "id"
    static let reefkeeper_points    = "points"
    static let reefkeeper_institution   = "institution"
    static let reefkeeper_user      = "user"
}
