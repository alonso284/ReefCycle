//
//  ReefKeeperViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

@Observable
class PendingReefKeeperViewModel {
    private(set) var user: User
    private(set) var reefKeeper: ReefKeeper?
    var ownedReefKeeperViewModel: OwnedReefKeeperViewModel? {
        if let reefKeeper {
            return OwnedReefKeeperViewModel(reefKeeper: reefKeeper)
        } else {
            return nil
        }
    }
    
    struct OwnedReefKeeperViewModel {
        private(set) var reefKeeper: ReefKeeper
        
        init(reefKeeper: ReefKeeper) {
            self.reefKeeper = reefKeeper
        }
        
        func getInstitution() async throws -> Institution? {
            let record = try await Config.publicDatabase.record(for: reefKeeper.institution.recordID)
            guard let institution = Institution(record: record) else {
                print("Cloudnt load Institution")
                return nil
            }
            print(institution.code)
            return institution
        }
        
        func getUser() async throws -> User? {
            let record = try await Config.publicDatabase.record(for: reefKeeper.user.recordID)
            guard let user = User(record: record) else {
                print("Cloudnt load user")
                return nil
            }
            print(user.username)
            return user
        }
        
    }
    
    func enoughPoints(points: Int) -> Bool {
        return reefKeeper.used + points <= reefKeeper.points
    }
    
    func usePoints(points: Int) async throws {
//        print(reefKeeper.user)
//        self.reefKeeper = reefKeeper
        guard enoughPoints(points: points) else { throw CKError(.invalidArguments) }
        
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_used] = points + reefKeeper.used
        
        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
//        return ReefKeeper(record: savedReefKeeperRecord)
    }
    
    mutating func selectSkin(skin: Skin) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_skin] = skin.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }

    
    mutating func selectHat(hat: Hat) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_hat] = hat.rawValue
        
        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        print("updating hat")
        self.reefKeeper = newReefKeeper
    }
    
    mutating func selectTool(tool: Tool) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
    mutating func load() async throws {
        let newReefKeeperRecord = reefKeeper.record
//        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
    init (user: User) {
        self.user = user
    }
    
    // FIXME: load from institution
    // FIXME: Not query all records (use the ones commented)
    func fetchReefKeeper() async throws {
//        let reference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
//        let records = try await Config.publicDatabase.fetchCustomRecords(ofType: ReefKeeper.recordType, matching: NSPredicate(format: "user.recordName == %@", user.id), inZone: nil)
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        print(records)
        let reefKeepers = records.compactMap { ReefKeeper(record: $0) }
        
        guard let reefKeeper = reefKeepers.first(where: { $0.user.recordID == user.id })  else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(reefKeeper.user)
        self.reefKeeper = reefKeeper
    }
    
    func createReefKeeper(institution: Institution, id: String) async throws {
        let institutionReference = CKRecord.Reference(recordID: institution.id, action: .deleteSelf)
        let userReference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
        
        let reefKeeperRecord = CKRecord(recordType: ReefKeeper.recordType)
        reefKeeperRecord[.reefkeeper_id] = id
        reefKeeperRecord[.reefkeeper_user] = userReference
        reefKeeperRecord[.reefkeeper_institution] = institutionReference
        reefKeeperRecord[.reefkeeper_points] = 0
        reefKeeperRecord[.reefkeeper_used] = 0
        
//        let reefKeeper = try await ReefKeeper(record: reefKeeperRecord)
        let reefKeeperRecordCreated = try await Config.publicDatabase.save(reefKeeperRecord)
        reefKeeper = ReefKeeper(record: reefKeeperRecordCreated)
//        user.reefKeeper = reefKeeper
//        print(record.recordID.recordName!)
    }
    
    
}
