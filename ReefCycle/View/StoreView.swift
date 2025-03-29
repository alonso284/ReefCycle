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
    
    let reefKeeperVM: OwnedReefKeeperViewModel
    
    var body: some View {
        NavigationStack {
            List {
                skinsView
                hatsView
                toolsView
            }
            .toolbar {
                NavigationLink("Edit", destination: {
                    EditUserView()
                })
            }
            .navigationTitle("Store")
        }
    }
    
    var skinsView: some View {
        Section("Skins") {
            ForEach(Skin.allCases, id: \.self) { skin in
                let isOwned = skins.contains { $0.skin == skin }

                Button(action: {
                    Task {
                        await buySkin(skin: skin)
                    }
                }) {
                    Text("\(skin.rawValue.capitalized) - \(skin.price) - \(isOwned ? "Owned" : "Not Owned")")
                }
                .disabled(isOwned)
            }
        }
    }
    
    var hatsView: some View {
        Section("Hats") {
            ForEach(Hat.allCases, id: \.self) { hat in
                let isOwned = hats.contains { $0.hat == hat }

                Button(action: {
                    Task {
                        await buyHat(hat: hat)
                    }
                }) {
                    Text("\(hat.rawValue.capitalized) - \(hat.price) - \(isOwned ? "Owned" : "Not Owned")")
                }
                .disabled(isOwned)
            }
        }
    }

    var toolsView: some View {
        Section("Tools") {
            ForEach(Tool.allCases, id: \.self) { tool in
                let isOwned = tools.contains { $0.tool == tool }

                Button(action: {
                    Task {
                        await buyTool(tool: tool)
                    }
                }) {
                    Text("\(tool.rawValue.capitalized) - \(tool.price) - \(isOwned ? "Owned" : "Not Owned")")
                }
                .disabled(isOwned)
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

//#Preview {
//    StoreView()
//}
