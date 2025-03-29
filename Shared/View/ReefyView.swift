//
//  ReefyView.swift
//  ReefCycle
//
//  Created by Alonso Huerta on 28/03/25.
//

import SwiftUI

struct ReefyView: View {
    let skin: Skin?
    let hat: Hat?
    let tool: Tool?
    
    var resolvedSkin: Skin {  skin ?? .light }
    
    var body: some View {
        VStack {
            Text(resolvedSkin.rawValue)
            Text(hat?.rawValue ?? "No Hat")
            Text(tool?.rawValue ?? "No Tool")
        }
        
            
        
    }
}

#Preview {
    ReefyView(skin: .dark, hat: .bandana, tool: .shovel)
}
