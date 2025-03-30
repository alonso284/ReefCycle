//
//  ReefCycleViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import Foundation
import CloudKit
import UIKit


@Observable
class ReefCycleViewModel {
    
    private(set) var user: User?
    private(set) var institutions: [Institution]?
    private(set) var reefKeepers: [ReefKeeper]?
    private(set) var users: [User]?
    
    func fetchInstitutions() async throws {
        let record = try await Config.publicDatabase.fetchAllRecords(ofType: Institution.recordType, inZone: nil)
        institutions = record.compactMap { Institution(record: $0) }
    }
    
    func fetchUsers() async throws {
        let record = try await Config.publicDatabase.fetchAllRecords(ofType: User.recordType, inZone: nil)
        users = record.compactMap { User(record: $0) }
    }
    
    
    var stats:[UniversityStat]? {
        guard let institutions, let reefKeepers else { return nil }

        let statsDict = reefKeepers.reduce(into: [String: Int]()) { result, reefKeeper in
            guard let institutionName = institutions.first(where: {
                $0.id == reefKeeper.institution.recordID
            })?.code else {
                return
            }

            result[institutionName, default: 0] += reefKeeper.points
        }

        let stats = statsDict.map { UniversityStat(name: $0.key, value: $0.value) }
        return stats
    }
    
    func impact(institution: Institution) -> Int {
        return reefKeepers?.reduce(into: 0) { result, reefKeeper in
            if reefKeeper.institution.recordID == institution.id {
                result += reefKeeper.points
            }
        } ?? 0
    }
    
    var sortedInsitutionsByImpact: [Institution]? {
        guard let institutions else { return nil }

        return institutions.sorted {
            impact(institution: $0) > impact(institution: $1)
        }
    }
    
    func user(from reference: CKRecord.Reference) async throws -> User? {
        let userRecordID = reference.recordID

        do {
            let record = try await Config.publicDatabase.record(for: userRecordID)
            print(record)
            let user = User(record: record)
            print(user)
            print("YUP")
            return user
        } catch {
            print("Failed to fetch user record: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchReefKeepers() async throws {
        let record = try await Config.publicDatabase.fetchAllRecords(ofType: ReefKeeper.recordType, inZone: nil)
        reefKeepers = record.compactMap { ReefKeeper(record: $0) }
        print(record)
    }
    
    func fetchUser() async throws {
        let userRecordID = try await Config.container.userRecordID()
        print(userRecordID.recordName)
        let record = try await Config.publicDatabase.record(for: userRecordID)
        
        guard let user = User(record: record) else { return }
        print(user.username)
        self.user = user
    }
    
    func saveUser(username: String) async throws {
        let record: CKRecord

        if let existingRecord = user?.record {
            record = existingRecord
        } else {
            let userRecordID = try await Config.container.userRecordID()
            print("Fetched userRecordID: \(userRecordID.recordName)")
            record = try await Config.publicDatabase.record(for: userRecordID)
        }

        record[.user_username] = username

        try await Config.publicDatabase.save(record)
        try await fetchUser()
    }
}
