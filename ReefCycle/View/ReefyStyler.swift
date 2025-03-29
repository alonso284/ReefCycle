//
//  ReefyStyler.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI
import SwiftData

struct ReefyStyler: View {
    @Environment(\.modelContext) private var modelContext
    @Query var hats: [OwnedHat]
    @Query var skins: [OwnedSkin]
    @Query var tools: [OwnedTool]
    
    @Binding var pendingReefKeeperVM : PendingReefKeeperViewModel
//    var reefKeeperVM : PendingReefKeeperViewModel.OwnedReefKeeperViewModel? {
//        pendingReefKeeperVM.ownedReefKeeperViewModel
//    }
    
    var body: some View {
        List {
            skinPicker
            hatPicker
            toolPicker
        }
    }
    
    var skinPicker: some View {
        Section("Skins") {
            ForEach(skins){
                ownedSkin in
                
                if let skin = ownedSkin.skin {
                    let isSelected = pendingReefKeeperVM.ownedReefKeeperViewModel?.reefKeeper.skin == skin
                    Button(action: {
                        Task {
                            do {
                                print("selecting")
                                try await pendingReefKeeperVM.selectSkin(skin: skin)
                            } catch {
                                print("Failed to select skin: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Text(skin.rawValue)
                            Spacer()
                            Image("Preview" + skin.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .disabled(isSelected)
                }
            }
        }
    }
    
    var hatPicker: some View {
        Section("Hats") {
            ForEach(hats){
                ownedHat in
                if let hat = ownedHat.hat {
                    let isSelected = reefKeeperVM?.reefKeeper.hat == hat
                    Button(action: {
                        Task {
                            do {
                                print("selecting")
                                try await reefKeeperVM?.selectHat(hat: hat)
                            } catch {
                                print("Failed to select skin: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Text(hat.rawValue)
                            Spacer()
                            Image("Preview" + hat.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .disabled(isSelected)
                }
            }
        }
    }
    
    var toolPicker: some View {
        Section("Tools") {
            ForEach(tools){
                ownedTool in
                
                if let tool = ownedTool.tool {
                    let isSelected = reefKeeperVM?.reefKeeper.tool == tool
                    Button(action: {
                        Task {
                            do {
                                print("selecting")
                                try await reefKeeperVM?.selectTool(tool: tool)
                            } catch {
                                print("Failed to select skin: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Text(tool.rawValue)
                            Spacer()
                            Image("Preview" + tool.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .disabled(isSelected)
                }
            }
        }
    }
}

//#Preview {
//    ReefyStyler()
//}
