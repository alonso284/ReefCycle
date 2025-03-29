//
//  StoreComponent.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 29/03/25.
//

import SwiftUI

struct StoreComponent: View {
    var image: String
    var name: String
    var price: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .clipped()

            Text(name.capitalized)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)

            Text("$\(price)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 140, height: 180)
        .padding(8)
    }
}
