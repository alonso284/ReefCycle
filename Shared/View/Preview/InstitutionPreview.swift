//
//  InstitutionPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct InstitutionPreview: View {
    let institutionVM: InstitutionViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: institutionVM.institution.logo.fileURL){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            Text(institutionVM.institution.code)
        }
    }
}

//#Preview {
//    InstitutionPreview()
//}
