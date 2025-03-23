//
//  CollegeViewModel.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import Foundation
import CloudKit

@Observable
class InstitutionViewModel {
    private(set) var institution: Institution
    
    init(institution: Institution) {
        self.institution = institution
    }
}
