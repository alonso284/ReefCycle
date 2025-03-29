//
//  ReefyView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefyView: View {
    let reefKeeper: ReefKeeper
    
    private var skin: Skin? {
        reefKeeper.skin
    }
    private var hat: Hat? {
        reefKeeper.hat
    }
    private var tool: Tool? {
        reefKeeper.tool
    }
    
    var body: some View {
        ZStack {
            Image(skin?.rawValue ?? "ReefyBlue")
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500)
            if let hat {
                Image(hat.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
            }
            if let tool {
                Image(tool.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
            }
        }
        
    }
}

//#Preview {
//    ReefyView(skin: .dark, hat: .bandana, tool: .shovel)
//}
