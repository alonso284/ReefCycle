//
//  ReefyView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefyView: View {
    let reefKeeper: ReefKeeper
    
    var skin: Skin {
        reefKeeper.skin ?? .light
    }
    var hat: Hat? {
        reefKeeper.hat
    }
    var tool: Tool? {
        reefKeeper.tool
    }
    
    var body: some View {
        VStack {
            Text(skin.rawValue)
            Text(hat?.rawValue ?? "No Hat")
            Text(tool?.rawValue ?? "No Tool")
        }
    }
}

//#Preview {
//    ReefyView(skin: .dark, hat: .bandana, tool: .shovel)
//}
