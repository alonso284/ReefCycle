//
//  InstitutionView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 23/03/25.
//

import SwiftUI

struct InstitutionView: View {
    let institutionVM: InstitutionViewModel
    var body: some View {
        Text(institutionVM.institution.code)
    }
}

//#Preview {
//    InstitutionView()
//}
