//
//  ReefyView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefyView: View {
    let reefKeeperVM: ReefKeeperViewModel
    
    private var skin: Skin? {
        reefKeeperVM.reefKeeper.skin
    }
    private var hat: Hat? {
        reefKeeperVM.reefKeeper.hat
    }
    private var tool: Tool? {
        reefKeeperVM.reefKeeper.tool
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
