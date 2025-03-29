//
//  StoreView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import SwiftData

struct StoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var hats: [OwnedHat]
    @Query var skins: [OwnedSkin]
    @Query var tools: [OwnedTool]
    
    @Binding var reefKeeperVM: PendingReefKeeperViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionCarousel(title: "Ropa", items: Skin.allCases, isOwned: { skin in
                        skins.contains { $0.skin == skin }
                    }, action: { skin in
                        await buySkin(skin: skin)
                    }, previewName: { skin in
                        "Preview" + skin.rawValue
                    }, itemName: { $0.rawValue }, price: { $0.price })

                    SectionCarousel(title: "Gorros", items: Hat.allCases, isOwned: { hat in
                        hats.contains { $0.hat == hat }
                    }, action: { hat in
                        await buyHat(hat: hat)
                    }, previewName: { hat in
                        "Preview" + hat.rawValue
                    }, itemName: { $0.rawValue }, price: { $0.price })

                    SectionCarousel(title: "Herramientas", items: Tool.allCases, isOwned: { tool in
                        tools.contains { $0.tool == tool }
                    }, action: { tool in
                        await buyTool(tool: tool)
                    }, previewName: { tool in
                        "Preview" + tool.rawValue
                    }, itemName: { $0.rawValue }, price: { $0.price })
                }
                .padding(.vertical)
            }
            .navigationTitle("Tienda")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.accentColor)
                        Text("\(reefKeeperVM.reefKeeper?.available_points ?? 0)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                    )
                }
            }

        }
    }

    func buyHat(hat: Hat) async {
        do {
            try await reefKeeperVM.usePoints(points: hat.price)
            modelContext.insert(OwnedHat(hat: hat))
        } catch {
            print("Failed to buy hat: \(error)")
        }
    }

    func buySkin(skin: Skin) async {
        do {
            try await reefKeeperVM.usePoints(points: skin.price)
            modelContext.insert(OwnedSkin(skin: skin))
        } catch {
            print("Failed to buy skin: \(error)")
        }
    }

    func buyTool(tool: Tool) async {
        do {
            try await reefKeeperVM.usePoints(points: tool.price)
            modelContext.insert(OwnedTool(tool: tool))
        } catch {
            print("Failed to buy tool: \(error)")
        }
    }
}
