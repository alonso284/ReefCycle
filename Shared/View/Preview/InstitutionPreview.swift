//
//  InstitutionPreview.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct InstitutionPreview: View {
    let institution: Institution
    
    var body: some View {
        HStack {
            AsyncImage(url: institution.logo.fileURL){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } placeholder: {
                ProgressView()
            }
            .padding(.trailing, 20)
            Text(institution.code)
                .font(.title2)
        }
    }
}

struct NumInstitutionPreview: View {
    let institution: Institution
    let num: Int
    
    var body: some View {
        HStack {
            if num > 0 {
                Text("\(num)")
                    .font(.largeTitle)
                    .padding(.horizontal)
            }
            
            AsyncImage(url: institution.logo.fileURL){ image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            .padding(.trailing)
            
            Text(institution.name)
                .font(.title2)
            
            Text("(\(institution.code))")
        }
    }
}

