//
//  InstitutionPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ProfileInstitutionPreview: View {
    let institution: Institution
    
    var body: some View {
        HStack{
            Spacer()
            AsyncImage(url: institution.logo.fileURL){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            } placeholder: {
                ProgressView()
            }
            
            Text(institution.code)
                .font(.headline)
            Spacer()
            
        }
        .padding(.trailing, 150)
    }
}

struct InstitutionPreview: View {
    let institution: Institution
    
    var body: some View {
        HStack {
            AsyncImage(url: institution.logo.fileURL){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
            }
            .padding(.trailing, 20)
            Text(institution.code)
                .font(.title2)
        }
    }
}



