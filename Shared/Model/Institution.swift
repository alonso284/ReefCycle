//
//  College.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import Foundation
import CloudKit

struct Institution {
    private let record:                 CKRecord
    private(set) var name:              String
    private(set) var code:              String
}

extension Institution: Identifiable, Comparable, Hashable, Equatable {
   var id: CKRecord.ID { self.record.recordID }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name.localizedCompare(rhs.name) == .orderedAscending
    }
}

extension Institution {
    
    /// The record type to use when saving a contact.
    static let recordType: CKRecord.RecordType = RecordType.Institution.rawValue

    /// Populates a record with the data for this contact.
    init?(record: CKRecord) {
        guard let code = record[.institution_code] as? String,
              let name = record[.institution_name] as? String
        else {
            return nil
        }
        
        self.init(record: record, name: name, code: code)
    }
}

extension CKRecord.FieldKey {
    static let institution_code    = "code"
    static let institution_name    = "name"
}
