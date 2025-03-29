//
//  ReefKeeper.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

struct ReefKeeper {
    let record:                 CKRecord
    private(set) var id:                String
    private(set) var points:            Int
    private(set) var used:              Int
    private(set) var skin:              Skin?
    private(set) var hat:               Hat?
    private(set) var tool:              Tool?
    private(set) var institution:       CKRecord.Reference
    private(set) var user:              CKRecord.Reference?
    
    var available_points: Int {
        return self.points - self.used
    }
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
              let used = record[.reefkeeper_used] as? Int,
              let rawSkin = record[.reefkeeper_skin] as? String?,
              let rawTool = record[.reefkeeper_tool] as? String?,
              let rawHat  = record[.reefkeeper_hat] as? String?,
              let institution = record[.reefkeeper_institution] as? CKRecord.Reference,
              let user = record[.reefkeeper_user] as? CKRecord.Reference?
              
        else {
            return nil
        }
        
        
        var skin: Skin?
        if let rawSkin {
            skin = Skin(rawValue: rawSkin)
        }

        var hat: Hat?
        if let rawHat {
            hat = Hat(rawValue: rawHat)
        }

        var tool: Tool?
        if let rawTool {
            tool = Tool(rawValue: rawTool)
        }
        
        self.init(record: record, id: id, points: points, used: used, skin: skin, hat: hat, tool: tool, institution: institution, user: user)
    }
}

extension CKRecord.FieldKey {
    static let reefkeeper_id        = "id"
    static let reefkeeper_points    = "points"
    static let reefkeeper_used      = "used"
    static let reefkeeper_skin      = "skin"
    static let reefkeeper_hat       = "hat"
    static let reefkeeper_tool       = "tool"
    static let reefkeeper_institution   = "institution"
    static let reefkeeper_user      = "user"
}
