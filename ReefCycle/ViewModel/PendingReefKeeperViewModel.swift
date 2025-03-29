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
    private(set) var institution: Institution?
    
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
        
        guard let reefKeeper = reefKeepers.first(where: { $0.user?.recordID == user.id })  else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(reefKeeper.user)
        self.reefKeeper = reefKeeper
    }
    
    func fetchInstitution() async throws {
//        let reference = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
//        let records = try await Config.publicDatabase.fetchCustomRecords(ofType: ReefKeeper.recordType, matching: NSPredicate(format: "user.recordName == %@", user.id), inZone: nil)
        guard let reefKeeper else { return }
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: Institution.recordType, inZone: nil)
        print(records)
        let institutions = records.compactMap { Institution(record: $0) }
        
        guard let institution = institutions.first(where: { $0.id == reefKeeper.institution.recordID })  else {
            print("Cloudnt load reefkeeper")
            return
        }
        print(institution.name)
        self.institution = institution
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
    
    func getInstitution() async throws -> Institution? {
        guard let reefKeeper else { return nil }
        let record = try await Config.publicDatabase.record(for: reefKeeper.institution.recordID)
        guard let institution = Institution(record: record) else {
            print("Cloudnt load Institution")
            return nil
        }
        print(institution.code)
        return institution
    }
    
    func getUser() async throws -> User? {
        guard let reefKeeper else { return nil }
        guard let userRef = reefKeeper.user else { return nil }
        let record = try await Config.publicDatabase.record(for: userRef.recordID)
        guard let user = User(record: record) else {
            print("Cloudnt load user")
            return nil
        }
        print(user.username)
        return user
    }
    
    func enoughPoints(points: Int) -> Bool? {
        guard let reefKeeper else { return nil }
        return reefKeeper.used + points <= reefKeeper.points
    }
    
    func usePoints(points: Int) async throws {
//        print(reefKeeper.user)
//        self.reefKeeper = reefKeeper
        guard let reefKeeper else { return }
        guard enoughPoints(points: points) == true else { throw CKError(.invalidArguments) }
        
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_used] = points + reefKeeper.used
        
        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
//        return ReefKeeper(record: savedReefKeeperRecord)
    }
    
    func selectSkin(skin: Skin) async throws {
        guard let reefKeeper else { return }
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_skin] = skin.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }

    
    func selectHat(hat: Hat) async throws {
        guard let reefKeeper else { return }
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_hat] = hat.rawValue
        
        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        print("updating hat")
        self.reefKeeper = newReefKeeper
    }
    
    func selectTool(tool: Tool) async throws {
        guard let reefKeeper else { return }
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
    func load() async throws {
        guard let reefKeeper else { return }
        let newReefKeeperRecord = reefKeeper.record
//        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
}
