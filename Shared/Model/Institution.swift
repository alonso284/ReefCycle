//
//  College.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit
import UIKit

struct Institution {
    private let record:                 CKRecord
    private(set) var name:              String
    private(set) var code:              String
    private(set) var logo:              CKAsset
    private(set) var location:          CLLocation?
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
              let name = record[.institution_name] as? String,
              let logo = record[.institution_logo] as? CKAsset,
              let location = record[.institution_location] as? CLLocation?
        else {
            return nil
        }
        
        print(record)
        self.init(record: record, name: name, code: code, logo: logo, location: location)
    }
}

extension CKRecord.FieldKey {
    static let institution_code    = "code"
    static let institution_name    = "name"
    static let institution_logo    = "logo"
    static let institution_location = "location"
}
