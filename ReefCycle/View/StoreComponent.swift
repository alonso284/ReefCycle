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
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                Text("$\(price)")
                    .font(.title2)
            }
            Spacer()
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
                .padding()
        }
    }
}

#Preview {
    StoreComponent(image: "PreviewCookHat", name: "Cook Hat", price: 200)
}
