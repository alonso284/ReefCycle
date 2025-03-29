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
    
    let reefKeeperVM: ReefKeeperViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Skins") {
                    ForEach(Skin.allCases, id: \.self) { skin in
                        let isOwned = skins.contains(where: { $0.skin == skin })

                        Text("\(skin.rawValue.capitalized) - \(skin.price) - \(isOwned ? "Owned" : "Not Owned")")
                            .onTapGesture {
                                Task {
                                    if isOwned {
                                        do {
                                            try await reefKeeperVM.selectSkin(skin: skin)
                                        } catch {
                                            print("Failed to select skin: \(error)")
                                        }
                                    } else {
                                        await buySkin(skin: skin)
                                    }
                                }
                            }
                    }
                }

                Section("Hats") {
                    ForEach(Hat.allCases, id: \.self) { hat in
                        let isOwned = hats.contains(where: { $0.hat == hat })

                        Text("\(hat.rawValue.capitalized) - \(hat.price) - \(isOwned ? "Owned" : "Not Owned")")
                            .onTapGesture {
                                Task {
                                    if isOwned {
                                        do {
                                            try await reefKeeperVM.selectHat(hat: hat)
                                        } catch {
                                            print("Failed to select hat: \(error)")
                                        }
                                    } else {
                                        await buyHat(hat: hat)
                                    }
                                }
                            }
                    }
                }

                Section("Tools") {
                    ForEach(Tool.allCases, id: \.self) { tool in
                        let isOwned = tools.contains(where: { $0.tool == tool })

                        Text("\(tool.rawValue.capitalized) - \(tool.price) - \(isOwned ? "Owned" : "Not Owned")")
                            .onTapGesture {
                                Task {
                                    if isOwned {
                                        do {
                                            try await reefKeeperVM.selectTool(tool: tool)
                                        } catch {
                                            print("Failed to select tool: \(error)")
                                        }
                                    } else {
                                        await buyTool(tool: tool)
                                    }
                                }
                            }
                    }
                }
            }
            
            .navigationTitle("Store")
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
