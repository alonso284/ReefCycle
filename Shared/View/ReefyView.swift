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
    var size: CGFloat = 500
    
    var body: some View {
        ZStack {
            Image(skin?.rawValue ?? "ReefyBlue")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
            if let hat {
                Image(hat.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }
            if let tool {
                Image(tool.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    
            }
        }
        
    }
}

//#Preview {
//    ReefyView(skin: .dark, hat: .bandana, tool: .shovel)
//}
