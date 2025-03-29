//
//  SectionCarousel.swift
//  ReefCycle
//
//  Created by Sofia Sandoval on 3/29/25.
//

import Foundation
import SwiftUI

struct SectionCarousel<Item: Hashable>: View {
    let title: String
    let items: [Item]
    let isOwned: (Item) -> Bool
    let action: (Item) async -> Void
    let previewName: (Item) -> String
    let itemName: (Item) -> String
    let price: (Item) -> Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        let owned = isOwned(item)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .cornerRadius(21)

                            Button {
                                Task {
                                    await action(item)
                                }
                            } label: {
                                StoreComponent(
                                    image: previewName(item),
                                    name: itemName(item),
                                    price: price(item)
                                )
                            }
                            .disabled(owned)
                            .opacity(owned ? 0.5 : 1.0)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 6)
                        .frame(width: 160, height: 200) // Adjusted to match inner content
                        .padding(.vertical, 4)
                        .cornerRadius(21)


                       
                    }
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
}
