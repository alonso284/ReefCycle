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
    
    // Add animation state
    @State private var isHovering: Item? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        let owned = isOwned(item)
                        let isHoveringThis = isHovering == item
                        
                        ZStack {
                            // Item card background with dynamic elevation
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(owned ? Color.green.opacity(0.3) : Color.accentColor.opacity(0.2), lineWidth: 1.5)
                                )
                            
                            Button {
                                if !owned {
                                    Task {
                                        await action(item)
                                    }
                                }
                            } label: {
                                StoreComponent(
                                    image: previewName(item),
                                    name: itemName(item),
                                    price: price(item)
                                )
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .disabled(owned)
                            
                            // Overlay for owned items
                            if owned {
                                VStack {
                                    Spacer()
                                    Text("Adquirido")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.green)
                                        .cornerRadius(12)
                                    Spacer().frame(height: 16)
                                }
                            }
                        }
                        .frame(width: 160, height: 210)
                        .padding(.vertical, 8)
                        .onHover { hovering in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isHovering = hovering ? item : nil
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
}

// Custom button style for nicer touch feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
