//
//  User.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import SwiftUI
import CloudKit

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r, g, b: Double
        switch hexSanitized.count {
        case 6:
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b)
    }
}

struct User {
    let record:                     CKRecord
    private(set) var username:      String
    private(set) var emoji:         String
    private(set) var color:         Color
    
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
              let reefKeeper = record[.user_reefKeeper] as? CKRecord.Reference?,
              let colorHex = record[.user_colorHex] as? String,
              let color = Color(hex: colorHex),
              let emoji = record[.user_emoji] as? String
//              let tags_rawValues = record[.user_tags] as? [String]?
        else {
            return nil
        }
        
//        let tags = tags_rawValues?.compactMap { Activity.Tag(rawValue: $0) } ?? []
//        guard let color = colorHex.toColor() else { return nil }
        print("GOT ALL VALUES")
        self.init(record: record, username: username, emoji: emoji, color: color, reefKeeper: reefKeeper)
    }
}
//
extension CKRecord.FieldKey {
    static let user_username        = "username"
    static let user_reefKeeper      = "reefKeeper"
    static let user_reefMaster      = "reefMaster"
    static let user_colorHex        = "color"
    static let user_emoji           = "emoji"
//    static let user_tags            = "tags"
}
