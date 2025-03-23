//
//  User.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 22/03/25.
//

import Foundation
import CloudKit

struct User {
    let record:                  CKRecord
    private(set) var username:           String
//    private(set) points:             Int
//    private(set) emoji:              String
    
    private(set) var reefKeeper:         CKRecord.Reference?
    private(set) var reefMaster:         CKRecord.Reference?
    

}

extension User: Identifiable, Comparable, Hashable, Equatable {
   var id: CKRecord.ID { self.record.recordID }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.username.localizedCompare(rhs.username) == .orderedAscending
    }
}

extension User {
    
    /// The record type to use when saving a contact.
    static let recordType: CKRecord.RecordType = RecordType.User.rawValue

    /// Populates a record with the data for this contact.
    init?(record: CKRecord) {
        guard let username = record[.user_username] as? String,
              let reefKeeper = record[.user_reefKeeper] as? CKRecord.Reference?
//              let colorHex = record[.user_colorHex] as? String,
//              let emoji = record[.user_emoji] as? String,
//              let tags_rawValues = record[.user_tags] as? [String]?
        else {
            return nil
        }
        
//        let tags = tags_rawValues?.compactMap { Activity.Tag(rawValue: $0) } ?? []
//        guard let color = colorHex.toColor() else { return nil }
        
        self.init(record: record, username: username, reefKeeper: reefKeeper)
    }
}
//
extension CKRecord.FieldKey {
    static let user_username        = "username"
    static let user_reefKeeper      = "reefKeeper"
    static let user_reefMaster      = "reefMaster"
//    static let user_colorHex        = "colorHex"
//    static let user_emoji           = "emoji"
//    static let user_tags            = "tags"
}
