//
//  ReefKeepViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit

@Observable
class OwnedReefKeeperViewModel {
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
    
    func selectSkin(skin: Skin) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_skin] = skin.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }

    
    func selectHat(hat: Hat) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_hat] = hat.rawValue
        
        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        print("updating hat")
        self.reefKeeper = newReefKeeper
    }
    
    func selectTool(tool: Tool) async throws {
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
    func load() async throws {
        let newReefKeeperRecord = reefKeeper.record
//        newReefKeeperRecord[.reefkeeper_tool] = tool.rawValue

        let savedReefKeeperRecord = try await Config.publicDatabase.save(newReefKeeperRecord)
        guard let newReefKeeper = ReefKeeper(record: savedReefKeeperRecord) else { return }
        self.reefKeeper = newReefKeeper
    }
    
}
