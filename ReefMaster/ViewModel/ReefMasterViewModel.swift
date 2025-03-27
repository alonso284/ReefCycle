//
//  ReefMasterViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 26/03/25.
//

import Foundation

@Observable
class ReefMasterViewModel {
    private(set) var reefMaster: ReefMaster
    private(set) var reefKeepers: [ReefKeeper]?
    
    init(reefKeeper: ReefMaster) {
        self.reefMaster = reefKeeper
    }
    
    func getInstitution() async throws -> Institution? {
        let record = try await Config.publicDatabase.record(for: reefMaster.institution.recordID)
        guard let institution = Institution(record: record) else {
            print("Cloudnt load Institution")
            return nil
        }
        print(institution.code)
        return institution
    }
    
    func getUser() async throws -> User? {
        let record = try await Config.publicDatabase.record(for: reefMaster.user.recordID)
        guard let user = User(record: record) else {
            print("Cloudnt load user")
            return nil
        }
        print(user.username)
        return user
    }
    
    func fetchReefKeepers() async throws {
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        print(records)
        let reefKeepers = records.compactMap { ReefKeeper(record: $0) }

        self.reefKeepers = reefKeepers.filter({ $0.institution.recordID == self.reefMaster.institution.recordID })
    }
    
    func fetchReefKeeper(institution: Institution, id: String) async throws -> ReefKeeper? {
        let records = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        print(records)
        let reefKeepers = records.compactMap { ReefKeeper(record: $0) }
        
        guard let reefKeeper = reefKeepers.first(where: { $0.id == id && $0.institution.recordID == institution.id })  else {
            print("Cloudnt load reefkeeper")
            return nil
        }
        
        return reefKeeper
    }
    
    func registerPoints(reefKeeper: ReefKeeper, points: Int) async throws{
//        print(reefKeeper.user)
//        self.reefKeeper = reefKeeper
        
        let newReefKeeperRecord = reefKeeper.record
        newReefKeeperRecord[.reefkeeper_points] = points + reefKeeper.points
        
        try await Config.publicDatabase.save(newReefKeeperRecord)
//        return ReefKeeper(record: savedReefKeeperRecord)
    }
}
