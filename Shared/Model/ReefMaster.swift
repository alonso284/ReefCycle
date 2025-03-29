//
//  ReefMaster.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

struct ReefMaster {
    private let record:                 CKRecord
    private(set) var id:                String
    private(set) var admin:             Bool
    private(set) var institution:       CKRecord.Reference
    private(set) var user:              CKRecord.Reference
}

extension ReefMaster: Identifiable, Comparable, Hashable, Equatable {
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

extension ReefMaster {
    
    /// The record type to use when saving a contact.
    static let recordType: CKRecord.RecordType = RecordType.ReefMaster.rawValue

    /// Populates a record with the data for this contact.
    init?(record: CKRecord) {
        guard let id = record[.reefmaster_id] as? String,
              let institution = record[.reefmaster_institution] as? CKRecord.Reference,
              let user = record[.reefmaster_user] as? CKRecord.Reference
        else {
            return nil
        }

        let admin_rawValue = record[.reefmaster_admin] as? Int ?? 0
        let admin: Bool = admin_rawValue != 0
        
        self.init(record: record, id: id, admin: admin, institution: institution, user: user)
    }
}

extension CKRecord.FieldKey {
    static let reefmaster_id        = "id"
    static let reefmaster_admin    = "admin"
    static let reefmaster_institution   = "institution"
    static let reefmaster_user      = "user"
}
