//
//  InstitutionView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import CloudKit

struct InstitutionView: View {
    let institution: Institution
    var body: some View {
        Text(institution.code)
    }
}

#Preview {
    let record = CKRecord(recordType: RecordType.Institution.rawValue)
    record[.institution_code] = "ITESM"
    
//    record[.institution_logo] = "
    record[.institution_name] = "Tecnologico de Monterrey"
//    record[.institution_location]
    if let institution = Institution(record: record) {
        return InstitutionView(institution: institution)
    } else {
        return EmptyView()
    }
}
