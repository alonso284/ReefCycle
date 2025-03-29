//
//  Config.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

enum RecordType: String, Codable, CaseIterable {
    case Institution    = "Institution"
    case ReefKeeper     = "ReefKeeper"
    case ReefMaster     = "ReefMaster"
    case User           = "Users"
}

enum Config {
    static let containerIdentifier = "iCloud.com.alonso284.ReefCycle"
    static let container = CKContainer(identifier: containerIdentifier)
    static var publicDatabase: CKDatabase {container.publicCloudDatabase}
}
